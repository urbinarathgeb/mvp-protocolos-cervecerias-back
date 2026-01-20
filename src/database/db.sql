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
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla para el desplegable de Materiales
CREATE TABLE materials (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- 3. Tabla de Equipos (La que crece con el usuario)
CREATE TABLE user_protocols (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(128) REFERENCES users(firebase_uid),
    codigo_interno VARCHAR(20) NOT NULL, -- El identificador único (Ej: FERM-01)
    nombre_personalizado VARCHAR(100),   -- El nombre que el usuario quiera
    categoria_id INT REFERENCES categorias_equipo(id),
    material_id INT REFERENCES materiales(id),
    volumen_litros FLOAT NOT NULL,       -- El número manual que el usuario ingresa
    tiene_cip BOOLEAN DEFAULT FALSE      -- Si tiene o no sistema de limpieza CIP
);

-- llenando las tablas de desplegable
INSERT INTO categorias_equipo (nombre) VALUES 
('Fermentador'), ('Molino'), ('Mangueras y tuberías'), ('Olla de cocción'), ('Refrigerador');

INSERT INTO materiales (nombre) VALUES 
('Acero Inoxidable'), ('Plástico (Vinilo/PVC)'), ('Cobre'), ('Vidrio');