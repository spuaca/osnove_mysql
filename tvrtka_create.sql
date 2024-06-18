DROP DATABASE IF EXISTS tvrtka;

CREATE DATABASE IF NOT EXISTS tvrtka DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE tvrtka;
-- OVO JE KOMENTAR
/* OVO JE KOMENTAR */

CREATE TABLE IF NOT EXISTS poslovnice (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ime VARCHAR(20) NOT NULL,
    adresa VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- First, add the new columns
ALTER TABLE poslovnice ADD COLUMN voditelj_id INT UNSIGNED NOT NULL AFTER adresa;
ALTER TABLE poslovnice ADD COLUMN grad_id INT UNSIGNED NOT NULL;

-- Create the necessary tables before adding foreign key constraints
CREATE TABLE IF NOT EXISTS grad (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ime VARCHAR(20) NOT NULL,
    zip VARCHAR(5) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS zaposlenici (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ime VARCHAR(20) NOT NULL,
    adresa VARCHAR(255) NOT NULL,
    poslovnica_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (poslovnica_id) REFERENCES poslovnice(id),
    grad_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (grad_id) REFERENCES grad(id)
) ENGINE=InnoDB;

-- Now that the necessary tables exist, add the foreign key constraints
ALTER TABLE poslovnice ADD FOREIGN KEY (voditelj_id) REFERENCES zaposlenici(id);
ALTER TABLE poslovnice ADD FOREIGN KEY (grad_id) REFERENCES grad(id);