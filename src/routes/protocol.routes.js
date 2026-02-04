import express from 'express';
import {
  getProtocolSteps,
  createProtocol,
} from '../controllers/protocol.controllers.js';
import { verifyAuthToken } from '../middleware/auth.middleware.js';
const router = express.Router();

router.get('/api/protocol/:equipmentId/:materialId/:hasCip', getProtocolSteps);
router.post('/api/create-protocol', verifyAuthToken, createProtocol);

export default router;
