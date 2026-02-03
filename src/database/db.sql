-- users

CREATE TABLE users (
    id SERIAL PRIMARY KEY NOT NULL UNIQUE, 
    firebase_uid VARCHAR(128) NOT NULL UNIQUE, 
    brewery_name VARCHAR(100) NOT NULL, 
    brewery_email VARCHAR(100) NOT NULL UNIQUE, 
    address VARCHAR(255),
    commune VARCHAR(100),
    phone_number VARCHAR(20),
    website VARCHAR(255),
    role VARCHAR(10) NOT NULL DEFAULT 'user', 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

INSERT INTO users (firebase_uid, email, name, role) 
VALUES ('admin_dev_uid_12345', 'admin@mail.com', 'Admin', 'admin');

INSERT INTO users (firebase_uid, email, name, role) 
VALUES ('user_dev_uid_12345', 'user@mail.com', 'User Cervecero', 'user');

INSERT INTO users (firebase_uid, email, name, role) 
VALUES ('D9EOG4uUJFUej5hnKMVOKHzciQB2', 'user_2@mail.com', 'User 2', 'user');


INSERT INTO users (firebase_uid, email, name, role) 
VALUES ('kqlXXM4a7YPorAarZj72N5k79pF2', 'user_3@mail.com', 'User 3', 'user');


-- equipos

-- Tabla para el desplegable de Equipos
CREATE TABLE equipment (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla para el desplegable de Materiales
CREATE TABLE materials (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla para el desplegable de Tipos
CREATE TABLE types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO types (name) VALUES 
('Isobárico'), ('Atmosférico'), ('Rodillos'), ('Discos'), ('Martillos'), ('Piedra'), ('Serpentín'), ('Placas'), ('Manguera flexible'), ('Tubería rígida'), ('Cornelius (Corny)'), ('Sankey'), ('Europeo'), ('Tipo G'), ('Piedra difusora'), ('Carbonatador inline'), ('Tanque de carbonatación'), ('Cartucho'), ('Inoxidable'), ('Placas y marcos');

-- Tabla intermedia para Equipos y Materiales que establece una relación many-to-many
CREATE TABLE equipment_materials (
    equipment_id INT REFERENCES equipment(id) ON DELETE CASCADE,
    material_id INT REFERENCES materials(id) ON DELETE CASCADE,
    PRIMARY KEY (equipment_id, material_id)
);

-- Tabla intermedia para Equipos y Tipos que establece una relación many-to-many
CREATE TABLE equipment_types (
    equipment_id INT REFERENCES equipment(id) ON DELETE CASCADE,
    type_id INT REFERENCES types(id) ON DELETE CASCADE,
    PRIMARY KEY (equipment_id, type_id)
);

-- Fermentador
INSERT INTO equipment_types (equipment_id, type_id) VALUES 
(1, 1), (1, 2);

--Molino de cebada
INSERT INTO equipment_types (equipment_id, type_id) VALUES 
(2, 3), (2, 4), (2, 5), (2, 6);

--Intercambiador de calor
INSERT INTO equipment_types (equipment_id, type_id) VALUES 
(5, 7), (5, 8);

--Mangueras y tuberías
INSERT INTO equipment_types (equipment_id, type_id) VALUES 
(7, 9), (7, 10);

--Barriles / Kegs
INSERT INTO equipment_types (equipment_id, type_id) VALUES 
(8, 11), (8, 12), (8, 13), (8, 14);

--Carbonatadores de cerveza
INSERT INTO equipment_types (equipment_id, type_id) VALUES 
(9, 15), (9, 16), (9, 17);

--Filtros
INSERT INTO equipment_types (equipment_id, type_id) VALUES 
(11, 18), (11, 19), (11, 20);



-- 3. Tabla de Protocolos (La que crece con el usuario)
CREATE TABLE user_protocols (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(128) REFERENCES users(firebase_uid) ON DELETE CASCADE,
    equipment_id INT REFERENCES equipment(id) ON DELETE CASCADE,
    type_id INT REFERENCES types(id) ON DELETE SET NULL,
    material_id INT REFERENCES materials(id) ON DELETE CASCADE,
    protocol_code VARCHAR(100) UNIQUE NOT NULL,
    volume_liters FLOAT NOT NULL,
    has_cip BOOLEAN DEFAULT FALSE
);

-- llenando las tablas de desplegable
INSERT INTO equipment (name) VALUES 
('Fermentador'), ('Molino de cebada'), ('Olla de calentado de agua'), ('Olla de maceración'), ('Intercambiador de calor'), ('Sifón cervecero'), ('Mangueras y tuberías'), ('Barriles / Kegs'), ('Carbonatadores de cerveza'), ('Bombas de trasiego'), ('Filtros');

INSERT INTO materials (name) VALUES 
('Acero inoxidable'), ('Acero inoxidable 304'), ('Acero inoxidable 316'), ('Acero al carbono'), ('Acrílico'), ('Aluminio'), ('Carbón'), ('Cerámica (piedra difusora)'), ('Hierro fundido'), ('Papel / Celulosa'), ('Piedra'), ('Plástico (PP / PU / PE)'), ('PET'),('PVC grado alimentario'), ('Silicona grado alimentario'), ('Plástico alimentario');

-- Fermentador
INSERT INTO equipment_materials (equipment_id, material_id) VALUES 
(1, 2), (1, 3), (1, 12), (1,13);

-- Molino de cebada
INSERT INTO equipment_materials (equipment_id, material_id) VALUES 
(2, 4), (2, 2), (2, 6), (2,9), (2, 11);

-- Olla de calentado de agua
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (3,2), (3,3);

-- Olla de maceración
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (4,2), (4,3);

-- Intercambiador de calor
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (5,2), (5,3);

-- Sifón cervecero
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (6,2), (6,3), (6, 5), (6, 12);

-- Mangueras y tuberías
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (7,2), (7,3), (7, 12), (7, 14), (7, 15);

-- Barriles / Kegs
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (8,1), (8,6);
 
-- Carbonatadores de cerveza
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (9,2), (9,3), (9, 8);

-- Bombas de trasiego
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (10,1), (10, 16);

-- Filtros
INSERT INTO equipment_materials (equipment_id, material_id) VALUES
 (11,1), (11,7) , (11, 10);


-- Tabla protocol_steps
CREATE TABLE protocol_steps (
    id SERIAL PRIMARY KEY,
    equipment_id INT REFERENCES equipment(id) ON DELETE CASCADE,
    material_id INT REFERENCES materials(id) ON DELETE CASCADE,
    step_number INT NOT NULL, -- 0, 1, 2...
    step_name VARCHAR(100) NOT NULL, 
    description TEXT NOT NULL,
    requires_cip BOOLEAN DEFAULT NULL -- TRUE: solo con CIP, FALSE: solo Manual, NULL: Ambos
);


-- Índices para que la búsqueda por equipo y material sea ultra rápida
CREATE INDEX idx_protocol_equipment ON protocol_steps(equipment_id);
CREATE INDEX idx_protocol_material ON protocol_steps(material_id);

-- ==========================================
-- FERMENTADOR ACERO INOXIDABLE 304 (ID MATERIALS: 2)
-- ==========================================

-- PASOS QUE SON IGUALES (CON Y SIN CIP)
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES 
(1, 2, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} Kg de detergente para {{volumen}} litros de agua.', NULL),
(1, 2, 5, 'Desinfección', 'ALKLEAN POWER actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', NULL),
(1, 2, 6, 'Enjuague final', 'Enjuaga el tanque con agua fría para eliminar los residuos de la solución cáustica y prevenir contaminaciones.', NULL);


-- PASOS QUE CAMBIAN SI TIENE CIP (TRUE)
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES 
(1, 2, 1, 'Inicio de la limpieza', 'Drena cualquier resto de cerveza o sedimento de levadura del tanque y enjuaga el interior con agua tibia para eliminar residuos sueltos.', TRUE),
(1, 2, 2, 'Enjuague primario', 'Enjuaga el tanque con agua tibia a través del sistema CIP para eliminar partículas restantes y preparar el tanque para la limpieza.', TRUE),
(1, 2, 3, 'Lavado alcalino', 'Añade el detergente de limpieza ALKLEAN al sistema CIP y recircula la solución por el sistema CIP durante 30 minutos a una temperatura aproximada de 40-50°C. Asegúrate de que entre en contacto con todas las superficies interiores para descomponer los residuos orgánicos.', TRUE),
(1, 2, 4, 'Enjuague secundario', 'Enjuaga el tanque con agua caliente para eliminar los residuos de la solución cáustica y prevenir la contaminación.', TRUE),
(1, 2, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no
queden residuos y cierra todas las conexiones del tanque de forma segura
para prepararlo para el siguiente lote.', TRUE);

-- PASOS QUE CAMBIAN SI NO TIENE CIP (FALSE)
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES 
(1, 2, 1, 'Inicio de la limpieza', 'Retira válvulas, empaques (gomas/elastómeros) y accesorios. El producto es seguro para estos materiales.', FALSE),
(1, 2, 2, 'Enjuague primario', 'Enjuaga el equipo con agua a presión para eliminar residuos de levadura, lúpulo o azúcares.', FALSE),
(1, 2, 3, 'Lavado alcalino', 'Aplica la solución con un cepillo de cerdas suaves o paño, asegurando que todas las paredes internas queden cubiertas. Para zonas con incrustaciones difíciles, deja actuar la solución por 30 minutos antes de frotar. Si el equipo es pequeño, la inmersión total es la técnica más efectiva para asegurar que el desinfectante llegue a cada rincón.', FALSE),
(1, 2, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE),
(1, 2, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no queden residuos y deja secar al aire en un ambiente limpio o ensambla y mantén cerrado.', FALSE);


-- ==========================================
-- FERMENTADOR ACERO INOXIDABLE 316 (ID: 4)
-- (Repetición exacta para mantener independencia)
-- ==========================================

-- PASOS QUE SON IGUALES (CON Y SIN CIP)
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES 
(1, 3, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} Kg de detergente para {{volumen}} litros de agua.', NULL),
(1, 3, 5, 'Desinfección', 'ALKLEAN POWER actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', NULL),
(1, 3, 6, 'Enjuague final', 'Enjuaga el tanque con agua fría para eliminar los residuos de la solución cáustica y prevenir contaminaciones.', NULL);


-- PASOS QUE CAMBIAN SI TIENE CIP (TRUE)
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES 
(1, 3, 1, 'Inicio de la limpieza', 'Drena cualquier resto de cerveza o sedimento de levadura del tanque y enjuaga el interior con agua tibia para eliminar residuos sueltos.', TRUE),
(1, 3, 2, 'Enjuague primario', 'Enjuaga el tanque con agua tibia a través del sistema CIP para eliminar partículas restantes y preparar el tanque para la limpieza.', TRUE),
(1, 3, 3, 'Lavado alcalino', 'Añade el detergente de limpieza ALKLEAN al sistema CIP y recircula la solución por el sistema CIP durante 30 minutos a una temperatura aproximada de 40-50°C. Asegúrate de que entre en contacto con todas las superficies interiores para descomponer los residuos orgánicos.', TRUE),
(1, 3, 4, 'Enjuague secundario', 'Enjuaga el tanque con agua caliente para eliminar los residuos de la solución cáustica y prevenir la contaminación.', TRUE),
(1, 3, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no
queden residuos y cierra todas las conexiones del tanque de forma segura
para prepararlo para el siguiente lote.', TRUE);

-- PASOS QUE CAMBIAN SI NO TIENE CIP (FALSE)
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES 
(1, 3, 1, 'Inicio de la limpieza', 'Retira válvulas, empaques (gomas/elastómeros) y accesorios. El producto es seguro para estos materiales.', FALSE),
(1, 3, 2, 'Enjuague primario', 'Enjuaga el equipo con agua a presión para eliminar residuos de levadura, lúpulo o azúcares.', FALSE),
(1, 3, 3, 'Lavado alcalino', 'Aplica la solución con un cepillo de cerdas suaves o paño, asegurando que todas las paredes internas queden cubiertas. Para zonas con incrustaciones difíciles, deja actuar la solución por 30 minutos antes de frotar. Si el equipo es pequeño, la inmersión total es la técnica más efectiva para asegurar que el desinfectante llegue a cada rincón.', FALSE),
(1, 3, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE),
(1, 3, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no queden residuos y deja secar al aire en un ambiente limpio o ensambla y mantén cerrado.', FALSE);

-- ==========================================
-- FERMENTADOR PLÁSTICO PP / PU / PE (ID MATERIALS: 12)
-- NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(1, 12, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', FALSE),
(1, 12, 1, 'Inicio de la limpieza', 'Retira válvulas, empaques (gomas/elastómeros) y accesorios. El producto es seguro para estos materiales. Sumérgelos en un balde con la misma solución al 2% durante el mismo tiempo que el fermentador.', FALSE),
(1, 12, 2, 'Enjuague primario', 'Enjuaga el fermentador con agua a temperatura ambiente para eliminar los restos gruesos de levadura y sedimentos del fondo. No utilices agua a más de 50°C para evitar deformar o estresar el plástico.', FALSE),
(1, 12, 3, 'Lavado alcalino', 'Vierte la solución preparada en el fermentador. Puedes realizar un llenado total o un lavado manual con un paño suave o esponja no abrasiva. Nunca uses fibras metálicas o cepillos de cerdas duras, ya que las rayas en el plástico son focos de contaminación imposibles de esterilizar después. Deja actuar la solución por un mínimo de 30 minutos.', FALSE),
(1, 12, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE),
(1, 12, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', FALSE),
(1, 12, 6, 'Enjuague final', 'Enjuaga el tanque con agua fría para eliminar los residuos de la solución cáustica y prevenir la contaminación.', FALSE),
(1, 12, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no
queden residuos y deja secar al aire en un ambiente limpio o ensambla y
mantén cerrado.', FALSE);

-- ==========================================
-- FERMENTADOR PET (ID MATERIALS: 13)
-- NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(1, 13, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', FALSE),
(1, 13, 1, 'Inicio de la limpieza', 'Retira válvulas, empaques (gomas/elastómeros) y accesorios. El producto es seguro para estos materiales. Sumérgelos en un balde con la misma solución al 2% durante el mismo tiempo que el fermentador.', FALSE),
(1, 13, 2, 'Enjuague primario', 'Enjuaga el fermentador con agua a temperatura ambiente para eliminar los restos gruesos de levadura y sedimentos del fondo. No utilices agua a más de 50°C para evitar deformar o estresar el plástico.', FALSE),
(1, 13, 3, 'Lavado alcalino', 'Vierte la solución preparada en el fermentador. Puedes realizar un llenado total o un lavado manual con un paño suave o esponja no abrasiva. Nunca uses fibras metálicas o cepillos de cerdas duras, ya que las rayas en el plástico son focos de contaminación imposibles de esterilizar después. Deja actuar la solución por un mínimo de 30 minutos.', FALSE),
(1, 13, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE),
(1, 13, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', FALSE),
(1, 13, 6, 'Enjuague final', 'Enjuaga el tanque con agua fría para eliminar los residuos de la solución cáustica y prevenir la contaminación.', FALSE),
(1, 13, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no
queden residuos y deja secar al aire en un ambiente limpio o ensambla y
mantén cerrado.', FALSE);