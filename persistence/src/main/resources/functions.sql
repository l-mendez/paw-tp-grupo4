-- ============================================================
-- BIOHACK PROTOCOLS PLATFORM — Functions & Triggers
-- ============================================================
-- Separator: ;; (needed because Spring's ResourceDatabasePopulator
-- can't handle $$ dollar-quoting with the default ; separator)
-- ============================================================


-- 1. Auto-calcular day_number
CREATE OR REPLACE FUNCTION calc_day_number() RETURNS trigger AS $$
DECLARE
    v_started_at DATE;
BEGIN
    IF NEW.enrollment_id IS NOT NULL THEN
        SELECT started_at::date INTO v_started_at
        FROM protocol_enrollments WHERE id = NEW.enrollment_id;
    ELSE
        SELECT started_at::date INTO v_started_at
        FROM protocols WHERE id = NEW.protocol_id;
    END IF;
    IF v_started_at IS NOT NULL THEN
        NEW.day_number := (NEW.log_date - v_started_at) + 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;;

DROP TRIGGER IF EXISTS trig_log_entries_day_number ON log_entries;;
CREATE TRIGGER trig_log_entries_day_number
    BEFORE INSERT OR UPDATE OF log_date ON log_entries
    FOR EACH ROW EXECUTE FUNCTION calc_day_number();;


-- 2. Full-text search en protocolos
CREATE OR REPLACE FUNCTION protocols_search_trigger() RETURNS trigger AS $$
BEGIN
    NEW.search_vector :=
        setweight(to_tsvector('spanish', COALESCE(NEW.title, '')), 'A') ||
        setweight(to_tsvector('spanish', COALESCE(NEW.description, '')), 'B') ||
        setweight(to_tsvector('spanish', COALESCE(array_to_string(NEW.tags, ' '), '')), 'C');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;;

DROP TRIGGER IF EXISTS trig_protocols_search ON protocols;;
CREATE TRIGGER trig_protocols_search
    BEFORE INSERT OR UPDATE OF title, description, tags ON protocols
    FOR EACH ROW EXECUTE FUNCTION protocols_search_trigger();;


-- 3. Auto-transition recruiting -> active al alcanzar min_participants
CREATE OR REPLACE FUNCTION check_cohort_threshold() RETURNS trigger AS $$
DECLARE
    v_min    INT;
    v_status TEXT;
    v_count  INT;
BEGIN
    SELECT min_participants, status INTO v_min, v_status
    FROM protocols WHERE id = NEW.protocol_id;

    IF v_status = 'recruiting' AND v_min IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM protocol_enrollments WHERE protocol_id = NEW.protocol_id;

        IF v_count >= v_min THEN
            UPDATE protocols
            SET status = 'active', started_at = now()
            WHERE id = NEW.protocol_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;;

DROP TRIGGER IF EXISTS trig_check_cohort_after_enrollment ON protocol_enrollments;;
CREATE TRIGGER trig_check_cohort_after_enrollment
    AFTER INSERT ON protocol_enrollments
    FOR EACH ROW EXECUTE FUNCTION check_cohort_threshold();;


-- 4. Incrementar fork_count en el protocolo padre al forkear
CREATE OR REPLACE FUNCTION increment_fork_count() RETURNS trigger AS $$
BEGIN
    IF NEW.forked_from IS NOT NULL THEN
        UPDATE protocols
        SET fork_count = fork_count + 1
        WHERE id = NEW.forked_from;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;;

DROP TRIGGER IF EXISTS trig_increment_fork_count ON protocols;;
CREATE TRIGGER trig_increment_fork_count
    AFTER INSERT ON protocols
    FOR EACH ROW EXECUTE FUNCTION increment_fork_count();;


-- 5. Impedir enrollments y logs en templates
CREATE OR REPLACE FUNCTION guard_no_template_enrollment() RETURNS trigger AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM protocols WHERE id = NEW.protocol_id AND is_template = TRUE) THEN
        RAISE EXCEPTION 'Cannot enroll in a template protocol -- fork it first';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;;

DROP TRIGGER IF EXISTS trig_guard_template_enrollment ON protocol_enrollments;;
CREATE TRIGGER trig_guard_template_enrollment
    BEFORE INSERT ON protocol_enrollments
    FOR EACH ROW EXECUTE FUNCTION guard_no_template_enrollment();;

