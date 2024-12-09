// api/entries.js

require('dotenv').config();
const mysql = require('mysql2');

// TiDB connection configuration using environment variables
const connection = mysql.createConnection({
  host: process.env.TIDB_HOST,
  port: process.env.TIDB_PORT,
  user: process.env.TIDB_USER,
  password: process.env.TIDB_PASSWORD,
  database: process.env.TIDB_DATABASE
});

module.exports = async (req, res) => {
  // Handle different HTTP methods (GET, POST, PUT, DELETE)
  
  if (req.method === 'GET') {
    // Get all diary entries
    const query = 'SELECT * FROM diary_entries';
    connection.query(query, (err, results) => {
      if (err) {
        console.error('Error fetching entries: ', err);
        return res.status(500).json({ error: err.message });
      }
      res.status(200).json(results);  // Return the diary entries
    });
  } else if (req.method === 'POST') {
    // Create a new diary entry
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
        id: results.insertId  // Return the ID of the newly inserted entry
      });
    });
  } else if (req.method === 'PUT') {
    // Update an existing diary entry
    const { id } = req.query;
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
  } else if (req.method === 'DELETE') {
    // Delete a diary entry
    const { id } = req.query;
    
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
  } else {
    // Invalid HTTP method
    res.status(405).json({ message: 'Method Not Allowed' });
  }
};
