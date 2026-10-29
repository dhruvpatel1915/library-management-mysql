USE library_db;

-- 1. All books with their category (JOIN)
SELECT b.title, b.author, c.category_name, b.available_copies
FROM books b
JOIN categories c ON c.category_id = b.category_id
ORDER BY c.category_name, b.title;

-- 2. Books currently available to issue
SELECT title, available_copies FROM books WHERE available_copies > 0;

-- 3. Which member has which book right now (not returned)
SELECT m.full_name, b.title, i.issue_date, i.due_date
FROM issues i
JOIN members m ON m.member_id = i.member_id
JOIN books   b ON b.book_id   = i.book_id
WHERE i.return_date IS NULL;

-- 4. Overdue books with fine (uses the view)
SELECT * FROM overdue_books ORDER BY days_late DESC;

-- 5. Number of books issued per category (GROUP BY)
SELECT c.category_name, COUNT(*) AS times_issued
FROM issues i
JOIN books b      ON b.book_id = i.book_id
JOIN categories c ON c.category_id = b.category_id
GROUP BY c.category_name
ORDER BY times_issued DESC;

-- 6. Most active members (GROUP BY + HAVING)
SELECT m.full_name, COUNT(*) AS books_issued
FROM issues i
JOIN members m ON m.member_id = i.member_id
GROUP BY m.member_id, m.full_name
HAVING COUNT(*) >= 2;

-- 7. Members who have never borrowed a book (LEFT JOIN)
SELECT m.full_name
FROM members m
LEFT JOIN issues i ON i.member_id = m.member_id
WHERE i.issue_id IS NULL;

-- 8. Search a book by part of its title
SELECT * FROM books WHERE title LIKE '%Java%';
