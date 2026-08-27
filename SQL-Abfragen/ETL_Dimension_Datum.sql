--- ETL für Dimension Datum

USE BDB_BackZeit;

INSERT INTO DWH_BackZeit.dbo.D_Datum(DatumID, Tag, Quartal, Monat, Jahr, Wochentag, MonatLang, MonatKurz)
SELECT DISTINCT
    CONVERT(INT, CONVERT(CHAR(8), Zeitpunkt, 112)) AS DatumID, -- 112 ist Format YYYYMMDD
    CONVERT(CHAR(10), Zeitpunkt, 23) AS Tag, -- 23 ist Format YYYY-MM-DD
    CONCAT(YEAR(Zeitpunkt), '-Q', DATEPART(QUARTER, Zeitpunkt)) AS Quartal,
    CONVERT(CHAR(7), Zeitpunkt, 23) AS Monat,
    YEAR(Zeitpunkt) AS Jahr,

    --Wochentag bestimmen

    --Variante1: Problem: hängt von den Server Einstellungen ab und kann daher falsche Werte liefern
    --CASE DATEPART(WEEKDAY, Zeitpunkt)
    --    WHEN 1 THEN 'Sonntag'
    --    WHEN 2 THEN 'Montag'
    --    WHEN 3 THEN 'Dienstag'
    --    WHEN 4 THEN 'Mittwoch'
    --    WHEN 5 THEN 'Donnerstag'
    --    WHEN 6 THEN 'Freitag'
    --    WHEN 7 THEN 'Samstag'
    --END AS Wochentag,

    --Variante2: Rechnet über einen bekannten Montag (1.1.1900) aus welcher Wochentag ist, dadurch ist das Ergebnis unabhängig von den Server Einstellungen
    CASE
        WHEN DATEDIFF(DAY, '19000101', Zeitpunkt) % 7 = 0 THEN 'Montag' -- Wenn die Differenz zwischen dem Zeitpunkt und 01.01.1900, restlos durch 7 teilbar ist, dann ist es ein Montag 
        WHEN DATEDIFF(DAY, '19000101', Zeitpunkt) % 7 = 1 THEN 'Dienstag' -- Bei einem Rest von 1, muss es ein Dienstag sein usw.
        WHEN DATEDIFF(DAY, '19000101', Zeitpunkt) % 7 = 2 THEN 'Mittwoch'
        WHEN DATEDIFF(DAY, '19000101', Zeitpunkt) % 7 = 3 THEN 'Donnerstag'
        WHEN DATEDIFF(DAY, '19000101', Zeitpunkt) % 7 = 4 THEN 'Freitag'
        WHEN DATEDIFF(DAY, '19000101', Zeitpunkt) % 7 = 5 THEN 'Samstag'
        WHEN DATEDIFF(DAY, '19000101', Zeitpunkt) % 7 = 6 THEN 'Sonntag'
    END AS Wochentag,
 
    CASE MONTH(Zeitpunkt)
        WHEN 1 THEN 'Januar'
        WHEN 2 THEN 'Februar'
        WHEN 3 THEN 'März'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'Mai'
        WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'Dezember'
    END AS MonatLang,

    CASE MONTH(Zeitpunkt)
        WHEN 1 THEN 'Jan'
        WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mär'
        WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'Mai'
        WHEN 6 THEN 'Jun'
        WHEN 7 THEN 'Jul'
        WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep'
        WHEN 10 THEN 'Okt'
        WHEN 11 THEN 'Nov'
        WHEN 12 THEN 'Dez'
    END AS MonatKurz

FROM
    BDB_BackZeit.bdb_Kassensystem.Verkauf;

SELECT * FROM DWH_BackZeit.dbo.D_Datum;