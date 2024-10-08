// Import required modules
console.log("Starting Firestore access test script...");
const admin = require('firebase-admin');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '.env') }); // Load environment variables

// Initialize Firebase Admin SDK
try {
  const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  console.log("Service Account Path:", serviceAccountPath);  // Confirm the path
  
  if (!admin.apps.length) {
    console.log("Initializing Firebase Admin SDK...");
    const serviceAccount = require(path.resolve(__dirname, serviceAccountPath));
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
    console.log("Firebase Admin initialized successfully");
  }
} catch (error) {
  console.error("Error initializing Firebase Admin SDK:", error.message);
}

// Reference to Firestore
const db = admin.firestore();

// Test Firestore Write
(async () => {
  try {
    console.log("Attempting to add document to Firestore...");
    const docRef = await db.collection('testCollection').add({
      name: "Test User",
      email: "test@example.com"
    });
    console.log("Document added with ID:", docRef.id);
  } catch (error) {
    console.error("Error writing document to Firestore:", error.message);
  }
})();
