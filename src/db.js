import pg from 'pg';
import 'dotenv/config';


// export const pool = new pg.Pool({
//   user: process.env.PG_USER,
//   password: process.env.PG_PASSWORD,
//   host: process.env.PG_HOST,
//   port: process.env.PG_PORT,
//   database: process.env.PG_DATABASE,
// });

const isProduction = Boolean(process.env.DATABASE_URL);

const poolConfig = isProduction
    ? {
        connectionString: process.env.DATABASE_URL,
        ssl: { rejectUnauthorized: false } // Requerido por Railway
    }
    : {
        // Si no hay DATABASE_URL, usa tus credenciales locales
        user: process.env.PG_USER,
        password: process.env.PG_PASSWORD,
        host: process.env.PG_HOST,
        port: process.env.PG_PORT,
        database: process.env.PG_DATABASE,
    };

export const pool = new pg.Pool(poolConfig);

// pool.connect((err, client, release) => {
//   if (err) {
//     return console.error('Error al adquirir cliente de BBDD:', err.stack);
//   }
//   console.log('✅ Conexión exitosa a PostgreSQL');
//   client.release();
// });

pool.connect((err, client, release) => {
    if (err) {
        return console.error('❌ Error de conexión:', err.stack);
    }
    console.log(`✅ Conexión exitosa a PostgreSQL (${isProduction ? 'Nube' : 'Local'})`);
    client.release();
});