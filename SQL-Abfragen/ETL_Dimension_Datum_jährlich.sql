--- ETL für Dimension Datum

USE DWH_BackZeit;


-- Entfernen der Stored Procedure, falls sie existiert
IF OBJECT_ID('sp_FillDimDatum', 'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE sp_FillDimDatum;
    END
GO
-- Erstellen der Stored Procedure
CREATE PROCEDURE sp_FillDimDatum
  @Jahr varChar(4)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE;
    DECLARE @EndDate DATE;
    DECLARE @WeekDay INT;

    SET @StartDate = CONVERT(DATE, CONCAT(@jahr, '-01-01'));
    SET @WeekDay = DATEDIFF(DAY, '19000101', @StartDate) % 7;
    SET @EndDate = CONVERT(DATE, CONCAT(@jahr, '-12-31'));

    WHILE @StartDate <= @EndDate
    BEGIN
        INSERT INTO DWH_BackZeit.dbo.D_Datum (DatumID, Tag, Quartal, Monat, Jahr, Wochentag, MonatLang, MonatKurz)
        VALUES (
            CONVERT(INT, CONVERT(CHAR(8), @StartDate, 112)), -- 112 ist Format YYYYMMDD
            @StartDate,
            Concat(Year(@StartDate),'-Q', DATEPART(QUARTER, @Startdate)),
            Concat(Year(@StartDate),'-', CASE WHEN MONTH(@startdate) < 10 THEN '0' ELSE '' END, Month(@Startdate)),
            CONVERT(VARCHAR(4), YEAR(@StartDate)),
            CASE @WeekDay
                WHEN 0 THEN 'Montag' -- Wenn die Differenz zwischen dem Zeitpunkt und 01.01.1900, restlos durch 7 teilbar ist, dann ist es ein Montag 
                WHEN 1 THEN 'Dienstag' -- Bei einem Rest von 1, muss es ein Dienstag sein usw.
                WHEN 2 THEN 'Mittwoch'
                WHEN 3 THEN 'Donnerstag'
                WHEN 4 THEN 'Freitag'
                WHEN 5 THEN 'Samstag'
                WHEN 6 THEN 'Sonntag'
            END,
            CASE MONTH(@StartDate)
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
            END,
            CASE MONTH(@StartDate)
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
            END
        );

        -- Zum nächsten Tag inkrementieren
        SET @StartDate = DATEADD(DAY, 1, @StartDate);
        -- Wochentag neu berechnen
        SET @WeekDay = DATEDIFF(DAY, '19000101', @StartDate) % 7;
    END
END;
GO

DELETE DWH_BackZeit.dbo.D_Datum;
EXEC sp_FillDimDatum 2026;
SELECT * FROM DWH_BackZeit.dbo.D_Datum;

---------

