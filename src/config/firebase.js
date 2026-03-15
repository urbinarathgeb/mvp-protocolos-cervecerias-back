import admin from 'firebase-admin';
import fs from 'fs';
import path from 'path';

// Validamos que la variable exista para evitar el error de los logs
const firebaseConfigValue = process.env.FIREBASE_SERVICE_ACCOUNT;

if (!firebaseConfigValue) {
  console.error("❌ ERROR: La variable FIREBASE_SERVICE_ACCOUNT no está definida.");
}

try {
  let serviceAccount;

  if (firebaseConfigValue) {
    // Intentamos determinar si es un JSON o una ruta
    if (firebaseConfigValue.trim().startsWith('{')) {
      // Es un string JSON (común en entornos de producción como Railway)
      serviceAccount = JSON.parse(firebaseConfigValue);
    } else {
      // Es una ruta de archivo (común en desarrollo local)
      const filePath = path.resolve(firebaseConfigValue);
      const fileContent = fs.readFileSync(filePath, 'utf8');
      serviceAccount = JSON.parse(fileContent);
    }

    // ESTO ARREGLA EL ERROR DE PEM: Reemplaza los escapes de saltos de línea si vienen de un string
    if (serviceAccount.private_key) {
      serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');
    }

    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
      });
      console.log("✅ Firebase Admin SDK inicializado correctamente");
    }
  }
} catch (error) {
  console.error("❌ Error crítico al inicializar Firebase:", error.message);
}

export default admin;