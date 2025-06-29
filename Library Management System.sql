CREATE TABLE authors(
author_id int auto_increment PRIMARY KEY,
name varchar(100) NOT NULL,
country varchar(100)
);

CREATE TABLE books(
book_id int auto_increment PRIMARY KEY,
title varchar(255) NOT NULL,
author_id int,
genre varchar(100),
publication_year year,
FOREIGN KEY(author_id) references authors(author_id)
);

CREATE TABLE members(
member_id int auto_increment PRIMARY KEY,
name varchar(255) NOT NULL,
membership_date date
);

CREATE TABLE loans(
loan_id int auto_increment PRIMARY KEY,
book_id int,
member_id int,
loan_date date NOT NULL,
return_date date,
FOREIGN KEY(book_id) references books(book_id),
FOREIGN KEY(member_id) references members(member_id)
);


INSERT INTO Authors (name, country) 
VALUES('J.K. Rowling', 'United Kingdom'),
('George R.R. Martin', 'United States'),
('Agatha Christie', 'United Kingdom'),
('J.R.R. Tolkien', 'United Kingdom'),
('Mark Twain', 'United States'),
('Jane Austen', 'United Kingdom'),
('Stephen King', 'United States'),
('Haruki Murakami', 'Japan'),
('Isabel Allende', 'Chile'),
('Chinua Achebe', 'Nigeria'),
('Gabriel García Márquez', 'Colombia'),
('C.S. Lewis', 'United Kingdom');

INSERT INTO books(title, author_id, genre, publication_year) 
VALUES('Harry Potter and the Sorcerer''s Stone', 1, 'Fantasy', 1997),
('A Game of Thrones', 2, 'Fantasy', 1996),
('Murder on the Orient Express', 3, 'Mystery', 1934),
('The Hobbit', 4, 'Fantasy', 1937),
('The Adventures of Tom Sawyer', 5, 'Adventure', 1876),
('Pride and Prejudice', 6, 'Romance', 1813),
('The Shining', 7, 'Horror', 1977),
('Kafka on the Shore', 8, 'Fiction', 2002),
('The House of the Spirits', 9, 'Magical Realism', 1982),
('Things Fall Apart', 10, 'Historical Fiction', 1958),
('One Hundred Years of Solitude', 11, 'Magical Realism', 1967),
('The Lion, the Witch, and the Wardrobe', 12, 'Fantasy', 1950);

INSERT INTO members(name, membership_date) 
VALUES('Alice Johnson', '2022-01-15'),
('Bob Smith', '2023-03-10'),
('Charlie Brown', '2021-07-25'),
('Diana Prince', '2022-11-01'),
('Ethan Hunt', '2023-05-20'),
('Fiona Gallagher', '2021-09-12'),
('George Bailey', '2023-06-18'),
('Hannah Montana', '2022-02-07'),
('Ian Malcolm', '2021-12-05'),
('Jessica Day', '2023-08-30'),
('Kevin McCallister', '2022-03-14'),
('Lara Croft', '2023-09-12');

INSERT INTO loans(book_id, member_id, loan_date, return_date)
VALUES(1, 1, '2023-12-01', '2023-12-15'),
(2, 2, '2023-12-02', '2023-12-16'),
(3, 3, '2023-11-20', '2023-12-04'),
(4, 4, '2023-11-25', '2023-12-09'),
(5, 5, '2023-12-03', '2023-12-17'),
(6, 6, '2023-11-30', '2023-12-14'),
(7, 7, '2023-12-01', NULL), 
(8, 8, '2023-12-05', NULL), 
(9, 9, '2023-12-06', '2023-12-20'),
(10, 10, '2023-11-18', '2023-12-02'),
(11, 11, '2023-12-04', '2023-12-18'),
(12, 12, '2023-12-07', NULL);


-- 1
SELECT name, title
FROM authors
JOIN books ON authors.author_id = books.author_id;

-- 2
SELECT loan_id,books.book_id, title, member_id, loan_date
FROM books
JOIN loans ON books.book_id = loans.book_id
WHERE loans.return_date IS NULL;

-- 3
SELECT authors.author_id, name, books.book_id, title, loan_date, return_date
FROM authors
JOIN books ON authors.author_id = books.author_id
JOIN loans ON books.book_id = loans.book_id
WHERE loans.return_date < curdate();

-- 4
SELECT genre, COUNT(*) as total
FROM books
GROUP BY genre;

-- 5
SELECT loan_id, book_id, member_id, total_purchases
FROM(
SELECT *,
RANK() OVER(partition by member_id) as total_purchases
FROM loans)  as x
WHERE x.total_purchases >= 3;

-- 6
SELECT books.book_id, title, COUNT(loan_id) as total
FROM books
JOIN loans ON books.book_id = loans.book_id
GROUP BY books.book_id
ORDER BY total desc
limit 1;

-- 7
SELECT name, title, publication_year
FROM authors
JOIN books ON authors.author_id = books.author_id
ORDER BY publication_year
limit 1;

-- 8
SELECT * FROM members
WHERE member_id NOT IN (SELECT member_id FROM loans);

-- 9
UPDATE loans
SET return_date = '2024-02-01'
WHERE loan_id = 7;

-- 10
DELETE FROM members
WHERE member_id = 4
AND member_id NOT IN(SELECT member_id FROM loans
WHERE return_date IS NULL);

-- FUNCTION
delimiter //
CREATE FUNCTION count_total_genre(p_genre varchar(100))
RETURNS int
DETERMINISTIC
begin
	DECLARE count_total int;
    SELECT COUNT(*) INTO count_total
    FROM books
    WHERE genre = p_genre;
    RETURN count_total;
end//
delimiter ;

-- TRIGGER
delimiter //
CREATE TRIGGER after_member_insert
AFTER INSERT ON members
FOR EACH ROW
begin
	INSERT INTO member_logs(member_id, member_name, log_message)
    VALUES(NEW.member_id, NEW.name, CONCAT('New mambered registered:',NEW.name));
end//
delimiter ;



SELECT * FROM authors;
SELECT * FROM books;
SELECT * FROM loans;
SELECT * FROM members;
SELECT * FROM member_logs;


