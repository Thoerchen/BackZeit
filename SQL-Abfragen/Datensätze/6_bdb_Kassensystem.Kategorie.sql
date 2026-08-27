-- Erzeuge 6 Datensätze für: bdb_Kassensysteme.Kategorie

USE BDB_BackZeit;
GO

INSERT INTO bdb_Kassensystem.Kategorie (KategorieID, KategorieName)
VALUES
(1, 'Brot'),
(2, 'Brötchen'),
(3, 'Kuchen'),
(4, 'Torten'),
(5, 'Snacks'),
(6, 'Getränke');
GO