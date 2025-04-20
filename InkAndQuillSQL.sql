-- Drop and recreate the database
DROP DATABASE IF EXISTS InkAndQuill;
CREATE DATABASE InkAndQuill;
USE InkAndQuill;

-- Create genre table
CREATE TABLE genre (
    g_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    g_name VARCHAR(30) NOT NULL,
    g_desc VARCHAR(60)
);

-- Create publisher table
CREATE TABLE publisher (
    p_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    p_name VARCHAR(100) NOT NULL,
    p_contactinfo VARCHAR(100),
    p_address VARCHAR(200)
);

-- Create author table
CREATE TABLE author (
    author_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    biography TEXT,
    nationality VARCHAR(50)
);

-- Create book table
CREATE TABLE book (
    isbn CHAR(13) NOT NULL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    publisher_id INT NOT NULL,
    publication_year INT NOT NULL,
    CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(p_id)
);

-- Junction table for books↔authors
CREATE TABLE book_author (
    book_isbn CHAR(13) NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_isbn, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_isbn) REFERENCES book(isbn),
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Junction table for books↔genres
CREATE TABLE book_genre (
    book_isbn CHAR(13) NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (book_isbn, genre_id),
    CONSTRAINT fk_bg_book FOREIGN KEY (book_isbn) REFERENCES book(isbn),
    CONSTRAINT fk_bg_genre FOREIGN KEY (genre_id) REFERENCES genre(g_id)
);

-- Create supplier table
CREATE TABLE supplier (
    supplier_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    address VARCHAR(200)
);

