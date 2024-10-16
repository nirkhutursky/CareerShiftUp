const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');
const logger = require('winston');
const verifyToken = require('../authWare'); // Ensure path is correct

const db = admin.firestore();

// Route to add a new resume (only authenticated users can add a resume)
router.post('/', verifyToken, async (req, res) => {
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
router.get('/', verifyToken, async (req, res) => {
  try {
    const userId = req.user.uid;
    const snapshot = await db.collection('resumes').where('userId', '==', userId).get();

    const resumes = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));
    res.status(200).json(resumes);
  } catch (error) {
    logger.error('Error fetching resumes:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Route to get a specific resume by ID (only if it belongs to the authenticated user)
router.get('/:id', verifyToken, async (req, res) => {
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
router.put('/:id', verifyToken, async (req, res) => {
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
router.delete('/:id', verifyToken, async (req, res) => {
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

module.exports = router;
