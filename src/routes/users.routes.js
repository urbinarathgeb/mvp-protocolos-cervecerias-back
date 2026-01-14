import { Router } from 'express';
import { verifyAuthToken, isAdmin } from '../middleware/auth.middleware.js';
import {
  getUserData,
  getAllUsers,
  createUser,
  deleteUser,
  updateUser,
} from '../controllers/users.controllers.js';

const router = Router();

// --- Rutas de Admin (Requieren Token + Rol Admin) ---
router.get('/api/users', verifyAuthToken, isAdmin, getAllUsers);
router.post('/api/users', verifyAuthToken, isAdmin, createUser);
router.delete('/api/users/:id', verifyAuthToken, isAdmin, deleteUser);
router.put('/api/users/:id', verifyAuthToken, isAdmin, updateUser);

// --- Rutas de Usuario (Requieren solo Token) ---
router.get('/api/user', verifyAuthToken, getUserData); // Obtener datos del usuario logueado

export default router;
