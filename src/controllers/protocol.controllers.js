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
