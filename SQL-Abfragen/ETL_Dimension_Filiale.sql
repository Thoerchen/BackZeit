--- ETL für Dimension Filiale

USE BDB_BackZeit;

INSERT INTO DWH_BackZeit.dbo.D_Filiale (FilialID, FilialName, FilialOrt)
SELECT
    f.FilialID,
    f.Filialname,
    CONCAT(a.AdresseID, '.', a.Ort) AS FilialOrt
FROM
    BDB_BackZeit.bdb_Immobilienverwaltung.Filiale AS f
JOIN
    BDB_BackZeit.bdb_Verwaltung.Adresse AS a ON f.AdresseID = a.AdresseID;
