FROM rust:1.79.0 AS builder

WORKDIR /app
RUN apt update && apt install lld clang -y
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release  

# FROM rust:1.79.0-slim AS runtime
# WORKDIR /app
# # Copy over the compuled binary from the builder environment to the runtime
# COPY --from=builder /app/target/release/zero2prod zero2prod
# COPY configuration configuration
# ENV APP_ENVIRONMENT production

FROM debian:bookworm-slim AS runtime
WORKDIR /app
# Install OpenSSL - dynamically linked by some dependencies
# Install ca-certificates - needed to verify TLS certs when using HTTPS
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/zero2prod zero2prod
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT [ "./zero2prod" ]