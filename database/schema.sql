CREATE DATABASE barcode_db;
USE barcode_db;

CREATE TABLE products (
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
('111222333444', 'Smartphone Stand', 'Adjustable stand for smartphones and tablets.', 15.99, 'Canada'),
('555666777888', 'USB-C Cable', 'Fast-charging USB-C cable for modern devices.', 9.99, 'South Korea'),
('000111222333', 'Laptop Cooling Pad', 'Cooling pad with multiple fan speeds.', 24.99, 'Germany');
