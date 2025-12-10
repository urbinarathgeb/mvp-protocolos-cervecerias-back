import { admin } from '../config/firebase.js';
import { pool } from '../db.js';

export const createUser = async (req, res) => {
  const { email, password, name, role } = req.body;

  if (!email || !password || !name) {
    return res.status(400).json({ message: 'Faltan datos obligatorios' });
  }
  try {
    const firebaseUser = await admin.auth().createUser({
      email,
      password,
      displayName: name,
    });

    const firebase_uid = firebaseUser.uid;
    const userRole = role || 'user'; // Asignar default
    const queryText =
      'INSERT INTO users (firebase_uid, email, name, role) VALUES ($1, $2, $3, $4) RETURNING *';

    const result = await pool.query(
      queryText,
      [firebase_uid, email, name, role] || 'user'
    );

    res.status(201).json({
      mesaage: 'Usuario creado exitosamente',
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
