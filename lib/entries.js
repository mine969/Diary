// Load environment variables from .env file (for local development)
require('dotenv').config();

const express = require('express');
const mysql = require('mysql2');
const app = express();
app.use(express.json());

// TiDB connection configuration using environment variables
const connection = mysql.createConnection({
  host: process.env.TIDB_HOST,       // The TiDB cluster endpoint
  user: process.env.TIDB_USER,       // TiDB username
  password: process.env.TIDB_PASSWORD, // TiDB password
  database: process.env.TIDB_DATABASE // TiDB database name
});

// Endpoint to get all diary entries
app.get('/api/entries', (req, res) => {
  const query = 'SELECT * FROM diary_entries'; // Get all entries from the diary_entries table
  connection.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching entries: ', err);
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json(results); // Return all entries
  });
});

// Endpoint to create a new diary entry
app.post('/api/entries', (req, res) => {
  const { title, content, date } = req.body;

  if (!title || !content || !date) {
    return res.status(400).json({ message: 'Title, content, and date are required' });
  }

  const query = 'INSERT INTO diary_entries (title, content, date) VALUES (?, ?, ?)';
  connection.query(query, [title, content, date], (err, results) => {
    if (err) {
      console.error('Error inserting entry: ', err);
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({
      message: 'Entry added successfully!',
      id: results.insertId // Return the ID of the newly inserted entry
    });
  });
});

// Endpoint to update an existing diary entry by ID
app.put('/api/entries/:id', (req, res) => {
  const { id } = req.params;
  const { title, content, date } = req.body;

  if (!title || !content || !date) {
    return res.status(400).json({ message: 'Title, content, and date are required' });
  }

  const query = 'UPDATE diary_entries SET title = ?, content = ?, date = ? WHERE id = ?';
  connection.query(query, [title, content, date, id], (err, results) => {
    if (err) {
      console.error('Error updating entry: ', err);
      return res.status(500).json({ error: err.message });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ message: 'Entry not found' });
    }
    res.status(200).json({ message: 'Entry updated successfully!' });
  });
});

// Endpoint to delete a diary entry by ID
app.delete('/api/entries/:id', (req, res) => {
  const { id } = req.params;

  const query = 'DELETE FROM diary_entries WHERE id = ?';
  connection.query(query, [id], (err, results) => {
    if (err) {
      console.error('Error deleting entry: ', err);
      return res.status(500).json({ error: err.message });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ message: 'Entry not found' });
    }
    res.status(200).json({ message: 'Entry deleted successfully!' });
  });
});

// Default route to check the API is running
app.get('/', (req, res) => {
  res.send('Diary App API is running!');
});

// Vercel serverless function entry point
module.exports = app;
