import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import usersRoutes from './routes/users.routes.js';
import equipmentRoutes from './routes/equipment.routes.js';
import protocolRoutes from './routes/protocol.routes.js';
import ticketsRoutes from './routes/tickets.routes.js';
import './db.js';
import './config/firebase.js';

const PORT = process.env.NODE_PORT || 3000;

const app = express();

// --- MIDDLEWARES GLOBALES ---
app.use(express.json()); // 2. Procesamiento de req.body (JSON)

const corsOptions = {
  // Permitir SOLO el origen de tu frontend (Vite/React)
  origin: ['https://mvp-protocolos-cervecerias-front.vercel.app','http://localhost:5173'],
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true, // Permite que se envíen cookies y headers de autorización
};


app.use(cors(corsOptions));

// --- RUTAS ---
app.use(usersRoutes);
app.use(equipmentRoutes);
app.use(protocolRoutes);
app.use(ticketsRoutes);
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

// middleware
// app.use(morgan('dev'));
// app.use(express.json());

// routes
