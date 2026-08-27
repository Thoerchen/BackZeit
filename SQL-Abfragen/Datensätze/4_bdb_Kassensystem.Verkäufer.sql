-- Hier werden aus der Mitarbeiter Tabelle alle mit dem Arbeitsbereich "Verkauf" rausgesucht und diesen Mitarbeitern wird eine VerkäuferID zugeordnet

USE BDB_BackZeit;
GO

-- Füge nur Mitarbeiter mit Arbeitsbereich "Verkauf" als Verkäufer ein
INSERT INTO bdb_Kassensystem.Verkäufer (VerkäuferID, MitarbeiterID)
SELECT
    ROW_NUMBER() OVER (ORDER BY m.MitarbeiterID) AS VerkäuferID,
    m.MitarbeiterID
FROM bdb_Personal.Mitarbeiter m
WHERE m.Arbeitsbereich = 'Verkauf';
GO