import express from 'express';
import {
  crearEquipo,
  getEquipment,
  getUserEquipos,
} from '../controllers/equipment.controller.js';
import { verifyAuthToken } from '../middleware/auth.middleware.js';

const router = express.Router();

router.get('/api/equipo/', getEquipment);
router.get('/api/mis-equipos', verifyAuthToken, getUserEquipos);
router.post('/api/equipo/crear', verifyAuthToken, crearEquipo);

export default router;
