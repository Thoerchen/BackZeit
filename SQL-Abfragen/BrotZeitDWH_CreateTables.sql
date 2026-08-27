CREATE DATABASE DWH_BackZeit;
GO

USE DWH_BackZeit;
GO

--DROP TABLE F_Verkäufe;
--DROP TABLE F_Verkäuferumsatz;
--DROP TABLE D_Zeit;
--DROP TABLE D_Datum;
--DROP TABLE D_Produkt;
--DROP TABLE D_Verkäufer;
--DROP TABLE D_Filiale;
--DROP TABLE D_Verkaufsvorgang;

CREATE TABLE D_Datum (
    DatumID   INT   Primary Key Identity(1,1),
    Tag     VARCHAR (10)   NOT NULL,
    Woche   VARCHAR (7)   NOT NULL,
    Monat   VARCHAR (7)   NOT NULL,
    Jahr      VARCHAR (4)   NOT NULL,
    Wochentag NVARCHAR (15) NOT NULL,
    MonatLang NVARCHAR (15) NOT NULL,
    MonatKurz CHAR (3)   NOT NULL   
);

CREATE TABLE D_Zeit (
    ZeitID      INT     PRIMARY KEY IDENTITY(1,1),
    Stunde      NVARCHAR(2) NOT NULL,
    Tageszeit   NVARCHAR (20) NOT NULL
);

CREATE TABLE D_Produkt (
    ProduktID       INT            PRIMARY KEY,
    ProduktName     NVARCHAR (100) NOT NULL,
    Bruttopreis   DECIMAL(4,2) NOT NULL           ,
    Nettopreis Decimal(4,2)   NOT NULL         ,
    Lagerkosten   DECIMAL(4,2) NOT NULL           ,
    Backkosten   DECIMAL(4,2) NOT NULL           ,
    Lohnkosten   DECIMAL(4,2) NOT NULL           ,
    Zutatenkosten   DECIMAL(4,2) NOT NULL           ,
    Gewinnbetrag AS (Nettopreis - Lagerkosten - Backkosten - Lohnkosten - Zutatenkosten), -- Datentyp ist automatisch Dezimal(4,2) da die Spalten aus denen berechnet wird diesen Typen haben
    KategorieID   INT NOT NULL,
    KategorieName   NVARCHAR (100) NOT NULL
);

CREATE TABLE D_Verkäufer (
    VerkäuferID            INT           PRIMARY KEY,
    VerkäuferName   nvarchar(50)    NOT NULL
);

CREATE TABLE D_Filiale (
    FilialID            INT           PRIMARY KEY,
    FilialName   nvarchar(50)    NOT NULL,
    FilialOrt nvarchar(50) NOT NULL,
    FilialName_Hist nvarchar(50) --veraltete Filialnamen können hier abgespeichert werden
);

CREATE TABLE D_Verkaufsvorgang (
    VerkaufsvorgangID            INT           PRIMARY KEY IDENTITY(1,1),
    Zeitpunkt   DATETIME2 NOT NULL,
    FilialID    INT NOT NULL,
    Umsatz      DECIMAL(7,2) NOT NULL,
    Zahlart CHAR(1), --'B' für Barzahlung und 'K' für Kartenzahlung
    CONSTRAINT UQ_Verkaufsvorgang UNIQUE (Zeitpunkt, FilialID)
);

CREATE TABLE F_Verkäufe (
    DatumID         INT   NOT NULL ,
    ZeitID  INT NOT NULL,
    ProduktID     INT          NOT NULL  ,
    FilialID       INT          NOT NULL  ,
    VerkäuferID       INT          NOT NULL  ,
    Umsatz         Decimal(7,2)     NOT NULL  ,
    Gewinn DECIMAL (7, 2) NOT NULL,
    AnzahlProdukte SMALLINT NOT NULL,
    PRIMARY KEY (DatumID, ZeitID, ProduktID, FilialID, VerkäuferID),
    FOREIGN KEY (DatumID) REFERENCES D_Datum (DatumID) ON DELETE CASCADE,
    FOREIGN KEY (ZeitID) REFERENCES D_Zeit (ZeitID) ON DELETE CASCADE,
    FOREIGN KEY (ProduktID) REFERENCES D_Produkt (ProduktID) ON DELETE CASCADE,
    FOREIGN KEY (FilialID) REFERENCES D_Filiale (FilialID) ON DELETE CASCADE,
    FOREIGN KEY (VerkäuferID) REFERENCES D_Verkäufer (VerkäuferID) ON DELETE CASCADE
);

CREATE TABLE F_Verkäuferumsatz (
    DatumID         INT   NOT NULL ,
    VerkaufsvorgangID     INT          NOT NULL  ,
    VerkäuferID       INT          NOT NULL  ,
    Gesamtumsatz         Decimal(7, 2)     NOT NULL  ,
    DurchschnittlicherUmsatz DECIMAL (7, 2) NOT NULL,
    AnzahlVerkäufe SMALLINT NOT NULL,
    PRIMARY KEY (DatumID, VerkaufsvorgangID, VerkäuferID),
    FOREIGN KEY (DatumID) REFERENCES D_Datum (DatumID) ON DELETE CASCADE,
    FOREIGN KEY (VerkaufsvorgangID) REFERENCES D_Verkaufsvorgang (VerkaufsvorgangID) ON DELETE CASCADE,
    FOREIGN KEY (VerkäuferID) REFERENCES D_Verkäufer (VerkäuferID) ON DELETE CASCADE
);

    
    