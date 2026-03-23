-- ============================================================
-- BIOHACK PROTOCOLS PLATFORM — Seed Data
-- ============================================================
-- Datos iniciales para catálogos normalizados:
--   • Goal categories + Goals
--   • Metric categories + Metrics
--   • Intervention categories + Interventions
--
-- Idempotente: usa ON CONFLICT DO NOTHING para re-ejecutar sin error.
-- ============================================================


-- ════════════════════════════════════════════════════════════
-- 1. GOAL CATEGORIES & GOALS
-- ════════════════════════════════════════════════════════════

INSERT INTO goal_categories (name, label, icon, sort_order) VALUES
    ('sleep',              'Sueño',              'moon',          1),
    ('cognition',          'Cognición',           'brain',         2),
    ('energy',             'Energía',             'zap',           3),
    ('mood',               'Estado de ánimo',     'smile',         4),
    ('physical',           'Rendimiento físico',  'dumbbell',      5),
    ('longevity',          'Longevidad',          'heart-pulse',   6),
    ('nutrition',          'Nutrición',           'apple',         7)
ON CONFLICT (name) DO NOTHING;

INSERT INTO goals (category_id, name, label, description) VALUES
    -- Sueño
    ((SELECT id FROM goal_categories WHERE name = 'sleep'),     'more_sleep_hours',      'Dormir más horas',             'Aumentar la cantidad total de horas de sueño por noche'),
    ((SELECT id FROM goal_categories WHERE name = 'sleep'),     'better_sleep_quality',  'Mejorar calidad de sueño',     'Lograr un sueño más profundo y reparador'),
    ((SELECT id FROM goal_categories WHERE name = 'sleep'),     'reduce_sleep_latency',  'Reducir latencia de sueño',    'Disminuir el tiempo que toma quedarse dormido'),
    ((SELECT id FROM goal_categories WHERE name = 'sleep'),     'regulate_circadian',    'Regular ciclo circadiano',     'Estabilizar horarios de sueño y vigilia'),

    -- Cognición
    ((SELECT id FROM goal_categories WHERE name = 'cognition'), 'improve_focus',         'Mejorar concentración',        'Aumentar la capacidad de mantener atención sostenida'),
    ((SELECT id FROM goal_categories WHERE name = 'cognition'), 'improve_memory',        'Mejorar memoria',              'Fortalecer la retención y recuperación de información'),
    ((SELECT id FROM goal_categories WHERE name = 'cognition'), 'reduce_brain_fog',      'Reducir brain fog',            'Disminuir episodios de confusión mental y falta de claridad'),
    ((SELECT id FROM goal_categories WHERE name = 'cognition'), 'boost_creativity',      'Aumentar creatividad',         'Estimular el pensamiento divergente y la generación de ideas'),

    -- Energía
    ((SELECT id FROM goal_categories WHERE name = 'energy'),    'boost_daily_energy',    'Aumentar energía diaria',      'Incrementar los niveles de energía a lo largo del día'),
    ((SELECT id FROM goal_categories WHERE name = 'energy'),    'reduce_fatigue',        'Reducir fatiga',               'Disminuir la sensación de cansancio y agotamiento'),
    ((SELECT id FROM goal_categories WHERE name = 'energy'),    'improve_endurance',     'Mejorar resistencia física',   'Aumentar la capacidad de sostener actividad prolongada'),

    -- Estado de ánimo
    ((SELECT id FROM goal_categories WHERE name = 'mood'),      'reduce_anxiety',        'Reducir ansiedad',             'Disminuir niveles de ansiedad y preocupación'),
    ((SELECT id FROM goal_categories WHERE name = 'mood'),      'improve_mood',          'Mejorar ánimo general',        'Elevar el estado de ánimo base día a día'),
    ((SELECT id FROM goal_categories WHERE name = 'mood'),      'manage_stress',         'Manejar estrés',              'Desarrollar mejor tolerancia y manejo del estrés'),
    ((SELECT id FROM goal_categories WHERE name = 'mood'),      'emotional_resilience',  'Mejorar resiliencia emocional','Fortalecer la capacidad de recuperarse de adversidades'),

    -- Rendimiento físico
    ((SELECT id FROM goal_categories WHERE name = 'physical'),  'gain_muscle',           'Ganar masa muscular',          'Aumentar masa muscular magra'),
    ((SELECT id FROM goal_categories WHERE name = 'physical'),  'improve_recovery',      'Mejorar recuperación',         'Acelerar la recuperación post-ejercicio'),
    ((SELECT id FROM goal_categories WHERE name = 'physical'),  'increase_strength',     'Aumentar fuerza',              'Incrementar la fuerza máxima en movimientos compuestos'),
    ((SELECT id FROM goal_categories WHERE name = 'physical'),  'improve_flexibility',   'Mejorar flexibilidad',         'Aumentar rango de movimiento y movilidad articular'),

    -- Longevidad
    ((SELECT id FROM goal_categories WHERE name = 'longevity'), 'reduce_inflammation',   'Reducir inflamación',          'Disminuir marcadores de inflamación sistémica'),
    ((SELECT id FROM goal_categories WHERE name = 'longevity'), 'cardiovascular_health', 'Mejorar salud cardiovascular', 'Optimizar indicadores de salud del corazón y vasos'),
    ((SELECT id FROM goal_categories WHERE name = 'longevity'), 'optimize_biomarkers',   'Optimizar biomarcadores',      'Llevar biomarcadores clave a rangos óptimos'),

    -- Nutrición
    ((SELECT id FROM goal_categories WHERE name = 'nutrition'), 'optimize_digestion',    'Optimizar digestión',          'Mejorar la función digestiva y reducir molestias'),
    ((SELECT id FROM goal_categories WHERE name = 'nutrition'), 'body_composition',      'Mejorar composición corporal', 'Optimizar la relación entre masa magra y grasa'),
    ((SELECT id FROM goal_categories WHERE name = 'nutrition'), 'reduce_cravings',       'Reducir antojos',              'Disminuir deseos de alimentos poco saludables')
