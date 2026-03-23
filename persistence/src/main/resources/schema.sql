-- ============================================================
-- BIOHACK PROTOCOLS PLATFORM — Database Schema (PostgreSQL)
-- ============================================================
-- Convenciones:
--   • snake_case en todo
--   • UUID como PK (mejor para APIs públicas, evita enumeration)
--   • created_at / updated_at en todas las tablas
--   • Soft delete (deleted_at) donde tenga sentido
--   • JSONB para metadata extensible sin romper el schema
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- 0. EXTENSIONES
-- ────────────────────────────────────────────────────────────

CREATE EXTENSION IF NOT EXISTS "pgcrypto";


-- ════════════════════════════════════════════════════════════
-- 1. USUARIOS, PERFILES Y RED SOCIAL
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           TEXT UNIQUE NOT NULL,
    password_hash   TEXT NOT NULL,
    display_name    TEXT NOT NULL,
    username        TEXT UNIQUE NOT NULL,            -- handle único para @menciones y URLs
    avatar_url      TEXT,
    bio             TEXT,                            -- biografía corta
    role            TEXT NOT NULL DEFAULT 'explorer'
                        CHECK (role IN ('explorer', 'creator', 'admin')),
    is_verified     BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_profiles (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    birth_year          INT,
    biological_sex      TEXT CHECK (biological_sex IN ('male', 'female', 'intersex', 'prefer_not_to_say')),
    activity_level      TEXT CHECK (activity_level IN ('sedentary', 'light', 'moderate', 'active', 'very_active')),
    height_cm           NUMERIC(5,1),
    weight_kg           NUMERIC(5,1),
    conditions          TEXT[] DEFAULT '{}',
    metadata            JSONB DEFAULT '{}',
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 1c. Sistema de seguidos / seguidores
CREATE TABLE IF NOT EXISTS user_follows (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    follower_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(follower_id, following_id),
    CHECK(follower_id != following_id)
);

CREATE INDEX IF NOT EXISTS idx_follows_follower  ON user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_following ON user_follows(following_id);


-- ════════════════════════════════════════════════════════════
-- 2. COMUNIDADES (estilo subreddit)
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS communities (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    slug            TEXT UNIQUE NOT NULL,            -- URL-safe: 'sleep-optimization'
    name            TEXT NOT NULL,
    description     TEXT,
    rules           TEXT,                            -- markdown
    avatar_url      TEXT,
    banner_url      TEXT,
    is_public       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS community_members (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    community_id    UUID NOT NULL REFERENCES communities(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role            TEXT NOT NULL DEFAULT 'member'
                        CHECK (role IN ('member', 'moderator', 'admin')),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(community_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_community_members_community ON community_members(community_id);
CREATE INDEX IF NOT EXISTS idx_community_members_user      ON community_members(user_id);

-- Posts de la comunidad (discusión general)
CREATE TABLE IF NOT EXISTS community_posts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    community_id    UUID NOT NULL REFERENCES communities(id) ON DELETE CASCADE,
    author_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    body            TEXT NOT NULL,
    is_pinned       BOOLEAN NOT NULL DEFAULT FALSE,
    upvote_count    INT NOT NULL DEFAULT 0,
    comment_count   INT NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at      TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_community_posts_community ON community_posts(community_id) WHERE deleted_at IS NULL;

-- Votos en posts
CREATE TABLE IF NOT EXISTS community_post_votes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id         UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vote            SMALLINT NOT NULL CHECK (vote IN (-1, 1)),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(post_id, user_id)
);

-- Comentarios en posts (threaded)
CREATE TABLE IF NOT EXISTS community_post_comments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id         UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
    author_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id       UUID REFERENCES community_post_comments(id) ON DELETE CASCADE,
    body            TEXT NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at      TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_post_comments_post   ON community_post_comments(post_id) WHERE deleted_at IS NULL;


-- ════════════════════════════════════════════════════════════
-- 3. CATÁLOGOS NORMALIZADOS
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS goal_categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT UNIQUE NOT NULL,
    label       TEXT NOT NULL,
    icon        TEXT,
    sort_order  INT NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS goals (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id     UUID NOT NULL REFERENCES goal_categories(id),
    name            TEXT UNIQUE NOT NULL,
    label           TEXT NOT NULL,
    description     TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS intervention_categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT UNIQUE NOT NULL,
    label       TEXT NOT NULL,
    icon        TEXT,
    sort_order  INT NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS interventions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id     UUID NOT NULL REFERENCES intervention_categories(id),
    name            TEXT UNIQUE NOT NULL,
    label           TEXT NOT NULL,
    description     TEXT,
    default_unit    TEXT,
    metadata        JSONB DEFAULT '{}',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS metric_categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT UNIQUE NOT NULL,
    label       TEXT NOT NULL,
    sort_order  INT NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS metrics (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id     UUID NOT NULL REFERENCES metric_categories(id),
    name            TEXT UNIQUE NOT NULL,
    label           TEXT NOT NULL,
    unit            TEXT NOT NULL,
    value_type      TEXT NOT NULL DEFAULT 'numeric'
                        CHECK (value_type IN ('numeric', 'scale', 'boolean', 'text')),
    scale_min       NUMERIC,
    scale_max       NUMERIC,
    higher_is_better BOOLEAN,
    metadata        JSONB DEFAULT '{}',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ════════════════════════════════════════════════════════════
-- 4. PROTOCOLOS
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS protocols (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    goal_id         UUID NOT NULL REFERENCES goals(id),
    community_id    UUID REFERENCES communities(id) ON DELETE SET NULL,

    title           TEXT NOT NULL,
    description     TEXT,
    duration_days   INT,

    is_template     BOOLEAN NOT NULL DEFAULT FALSE,

    status          TEXT NOT NULL DEFAULT 'draft'
                        CHECK (status IN ('draft', 'recruiting', 'active', 'completed')),
    visibility      TEXT NOT NULL DEFAULT 'private'
                        CHECK (visibility IN ('private', 'public', 'unlisted')),

    -- Cohort
    min_participants INT,
    max_participants INT,

    -- Timestamps del ciclo de vida
    recruiting_at   TIMESTAMPTZ,
    started_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,

    tags            TEXT[] DEFAULT '{}',
    search_vector   TSVECTOR,

    metadata        JSONB DEFAULT '{}',
    fork_count      INT NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at      TIMESTAMPTZ,

    forked_from     UUID REFERENCES protocols(id)
);

CREATE INDEX IF NOT EXISTS idx_protocols_creator     ON protocols(creator_id)   WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_protocols_goal        ON protocols(goal_id)      WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_protocols_community   ON protocols(community_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_protocols_status      ON protocols(status)       WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_protocols_visibility  ON protocols(visibility)   WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_protocols_tags        ON protocols USING GIN(tags)          WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_protocols_search      ON protocols USING GIN(search_vector) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_protocols_templates   ON protocols(goal_id, fork_count DESC)
    WHERE deleted_at IS NULL AND is_template = TRUE AND visibility = 'public';


-- 4a. Intervenciones dentro de un protocolo
CREATE TABLE IF NOT EXISTS protocol_interventions (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    protocol_id         UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    intervention_id     UUID NOT NULL REFERENCES interventions(id),
    dosage              NUMERIC,
    dosage_unit         TEXT,
    frequency           TEXT NOT NULL,
    timing              TEXT,
    instructions        TEXT,
    sort_order          INT NOT NULL DEFAULT 0,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(protocol_id, intervention_id)
);

-- 4b. Métricas que se trackean en un protocolo
CREATE TABLE IF NOT EXISTS protocol_metrics (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    protocol_id     UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    metric_id       UUID NOT NULL REFERENCES metrics(id),
    target_value    NUMERIC,
    log_frequency   TEXT NOT NULL DEFAULT 'daily',
    sort_order      INT NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(protocol_id, metric_id)
);


-- ════════════════════════════════════════════════════════════
-- 5. INSCRIPCIONES (ENROLLMENTS)
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS protocol_enrollments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    protocol_id     UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    status          TEXT NOT NULL DEFAULT 'enrolled'
                        CHECK (status IN ('enrolled', 'active', 'paused', 'completed', 'abandoned')),
    enrollment_type TEXT NOT NULL DEFAULT 'cohort'
                        CHECK (enrollment_type IN ('cohort', 'async')),
    is_public       BOOLEAN NOT NULL DEFAULT TRUE,

    started_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(protocol_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_enrollments_protocol ON protocol_enrollments(protocol_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_user     ON protocol_enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_public   ON protocol_enrollments(protocol_id) WHERE is_public = TRUE;


-- ════════════════════════════════════════════════════════════
-- 6. LOGGING Y DATOS
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS log_entries (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    protocol_id     UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users(id),
    enrollment_id   UUID REFERENCES protocol_enrollments(id) ON DELETE CASCADE,

    log_date        DATE NOT NULL,
    day_number      INT NOT NULL,

    adherence_pct   NUMERIC(5,2),
    notes           TEXT,
    mood            TEXT CHECK (mood IN ('terrible','bad','neutral','good','great')),

    metadata        JSONB DEFAULT '{}',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(protocol_id, user_id, log_date)
);

CREATE INDEX IF NOT EXISTS idx_log_entries_user       ON log_entries(user_id);
CREATE INDEX IF NOT EXISTS idx_log_entries_date       ON log_entries(log_date);
CREATE INDEX IF NOT EXISTS idx_log_entries_protocol   ON log_entries(protocol_id);
CREATE INDEX IF NOT EXISTS idx_log_entries_day_number ON log_entries(protocol_id, day_number);

CREATE TABLE IF NOT EXISTS metric_values (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    log_entry_id    UUID NOT NULL REFERENCES log_entries(id) ON DELETE CASCADE,
    metric_id       UUID NOT NULL REFERENCES metrics(id),
    numeric_value   NUMERIC,
    text_value      TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(log_entry_id, metric_id)
);

CREATE INDEX IF NOT EXISTS idx_metric_values_metric ON metric_values(metric_id);


-- ════════════════════════════════════════════════════════════
-- 7. SOCIAL: COMENTARIOS, REVIEWS, FAVORITOS, REPORTES
-- ════════════════════════════════════════════════════════════

-- 7a. Comentarios en protocolos (threaded)
CREATE TABLE IF NOT EXISTS protocol_comments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    protocol_id     UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    author_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id       UUID REFERENCES protocol_comments(id) ON DELETE CASCADE,
    body            TEXT NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at      TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_protocol_comments_protocol ON protocol_comments(protocol_id) WHERE deleted_at IS NULL;

-- 7b. Reviews (rating 0-5 + texto)
CREATE TABLE IF NOT EXISTS protocol_reviews (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    protocol_id     UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating          SMALLINT NOT NULL CHECK (rating BETWEEN 0 AND 5),
    title           TEXT,
    body            TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(user_id, protocol_id)
);

CREATE INDEX IF NOT EXISTS idx_protocol_reviews_protocol ON protocol_reviews(protocol_id);

-- 7c. Favoritos
CREATE TABLE IF NOT EXISTS protocol_favorites (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    protocol_id     UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(user_id, protocol_id)
);

-- 7d. Reportes / flags (polimórfico)
CREATE TABLE IF NOT EXISTS reports (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_type     TEXT NOT NULL
                        CHECK (target_type IN ('protocol', 'comment', 'review', 'post', 'user')),
    target_id       UUID NOT NULL,
    reason          TEXT NOT NULL,
    details         TEXT,
    status          TEXT NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
    resolved_by     UUID REFERENCES users(id),
    resolved_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_reports_status ON reports(status) WHERE status = 'pending';


-- ════════════════════════════════════════════════════════════
-- 8. NOTIFICACIONES
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS notifications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    actor_id        UUID REFERENCES users(id) ON DELETE SET NULL,
    type            TEXT NOT NULL,
    target_type     TEXT,
    target_id       UUID,
    title           TEXT NOT NULL,
    body            TEXT,
    is_read         BOOLEAN NOT NULL DEFAULT FALSE,
    read_at         TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_user   ON notifications(user_id, is_read, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id) WHERE is_read = FALSE;


-- ════════════════════════════════════════════════════════════
-- 9. ACTIVITY FEED
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS activity_events (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    verb            TEXT NOT NULL,
    target_type     TEXT NOT NULL,
    target_id       UUID NOT NULL,

    community_id    UUID REFERENCES communities(id) ON DELETE SET NULL,

    snapshot        JSONB DEFAULT '{}',

    is_public       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_activity_actor     ON activity_events(actor_id, created_at DESC)
    WHERE is_public = TRUE;
CREATE INDEX IF NOT EXISTS idx_activity_community ON activity_events(community_id, created_at DESC)
    WHERE is_public = TRUE AND community_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_activity_global    ON activity_events(created_at DESC)
    WHERE is_public = TRUE;


-- ════════════════════════════════════════════════════════════
-- 10. ACHIEVEMENTS Y STREAKS
-- ════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS achievements (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            TEXT UNIQUE NOT NULL,
    name            TEXT NOT NULL,
    description     TEXT NOT NULL,
    icon            TEXT,
    category        TEXT NOT NULL DEFAULT 'general'
                        CHECK (category IN ('general', 'streak', 'social', 'explorer', 'creator')),
    criteria        JSONB NOT NULL DEFAULT '{}',
    points          INT NOT NULL DEFAULT 0,
    sort_order      INT NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_achievements (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_id  UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
    protocol_id     UUID REFERENCES protocols(id) ON DELETE SET NULL,
    unlocked_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(user_id, achievement_id)
);

CREATE INDEX IF NOT EXISTS idx_user_achievements_user ON user_achievements(user_id);

CREATE TABLE IF NOT EXISTS user_streaks (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    protocol_id         UUID NOT NULL REFERENCES protocols(id) ON DELETE CASCADE,

    current_streak      INT NOT NULL DEFAULT 1,
    longest_streak      INT NOT NULL DEFAULT 1,
    last_log_date       DATE NOT NULL,

    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(user_id, protocol_id)
);

CREATE INDEX IF NOT EXISTS idx_user_streaks_user ON user_streaks(user_id);


