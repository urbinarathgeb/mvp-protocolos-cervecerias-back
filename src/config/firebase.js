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

try {
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

  // ESTO ARREGLA EL ERROR DE PEM: Reemplaza los escapes de saltos de línea
  serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');

  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
    console.log("✅ Firebase Admin SDK inicializado correctamente");
  }
} catch (error) {
  console.error("❌ Error crítico al inicializar Firebase:", error.message);
}
export default admin;