ON CONFLICT (name) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 2. METRIC CATEGORIES & METRICS
-- ════════════════════════════════════════════════════════════

INSERT INTO metric_categories (name, label, sort_order) VALUES
    ('sleep',        'Sueño',                 1),
    ('energy',       'Energía',               2),
    ('cognitive',    'Cognitivas',             3),
    ('mood',         'Estado de ánimo',        4),
    ('body',         'Cuerpo',                 5),
    ('performance',  'Rendimiento',            6),
    ('blood',        'Sangre / Biomarcadores', 7),
    ('subjective',   'Subjetivas',             8)
ON CONFLICT (name) DO NOTHING;

INSERT INTO metrics (category_id, name, label, unit, value_type, scale_min, scale_max, higher_is_better) VALUES
    -- Sueño
    ((SELECT id FROM metric_categories WHERE name = 'sleep'), 'sleep_hours',          'Horas de sueño',          'horas',    'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'sleep'), 'sleep_quality',        'Calidad de sueño',        '1-10',     'scale',   1,    10,  TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'sleep'), 'sleep_latency',        'Latencia de sueño',       'minutos',  'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'sleep'), 'night_awakenings',     'Despertares nocturnos',   'count',    'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'sleep'), 'deep_sleep',           'Sueño profundo',          'minutos',  'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'sleep'), 'rem_sleep',            'Sueño REM',               'minutos',  'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'sleep'), 'sleep_efficiency',     'Eficiencia de sueño',     '%',        'numeric', NULL, NULL, TRUE),

    -- Energía
    ((SELECT id FROM metric_categories WHERE name = 'energy'), 'energy_level',        'Nivel de energía',        '1-10',     'scale',   1,    10,  TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'energy'), 'perceived_fatigue',   'Fatiga percibida',        '1-10',     'scale',   1,    10,  FALSE),

    -- Cognitivas
    ((SELECT id FROM metric_categories WHERE name = 'cognitive'), 'perceived_focus',     'Concentración percibida',  '1-10',    'scale',   1,    10,  TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'cognitive'), 'mental_clarity',      'Claridad mental',          '1-10',    'scale',   1,    10,  TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'cognitive'), 'perceived_productivity','Productividad percibida', '1-10',    'scale',   1,    10,  TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'cognitive'), 'reaction_time',       'Tiempo de reacción',       'ms',      'numeric', NULL, NULL, FALSE),

    -- Estado de ánimo
    ((SELECT id FROM metric_categories WHERE name = 'mood'), 'anxiety_level',       'Nivel de ansiedad',        '1-10',     'scale',   1,    10,  FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'mood'), 'stress_level',        'Nivel de estrés',          '1-10',     'scale',   1,    10,  FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'mood'), 'general_mood',        'Estado de ánimo general',  '1-10',     'scale',   1,    10,  TRUE),

    -- Cuerpo
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'body_weight',         'Peso corporal',                'kg',    'numeric', NULL, NULL, NULL),
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'resting_heart_rate',  'Frecuencia cardíaca en reposo','bpm',   'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'hrv',                 'HRV',                          'ms',    'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'body_fat',            'Grasa corporal',               '%',     'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'systolic_bp',         'Presión arterial sistólica',   'mmHg',  'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'diastolic_bp',        'Presión arterial diastólica',  'mmHg',  'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'body_temperature',    'Temperatura corporal',         '°C',    'numeric', NULL, NULL, NULL),
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'waist_circumference', 'Perímetro de cintura',         'cm',    'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'body'), 'spo2',                'SpO2',                         '%',     'numeric', NULL, NULL, TRUE),

    -- Rendimiento
    ((SELECT id FROM metric_categories WHERE name = 'performance'), 'reps_completed',    'Reps/series completadas',  'count',      'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'performance'), 'exercise_duration',  'Tiempo de ejercicio',      'minutos',    'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'performance'), 'estimated_vo2max',   'VO2 estimado',             'mL/kg/min',  'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'performance'), 'estimated_1rm',      '1RM estimado',             'kg',         'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'performance'), 'daily_steps',        'Pasos diarios',            'count',      'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'performance'), 'distance_covered',   'Distancia recorrida',      'km',         'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'performance'), 'active_calories',    'Calorías activas',         'kcal',       'numeric', NULL, NULL, TRUE),

    -- Sangre / Biomarcadores
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'fasting_glucose',     'Glucosa en ayunas',        'mg/dL',   'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'hba1c',               'HbA1c',                    '%',       'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'total_testosterone',  'Testosterona total',       'ng/dL',   'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'cortisol_am',         'Cortisol AM',              'µg/dL',   'numeric', NULL, NULL, NULL),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'tsh',                 'TSH',                      'mIU/L',   'numeric', NULL, NULL, NULL),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'vitamin_d',           'Vitamina D (25-OH)',       'ng/mL',   'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'ferritin',            'Ferritina',                'ng/mL',   'numeric', NULL, NULL, NULL),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'crp',                 'PCR (proteína C reactiva)','mg/L',    'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'total_cholesterol',   'Colesterol total',         'mg/dL',   'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'hdl',                 'HDL',                      'mg/dL',   'numeric', NULL, NULL, TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'ldl',                 'LDL',                      'mg/dL',   'numeric', NULL, NULL, FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'blood'), 'triglycerides',       'Triglicéridos',            'mg/dL',   'numeric', NULL, NULL, FALSE),

    -- Subjetivas
    ((SELECT id FROM metric_categories WHERE name = 'subjective'), 'perceived_pain',  'Dolor percibido',   '1-10',  'scale',   1,    10,  FALSE),
    ((SELECT id FROM metric_categories WHERE name = 'subjective'), 'digestion',       'Digestión',         '1-10',  'scale',   1,    10,  TRUE),
    ((SELECT id FROM metric_categories WHERE name = 'subjective'), 'libido',          'Libido',            '1-10',  'scale',   1,    10,  TRUE)
