-- Section 5.1
-- Procédure qui calcule la somme des montants se trouvant dans l'historique de commande
-- d'un client en particulier.
-- On ajoute une colonne total_depense à la table clients pour commencer.
CREATE OR REPLACE PROCEDURE p_Calculer_Somme_Colonne(p_id_client INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    somme_total NUMERIC(10, 2); 
BEGIN

    SELECT SUM(montant) INTO somme_total
    FROM historiquecommande
    WHERE p_id_client = id_client;
    
    UPDATE clients
    SET total_depense = somme_total
    WHERE id_client = p_id_client;
    
END;
$$;


-- Calcule la valeur de stock que possède le magasin pour un certain id_produit en
-- multipliant la quantité en stock par son prix.
CREATE OR REPLACE FUNCTION f_Calculer_Total(p_id_produit INTEGER)
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    valeur_stock NUMERIC(10,2);
BEGIN
    SELECT quantite_en_stock * prix INTO valeur_stock
    FROM produits
    WHERE id_produit = p_id_produit;

    RETURN valeur_stock;
END;
$$;


-- Procédure qui assigne un pourcentage de rabais aléatoire entre p_rabais_min et
-- p_rabais_max à p_nombre_clients.
-- On ajoute une colonne rabais dans la table clients pour commencer.
CREATE OR REPLACE PROCEDURE p_Assigner_Attributs(p_nombre_clients INTEGER, p_rabais_min INTEGER, p_rabais_max INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE clients
    SET rabais = floor(random() * (p_rabais_max - p_rabais_min) + p_rabais_min)
    WHERE id_client IN (
        SELECT id_client
        FROM clients
        ORDER BY random()
        LIMIT p_nombre_clients
    );
END;
$$;


-- Section 5.2
-- Déclencheur qui empêche les commandesclient de dépasser un montant de 500$.
CREATE OR REPLACE FUNCTION Verifier_Restrictions()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.montant > 500 THEN
        RAISE EXCEPTION 'Le montant de la commande dépasse la limite (500$).';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Verifier_Restrictions
BEFORE INSERT OR UPDATE ON commandesclient
FOR EACH ROW
EXECUTE FUNCTION Verifier_Restrictions();

CREATE TRIGGER TRG_Verifier_Restrictions
BEFORE INSERT OR UPDATE ON historiquecommande
FOR EACH ROW
EXECUTE FUNCTION Verifier_Restrictions();


-- Section 5.3
-- Déclencheur qui empêche l'augmentation d'un prix de plus de 15%.
-- Si on tente de l'augmenter de plus de 15%, l'augmentation sera
-- plafonner à 15%
CREATE OR REPLACE FUNCTION Verifier_Augmentation()
RETURNS TRIGGER AS $$
BEGIN 
    IF NEW.prix > OLD.prix * 1.15 THEN
	NEW.prix = OLD.prix * 1.15;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Verifier_Augmentation
BEFORE UPDATE ON produits
FOR EACH ROW
EXECUTE FUNCTION Verifier_Augmentation();


-- Déclencheur qui empêche de commander plus de 50 fois le même produit
-- dans la même commande.
CREATE OR REPLACE FUNCTION Verifier_Quantite_Commande()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantite > 50 THEN
	RAISE EXCEPTION 'Une commande ne peut pas contenir plus de 50 fois le même produit.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Verifier_Quantite_Commande
BEFORE INSERT OR UPDATE ON commandes
FOR EACH ROW
EXECUTE FUNCTION Verifier_Quantite_Commande();


-- Section 5.4
-- Test p_Calculer_Somme_Colonne(p_id_client)
-- Calcul de la somme des montants pour le client 1
-- Le client 1 a actuellement deux commandes de 100$ dans son historique 
-- Devrait retourner 200$
CALL p_Calculer_Somme_Colonne(1);

SELECT total_depense 
FROM clients 
WHERE id_client = 1; 


-- Test f_Calculer_Total(p_id_produit)
-- Calcul de la valeur des stocks actuels du produit 5
-- 500 produits en stock au cout de 50$ chaque
-- Devrait retourner 25000$
SELECT f_Calculer_Total(5);


-- Test p_Assigner_Attributs(p_nombre_clients, p_rabais_min, p_rabais_max)
-- Attribution d'un pourcentage de rabais aléatoire entre 5% et 15% à 2 clients
-- choisi aléatoirement.
CALL p_Assigner_Attributs(2, 5, 15);

SELECT id_client, rabais
FROM clients


-- Test TRG_Verifier_Restrictions
-- Insertion ou mise à jour d'une commande client avec un montant valide (devrait fonctionner)
INSERT INTO commandesclient (id_commande_client, type, montant, adresse, id_client) 
VALUES (7, 'En magasin', 400.00, NULL, 1);

UPDATE commandesclient
SET montant = 300.00
WHERE id_commande_client = 7;

-- Insertion ou mise à jour d'une commande client avec un montant invalide (NE devrait PAS fonctionner)
INSERT INTO commandesclient (id_commande_client, type, montant, adresse, id_client) 
VALUES (8, 'En magasin', 600.00, NULL, 1);

UPDATE commandesclient
SET montant = 700.00
WHERE id_commande_client = 7;

-- Insertion ou mise à jour d'une commande dans l'historique de commande avec 
-- un montant valide (devrait fonctionner)
INSERT INTO historiquecommande (id_historique, date_commande, montant, type, id_fournisseur, id_client)
VALUES (7, '2024-01-01', 400.00, 'fournisseur', 1, NULL);

UPDATE historiquecommande
SET montant = 300.00
WHERE id_historique = 7;

-- Insertion ou mise à jour d'une commande dans l'historique de commande avec 
-- un montant invalide (NE devrait PAS fonctionner)
INSERT INTO historiquecommande (id_historique, date_commande, montant, type, id_fournisseur, id_client)
VALUES (8, '2024-02-01', 600.00, 'client', NULL, 1);

UPDATE historiquecommande
SET montant = 700.00
WHERE id_historique = 7;


-- Test TRG_Verifier_Augmentation
-- Mise à jour d'un prix avec une augmentation valide (devrait fonctionner)
-- Le produit 3 a un prix de 30$, 15% d'augmentation = 34,50$
UPDATE produits 
SET prix = 34 
WHERE id_produit = 3;

-- Mise à jour d'un prix avec une augmentation invalide (NE devrait PAS fonctionner)
-- Le produit 4 a un prix de 40$, 15% d'augmentation = 46,00$
-- Son prix devrait plafonner à 46$
UPDATE produits
SET prix = 50
WHERE id_produit = 4


-- Test TRG_Verifier_Quantite_Commande
-- Insertion ou mise à jour d'une commande avec une quantite de produits en 
-- commande valide (devrait fonctionner)
INSERT INTO commandes (id_commande, date_commande, quantite, statut)
VALUES (16, '2024-11-28', 30, 'En cours');

UPDATE commandes
SET quantite = 40
WHERE id_commande = 16;

-- Insertion ou mise à jour d'une commande avec une quantite de produits en 
-- commande invalide (ne devrait pas fonctionner)
INSERT INTO commandes (id_commande, date_commande, quantite, statut)
VALUES (17, '2024-11-28', 55, 'En cours');

UPDATE commandes
SET quantite = 60
WHERE id_commande = 16;



