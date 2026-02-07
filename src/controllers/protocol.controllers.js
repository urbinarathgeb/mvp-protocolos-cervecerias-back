import { pool } from '../db.js';

export const getProtocolSteps = async (req, res) => {
  const { equipmentId, materialId, hasCip } = req.params;
  try {
    // La lógica de la query:
    // 1. Filtra por equipo y material.
    // 2. Trae pasos que sean NULL (aplican a ambos) O que coincidan con el hasCip del usuario.
    const query = `
    SELECT step_number, step_name, description
    FROM protocol_steps
    WHERE equipment_id = $1
    AND material_id = $2
    AND (requires_cip IS NULL OR requires_cip = $3)
    ORDER BY step_number ASC
    `;
    const values = [equipmentId, materialId, hasCip === `true`];
    const { rows } = await pool.query(query, values);

    if (rows.length === 0) {
      return res.status(404).json({
        message:
          'Protocolo no encontrado para el equipo y material seleccionado',
      });
    }
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener pasos del protocolo:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

export const getUserProtocols = async (req, res) => {
  try {
    // El middleware authentication (verifyAuthToken) ya validó el token
    // y populó req.user con { id, firebase_uid, role, name, email } de la BD local.
    // Usamos firebase_uid porque el usuario actualizó su esquema de BD.
    const user_uid = req.user ? req.user.firebase_uid : null;

    if (!user_uid) {
      console.warn('getUserProtocols: No firebase_uid found in req.user');
      return res
        .status(401)
        .json({ error: 'Usuario no identificado correctamente' });
    }

    console.log('Fetching user protocols for user_uid:', user_uid);

    // Hacemos JOINs para devolver los nombres de categoría y material.
    const query = `
      SELECT 
        p.*, 
        e.name as equipment_name, 
        m.name as material_name,
        t.name as type_name,
        u.brewery_name
      FROM user_protocols p
      LEFT JOIN equipment e ON p.equipment_id = e.id
      LEFT JOIN materials m ON p.material_id = m.id
      LEFT JOIN types t ON p.type_id = t.id
      LEFT JOIN users u ON p.user_id = u.firebase_uid
      WHERE p.user_id = $1 
      ORDER BY p.id DESC
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

export const createProtocol = async (req, res) => {
  const {
    equipment_id,
    type_id,
    material_id,
    volume_liters,
    has_cip,
    user_id,
  } = req.body;

  // Obtenemos el FIREBASE UID del usuario autenticado (del token)
  // IMPORTANTE: La base de datos fue modificada por el usuario para usar firebase_uid en la tabla equipos.
  const user_uid = req.user?.firebase_uid || user_id;

  if (!user_uid) {
    return res.status(401).json({ error: 'Usuario no identificado.' });
  }

  try {
    // 1. Obtener el nombre del equipo para el prefijo (ej: "FERMENTADOR" -> "FER")
    const eqResult = await pool.query(
      `SELECT name FROM equipment WHERE id = $1`,
      [equipment_id],
    );

    if (eqResult.rows.length === 0) {
      return res.status(404).json({ error: 'Equipo base no encontrado.' });
    }
    const prefix = eqResult.rows[0].name.substring(0, 3).toUpperCase();

    //2. Contamos cuántos protocolos tiene el usuario para ese equipo
    const countResult = await pool.query(
      `SELECT COUNT(*) FROM user_protocols WHERE user_id = $1 AND equipment_id = $2`,
      [user_uid, equipment_id],
    );

    const nextNumber = parseInt(countResult.rows[0].count) + 1;
    const protocol_code = `${prefix}-${nextNumber.toString().padStart(3, '0')}`;

    const final_type_id = type_id ? parseInt(type_id) : null;
    const final_eq_id = parseInt(equipment_id);
    const final_mat_id = parseInt(material_id);
    const final_vol = parseFloat(volume_liters);

    const query = `INSERT INTO user_protocols
    (user_id, equipment_id, type_id, material_id, protocol_code, volume_liters, has_cip)
    VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`;

    const values = [
      user_uid,
      final_eq_id,
      final_type_id,
      final_mat_id,
      protocol_code,
      final_vol,
      has_cip,
    ];
    const result = await pool.query(query, values);
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error detallado:', error.message);
    res.status(500).json({
      error: 'Error al crear el protocolo',
      detail: error.message,
    });
  }
};
