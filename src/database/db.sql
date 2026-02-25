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

-- FECHA 14-02
-- SEE AGREGA COLUMNA CONCENTRACIÓN PARA EL DETERGENTE, YA QUE AHORA 2%
--NO ES UN ESTÁNDAR Y DEPENDE DEL EQUIPO Y MATERIAL.
ALTER TABLE equipment_materials
ADD COLUMN concentration DECIMAL(4,3) DEFAULT 0.020;


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

 --Airlock
 INSERT INTO equipment_materials (equipment_id, material_id, concentration) VALUES
 (12,5, 0.010), (12,12, 0.020) , (12, 17, 0.020);

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
    protocol_code VARCHAR(100) NOT NULL,
    volume_liters FLOAT NOT NULL,
    has_cip BOOLEAN DEFAULT FALSE,
    detergent_concentration FLOAT DEFAULT 0,
    UNIQUE (user_id, protocol_code)
);

-- llenando las tablas de desplegable
INSERT INTO equipment (name) VALUES
('Fermentador'), ('Molino de cebada'), ('Olla de calentado de agua'), ('Olla de maceración'), ('Intercambiador de calor'), ('Sifón cervecero'), ('Mangueras y tuberías'), ('Barriles / Kegs'), ('Carbonatadores de cerveza'), ('Bombas de trasiego'), ('Filtros'), ('Airlock');

INSERT INTO materials (name) VALUES
('Acero inoxidable'), ('Acero inoxidable 304'), ('Acero inoxidable 316'), ('Acero al carbono'), ('Acrílico'), ('Aluminio'), ('Carbón'), ('Cerámica (piedra difusora)'), ('Hierro fundido'), ('Papel / Celulosa'), ('Piedra'), ('Plástico (PP / PU / PE)'), ('PET'),('PVC grado alimentario'), ('Silicona grado alimentario'), ('Plástico alimentario'), ('Vidrio');




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

-- ==========================================
-- MOLINO DE CEBADA (ID EQUIPMENT: 2)
-- TYPE - PIEDRA
-- MATERIAL - PIEDRA (ID MATERIAL: 11)
-- NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(2, 11, 0, 'Preparación del eqiopo', 'Detener el molino, desconectar de la fuente de energía y aplicar bloqueo/etiquetado. Abrir el molino y exponer la piedra de molienda y las superficies internas de la carcasa. Asegurarse de tener a mano las herramientas permitidas (brochas de nylon, espátulas plásticas y aspiradora HEPA).', FALSE),
(2, 11, 1, 'Inicio de la limpieza', 'Barrer con brocha de cerdas naturales o nylon la superficie activa, ranuras y bordes. Utilizar aspiradora industrial con filtro HEPA para retirar el polvo suelto. Remover únicamente con espátula plástica o raspador de madera (prohibido usar herramientas metálicas, alcohol o aceites en la piedra).', FALSE),
(2, 11, 2, 'Inspección', 'Revisar visualmente la superficie en busca de acumulación de grasa natural del grano, microfisuras o zonas apelmazadas que afecten la molienda. Confirmar que no queden restos de humedad en los ejes o carcasas. Cerrar el equipo, retirar el bloqueo y registrar la actividad indicando la frecuencia (diaria o por cambio de lote).', FALSE);

-- ==========================================
-- MOLINO DE CEBADA (ID EQUIPMENT: 2)
-- TYPE - RODILLO
-- MATERIAL - ALUMINIO (ID MATERIAL: 6)
-- NO TIENE CIP
-- ==========================================
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(2, 6, 0, 'Preparación del equipo', 'Detener el molino, desconectar de la fuente de energía y aplicar bloqueo/etiquetado. Abrir el molino y exponer la piedra de molienda y las superficies internas de la carcasa. Asegurarse de tener a mano las herramientas permitidas (brochas de nylon, espátulas plásticas y aspiradora HEPA).', FALSE),
(2, 6, 1, 'Inicio de la limpieza', 'Cepillar con brocha muy suave para remover restos de grano. Aspirar los residuos para evitar que entren en los rodamientos. Usar un paño apenas humedecido con alcohol isopropílico y secar de inmediato. Limpiar con paño seco. Solo en estas partes de acero/hierro se permite el uso de alcohol o detergente si es estrictamente necesario. No aplicar ALKLEAN ni ningún producto alcalino sobre los rodillos, ya que el aluminio es sensible a la corrosión.', FALSE),
(2, 6, 2, 'Inspección', 'Revisar visualmente la superficie en busca de acumulación de grasa natural del grano, microfisuras o zonas apelmazadas que afecten la molienda. Confirmar que no queden restos de humedad en los ejes o carcasas. Cerrar el equipo, retirar el bloqueo y registrar la actividad indicando la frecuencia (diaria o por cambio de lote).', FALSE );

