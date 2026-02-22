import { Router } from 'express';
import { verifyAuthToken, isAdmin } from '../middleware/auth.middleware.js';
import {
  createTicket,
  getAllTickets,
  getMyTickets,
  getTicketById,
  updateTicketStatus,
} from '../controllers/tickets.controller.js';

const router = Router();

// --- Rutas de Usuario (Requieren solo Token) ---
router.post('/api/tickets', verifyAuthToken, createTicket);
router.get('/api/my-tickets', verifyAuthToken, getMyTickets);

// --- Rutas de Admin (Requieren Token + Rol Admin) ---
router.get('/api/tickets', verifyAuthToken, isAdmin, getAllTickets);
router.get('/api/tickets/:id', verifyAuthToken, isAdmin, getTicketById);
router.patch('/api/tickets/:id/status', verifyAuthToken, isAdmin, updateTicketStatus);

export default router;
