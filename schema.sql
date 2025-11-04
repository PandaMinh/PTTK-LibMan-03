-- schema.sql (standalone copy)
-- Recreated schema: matches ER diagram and Java models
-- Database and schema for library_management
CREATE DATABASE IF NOT EXISTS library_management DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_management;

-- User table (base for Reader/Staff)
CREATE TABLE IF NOT EXISTS tblUser (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  tel VARCHAR(50),
  address VARCHAR(255),
  email VARCHAR(255),
  dateOfBirth DATE,
  role VARCHAR(50)
);

-- Staff table: maps a User record that is a staff member
CREATE TABLE IF NOT EXISTS tblStaff (
  -- id là PRIMARY KEY cũng là foreign key to tblUser
    id INT PRIMARY KEY,
    CONSTRAINT fk_staff_user FOREIGN KEY (id) REFERENCES tblUser(id) ON DELETE CASCADE
    -- fk_staff_user là khóa ngoại liên kết đến tblUser
);

-- Librarian table: extension of Staff (one-to-one)
CREATE TABLE IF NOT EXISTS tblLibrarian (
  id INT PRIMARY KEY,
  CONSTRAINT fk_librarian_staff FOREIGN KEY (id) REFERENCES tblStaff(id) ON DELETE CASCADE
);

-- Reader table: uses same id as tblUser (user -> reader)
CREATE TABLE IF NOT EXISTS tblReader (
  id INT PRIMARY KEY,
  numberCard VARCHAR(100),
  issuedDate DATE,
  expiryDate DATE,
  description VARCHAR(255),
  CONSTRAINT fk_reader_user FOREIGN KEY (id) REFERENCES tblUser(id) ON DELETE CASCADE
);

-- Supplier (matches model.Supplier)
CREATE TABLE IF NOT EXISTS tblSupplier (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  tel VARCHAR(50),
  address VARCHAR(255),
  note VARCHAR(255)
);

-- Document (matches model.Document, extended with optional inventory fields)
CREATE TABLE IF NOT EXISTS tblDocument (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255),
  category VARCHAR(255),
  yearPublic INT,
  content TEXT,
  description TEXT
);

