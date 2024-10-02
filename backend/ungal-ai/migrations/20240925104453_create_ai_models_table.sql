-- Up migration
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE provider_name_enum AS ENUM ('OpenAI', 'Anthropic', 'Gemini');

CREATE TABLE ai_models (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_name provider_name_enum NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (provider_name, model_name)
);

CREATE INDEX idx_ai_models_provider_model ON ai_models(provider_name, model_name);

-- Down migration
DROP TABLE ai_models;
DROP TYPE provider_name_enum;
DROP EXTENSION IF EXISTS "uuid-ossp";
