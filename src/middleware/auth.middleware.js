import  admin  from '../config/firebase.js';
import { pool } from '../db.js';

// Middleware que verifica el token y establece el usuario en req.user
export const verifyAuthToken = async (req, res, next) => {
  // 1. Obtener el Token: El token se envía en el header 'Authorization'
  const idToken = req.headers.authorization?.split('Bearer ')[1];


  if (!idToken) {
    return res
      .status(401)
      .json({ message: 'No autorizado. Token no proporcionado.' });
  }

  try {
    // 2. Verificar el Token con Firebase Admin SDK
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const firebase_uid = decodedToken.uid;
    console.log("DEBUG: UID de Firebase decodificado ->", firebase_uid);
    // 3. Obtener el Rol del Usuario desde PostgreSQL
    const queryText =
      'SELECT id, firebase_uid, role, brewery_name, brewery_email, address, commune, phone_number, website FROM users WHERE firebase_uid = $1;';
    const result = await pool.query(queryText, [firebase_uid]);

    if (result.rows.length === 0) {
      return res
        .status(401)
        .json({ message: 'Usuario no encontrado en la base de datos.' });
    }
    // 4. Adjuntar la información del usuario al objeto de solicitud (req)
    req.user = result.rows[0];
    // Continuar con la siguiente función (el controlador)
    next();
  } catch (error) {
    console.error('Error al verificar el token:', error.message);
    // Error de token inválido, expirado, etc.
    return res.status(401).json({ message: 'Token inválido o expirado.' });
  }
};

// Middleware para verificar si el usuario es administrador

export const isAdmin = (req, res, next) => {
  if (!req.user || req.user.role !== 'admin') {
    return res
      .status(403)
      .json({ message: 'No autorizado. Se requiere el rol de administrador.' });
  }
  next();
};
