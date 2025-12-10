import admin from 'firebase-admin';

const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT;

// Intenta inicializar Firebase
try {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccountPath),
  });
  console.log('✅ Firebase Admin SDK inicializado.');
} catch (error) {
  if (!/already exists/.test(error.message)) {
    console.error('Error al inicializar Firebase Admin:', error.stack);
  }
}

export { admin };
