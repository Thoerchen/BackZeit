--- ETL für Dimension Verkaufsvorgang

USE BDB_BackZeit;
GO


-- Stored Procedure entfernen, falls sie bereits existiert
IF OBJECT_ID('sp_FillDimVerkaufsvorgang', 'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE sp_FillDimVerkaufsvorgang;
    END

GO


-- Stored Procedure erstellen
CREATE PROCEDURE sp_FillDimVerkaufsvorgang
AS
BEGIN

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

END

GO

-- Stored Procedure ausführen
EXECUTE sp_FillDimVerkaufsvorgang;

GO

-- Ergebnis kontrollieren
SELECT *
FROM   DWH_BackZeit.dbo.D_Verkaufsvorgang;