-- Create stock table
CREATE TABLE stock (
    stock_id INT AUTO_INCREMENT PRIMARY KEY,
    stock_quantity_available INT,
    restock_quantity INT,
    last_stock_date DATE,
    book_isbn CHAR(13) NOT NULL,
    supplier_id INT NOT NULL,
    CONSTRAINT fk_stock_book FOREIGN KEY (book_isbn) REFERENCES book(isbn),
    CONSTRAINT fk_stock_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

-- Create customer table
CREATE TABLE customer (
    customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    phone_number VARCHAR(20),
    address VARCHAR(200)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- Create order_item table
CREATE TABLE order_item (
    order_item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_isbn CHAR(13) NOT NULL,
    book_quantity INT,
    price DECIMAL(10, 2),
    CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_item_book FOREIGN KEY (book_isbn) REFERENCES book(isbn)
);

-- Create payment table
CREATE TABLE payment (
    payment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert genres
INSERT INTO genre (g_name, g_desc) VALUES
    ('Fantasy', 'Fantasy with magic'),
    ('Mystery', 'Detectives solving crimes'),
    ('Science Fiction', 'Futuristic, speculative science');

-- Insert publishers
INSERT INTO publisher (p_name, p_contactinfo, p_address) VALUES
    ('Penguin Random House', 'contact@penguin.com', '1745 Broadway, NY'),
    ('HarperCollins', 'contact@harpercollins.com', '195 Broadway, NY');

-- Insert authors
INSERT INTO author (name, biography, nationality) VALUES
    ('Toshikazu Kawaguchi', 'Japanese author of Before the Coffee Gets Cold.', 'Japanese'),
    ('Karen M. McManus', 'Author of Good Girl’s Guide to Murder series.', 'American'),
    ('J.K. Rowling', 'Author of the Harry Potter series.', 'British');

-- Insert books
INSERT INTO book (isbn, title, price, publisher_id, publication_year) VALUES
    ('9781405937220', 'Before the Coffee Gets Cold', 15.99, 1, 2019),
    ('9781405937221', 'Before the Coffee Gets Cold (eBook)', 9.99, 1, 2019),
    ('9781405937251', 'The 7½ Deaths of Evelyn Hardcastle', 14.99, 1, 2018),
    ('9780399544917', 'One of Us Is Lying', 12.99, 2, 2017),
    ('9780399593931', 'Good Girl, Bad Blood', 13.99, 2, 2020),
    ('9780747532743', 'Harry Potter and the Philosopher''s Stone', 19.99, 1, 1997),
    ('9780747532744', 'Harry Potter and the Philosopher''s Stone (eBook)', 11.99, 1, 1997);

-- Map books to authors
INSERT INTO book_author (book_isbn, author_id) VALUES
    ('9781405937220', 1),
    ('9781405937221', 1),
    ('9781405937251', 2),
    ('9780399544917', 2),
    ('9780399593931', 2),
    ('9780747532743', 3),
    ('9780747532744', 3);

-- Map books to genres
INSERT INTO book_genre (book_isbn, genre_id) VALUES
    ('9781405937220', 1),
    ('9781405937221', 1),
    ('9781405937251', 1),
    ('9780399544917', 2),
    ('9780399593931', 2),
    ('9780747532743', 1),
    ('9780747532744', 1);

-- Insert suppliers
INSERT INTO supplier (name, email, phone_number, address) VALUES
    ('BookSupplier1', 'contact@booksupplier1.com', '123-456-7890', '101 Supplier St, NY'),
    ('BookSupplier2', 'contact@booksupplier2.com', '987-654-3210', '202 Supplier Ave, LA');

-- insert stock records 
INSERT INTO stock (stock_quantity_available, restock_quantity, last_stock_date, book_isbn, supplier_id) VALUES
    (100, 50, '2025-04-15', '9781405937220', 1),
    (80,  40, '2025-04-16', '9781405937221', 1),
    (60,  30, '2025-04-17', '9781405937251', 2),
    (90,  45, '2025-04-18', '9780399544917', 2),
    (70,  35, '2025-04-19', '9780399593931', 1),
    (120, 60, '2025-04-20', '9780747532743', 1),
    (95,  50, '2025-04-21', '9780747532744', 2);

-- Insert customers
INSERT INTO customer (name, email, phone_number, address) VALUES
    ('John Doe', 'johndoe@example.com', '555-1234', '123 Elm St, NY'),
    ('Jane Smith', 'janesmith@example.com', '555-5678', '456 Oak St, LA');

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
    (1, '2025-04-10', 25.98, 'Shipped'),
    (1, '2025-04-15', 39.97, 'Delivered'),
    (2, '2025-04-12', 31.98, 'Pending'),
    (1, '2025-05-20', 14.99, 'Processing');

-- Insert order items
INSERT INTO order_item (order_id, book_isbn, book_quantity, price) VALUES
    (1, '9781405937220', 1, 15.99),
    (1, '9781405937221', 1, 9.99),
    (2, '9780399544917', 2, 12.99),
    (2, '9780399593931', 1, 13.99),
    (3, '9780747532743', 1, 19.99),
    (3, '9780747532744', 1, 11.99),
    (4, '9781405937251', 1, 14.99);

-- Insert payments
INSERT INTO payment (order_id, payment_date, amount_paid, payment_method) VALUES
    (1, '2025-04-10', 25.98, 'Credit Card'),
    (2, '2025-04-15', 39.97, 'PayPal'),
    (3, '2025-04-12', 31.98, 'Credit Card'),
    (4, '2025-05-20', 14.99, 'Credit Card');

--  Queries

-- q1: List all books by a specific author
SELECT b.title
FROM book b
JOIN book_author ba ON b.isbn = ba.book_isbn
JOIN author a ON ba.author_id = a.author_id
WHERE a.name = 'J.K. Rowling';

-- q2: List all books by specific genre
SELECT b.title
FROM book b
JOIN book_genre bg ON b.isbn = bg.book_isbn
JOIN genre g ON bg.genre_id = g.g_id
WHERE g.g_name = 'Fantasy';

-- q3: Retrieve all orders placed by a specific customer
SELECT o.order_id, o.order_date, o.total_amount, o.status
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
WHERE c.name = 'John Doe';

-- q4: Get the total sales amount for a specific book
SELECT b.title, SUM(oi.book_quantity * oi.price) AS total_revenue
FROM order_item oi
JOIN book b ON oi.book_isbn = b.isbn      
WHERE b.title = 'One of Us Is Lying'
GROUP BY b.title
ORDER BY total_revenue DESC;
 
 -- q5: Books with Low Stock (below 50)
SELECT b.title, s.stock_quantity_available
FROM stock s
JOIN book b ON s.book_isbn = b.isbn
WHERE s.stock_quantity_available < 50;


-- q6: Find all books published by a certain publisher
SELECT b.title, b.isbn, b.publication_year, p.p_name
FROM book b
JOIN publisher p ON b.publisher_id = p.p_id
WHERE p.p_name = 'HarperCollins';

-- q7: List all books that are currently out of stock
SELECT b.title, b.isbn
FROM book b
JOIN stock s ON b.isbn = s.book_isbn
WHERE s.stock_quantity_available = 0;

-- q8: List all inventory stock
SELECT s.stock_id, b.title, s.stock_quantity_available, s.restock_quantity, s.last_stock_date, sup.name AS supplier_name
FROM stock s
JOIN book b ON s.book_isbn = b.isbn
JOIN supplier sup ON s.supplier_id = sup.supplier_id;

 -- q9: ⁠Check if a specific book has stock available or is out of stock.
SELECT 
  b.title,
  s.stock_quantity_available,
  CASE 
    WHEN s.stock_quantity_available > 0 THEN 'In Stock'
    ELSE 'Out of Stock'
  END AS stock_status
FROM book b
JOIN stock s ON b.isbn = s.book_isbn
WHERE b.isbn = '9780747532743';

-- q10:  ⁠List all suppliers and the books they provide.
SELECT 
  sup.name AS supplier_name,
  b.title AS book_title,
  s.restock_quantity,
  s.last_stock_date
FROM supplier sup
JOIN stock s ON sup.supplier_id = s.supplier_id
JOIN book b ON s.book_isbn = b.isbn
ORDER BY sup.name, b.title;

-- q11  ⁠Find the supplier(s) for a specific book.
SELECT 
  b.title,
  sup.name AS supplier_name,
  sup.email,
  sup.phone_number
FROM stock s
JOIN supplier sup ON s.supplier_id = sup.supplier_id
JOIN book b ON s.book_isbn = b.isbn
WHERE b.isbn = '9780747532743';

-- q12 Retrieve all stock entries provided by a specific supplier
SELECT 
  s.stock_id,
  b.title AS book_title,
  s.stock_quantity_available,
  s.restock_quantity,
  s.last_stock_date
FROM stock s
JOIN book b ON s.book_isbn = b.isbn
JOIN supplier sup ON s.supplier_id = sup.supplier_id
WHERE sup.name = 'BookSupplier1';

-- q13 Find the most recent restock date for a given book.
SELECT 
  b.title,
  MAX(s.last_stock_date) AS most_recent_restock
FROM stock s
JOIN book b ON s.book_isbn = b.isbn
WHERE b.isbn = '9781405937220'
GROUP BY b.title;

-- q14 List all books supplied by a specific supplier along with their restock quantities
SELECT 
  b.title AS book_title,
  s.restock_quantity,
  s.last_stock_date
FROM stock s
JOIN book b ON s.book_isbn = b.isbn
JOIN supplier sup ON s.supplier_id = sup.supplier_id
WHERE sup.name = 'BookSupplier2'
ORDER BY s.last_stock_date DESC;