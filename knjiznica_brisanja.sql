-- Brisasnja iz baze Knjiznica

-- brisanje pojedinog zapisa (retka) u tablici
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM clanovi WHERE id = 4;
SET FOREIGN_KEY_CHECKS = 1;

-- brisanje atributa (column) iz postojece tablice
ALTER TABLE clanovi DROP datum_rodjenja;

-- brisanje indeksa u tablici
ALTER TABLE knjige DROP FOREIGN KEY knjige_ibfk_1;

-- brisanje atributa (column) iz postojece tablice
ALTER TABLE clanovi drop index email;
ALTER TABLE knjige DROP zanr_id;

-- brisanje cijele tablice
drop table clanovi cascade;

-- brisanje cijele baze
drop database knjiznica;

-- brisanje podataka iz tablice
truncate clanovi;

-- obrisati strani kljuc
ALTER TABLE knjige DROP FOREIGN KEY knjige_ibfk_1;

-- kreiranje stranog kljuca sa uvjetom ON DELETE CASCADE
alter table knjige add FOREIGN KEY (zanr_id) REFERENCES zanrovi(id) ON DELETE CASCADE on update cascade; /* on update se ne koristi nikad (id se ne mijenja) */

-- promjena vrijednosti u postojećim zapisima
UPDATE clanovi SET prezime = 'Dobrinic', ime = 'Aleks' WHERE id = 8;
UPDATE clanovi SET datum_clanstva = CURDATE() WHERE id = 8;