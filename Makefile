# Makefile for Ungal.ai backend

# Variables
DOCKER_COMPOSE = docker compose

# Default target
.PHONY: all
all: build

# Start the application
.PHONY: start
start:
	$(DOCKER_COMPOSE) up

# Stop and remove containers
.PHONY: down
down:
	$(DOCKER_COMPOSE) down

# Remove all build artifacts and docker volumes
.PHONY: clean
clean: down
	$(DOCKER_COMPOSE) down -v
	rm -rf backend/ungal-ai/target

# Build the application
.PHONY: build
build:
	$(DOCKER_COMPOSE) build

# Run database migrations
.PHONY: migrate
migrate:
	$(DOCKER_COMPOSE) run --rm backend sqlx migrate run

# Run tests
.PHONY: test
test:
	cd backend/ungal-ai && cargo test

# Format code
.PHONY: fmt
fmt:
	cd backend/ungal-ai && cargo fmt

# Check code formatting
.PHONY: fmt-check
fmt-check:
	cd backend/ungal-ai && cargo fmt -- --check

# Run linter
.PHONY: lint
lint:
	cd backend/ungal-ai && cargo clippy -- -D warnings

# Check migration status
.PHONY: migration-status
migration-status:
	$(DOCKER_COMPOSE) run --rm backend sqlx migrate info

# Revert all migrations
.PHONY: migrate-revert-all
migrate-revert-all:
	$(DOCKER_COMPOSE) run --rm backend sqlx migrate revert --all

# Drop the database
.PHONY: drop-db
drop-db:
	$(DOCKER_COMPOSE) run --rm backend sqlx database drop -y

# Create the database
.PHONY: create-db
create-db:
	$(DOCKER_COMPOSE) run --rm backend sqlx database create

# Reset migration table
.PHONY: reset-migration-table
reset-migration-table:
	$(DOCKER_COMPOSE) run --rm backend psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) -c "DROP TABLE IF EXISTS _sqlx_migrations;"

# Help command
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make start      - Start the application"
	@echo "  make down       - Stop and remove containers"
	@echo "  make clean      - Remove all build artifacts and docker volumes"
	@echo "  make build      - Build the application"
	@echo "  make migrate    - Run database migrations"
	@echo "  make test       - Run tests"
	@echo "  make fmt        - Format code"
	@echo "  make fmt-check  - Check code formatting"
	@echo "  make lint       - Run linter"
	@echo "  make help       - Show this help message"
