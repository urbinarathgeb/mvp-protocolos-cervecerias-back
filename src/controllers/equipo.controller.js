import { pool } from '../db.js';

export const getEquipo = async (req, res) => {
  try {
    const equipo = await pool.query(
      'SELECT * FROM categorias_equipo ORDER BY nombre ASC'
    );
    const materiales = await pool.query(
      'SELECT * FROM materiales ORDER BY nombre ASC'
    );
    res.json({ equipo: equipo.rows, materiales: materiales.rows });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener los equipos' });
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
        INSERT INTO equipos 
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
    const equipos = await pool.query('SELECT * FROM equipos');
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
      FROM equipos e
      LEFT JOIN categorias_equipo c ON e.categoria_id = c.id
      LEFT JOIN materiales m ON e.material_id = m.id
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
