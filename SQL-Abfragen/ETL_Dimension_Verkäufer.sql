--- ETL für Dimension Verkäufer

USE BDB_BackZeit;
GO


-- Stored Procedure entfernen, falls sie bereits existiert
IF OBJECT_ID('sp_FillDimVerkäufer', 'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE sp_FillDimVerkäufer;
    END

GO


-- Stored Procedure erstellen
CREATE PROCEDURE sp_FillDimVerkäufer
AS
BEGIN

INSERT INTO DWH_BackZeit.dbo.D_Verkäufer(VerkäuferID, VerkäuferName)
SELECT
    v.VerkäuferID,
    m.MitarbeiterName
FROM bdb_Kassensystem.Verkäufer AS v
INNER JOIN bdb_Personal.Mitarbeiter AS m
    ON v.MitarbeiterID = m.MitarbeiterID
WHERE
    NOT EXISTS
        (SELECT 1
        FROM DWH_BackZeit.dbo.D_Verkäufer AS dv
            WHERE dv.VerkäuferID = v.VerkäuferID
        );

END

GO

-- Stored Procedure ausführen
EXECUTE sp_FillDimVerkäufer;

GO

-- Ergebnis kontrollieren
SELECT *
FROM   DWH_BackZeit.dbo.D_Verkäufer;


