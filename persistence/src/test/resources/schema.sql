-- HSQLDB-compatible test schema (subset of production PostgreSQL schema)

CREATE TABLE goal_categories (
    id          UUID PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    label       VARCHAR(200) NOT NULL,
    icon        VARCHAR(100),
    sort_order  INT DEFAULT 0 NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE goals (
    id              UUID PRIMARY KEY,
    category_id     UUID NOT NULL,
    name            VARCHAR(200) NOT NULL UNIQUE,
    label           VARCHAR(200) NOT NULL,
    description     VARCHAR(1000),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (category_id) REFERENCES goal_categories(id)
);

CREATE TABLE intervention_categories (
    id          UUID PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    label       VARCHAR(200) NOT NULL,
    icon        VARCHAR(100),
    sort_order  INT DEFAULT 0 NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE interventions (
    id              UUID PRIMARY KEY,
    category_id     UUID NOT NULL,
    name            VARCHAR(200) NOT NULL UNIQUE,
    label           VARCHAR(200) NOT NULL,
    description     VARCHAR(1000),
    default_unit    VARCHAR(50),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (category_id) REFERENCES intervention_categories(id)
);

CREATE TABLE users (
    id              UUID PRIMARY KEY,
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    display_name    VARCHAR(200) NOT NULL,
    username        VARCHAR(100) UNIQUE NOT NULL,
    avatar_url      VARCHAR(512),
    bio             VARCHAR(1000),
    role            VARCHAR(50) DEFAULT 'explorer' NOT NULL,
    is_verified     BOOLEAN DEFAULT FALSE NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE protocols (
    id              UUID PRIMARY KEY,
    creator_id      UUID NOT NULL REFERENCES users(id),
    goal_id         UUID NOT NULL REFERENCES goals(id),
    community_id    UUID,
    title           VARCHAR(255) NOT NULL,
    description     VARCHAR(2000),
    duration_days   INT,
    is_template     BOOLEAN DEFAULT FALSE NOT NULL,
    status          VARCHAR(50) DEFAULT 'draft' NOT NULL,
    visibility      VARCHAR(50) DEFAULT 'private' NOT NULL,
    min_participants INT,
    max_participants INT,
    fork_count      INT DEFAULT 0 NOT NULL,
    forked_from     UUID,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at      TIMESTAMP
);

CREATE TABLE protocol_interventions (
    id              UUID PRIMARY KEY,
    protocol_id     UUID NOT NULL REFERENCES protocols(id),
    intervention_id UUID NOT NULL REFERENCES interventions(id),
    dosage          NUMERIC,
    dosage_unit     VARCHAR(50),
    frequency       VARCHAR(100) NOT NULL,
    timing          VARCHAR(100),
    instructions    VARCHAR(1000),
    sort_order      INT DEFAULT 0 NOT NULL,
    is_active       BOOLEAN DEFAULT TRUE NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(protocol_id, intervention_id)
);

CREATE TABLE protocol_enrollments (
    id              UUID PRIMARY KEY,
    protocol_id     UUID NOT NULL REFERENCES protocols(id),
    user_id         UUID NOT NULL REFERENCES users(id),
    status          VARCHAR(50) DEFAULT 'enrolled' NOT NULL,
    enrollment_type VARCHAR(50) DEFAULT 'cohort' NOT NULL,
    is_public       BOOLEAN DEFAULT TRUE NOT NULL,
    started_at      TIMESTAMP,
    completed_at    TIMESTAMP,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(protocol_id, user_id)
);

CREATE TABLE protocol_favorites (
    id              UUID PRIMARY KEY,
    user_id         UUID NOT NULL REFERENCES users(id),
    protocol_id     UUID NOT NULL REFERENCES protocols(id),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(user_id, protocol_id)
);

CREATE TABLE protocol_reviews (
    id              UUID PRIMARY KEY,
    protocol_id     UUID NOT NULL REFERENCES protocols(id),
    user_id         UUID NOT NULL REFERENCES users(id),
    rating          SMALLINT NOT NULL,
    title           VARCHAR(255),
    body            VARCHAR(2000),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(user_id, protocol_id)
);

CREATE TABLE metric_categories (
    id          UUID PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    label       VARCHAR(200) NOT NULL,
    sort_order  INT DEFAULT 0 NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE metrics (
    id              UUID PRIMARY KEY,
    category_id     UUID NOT NULL,
    name            VARCHAR(200) NOT NULL UNIQUE,
    label           VARCHAR(200) NOT NULL,
    unit            VARCHAR(50) NOT NULL,
    value_type      VARCHAR(20) DEFAULT 'numeric' NOT NULL,
    scale_min       NUMERIC,
    scale_max       NUMERIC,
    higher_is_better BOOLEAN,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (category_id) REFERENCES metric_categories(id)
);
