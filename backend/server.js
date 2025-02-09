const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const path = require('path');

const app = express();
const port = 3000;

app.use(express.json());
app.use(cors());

// Serve static files (e.g., index.html) from the frontend folder
app.use(express.static(path.join(__dirname, 'frontend')));

// Database connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'barcode_db'
});

db.connect(err => {
  if (err) {
    console.error('Database connection failed:', err.stack);
    return;
  }
  console.log('Connected to the database.');
});

// API route for fetching product details by barcode
app.get('/api/product/:barcode', (req, res) => {
  const barcode = req.params.barcode;

  if (!barcode || barcode.trim() === '') {
    return res.status(400).json({ message: 'Barcode is required.' });
  }

  const query = 'SELECT * FROM products WHERE barcode = ?';
  db.query(query, [barcode], (error, results) => {
    if (error) {
      return res.status(500).json({ error: 'Database query failed' });
    }
    if (results.length > 0) {
      res.json(results[0]);
    } else {
      res.status(404).json({ message: 'Product not found' });
    }
  });
});

// Add a route to serve the root URL (index.html)
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'frontend', 'index.html'));
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});