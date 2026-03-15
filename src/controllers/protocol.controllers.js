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
        u.brewery_name,
        p.detergent_concentration
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
    concentration,
  } = req.body;

  // Obtenemos el FIREBASE UID del usuario autenticado (del token)
  // IMPORTANTE: La base de datos usa firebase_uid para asociar protocolos.
  let user_uid = req.user?.firebase_uid;

  // Si no viene en req.user (ej: test o fallback), intentamos usar el del body
  // Pero verificamos si el user_id proporcionado es un ID numérico de DB o un UID de Firebase
  if (!user_uid && user_id) {
    if (isNaN(user_id)) {
      user_uid = user_id;
    } else {
      // Si es un número, buscamos su firebase_uid en la DB
      try {
        const userRes = await pool.query(
          'SELECT firebase_uid FROM users WHERE id = $1',
          [user_id],
        );
        if (userRes.rows.length > 0) {
          user_uid = userRes.rows[0].firebase_uid;
        }
      } catch (err) {
        console.error('Error buscando firebase_uid:', err);
      }
    }
  }

  if (!user_uid) {
    return res.status(401).json({ error: 'Usuario no identificado.' });
  }

  try {
    console.log('--- Creating Protocol ---');
    console.log('Payload:', req.body);
    console.log('User UID:', user_uid);

    // 1. Obtener el nombre del equipo para el prefijo (ej: "FERMENTADOR" -> "FER")
    const eqResult = await pool.query(
      `SELECT name FROM equipment WHERE id = $1`,
      [equipment_id],
    );

    if (eqResult.rows.length === 0) {
      console.warn('Equipment not found:', equipment_id);
      return res.status(404).json({ error: 'Equipo base no encontrado.' });
    }
    const prefix = eqResult.rows[0].name.substring(0, 3).toUpperCase();

    //2. Contamos cuántos protocolos tiene el usuario para ese equipo para generar el código
    // Se usa MAX o COUNT, pero para que sea amigable se usará el siguiente número disponible
    const lastResult = await pool.query(
      `SELECT protocol_code FROM user_protocols WHERE user_id = $1 AND equipment_id = $2 ORDER BY id DESC LIMIT 1`,
      [user_uid, equipment_id],
    );

    let nextNumber = 1;
    if (lastResult.rows.length > 0) {
      const lastCode = lastResult.rows[0].protocol_code;
      const parts = lastCode.split('-');
      if (parts.length > 1) {
        nextNumber = parseInt(parts[1]) + 1;
      }
    }
    const protocol_code = `${prefix}-${nextNumber.toString().padStart(3, '0')}`;

    const final_type_id =
      type_id && type_id !== '' ? parseInt(type_id) : null;
    const final_eq_id = parseInt(equipment_id);
    const final_mat_id = parseInt(material_id);
    const final_vol = parseFloat(volume_liters) || 0;
    const final_concentration = parseFloat(concentration) || 0;

    console.log('Final values:', {
      user_uid,
      final_eq_id,
      final_type_id,
      final_mat_id,
      protocol_code,
      final_vol,
      has_cip,
      final_concentration,
    });

    const query = `INSERT INTO user_protocols
    (user_id, equipment_id, type_id, material_id, protocol_code, volume_liters, has_cip, detergent_concentration)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`;

    const values = [
      user_uid,
      final_eq_id,
      final_type_id,
      final_mat_id,
      protocol_code,
      final_vol,
      has_cip,
      final_concentration,
    ];
    const result = await pool.query(query, values);
    console.log('Protocol created successfully:', result.rows[0].id);
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error detallado:', error);
    res.status(500).json({
      error: 'Error al crear el protocolo',
      detail: error.message,
    });
  }
};

export const deleteProtocol = async (req, res) => {
  const { id } = req.params;
  const user_uid = req.user ? req.user.firebase_uid : null;

  if (!user_uid) {
    return res.status(401).json({ error: 'Usuario no identificado.' });
  }

  try {
    // Verificamos que el protocolo pertenezca al usuario antes de borrar
    const deleteQuery = `
      DELETE FROM user_protocols 
      WHERE id = $1 AND user_id = $2 
      RETURNING *
    `;
    const result = await pool.query(deleteQuery, [id, user_uid]);

    if (result.rowCount === 0) {
      return res.status(404).json({
        error: 'Protocolo no encontrado o no pertenece al usuario.',
      });
    }

    res.json({ message: 'Protocolo eliminado correctamente', protocol: result.rows[0] });
  } catch (error) {
    console.error('Error al eliminar el protocolo:', error);
    res.status(500).json({
      error: 'Error al eliminar el protocolo',
      details: error.message,
    });
  }
};
