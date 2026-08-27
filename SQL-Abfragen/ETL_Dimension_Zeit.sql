--- ETL für Dimension Zeit

USE BDB_BackZeit;

INSERT INTO DWH_BackZeit.dbo.D_Zeit (ZeitID, Stunde, Tageszeit)
SELECT DISTINCT
    DATEPART(HOUR, Zeitpunkt) AS ZeitID,
    DATEPART(HOUR, Zeitpunkt) AS Stunde,

    CASE
        WHEN DATEPART(HOUR, Zeitpunkt) BETWEEN 6 AND 11 THEN 'Morgen'
        WHEN DATEPART(HOUR, Zeitpunkt) BETWEEN 12 AND 17 THEN 'Mittag'
        WHEN DATEPART(HOUR, Zeitpunkt) BETWEEN 18 AND 21 THEN 'Abend'
        ELSE 'Nacht'
    END AS Tageszeit

FROM
    BDB_BackZeit.bdb_Kassensystem.Verkauf;

SELECT * FROM DWH_BackZeit.dbo.D_Zeit;
