INSERT INTO grad (ime, zip) VALUES ('Zagreb', '10000');
INSERT INTO grad (ime, zip) VALUES ('Split', '21000');
INSERT INTO grad (ime, zip) VALUES ('Pula', '52000');

INSERT INTO poslovnice (ime, adresa, grad_id)
VALUES ('Trgovina Zagreb', 'Ulica Grada Vukovara 55', 1);

INSERT INTO zaposlenici (ime, adresa, poslovnica_id, grad_id)
VALUES ('Ivo Ivic', 'Ulica Grada Vukovara 55', 4, 1);

DELETE FROM poslovnice WHERE ID = 2;
DELETE FROM poslovnice WHERE ime = 'Zagreb';

UPDATE poslovnice SET ime = 'Trgovina Split', adresa = '21000' WHERE id = 6;