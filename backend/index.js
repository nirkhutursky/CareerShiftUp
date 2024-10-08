// Import required modules
const express = require('express');
const admin = require('firebase-admin');
const path = require('path');
const verifyToken = require('./authWare');
require('dotenv').config(); // Load environment variables

// Initialize Firebase Admin SDK using environment variable for the service account key
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

// Route to add a new resume
// Route to add a new resume

// Serve the Google Login Test HTML file
app.get('/google-login-test', (req, res) => {
  res.sendFile(path.join(__dirname, 'auth_test.html'));
});

// Route to add a new resume (only authenticated users can add a resume)
app.post('/add-resume', verifyToken, async (req, res) => {
  try {
    const resumeData = req.body;
    resumeData.userId = req.user.uid; // Add user's UID to the resume data

    const docRef = await db.collection('resumes').add(resumeData);
    res.status(201).json({ success: true, id: docRef.id });
  } catch (error) {
    console.error('Error adding resume:', error);
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
    console.error('Error fetching resumes:', error);
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
    console.error('Error fetching resume:', error);
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
    console.error('Error updating resume:', error);
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
    console.error('Error deleting resume:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
