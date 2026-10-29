-- Library Management System: schema (MySQL 8 / MariaDB)
DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE books (
    book_id          INT AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(150) NOT NULL,
    author           VARCHAR(100) NOT NULL,
    category_id      INT NOT NULL,
    total_copies     INT NOT NULL CHECK (total_copies >= 0),
    available_copies INT NOT NULL CHECK (available_copies >= 0),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE members (
    member_id   INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    phone       VARCHAR(15),
    joined_date DATE NOT NULL
);

CREATE TABLE issues (
    issue_id    INT AUTO_INCREMENT PRIMARY KEY,
    book_id     INT NOT NULL,
    member_id   INT NOT NULL,
    issue_date  DATE NOT NULL,
    due_date    DATE NOT NULL,
    return_date DATE NULL,
    FOREIGN KEY (book_id)   REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CHECK (due_date >= issue_date)
);

-- Trigger: when a book is issued, reduce available copies
DELIMITER //
CREATE TRIGGER trg_issue_book
AFTER INSERT ON issues
FOR EACH ROW
BEGIN
    UPDATE books SET available_copies = available_copies - 1
    WHERE book_id = NEW.book_id;
END//

-- Trigger: when a book is returned, increase available copies
CREATE TRIGGER trg_return_book
AFTER UPDATE ON issues
FOR EACH ROW
BEGIN
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        UPDATE books SET available_copies = available_copies + 1
        WHERE book_id = NEW.book_id;
    END IF;
END//
DELIMITER ;

-- View: books that are not returned and past the due date
CREATE VIEW overdue_books AS
SELECT i.issue_id,
       m.full_name,
       b.title,
       i.due_date,
       DATEDIFF(CURDATE(), i.due_date)        AS days_late,
       DATEDIFF(CURDATE(), i.due_date) * 2    AS fine_rupees   -- Rs. 2 per day
FROM issues i
JOIN members m ON m.member_id = i.member_id
JOIN books   b ON b.book_id   = i.book_id
WHERE i.return_date IS NULL
  AND i.due_date < CURDATE();
