import admin from 'firebase-admin';

// const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT;
//
// // Intenta inicializar Firebase
// try {
//   admin.initializeApp({
//     credential: admin.credential.cert(serviceAccountPath),
//   });
//   console.log('✅ Firebase Admin SDK inicializado.');
// } catch (error) {
//   if (!/already exists/.test(error.message)) {
//     console.error('Error al inicializar Firebase Admin:', error.stack);
//   }
// }
//
// export { admin };

// Validamos que la variable exista para evitar el error de los logs
if (!process.env.FIREBASE_SERVICE_ACCOUNT) {
  console.error("❌ ERROR: La variable FIREBASE_SERVICE_ACCOUNT no está definida en Railway");
}

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
  console.log("✅ Firebase Admin SDK inicializado correctamente");
}

export default admin;