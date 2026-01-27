import { pool } from '../db.js';

export const getEquipment = async (req, res) => {
  try {
    const equipment = await pool.query(
      'SELECT * FROM equipment ORDER BY name ASC',
    );
    const materials = await pool.query(
      'SELECT * FROM materials ORDER BY name ASC',
    );
    res.json({ equipment: equipment.rows, materials: materials.rows });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener los equipos' });
  }
};

// Obtiene materiales asociados a un equipo específico usando la tabla intermedia
export const getMaterialsByEquipment = async (req, res) => {
  const { id } = req.params; // Recibimos el ID del equipo desde la URL
  try {
    const result = await pool.query(
      `SELECT m.id, m.name 
       FROM materials m
       JOIN equipment_materials em ON m.id = em.material_id
       WHERE em.equipment_id = $1
       ORDER BY m.name ASC`,
      [id],
    );
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener materiales filtrados' });
  }
};

// Obtiene tipos asociados a un equipo específico usando la tabla intermedia
export const getTypesByEquipment = async (req, res) => {
  const { id } = req.params; // Recibimos el ID del equipo desde la URL
  try {
    const result = await pool.query(
      `SELECT t.id, t.name 
       FROM types t
       JOIN equipment_types et ON t.id = et.type_id
       WHERE et.equipment_id = $1
       ORDER BY t.name ASC`,
      [id],
    );
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener tipos filtrados' });
  }
};

export const crearEquipo = async (req, res) => {
  const {
    codigo_interno,
    nombre_personalizado,
    categoria_id,
    material_id,
    volumen_litros,
    tiene_cip,
  } = req.body;

  // Obtenemos el FIREBASE UID del usuario autenticado (del token)
  // IMPORTANTE: La base de datos fue modificada por el usuario para usar firebase_uid en la tabla equipos.
  const user_uid = req.user ? req.user.firebase_uid : null;

  if (!user_uid) {
    return res
      .status(401)
      .json({ error: 'Debes estar autenticado para crear un equipo.' });
  }

  try {
    const query = `
        INSERT INTO user_protocols 
        (user_id, codigo_interno, nombre_personalizado, categoria_id, material_id, volumen_litros, tiene_cip) 
        VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *
        `;
    const values = [
      user_uid,
      codigo_interno,
      nombre_personalizado,
      categoria_id,
      material_id,
      volumen_litros,
      tiene_cip,
    ];
    const result = await pool.query(query, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al crear el equipo' });
  }
};

export const getEquipos = async (req, res) => {
  try {
    const equipos = await pool.query('SELECT * FROM user_protocols');
    res.json(equipos.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener los equipos' });
  }
};

// export const getUserEquipos = async (req, res) => {
//   const user_id = req.user.id;
//   try {
//     const query = 'SELECT * FROM equipos WHERE user_id = $1 ORDER BY id DESC';
//     const result = await pool.query(query, [user_id]);
//     res.json(result.rows);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ error: 'Error al obtener los equipos del usuario' });
//   }
// };

export const getUserEquipos = async (req, res) => {
  try {
    console.log('--- getUserEquipos Start ---');
    console.log('req.user:', req.user);

    // El middleware authentication (verifyAuthToken) ya validó el token
    // y populó req.user con { id, firebase_uid, role, name, email } de la BD local.
    // Usamos firebase_uid porque el usuario actualizó su esquema de BD.
    const user_uid = req.user ? req.user.firebase_uid : null;

    if (!user_uid) {
      console.warn('getUserEquipos: No firebase_uid found in req.user');
      return res
        .status(401)
        .json({ error: 'Usuario no identificado correctamente' });
    }

    console.log('Fetching equipos for user_uid:', user_uid);

    // Usamos pool.query en lugar de Sequelize (Equipo.findAll).
    // Hacemos JOINs para devolver los nombres de categoría y material.
    const query = `
      SELECT 
        e.*, 
        c.nombre as categoria_nombre, 
        m.nombre as material_nombre 
      FROM user_protocols e
      LEFT JOIN equipment c ON e.categoria_id = c.id
      LEFT JOIN materials m ON e.material_id = m.id
      WHERE e.user_id = $1 
      ORDER BY e.id DESC
    `;

    // Pasamos user_uid (string) en lugar del ID numérico
    const result = await pool.query(query, [user_uid]);
    console.log('Query result row count:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('CRITICAL Error en getUserEquipos:', error);
    res.status(500).json({
      error: 'Error al obtener los equipos del usuario',
      details: error.message,
    });
  }
};
