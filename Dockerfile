FROM rust:1.72.0

WORKDIR /app
RUN apt update && apt install lld clang -y

COPY . .
RUN vargo build --release

ENTRYPOINT [ "./target/release/zerp2prod" ]