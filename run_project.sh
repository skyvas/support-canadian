#!/bin/bash

# Step 1: Install Homebrew (if not installed)
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Step 2: Install MySQL and Node.js
echo "Installing MySQL and Node.js..."
brew install mysql node

# Step 3: Start MySQL service
echo "Starting MySQL service..."
brew services start mysql

# Step 4: Set up MySQL database and sample data
echo "Setting up the database..."

# Create the database and sample data
mysql -u root -e "
CREATE DATABASE IF NOT EXISTS barcode_db;
USE barcode_db;

CREATE TABLE IF NOT EXISTS products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  barcode VARCHAR(50) NOT NULL,
  product_name VARCHAR(100),
  description TEXT,
  price DECIMAL(10, 2),
  country_of_origin VARCHAR(50)
);

INSERT INTO products (barcode, product_name, description, price, country_of_origin) VALUES
('123456789012', 'Wireless Mouse', 'A high-precision wireless mouse with ergonomic design.', 29.99, 'USA'),
('987654321098', 'Bluetooth Speaker', 'Portable Bluetooth speaker with high-quality sound.', 49.99, 'China'),
('111222333444', 'Smartphone Stand', 'Adjustable stand for smartphones and tablets.', 15.99, 'India'),
('555666777888', 'USB-C Cable', 'Fast-charging USB-C cable for modern devices.', 9.99, 'South Korea'),
('000111222333', 'Laptop Cooling Pad', 'Cooling pad with multiple fan speeds.', 24.99, 'Germany');
"

# Step 5: Set up the backend (Node.js)
echo "Setting up the backend..."

# Create backend directory and write server.js file
mkdir -p ~/barcode-lookup-system/backend
cat > ~/barcode-lookup-system/backend/server.js <<EOL
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(express.json());
app.use(cors());

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

app.get('/api/product/:barcode', (req, res) => {
  const barcode = req.params.barcode;
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

app.listen(port, () => {
  console.log(\`Server running on http://localhost:\${port}\`);
});
EOL

# Step 6: Install backend dependencies
echo "Installing backend dependencies..."
cd ~/barcode-lookup-system/backend
npm init -y
npm install express mysql2 cors

# Step 7: Start the backend server
echo "Starting backend server..."
node server.js &

# Step 8: Provide instructions for frontend setup
echo "Frontend setup instructions:"
echo "1. Open the 'index.html' file located in the 'frontend' folder in your browser."
echo "2. The frontend will communicate with the backend API running on http://localhost:3000."

echo "Setup complete. Enjoy!"