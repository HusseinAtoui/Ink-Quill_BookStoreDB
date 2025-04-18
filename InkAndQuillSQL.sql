-- Drop and recreate the database
DROP DATABASE IF EXISTS InkAndQuill;
CREATE DATABASE InkAndQuill;
USE InkAndQuill;

-- genre table
CREATE TABLE genre (
    g_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    g_name VARCHAR(30) NOT NULL,
    g_desc VARCHAR(60)
);

-- publisher table
CREATE TABLE publisher (
    p_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    p_name VARCHAR(100) NOT NULL,
    p_contactinfo VARCHAR(100),
    p_address VARCHAR(200)
);

-- author table
CREATE TABLE author (
    author_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    biography TEXT,
    nationality VARCHAR(50)
);

-- book table
CREATE TABLE book (
    isbn CHAR(13) NOT NULL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    genre INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    publisher_id INT NOT NULL,
    publication_year INT NOT NULL,
    CONSTRAINT fk_book_genre FOREIGN KEY (genre) REFERENCES genre(g_id),
    CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(p_id)
);

-- rlt: books and authors
CREATE TABLE book_author (
    book_isbn CHAR(13) NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_isbn, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_isbn) REFERENCES book(isbn),
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- supplier table
CREATE TABLE supplier (
    supplier_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    address VARCHAR(200)
);

-- stock table
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

-- customer table
CREATE TABLE customer (
    customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    phone_number VARCHAR(20),
    address VARCHAR(200)
);

-- orders table
CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- order_item table
CREATE TABLE order_item (
    order_item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_isbn CHAR(13) NOT NULL,
    book_quantity INT,
    price DECIMAL(10, 2),
    CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_item_book FOREIGN KEY (book_isbn) REFERENCES book(isbn)
);

-- payment table
CREATE TABLE payment (
    payment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert genres
INSERT INTO genre (g_id, g_name, g_desc) VALUES
    (1, 'Fantasy', 'Fantasy with magic'),
    (2, 'Mystery', 'Detectives solving crimes'),
    (3, 'Science Fiction', 'Futuristic, speculative science');

-- Insert publishers
INSERT INTO publisher (p_id, p_name, p_contactinfo, p_address) VALUES
    (1, 'Penguin Random House', 'contact@penguin.com', '1745 Broadway, NY'),
    (2, 'HarperCollins', 'contact@harpercollins.com', '195 Broadway, NY');

-- Insert authors
INSERT INTO author (author_id, name, biography, nationality) VALUES
    (1, 'Toshikazu Kawaguchi', 'Japanese author of Before the Coffee Gets Cold.', 'Japanese'),
    (2, 'Karen M. McManus', 'Author of Good Girl’s Guide to Murder series.', 'American'),
    (3, 'J.K. Rowling', 'Author of the Harry Potter series.', 'British');

-- Insert books
INSERT INTO book (isbn, title, genre, price, publisher_id, publication_year) VALUES
    ('9781405937220', 'Before the Coffee Gets Cold', 1, 15.99, 1, 2019),
    ('9781405937251', 'The 7½ Deaths of Evelyn Hardcastle', 1, 14.99, 1, 2018),
    ('9780399544917', 'One of Us Is Lying', 2, 12.99, 2, 2017),
    ('9780399593931', 'Good Girl, Bad Blood', 2, 13.99, 2, 2020),
    ('9780747532743', 'Harry Potter and the Philosopher''s Stone', 1, 19.99, 1, 1997),
    ('9780747538493', 'Harry Potter and the Chamber of Secrets', 1, 20.99, 1, 1998),
    ('9780747551003', 'Harry Potter and the Prisoner of Azkaban', 1, 21.99, 1, 1999);

-- Map books to authors
INSERT INTO book_author (book_isbn, author_id) VALUES
    ('9781405937220', 1),
    ('9781405937251', 2),
    ('9780399544917', 2),
    ('9780399593931', 2),
    ('9780747532743', 3),
    ('9780747538493', 3),
    ('9780747551003', 3);

-- Insert suppliers
INSERT INTO supplier (supplier_id, name, email, phone_number, address) VALUES
    (1, 'BookSupplier1', 'contact@booksupplier1.com', '123-456-7890', '101 Supplier St, NY'),
    (2, 'BookSupplier2', 'contact@booksupplier2.com', '987-654-3210', '202 Supplier Ave, LA');

-- Insert stock records
INSERT INTO stock (stock_quantity_available, restock_quantity, last_stock_date, book_isbn, supplier_id) VALUES
    (100, 50, '2025-04-15', '9781405937220', 1),
    (50, 30, '2025-04-14', '9781405937251', 1),
    (75, 40, '2025-04-16', '9780399544917', 2),
    (80, 60, '2025-04-15', '9780399593931', 2),
    (120, 50, '2025-04-17', '9780747532743', 1),
    (110, 45, '2025-04-16', '9780747538493', 1),
    (90, 40, '2025-04-15', '9780747551003', 1);

-- Insert customers
INSERT INTO customer (customer_id, name, email, phone_number, address) VALUES
    (1, 'John Doe', 'johndoe@example.com', '555-1234', '123 Elm St, NY'),
    (2, 'Jane Smith', 'janesmith@example.com', '555-5678', '456 Oak St, LA');

-- Insert orders
INSERT INTO orders (order_id, customer_id, order_date, total_amount, status) VALUES
    (1, 1, '2025-04-10', 50.97, 'Shipped'),
    (2, 2, '2025-04-12', 59.97, 'Pending');

-- Insert order items
INSERT INTO order_item (order_item_id, order_id, book_isbn, book_quantity, price) VALUES
    (1, 1, '9781405937220', 2, 15.99),
    (2, 1, '9780399544917', 1, 12.99),
    (3, 2, '9780747532743', 1, 19.99);

-- Insert payments
INSERT INTO payment (payment_id, order_id, payment_date, amount_paid, payment_method) VALUES
    (1, 1, '2025-04-10', 50.97, 'Credit Card'),
    (2, 2, '2025-04-12', 59.97, 'PayPal');

-- q1: List all books by a specific author
SELECT b.title
FROM book b
JOIN book_author ba ON b.isbn = ba.book_isbn
JOIN author a ON ba.author_id = a.author_id
WHERE a.name = 'J.K. Rowling';
