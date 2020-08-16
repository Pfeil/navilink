# Navi & Link

Navi is a server that stores strings associated with an identifier and a string. Use case is for example storing your hostname in this server so you can access it later for ssh usage, in case you do not have a static hostname or IP.

## Navi (the server)

Navi is a server application. It does store the information in memory only. This means restarting the server will remove all data. Note that Navi is based on rocket.rs, which still requires nightly rust.

Build the server using `cargo build --release`, run it via `cargo run --release`.

## Link (a helper script)

Link.sh is a bash script. use `bash link.sh push` to insert or update your information record on the server. use `bash link.sh pull` to receive the string you stored in the server.

> PLEASE MAKE SURE YOU CUSTOMIZE AT LEAST THE IDENTIFIER AND THE PASSPHRASE WITHIN THE SCRIPT!

You can i.e. use a cron job to regulary call `bash link.sh push` to update the record.
