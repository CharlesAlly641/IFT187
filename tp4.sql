-- Question 1 : TRG_Verifier_Restrictions
-- Déclencheur qui empêche les commandesclient de dépasser un montant de 500$.
CREATE OR REPLACE FUNCTION Verifier_Restrictions()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.montant > 500 THEN
        RAISE EXCEPTION 'Le montant de la commande dépasse la limite (500$)';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Verifier_Restrictions
BEFORE INSERT ON commandesclient
FOR EACH ROW
EXECUTE FUNCTION Verifier_Restrictions();

-- Cas test 1 : Montant inférieur à 500$
INSERT INTO commandesclient (id_commande_client, type, montant, adresse, id_client) 
VALUES (8, 'En magasin', 450, NULL, 1);
-- Résultat attendu : Insertion réussie

-- Cas test 2 : Montant égal à 500$
INSERT INTO commandesclient (id_commande_client, type, montant, adresse, id_client) 
VALUES (9, 'En magasin', 500, NULL, 1);
-- Résultat attendu : Insertion réussie

-- Cas test 3 : Montant supérieur à 500$
INSERT INTO commandesclient (id_commande_client, type, montant, adresse, id_client) 
VALUES (1, 'En magasin', 550, NULL, 1);
-- Résultat attendu : Exception 'Le montant de la commande dépasse la limite (500$)'


-- Question 2.1 : p_Calculer_Somme_Colonne
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

-- Cas test : Calculer la somme des montants pour un client spécifique
CALL p_Calculer_Somme_Colonne(1);
-- Résultat attendu : La colonne total_depense du client avec id_client = 1 est mise à jour avec la somme des montants de l'historique de commande


-- Question 2.2 : p_Calculer_Toutes_Sommes
-- Procédure qui calcule la somme des montants de trouvant dans l'historique de commande
-- de chaque client.
CREATE OR REPLACE PROCEDURE p_Calculer_Toutes_Sommes()
LANGUAGE plpgsql
AS $$
DECLARE
    indice INTEGER = 1;
BEGIN
    FOR indice IN SELECT id_client FROM clients
    LOOP
	CALL p_Calculer_Somme_Colonne(indice);
    END LOOP;
END;
$$;

-- Cas test : Calculer la somme des montants pour tous les clients
CALL p_Calculer_Toutes_Sommes();
-- Résultat attendu : La colonne total_depense de chaque client est mise à jour avec la somme des montants de l'historique de commande


-- Question 3 : f_Calculer_Total
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

-- Cas de test : Calculer la valeur de stock pour un produit spécifique
SELECT f_Calculer_Total(1);
-- Résultat attendu : Retourne la valeur de stock (quantité_en_stock * prix) pour le produit avec id_produit = 1


-- Question 4 : p_Generer_Enregistrements
-- Procédure qui ajoute la colonne nom_produit dans la table retour, qui se retrouvait
-- initalement dans la table produit.
-- On ajoute une colonne nom_produit à la table retour pour commencer.
CREATE OR REPLACE PROCEDURE p_Generer_Enregistrements()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE retour 
    SET nom_produit = p.nom_produit
    FROM produits p
    WHERE retour.id_produit = p.id_produit;
END;
$$;

-- Cas de test : Mettre à jour la table retour avec les noms des produits
CALL p_Generer_Enregistrements();
-- Résultat attendu : La colonne nom_produit de la table retour est mise à jour avec les noms des produits correspondants
    

-- Question 5 : p_Assigner_Attributs
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

-- Cas de test : Assigner un pourcentage de rabais aléatoire à un nombre de clients
CALL p_Assigner_Attributs(2, 5, 15);
-- Résultat attendu : 2 clients sélectionnés aléatoirement reçoivent un rabais entre 5% et 15%


-- Question 6.1 : f_Compte_Elements
-- Fonction qui compte le nombre d'éléments d'une des catégories de la table 
-- historiquecommande.
CREATE OR REPLACE FUNCTION f_Compte_Elements(p_categorie VARCHAR(100))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    nb_elements INTEGER;
BEGIN
    IF p_categorie = 'id_fournisseur' THEN
        SELECT COUNT(id_fournisseur) INTO nb_elements 
        FROM historiquecommande 
        WHERE id_fournisseur IS NOT NULL;
    ELSIF p_categorie = 'id_client' THEN
        SELECT COUNT(id_client) INTO nb_elements 
        FROM historiquecommande 
        WHERE id_client IS NOT NULL;
    ELSIF p_categorie = 'type' THEN
        SELECT COUNT(type) INTO nb_elements 
        FROM historiquecommande 
        WHERE type IS NOT NULL;
    ELSIF p_categorie = 'montant' THEN
        SELECT COUNT(montant) INTO nb_elements 
        FROM historiquecommande 
        WHERE montant IS NOT NULL;
    ELSIF p_categorie = 'date_commande' THEN
        SELECT COUNT(date_commande) INTO nb_elements 
        FROM historiquecommande 
        WHERE date_commande IS NOT NULL;
    ELSIF p_categorie = 'id_historique' THEN
        SELECT COUNT(id_historique) INTO nb_elements 
        FROM historiquecommande 
        WHERE id_historique IS NOT NULL;
    ELSE
        RAISE EXCEPTION 'Colonne invalide';
    END IF;
    RETURN nb_elements;
END;
$$;

