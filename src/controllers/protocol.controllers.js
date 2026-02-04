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

export const createProtocol = async (req, res) => {
  const { equipment_id, type_id, material_id, volume_liters, has_cip } =
    req.body;

  // Obtenemos el FIREBASE UID del usuario autenticado (del token)
  // IMPORTANTE: La base de datos fue modificada por el usuario para usar firebase_uid en la tabla equipos.
  const user_uid = req.user ? req.user.firebase_uid : null;

  if (!user_uid) {
    return res
      .status(401)
      .json({ error: 'Debes estar autenticado para crear un equipo.' });
  }

  try {
    // 1. Obtener el nombre del equipo para el prefijo (ej: "FERMENTADOR" -> "FER")
    const eqResult = await pool.query(
      `SELECT name FROM equipment WHERE id = $1`,
      [equipment_id],
    );
    if (eqResult.rows.length === 0) {
      return res.status(404).json({ message: 'Equipo no encontrado' });
    }
    // Obtenemos el prefijo de 3 letras del equipo
    const prefix = eqResult.rows[0].name.substring(0, 3).toUpperCase();

    //2. Contamos cuántos protocolos tiene el usuario para ese equipo
    const countResult = await pool.query(
      `SELECT COUNT(*) FROM user_protocols WHERE user_id = $1 AND equipment_id = $2`,
      [user_uid, equipment_id],
    );

    const nextNumber = parseInt(countResult.rows[0].count) + 1;
    // Agregamos ceros a la izquierda para que siempre tenga 3 dígitos (ej: 001, 002, 010)
    const formattedNumber = nextNumber.toString().padStart(3, '0');
    const protocol_code = `${prefix}-${formattedNumber}`;

    const query = `INSERT INTO user_protocols 
    (user_id, equipment_id, type_id, material_id, protocol_code, volume_liters, has_cip)
    VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`;

    const values = [
      user_uid,
      equipment_id,
      type_id,
      material_id,
      protocol_code,
      volume_liters,
      has_cip,
    ];
    const result = await pool.query(query, values);
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error al crear el protocolo:', error);
    res.status(500).json({ error: 'Error al crear el protocolo' });
  }
};
