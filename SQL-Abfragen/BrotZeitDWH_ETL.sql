USE DWH_BackZeit;
GO

-- Entfernen der Stored Procedure, falls sie existiert
IF OBJECT_ID('sp_FillDimProdukt', 'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE dwh1.sp_FillDimArtikel;
    END

DELETE D_Produkt;

GO
-- Erstellen der Stored Procedure
CREATE PROCEDURE sp_FillDimProdukt
AS
BEGIN
    INSERT INTO D_Produkt (ProduktID, ProduktName, Bruttopreis, Nettopreis, Lagerkosten, Backkosten, Lohnkosten, Zutatenkosten, Gewinnmarge, KategorieID, KategorieName)
    SELECT  p.ProduktID,
            p.ProduktName,
            p.Bruttopreis,
            p.Nettopreis,
            --Lagerkosten
            r.Backzeit * 5 /r.Stückzahl,
            r.Zubereitungsdauer * 1 / r.Stückzahl,
            --Zutatenkosten,
            --Gewinnmarge,
            p.KategorieID,
            k.KategorieName
    FROM   BDB_BackZeit.bdb_Kassensystem.Produkt AS p
           Inner JOIN
           BDB_BackZeit.bdb_Rezepte.Rezept AS r
           ON p.ProduktID = r.ProduktID
           INNER JOIN
           BDB_BackZeit.bdb_Rezepte.beinhaltet AS b
           ON b.ProduktID = p.ProduktID
           INNER JOIN
           BDB_Backzeit.bdb_Rezepte.Zutat AS z
           ON b.ZutatID = z.ZutatID
           Inner JOIN
           BDB_BackZeit.bdb_Kassensystem.Kategorie AS k
           ON p.KategorieID = k.KategorieID
           WHERE r.RezeptVersion = MAX((SELECT RezeptVersion FROM BDB_BackZeit.bdb_Rezepte.Rezept WHERE ProduktID = p.ProduktID))

END


GO

EXEC sp_FillDimProdukt;
SELECT *
FROM   D_Produkt;
