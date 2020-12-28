#![feature(proc_macro_hygiene, decl_macro)]
use ::std::collections::HashMap;
use ::std::sync::Mutex;
use rocket::http::Status;
use rocket::response::{content::Plain, status};
use rocket::{Request, State};
use rocket_contrib::json::Json;
use serde::{Deserialize, Serialize};

#[macro_use]
extern crate rocket;

#[derive(Serialize, Deserialize, Clone)]
struct Record {
    passphrase: String,
    item: String,
}

#[derive(Default)]
struct Memory {
    ids: HashMap<String, Record>,
}

type Answer = Result<status::Accepted<&'static str>, Status>;

#[put("/<id>", data = "<record>")]
fn push(id: String, record: Json<Record>, state: State<Mutex<Memory>>) -> Answer {
    let mut guard = state.lock().unwrap();
    if record.item.len() > 100 {
        return Err(Status::Unauthorized);
    }
    if let Some(stored_record) = guard.ids.get(&id) {
        if stored_record.passphrase == record.passphrase {
            guard.ids.insert(id, record.into_inner());
            Ok(status::Accepted(Some("Record was updated.")))
        } else {
            // wrong passphrase
            Err(Status::Unauthorized)
        }
    } else {
        // record not available -> insert
        guard.ids.insert(id, record.into_inner());
        Ok(status::Accepted(Some("Record was created.")))
    }
}

#[post("/<id>", data = "<passphrase>")]
fn pull(
    id: String,
    passphrase: Json<String>,
    state: State<Mutex<Memory>>,
) -> Result<Plain<String>, Status> {
    let guard = state.lock().unwrap();
    if let Some(stored_record) = guard.ids.get(&id) {
        if passphrase.into_inner() == stored_record.passphrase {
            Ok(Plain(stored_record.item.to_string()))
        } else {
            Err(Status::Unauthorized)
        }
    } else {
        Err(Status::NoContent)
    }
}

#[catch(400)]
fn bad_request_400(req: &Request) -> String {
    format!("HTTP 400: {:?}", req)
}

#[catch(404)]
fn bad_request_404(req: &Request) -> String {
    format!("HTTP 404: {:?}", req)
}

fn main() {
    rocket::ignite()
        .manage(Mutex::new(Memory::default()))
        .mount("/v1", routes![push, pull])
        .register(catchers![bad_request_400, bad_request_404])
        .launch();
}