-- Cas test : Compter le nombre d'éléments pour une catégorie spécifique
SELECT f_Compte_Elements('id_client');
-- Résultat attendu : Retourne le nombre d'éléments non nuls dans la colonne id_client de la table historiquecommande


-- Question 6.2 
-- Requête SQL qui affiche les catégories de la table historiquecommande en ordre 
-- décroissant.
CREATE TEMP TABLE resultats (
    categorie VARCHAR(100),
    nb_elements INTEGER
);

INSERT INTO resultats (categorie, nb_elements)
SELECT 'id_fournisseur', f_Compte_Elements('id_fournisseur')
UNION ALL
SELECT 'id_client', f_Compte_Elements('id_client')
UNION ALL
SELECT 'type', f_Compte_Elements('type')
UNION ALL
SELECT 'montant', f_Compte_Elements('montant')
UNION ALL
SELECT 'date_commande', f_Compte_Elements('date_commande')
UNION ALL
SELECT 'id_historique', f_Compte_Elements('id_historique');

-- Cas de test : Afficher les catégories de la table historiquecommande en ordre décroissant
SELECT * FROM resultats
ORDER BY nb_elements DESC;
-- Résultat attendu : Retourne les catégories et le nombre d'éléments en ordre décroissant


-- Question 7 : p_Afficher_Attributs 
-- Procédure qui classe en ordre p_classement (ASC ou DESC) le p_attribut de la table
-- produits.
CREATE OR REPLACE PROCEDURE p_afficher_attributs(p_attribut VARCHAR(100), p_classement VARCHAR(4))
LANGUAGE plpgsql
AS
$$
DECLARE
    query text;
    valeur numeric;
    row produits%ROWTYPE;
BEGIN
    IF p_classement = 'ASC' THEN
        query := format('SELECT * FROM produits ORDER BY %I ASC', p_attribut);
    ELSIF p_classement = 'DESC' THEN
        query := format('SELECT * FROM produits ORDER BY %I DESC', p_attribut);
    ELSE
        RAISE NOTICE 'Classement invalide';
        RETURN;
    END IF;

    FOR row IN EXECUTE query
        LOOP
            IF p_attribut = 'id_produit' THEN
                valeur := row.id_produit::numeric;
            ELSIF p_attribut = 'prix' THEN
                valeur := row.prix;
            ELSIF p_attribut = 'quantite_en_stock' THEN
                valeur := row.quantite_en_stock::numeric;
            ELSIF p_attribut = 'quantite_en_commande' THEN
                valeur := row.quantite_en_commande::numeric;
            ELSE
                RAISE NOTICE 'Attribut invalide';
                RETURN;
            END IF;

            RAISE NOTICE 'ID: %, Nom: %, %: %', row.id_produit, row.nom_produit, p_attribut, valeur;
        END LOOP;
END;
$$; 

-- Cas test : Afficher les attributs de la table produits en ordre croissant
CALL p_afficher_attributs('prix', 'ASC');
-- Résultat attendu : Affiche les produits en ordre croissant de prix

-- Cas de test : Afficher les attributs de la table produits en ordre décroissant
CALL p_afficher_attributs('prix', 'DESC');
-- Résultat attendu : Affiche les produits en ordre décroissant de prix


-- Question 8 : f_Verifier_Présence
-- Fonction qui vérifie si un certain id_client passé en paramètre se trouve dans la 
-- table historiquecommande.
CREATE OR REPLACE FUNCTION f_Verifier_Presence(p_identifiant INTEGER)
RETURNS CHAR
LANGUAGE plpgsql
AS $$
DECLARE
    nb_references INTEGER;
BEGIN
    SELECT COUNT(*) INTO nb_references
    FROM historiquecommande
    WHERE id_client = p_identifiant;

    IF nb_references > 0 THEN
	RETURN 'O';
    ELSE
	RETURN 'N';
    END IF;
END;
$$;

-- Cas de test : Vérifier la présence d'un client dans la table historiquecommande
SELECT f_Verifier_Presence(1);
-- Résultat attendu : Retourne 'O' si le client avec id_client = 1 est présent, sinon 'N'


-- Question 9 : f_Elements_Plus_Frequents
-- Fonction qui retourne en ordre décroissant en terme de fréquence les différents
-- types de la table historique commande.
-- ****Avons eu l'accord de la professeure (Nadia Tahiri) d'inverser les questions 9
-- et 10 pour les rendre ainsi plus intuitives****
CREATE OR REPLACE FUNCTION f_Element_Plus_Frequent()
RETURNS TABLE(type VARCHAR, count INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT historiquecommande.type, COUNT(*)::INTEGER
    FROM historiquecommande
    GROUP BY historiquecomande.type
    ORDER BY COUNT(*) DESC;
END;
$$;

-- Cas de test : Retourner les types les plus fréquents de la table historiquecommande
SELECT * FROM f_Element_Plus_Frequent();
-- Résultat attendu : Retourne les types et leur fréquence en ordre décroissant


-- Question 10 
-- Requête SQL qui affiche uniquement l'élément le plus fréquent des différents types
-- de la table historique commande.
-- ****Avons eu l'accord de la professeure (Nadia Tahiri) d'inverser les questions 9
-- et 10 pour les rendre ainsi plus intuitives****
SELECT type, count
FROM f_Element_Plus_Frequent()
LIMIT 1;
-- Résultat attendu : Retourne le type le plus fréquent et son nombre d'occurrences
