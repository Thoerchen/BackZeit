USE DWH_BackZeit;
GO

-- Stored Procedure entfernen, falls sie bereits existiert
IF OBJECT_ID('dwh1.sp_FillDimProdukt', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dwh1.sp_FillDimProdukt;
END
GO

-- Dimension leeren
DELETE FROM D_Produkt;
GO

-- Stored Procedure erstellen
CREATE PROCEDURE dwh1.sp_FillDimProdukt
AS
BEGIN
    SET NOCOUNT ON;

    /*
        Für jedes Produkt wird zunächst die aktuellste
        Rezeptversion ermittelt.
    */

    ;WITH AktuelleRezeptVersion AS
    (
        SELECT
            ProduktID,
            MAX(RezeptVersion) AS RezeptVersion
        FROM BDB_BackZeit.bdb_Rezepte.Rezept
        GROUP BY ProduktID
    ),
    AktuelleRezepte AS
    (
        SELECT
            r.ProduktID,
            r.Zubereitungsdauer,
            r.Backzeit,
            r.Stückzahl
        FROM BDB_BackZeit.bdb_Rezepte.Rezept AS r
        INNER JOIN AktuelleRezeptVersion AS ar
            ON r.ProduktID = ar.ProduktID
            AND r.RezeptVersion = ar.RezeptVersion
    )
    INSERT INTO D_Produkt
    (
        ProduktID,
        ProduktName,
        Bruttopreis,
        Nettopreis,
        Lagerkosten,
        Backkosten,
        Lohnkosten,
        Zutatenkosten,
        KategorieID,
        KategorieName
    )
    SELECT
        p.ProduktID,
        p.ProduktName,
        p.Bruttopreis,
        p.Nettopreis,

        -- Lagerkosten
        SUM(z.LagerkostenProg * b.Menge) / NULLIF(r.Stückzahl, 0),

        -- Backkosten
        r.Backzeit * 5.0 / NULLIF(r.Stückzahl, 0),

        -- Lohnkosten
        r.Zubereitungsdauer * 1.0 / NULLIF(r.Stückzahl, 0),

        -- Zutatenkosten
        SUM(z.PreisProKg * b.Menge) / NULLIF(r.Stückzahl, 0),

        p.KategorieID,
        k.KategorieName

    FROM BDB_BackZeit.bdb_Kassensystem.Produkt AS p

    INNER JOIN AktuelleRezepte AS r
        ON p.ProduktID = r.ProduktID

    INNER JOIN BDB_BackZeit.bdb_Rezepte.beinhaltet AS b
        ON b.ProduktID = p.ProduktID

    INNER JOIN BDB_BackZeit.bdb_Rezepte.Zutat AS z
        ON b.ZutatID = z.ZutatID

    INNER JOIN BDB_BackZeit.bdb_Kassensystem.Kategorie AS k
        ON p.KategorieID = k.KategorieID

    GROUP BY
        p.ProduktID,
        p.ProduktName,
        p.Bruttopreis,
        p.Nettopreis,
        r.Zubereitungsdauer,
        r.Backzeit,
        r.Stückzahl,
        p.KategorieID,
        k.KategorieName;
END
GO

-- Stored Procedure ausführen
EXEC dwh1.sp_FillDimProdukt;
GO

-- Ergebnis kontrollieren
SELECT *
FROM D_Produkt;
GO
