import { Router } from 'express';
import { createUser } from '../controllers/admin.controllers.js';
import { verifyAuthToken, isAdmin } from '../middleware/auth.middleware.js';

const router = Router();

// Endpoint para crear usuarios:
// 1. verifyAuthToken: Asegura que haya un usuario logeado y un token válido.
// 2. isAdmin: Asegura que el usuario logeado tenga el rol 'admin'.
router.post('/api/users', verifyAuthToken, isAdmin, createUser);

export default router;
