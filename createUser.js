import 'dotenv/config';
import './src/config/firebase.js';
import { admin } from './src/config/firebase.js';

const EMAIL = 'user_3@mail.com';
const PASSWORD = 'PasswordSegura123';
// const ROLE = 'user';

async function createInitialAdmin() {
  console.log(`Intentando crear el usuario ${EMAIL}`);

  try {
    const userRecord = await admin.auth().createUser({
      email: EMAIL,
      password: PASSWORD,
      displayName: 'User 3',
    });
    console.log('\n--- CUENTA CREADA EXITOSAMENTE EN FIREBASE AUTH ---');
    console.log(`Email: ${EMAIL}`);
    console.log(`Password: ${PASSWORD}`);
    console.log(`Firebase UID REAL (COPIAR): ${userRecord.uid}`);
    console.log('--------------------------------------------------\n');

    console.log(
      'Ahora, ve a psql y ejecuta el comando de UPDATE o INSERT con el UID, nombre y rol.'
    );
  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      console.error(`Error: El correo ${EMAIL} ya existe en Firebase Auth`);
    } else {
      console.error('Error desconocido al crear admin:', error.message);
    }
  }
}

createInitialAdmin();
