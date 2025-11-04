CREATE DATABASE IF NOT EXISTS market08;
USE market08;

CREATE TABLE user (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(150),
  fullName VARCHAR(100),
  role VARCHAR(20) DEFAULT 'CUSTOMER'
);

CREATE TABLE customer (
  userId INT AUTO_INCREMENT PRIMARY KEY,
  FOREIGN KEY (userId) REFERENCES user (id) ON DELETE CASCADE
);

CREATE TABLE address (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customerId INT NOT NULL,
  street VARCHAR(255),
  province VARCHAR(255),
  country VARCHAR(255),
  FOREIGN KEY (customerId) REFERENCES customer(userId) ON DELETE CASCADE
);

CREATE TABLE product (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price FLOAT NOT NULL,
  quantity INT DEFAULT 0
);

CREATE TABLE onlineOrder (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customerId INT NOT NULL,
  addressId INT NOT NULL,
  status VARCHAR(50) DEFAULT 'PENDING',
  orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customerId) REFERENCES customer(userId),
  FOREIGN KEY (addressId) REFERENCES address(id)
);

CREATE TABLE orderDetail (
  id INT AUTO_INCREMENT PRIMARY KEY,
  onlineOrderId INT NOT NULL,
  productId INT NOT NULL,
  price FLOAT NOT NULL,
  quantity INT NOT NULL,
  FOREIGN KEY (onlineOrderId) REFERENCES onlineOrder(id) ON DELETE CASCADE,
  FOREIGN KEY (productId) REFERENCES product(id)
);

DELETE FROM `user` WHERE username IN ('admin', 'user');
INSERT INTO `user` (id, username, password, phone, email, fullName, role) VALUES
(1, 'admin', '$2a$12$gg3BQ1dh9K26H3ywr.RWSuVmbbNh6wlno9Hd7xilgxa.mkiPp1gNK', '0123456789', 'admin@example.com', 'Admin Demo', 'ADMIN'),
(2, 'user',  '$2a$12$gg3BQ1dh9K26H3ywr.RWSuVmbbNh6wlno9Hd7xilgxa.mkiPp1gNK', '0987654321', 'user@example.com',  'User Demo',  'CUSTOMER');
INSERT INTO customer (userId) VALUES (2);

INSERT INTO product (id, name, description, price, quantity) VALUES
(1, 'Tivi Samsung 55 inch', 'Smart TV, 4K UHD, HDR', 15000000, 50),
(2, 'Tivi LG 50 inch', 'Smart TV, Full HD, HDR10', 12000000, 30),
(3, 'Tivi Sony 65 inch', 'OLED, 4K UHD, Smart TV', 35000000, 20),
(4, 'Máy giặt Electrolux 9kg', 'Giặt 9kg, lồng ngang, inverter', 8500000, 15),
(5, 'Máy giặt Samsung 10kg', 'Lồng ngang, giặt nhanh, inverter', 9500000, 10),
(6, 'Tủ lạnh Panasonic 300L', 'Ngăn đá dưới, tiết kiệm điện', 7500000, 12),
(7, 'Tủ lạnh LG 350L', 'Ngăn đá trên, công nghệ Inverter', 8800000, 8),
(8, 'Điều hòa Daikin 1 HP', 'Làm lạnh nhanh, tiết kiệm điện', 6500000, 25),
(9, 'Điều hòa Panasonic 2 HP', 'Làm lạnh nhanh, gas R32', 12000000, 10),
(10, 'Máy hút bụi Philips', 'Công suất 2000W, lọc HEPA', 2500000, 30);

INSERT INTO address (id, customerId, street, province, country) VALUES
(1, 2, '123 Lê Lợi', 'Hà Nội', 'Việt Nam'),
(2, 2, '456 Trần Phú', 'Hà Nội', 'Việt Nam'),
(3, 2, '789 Nguyễn Huệ', 'Hà Nội', 'Việt Nam'),
(4, 2, '101 Lý Thường Kiệt', 'Hà Nội', 'Việt Nam'),
(5, 2, '202 Phan Đình Phùng', 'Hà Nội', 'Việt Nam');
