-- The library issues membership cards to its members.
-- Books are categorized by genres.
-- Each book can have multiple copies.
-- Members can borrow books for a period, and late returns incur a fine.
-- Each book has a unique ISBN, but there can be multiple copies of the same book.

-- ER Diagram

-- Entities:

-- Member
-- Book
-- Genre
-- BookCopy
-- Borrow


-- Relationships:

-- Members can borrow multiple books.
-- Each book belongs to one genre.
-- Each book can have multiple copies.
-- Each borrow record is associated with one member and one book copy.

-- SQL za kreiranje baze knjiznica
-- kreirajte bazu i popunite sa proizvoljnim podacima

DROP DATABASE IF EXISTS library;

CREATE DATABASE IF NOT EXISTS library DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE library;

CREATE TABLE member (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(200),
    Phone VARCHAR(15),
    MembershipCardNumber VARCHAR(20)
);

CREATE TABLE genre (
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(100)
);

CREATE TABLE book (
    ISBN VARCHAR(13) PRIMARY KEY,
    Title VARCHAR(200),
    Author VARCHAR(100),
    GenreID INT,
    FOREIGN KEY (GenreID) REFERENCES genre(GenreID)
);

CREATE TABLE bookCopy (
    CopyID INT PRIMARY KEY,
    ISBN VARCHAR(13),
    AvailabilityStatus BOOLEAN,
    FOREIGN KEY (ISBN) REFERENCES book(ISBN)
);

CREATE TABLE borrow (
    BorrowID INT PRIMARY KEY,
    MemberID INT,
    CopyID INT,
    BorrowDate DATE,
    ReturnDate DATE,
    DueDate DATE,
    LateFee DECIMAL(5, 2),
    FOREIGN KEY (MemberID) REFERENCES member(MemberID),
    FOREIGN KEY (CopyID) REFERENCES bookCopy(CopyID)
);


INSERT INTO member (MemberID, Name, Address, Phone, MembershipCardNumber) 
VALUES 
    (1, 'John Doe', '123 Main St, City', '123-456-7890', 'MCN001'),
    (2, 'Jane Smith', '456 Oak St, Town', '987-654-3210', 'MCN002'),
    (3, 'Michael Johnson', '789 Pine St, Village', '555-123-4567', 'MCN003');

INSERT INTO genre (GenreID, GenreName) 
VALUES 
    (1, 'Science Fiction'),
    (2, 'Mystery'),
    (3, 'Romance'),
    (4, 'Fantasy');

INSERT INTO book (ISBN, Title, Author, GenreID) 
VALUES 
    ('9780451457998', 'Dune', 'Frank Herbert', 1),
    ('9780765326355', 'The Da Vinci Code', 'Dan Brown', 2),
    ('9780743477116', 'Angels & Demons', 'Dan Brown', 2),
    ('9780345391803', 'Jurassic Park', 'Michael Crichton', 1),
    ('9780061056480', 'Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 4),
    ('9780061124952', 'Twilight', 'Stephenie Meyer', 3);

INSERT INTO bookCopy (CopyID, ISBN, AvailabilityStatus) 
VALUES 
    (1, '9780451457998', true),
    (2, '9780451457998', true),
    (3, '9780765326355', true),
    (4, '9780743477116', true),
    (5, '9780345391803', true),
    (6, '9780061056480', true),
    (7, '9780061056480', true),
    (8, '9780061124952', true),
    (9, '9780061124952', true),
    (10, '9780061124952', true);

INSERT INTO borrow (BorrowID, MemberID, CopyID, BorrowDate, ReturnDate, DueDate, LateFee) 
VALUES 
    (1, 1, 1, '2024-06-01', '2024-06-10', '2024-06-08', 0.00),
    (2, 2, 3, '2024-06-02', '2024-06-10', '2024-06-09', 0.00),
    (3, 3, 5, '2024-06-03', NULL, '2024-06-10', NULL);