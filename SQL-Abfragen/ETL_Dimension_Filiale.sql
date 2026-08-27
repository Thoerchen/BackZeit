--- ETL für Dimension Filiale

USE BDB_BackZeit;
GO


-- Stored Procedure entfernen, falls sie bereits existiert
IF OBJECT_ID('sp_FillDimFiliale', 'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE sp_FillDimFiliale;
    END

GO


-- Stored Procedure erstellen
CREATE PROCEDURE sp_FillDimFiliale
AS
BEGIN

INSERT INTO DWH_BackZeit.dbo.D_Filiale (FilialID, FilialName, FilialOrt)
SELECT
    f.FilialID,
    f.Filialname,
    CONCAT(a.AdresseID, '.', a.Ort) AS FilialOrt
FROM
    BDB_BackZeit.bdb_Immobilienverwaltung.Filiale AS f
JOIN
    BDB_BackZeit.bdb_Verwaltung.Adresse AS a ON f.AdresseID = a.AdresseID
WHERE
    NOT EXISTS
        (SELECT 1
        FROM DWH_BackZeit.dbo.D_Filiale AS df
            WHERE df.FilialID = f.FilialID
        );

END

GO

-- Stored Procedure ausführen
EXECUTE sp_FillDimFiliale;

GO

-- Ergebnis kontrollieren
SELECT *
FROM   DWH_BackZeit.dbo.D_Filiale;