-- ==========================================
-- MOLINO DE CEBADA (ID EQUIPMENT: 2)
-- TYPE - RODILLO
-- MATERIAL - ACERO INOXIDABLE 304 (ID MATERIAL: 2)
-- NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(2, 2, 0, 'Preparación del equipo', 'Detener el molino, desconectar de la fuente de energía y aplicar bloqueo/etiquetado. Abrir el molino y exponer la piedra de molienda y las superficies internas de la carcasa. Asegurarse de tener a mano las herramientas permitidas (brochas de nylon, espátulas plásticas y aspiradora HEPA).', FALSE),
(2, 2, 1, 'Inicio de la limpieza', 'Realizar un cepillado en seco vigoroso con nylon medio para desprender restos de grano y harina. Eliminar todo el polvo residual con filtro HEPA. En caso de grasa de grano adherida, utilizar un paño con alcohol isopropílico. Si el fabricante lo autoriza, aplicar una capa mínima de aceite grado alimentario para protección post-limpieza.', FALSE),
(2, 2, 2, 'Inspección', 'Revisar visualmente la superficie en busca de acumulación de grasa natural del grano, microfisuras o zonas apelmazadas que afecten la molienda. Confirmar que no queden restos de humedad en los ejes o carcasas. Cerrar el equipo, retirar el bloqueo y registrar la actividad indicando la frecuencia (diaria o por cambio de lote).', FALSE);

-- ==========================================
-- MOLINO DE CEBADA (ID EQUIPMENT: 2)
-- TYPE - RODILLO
-- MATERIAL - ACERO AL CARBONO (ID MATERIAL: 4)
-- NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(2, 4, 0, 'Preparación del equipo', 'Detener el molino, desconectar de la fuente de energía y aplicar bloqueo/etiquetado. Abrir el molino y exponer la piedra de molienda y las superficies internas de la carcasa. Asegurarse de tener a mano las herramientas permitidas (brochas de nylon, espátulas plásticas y aspiradora HEPA).', FALSE),
(2, 4, 1, 'Inicio de la limpieza', 'Cepillar los rodillos con nylon y aspirar inmediatamente. Aspirar es superior al aire comprimido, ya que este último dispersa partículas hacia los rodamientos. Si hay grasa seca, usar paño con alcohol isopropílico de aplicación rápida y secar completamente. Aplicar una película muy fina de aceite grado alimentario. Retirar el exceso con un pañoo seco para que no afecte el flujo del grano; nunca dejar el metal expuesto al aire sin protección.', FALSE),
(2, 4, 2, 'Inspección', 'Revisar visualmente la superficie en busca de acumulación de grasa natural del grano, microfisuras o zonas apelmazadas que afecten la molienda. Confirmar que no queden restos de humedad en los ejes o carcasas. Cerrar el equipo, retirar el bloqueo y registrar la actividad indicando la frecuencia (diaria o por cambio de lote).', FALSE);

-- ==========================================
-- OLLA DE CALENTADO (ID EQUIPMENT: 3)
-- MATERIAL - ACERO INOXIDABLE 304 (ID MATERIAL: 2)
-- ==========================================

