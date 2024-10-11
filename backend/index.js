// Import required modules
const express = require('express');
const admin = require('firebase-admin');
const path = require('path');
const verifyToken = require('./authWare');
const rateLimit = require('express-rate-limit');
const winston = require('winston');
require('dotenv').config(); // Load environment variables

// Initialize Firebase Admin SDK using environment variable for the service account key
try {
  const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  console.log("Service Account Path:", serviceAccountPath);  // Add this line to confirm the path

  if (!admin.apps.length) {
    const serviceAccount = require(path.resolve(__dirname, serviceAccountPath));
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
    console.log("Firebase Admin initialized successfully");
  } else {
    console.log("Firebase Admin already initialized");
  }
} catch (error) {
  console.error("Error initializing Firebase Admin SDK:", error.message);
}

const db = admin.firestore();

// Set up Express app
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware to parse JSON requests
app.use(express.json());

// Set up rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
  message: { success: false, message: "Too many requests, please try again later." }
});

// Apply rate limiter to all requests
app.use(limiter);

// Set up winston for logging
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.printf(({ timestamp, level, message }) => {
      return `[${timestamp}] ${level.toUpperCase()}: ${message}`;
    })
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'server.log' })
  ],
});

// Middleware for logging requests
app.use((req, res, next) => {
  logger.info(`Incoming request: ${req.method} ${req.url}`);
  next();
});

// Serve the Google Login Test HTML file
app.get('/google-login-test', (req, res) => {
  res.sendFile(path.join(__dirname, 'auth_test.html'));
});

// New route to receive and verify ID token
app.post('/receive-token', async (req, res) => {
  const idToken = req.body.token;

  if (!idToken) {
    return res.status(400).json({ success: false, message: 'No token provided' });
  }

  try {
    // Verify the ID token using Firebase Admin SDK
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    logger.info(`Received and verified ID token for user: ${decodedToken.uid}`);
    console.log("Full ID Token:", idToken); // Print the raw ID token itself

    res.status(200).json({ success: true, message: 'Token received and verified successfully' });
  } catch (error) {
    logger.error(`Error verifying Firebase ID token: ${error.message}`);
    res.status(401).json({ success: false, message: 'Unauthorized: Invalid token format or expired' });
  }
});

// Route to add a new resume (only authenticated users can add a resume)
app.post('/add-resume', verifyToken, async (req, res) => {
  logger.info('Received request to add resume');
  try {
    const resumeData = req.body;
    resumeData.userId = req.user.uid; // Add user's UID to the resume data

    const docRef = await db.collection('resumes').add(resumeData);
    res.status(201).json({ success: true, id: docRef.id });
  } catch (error) {
    logger.error('Error adding resume:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Route to get all resumes of the authenticated user
app.get('/resumes', verifyToken, async (req, res) => {
  try {
    const userId = req.user.uid; // Get the UID from the authenticated user
    const snapshot = await db.collection('resumes').where('userId', '==', userId).get();

    const resumes = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));
    res.status(200).json(resumes);
  } catch (error) {
    logger.error('Error fetching resumes:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Route to get a specific resume by ID (only if it belongs to the authenticated user)
app.get('/resumes/:id', verifyToken, async (req, res) => {
  try {
    const { id } = req.params;
    const docRef = db.collection('resumes').doc(id);
    const doc = await docRef.get();

    if (doc.exists && doc.data().userId === req.user.uid) {
      res.status(200).json({ id: doc.id, ...doc.data() });
    } else {
      res.status(404).json({ success: false, message: 'Resume not found or access denied' });
    }
  } catch (error) {
    logger.error('Error fetching resume:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Route to update a resume by ID (only if it belongs to the authenticated user)
app.put('/resumes/:id', verifyToken, async (req, res) => {
  try {
    const { id } = req.params;
    const updatedData = req.body;
    const docRef = db.collection('resumes').doc(id);
    const doc = await docRef.get();

    if (doc.exists && doc.data().userId === req.user.uid) {
      await docRef.update(updatedData);
      res.status(200).json({ success: true, message: 'Resume updated successfully' });
    } else {
      res.status(404).json({ success: false, message: 'Resume not found or access denied' });
    }
  } catch (error) {
    logger.error('Error updating resume:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Route to delete a resume by ID (only if it belongs to the authenticated user)
app.delete('/resumes/:id', verifyToken, async (req, res) => {
  try {
    const { id } = req.params;
    const docRef = db.collection('resumes').doc(id);
    const doc = await docRef.get();

    if (doc.exists && doc.data().userId === req.user.uid) {
      await docRef.delete();
      res.status(200).json({ success: true, message: 'Resume deleted successfully' });
    } else {
      res.status(404).json({ success: false, message: 'Resume not found or access denied' });
    }
  } catch (error) {
    logger.error('Error deleting resume:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Start the server
app.listen(PORT, () => {
  logger.info(`Server is running on http://localhost:${PORT}`);
});
