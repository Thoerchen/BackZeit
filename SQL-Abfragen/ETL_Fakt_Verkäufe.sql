USE DWH_BackZeit;
GO

-- Entfernen der Stored Procedure, falls sie existiert
IF OBJECT_ID('dbo.ETL_F_Verkaeufe', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.ETL_F_Verkaeufe;
END
GO

-- Erstellen der Stored Procedure
CREATE PROCEDURE dbo.ETL_F_Verkaeufe
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DWH_BackZeit.dbo.F_Verkäufe (DatumID, ZeitID, ProduktID, FilialID, VerkäuferID, AnzahlProdukte, Umsatz, Gewinn)
    SELECT
        CONVERT(INT, CONVERT(CHAR(8), CAST(v.Zeitpunkt AS DATE), 112)) AS DatumID,
        z.ZeitID,
        w.ProduktID,
        v.FilialID,
        v.VerkäuferID,

        -- AnzahlProdukte
        CAST(w.Menge AS SMALLINT) AS AnzahlProdukte,

        --Umsatz
        CAST( w.Menge * p.Nettopreis AS DECIMAL(7,2)) AS Umsatz,

        -- Gewinn
        CAST(w.Menge * dp.Gewinnbetrag AS DECIMAL(7,2)) AS Gewinn

        

    FROM BDB_BackZeit.bdb_Kassensystem.Verkauf v

    INNER JOIN BDB_BackZeit.bdb_Kassensystem.wirdVerkauft w
        ON v.Zeitpunkt = w.Zeitpunkt
        AND v.FilialID = w.FilialID

    INNER JOIN BDB_BackZeit.bdb_Kassensystem.Produkt p
        ON w.ProduktID = p.ProduktID

    INNER JOIN DWH_BackZeit.dbo.D_Produkt dp
        ON w.ProduktID = dp.ProduktID

    INNER JOIN DWH_BackZeit.dbo.D_Zeit z
        ON z.Stunde =
           RIGHT('0' + CAST(DATEPART(HOUR, v.Zeitpunkt) AS VARCHAR(2)), 2)

    -- Verhindert, dass bereits geladene Verkäufe erneut eingefügt werden
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM DWH_BackZeit.dbo.F_Verkäufe f
        WHERE f.DatumID =
              CONVERT(INT, CONVERT(CHAR(8), CAST(v.Zeitpunkt AS DATE), 112))
          AND f.ZeitID = z.ZeitID
          AND f.ProduktID = w.ProduktID
          AND f.FilialID = v.FilialID
          AND f.VerkäuferID = v.VerkäuferID
    );
END;
GO

EXEC dbo.ETL_F_Verkaeufe;
GO

SELECT * FROM DWH_BackZeit.dbo.F_Verkäufe