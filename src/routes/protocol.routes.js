import express from 'express';
import {
  getProtocolSteps,
  createProtocol,
  getUserProtocols,
} from '../controllers/protocol.controllers.js';
import { verifyAuthToken } from '../middleware/auth.middleware.js';
const router = express.Router();

router.get('/api/protocol/:equipmentId/:materialId/:hasCip', getProtocolSteps);
router.get('/api/user-protocols', verifyAuthToken, getUserProtocols);
router.post('/api/create-protocol', verifyAuthToken, createProtocol);

export default router;
