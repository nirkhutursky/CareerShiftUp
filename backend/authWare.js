const admin = require('firebase-admin');

// Middleware function to verify Firebase ID Token
async function verifyToken(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, message: 'Unauthorized: No token provided' });
  }

  const idToken = authHeader.split(' ')[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken; // Attach the decoded token to the request for use in other routes
    next(); // Allow the request to proceed
  } catch (error) {
    console.error('Error verifying Firebase ID token:', error);
    res.status(401).json({ success: false, message: 'Unauthorized: Invalid token' });
  }
}

module.exports = verifyToken;
