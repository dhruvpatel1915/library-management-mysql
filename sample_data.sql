USE library_db;

INSERT INTO categories (category_name) VALUES
('Programming'), ('Database'), ('Networking'), ('Design'), ('Fiction');

INSERT INTO books (title, author, category_id, total_copies, available_copies) VALUES
('Head First Java',              'Kathy Sierra',      1, 4, 4),
('Java: The Complete Reference', 'Herbert Schildt',   1, 3, 3),
('Learning SQL',                 'Alan Beaulieu',     2, 3, 3),
('Database System Concepts',     'Silberschatz',      2, 2, 2),
('Computer Networks',            'Andrew Tanenbaum',  3, 2, 2),
('The Design of Everyday Things','Don Norman',        4, 2, 2),
('Wings of Fire',                'A. P. J. Abdul Kalam', 5, 5, 5);

INSERT INTO members (full_name, email, phone, joined_date) VALUES
('Rohit Shah',   'rohit@example.com',  '9000000001', '2026-06-15'),
('Meera Patel',  'meera@example.com',  '9000000002', '2026-07-01'),
('Aman Desai',   'aman@example.com',   '9000000003', '2026-07-20'),
('Priya Mehta',  'priya@example.com',  '9000000004', '2026-08-05'),
('Neha Joshi',   'neha@example.com',   '9000000005', '2026-09-12');

-- Issues (triggers reduce available_copies automatically)
INSERT INTO issues (book_id, member_id, issue_date, due_date, return_date) VALUES
(1, 1, '2026-09-01', '2026-09-15', NULL),          -- overdue
(3, 2, '2026-09-10', '2026-09-24', NULL),          -- overdue
(7, 3, '2026-10-20', '2026-11-03', NULL),          -- not yet due
(2, 1, '2026-08-10', '2026-08-24', NULL),          -- will be returned below
(5, 4, '2026-10-01', '2026-10-15', NULL);          -- overdue

-- Return one book (trigger increases available_copies)
UPDATE issues SET return_date = '2026-08-22' WHERE issue_id = 4;
