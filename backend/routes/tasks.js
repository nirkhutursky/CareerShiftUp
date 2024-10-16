const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');
const logger = require('winston');
const verifyToken = require('../authWare'); // Adjust path if necessary

const db = admin.firestore();

// Helper function to calculate the default deadline (one week from now)
const getDefaultDeadline = () => {
  const defaultDeadline = new Date();
  defaultDeadline.setDate(defaultDeadline.getDate() + 7);
  return defaultDeadline.toISOString();
};

// Route to add a new task
router.post('/', verifyToken, async (req, res) => {
  try {
    const { title, description, deadline, isTemplate } = req.body;
    const userId = req.user.uid;

    const newTask = {
      title,
      description: description || '',
      status: 'pending',
      deadline: deadline || getDefaultDeadline(),
      userId,
      isTemplate: isTemplate || false,
    };

    const docRef = await db.collection('users').doc(userId).collection('tasks').add(newTask);
    res.status(201).json({ success: true, taskId: docRef.id, message: 'Task added successfully' });
  } catch (error) {
    logger.error('Error adding task:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Route to get all tasks for the authenticated user
router.get('/', verifyToken, async (req, res) => {
  try {
    const userId = req.user.uid;
    const snapshot = await db.collection('users').doc(userId).collection('tasks').get();

    const tasks = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));
    res.status(200).json(tasks);
  } catch (error) {
    logger.error('Error fetching tasks:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Route to update a task by ID
router.put('/:id', verifyToken, async (req, res) => {
  try {
    const { id } = req.params;
    const updatedData = req.body;
    const userId = req.user.uid;

    const taskRef = db.collection('users').doc(userId).collection('tasks').doc(id);
    const doc = await taskRef.get();

    if (doc.exists) {
      await taskRef.update(updatedData);
      res.status(200).json({ success: true, message: 'Task updated successfully' });
    } else {
      res.status(404).json({ success: false, message: 'Task not found' });
    }
  } catch (error) {
    logger.error('Error updating task:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Route to delete a task by ID
router.delete('/:id', verifyToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.uid;

    const taskRef = db.collection('users').doc(userId).collection('tasks').doc(id);
    const doc = await taskRef.get();

    if (doc.exists) {
      await taskRef.delete();
      res.status(200).json({ success: true, message: 'Task deleted successfully' });
    } else {
      res.status(404).json({ success: false, message: 'Task not found' });
    }
  } catch (error) {
    logger.error('Error deleting task:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

module.exports = router;
