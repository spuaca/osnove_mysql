-- ### Baza podataka jednostavne knjiznice
-- - Knjižnica svojim članovima izdaje članske iskaznice.
-- - Knjige su kategorizirane po žanrovima.
-- - Svaka knjiga ima jedinstveni ISBN, ali može postojati više kopija iste knjige.
-- - Knjižnica treba pratiti svaku fizičku kopiju knjige i stanje dostupnosti iste.
-- - Članovi mogu posuđivati ​​knjige na određeno vrijeme, a zakašnjeli povrati povlače novčanu kaznu.

-- ### ER Diagram
-- Entiteti:
-- - Član
-- - Knjiga
-- - Kategorija (Žanr)
-- - Kopija
-- - Posudba

-- ### Relacije
-- - Članovi mogu posuditi više knjiga.
-- - Svaka knjiga pripada jednom žanru.
-- - Svaka knjiga može imati više primjeraka.
-- - Svaki zapIS o posudbi povezan je s jednim članom i jednim primjerkom knjige.

-- ### SQL naredbe za kreiranje baze

-- kreirajte bazu i popunite tablice sa proizvoljnim podacima

-- ```sql
DROP DATABASE IF EXISTS knjiznica;
CREATE DATABASE IF NOT EXISTS knjiznica DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE knjiznica;

-- Tablica za članove knjižnice
CREATE TABLE IF NOT EXISTS clanovi (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ime VARCHAR(100) NOT NULL,
    prezime VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    datum_rodjenja DATE,
    datum_clanstva DATE NOT NULL DEFAULT (CURDATE())
);-- ako ne navedemo ENGINE=InnoDB MySQL ce po zadanim postavkama sam postaviti InnoDB

-- Tablica za žanrove knjiga
CREATE TABLE IF NOT EXISTS zanrovi (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naziv VARCHAR(100) UNIQUE NOT NULL
);

-- Tablica za knjige
CREATE TABLE IF NOT EXISTS knjige (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naslov VARCHAR(200) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    zanr_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zanr_id) REFERENCES zanrovi(id) ON DELETE CASCADE
);

-- Tablica za fizičke kopije knjiga
CREATE TABLE IF NOT EXISTS kopija (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    knjiga_id INT UNSIGNED NOT NULL,
    barkod VARCHAR(50) NOT NULL,
    dostupna BOOLEAN DEFAULT TRUE,
    UNIQUE (knjiga_id, barkod),
    FOREIGN KEY (knjiga_id) REFERENCES knjige(id)
);

-- Tablica za posudbe
CREATE TABLE IF NOT EXISTS posudbe (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    clan_id INT UNSIGNED NOT NULL,
    kopija_id INT UNSIGNED NOT NULL,
    datum_posudbe DATE NOT NULL DEFAULT (CURDATE()),
    datum_povrata DATE DEFAULT NULL,
    zakasnina DECIMAL(5, 2) DEFAULT NULL,
    FOREIGN KEY (clan_id) REFERENCES clanovi(id),
    FOREIGN KEY (kopija_id) REFERENCES kopija(id)
);

-- Umetanje podataka u tablicu clanovi
INSERT INTO clanovi (ime, prezime, email, datum_rodjenja, datum_clanstva) VALUES
('Ivan', 'Horvat', 'ivan.horvat@example.com', '1980-01-15', '2023-01-01'),
('Ana', 'Marić', 'ana.maric@example.com', '1990-05-10', '2023-02-15'),
('Petar', 'Novak', 'petar.novak@example.com', '1975-08-20', '2023-03-01'),
('Maja', 'Kovač', 'maja.kovac@example.com', '1985-12-25', '2023-04-10');

-- Umetanje podataka u tablicu zanrovi
INSERT INTO zanrovi (naziv) VALUES
('Znanstvena fantastika'),
('Ljubavni roman'),
('Kriminalistički roman'),
('Biografija');

-- Umetanje podataka u tablicu knjige
INSERT INTO knjige (naslov, autor, isbn, zanr_id) VALUES
('Dina', 'Frank Herbert', '978-3-16-148410-0', 1),
('Ponos i predrasude', 'Jane Austen', '978-0-14-143951-8', 2),
('Umorstva u Ulici Morgue', 'Edgar Allan Poe', '978-1-85326-015-5', 3),
('Steve Jobs', 'Walter Isaacson', '978-1-4516-4853-9', 4);

-- Umetanje podataka u tablicu kopija
INSERT INTO kopija (knjiga_id, barkod, dostupna) VALUES
(1, '1234567890123', TRUE),
(1, '1234567890124', TRUE),
(2, '1234567890125', TRUE),
(2, '1234567890126', FALSE),
(3, '1234567890127', TRUE),
(4, '1234567890128', TRUE);

-- Umetanje podataka u tablicu posudbe
INSERT INTO posudbe (clan_id, kopija_id, datum_posudbe, datum_povrata, zakasnina) VALUES
(1, 1, '2023-06-01', '2023-06-15', NULL),
(2, 3, '2023-06-05', '2023-06-20', NULL),
(3, 4, '2023-06-10', '2023-06-25', 10.00),  -- Zakasnina zbog kašnjenja
(4, 6, '2023-06-15', NULL, NULL);

-- nova posudba
INSERT INTO posudbe (clan_id, kopija_id, datum_posudbe) VALUES (1, 3, '2023-06-05');
-- ```


-- ### Zadaca:
-- #### Napraviti Upite na bazi podataka "knjiznica"
-- 1. Navedite sve članove koji su posudili knjige, zajedno s naslovima knjiga koje su posudili.
SELECT c.id AS clan_id, c.ime, c.prezime, kn.naslov FROM posudbe p
CONCAT(clanovi.ime , " " , clanovi.prezime) AS Ime
JOIN clanovi c ON c.id = p.clan_id
JOIN kopija ko ON ko.id = p.kopija_id
JOIN knjige kn ON kn.id = ko.knjiga_id;
-- WHERE p.datum_povrata IS NULL; /* koji jos nisu vratili */

-- 2. Pronađite članove koji imaju zakašnjele knjige.
-- SELECT c.id AS clan_id, c.ime, c.prezime FROM posudbe p
-- JOIN clanovi c ON c.id = p.clan_id
-- WHERE p.zakasnina IS NOT NULL;

SELECT c.id AS clan_id, c.ime, c.prezime, p.datum_posudbe, p.datum_povrata FROM posudbe p
JOIN clanovi c ON c.id = p.clan_id
WHERE
    p.datum_povrata IS NULL AND CURDATE() - p.datum_posudbe > 14
    OR
    p.datum_povrata - p.datum_posudbe > 14;

-- 3. Pronađite sve žanrove i broj dostupnih knjiga u svakom žanru.
SELECT z.naziv, COUNT(ko.id) AS broj_dostupnih_knjiga
FROM zanrovi z
JOIN knjige kn ON kn.zanr_id = z.id
JOIN kopija ko ON ko.knjiga_id = kn.id
WHERE ko.dostupna > 0
GROUP BY z.id
ORDER BY z.naziv;