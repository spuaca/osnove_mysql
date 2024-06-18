-- Dohvati sve (zapise i polja) podatke iz tablice filmovi
SELECT * FROM filmovi;
-- Dohvati sve (zapise i polja) podatke iz tablice clanovi
SELECT * FROM clanovi;

-- dohvati polja naslov, godina iz tablice filmovi
SELECT naslov AS Naslov, godina AS "Godina izdavanja" FROM filmovi;

-- dohvati samo prvi zapis iz tablice filmovi
SELECT * FROM filmovi WHERE id=1;

-- dohvati zapis iz tablice filmovi gdje je naslov Inception
SELECT * FROM filmovi WHERE naslov='Inception';

-- dohvati zapis iz tablice filmovi gdje je id 2 ili 3;
SELECT * FROM filmovi WHERE id=2 OR id=3;
SELECT * FROM filmovi WHERE id IN (3,2,4);

-- dohvati zapise iz tablice filmovi gdje je ime Ivan i email sadrzava ivan
SELECT * FROM clanovi WHERE ime='Ivan Horvat' AND telefon='0912345678';

SELECT * FROM filmovi WHERE (id=1 OR id=2) AND naslov='Kum';

-- dohvati zapise iz tablice filmovi gdje je film noviji od godine 1990
SELECT * FROM filmovi WHERE godina >= 1990;

-- dohvati zapise iz tablice filmovi gdje je film id razlicit od 2
SELECT * FROM filmovi WHERE id <> 2;
SELECT * FROM filmovi WHERE id != 2;

-- poredaj filmove po godinama uzlazno
SELECT * FROM filmovi ORDER BY godina;

-- poredaj filmove po godinama silazno
SELECT * FROM filmovi ORDER BY godina DESC;

-- pretrazi tablicu filmovi po naslovu filma
SELECT * FROM filmovi WHERE naslov LIKE '%cept%';
SELECT * FROM filmovi WHERE naslov LIKE '__ception'; /* _ za 1 znak ili vise*/

-- count, avg, sum
SELECT COUNT(*) FROM filmovi;
SELECT COUNT(id) FROM filmovi;
SELECT COUNT(id) AS 'Broj filmova u bazi' FROM filmovi;
SELECT COUNT(id) AS 'Broj filmova u bazi mladjih od 24 godine' FROM filmovi WHERE godina > 1990;

SELECT AVG(cijena) AS 'Prosjek cijene' FROM cjenik;

SELECT FORMAT(AVG(cijena), 2) AS 'Prosjek cijene fromatiran' FROM cjenik;
SELECT FORMAT(AVG(cijena), 2) AS 'Prosjek cijene formatiran' FROM cjenik WHERE cijena > 2;

SELECT SUM(cijena) AS 'Ukupna cijena' FROM cjenik;

SELECT f.naslov, f.godina, z.ime
    FROM filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id;

SELECT f.naslov, f.godina, z.ime AS 'Zanr'
    FROM filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id;

SELECT f.naslov, f.godina, z.ime, c.tip_filma AS 'Tip', c.cijena, c.zakasnina_po_danu AS 'Zakasnina'
    FROM filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id
    JOIN cjenik c ON f.cjenik_id = c.id;