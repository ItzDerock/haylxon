####
# Build haylxon
####
FROM rust:1.77-slim-bullseye as builder
WORKDIR /usr/src/

# RUN rustup target add x86_64-unknown-linux-musl

COPY Cargo.toml Cargo.lock ./
COPY src ./src 

RUN cargo build --release
RUN strip target/release/hxn


####
#Begin final image
####
#copy rust build
FROM debian:bullseye-slim as release
WORKDIR /app
COPY --from=builder /usr/src/target/release/hxn .
# install chrome
RUN apt update
RUN apt -y install chromium

# Webgl
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
  xorg xserver-xorg xvfb libx11-dev libxext-dev

RUN ln -s /usr/bin/chromium /usr/bin/chrome
RUN mkdir /app/hxnshots

USER 1000
ENTRYPOINT ["xvfb-run", "/app/hxn"]
