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


const corsOptions = {
  // Permitir el origen principal, localhost y despliegues de Vercel (incluyendo preview)
  origin: (origin, callback) => {
    const allowedOrigins = [
      'https://mvp-protocolos-cervecerias-front.vercel.app',
      'http://localhost:5173'
    ];
    
    // Si no hay origen (como en peticiones de servidor a servidor o herramientas como Postman) o está en la lista blanca
    if (!origin || allowedOrigins.indexOf(origin) !== -1 || origin.endsWith('.vercel.app')) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true, // Permite que se envíen cookies y headers de autorización
};


app.use(cors(corsOptions));
// --- MIDDLEWARES GLOBALES ---
app.use(express.json()); // 2. Procesamiento de req.body (JSON)


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