ON CONFLICT (name) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 3. INTERVENTION CATEGORIES & INTERVENTIONS
-- ════════════════════════════════════════════════════════════

INSERT INTO intervention_categories (name, label, icon, sort_order) VALUES
    ('supplements',   'Suplementos',        'pill',           1),
    ('light',         'Luz y ambiente',     'sun',            2),
    ('breathing',     'Respiración',        'wind',           3),
    ('exercise',      'Ejercicio',          'dumbbell',       4),
    ('nutrition',     'Alimentación',       'utensils',       5),
    ('mindfulness',   'Mindfulness',        'leaf',           6),
    ('sleep_hygiene', 'Higiene de sueño',   'moon',           7)
ON CONFLICT (name) DO NOTHING;

INSERT INTO interventions (category_id, name, label, description, default_unit) VALUES
    -- Suplementos
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'creatine',       'Creatina',        'Monohidrato de creatina',                          'g'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'magnesium',      'Magnesio',        'Magnesio (glicinato, treonato, citrato, etc.)',     'mg'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'omega3',         'Omega-3',         'Ácidos grasos EPA/DHA',                             'mg'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'vitamin_d',      'Vitamina D',      'Colecalciferol (vitamina D3)',                       'IU'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'melatonin',      'Melatonina',      'Melatonina exógena para regulación del sueño',      'mg'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'ashwagandha',    'Ashwagandha',     'Extracto de Withania somnifera (KSM-66, Sensoril)', 'mg'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'l_theanine',     'L-Teanina',       'Aminoácido del té verde',                           'mg'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'caffeine',       'Cafeína',         'Cafeína anhidra o de fuente natural',               'mg'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'zinc',           'Zinc',            'Zinc (picolinato, bisglicinato, etc.)',              'mg'),
    ((SELECT id FROM intervention_categories WHERE name = 'supplements'), 'vitamin_b12',    'Vitamina B12',    'Cianocobalamina o metilcobalamina',                  'µg'),

    -- Luz y ambiente
    ((SELECT id FROM intervention_categories WHERE name = 'light'), 'morning_sunlight',   'Exposición a luz solar AM',    'Exposición directa a luz solar en las primeras horas',  'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'light'), 'blue_light_block',   'Bloqueo de luz azul PM',       'Uso de lentes o filtros bloqueadores de luz azul',      'horas'),
    ((SELECT id FROM intervention_categories WHERE name = 'light'), 'red_light_therapy',  'Luz roja/infrarroja',          'Terapia con luz roja o infrarroja cercana',             'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'light'), 'cool_sleep_env',     'Ambiente frío para dormir',    'Mantener temperatura baja en el dormitorio (18-20°C)', '°C'),

    -- Respiración
    ((SELECT id FROM intervention_categories WHERE name = 'breathing'), 'wim_hof',        'Respiración Wim Hof',    'Rondas de hiperventilación controlada + retención',    'rondas'),
    ((SELECT id FROM intervention_categories WHERE name = 'breathing'), 'box_breathing',  'Box breathing',          'Respiración cuadrada: inhalar-retener-exhalar-retener','minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'breathing'), 'breathing_478',  'Respiración 4-7-8',      'Inhalar 4s, retener 7s, exhalar 8s',                  'ciclos'),
    ((SELECT id FROM intervention_categories WHERE name = 'breathing'), 'nasal_breathing', 'Breathwork nasal',      'Respiración exclusivamente nasal durante actividades', 'minutos'),

    -- Ejercicio
    ((SELECT id FROM intervention_categories WHERE name = 'exercise'), 'strength_training', 'Entrenamiento de fuerza', 'Entrenamiento con pesas o resistencia',             'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'exercise'), 'hiit',              'HIIT',                    'Entrenamiento intervalado de alta intensidad',       'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'exercise'), 'zone2_cardio',      'Cardio zona 2',           'Ejercicio cardiovascular aeróbico de baja intensidad','minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'exercise'), 'yoga',              'Yoga',                    'Práctica de yoga (hatha, vinyasa, etc.)',            'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'exercise'), 'daily_walk',        'Caminata diaria',         'Caminata a paso moderado',                          'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'exercise'), 'stretching',        'Stretching',              'Estiramientos estáticos o dinámicos',               'minutos'),

    -- Alimentación
    ((SELECT id FROM intervention_categories WHERE name = 'nutrition'), 'intermittent_fasting', 'Ayuno intermitente',         'Periodos de ayuno programados (16:8, 18:6, etc.)',  'horas'),
    ((SELECT id FROM intervention_categories WHERE name = 'nutrition'), 'keto_diet',            'Dieta cetogénica',           'Alimentación alta en grasas, muy baja en carbohidratos', NULL),
    ((SELECT id FROM intervention_categories WHERE name = 'nutrition'), 'caloric_restriction',  'Restricción calórica',       'Reducción controlada de ingesta calórica diaria',   'kcal'),
    ((SELECT id FROM intervention_categories WHERE name = 'nutrition'), 'eating_window',        'Ventana de alimentación',    'Limitar ingesta a una ventana temporal definida',   'horas'),
    ((SELECT id FROM intervention_categories WHERE name = 'nutrition'), 'sugar_elimination',    'Eliminación de azúcar',      'Eliminación de azúcares añadidos de la dieta',      NULL),

    -- Mindfulness
    ((SELECT id FROM intervention_categories WHERE name = 'mindfulness'), 'meditation',       'Meditación',           'Práctica de meditación guiada o libre',              'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'mindfulness'), 'journaling',       'Journaling',           'Escritura reflexiva diaria',                         'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'mindfulness'), 'daily_gratitude',  'Gratitud diaria',      'Registro diario de cosas por las que estar agradecido','items'),
    ((SELECT id FROM intervention_categories WHERE name = 'mindfulness'), 'sauna',            'Sauna',                'Sesión de sauna seca o infrarroja',                  'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'mindfulness'), 'cold_exposure',    'Baño frío/crioterapia','Exposición a agua fría o crioterapia',               'minutos'),

    -- Higiene de sueño
    ((SELECT id FROM intervention_categories WHERE name = 'sleep_hygiene'), 'fixed_sleep_schedule', 'Horario fijo de sueño',      'Acostarse y levantarse a la misma hora cada día',      NULL),
    ((SELECT id FROM intervention_categories WHERE name = 'sleep_hygiene'), 'no_screens_before_bed','No pantallas 1h antes',      'Evitar pantallas al menos 1 hora antes de dormir',     'minutos'),
    ((SELECT id FROM intervention_categories WHERE name = 'sleep_hygiene'), 'cool_bedroom',         'Temperatura ambiente baja',  'Mantener el dormitorio entre 18-20°C',                 '°C'),
    ((SELECT id FROM intervention_categories WHERE name = 'sleep_hygiene'), 'total_blackout',       'Blackout total',             'Oscuridad completa en el dormitorio para dormir',      NULL)
ON CONFLICT (name) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 4. ACHIEVEMENTS (catálogo base)
-- ════════════════════════════════════════════════════════════

INSERT INTO achievements (slug, name, description, icon, category, criteria, points, sort_order) VALUES
    ('first_log',            'Primera entrada',          'Registraste tu primer log entry',                        'pencil',    'general',  '{"type": "count", "entity": "logs", "threshold": 1}',                 10,  1),
    ('streak_7',             'Una semana al pie',        'Mantuviste un streak de 7 días consecutivos',            'fire',      'streak',   '{"type": "streak", "days": 7}',                                       25,  2),
    ('streak_30',            'Mes de hierro',            'Mantuviste un streak de 30 días consecutivos',           'fire',      'streak',   '{"type": "streak", "days": 30}',                                      100, 3),
    ('streak_100',           'Centurión',                'Mantuviste un streak de 100 días consecutivos',          'fire',      'streak',   '{"type": "streak", "days": 100}',                                     500, 4),
    ('protocol_completed',   'Misión cumplida',          'Completaste tu primer protocolo',                        'check',     'general',  '{"type": "count", "entity": "protocols_completed", "threshold": 1}',   50,  5),
    ('five_protocols',       'Experimentador serial',    'Completaste 5 protocolos',                               'beaker',    'explorer', '{"type": "count", "entity": "protocols_completed", "threshold": 5}',   150, 6),
    ('first_review',         'Crítico constructivo',     'Dejaste tu primera review en un protocolo',              'star',      'social',   '{"type": "count", "entity": "reviews_written", "threshold": 1}',       15,  7),
    ('ten_reviews',          'Voz de la comunidad',      'Escribiste 10 reviews',                                  'star',      'social',   '{"type": "count", "entity": "reviews_written", "threshold": 10}',      75,  8),
    ('first_protocol',       'Creador novato',           'Creaste tu primer protocolo',                            'flask',     'creator',  '{"type": "count", "entity": "protocols_created", "threshold": 1}',     25,  9),
    ('five_created',         'Diseñador de protocolos',  'Creaste 5 protocolos',                                   'flask',     'creator',  '{"type": "count", "entity": "protocols_created", "threshold": 5}',     100, 10),
    ('first_follower',       'Influyente',               'Alguien te empezó a seguir',                             'users',     'social',   '{"type": "count", "entity": "followers", "threshold": 1}',             10,  11),
    ('community_joined',     'Parte del equipo',         'Te uniste a tu primera comunidad',                       'users',     'social',   '{"type": "count", "entity": "communities_joined", "threshold": 1}',    10,  12),
    ('first_fork',           'Remix master',             'Forkeaste tu primer protocolo',                          'git-fork',  'explorer', '{"type": "count", "entity": "protocols_forked", "threshold": 1}',      15,  13),
    ('hundred_logs',         'Data machine',             'Registraste 100 log entries en total',                   'database',  'general',  '{"type": "count", "entity": "logs", "threshold": 100}',               75,  14),
    ('five_hundred_logs',    'Obsesivo de los datos',    'Registraste 500 log entries en total',                   'database',  'general',  '{"type": "count", "entity": "logs", "threshold": 500}',               250, 15)
ON CONFLICT (slug) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 5. SEED USERS (test creators)
-- ════════════════════════════════════════════════════════════

INSERT INTO users (id, email, password_hash, display_name, username, role) VALUES
    -- All seed users use password: password123
    ('a0000000-0000-0000-0000-000000000001', 'creator1@biostack.test', '$2a$10$mGKnw7P3Ag7yKy1SBhhU.ueH2gkdYC3mscLKKFiPcVNCl0qkEHvb.', 'Dr. Marcos Vitale', 'marcos_vitale', 'creator'),
    ('a0000000-0000-0000-0000-000000000002', 'creator2@biostack.test', '$2a$10$mGKnw7P3Ag7yKy1SBhhU.ueH2gkdYC3mscLKKFiPcVNCl0qkEHvb.', 'Sofía Neuhaus',    'sofia_neuhaus',  'creator'),
    ('a0000000-0000-0000-0000-000000000003', 'explorer1@biostack.test','$2a$10$mGKnw7P3Ag7yKy1SBhhU.ueH2gkdYC3mscLKKFiPcVNCl0qkEHvb.', 'Juan Explorador',  'juan_explorer',  'explorer'),
    ('a0000000-0000-0000-0000-000000000004', 'explorer2@biostack.test','$2a$10$mGKnw7P3Ag7yKy1SBhhU.ueH2gkdYC3mscLKKFiPcVNCl0qkEHvb.', 'Ana Biohacker',    'ana_biohacker',  'explorer'),
    ('a0000000-0000-0000-0000-000000000005', 'explorer3@biostack.test','$2a$10$mGKnw7P3Ag7yKy1SBhhU.ueH2gkdYC3mscLKKFiPcVNCl0qkEHvb.', 'Leo Data',         'leo_data',       'explorer')
ON CONFLICT (email) DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 6. SEED PROTOCOLS
-- ════════════════════════════════════════════════════════════

INSERT INTO protocols (id, creator_id, goal_id, title, description, duration_days, status, visibility, tags) VALUES
    -- 1. Sleep optimization
    ('b0000000-0000-0000-0000-000000000001',
     'a0000000-0000-0000-0000-000000000001',
     (SELECT id FROM goals WHERE name = 'better_sleep_quality'),
     'Optimización de sueño profundo',
     'Protocolo integral para mejorar la calidad de sueño combinando suplementación con magnesio y melatonina, reducción de luz azul y horario fijo de sueño. Basado en las recomendaciones de Andrew Huberman.',
     30, 'active', 'public',
     ARRAY['sueño', 'melatonina', 'magnesio', 'huberman']),

    -- 2. Cognitive stack
    ('b0000000-0000-0000-0000-000000000002',
     'a0000000-0000-0000-0000-000000000001',
     (SELECT id FROM goals WHERE name = 'improve_focus'),
     'Stack nootrópico para concentración',
     'Combinación de L-Teanina + Cafeína con meditación matutina y breathwork nasal. Diseñado para maximizar horas de deep work.',
     60, 'active', 'public',
     ARRAY['nootrópicos', 'concentración', 'deep-work', 'cafeína']),

    -- 3. Cold exposure + breathing
    ('b0000000-0000-0000-0000-000000000003',
     'a0000000-0000-0000-0000-000000000002',
     (SELECT id FROM goals WHERE name = 'reduce_inflammation'),
     'Wim Hof: frío + respiración',
     'Protocolo basado en el método Wim Hof: exposición progresiva al frío combinada con respiración cíclica. Ideal para reducir inflamación y mejorar resiliencia.',
     21, 'recruiting', 'public',
     ARRAY['wim-hof', 'frío', 'respiración', 'inflamación']),

    -- 4. Strength protocol
    ('b0000000-0000-0000-0000-000000000004',
     'a0000000-0000-0000-0000-000000000002',
     (SELECT id FROM goals WHERE name = 'gain_muscle'),
     'Fuerza + Creatina 12 semanas',
     'Programa de hipertrofia de 12 semanas con suplementación de creatina monohidrato (5g/día). Incluye entrenamiento de fuerza 4x/semana y tracking de 1RM estimado.',
     90, 'active', 'public',
     ARRAY['fuerza', 'creatina', 'hipertrofia', 'gym']),

    -- 5. Anxiety management
    ('b0000000-0000-0000-0000-000000000005',
     'a0000000-0000-0000-0000-000000000001',
     (SELECT id FROM goals WHERE name = 'reduce_anxiety'),
     'Manejo de ansiedad con meditación',
     'Protocolo de 4 semanas para reducir ansiedad combinando meditación guiada (20 min/día), ashwagandha y journaling. Enfoque en regulación del sistema nervioso.',
     28, 'completed', 'public',
     ARRAY['ansiedad', 'meditación', 'ashwagandha', 'mindfulness']),

    -- 6. Intermittent fasting
    ('b0000000-0000-0000-0000-000000000006',
     'a0000000-0000-0000-0000-000000000002',
     (SELECT id FROM goals WHERE name = 'body_composition'),
     'Ayuno intermitente 16:8',
     'Protocolo de ayuno intermitente con ventana de alimentación de 8 horas. Incluye tracking de peso, composición corporal y niveles de energía percibida.',
     45, 'active', 'public',
     ARRAY['ayuno', 'nutrición', '16:8', 'composición-corporal']),

    -- 7. Morning routine
    ('b0000000-0000-0000-0000-000000000007',
     'a0000000-0000-0000-0000-000000000001',
     (SELECT id FROM goals WHERE name = 'boost_daily_energy'),
     'Rutina matutina de alta energía',
     'Protocolo corto de 2 semanas: exposición a luz solar en los primeros 30 min, breathwork y caminata de 15 min. Sin suplementos.',
     14, 'active', 'public',
     ARRAY['mañana', 'energía', 'luz-solar', 'rutina']),

    -- 8. HRV optimization
    ('b0000000-0000-0000-0000-000000000008',
     'a0000000-0000-0000-0000-000000000002',
     (SELECT id FROM goals WHERE name = 'cardiovascular_health'),
     'Optimización de HRV',
     'Protocolo enfocado en mejorar la variabilidad de frecuencia cardíaca (HRV) mediante cardio zona 2, respiración box breathing y omega-3. Requiere tracking diario de HRV.',
     60, 'recruiting', 'public',
     ARRAY['hrv', 'cardio', 'zona-2', 'omega-3']),

    -- 9. Digital detox sleep
    ('b0000000-0000-0000-0000-000000000009',
     'a0000000-0000-0000-0000-000000000001',
     (SELECT id FROM goals WHERE name = 'reduce_sleep_latency'),
     'Detox digital para dormir mejor',
     'Desafío de 7 días sin pantallas 2 horas antes de dormir. Incluye lectura, journaling nocturno y ambiente de blackout total.',
     7, 'draft', 'public',
     ARRAY['sueño', 'pantallas', 'detox-digital', 'latencia']),

    -- 10. Meditation + journaling
    ('b0000000-0000-0000-0000-000000000010',
     'a0000000-0000-0000-0000-000000000002',
     (SELECT id FROM goals WHERE name = 'manage_stress'),
     'Mindfulness diario: meditación + journal',
     'Protocolo de 30 días combinando 15 minutos de meditación con journaling reflexivo y práctica de gratitud. Ideal para gestionar el estrés del día a día.',
     30, 'active', 'public',
     ARRAY['mindfulness', 'estrés', 'meditación', 'journaling'])
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 7. SEED PROTOCOL INTERVENTIONS
-- ════════════════════════════════════════════════════════════

INSERT INTO protocol_interventions (protocol_id, intervention_id, dosage, dosage_unit, frequency, timing, sort_order) VALUES
    -- Sleep protocol: magnesium + melatonin + blue light block + fixed schedule
    ('b0000000-0000-0000-0000-000000000001', (SELECT id FROM interventions WHERE name = 'magnesium'),           400,  'mg',      'diario', 'Antes de dormir', 1),
    ('b0000000-0000-0000-0000-000000000001', (SELECT id FROM interventions WHERE name = 'melatonin'),           0.5,  'mg',      'diario', '30 min antes de acostarse', 2),
    ('b0000000-0000-0000-0000-000000000001', (SELECT id FROM interventions WHERE name = 'blue_light_block'),    NULL, 'horas',   'diario', '2h antes de dormir', 3),
    ('b0000000-0000-0000-0000-000000000001', (SELECT id FROM interventions WHERE name = 'fixed_sleep_schedule'),NULL, NULL,      'diario', 'Misma hora todos los días', 4),

    -- Cognitive stack: caffeine + l-theanine + meditation + nasal breathing
    ('b0000000-0000-0000-0000-000000000002', (SELECT id FROM interventions WHERE name = 'caffeine'),            100,  'mg',      'diario', 'Mañana con el primer café', 1),
    ('b0000000-0000-0000-0000-000000000002', (SELECT id FROM interventions WHERE name = 'l_theanine'),          200,  'mg',      'diario', 'Junto con la cafeína', 2),
    ('b0000000-0000-0000-0000-000000000002', (SELECT id FROM interventions WHERE name = 'meditation'),          15,   'minutos', 'diario', 'Al despertar', 3),
    ('b0000000-0000-0000-0000-000000000002', (SELECT id FROM interventions WHERE name = 'nasal_breathing'),     NULL, 'minutos', 'diario', 'Durante sesiones de trabajo', 4),

    -- Cold exposure: wim hof + cold exposure
    ('b0000000-0000-0000-0000-000000000003', (SELECT id FROM interventions WHERE name = 'wim_hof'),             3,    'rondas',  'diario', 'Mañana en ayunas', 1),
    ('b0000000-0000-0000-0000-000000000003', (SELECT id FROM interventions WHERE name = 'cold_exposure'),       3,    'minutos', 'diario', 'Después de respiración', 2),

    -- Strength: creatine + strength training
    ('b0000000-0000-0000-0000-000000000004', (SELECT id FROM interventions WHERE name = 'creatine'),            5,    'g',       'diario',    'Con comida post-entreno', 1),
    ('b0000000-0000-0000-0000-000000000004', (SELECT id FROM interventions WHERE name = 'strength_training'),   60,   'minutos', '4x/semana', 'Bloques de 60 min', 2),

    -- Anxiety: ashwagandha + meditation + journaling
    ('b0000000-0000-0000-0000-000000000005', (SELECT id FROM interventions WHERE name = 'ashwagandha'),         600,  'mg',      'diario', 'Con el desayuno', 1),
    ('b0000000-0000-0000-0000-000000000005', (SELECT id FROM interventions WHERE name = 'meditation'),          20,   'minutos', 'diario', 'Mañana o noche', 2),
    ('b0000000-0000-0000-0000-000000000005', (SELECT id FROM interventions WHERE name = 'journaling'),          10,   'minutos', 'diario', 'Antes de dormir', 3),

    -- Fasting: intermittent fasting + eating window
    ('b0000000-0000-0000-0000-000000000006', (SELECT id FROM interventions WHERE name = 'intermittent_fasting'),16,   'horas',   'diario', 'Ayuno de 22:00 a 14:00', 1),
    ('b0000000-0000-0000-0000-000000000006', (SELECT id FROM interventions WHERE name = 'eating_window'),       8,    'horas',   'diario', 'Comer entre 14:00 y 22:00', 2),

    -- Morning routine: morning sunlight + daily walk + box breathing
    ('b0000000-0000-0000-0000-000000000007', (SELECT id FROM interventions WHERE name = 'morning_sunlight'),    30,   'minutos', 'diario', 'Primeros 30 min del día', 1),
    ('b0000000-0000-0000-0000-000000000007', (SELECT id FROM interventions WHERE name = 'daily_walk'),          15,   'minutos', 'diario', 'Caminata matutina', 2),
    ('b0000000-0000-0000-0000-000000000007', (SELECT id FROM interventions WHERE name = 'box_breathing'),       5,    'minutos', 'diario', 'Post-caminata', 3),

    -- HRV: zone2 cardio + box breathing + omega-3
    ('b0000000-0000-0000-0000-000000000008', (SELECT id FROM interventions WHERE name = 'zone2_cardio'),        45,   'minutos', '3x/semana', 'FC entre 120-150 bpm', 1),
    ('b0000000-0000-0000-0000-000000000008', (SELECT id FROM interventions WHERE name = 'box_breathing'),       10,   'minutos', 'diario',    'Mañana y noche', 2),
    ('b0000000-0000-0000-0000-000000000008', (SELECT id FROM interventions WHERE name = 'omega3'),              2000, 'mg',      'diario',    'Con comida principal', 3),

    -- Digital detox: no screens + journaling + total blackout
    ('b0000000-0000-0000-0000-000000000009', (SELECT id FROM interventions WHERE name = 'no_screens_before_bed'),120, 'minutos', 'diario', '2h antes de dormir', 1),
    ('b0000000-0000-0000-0000-000000000009', (SELECT id FROM interventions WHERE name = 'journaling'),          10,   'minutos', 'diario', 'Reemplazo de pantallas', 2),
    ('b0000000-0000-0000-0000-000000000009', (SELECT id FROM interventions WHERE name = 'total_blackout'),      NULL, NULL,      'diario', 'Oscuridad total', 3),

    -- Mindfulness: meditation + journaling + daily gratitude
    ('b0000000-0000-0000-0000-000000000010', (SELECT id FROM interventions WHERE name = 'meditation'),          15,   'minutos', 'diario', 'Mañana', 1),
    ('b0000000-0000-0000-0000-000000000010', (SELECT id FROM interventions WHERE name = 'journaling'),          15,   'minutos', 'diario', 'Noche', 2),
    ('b0000000-0000-0000-0000-000000000010', (SELECT id FROM interventions WHERE name = 'daily_gratitude'),     3,    'items',   'diario', 'Con el journaling', 3)
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 8. SEED PROTOCOL METRICS
-- ════════════════════════════════════════════════════════════

INSERT INTO protocol_metrics (protocol_id, metric_id, log_frequency, sort_order) VALUES
    -- Sleep protocol
    ('b0000000-0000-0000-0000-000000000001', (SELECT id FROM metrics WHERE name = 'sleep_hours'),      'daily', 1),
    ('b0000000-0000-0000-0000-000000000001', (SELECT id FROM metrics WHERE name = 'sleep_quality'),    'daily', 2),
    ('b0000000-0000-0000-0000-000000000001', (SELECT id FROM metrics WHERE name = 'sleep_latency'),    'daily', 3),
    ('b0000000-0000-0000-0000-000000000001', (SELECT id FROM metrics WHERE name = 'deep_sleep'),       'daily', 4),

    -- Cognitive stack
    ('b0000000-0000-0000-0000-000000000002', (SELECT id FROM metrics WHERE name = 'perceived_focus'),        'daily', 1),
    ('b0000000-0000-0000-0000-000000000002', (SELECT id FROM metrics WHERE name = 'mental_clarity'),         'daily', 2),
    ('b0000000-0000-0000-0000-000000000002', (SELECT id FROM metrics WHERE name = 'perceived_productivity'), 'daily', 3),

    -- Cold exposure
    ('b0000000-0000-0000-0000-000000000003', (SELECT id FROM metrics WHERE name = 'energy_level'),     'daily', 1),
    ('b0000000-0000-0000-0000-000000000003', (SELECT id FROM metrics WHERE name = 'general_mood'),     'daily', 2),
    ('b0000000-0000-0000-0000-000000000003', (SELECT id FROM metrics WHERE name = 'perceived_pain'),   'daily', 3),

    -- Strength
    ('b0000000-0000-0000-0000-000000000004', (SELECT id FROM metrics WHERE name = 'estimated_1rm'),    'weekly', 1),
    ('b0000000-0000-0000-0000-000000000004', (SELECT id FROM metrics WHERE name = 'body_weight'),      'weekly', 2),
    ('b0000000-0000-0000-0000-000000000004', (SELECT id FROM metrics WHERE name = 'reps_completed'),   'daily',  3),

    -- Anxiety
    ('b0000000-0000-0000-0000-000000000005', (SELECT id FROM metrics WHERE name = 'anxiety_level'),    'daily', 1),
    ('b0000000-0000-0000-0000-000000000005', (SELECT id FROM metrics WHERE name = 'stress_level'),     'daily', 2),
    ('b0000000-0000-0000-0000-000000000005', (SELECT id FROM metrics WHERE name = 'general_mood'),     'daily', 3),

    -- Fasting
    ('b0000000-0000-0000-0000-000000000006', (SELECT id FROM metrics WHERE name = 'body_weight'),      'daily', 1),
    ('b0000000-0000-0000-0000-000000000006', (SELECT id FROM metrics WHERE name = 'body_fat'),         'weekly', 2),
    ('b0000000-0000-0000-0000-000000000006', (SELECT id FROM metrics WHERE name = 'energy_level'),     'daily', 3),

    -- Morning routine
    ('b0000000-0000-0000-0000-000000000007', (SELECT id FROM metrics WHERE name = 'energy_level'),     'daily', 1),
    ('b0000000-0000-0000-0000-000000000007', (SELECT id FROM metrics WHERE name = 'general_mood'),     'daily', 2),

    -- HRV
    ('b0000000-0000-0000-0000-000000000008', (SELECT id FROM metrics WHERE name = 'hrv'),              'daily', 1),
    ('b0000000-0000-0000-0000-000000000008', (SELECT id FROM metrics WHERE name = 'resting_heart_rate'),'daily', 2),
    ('b0000000-0000-0000-0000-000000000008', (SELECT id FROM metrics WHERE name = 'estimated_vo2max'), 'weekly', 3),

    -- Digital detox
    ('b0000000-0000-0000-0000-000000000009', (SELECT id FROM metrics WHERE name = 'sleep_latency'),    'daily', 1),
    ('b0000000-0000-0000-0000-000000000009', (SELECT id FROM metrics WHERE name = 'sleep_quality'),    'daily', 2),

    -- Mindfulness
    ('b0000000-0000-0000-0000-000000000010', (SELECT id FROM metrics WHERE name = 'stress_level'),     'daily', 1),
    ('b0000000-0000-0000-0000-000000000010', (SELECT id FROM metrics WHERE name = 'general_mood'),     'daily', 2),
    ('b0000000-0000-0000-0000-000000000010', (SELECT id FROM metrics WHERE name = 'anxiety_level'),    'daily', 3)
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 9. SEED ENROLLMENTS (for popularity)
-- ════════════════════════════════════════════════════════════

INSERT INTO protocol_enrollments (protocol_id, user_id, status) VALUES
    -- Sleep protocol (3 enrollments)
    ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 'active'),
    ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000004', 'completed'),
    ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000005', 'active'),

    -- Cognitive stack (2 enrollments)
    ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000003', 'active'),
    ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000004', 'active'),

    -- Strength (4 enrollments — most popular)
    ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000003', 'active'),
    ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000004', 'active'),
    ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000005', 'completed'),
    ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001', 'active'),

    -- Anxiety (2 enrollments, completed)
    ('b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000003', 'completed'),
    ('b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000005', 'completed'),

    -- Fasting (1 enrollment)
    ('b0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000004', 'active'),

    -- Morning routine (3 enrollments)
    ('b0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000003', 'active'),
    ('b0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000004', 'active'),
    ('b0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000005', 'active'),

    -- Mindfulness (2 enrollments)
    ('b0000000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-000000000003', 'active'),
    ('b0000000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-000000000004', 'active')
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 10. SEED REVIEWS (for rating)
-- ════════════════════════════════════════════════════════════

INSERT INTO protocol_reviews (protocol_id, user_id, rating, title, body) VALUES
    -- Sleep protocol: avg 4.33
    ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 5, 'Excelente protocolo', 'Mejoré mi sueño notablemente en 2 semanas.'),
    ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000004', 4, 'Muy bueno', 'El magnesio ayudó muchísimo, la melatonina no tanto.'),
    ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000005', 4, 'Recomendado', 'Consistente y fácil de seguir.'),

    -- Cognitive stack: avg 4.5
    ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000003', 5, 'Game changer', 'La combo cafeína+teanina es increíble para el focus.'),
    ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000004', 4, 'Muy efectivo', 'Noté mejoras a partir del día 5.'),

    -- Strength: avg 4.67
    ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000003', 5, 'Resultados reales', 'Gané 3kg de masa magra en 8 semanas.'),
    ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000004', 5, 'Excelente estructura', 'Bien pensado y progresivo.'),
    ('b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000005', 4, 'Sólido', 'Buena base, agregaría más variación.'),

    -- Anxiety: avg 3.5
    ('b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000003', 3, 'Decente', 'Ayudó algo pero esperaba más.'),
    ('b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000005', 4, 'Funcionó para mí', 'El journaling fue clave.'),

    -- Morning routine: avg 5.0
    ('b0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000003', 5, 'Perfecto', 'Simple y efectivo, lo sigo haciendo.'),
    ('b0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000004', 5, 'Lo mejor que probé', 'Cambió mi mañana completamente.'),

    -- Mindfulness: avg 4.0
    ('b0000000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-000000000003', 4, 'Buena rutina', 'Meditación + journal es una gran combo.'),
    ('b0000000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-000000000004', 4, 'Consistente', 'Fácil de mantener y notar cambios.')
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 11. SEED FAVORITES (for popularity score)
-- ════════════════════════════════════════════════════════════

