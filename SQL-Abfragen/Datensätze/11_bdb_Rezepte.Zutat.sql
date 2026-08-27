-- Erzeuge 50 Datensätze für: bdb_Rezepte.Zutat

USE BDB_BackZeit;
GO

INSERT INTO bdb_Rezepte.Zutat (
    LagerkostenProg,
    Allergen,
    PreisProKg,
    Bezeichnung
)
VALUES
-- Grundzutaten
(0.0012, 1, 0.85, 'Weizenmehl Type 405'),
(0.00095, 0, 1.10, 'Zucker weiß'),
(0.0025, 1, 3.20, 'Hühnereier'),
(0.0018, 1, 4.50, 'Butter'),
(0.0015, 1, 1.20, 'Vollmilch'),
(0.00075, 0, 5.80, 'Hefe frisch'),
(0.0003, 0, 0.45, 'Salz'),
(0.0032, 0, 120.00, 'Vanilleextrakt'),
(0.0011, 0, 2.30, 'Backpulver'),
(0.0028, 0, 8.50, 'Kakao Pulver'),

-- Backzutaten
(0.0014, 0, 3.75, 'Zitronenschale getrocknet'),
(0.00085, 0, 5.20, 'Mandelblättchen'),
(0.0016, 1, 7.80, 'Haselnüsse'),
(0.0009, 0, 4.10, 'Kokosraspeln'),
(0.0013, 1, 9.50, 'Erdnüsse'),
(0.00105, 0, 6.20, 'Rosinen'),
(0.0007, 0, 15.80, 'Kardamom gemahlen'),
(0.00125, 0, 18.50, 'Safranfäden'),
(0.0008, 0, 3.90, 'Zimt Pulver'),
(0.00115, 0, 4.75, 'Kakaobutter'),

-- Fette und Öle
(0.0017, 0, 6.20, 'Rapsöl'),
(0.00155, 0, 5.80, 'Sonnenblumenöl'),
(0.0019, 0, 7.30, 'Olivenöl nativ'),
(0.00135, 0, 8.90, 'Kokosöl'),
(0.00165, 0, 10.20, 'Leinöl'),

-- Milchprodukte
(0.0021, 1, 2.80, 'Sahne'),
(0.00185, 1, 3.40, 'Joghurt Natur'),
(0.002, 1, 4.10, 'Quark Magerstufe'),
(0.00195, 1, 3.70, 'Ricotta'),
(0.00225, 1, 5.20, 'Frischkäse Doppelrahmstufe'),

-- Süßungsmittel
(0.00065, 0, 2.30, 'Honig'),
(0.00075, 0, 1.90, 'Ahornsirup'),
(0.0008, 0, 3.10, 'Agavendicksaft'),
(0.0009, 0, 4.50, 'Palmzucker'),
(0.0007, 0, 2.80, 'Rohrohrzucker'),

-- Gewürze
(0.00145, 0, 12.50, 'Pfeffer schwarz gemahlen'),
(0.0013, 0, 9.80, 'Paprikapulver süß'),
(0.0015, 0, 11.20, 'Kreuzkümmel gemahlen'),
(0.0012, 0, 8.75, 'Koriander gemahlen'),
(0.0014, 0, 10.50, 'Ingwerpulver'),

-- Nüsse und Samen
(0.0023, 1, 14.80, 'Walnüsse'),
(0.00215, 1, 12.30, 'Cashewkerne'),
(0.0024, 1, 16.50, 'Pistazien'),
(0.0022, 1, 13.75, 'Paranüsse'),
(0.00205, 1, 11.90, 'Macadamianüsse');
GO