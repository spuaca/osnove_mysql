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

-- Spoji tablice filmovi i zanrovi kako bi u rezultatu dobio skupljene podatke iz obje tablice
SELECT f.naslov, f.godina, z.ime AS 'Zanr'
    FROM filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id;

-- Spoji tablice filmovi, zanrovi i cjenik kako bi u rezultatu dobio skupljene podatke iz sve tri tablice
SELECT f.naslov, f.godina, z.ime, c.tip_filma AS 'Tip', c.cijena, c.zakasnina_po_danu AS 'Zakasnina'
    FROM filmovi f
    JOIN zanrovi z ON f.zanr_id = z.id
    JOIN cjenik c ON f.cjenik_id = c.id;

-- spoji tablice posudba sa filmovi, clanovi i mediji preko vezne tablice zaliha
SELECT p.datum_posudbe, p.datum_povrata, c.ime, f.naslov, m.tip
    FROM posudba p
    JOIN clanovi c ON p.clan_id = c.id
    JOIN zaliha z ON p.zaliha_id = z.id
    JOIN filmovi f ON z.film_id = f.id
    JOIN mediji m ON z.medij_id = m.id;

-- izlistaj i film naziv i medij za filmove koji nisu vraceni
SELECT p.datum_posudbe, p.datum_povrata, c.ime, f.naslov, m.tip
    FROM posudba p
    JOIN clanovi c ON p.clan_id = c.id
    JOIN zaliha z ON p.zaliha_id = z.id
    JOIN filmovi f ON z.film_id = f.id
    JOIN mediji m ON z.medij_id = m.id
    WHERE p.datum_povrata IS NULL;

-- povezi sve tablice i izlistaj podatke
SELECT p.datum_posudbe,
       p.datum_povrata,
       c.ime AS "Ime Clana",
       f.naslov,
       m.tip AS Medij,
       zanrovi.ime AS Zanr,
       cj.tip_filma,
       cj.cijena,
       cj.zakasnina_po_danu
FROM posudba p
    JOIN clanovi c ON p.clan_id = c.id
    JOIN zaliha z ON p.zaliha_id = z.id
    JOIN filmovi f ON z.film_id = f.id
    JOIN mediji m ON z.medij_id = m.id
    JOIN zanrovi ON zanrovi.id = f.zanr_id
    JOIN cjenik cj ON cj.id = f.cjenik_id
    WHERE p.datum_povrata IS NOT NULL;

-- ispisi clanove koji su posudili vise od jednog filma
SELECT c.ime
FROM clanovi c
JOIN posudba p ON p.clan_id = c.id
GROUP BY c.ime
HAVING COUNT(c.id) > 1;

-- GROUP BY ispisite totalnu kolicinu kopija dostupnih po filmu
SELECT f.*, SUM(z.kolicina) AS "Ukupna kolicina"
FROM filmovi f
JOIN zaliha z ON z.film_id = f.id
GROUP BY f.id;

SELECT COUNT(DISTINCT clan_id) FROM posudba;

SELECT * FROM posudba p
JOIN clanovi c
WHERE c.id = p.clan_id
WHERE COUNT(c.id) BETWEEN 1 AND 60;

-- dohvati sve iz filmova
SELECT * FROM filmovi LIMIT 3 OFFSET 2;

-- dohvati prosjecnu cijenu filmov s obizorm na ukupnu zalihu filmova