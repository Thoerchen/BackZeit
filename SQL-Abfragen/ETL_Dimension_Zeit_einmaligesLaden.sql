--- ETL für Dimension Zeit
USE DWH_BackZeit;
GO

-- Tabelle nur einmalig erstellen
--IF OBJECT_ID('DWH_BackZeit.dbo.D_Zeit', 'U') IS NULL
--BEGIN
--    CREATE TABLE DWH_BackZeit.dbo.D_Zeit
--    (
--        ZeitID INT PRIMARY KEY,
--        Stunde INT NOT NULL,
--        Tageszeit VARCHAR(10) NOT NULL
--    );
--END
--GO

-- Tabelle nur befüllen, wenn sie noch keine Einträge enthält
IF NOT EXISTS (SELECT 1 FROM DWH_BackZeit.dbo.D_Zeit)
BEGIN
    INSERT INTO DWH_BackZeit.dbo.D_Zeit
        (ZeitID, Stunde, Tageszeit)
    VALUES
        (0,  0,  'Nacht'),
        (1,  1,  'Nacht'),
        (2,  2,  'Nacht'),
        (3,  3,  'Nacht'),
        (4,  4,  'Nacht'),
        (5,  5,  'Nacht'),
        (6,  6,  'Morgen'),
        (7,  7,  'Morgen'),
        (8,  8,  'Morgen'),
        (9,  9,  'Morgen'),
        (10, 10, 'Morgen'),
        (11, 11, 'Morgen'),
        (12, 12, 'Mittag'),
        (13, 13, 'Mittag'),
        (14, 14, 'Mittag'),
        (15, 15, 'Mittag'),
        (16, 16, 'Mittag'),
        (17, 17, 'Mittag'),
        (18, 18, 'Abend'),
        (19, 19, 'Abend'),
        (20, 20, 'Abend'),
        (21, 21, 'Abend'),
        (22, 22, 'Nacht'),
        (23, 23, 'Nacht');
END
GO

TRUNCATE TABLE DWH_BackZeit.dbo.D_Zeit;
GO

SELECT *
FROM DWH_BackZeit.dbo.D_Zeit
