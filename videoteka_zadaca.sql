-- ### Dopuna zadace

-- - kreirajte novo korisnika u MySQL-u i dajte mu povlastice samo za bazu videoteka
CREATE USER 'novi'@'localhost' IDENTIFIED BY 'novi';
GRANT ALL PRIVILEGES ON *.* TO 'novi'@'localhost';

-- - Svaki film ima zalihu dostupnih kopija po mediju za koji je dostupan
CREATE TABLE IF NOT EXISTS kopija (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    film_id INT UNSIGNED NOT NULL,
    barkod VARCHAR(50) NOT NULL,
    dostupan BOOLEAN DEFAULT TRUE,
    medij_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (medij_id) REFERENCES mediji(id),
    UNIQUE (film_id, barkod),
    FOREIGN KEY (film_id) REFERENCES filmovi(id)
);

INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (1, '1234567890123', TRUE, 1);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (1, '1234567890124', TRUE, 2);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (2, '1234567890125', TRUE, 3);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (2, '1234567890126', TRUE, 1);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (3, '1234567890127', TRUE, 2);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (4, '1234567890128', TRUE, 3);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (5, '1234567890129', TRUE, 1);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (5, '1234567890130', TRUE, 1);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (5, '1234567890131', TRUE, 1);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (5, '1234567890133', TRUE, 1);
INSERT INTO kopija (film_id, barkod, dostupan, medij_id) VALUES (5, '1234567890135', TRUE, 1);

-- - Svaka fizicka kopija filma ima svoj jedinstveni identifikacijski broj (s/n) kako bi se mogla pratiti
SELECT k.id AS kopija_id, k.barkod, f.naslov, k.dostupan, m.tip FROM kopija k
JOIN filmovi f ON f.id = k.film_id
JOIN mediji m ON m.id = k.medij_id
ORDER BY k.id;


-- Izbroji kolicinu filma iz kopije i update zaliha
DROP TRIGGER IF EXISTS update_zaliha_kolicina;
DELIMITER //

CREATE TRIGGER update_zaliha_kolicina AFTER INSERT ON kopija
FOR EACH ROW
BEGIN
    DECLARE count_dostupan INT;

    SELECT COUNT(*)
    INTO count_dostupan
    FROM kopija
    WHERE film_id = NEW.film_id AND medij_id = NEW.medij_id
      AND dostupan = TRUE;

    UPDATE zaliha
    SET kolicina = count_dostupan
    WHERE film_id = NEW.film_id AND medij_id = NEW.medij_id;
END //

DELIMITER ;

-- - Clan od jednom moze posuditi vise od jednog filma
ALTER TABLE posudba
ADD COLUMN kopija_id INT UNSIGNED AFTER zaliha_id,
ADD FOREIGN KEY (kopija_id) REFERENCES zaliha(id);

INSERT INTO posudba (datum_posudbe, datum_povrata, clan_id, zaliha_id, kopija_id) VALUES ('2024-06-09', '2024-06-13', 1, 1, 1);
INSERT INTO posudba (datum_posudbe, datum_povrata, clan_id, zaliha_id, kopija_id) VALUES ('2024-06-09', '2024-06-13', 1, 1, 2);