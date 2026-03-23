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
