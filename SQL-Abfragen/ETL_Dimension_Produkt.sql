USE DWH_BackZeit;

GO
-- Stored Procedure entfernen, falls sie bereits existiert
IF OBJECT_ID('sp_FillDimProdukt', 'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE sp_FillDimProdukt;
    END

GO
-- Stored Procedure erstellen
CREATE PROCEDURE sp_FillDimProdukt
AS
BEGIN
    SET NOCOUNT ON;

    /*
        Für jedes Produkt wird zunächst die aktuellste
        Rezeptversion ermittelt.
    */;
    WITH AktuelleRezeptVersion
    AS   (SELECT   ProduktID,
                   MAX(RezeptVersion) AS RezeptVersion
          FROM     BDB_BackZeit.bdb_Rezepte.Rezept
          GROUP BY ProduktID),
         AktuelleRezepte
    AS   (SELECT r.ProduktID,
                 r.Zubereitungsdauer,
                 r.Backzeit,
                 r.Stückzahl
          FROM   BDB_BackZeit.bdb_Rezepte.Rezept AS r
                 INNER JOIN
                 AktuelleRezeptVersion AS ar
                 ON r.ProduktID = ar.ProduktID
                    AND r.RezeptVersion = ar.RezeptVersion),
         -- Kostenberechnung pro Produkt (aggregiert über alle Zutaten)
         ProduktKosten
    AS   (SELECT   b.ProduktID,
                   SUM(z.LagerkostenProg * b.Menge) AS GesamtLagerkosten,
                   SUM(z.PreisProKg * b.Menge * 0.0001) AS GesamtZutatenkosten
            FROM     BDB_BackZeit.bdb_Rezepte.beinhaltet AS b
                     INNER JOIN
                     BDB_BackZeit.bdb_Rezepte.Zutat AS z
                     ON b.ZutatID = z.ZutatID
            GROUP BY b.ProduktID)
    INSERT INTO D_Produkt (ProduktID, ProduktName, Bruttopreis, Nettopreis, Lagerkosten, Backkosten, Lohnkosten, Zutatenkosten, KategorieID, KategorieName)
    SELECT   p.ProduktID,
             p.ProduktName,
             p.Bruttopreis,
             p.Nettopreis,
             pc.GesamtLagerkosten / r.Stückzahl,  -- Lagerkosten pro Stück
             r.Backzeit * 5 / r.Stückzahl,        -- Backkosten pro Stück
             r.Zubereitungsdauer * 1 / r.Stückzahl, -- Lohnkosten pro Stück
             pc.GesamtZutatenkosten / r.Stückzahl, -- Zutatenkosten pro Stück
             p.KategorieID,
             k.KategorieName
    FROM     BDB_BackZeit.bdb_Kassensystem.Produkt AS p
             INNER JOIN
             AktuelleRezepte AS r
             ON p.ProduktID = r.ProduktID
             INNER JOIN
             ProduktKosten AS pc
             ON p.ProduktID = pc.ProduktID
             INNER JOIN
             BDB_BackZeit.bdb_Kassensystem.Kategorie AS k
             ON p.KategorieID = k.KategorieID;
END

GO
-- Stored Procedure ausführen
EXECUTE sp_FillDimProdukt;

GO
-- Ergebnis kontrollieren
SELECT *
FROM   D_Produkt
