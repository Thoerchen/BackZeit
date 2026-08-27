--- ETL für Dimension Verkäufer

USE BDB_BackZeit;

INSERT INTO DWH_BackZeit.dbo.D_Verkäufer(VerkäuferID, VerkäuferName)
SELECT
    v.VerkäuferID,
    m.MitarbeiterName
FROM bdb_Kassensystem.Verkäufer AS v
INNER JOIN bdb_Personal.Mitarbeiter AS m
    ON v.MitarbeiterID = m.MitarbeiterID;





