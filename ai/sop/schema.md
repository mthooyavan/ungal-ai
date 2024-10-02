# Ungal.ai Database Schema

This document outlines the database schema for the Ungal.ai application.

## Tables

### 1. users

Stores user account information.

| Column Name | Type | Constraints |
|-------------|------|-------------|
| id | UUID | PRIMARY KEY |
| username | VARCHAR(50) | UNIQUE, NOT NULL |
| email | VARCHAR(255) | UNIQUE, NOT NULL |
| password_hash | VARCHAR(255) | NOT NULL |
| token_credits | INTEGER | NOT NULL, DEFAULT 0 |
| is_enabled | BOOLEAN | NOT NULL, DEFAULT TRUE |
| created_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP |

### 2. conversations

Stores information about user conversations.

| Column Name | Type | Constraints |
|-------------|------|-------------|
| id | UUID | PRIMARY KEY |
| user_id | UUID | NOT NULL, FOREIGN KEY REFERENCES users(id) |
| model_id | UUID | NOT NULL, FOREIGN KEY REFERENCES ai_models(id) |
| title | VARCHAR(255) | NOT NULL |
| created_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP |

### 3. messages

Stores individual messages within conversations.

| Column Name | Type | Constraints |
|-------------|------|-------------|
| id | UUID | PRIMARY KEY |
| conversation_id | UUID | NOT NULL, FOREIGN KEY REFERENCES conversations(id) |
| role | VARCHAR(20) | NOT NULL |
| content | TEXT | NOT NULL |
| created_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP |

### 4. ai_models

Stores information about available AI models.

| Column Name | Type | Constraints |
|-------------|------|-------------|
| id | UUID | PRIMARY KEY |
| provider_name | ENUM('OpenAI', 'Anthropic', 'Gemini') | NOT NULL |
| model_name | VARCHAR(100) | NOT NULL |
| description | TEXT | |
| is_active | BOOLEAN | NOT NULL, DEFAULT TRUE |
| UNIQUE (provider_name, model_name) |

## Indexes

- users: CREATE INDEX idx_users_username ON users(username);
- users: CREATE INDEX idx_users_email ON users(email);
- conversations: CREATE INDEX idx_conversations_user_id ON conversations(user_id);
- conversations: CREATE INDEX idx_conversations_model_id ON conversations(model_id);
- messages: CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
- ai_models: CREATE INDEX idx_ai_models_provider_model ON ai_models(provider_name, model_name);

## Notes

- All tables use UUID as primary keys for better distribution and security.
- Timestamps are used to track creation and update times.
- Foreign key constraints ensure referential integrity.
- Indexes are added to improve query performance on frequently accessed columns.
- The `provider_name` in the `ai_models` table is implemented as an ENUM for data integrity.
- A unique constraint is added to `ai_models` to ensure the combination of `provider_name` and `model_name` is unique.
- The `users` table now includes `token_credits` and `is_enabled` fields.
- The `conversations` table now includes the `model_id` directly, replacing the need for a separate `conversation_models` table.