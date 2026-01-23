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

-- Tabla para el desplegable de Categorías
CREATE TABLE equipment (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla para el desplegable de Materiales
CREATE TABLE materials (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla intermedia para Equipos y Materiales que establece una relación many-to-many
CREATE TABLE equipment_materials (
    equipment_id INT REFERENCES equipment(id) ON DELETE CASCADE,
    material_id INT REFERENCES materials(id) ON DELETE CASCADE,
    PRIMARY KEY (equipment_id, material_id)
);

-- 3. Tabla de Equipos (La que crece con el usuario)
CREATE TABLE user_protocols (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(128) REFERENCES users(firebase_uid),
    codigo_interno VARCHAR(20) NOT NULL, -- El identificador único (Ej: FERM-01)
    nombre_personalizado VARCHAR(100),   -- El nombre que el usuario quiera
    categoria_id INT REFERENCES equipment(id),
    material_id INT REFERENCES materials(id),
    volumen_litros FLOAT NOT NULL,       -- El número manual que el usuario ingresa
    tiene_cip BOOLEAN DEFAULT FALSE      -- Si tiene o no sistema de limpieza CIP
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
