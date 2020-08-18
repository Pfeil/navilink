FROM centos:centos7

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >> rustup.init.sh
RUN bash rustup.init.sh -y --profile minimal
RUN $HOME/.cargo/bin/rustup default nightly
RUN yum install -y git gcc
RUN git clone https://github.com/Pfeil/navilink.git \
    && cd navilink

ENTRYPOINT cd navilink && $HOME/.cargo/bin/cargo +nightly build --release
