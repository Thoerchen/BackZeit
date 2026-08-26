--- Erstelle Business-Datenbank
CREATE DATABASE BDB_BackZeit;
GO

USE BDB_BackZeit;
GO

--- Erstelle Verwaltungsdatenbankschema
CREATE SCHEMA bdb_Verwaltung;
GO

CREATE TABLE bdb_Verwaltung.Adresse(
	AdresseID INT Identity(1,1) NOT NULL PRIMARY Key,
	Straße NVARCHAR(50) NOT NULL,
	PLZ VARCHAR(5) NOT NULL,
	Ort NVARCHAR(20) NOT NULL,
	Hausnummer NVARCHAR(7)  NOT NULL
);
GO

--- Erstelle Personaldatenbankschema
CREATE SCHEMA bdb_Personal;
GO

CREATE TABLE bdb_Personal.Mitarbeiter (
	MitarbeiterID INT Identity(1,1) NOT NULL PRIMARY Key,
	Name NVARCHAR(50) NOT NULL,
	Geschlecht CHAR,
	StundenProWoche Decimal(4,2) NOT NULL,
	Kündigungsdatum DATETIME2,
	GehaltProStunde Decimal(4,2) NOT NULL,
	Einstellungsdatum DATETIME2 NOT NULL,
	Telefonnummer NVARCHAR(12),
	AdresseID INTEGER NOT NULL FOREIGN KEY REFERENCES bdb_Verwaltung.Adresse(AdresseID),
	Arbeitsbereich NVARCHAR(20) NOT NULL
);
GO

--- Erstelle Immobilienverwaltungsschema
CREATE SCHEMA bdb_Immobilienverwaltung;
GO

CREATE TABLE bdb_Immobilienverwaltung.Filiale(
	FilialID INT Identity(1,1) NOT NULL PRIMARY Key,
	Filialname NVARCHAR(50) UNIQUE NOT NULL,
	AdresseID INTEGER NOT NULL FOREIGN KEY REFERENCES bdb_Verwaltung.Adresse(AdresseID),
	Stromkosten Decimal(7,2) NOT NULL,
	Heizkosten Decimal(7,2) NOT NULL,
	Kaltmiete Decimal(7,2) NOT NULL,
	sonstNebenkosten Decimal(7,2) NOT NULL,
	GrößeInQm Decimal(7,2) NOT NULL
);
GO


--- Erstelle Kassensystem
CREATE SCHEMA bdb_Kassensystem;
GO

CREATE TABLE bdb_Kassensystem.Verkäufer(
	VerkäuferID INT NOT NULL PRIMARY KEY,
    MitarbeiterID INT NOT NULL,
	FOREIGN KEY(MitarbeiterID) REFERENCES bdb_Personal.Mitarbeiter(MitarbeiterID)
);

CREATE TABLE bdb_Kassensystem.Verkauf(
	Zeitpunkt DATETIME2 NOT NULL PRIMARY KEY,
    FilialID INT NOT NULL,
    Zahlart CHAR(1),
    VerkäuferID INT NOT NULL,
    FOREIGN KEY (FilialID) REFERENCES bdb_Immobilienverwaltung.Filiale(FilialID),
    FOREIGN KEY (VerkäuferID) REFERENCES bdb_Kassensystem.Verkäufer(VerkäuferID)
);

CREATE TABLE bdb_Kassensystem.Kategorie(
	KategorieID INT NOT NULL PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL
);
CREATE TABLE bdb_Kassensystem.Produkt(
	ProduktID INT NOT NULL PRIMARY KEY,
    Bruttopreis DECIMAL(4,2) NOT NULL,
    Nettopreis DECIMAL(4,2) NOT NULL,
    ProduktName NVARCHAR(50) NOT NULL,
    KategorieID INT NOT NULL,
    FOREIGN KEY (KategorieID) REFERENCES bdb_Kassensystem.Kategorie(KategorieID)
);


CREATE TABLE bdb_Kassensystem.arbeitetIn(
	SchichtID INT NOT NULL,
	FilialID INT NOT NULL,
	VerkäuferID INT NOT NULL,
    Datum DATE NOT NULL,
	Schichtende time NOT NULL, 
	Schichtbeginn time NOT NULL,
    PRIMARY KEY (SchichtID), 
    FOREIGN KEY (FilialID) REFERENCES bdb_Immobilienverwaltung.Filiale(FilialID),
    FOREIGN KEY (VerkäuferID) REFERENCES bdb_Kassensystem.Verkäufer(VerkäuferID)

);

CREATE TABLE bdb_Kassensystem.wirdVerkauft(
	FilialID INT NOT NULL,
    Zeitpunkt DATETIME2 NOT NULL,
    ProduktID INT NOT NULL,
    Menge DECIMAL(5,2),
    PRIMARY KEY (FilialID, Zeitpunkt, ProduktID),
    FOREIGN KEY (FilialID) REFERENCES bdb_Immobilienverwaltung.Filiale(FilialID),
    FOREIGN KEY (ProduktID) REFERENCES bdb_Kassensystem.Produkt(ProduktID),
	FOREIGN KEY (Zeitpunkt) REFERENCES bdb_Kassensystem.Verkauf(Zeitpunkt)
);
GO


--- Erstelle Rezepteschema
CREATE SCHEMA bdb_Rezepte;
GO

CREATE TABLE bdb_Rezepte.Rezept(
	ProduktID INTEGER NOT NULL,
	RezeptVersion SMALLINT NOT NULL Identity(1,1), -- Version umbenannt in RezeptVersion, um Verwechslung mit SQL Systemvariable zu vermeiden
	Zubereitungsdauer Decimal(7,2) NOT NULL,
	gültigBis DateTime2,
	gültigAb DateTime2,
	Backzeit Decimal(4,2) NOT NULL,
	Autor NVARCHAR(50) NOT NULL,
	Stückzahl TINYINT,
	PRIMARY KEY (ProduktID, RezeptVersion),
	FOREIGN KEY (ProduktID) REFERENCES bdb_Kassensystem.Produkt(ProduktID)
);

--
CREATE TABLE bdb_Rezepte.Zutat(
	ZutatID INT Identity(1,1) NOT NULL PRIMARY Key,
	LagerkostenProg Decimal(4,2) NOT NULL,
	Allergen BIT,
	PreisProKg Decimal(7,2) NOT NULL,
	Bezeichnung NVARCHAR(50) NOT NULL
);
--
CREATE TABLE bdb_Rezepte.beinhatet(
	ZutatID INT NOT NULL,
	RezeptVersion SMALLINT NOT NULL,
	ProduktID INT NOT NULL,
	Menge SMALLINT NOT NULL
	PRIMARY KEY (ZutatID, RezeptVersion, ProduktID),
	FOREIGN KEY (ZutatID) REFERENCES bdb_Rezepte.Zutat(ZutatID),
	FOREIGN KEY (ProduktID, RezeptVersion) REFERENCES bdb_Rezepte.Rezept(ProduktID, RezeptVErsion)
);
GO