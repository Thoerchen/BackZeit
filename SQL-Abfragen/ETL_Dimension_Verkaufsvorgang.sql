USE BDB_BackZeit;

INSERT INTO DWH_BackZeit.dbo.D_Verkaufsvorgang(Zahlart, FilialID, Zeitpunkt, Umsatz) 
SELECT
    v.Zahlart,
    v.FilialID,
    v.Zeitpunkt,
    SUM(wirdV.Menge * p.Bruttopreis) AS Umsatz
FROM
    BDB_BackZeit.bdb_Kassensystem.Verkauf AS v 
JOIN 
    BDB_BackZeit.bdb_Kassensystem.wirdVerkauft AS wirdV ON v.FilialID = wirdV.FilialID
JOIN
    BDB_BackZeit.bdb_Kassensystem.Produkt AS p ON wirdV.ProduktID = p.ProduktID;
    