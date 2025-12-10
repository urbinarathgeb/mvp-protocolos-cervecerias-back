import pg from 'pg';
import 'dotenv/config';

export const pool = new pg.Pool({
  user: process.env.PG_USER,
  password: process.env.PG_PASSWORD,
  host: process.env.PG_HOST,
  port: process.env.PG_PORT,
  database: process.env.PG_DATABASE,
});

pool.connect((err, client, release) => {
  if (err) {
    return console.error('Error al adquirir cliente de BBDD:', err.stack);
  }
  console.log('✅ Conexión exitosa a PostgreSQL');
  client.release();
});
