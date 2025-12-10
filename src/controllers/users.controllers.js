// Nota: Gracias al middleware, req.user ya contiene los datos de PostgreSQL.
export const getUserData = (req, res) => {
  // req.user fue llenado por verifyAuthToken: { id, role, name, email, firebase_uid }
  const { id, name, role, email } = req.user;

  // Solo enviamos los datos esenciales de vuelta al frontend
  res.json({
    id,
    name,
    role,
    email,
  });
};
