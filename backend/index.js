const express = require('express');
const admin = require('firebase-admin');
const path = require('path');
const rateLimit = require('express-rate-limit');
const winston = require('winston');
const cors = require('cors');
require('dotenv').config();

// Initialize Firebase Admin SDK
try {
  const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;

  if (!admin.apps.length) {
    const serviceAccount = require(path.resolve(__dirname, serviceAccountPath));
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    console.log('Firebase Admin initialized successfully');
  } else {
    console.log('Firebase Admin already initialized');
  }
} catch (error) {
  console.error('Error initializing Firebase Admin SDK:', error.message);
}

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: { success: false, message: 'Too many requests, please try again later.' },
});
app.use(limiter);

// Logging setup
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.printf(({ timestamp, level, message }) => `[${timestamp}] ${level.toUpperCase()}: ${message}`)
  ),
  transports: [new winston.transports.Console(), new winston.transports.File({ filename: 'server.log' })],
});

app.use((req, res, next) => {
  logger.info(`Incoming request: ${req.method} ${req.url}`);
  next();
});

// Import routes
const taskRoutes = require('./routes/tasks');
const resumeRoutes = require('./routes/resumes');

// Use routes
app.use('/tasks', taskRoutes);
app.use('/resumes', resumeRoutes);

// Start the server
app.listen(PORT, () => {
  logger.info(`Server is running on http://localhost:${PORT}`);
});
