// api/entries.js

const mysql = require('mysql2');
const express = require('express');
const app = express();
app.use(express.json());

// TiDB connection configuration
const connection = mysql.createConnection({
  host: 'your-tidb-cluster-endpoint',  // Replace with your TiDB cluster endpoint
  user: 'your-tidb-username',          // Replace with your TiDB username
  password: 'your-tidb-password',      // Replace with your TiDB password
  database: 'your-database-name'       // Replace with your TiDB database name
});

// CRUD APIs for diary entries

// 1. Create Entry
app.post('/api/entries', (req, res) => {
  const { title, content, date } = req.body;

  const query = 'INSERT INTO diary_entries (title, content, date) VALUES (?, ?, ?)';
  connection.query(query, [title, content, date], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Entry added successfully!', id: results.insertId });
  });
});

// 2. Get All Entries
app.get('/api/entries', (req, res) => {
  const query = 'SELECT * FROM diary_entries';
  connection.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json(results);
  });
});

// 3. Update Entry
app.put('/api/entries/:id', (req, res) => {
  const { title, content, date } = req.body;
  const { id } = req.params;

  const query = 'UPDATE diary_entries SET title = ?, content = ?, date = ? WHERE id = ?';
  connection.query(query, [title, content, date, id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json({ message: 'Entry updated successfully!' });
  });
});

// 4. Delete Entry
app.delete('/api/entries/:id', (req, res) => {
  const { id } = req.params;

  const query = 'DELETE FROM diary_entries WHERE id = ?';
  connection.query(query, [id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json({ message: 'Entry deleted successfully!' });
  });
});

// Vercel serverless function entry point
module.exports = app;
