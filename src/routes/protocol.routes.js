import express from 'express';
import { getProtocolSteps } from '../controllers/protocol.controllers.js';

const router = express.Router();

router.get('/api/protocol/:equipmentId/:materialId/:hasCip', getProtocolSteps);
