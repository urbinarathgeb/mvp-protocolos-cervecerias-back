import { Router } from 'express';
import { verifyAuthToken } from '../middleware/auth.middleware.js';
import { getUserData } from '../controllers/users.controllers.js';

const router = Router();

router.get('/api/users', (req, res) => {
  res.send('Obteniendo todos los usuarios');
});

// router.get('/users/:id', (req, res) => {
//   const { id } = req.params;
//   res.send(`Obteniendo el usuario ${id}`);
// });
// Esta ruta necesita el Token JWT para funcionar
router.get('/api/user', verifyAuthToken, getUserData);

router.post('/api/users', (req, res) => {
  res.send('Creando un usuario');
});

router.delete('/api/users/:id', (req, res) => {
  const { id } = req.params;
  res.send(`Eliminando el usuario ${id}`);
});

router.put('/api/users/:id', (req, res) => {
  const { id } = req.params;
  res.send(`Actualizando el usuario ${id}`);
});

export default router;
