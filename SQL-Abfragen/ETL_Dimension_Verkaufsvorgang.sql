USE BDB_BackZeit;

INSERT INTO DWH_BackZeit.dbo.D_Verkaufsvorgang(Zahlart, FilialID, Zeitpunkt, Umsatz) 
SELECT
    v.Zahlart,
    wirdV.FilialID,
    wirdV.Zeitpunkt,
    SUM(wirdV.Menge * p.Bruttopreis) AS Umsatz
FROM
    BDB_BackZeit.bdb_Kassensystem.wirdVerkauft AS wirdV 
JOIN
    BDB_BackZeit.bdb_Kassensystem.Produkt AS p ON wirdV.ProduktID = p.ProduktID
JOIN
    BDB_BackZeit.bdb_Kassensystem.Verkauf AS v ON v.FilialID = wirdV.FilialID AND wirdV.Zeitpunkt = v.Zeitpunkt

GROUP BY wirdV.FilialID, wirdV.Zeitpunkt, v.Zahlart;

SELECT * FROM DWH_BackZeit.dbo.D_Verkaufsvorgang
    