CREATE OR REPLACE FUNCTION guard_no_template_log() RETURNS trigger AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM protocols WHERE id = NEW.protocol_id AND is_template = TRUE) THEN
        RAISE EXCEPTION 'Cannot log entries on a template protocol';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;;

DROP TRIGGER IF EXISTS trig_guard_template_log ON log_entries;;
CREATE TRIGGER trig_guard_template_log
    BEFORE INSERT ON log_entries
    FOR EACH ROW EXECUTE FUNCTION guard_no_template_log();;


-- 6. Actualizar streak al insertar un log entry
CREATE OR REPLACE FUNCTION update_user_streak() RETURNS trigger AS $$
DECLARE
    v_existing   RECORD;
    v_new_streak INT;
BEGIN
    SELECT current_streak, longest_streak, last_log_date
    INTO v_existing
    FROM user_streaks
    WHERE user_id = NEW.user_id AND protocol_id = NEW.protocol_id;

    IF NOT FOUND THEN
        INSERT INTO user_streaks (user_id, protocol_id, current_streak, longest_streak, last_log_date)
        VALUES (NEW.user_id, NEW.protocol_id, 1, 1, NEW.log_date);
    ELSIF NEW.log_date = v_existing.last_log_date THEN
        NULL;
    ELSIF NEW.log_date = v_existing.last_log_date + 1 THEN
        v_new_streak := v_existing.current_streak + 1;
        UPDATE user_streaks
        SET current_streak = v_new_streak,
            longest_streak = GREATEST(v_existing.longest_streak, v_new_streak),
            last_log_date  = NEW.log_date,
            updated_at     = now()
        WHERE user_id = NEW.user_id AND protocol_id = NEW.protocol_id;
    ELSE
        UPDATE user_streaks
        SET current_streak = 1,
            last_log_date  = NEW.log_date,
            updated_at     = now()
        WHERE user_id = NEW.user_id AND protocol_id = NEW.protocol_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;;

DROP TRIGGER IF EXISTS trig_update_streak ON log_entries;;
CREATE TRIGGER trig_update_streak
    AFTER INSERT ON log_entries
    FOR EACH ROW EXECUTE FUNCTION update_user_streak();;


-- 7. updated_at automatico
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;;

DROP TRIGGER IF EXISTS trig_users_updated_at ON users;;
CREATE TRIGGER trig_users_updated_at             BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
DROP TRIGGER IF EXISTS trig_user_profiles_updated_at ON user_profiles;;
CREATE TRIGGER trig_user_profiles_updated_at      BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
DROP TRIGGER IF EXISTS trig_protocols_updated_at ON protocols;;
CREATE TRIGGER trig_protocols_updated_at          BEFORE UPDATE ON protocols FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
DROP TRIGGER IF EXISTS trig_protocol_interventions_upd ON protocol_interventions;;
CREATE TRIGGER trig_protocol_interventions_upd    BEFORE UPDATE ON protocol_interventions FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
DROP TRIGGER IF EXISTS trig_protocol_enrollments_upd ON protocol_enrollments;;
CREATE TRIGGER trig_protocol_enrollments_upd      BEFORE UPDATE ON protocol_enrollments FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
DROP TRIGGER IF EXISTS trig_log_entries_updated_at ON log_entries;;
CREATE TRIGGER trig_log_entries_updated_at        BEFORE UPDATE ON log_entries FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
DROP TRIGGER IF EXISTS trig_protocol_reviews_updated_at ON protocol_reviews;;
CREATE TRIGGER trig_protocol_reviews_updated_at   BEFORE UPDATE ON protocol_reviews FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
DROP TRIGGER IF EXISTS trig_community_posts_updated_at ON community_posts;;
CREATE TRIGGER trig_community_posts_updated_at    BEFORE UPDATE ON community_posts FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
DROP TRIGGER IF EXISTS trig_communities_updated_at ON communities;;
CREATE TRIGGER trig_communities_updated_at        BEFORE UPDATE ON communities FOR EACH ROW EXECUTE FUNCTION set_updated_at();;
