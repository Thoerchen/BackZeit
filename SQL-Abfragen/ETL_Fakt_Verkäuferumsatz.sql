USE DWH_BackZeit;
GO

-- Entfernen der Stored Procedure, falls sie existiert
IF OBJECT_ID('sp_FillFactVerkaeuferumsatz', 'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE sp_FillFactVerkaeuferumsatz;
    END

GO
-- Erstellen der Stored Procedure
CREATE PROCEDURE sp_FillFactVerkaeuferumsatz
AS
BEGIN
    DECLARE @GesamtumsatzVorher DECIMAL(7,2);
    --SET @GesamtumsatzVorher = 

    INSERT INTO F_Verkäuferumsatz (DatumID, VerkäuferID, Gesamtumsatz, AnzahlVerkäufe)
    SELECT  CONVERT(INT, CONVERT(CHAR(8), v.Zeitpunkt, 112)),
            vm.VerkäuferID,
            --Gesasmtumsatz = Bisher größter Umsatz + Aktueller Umsatz
            ISNULL((SELECT MAX(Gesamtumsatz) FROM F_Verkäuferumsatz AS f WHERE f.VerkäuferID = vm.VerkäuferID), 0)
            + ISNULL((SELECT TOP(1) Umsatz FROM D_Verkaufsvorgang AS vv WHERE vv.Zeitpunkt = v.Zeitpunkt AND vv.FilialID = v.FilialID), 0),
            --Anzahl Verkäufe = bisher größte ANzahl an Verkäufen + 1
            ISNULL((SELECT MAX(AnzahlVerkäufe) FROM F_Verkäuferumsatz AS f WHERE f.VerkäuferID = vm.VerkäuferID),0) + 1
    FROM   BDB_BackZeit.bdb_Kassensystem.Verkäufer AS vm
           Inner JOIN
           BDB_BackZeit.bdb_Kassensystem.Verkauf AS v
           ON vm.VerkäuferID = v.VerkäuferID    
    GROUP BY vm.VerkäuferID
END


GO

EXEC sp_FillDimProdukt;
SELECT *
FROM   D_Produkt;
       