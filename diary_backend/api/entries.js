// api/entries.js

const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
const dotenv = require('dotenv');
const url = require('url');  // To parse the connection string

dotenv.config();  // Load environment variables from .env

const app = express();

app.use(cors());
app.use(express.json());

// Get the connection string from environment variables (you can put it in .env)
const dbConnectionString = process.env.TIDB_CONNECTION_STRING;

// Parse the MySQL connection string
const parsedUrl = url.parse(dbConnectionString);
const dbConfig = {
  host: parsedUrl.hostname,               // TiDB host
  user: parsedUrl.auth.split(':')[0],      // TiDB user (before the colon in the connection string)
  password: parsedUrl.auth.split(':')[1],  // TiDB password (after the colon in the connection string)
  database: parsedUrl.pathname.split('/')[1],  // TiDB database (after the first slash)
  port: parsedUrl.port,                   // TiDB port (4000 in your connection string)
  ssl: {
    rejectUnauthorized: true  // SSL configuration to ensure secure connection
  }
};

// Create the MySQL2 connection
const connection = mysql.createConnection(dbConfig);

// Test the connection
connection.connect(err => {
  if (err) {
    console.error('Error connecting to TiDB:', err.stack);
  } else {
    console.log('Connected to TiDB!');
  }
});

// CRUD Endpoints

// Endpoint to get all diary entries
app.get('/api/entries', (req, res) => {
  connection.query('SELECT * FROM diary_entries', (err, results) => {
    if (err) {
      console.error('Error fetching entries: ', err);
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json(results);
  });
});

// Endpoint to get a single diary entry by ID
app.get('/api/entries/:id', (req, res) => {
  const id = req.params.id;
  connection.query('SELECT * FROM diary_entries WHERE id = ?', [id], (err, results) => {
    if (err) {
      console.error('Error fetching entry: ', err);
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'Entry not found' });
    }
    res.status(200).json(results[0]);
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
      id: results.insertId
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

// Export the app for Vercel serverless functions
module.exports = app;
