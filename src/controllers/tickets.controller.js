import { pool } from '../db.js';

export const createTicket = async (req, res) => {
  const { subject, category, message, user_id, user_email } = req.body;

  if (!subject || !category || !message || !user_id || !user_email) {
    return res.status(400).json({ message: 'Todos los campos son obligatorios.' });
  }

  try {
    const queryText = `
      INSERT INTO tickets (subject, category, message, user_id, user_email)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *;
    `;
    const values = [subject, category, message, user_id, user_email];
    const result = await pool.query(queryText, values);

    return res.status(201).json({
      message: 'Ticket creado exitosamente.',
      ticket: result.rows[0],
    });
  } catch (error) {
    console.error('Error al crear el ticket:', error.message);
    return res.status(500).json({ message: 'Error interno del servidor al crear el ticket.' });
  }
};

export const getAllTickets = async (req, res) => {
  try {
    const queryText = 'SELECT * FROM tickets ORDER BY created_at DESC;';
    const result = await pool.query(queryText);

    return res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error al obtener los tickets:', error.message);
    return res.status(500).json({ message: 'Error interno del servidor al obtener los tickets.' });
  }
};

export const getMyTickets = async (req, res) => {
  try {
    const queryText = `
      SELECT *
      FROM tickets
      WHERE user_id = $1
      ORDER BY created_at DESC;
    `;
    const result = await pool.query(queryText, [req.user.firebase_uid]);

    return res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error al obtener tickets del usuario:', error.message);
    return res
      .status(500)
      .json({ message: 'Error interno del servidor al obtener tus tickets.' });
  }
};

export const getTicketById = async (req, res) => {
  const { id } = req.params;

  try {
    const queryText = 'SELECT * FROM tickets WHERE id = $1;';
    const result = await pool.query(queryText, [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Ticket no encontrado.' });
    }

    return res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error('Error al obtener el ticket:', error.message);
    return res.status(500).json({ message: 'Error interno del servidor al obtener el ticket.' });
  }
};

export const updateTicketStatus = async (req, res) => {
  const { id } = req.params;
  const { status, admin_response } = req.body;

  const hasStatus = typeof status === 'string' && status.trim().length > 0;
  const hasResponse =
    typeof admin_response === 'string' && admin_response.trim().length > 0;

  if (!hasStatus && !hasResponse) {
    return res.status(400).json({
      message:
        'Debes enviar al menos un campo para actualizar: status o admin_response.',
    });
  }

  try {
    const queryText = `
      UPDATE tickets
      SET
        status = COALESCE($1, status),
        admin_response = COALESCE($2, admin_response),
        responded_at = CASE
          WHEN $2 IS NOT NULL THEN CURRENT_TIMESTAMP
          ELSE responded_at
        END,
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $3
      RETURNING *;
    `;
    const result = await pool.query(queryText, [
      hasStatus ? status : null,
      hasResponse ? admin_response.trim() : null,
      id,
    ]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Ticket no encontrado.' });
    }

    return res.status(200).json({
      message: 'Ticket actualizado exitosamente.',
      ticket: result.rows[0],
    });
  } catch (error) {
    console.error('Error al actualizar el ticket:', error.message);
    return res.status(500).json({ message: 'Error interno del servidor al actualizar el ticket.' });
  }
};
