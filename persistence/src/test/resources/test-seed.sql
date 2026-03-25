-- Minimal seed data for DAO tests

-- Goal categories
INSERT INTO goal_categories (id, name, label, icon, sort_order) VALUES
    ('00000000-0000-0000-0001-000000000001', 'sleep', 'Sueño', 'moon', 1),
    ('00000000-0000-0000-0001-000000000002', 'cognition', 'Cognición', 'brain', 2),
    ('00000000-0000-0000-0001-000000000003', 'fitness', 'Fitness', 'dumbbell', 3);

-- Goals
INSERT INTO goals (id, category_id, name, label, description) VALUES
    ('00000000-0000-0000-0002-000000000001', '00000000-0000-0000-0001-000000000001', 'better_sleep', 'Mejor sueño', 'Mejorar calidad de sueño'),
    ('00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0001-000000000001', 'reduce_latency', 'Reducir latencia', 'Dormirse más rápido'),
    ('00000000-0000-0000-0002-000000000003', '00000000-0000-0000-0001-000000000002', 'improve_focus', 'Mejorar concentración', 'Más focus'),
    ('00000000-0000-0000-0002-000000000004', '00000000-0000-0000-0001-000000000003', 'gain_muscle', 'Ganar músculo', 'Hipertrofia');

-- Intervention categories
INSERT INTO intervention_categories (id, name, label, icon, sort_order) VALUES
    ('00000000-0000-0000-0003-000000000001', 'supplements', 'Suplementos', 'pill', 1),
    ('00000000-0000-0000-0003-000000000002', 'exercise', 'Ejercicio', 'dumbbell', 2);

-- Interventions
INSERT INTO interventions (id, category_id, name, label, description) VALUES
    ('00000000-0000-0000-0004-000000000001', '00000000-0000-0000-0003-000000000001', 'creatine', 'Creatina', 'Creatina monohidrato'),
    ('00000000-0000-0000-0004-000000000002', '00000000-0000-0000-0003-000000000001', 'magnesium', 'Magnesio', 'Magnesio glicinato'),
    ('00000000-0000-0000-0004-000000000003', '00000000-0000-0000-0003-000000000002', 'strength_training', 'Entrenamiento de fuerza', 'Pesas');

-- Users
INSERT INTO users (id, email, password_hash, display_name, username) VALUES
    ('00000000-0000-0000-0007-000000000001', 'test@example.com', '$2a$10$placeholder', 'Test User', 'testuser'),
    ('00000000-0000-0000-0007-000000000002', 'other@example.com', '$2a$10$placeholder', 'Other User', 'otheruser');

-- Protocols
INSERT INTO protocols (id, creator_id, goal_id, title, status, visibility) VALUES
    ('00000000-0000-0000-0008-000000000001', '00000000-0000-0000-0007-000000000001', '00000000-0000-0000-0002-000000000001', 'Test Protocol', 'active', 'public');

-- Protocol interventions (2 active, 1 inactive)
INSERT INTO protocol_interventions (id, protocol_id, intervention_id, dosage, dosage_unit, frequency, timing, instructions, sort_order, is_active) VALUES
    ('00000000-0000-0000-0009-000000000001', '00000000-0000-0000-0008-000000000001', '00000000-0000-0000-0004-000000000001', 5, 'g', 'diario', 'manana', 'Tomar con agua', 1, TRUE),
    ('00000000-0000-0000-0009-000000000002', '00000000-0000-0000-0008-000000000001', '00000000-0000-0000-0004-000000000002', 400, 'mg', 'diario', 'noche', 'Antes de dormir', 2, TRUE),
    ('00000000-0000-0000-0009-000000000003', '00000000-0000-0000-0008-000000000001', '00000000-0000-0000-0004-000000000003', NULL, NULL, '3x/semana', NULL, NULL, 3, FALSE);

-- Protocol reviews
INSERT INTO protocol_reviews (id, protocol_id, user_id, rating, body) VALUES
    ('00000000-0000-0000-000a-000000000001', '00000000-0000-0000-0008-000000000001', '00000000-0000-0000-0007-000000000001', 5, 'Excelente protocolo'),
    ('00000000-0000-0000-000a-000000000002', '00000000-0000-0000-0008-000000000001', '00000000-0000-0000-0007-000000000002', 4, 'Muy bueno');

-- Metric categories
INSERT INTO metric_categories (id, name, label, sort_order) VALUES
    ('00000000-0000-0000-0005-000000000001', 'biometrics', 'Biométricas', 1),
    ('00000000-0000-0000-0005-000000000002', 'subjective', 'Subjetivas', 2);

-- Metrics
INSERT INTO metrics (id, category_id, name, label, unit, value_type) VALUES
    ('00000000-0000-0000-0006-000000000001', '00000000-0000-0000-0005-000000000001', 'hrv', 'HRV', 'ms', 'numeric'),
    ('00000000-0000-0000-0006-000000000002', '00000000-0000-0000-0005-000000000001', 'sleep_hours', 'Horas de sueño', 'horas', 'numeric'),
    ('00000000-0000-0000-0006-000000000003', '00000000-0000-0000-0005-000000000002', 'perceived_focus', 'Focus percibido', '1-10', 'scale');
