# Use the official Rust image as the base image
FROM rust:1.76-slim-buster as builder

# Install required dependencies
RUN apt-get update && apt-get install -y libpq-dev

# Set the working directory in the container
WORKDIR /usr/src/ungal-ai

# Copy the Cargo.toml and Cargo.lock files
COPY Cargo.toml Cargo.lock ./

# Copy the actual source code
COPY src ./src

# Install sqlx-cli
RUN cargo install sqlx-cli --no-default-features --features postgres

# Build the application
RUN cargo build --release

# Create a new stage with a minimal image for the final container
FROM debian:buster-slim

# Install required runtime dependencies
RUN apt-get update && apt-get install -y libpq5 && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /usr/local/bin

# Copy the built executable from the builder stage
COPY --from=builder /usr/src/ungal-ai/target/release/ungal-ai .
COPY --from=builder /usr/local/cargo/bin/sqlx /usr/local/bin/sqlx

# Copy migrations folder
COPY migrations ./migrations

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["./ungal-ai"]