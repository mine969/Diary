// server.js (for local testing only)

require('dotenv').config();  // Load environment variables from .env file
const express = require('express');
const app = express();

// Middleware to parse JSON request bodies
app.use(express.json());

// Import the entries API (the serverless function code for handling CRUD operations)
app.use('/api/entries', require('./api/entries'));

// Start the server locally (for testing purposes)
const PORT = process.env.PORT || 3000;  // Default to port 3000 if not provided in environment variables
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
