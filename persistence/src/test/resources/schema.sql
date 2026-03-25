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
