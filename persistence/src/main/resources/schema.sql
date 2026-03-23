CREATE TABLE IF NOT EXISTS users (
    user_id         SERIAL PRIMARY KEY,
    username        VARCHAR(100) UNIQUE NOT NULL,
    email           VARCHAR(255) UNIQUE NOT NULL,
    password        VARCHAR(255) NOT NULL DEFAULT '',
    bio             TEXT,
    avatar_url      VARCHAR(512),
    created_at      TIMESTAMP DEFAULT NOW()
);
