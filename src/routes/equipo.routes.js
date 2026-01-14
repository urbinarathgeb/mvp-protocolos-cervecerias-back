import express from 'express';
import {
  crearEquipo,
  getEquipo,
  getUserEquipos,
} from '../controllers/equipo.controller.js';
import { verifyAuthToken } from '../middleware/auth.middleware.js';

const router = express.Router();

router.get('/api/equipo/', getEquipo);
router.get('/api/mis-equipos', verifyAuthToken, getUserEquipos);
router.post('/api/equipo/crear', verifyAuthToken, crearEquipo);

export default router;
