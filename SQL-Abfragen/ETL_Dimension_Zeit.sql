--- ETL für Dimension Zeit

USE DWH_BackZeit;
GO

-- Entfernen der Stored Procedure, falls sie existiert
IF OBJECT_ID('sp_FillDimZeit', 'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE sp_FillDimZeit;
    END
GO
-- Erstellen der Stored Procedure
CREATE PROCEDURE sp_FillDimZeit
AS
BEGIN
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
        BDB_BackZeit.bdb_Kassensystem.Verkauf v

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM DWH_BackZeit.dbo.D_Zeit z
        WHERE z.ZeitID = DATEPART(HOUR, v.Zeitpunkt)
    );
END
GO

EXEC sp_FillDimZeit;
SELECT * FROM DWH_BackZeit.dbo.D_Zeit;

