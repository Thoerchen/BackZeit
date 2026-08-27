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
--Zuerst muss für jedes Produkt das aktuellste Rezept rausgesucht werden
    DECLARE @ProduktID INT;
    DECLARE @NeuesteRezeptVersion SMALLINT;

    SET @ProduktID = (SELECT TOP(1) ProduktID FROM BDB_BackZeit.bdb_Kassensystem.Produkt);  --Erstes Produkt auswählen

    CREATE TABLE #AktuelleRezepte (
    ProduktID INTEGER PRIMARY KEY NOT NULL,
	Zubereitungsdauer Decimal(7,2) NOT NULL,
	Backzeit Decimal(4,2) NOT NULL,
	Stückzahl TINYINT NOT NULL)
    
    SELECT * INTO #WHILEPRODUKTE FROM BDB_BackZeit.bdb_Kassensystem.Produkt;    --Alle Produkte in eine temporäre Tabelle speichern, die dann interativ gelöscht wird um alle Produkte einmal durchzugehen

    WHILE @@ROWCOUNT <> 0 --Solange #WHILEPRODUKTE Zeilen beinhaltet
    BEGIN
        SELECT * FROM #WHILEPRODUKTE WHERE ProduktID = @ProduktID
        SET @NeuesteRezeptVersion = MAX((SELECT RezeptVersion FROM BDB_BackZeit.bdb_Rezepte.Rezept WHERE ProduktID = @ProduktID))
        Insert INTO #AKTUELLEREZEPTE (ProduktID, Zubereitungsdauer, Backzeit, Stückzahl)
            SELECT ProduktID, Zubereitungsdauer, Backzeit, Stückzahl
                FROM BDB_BackZeit.bdb_Rezepte.Rezept
                WHERE ProduktID = @ProduktID AND RezeptVersion = @NeuesteRezeptVersion;
        DELETE FROM #WHILEPRODUKTE WHERE ProduktID = @ProduktID
        SET @ProduktID = (SELECT TOP(1) ProduktID FROM #WHILEPRODUKTE);
    END
        
    INSERT INTO D_Produkt (ProduktID, ProduktName, Bruttopreis, Nettopreis, Lagerkosten, Backkosten, Lohnkosten, Zutatenkosten, KategorieID, KategorieName)
    SELECT  p.ProduktID,
            p.ProduktName,
            p.Bruttopreis,
            p.Nettopreis,
            SUM(z.LagerkostenProg * b.Menge)/r.Stückzahl, --Lagerkosten
            r.Backzeit * 5 /r.Stückzahl,    --Backkosten
            r.Zubereitungsdauer * 1 / r.Stückzahl,  --Lohnkosten
            SUM(z.PreisProKg * b.Menge)/r.Stückzahl,    --Zutatenkosten
            --Gewinnmarge wird als Computed Column berechtnet (bei Create Table)
            p.KategorieID,
            k.KategorieName
    FROM   BDB_BackZeit.bdb_Kassensystem.Produkt AS p
           Inner JOIN
           #AKTUELLEREZEPTE AS r
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
    GROUP BY p.ProduktID
END


GO

EXEC sp_FillDimProdukt;
SELECT *
FROM   D_Produkt;
       