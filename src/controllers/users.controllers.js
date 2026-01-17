import { admin } from '../config/firebase.js';
import { pool } from '../db.js';

// Nota: Gracias al middleware, req.user ya contiene los datos de PostgreSQL.
export const getUserData = (req, res) => {
  // req.user fue llenado por verifyAuthToken: { id, role, name, email, firebase_uid }
  const {
    id,
    brewery_name,
    role,
    brewery_email,
    address,
    comune,
    phone_number,
    website,
  } = req.user;

  // Solo enviamos los datos esenciales de vuelta al frontend
  res.json({
    id,
    brewery_name,
    role,
    brewery_email,
    address,
    comune,
    phone_number,
    website,
  });
};

export const getAllUsers = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users');
    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener usuarios:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

export const createUser = async (req, res) => {
  const {
    brewery_email,
    brewery_name,
    password,
    role,
    address,
    commune,
    phone_number,
    website,
  } = req.body;

  if (
    !brewery_email ||
    !password ||
    !brewery_name ||
    !address ||
    !commune ||
    !phone_number
  ) {
    return res.status(400).json({ message: 'Faltan datos obligatorios' });
  }

  try {
    const firebaseUser = await admin.auth().createUser({
      email: brewery_email,
      password,
      displayName: brewery_name,
    });

    const firebase_uid = firebaseUser.uid;
    const userRole = role || 'user';
    const queryText =
      'INSERT INTO users (firebase_uid, brewery_email, brewery_name, address, commune, phone_number, website, role) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *';

    const result = await pool.query(queryText, [
      firebase_uid,
      brewery_email,
      brewery_name,
      address,
      commune,
      phone_number,
      website,
      userRole,
    ]);

    res.status(201).json({
      message: 'Usuario creado exitosamente',
      user_id: result.rows[0].id,
      firebase_uid: firebase_uid,
    });
  } catch (error) {
    console.error('Error al crear usuario', error);
    res.status(500).json({
      message: error.message,
    });
  }
};

export const deleteUser = async (req, res) => {
  const { id } = req.params;
  try {
    // 1. Obtener firebase_uid antes de borrar de DB (opcional, si quisieras borrar de firebase también)
    // Por ahora asumiremos borrado lógico o solo de DB, pero si es borrado total:
    const userQuery = 'SELECT firebase_uid FROM users WHERE id = $1';
    const userResult = await pool.query(userQuery, [id]);

    if (userResult.rows.length === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    // 2. Borrar de PostgreSQL
    await pool.query('DELETE FROM users WHERE id = $1', [id]);

    // 3. Borrar de Firebase (Opcional pero recomendado para consistencia)
    const firebaseUid = userResult.rows[0].firebase_uid;
    await admin
      .auth()
      .deleteUser(firebaseUid)
      .catch((err) => console.warn('Error borrando de firebase:', err));

    res.json({ message: `Usuario ${id} eliminado correctamente` });
  } catch (error) {
    console.error('Error al eliminar usuario:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

export const updateUser = async (req, res) => {
  const { id } = req.params;
  const {
    brewery_name,
    brewery_email,
    address,
    commune,
    phone_number,
    website,
    role,
  } = req.body; // Asumimos que solo se edita name y role en DB por ahora

  try {
    const result = await pool.query(
      'UPDATE users SET brewery_name = COALESCE($1, brewery_name), brewery_email = COALESCE($2, brewery_email), address = COALESCE($3, address), commune = COALESCE($4, commune), phone_number = COALESCE($5, phone_number), website = COALESCE($6, website), role = COALESCE($7, role) WHERE id = $8 RETURNING *',
      [
        brewery_name,
        brewery_email,
        address,
        commune,
        phone_number,
        website,
        role,
        id,
      ],
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    res.json({ message: `Usuario ${id} actualizado`, user: result.rows[0] });
  } catch (error) {
    console.error('Error al actualizar usuario:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};
