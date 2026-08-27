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
    WITH BisherigeWerte AS
        (SELECT bdbv.VerkäuferID AS VerkäuferID, SUM(vv.Umsatz) AS bisherigeUmsätze, COUNT(vv.VerkaufsvorgangID) AS bisherigeVerkäufe
            FROM D_Verkaufsvorgang AS vv
            Inner JOIN
            BDB_BackZeit.bdb_Kassensystem.Verkauf AS bdbv
            ON vv.Zeitpunkt = bdbv.Zeitpunkt AND vv.FilialID = bdbv.FilialID
        GROUP BY bdbv.VerkäuferID)
    
    INSERT INTO F_Verkäuferumsatz (DatumID, VerkäuferID, VerkaufsvorgangID, Gesamtumsatz, AnzahlVerkäufe)
    SELECT  CONVERT(INT, CONVERT(CHAR(8), vv.Zeitpunkt, 112)),
            v.VerkäuferID,
            vv.VerkaufsvorgangID,
            bw.bisherigeUmsätze,
            bw.bisherigeVerkäufe
    FROM   D_Verkäufer AS v
           Inner JOIN
           BDB_BackZeit.bdb_Kassensystem.Verkauf AS bdbv
           ON bdbv.VerkäuferID = v.VerkäuferID
           INNER JOIN
           D_Verkaufsvorgang AS vv
           ON vv.Zeitpunkt = bdbv.Zeitpunkt AND vv.FilialID = bdbv.FilialID
           INNER JOIN
           BisherigeWerte AS bw
           ON bw.VerkäuferID = v.VerkäuferID
END


GO

EXEC sp_FillFactVerkaeuferumsatz;
SELECT *
FROM   F_Verkäuferumsatz;

--DELETE F_Verkäuferumsatz;
    