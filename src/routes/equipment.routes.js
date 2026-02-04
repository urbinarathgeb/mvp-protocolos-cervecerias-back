import express from 'express';
import {
  // crearEquipo,
  getEquipment,
  getMaterialsByEquipment,
  getTypesByEquipment,
  // getUserEquipos,
} from '../controllers/equipment.controller.js';
// import { verifyAuthToken } from '../middleware/auth.middleware.js';

const router = express.Router();

router.get('/api/equipments', getEquipment);
router.get('/api/equipment/:id/materials', getMaterialsByEquipment);
router.get('/api/equipment/:id/types', getTypesByEquipment);
// router.get('/api/mis-equipos', verifyAuthToken, getUserEquipos);
// BORRAR UNA VEZ QUE ESTÉ PROBADA LA NUEVA RUTA create-protocol EN protocol.routes.js
// router.post('/api/equipo/crear', verifyAuthToken, crearEquipo);

export default router;
