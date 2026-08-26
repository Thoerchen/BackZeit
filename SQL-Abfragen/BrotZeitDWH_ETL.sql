-- Entfernen der Stored Procedure, falls sie existiert
IF OBJECT_ID('dwh1.sp_FillDimArtikel', 'P') IS NOT NULL
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
    --SELECT k.KasseID,
    --       f.FilialID,
    --       f.FilialName,
    --       fbz.FilialBezirkID,
    --       fbz.Filialbezirkname,
    --       ob.FilialoberbezirkID,
    --       ob.Filialoberbezirk,
    --       flk.FiliallandkreisID,
    --       flk.Filiallandkreis,
    --       fbl.FilialBundeslandID,
    --       fbl.FilialBundesland,
    --       fs.FilialStaatID,
    --       fs.FilialStaat
    --FROM   NORTHWND.dbo.Kasse AS k
    --       INNER JOIN
    --       NORTHWND.dbo.Filiale AS f
    --       ON k.FilialID = f.FilialID
    --       INNER JOIN
    --       NORTHWND.dbo.Filialbezirk AS fbz
    --       ON f.FilialbezirkID = fbz.FilialbezirkID
    --       INNER JOIN
    --       NORTHWND.dbo.FilialOberbezirk AS ob
    --       ON fbz.FilialoberbezirkID = ob.FilialoberbezirkID
    --       INNER JOIN
    --       NORTHWND.dbo.FilialLandkreis AS flk
    --       ON f.FiliallandkreisID = flk.FiliallandkreisID
    --       INNER JOIN
    --       NORTHWND.dbo.FilialBundesland AS fbl
    --       ON flk.FilialBundeslandID = fbl.FilialBundeslandID
    --       INNER JOIN
    --       NORTHWND.dbo.FilialStaat AS fs
    --       ON fbl.FilialStaatID = fs.FilialStaatID;
END


GO

EXEC dwh1.sp_FillDimArtikel;
SELECT *
FROM   dwh1.DIM_Artikel;