INSERT INTO protocol_favorites (user_id, protocol_id) VALUES
    ('a0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000001'),
    ('a0000000-0000-0000-0000-000000000004', 'b0000000-0000-0000-0000-000000000001'),
    ('a0000000-0000-0000-0000-000000000005', 'b0000000-0000-0000-0000-000000000002'),
    ('a0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000004'),
    ('a0000000-0000-0000-0000-000000000004', 'b0000000-0000-0000-0000-000000000004'),
    ('a0000000-0000-0000-0000-000000000005', 'b0000000-0000-0000-0000-000000000004'),
    ('a0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000007'),
    ('a0000000-0000-0000-0000-000000000004', 'b0000000-0000-0000-0000-000000000007')
ON CONFLICT DO NOTHING;


-- ════════════════════════════════════════════════════════════
-- 12. POPULATE search_vector FOR FULL-TEXT SEARCH
-- ════════════════════════════════════════════════════════════

UPDATE protocols SET search_vector =
    setweight(to_tsvector('spanish', COALESCE(title, '')), 'A') ||
    setweight(to_tsvector('spanish', COALESCE(description, '')), 'B') ||
    setweight(to_tsvector('spanish', COALESCE(array_to_string(tags, ' '), '')), 'C')
WHERE search_vector IS NULL;
