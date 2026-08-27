-- Erzeuge 47 Datensätze für: bdb_Rezepte.beinhaltet

USE BDB_BackZeit;
GO

INSERT INTO bdb_Rezepte.beinhaltet (ZutatID, RezeptVersion, ProduktID, Menge)
VALUES
-- ProduktID 1: Standard-Brot
(1, 1, 1, 500),   -- Weizenmehl Type 405
(4, 1, 1, 20),    -- Butter
(5, 1, 1, 200),   -- Milch
(6, 1, 1, 10),    -- Hefe
(7, 1, 1, 5),     -- Salz

-- ProduktID 2: Zuckergebäck
(2, 2, 2, 300),   -- Zucker
(1, 2, 2, 400),   -- Weizenmehl Type 405
(3, 2, 2, 4),     -- Eier

-- ProduktID 3: Rosinenbrot
(24, 3, 3, 150),  -- Rosinen
(1, 3, 3, 350),   -- Weizenmehl Type 405
(20, 3, 3, 100),  -- Honig

-- ProduktID 4: Schokokuchen
(8, 4, 4, 2),     -- Vanilleextrakt
(1, 4, 4, 450),   -- Weizenmehl Type 405
(10, 4, 4, 30),   -- Kakao Pulver

-- ProduktID 5: Kardamom-Zimtschnecken
(28, 5, 5, 100),  -- Sahne
(17, 5, 5, 2),    -- Kardamom gemahlen
(1, 5, 5, 400),   -- Weizenmehl Type 405

-- ProduktID 6: Zimtkuchen
(19, 6, 6, 10),   -- Zimt Pulver
(1, 6, 6, 300),   -- Weizenmehl Type 405
(2, 6, 6, 200),   -- Zucker
(3, 6, 6, 5),     -- Eier

-- ProduktID 7: Haselnusskuchen
(15, 7, 7, 200),  -- Haselnüsse
(1, 7, 7, 250),   -- Weizenmehl Type 405
(2, 7, 7, 150),   -- Zucker

-- ProduktID 8: Mandelblättchen-Konfekt
(12, 8, 8, 500),  -- Mandelblättchen
(1, 8, 8, 200),   -- Weizenmehl Type 405
(2, 8, 8, 100),   -- Zucker

-- ProduktID 9: Kokosmakronen
(14, 9, 9, 100),  -- Kokosraspeln
(1, 9, 9, 300),   -- Weizenmehl Type 405
(2, 9, 9, 100),   -- Zucker

-- ProduktID 10: Ahorn-Karamell-Kuchen
(21, 10, 10, 50), -- Ahornsirup
(1, 10, 10, 250), -- Weizenmehl Type 405
(10, 10, 10, 20), -- Kakao Pulver

-- ProduktID 11-20: Kekse/Plätzchen (Beispiele)
(1, 11, 11, 250), -- Weizenmehl Type 405
(2, 11, 11, 200), -- Zucker
(4, 11, 11, 150), -- Butter
(3, 11, 11, 3),   -- Eier

(1, 12, 12, 300), -- Weizenmehl Type 405
(2, 12, 12, 150), -- Zucker
(26, 12, 12, 100),-- Erdnüsse

(1, 13, 13, 200), -- Weizenmehl Type 405
(2, 13, 13, 100), -- Zucker
(11, 13, 13, 5),  -- Zitronenschale getrocknet

(14, 100, 100, 80), -- Kokosraspeln
(1, 100, 100, 260), -- Weizenmehl Type 405
(2, 100, 100, 120), -- Zucker
(29, 100, 100, 50); -- Leinöl
GO