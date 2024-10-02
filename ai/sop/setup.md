# Backend Setup for Ungal.ai using Docker

This document provides a step-by-step guide to set up the backend environment and build the API endpoints for **ungal.ai** using Docker and Docker Compose.

---

## Prerequisites

- [x] **Install Docker and Docker Compose**
    - **Install Docker:**
        - **Windows and macOS:**
            - Download and install Docker Desktop from [Docker's official website](https://www.docker.com/products/docker-desktop).
        - **Linux:**
            - Follow the installation instructions for your distribution from the [Docker documentation](https://docs.docker.com/engine/install/).
    - **Verify Docker Installation:**
        ```bash
        docker --version
        ```
    - **Install Docker Compose if not included:**
        - **Linux Users:**
            - Install Docker Compose separately by following the [official instructions](https://docs.docker.com/compose/install/).
        - **Verify Docker Compose Installation:**
            ```bash
            docker-compose --version
            ```

---

## Setting Up the Backend Environment with Docker

- [x] **Create Project Directory Structure**
    - Open a terminal and navigate to your desired projects directory.
    - Create a directory for the backend project:
        ```bash
        mkdir -p backend/ungal-ai
        ```
    - Navigate to the project directory:
        ```bash
        cd backend/ungal-ai
        ```

- [x] **Initialize a New Rust Project**
    - Initialize the Rust application:
        ```bash
        cargo new . --bin
        ```
    - This creates a new Rust binary application in the current directory.

- [x] **Set Up the Dockerfile**
    - Create a `Dockerfile` in the `backend/ungal-ai` directory.
    - Define the necessary steps to containerize the Rust application.

- [x] **Configure Docker Compose**
    - Navigate to the root directory of your project (where `backend` is located).
    - Create a `docker-compose.yml` file.
    - Define the services:
        - **Backend Service:**
            - Build the Docker image using the `Dockerfile`.
            - Map the application's port to the host (e.g., `8000:8000`).
            - Set environment variables for the application.
            - Specify dependencies (e.g., depends on the database service).
        - **Database Service:**
            - Use the official PostgreSQL image.
            - Set environment variables for `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`.
            - Expose port `5432` to the host.
            - Configure volumes for data persistence.

- [x] **Create an Environment Variables File**
    - In the root directory, create a `.env` file.
    - Add the necessary environment variables:
        ```
        POSTGRES_USER=ungal_user
        POSTGRES_PASSWORD=your_secure_password_here
        POSTGRES_DB=ungal_ai_db
        DATABASE_URL=postgres://ungal_user:your_secure_password_here@db:5432/ungal_ai_db
        ```
    - **Note:** Replace `your_secure_password_here` with a secure password.
    - Ensure the `.env` file is added to `.gitignore` to prevent it from being committed to version control.

- [x] **Modify Application Configuration**
    - Update the application to read configuration from environment variables.
    - Ensure database connection strings and secret keys are not hard-coded.

- [x] **Add Dependencies to `Cargo.toml`**
    - Update `Cargo.toml` with the required dependencies:
        - `axum`, `tokio`, `sqlx`, `dotenvy`, etc.

---

## Building and Running Services

- [x] **Build Docker Images**
    - From the root directory, run:
        ```bash
        docker-compose build
        ```
    - This command builds the images for all services defined in `docker-compose.yml`.

- [x] **Start the Services**
    - Run the following command to start the containers:
        ```bash
        docker-compose up
        ```
    - To run in detached mode (in the background), add the `-d` flag:
        ```bash
        docker-compose up -d
        ```

- [x] **Verify Services are Running**
    - List running containers:
        ```bash
        docker ps
        ```
    - Check logs for any errors:
        ```bash
        docker-compose logs
        ```
    - Access the backend API at `http://localhost:8000`.

---

## Managing Database Migrations

- [x] **Set Up Database Migrations**
    - Use `sqlx` for managing database migrations.
    - Create a `migrations` directory in the `backend/ungal-ai` project:
        ```bash
        cd backend/ungal-ai
        mkdir migrations
        ```

- [x] **Create Migration Scripts**
    - Generate new migration files using `sqlx`:
        ```bash
        sqlx migrate add create_users_table
        sqlx migrate add create_ai_models_table
        sqlx migrate add create_conversations_table
        sqlx migrate add create_messages_table
        ```
    - Add SQL statements to define the database schema based on `schema.md`.

- [x] **Implement Migrations**
    - Open each migration file in the `migrations` directory.
    - Add the SQL statements to create the tables and indexes as defined in `schema.md`.
    - Ensure that the `down.sql` files contain the correct statements to revert the migrations.

- [ ] **Run Migrations Using Makefile**
    - From the root directory, run:
        ```bash
        make migrate
        ```
    - This command will run the migrations inside the Docker container.

- [x] **Update Application Code**
    - Modify the Rust application code to use the new database schema.
    - Update any existing database queries or models to reflect the new structure.

---

## Implementing API Endpoints

- [ ] **Add Dependencies to `Cargo.toml`**
    - Update `Cargo.toml` with the required dependencies:
        - `axum`, `tokio`, `sqlx`, `jsonwebtoken`, `serde`, etc.

- [ ] **Implement Authentication Endpoints**
    - **Register (`/register`):**
        - Create an endpoint to handle user registration.
    - **Login (`/login`):**
        - Create an endpoint to authenticate users and issue JWTs.

- [ ] **Implement Conversation Management Endpoints**
    - **Create Conversation (`/conversations`):**
        - Handle creation of new conversations.
    - **Get Conversations (`/conversations`):**
        - Retrieve a list of user's conversations.
    - **Post Messages (`/conversations/{id}/messages`):**
        - Add messages to a conversation.
    - **Get Messages (`/conversations/{id}/messages`):**
        - Retrieve messages from a conversation.

- [ ] **Implement AI Model Integration**
    - **List Models (`/models`):**
        - Provide a list of available AI models.
    - **Switch Model (`/models/switch`):**
        - Allow switching the AI model during a conversation.

- [ ] **Ensure Asynchronous Operations**
    - Use async/await for all I/O-bound operations.
    - Ensure database queries and external API calls are non-blocking.

---

## Testing and Validation

- [ ] **Test API Endpoints**
    - Use Postman or curl to test each endpoint.
    - Verify proper authentication and authorization.
    - Test edge cases and error handling.

- [ ] **Monitor Logs and Debug**
    - Use `docker-compose logs` to monitor application logs.
    - Address any errors or warnings.

- [ ] **Run Automated Tests**
    - Write unit and integration tests.
    - Run tests inside the Docker environment if necessary.

---

## Additional Considerations

- [ ] **Update Documentation**
    - Document API endpoints and usage.
    - Update the `README.md` with setup and usage instructions.

- [ ] **Version Control**
    - Commit changes to the repository.
    - Ensure `.gitignore` includes unnecessary or sensitive files:
        - Updated with Rust-specific ignores from GitHub's Rust.gitignore template.
        - Added IDE-specific and OS-specific ignores.
        - Kept `.env` in the ignore list to prevent committing sensitive information.

- [ ] **Prepare for Deployment**
    - Optimize Docker images (e.g., multi-stage builds).
    - Review security settings and environment configurations.

- [ ] **Continuous Integration and Deployment (CI/CD)**
    - Set up a CI/CD pipeline to automate testing and deployment processes.

---

*Note:* This setup guide provides a bullet point checklist with commands and step-by-step processes needed to set up the backend using Docker and Docker Compose, without including code examples.

---

## Managing Database Migrations

- [ ] **Handle Migration Conflicts**
    - If encountering migration conflicts, follow these steps:
        1. Check the current migration status:
            ```bash
            make migration-status
            ```
        2. If some migrations are applied and others are not, create a new empty migration:
            ```bash
            sqlx migrate add fix_migration_conflicts
            ```
        3. Run the migrations again:
            ```bash
            make migrate
            ```
    - If problems persist, consider reverting all migrations and reapplying:
        ```bash
        make migrate-revert-all
        make migrate
        ```

---
