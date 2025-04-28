# --- Build Stage ---
FROM rust:1.74 as builder


RUN apt-get update && apt-get install -y pkg-config libssl-dev

WORKDIR /app

COPY . .

RUN cargo build --release

# --- Runtime Stage ---
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app


COPY --from=builder /app/target/release/nexus-network /usr/local/bin/nexus-network


ENTRYPOINT ["nexus-network"]
CMD ["start", "--env", "beta"]