-- Importing invoice and details (matches models ImportingInvoice and ImportingDetail)
CREATE TABLE IF NOT EXISTS tblImportingInvoice (
  id INT AUTO_INCREMENT PRIMARY KEY,
  supplierId INT NOT NULL,
  librarianId INT NOT NULL,
  importDate DATETIME,
  typePay VARCHAR(100),
  bank VARCHAR(255),
  CONSTRAINT fk_import_supplier FOREIGN KEY (supplierId) REFERENCES tblSupplier(id) ON DELETE RESTRICT,
  CONSTRAINT fk_import_librarian FOREIGN KEY (librarianId) REFERENCES tblLibrarian(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS tblImportingDetail (
  id INT AUTO_INCREMENT PRIMARY KEY,
  invoiceId INT NOT NULL,
  documentId INT NOT NULL,
  price DECIMAL(12,2) DEFAULT 0,
  quantity INT DEFAULT 0,
  CONSTRAINT fk_impdetail_invoice FOREIGN KEY (invoiceId) REFERENCES tblImportingInvoice(id) ON DELETE CASCADE,
  CONSTRAINT fk_impdetail_document FOREIGN KEY (documentId) REFERENCES tblDocument(id) ON DELETE RESTRICT
);

-- Sample seed data

-- =========================
-- Sample data (idempotent)
-- =========================

-- Users: readers and librarians
INSERT INTO tblUser (username, password, name, tel, address, email, dateOfBirth, role)
VALUES
('reader1', 'password123', 'Hoang Van E', '0123456785', 'Ha Noi', 'reader1@example.com', '1990-01-01', 'READER'),
('reader2', 'password123', 'Vu Thi F', '0123456784', 'Ha Noi', 'reader2@example.com', '1992-05-15', 'READER'),
('librarian1', 'password123', 'Le Van C', '0123456787', 'Ha Noi', 'librarian1@example.com', '1985-03-20', 'LIBRARIAN'),
('reader3', 'password123', 'Nguyen Van R3', '0123000003', 'Ha Noi', 'r3@example.com', '1994-03-10', 'READER'),
('reader4', 'password123', 'Tran Thi R4', '0123000004', 'Hai Phong', 'r4@example.com', '1993-04-11', 'READER'),
('reader5', 'password123', 'Le Van R5', '0123000005', 'Da Nang', 'r5@example.com', '1992-05-12', 'READER'),
('reader6', 'password123', 'Pham Thi R6', '0123000006', 'Hue', 'r6@example.com', '1991-06-13', 'READER'),
('reader7', 'password123', 'Hoang Van R7', '0123000007', 'Nha Trang', 'r7@example.com', '1990-07-14', 'READER'),
('reader8', 'password123', 'Vu Thi R8', '0123000008', 'Vinh', 'r8@example.com', '1989-08-15', 'READER'),
('reader9', 'password123', 'Do Van R9', '0123000009', 'Hai Duong', 'r9@example.com', '1988-09-16', 'READER'),
('reader10', 'password123', 'Bui Thi R10', '0123000010', 'Ha Tinh', 'r10@example.com', '1987-10-17', 'READER'),
('librarian2', 'password123', 'Pham Thu L2', '0123090002', 'Ha Noi', 'l2@example.com', '1980-02-02', 'LIBRARIAN'),
('librarian3', 'password123', 'Doan Van L3', '0123090003', 'Ho Chi Minh', 'l3@example.com', '1979-03-03', 'LIBRARIAN')
ON DUPLICATE KEY UPDATE password=VALUES(password), name=VALUES(name), tel=VALUES(tel), address=VALUES(address), email=VALUES(email), dateOfBirth=VALUES(dateOfBirth), role=VALUES(role);

-- Readers: ensure tblReader entries exist for users with role READER
INSERT INTO tblReader (id, numberCard, issuedDate, expiryDate, description)
SELECT u.id, CONCAT('RC', LPAD(u.id,4,'0')), '2024-01-01', '2026-01-01', 'Auto-generated reader'
FROM tblUser u
WHERE u.role = 'READER'
  AND NOT EXISTS (SELECT 1 FROM tblReader r WHERE r.id = u.id);

-- Staff & Librarian: create tblStaff and tblLibrarian rows for librarian users
-- tblStaff and tblLibrarian use the same id as tblUser (per current schema design)
INSERT INTO tblStaff (id)
SELECT u.id FROM tblUser u WHERE u.role = 'LIBRARIAN' AND NOT EXISTS (SELECT 1 FROM tblStaff s WHERE s.id = u.id);

INSERT INTO tblLibrarian (id)
SELECT s.id FROM tblStaff s WHERE NOT EXISTS (SELECT 1 FROM tblLibrarian l WHERE l.id = s.id);

-- Suppliers: add a few suppliers if missing
INSERT INTO tblSupplier (name, tel, address, note)
SELECT 'NXB Kim Dong', '0987654321', 'Ha Noi', 'Supplier Kim Dong'
WHERE NOT EXISTS (SELECT 1 FROM tblSupplier WHERE name = 'NXB Kim Dong');

INSERT INTO tblSupplier (name, tel, address, note)
SELECT 'NXB Giao Duc', '0987654322', 'Ho Chi Minh', 'Supplier Giao Duc'
WHERE NOT EXISTS (SELECT 1 FROM tblSupplier WHERE name = 'NXB Giao Duc');

INSERT INTO tblSupplier (name, tel, address, note)
SELECT 'NXB Tre', '0987654323', 'Da Nang', 'Supplier Tre'
WHERE NOT EXISTS (SELECT 1 FROM tblSupplier WHERE name = 'NXB Tre');

-- Documents: insert sample documents if missing by title
INSERT INTO tblDocument (title, author, category, yearPublic, content, description)
SELECT 'Lap Trinh Java', 'Nguyen Van X', 'Textbook', 2023, 'Content A', 'Sach giao trinh Java co ban'
WHERE NOT EXISTS (SELECT 1 FROM tblDocument WHERE title = 'Lap Trinh Java');

INSERT INTO tblDocument (title, author, category, yearPublic, content, description)
SELECT 'Toan Cao Cap', 'Tran Van Y', 'Textbook', 2023, 'Content B', 'Sach giao trinh Toan cao cap'
WHERE NOT EXISTS (SELECT 1 FROM tblDocument WHERE title = 'Toan Cao Cap');

INSERT INTO tblDocument (title, author, category, yearPublic, content, description)
SELECT 'Doremon Tap 1', 'Fujiko F. Fujio', 'Comic', 2023, 'Content C', 'Truyen tranh Doremon'
WHERE NOT EXISTS (SELECT 1 FROM tblDocument WHERE title = 'Doremon Tap 1');

-- Create one importing invoice if none exist, linking first supplier and first librarian
INSERT INTO tblImportingInvoice (supplierId, librarianId, importDate, typePay, bank)
SELECT s.id, l.id, '2023-01-01 10:00:00', 'CASH', NULL
FROM (SELECT id FROM tblSupplier LIMIT 1) s
CROSS JOIN (SELECT id FROM tblLibrarian LIMIT 1) l
WHERE NOT EXISTS (SELECT 1 FROM tblImportingInvoice);

-- Create importing detail for that invoice if none exist
INSERT INTO tblImportingDetail (invoiceId, documentId, price, quantity)
SELECT i.id, d.id, 150000, 5
FROM (SELECT id FROM tblImportingInvoice LIMIT 1) i
CROSS JOIN (SELECT id FROM tblDocument WHERE title = 'Lap Trinh Java' LIMIT 1) d
WHERE NOT EXISTS (SELECT 1 FROM tblImportingDetail);

-- End of sample data

-- =========================
-- Add 20 more documents (idempotent)
-- =========================
INSERT INTO tblDocument (title, author, category, yearPublic, content, description)
SELECT t.title, t.author, t.category, t.yearPublic, t.content, t.description
FROM (
  SELECT 'Document 001 - Intro' AS title, 'Author A' AS author, 'General' AS category, 2015 AS yearPublic, 'Content 1' AS content, 'Mock doc' AS description
  UNION ALL SELECT 'Document 002 - Algorithms','Author B','CS',2016,'Content 2','Mock doc'
  UNION ALL SELECT 'Document 003 - Data Structures','Author C','CS',2017,'Content 3','Mock doc'
  UNION ALL SELECT 'Document 004 - Networks','Author D','CS',2018,'Content 4','Mock doc'
  UNION ALL SELECT 'Document 005 - OS','Author E','CS',2019,'Content 5','Mock doc'
  UNION ALL SELECT 'Document 006 - DBMS','Author F','CS',2020,'Content 6','Mock doc'
  UNION ALL SELECT 'Document 007 - Web Dev','Author G','CS',2021,'Content 7','Mock doc'
  UNION ALL SELECT 'Document 008 - Java Advanced','Author H','CS',2022,'Content 8','Mock doc'
  UNION ALL SELECT 'Document 009 - Spring Boot','Author I','CS',2023,'Content 9','Mock doc'
  UNION ALL SELECT 'Document 010 - Design Patterns','Author J','CS',2014,'Content 10','Mock doc'
  UNION ALL SELECT 'Document 011 - Algorithms II','Author K','CS',2013,'Content 11','Mock doc'
  UNION ALL SELECT 'Document 012 - Machine Learning','Author L','AI',2021,'Content 12','Mock doc'
  UNION ALL SELECT 'Document 013 - Deep Learning','Author M','AI',2022,'Content 13','Mock doc'
  UNION ALL SELECT 'Document 014 - NLP','Author N','AI',2020,'Content 14','Mock doc'
  UNION ALL SELECT 'Document 015 - Computer Vision','Author O','AI',2019,'Content 15','Mock doc'
  UNION ALL SELECT 'Document 016 - Software Eng','Author P','SE',2018,'Content 16','Mock doc'
  UNION ALL SELECT 'Document 017 - Testing','Author Q','SE',2017,'Content 17','Mock doc'
  UNION ALL SELECT 'Document 018 - DevOps','Author R','Ops',2020,'Content 18','Mock doc'
  UNION ALL SELECT 'Document 019 - Cloud Computing','Author S','Cloud',2021,'Content 19','Mock doc'
  UNION ALL SELECT 'Document 020 - Security','Author T','Security',2016,'Content 20','Mock doc'
) t
WHERE NOT EXISTS (SELECT 1 FROM tblDocument d WHERE d.title = t.title);

-- =========================
-- Insert many importing invoices (20) and details (2-5 per invoice)
-- =========================

-- Create 20 importing invoices with incremental dates using a derived numbers table
INSERT INTO tblImportingInvoice (supplierId, librarianId, importDate, typePay, bank)
SELECT s.id, l.id, DATE_ADD('2023-01-01', INTERVAL nums.n DAY) AS importDate, 'CASH', CONCAT('Bank ', (nums.n % 3) + 1)
FROM (
  SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
  UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
  UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
) nums
CROSS JOIN (SELECT id FROM tblSupplier LIMIT 1) s
CROSS JOIN (SELECT id FROM tblLibrarian LIMIT 1) l
WHERE NOT EXISTS (
  SELECT 1 FROM tblImportingInvoice ii WHERE ii.importDate = DATE_ADD('2023-01-01', INTERVAL nums.n DAY) AND ii.supplierId = s.id AND ii.librarianId = l.id
);

-- For the last 20 invoices inserted, add 2-5 details each using latest documents (idempotent)
INSERT INTO tblImportingDetail (invoiceId, documentId, price, quantity)
SELECT i.id AS invoiceId, d.id AS documentId, (100000 + (d.id % 10) * 5000) AS price, ((d.id % 5) + 1) * 2 AS quantity
FROM (SELECT id FROM tblImportingInvoice ORDER BY id DESC LIMIT 20) i
CROSS JOIN (SELECT id FROM tblDocument ORDER BY id DESC LIMIT 5) d
WHERE NOT EXISTS (
  SELECT 1 FROM tblImportingDetail idt WHERE idt.invoiceId = i.id AND idt.documentId = d.id
);

-- End of mass importing data