-- CON CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(3, 2, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2 %. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua. Agregar siempre el producto al agua de forma espolvoreada, nunca el agua al producto.', TRUE ),
(3, 2, 1, 'Inicio de la limpieza', 'Drena cualquier resto de cerveza o sedimento de levadura del tanque y enjuaga el interior con agua tibia para eliminar residuos sueltos.', TRUE),
(3, 2, 2, 'Enjuague primario', 'Enjuaga el tanque con agua tibia a través del sistema CIP para eliminar partículas restantes y preparar el tanque para la limpieza.', TRUE),
(3, 2, 3, 'Lavado Alcalino', 'Añade el detergente de limpieza ALKLEAN al sistema CIP. Recircula la solución por el sistema CIP durante 30 minutos a una temperatura aproximada de 40-50°C. Asegúrate de que entre en contacto con todas las superficies interiores para descomponer los residuos orgánicos.', TRUE),
(3, 2, 4, 'Enjuague secundario', 'Enjuaga el tanque con agua caliente para eliminar los residuos de la solución cáustica y prevenir la contaminación.', TRUE),
(3, 2, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no queden residuos y cierra todas las conexiones del tanque de forma segura para prepararlo para el siguiente lote.', TRUE);

-- SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(3, 2, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN se recomienda una concentración aproximada del 2 %. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', FALSE),
(3, 2, 1, 'Inicio de la limpieza', 'Retira v´alvulas, empaques (gomas/elastómeros) y accesorios. El producto es seguro para estos materiales.', FALSE),
(3, 2, 2, 'Enjuague primario', 'Enjuaga el equipo con agua a presión para eliminar residuos de levadura, lúpulo o azúcares.', FALSE),
(3, 2, 3, 'Lavado alcalino', 'Aplica la solución con un cepillo de cerdas suaves o paño, asegurando que todas las paredes internas queden cubiertas. Para zonas con incrustaciones difíciles, deja actuar la solución por 30 minutos antes de frotar. Si el equipo es pequeño, la inmersión total es la técnica más efectiva para asegurar que el desinfectante llegue a cada rincón.', FALSE),
(3, 2, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE),
(3, 2, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no queden residuos y deja secar al aire en un ambiente limpio o ensambla y mantén cerrado.', FALSE);

-- CON Y SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(3, 2, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', NULL ),
(3, 2, 6, 'Enjuague final', 'Enjuaga el tanque con agua fría para eliminar los residuos de la solución cáustica y prevenir la contaminación.', NULL);

-- ==========================================
-- OLLA DE MACERACIÓN (ID EQUIPMENT: 4)
-- MATERIAL - ACERO INOXIDABLE 304 (ID MATERIAL: 2)
-- ==========================================

-- CON CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(4, 2, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua. Agregar siempre el producto al agua de forma espolvoreada, nunca el agua al producto.', TRUE),
(4, 2, 1, 'Inicio de la limpieza', 'Drena cualquier resto de cerveza o sedimento de levadura del tanque y enjuaga el interior con agua tibia para eliminar residuos sueltos.', TRUE),
(4, 2, 2, 'Enjuague primario', 'Enjuaga el tanque con agua tibia a través del sistema CIP para eliminar partículas restantes y preparar el tanque para la limpieza.', TRUE ),
(4, 2, 3, 'Lavado alcalino', 'Añade el detergente de limpieza ALKLEAN al sistema CIP. Recircula la solución por el sistema CIP durante 30 minutos a una temperatura aproximada de 40-50°C. Asegúrate de que entre en contacto con todas las superficies interiores para descomponer los residuos orgánicos.', TRUE),
(4, 2, 4, 'Enjuague secundario', 'Enjuaga el tanque con agua caliente para eliminar los residuos de la solución cáustica y prevenir la contaminación.', TRUE),
(4, 2, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no queden residuos y cierra todas las conexiones del tanque de forma segura para prepararlo para el siguiente lote.', TRUE);

-- SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(4, 2, 0,'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', FALSE),
(4, 2, 1, 'Inicio de la limpieza', 'Retira válvulas, empaques (gomas/elastómeros) y accesorios. El producto es seguro para estos materiales.', FALSE),
(4, 2, 2, 'Enjuague primario', 'Enjuaga el equipo con agua a presión para eliminar residuos de levadura, lúpulo o azúcares.', FALSE),
(4, 2, 3, 'Lavado alcalino', 'Aplica la solución con un cepillo de cerdas suaves o paño, asegurando que todas las paredes internas queden cubiertas. Para zonas con incrustaciones difíciles, deja actuar la solución por 30 minutos antes de frotar. Si el equipo es pequeñoo, la inmersión total es la técnica más efectiva para asegurar que el desinfectante llegue a cada rincón.', FALSE),
(4, 2, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE),
(4, 2, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no queden residuos y deja secar al aire en un ambiente limpio o ensambla y mantén cerrado.', FALSE);

-- CON Y SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(4, 2, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', NULL),
(4, 2, 6, 'Enjuague final', 'Enjuaga el tanque con agua fría para eliminar los residuos de la solución cáustica y prevenir la contaminación.', NULL);

-- ==========================================
-- OLLA DE MACERACIÓN (ID EQUIPMENT: 4)
-- MATERIAL - ACERO INOXIDABLE 316 (ID MATERIAL: 3)
-- ==========================================

-- CON CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(4, 3, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua. Agregar siempre el producto al agua de forma espolvoreada, nunca el agua al producto.', TRUE),
(4, 3, 1, 'Inicio de la limpieza', 'Drena cualquier resto de cerveza o sedimento de levadura del tanque y enjuaga el interior con agua tibia para eliminar residuos sueltos.', TRUE),
(4, 3, 2, 'Enjuague primario', 'Enjuaga el tanque con agua tibia a través del sistema CIP para eliminar partículas restantes y preparar el tanque para la limpieza.', TRUE ),
(4, 3, 3, 'Lavado alcalino', 'Añade el detergente de limpieza ALKLEAN al sistema CIP. Recircula la solución por el sistema CIP durante 30 minutos a una temperatura aproximada de 40-50°C. Asegúrate de que entre en contacto con todas las superficies interiores para descomponer los residuos orgánicos.', TRUE),
(4, 3, 4, 'Enjuague secundario', 'Enjuaga el tanque con agua caliente para eliminar los residuos de la solución cáustica y prevenir la contaminación.', TRUE),
(4, 3, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no queden residuos y cierra todas las conexiones del tanque de forma segura para prepararlo para el siguiente lote.', TRUE);

-- SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(4, 3, 0,'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', FALSE),
(4, 3, 1, 'Inicio de la limpieza', 'Retira válvulas, empaques (gomas/elastómeros) y accesorios. El producto es seguro para estos materiales.', FALSE),
(4, 3, 2, 'Enjuague primario', 'Enjuaga el equipo con agua a presión para eliminar residuos de levadura, lúpulo o azúcares.', FALSE),
(4, 3, 3, 'Lavado alcalino', 'Aplica la solución con un cepillo de cerdas suaves o paño, asegurando que todas las paredes internas queden cubiertas. Para zonas con incrustaciones difíciles, deja actuar la solución por 30 minutos antes de frotar. Si el equipo es pequeñoo, la inmersión total es la técnica más efectiva para asegurar que el desinfectante llegue a cada rincón.', FALSE),
(4, 3, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE),
(4, 3, 7, 'Inspección', 'Inspecciona el interior del tanque para verificar que no queden residuos y deja secar al aire en un ambiente limpio o ensambla y mantén cerrado.', FALSE);

-- CON Y SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(4, 3, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', NULL),
(4, 3, 6, 'Enjuague final', 'Enjuaga el tanque con agua fría para eliminar los residuos de la solución cáustica y prevenir la contaminación.', NULL);

-- ==========================================
-- INTERCAMBIADOR DE CALOR (ID EQUIPMENT: 5)
-- TYPE: PLACAS (ID TYPE:)
-- MATERIAL - ACERO INOXIDABLE 304 (ID MATERIAL: 2)
-- ==========================================

-- CON CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(5, 2, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua. Agregar siempre el producto al agua de forma espolvoreada, nunca el agua al producto.', TRUE),
(5, 2, 1, 'Inicio de la limpieza', 'Aislar el intercambiador del resto del sistema. Conectar las mangueras de recirculación en sentido inverso al flujo normal (backwash) para ayudar a desprender partículas atrapadas entre las placas.', TRUE),
(5, 2, 2, 'Enjuague primario', 'Circular agua tibia (máximo 50°C) para arrastrar los restos de mosto y sedimentos sueltos hasta que el agua salga clara.', TRUE),
(5, 2, 3, 'Lavado Alcalino', 'A˜nade el detergente de limpieza ALKLEAN al sistema CIP. Recircula la solución por el sistema CIP durante 30 minutos a una temperatura aproximada de 40-50°C. Asegúrate de que entre en contacto con todas las superficies interiores para descomponer los residuos orgánicos.', TRUE),
(5, 2, 4, 'Enjuague secundario', 'Circular agua potable para eliminar los restos del detergente alcalino.', TRUE);


-- SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(5, 2, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', FALSE),
(5, 2, 1, 'Inicio de la limpieza', 'Desajustar los pernos de compresión de forma simétrica. Marcar las placas con una línea diagonal exterior para asegurar que se reensamblen en el mismo orden y posición.', FALSE),
(5, 2, 2, 'Enjuague primario', 'Separar las placas una a una y aplicar agua a presiÓn para retirar el grueso del sedimento o ”piedra de cerveza”.', FALSE),
(5, 2, 3, 'Lavado alcalino', 'Sumergir las placas en la solución de ALKLEAN POWER durante 30 minutos. El poder oxidante desprenderá las proteínas pegadas sin necesidad de tallado abrasivo.', FALSE),
(5, 2, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE);

--CON Y SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(5, 2, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', NULL),
(5, 2, 6, 'Enjuague final', 'Realizar un Último paso con agua potable hasta asegurar un pH neutro (7-8).', NULL),
(5, 2, 7, 'Inspección', 'Revisar que los sellos no estén deformados o resecos. Reensamblar el equipo apretando los pernos hasta la medida de compresión especificada por el fabricante.', NULL);


-- ==========================================
-- INTERCAMBIADOR DE CALOR (ID EQUIPMENT: 5)
-- TYPE: PLACAS (ID TYPE:)
-- MATERIAL - ACERO INOXIDABLE 304 (ID MATERIAL: 3)
-- ==========================================

-- CON CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(5, 3, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua. Agregar siempre el producto al agua de forma espolvoreada, nunca el agua al producto.', TRUE),
(5, 3, 1, 'Inicio de la limpieza', 'Aislar el intercambiador del resto del sistema. Conectar las mangueras de recirculación en sentido inverso al flujo normal (backwash) para ayudar a desprender partículas atrapadas entre las placas.', TRUE),
(5, 3, 2, 'Enjuague primario', 'Circular agua tibia (máximo 50°C) para arrastrar los restos de mosto y sedimentos sueltos hasta que el agua salga clara.', TRUE),
(5, 3, 3, 'Lavado Alcalino', 'A˜nade el detergente de limpieza ALKLEAN al sistema CIP. Recircula la solución por el sistema CIP durante 30 minutos a una temperatura aproximada de 40-50°C. Asegúrate de que entre en contacto con todas las superficies interiores para descomponer los residuos orgánicos.', TRUE),
(5, 3, 4, 'Enjuague secundario', 'Circular agua potable para eliminar los restos del detergente alcalino.', TRUE);

-- SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(5, 3, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 2%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', FALSE),
(5, 3, 1, 'Inicio de la limpieza', 'Desajustar los pernos de compresión de forma simétrica. Marcar las placas con una línea diagonal exterior para asegurar que se reensamblen en el mismo orden y posición.', FALSE),
(5, 3, 2, 'Enjuague primario', 'Separar las placas una a una y aplicar agua a presiÓn para retirar el grueso del sedimento o ”piedra de cerveza”.', FALSE),
(5, 3, 3, 'Lavado alcalino', 'Sumergir las placas en la solución de ALKLEAN POWER durante 30 minutos. El poder oxidante desprenderá las proteínas pegadas sin necesidad de tallado abrasivo.', FALSE),
(5, 3, 4, 'Enjuague secundario', 'Enjuaga con abundante agua limpia. Controla con tiras de pH hasta que el agua de salida marque un pH neutro (entre 7 y 8) para asegurar que no hay residuos del detergente.', FALSE);

--CON Y SIN CIP
INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(5, 3, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', NULL),
(5, 3, 6, 'Enjuague final', 'Realizar un Último paso con agua potable hasta asegurar un pH neutro (7-8).', NULL),
(5, 3, 7, 'Inspección', 'Revisar que los sellos no estén deformados o resecos. Reensamblar el equipo apretando los pernos hasta la medida de compresión especificada por el fabricante.', NULL);

-- ==========================================
-- AIRLOCK (ID EQUIPMENT: 12)
-- MATERIAL - ARÍLICO (ID MATERIAL: 5)
-- NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(12, 5, 0, 'Preparación del detergente', 'Se recomienda una concentración aproximada del 1%, agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua A 35ºC.', FALSE),
(12, 5, 1, 'Inicio de la limpieza', 'Desarmar completamente (cuerpo, tapa, flotador) y retirar residuos de levadura o krausen inmediatamente tras su uso.', FALSE),
(12, 5, 2, 'Enjuague primario', 'Enjuagua todas las piezas con agua potable a temperatura ambiente para eliminar residuos gruesos y solubles.', FALSE),
(12, 5, 3, 'Lavado alcalino', 'Sumerje las piezas en la solución detergente preparada y lava manualmente con un paño de microfibra o esponja suave. Deja actuar la solución por máximo 10 minutos. Prohibido: fibras metálicas, abrasivos o solventes agresivos. Evitar uso de alcohol.', FALSE),
(12, 5, 4, 'Enjuague secundario', 'Enjuaga con abundante agua potable hasta eliminar completamente residuos de detergente. Verifica ausencia de espuma.', FALSE),
(12, 5, 5, 'Desinfección', 'Aplica un desinfectante grado alimentario compatible con el material (ácido peracético, iodóforo o amonio cuaternario autorizado).', FALSE),
(12, 5, 6, 'Enjuague final', 'Realiza enjuague final solo si el desinfectante no es no-rinse. Utiliza agua potable fría.', FALSE),
(12, 5, 7, 'Inspección', 'Inspeccione visualmente: Limpieza total, Transparencia del material, Ausencia de olores, rayaduras o fisuras. Registra la limpieza según plan de saneamiento.', FALSE);

-- ==========================================
-- AIRLOCK (ID EQUIPMENT: 12)
-- MATERIAL - VIDRIO (ID MATERIAL: 17)
-- NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(12, 17, 0, 'Preparación del detergente', 'Se recomienda una concentración aproximada del 2%, agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua A 50ºC.', FALSE),
(12, 17, 1, 'Inicio de la limpieza', 'Desarmar completamente (cuerpo, tapa, flotador) y retirar residuos de levadura o krausen inmediatamente tras su uso.', FALSE),
(12, 17, 2, 'Enjuague primario', 'Enjuagua todas las piezas con agua potable a temperatura ambiente para eliminar residuos gruesos y solubles.', FALSE),
(12, 17, 3, 'Lavado alcalino', 'Sumerje las piezas en la solución detergente preparada y lava manualmente con una escobilla adecuada al diámetro. Deja actuar la solución durante 15-20 minutos. Prohibido: fibras metálicas, abrasivos o solventes agresivos. Evitar uso de alcohol.', FALSE),
(12, 17, 4, 'Enjuague secundario', 'Enjuaga con abundante agua potable hasta eliminar completamente residuos de detergente. Verifica ausencia de espuma.', FALSE),
(12, 17, 5, 'Desinfección', 'Aplica un desinfectante grado alimentario compatible con el material (ácido peracético, iodóforo o amonio cuaternario autorizado).', FALSE),
(12, 17, 6, 'Enjuague final', 'Realiza enjuague final solo si el desinfectante no es no-rinse. Utiliza agua potable fría.', FALSE),
(12, 17, 7, 'Inspección', 'Inspeccione visualmente: Limpieza total, Transparencia del material, Ausencia de olores, rayaduras o fisuras. Registra la limpieza según plan de saneamiento.', FALSE);

-- ==========================================
-- AIRLOCK (ID EQUIPMENT: 12)
-- MATERIAL - PLÁSTICO PP (ID MATERIAL: 12)
-- NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(12, 12, 0, 'Preparación del detergente', 'Se recomienda una concentración aproximada del 2%, agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua A 45ºC.', FALSE),
(12, 12, 1, 'Inicio de la limpieza', 'Desarmar completamente (cuerpo, tapa, flotador) y retirar residuos de levadura o krausen inmediatamente tras su uso.', FALSE),
(12, 12, 2, 'Enjuague primario', 'Enjuagua todas las piezas con agua potable a temperatura ambiente para eliminar residuos gruesos y solubles.', FALSE),
(12, 12, 3, 'Lavado alcalino', 'Sumerje las piezas en la solución detergente preparada y lava manualmente con un cepillo de nylon o esponja no abrasiva. Deja actuar la solución durante 15-20 minutos. Prohibido: fibras metálicas, abrasivos o solventes agresivos. Evitar uso de alcohol.', FALSE),
(12, 12, 4, 'Enjuague secundario', 'Enjuaga con abundante agua potable hasta eliminar completamente residuos de detergente. Verifica ausencia de espuma.', FALSE),
(12, 12, 5, 'Desinfección', 'Aplica un desinfectante grado alimentario compatible con el material (ácido peracético, iodóforo o amonio cuaternario autorizado).', FALSE),
(12, 12, 6, 'Enjuague final', 'Realiza enjuague final solo si el desinfectante no es no-rinse. Utiliza agua potable fría.', FALSE),
(12, 12, 7, 'Inspección', 'Inspeccione visualmente: Limpieza total, Transparencia del material, Ausencia de olores, rayaduras o fisuras. Registra la limpieza según plan de saneamiento.', FALSE);


-- ==========================================
-- SIFÓN DE CERVECERÍA (ID EQUIPMENT: 6)
-- MATERIAL - ACERO INOX 304 (ID MATERIAL: 2)
--  TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(6, 2, 3, 'Lavado alcalino', 'Sumergir completamente las piezas y aplicar acción mecánica suave con cepillo de cerdas blandas. Mantener el tiempo de contacto de 15 a 20 minutos.', TRUE);


-- ==========================================
-- SIFÓN DE CERVECERÍA (ID EQUIPMENT: 6)
-- MATERIAL - ACERO INOX 304 (ID MATERIAL: 2)
--  NO TIENE CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(6, 2, 3, 'Lavado alcalino', 'Sumergir completamente las piezas y aplicar acción mecánica suave con cepillo de cerdas blandas. Mantener el tiempo de contacto de 20 a 30 minutos.', FALSE);


-- ==========================================
-- SIFÓN DE CERVECERÍA (ID EQUIPMENT: 6)
-- MATERIAL - ACERO INOX 304 (ID MATERIAL: 2)
--  CON Y SIN CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(6, 2, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 1%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', NULL),
(6, 2, 1, 'Inicio de la limpieza', 'Desarmar completamente el sifón o caña, separando tubos, uniones y accesorios. Inspeccionar visualmente el estado del equipo.', NULL),
(6, 2, 2, 'Enjuague primario', 'Enjuagar todas las piezas con agua potable a 20–40°C para eliminar residuos visibles. No utilizar agua caliente.', NULL),
(6, 2, 4, 'Enjuague secundario', 'Enjuagar con abundante agua potable hasta alcanzar pH neutro (7), verificando con cinta indicadora o pH-metro.', NULL),
(6, 2, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', NULL),
(6, 2, 6, 'Enjuague final', 'Enjuaga el tanque con agua fría para eliminar los residuos de la solución cáustica y prevenir la contaminación.', NULL),
(6, 2, 7, 'Inspección', 'Registrar la limpieza e inspección visual del estado del material.', NULL);


-- ==========================================
-- MANGUERAS DE CERVECERÍA (ID EQUIPMENT: 7)
-- MATERIAL - PLÁSTICO PP (ID MATERIAL: 12)
--  CON CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(7, 12, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 1%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', TRUE),
(7, 12, 1, 'Inicio de la limpieza', 'Conectar mangueras y tuberías al sistema CIP.', TRUE),
(7, 12, 2, 'Enjuague primario', 'Recircular agua potable a temperatura ambiente durante al menos 1 minuto como pre-enjuague.', TRUE),
(7, 12, 3, 'Lavado alcalino', 'Recircular agua potable a temperatura ambiente durante al menos 1 minuto como pre-enjuague.', TRUE),
(7, 12, 4, 'Enjuague secundario', 'Enjuagar con agua potable hasta alcanzar pH cercano a neutro (7).', TRUE),
(7, 12, 5, 'Desinfección', 'ALKLEAN POWER ya actúa como desinfectante de amplio espectro y esterilizante químico en frío gracias a su alto poder oxidante.', TRUE),
(7, 12, 6, 'Enjuague final', 'Enjuaga con agua fría para eliminar los residuos de la solución cáustica y prevenir la contaminación.', TRUE),
(7, 12, 7, 'Inspección', 'Registrar la limpieza e inspección visual del estado del material.', TRUE);


-- ==========================================
-- BARRILES KEGS (ID EQUIPMENT: 8)
-- MATERIAL - ACERO INOX (ID MATERIAL: 1)
--  SIN CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(8, 1, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN, se recomienda una concentración aproximada del 1%. La preparación de este detergente se realiza agregando {{cantidad}} kg de detergente para {{volumen}} litros de agua.', FALSE),
(8, 1, 1, 'Inicio de la limpieza', 'Despresurice completamente el keg. Retire la válvula (Sankey) o desconecte postes y tapas (Cornelius). Extraiga empaques y o-rings. Sumerja válvulas, lanzas, postes, tapas y o-rings en la misma solución detergente seǵun el tiempo indicado por el fabricante. Cepille con escobilla de nylon.', FALSE),
(8, 1, 2, 'Enjuague primario', 'Enjuague el interior del barril con agua potable caliente para remover residuos gruesos de cerveza, levadura y sedimentos.', FALSE),
(8, 1, 3, 'Lavado alcalino', 'Llene el keg parcialmente con la solución detergente preparada. Cepille manualmente el interior con cepillo espećıfico para kegs. Asegure contacto del detergente con paredes, fondo y cuello.', FALSE),
(8, 1, 4, 'Enjuague secundario', 'Enjuague el barril y los accesorios con abundante agua potable hasta eliminar completamente residuos alcalinos. Verifique pH neutro en agua de salida (pH 6,5–8).', FALSE),
(8, 1, 5, 'Desinfección', 'Aplique desinfectante grado alimentario (ácido peracético 0,1–0,2 %, iodóforo o amonio cuaternario autorizado). Asegure contacto total durante 2–5 minutos.', FALSE),
(8, 1, 6, 'Enjuague final', 'Realizar solo si el desinfectante no es no-rinse.', FALSE),
(8, 1, 7, 'Inspección', 'Verifique limpieza interna, ausencia de olores y correcto estado de empaques. Registre la operacíon seǵun plan de saneamiento.', FALSE);

-- ==========================================
-- BARRILES KEGS (ID EQUIPMENT: 8)
-- MATERIAL - ALUMINIO (ID MATERIAL: 6)
--  SIN CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(8, 6, 0, 'Preparación del detergente', 'Prepare una solucíon de detergente neutro o alcalino de baja causticidad al 0,5% v/v, agregando {{ cantidad }} kg de detergente en {{ volumen }} litros de agua tibia (45°C).', FALSE),
(8, 6, 1, 'Inicio de la limpieza', 'Despresurice completamente el keg. Retire la válvula (Sankey) o desconecte postes y tapas (Cornelius). Extraiga empaques y o-rings. Sumerja válvulas, lanzas, postes, tapas y o-rings en la misma solución detergente seǵun el tiempo indicado por el fabricante. Cepille con escobilla de nylon.', FALSE),
(8, 6, 2, 'Enjuague primario', 'Enjuague el interior del barril con agua potable caliente para remover residuos gruesos de cerveza, levadura y sedimentos.', FALSE),
(8, 6, 3, 'Lavado alcalino', 'Llene parcialmente el barril con la solucíon detergente. Cepille suavemente el interior con cepillo de nylon. Evite tiempos prolongados. Tiempo de contacto ḿaximo de 10–15 minutos.', FALSE),
(8, 6, 4, 'Enjuague secundario', 'Enjuague el barril y los accesorios con abundante agua potable hasta eliminar completamente residuos alcalinos. Verifique pH neutro en agua de salida (pH 6,5–8).', FALSE),
(8, 6, 5, 'Desinfección', 'Aplique desinfectante grado alimentario (ácido peracético 0,1–0,2 %, iodóforo o amonio cuaternario autorizado). Asegure contacto total durante 2–5 minutos.', FALSE),
(8, 6, 6, 'Enjuague final', 'Realizar solo si el desinfectante no es no-rinse.', FALSE),
(8, 6, 7, 'Inspección', 'Verifique limpieza interna, ausencia de olores y correcto estado de empaques. Registre la operacíon seǵun plan de saneamiento.', FALSE);

-- ==========================================
-- CARBONATADORES (ID EQUIPMENT: 9)
-- MATERIAL - CERÁMICA (ID MATERIAL: 8)
--  SIN CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(9, 8, 0, 'Preparación del detergente', 'en caso de que usted utilice ALKLEAN POWER TRIPLE EFECTO (Espuma) se recomienda una concentración aproximada del 1 %. La preparación de este detergente se realiza agregando {{ cantidad }} kg de detergente para {{ volumen }} litros de agua.', FALSE),
(9, 8, 1, 'Inicio de la limpieza', 'Vaciar completamente el tanque.', FALSE),
(9, 8, 2, 'Enjuague primario', 'Recircular agua potable a 20–30°C durante al menos 2 minutos para eliminar cerveza residual.', FALSE),
(9, 8, 3, 'Lavado alcalino', 'Recircular solucíon de ALKLEAN POWER asegurando flujo continuo a trav́es de la piedra difusora por 30 minutos a temperatura entre los 20 a 40°C.', FALSE),
(9, 8, 4, 'Enjuague secundario', 'Enjuagar con agua potable hasta pH cercano a neutro.', FALSE),
(9, 8, 5, 'Desinfección', 'Aplique desinfectante grado alimentario (ácido peracético 0,1–0,2 %, iodóforo o amonio cuaternario autorizado). Asegure contacto total durante 2–5 minutos.', FALSE),
(9, 8, 6, 'Enjuague final', 'Realizar solo si el desinfectante no es no-rinse.', FALSE),
(9, 8, 7, 'Inspección', 'Mantener la piedra llena de solucíon sanitizante o purgada con CO2 hasta su uso.', FALSE);

-- ==========================================
-- CARBONATADORES (ID EQUIPMENT: 9)
-- MATERIAL - ACERO INOX 304 (ID MATERIAL: 2)
--  SIN CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(9, 2, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN POWER TRIPLE EFECTO (Espuma) se recomienda una concentración aproximada del 1 %. La preparación de este detergente se realiza agregando {{ cantidad }} kg de detergente para {{ volumen }} litros de agua.', FALSE),
(9, 2, 1, 'Inicio de la limpieza', 'Vaciar completamente el tanque.', FALSE),
(9, 2, 2, 'Enjuague primario', 'Realizar enjuague manual con agua potable.', FALSE),
(9, 2, 3, 'Lavado alcalino', 'Aplicar espuma de ALKLEAN POWER TRIPLE EFECTO sobre todas las superficies internas por 20 minutos. Aplicar acción mecánica suave en zonas críticas si es necesario. Mantener el tiempo de contacto de 20 minutos.', FALSE),
(9, 2, 4, 'Enjuague secundario', 'Enjuagar con agua potable hasta pH cercano a neutro.', FALSE),
(9, 2, 5, 'Desinfección', 'Aplique desinfectante grado alimentario (ácido peracético 0,1–0,2 %, iodóforo o amonio cuaternario autorizado). Asegure contacto total durante 2–5 minutos.', FALSE),
(9, 2, 6, 'Enjuague final', 'Realizar solo si el desinfectante no es no-rinse.', FALSE),
(9, 2, 7, 'Inspección', 'Dejar escurrir, cerrar el tanque y mantener protegido de recontaminación. Inspeccionar visualmente el estado del material. Registrar la operación según plan de saneamiento.', FALSE);

-- ==========================================
-- CARBONATADORES (ID EQUIPMENT: 9)
-- MATERIAL - ACERO INOX 316 (ID MATERIAL: 3)
--  SIN CIP
-- ==========================================

INSERT INTO protocol_steps (equipment_id, material_id, step_number, step_name, description, requires_cip) VALUES
(9, 3, 0, 'Preparación del detergente', 'En caso de que utilices ALKLEAN POWER TRIPLE EFECTO (Espuma) se recomienda una concentración aproximada del 1 %. La preparación de este detergente se realiza agregando {{ cantidad }} kg de detergente para {{ volumen }} litros de agua.', FALSE),
(9, 3, 1, 'Inicio de la limpieza', 'Vaciar completamente el tanque.', FALSE),
(9, 3, 2, 'Enjuague primario', 'Realizar enjuague manual con agua potable.', FALSE),
(9, 3, 3, 'Lavado alcalino', 'Aplicar espuma de ALKLEAN POWER TRIPLE EFECTO sobre todas las superficies internas por 20 minutos. Aplicar acción mecánica suave en zonas críticas si es necesario. Mantener el tiempo de contacto de 20 minutos.', FALSE),
(9, 3, 4, 'Enjuague secundario', 'Enjuagar con agua potable hasta pH cercano a neutro.', FALSE),
(9, 3, 5, 'Desinfección', 'Aplique desinfectante grado alimentario (ácido peracético 0,1–0,2 %, iodóforo o amonio cuaternario autorizado). Asegure contacto total durante 2–5 minutos.', FALSE),
(9, 3, 6, 'Enjuague final', 'Realizar solo si el desinfectante no es no-rinse.', FALSE),
(9, 3, 7, 'Inspección', 'Dejar escurrir, cerrar el tanque y mantener protegido de recontaminación. Inspeccionar visualmente el estado del material. Registrar la operación según plan de saneamiento.', FALSE);