-- Tests d'insertion
INSERT INTO Personne (nom, prenom, email, telephone) VALUES
('Labbe', 'Serge', 'serge.labbe@hotmail.com', '1234567890');

INSERT INTO Clients (id_personne) VALUES
((SELECT id_personne FROM Personne WHERE email = 'serge.labbe@hotmail.com'));

-- Tests de sélection
SELECT * FROM Personne WHERE email = 'serge.labbe@hotmail.com';
SELECT * FROM Clients WHERE id_personne = (SELECT id_personne FROM Personne WHERE email = 'serge.labbe@hotmail.com');

-- Tests de mise à jour
UPDATE Personne SET telephone = '0987654321' WHERE email = 'serge.labbe@hotmail.com';
SELECT * FROM Personne WHERE email = 'serge.labbe@hotmail.com';

-- Tests de suppression
DELETE FROM Clients WHERE id_personne = (SELECT id_personne FROM Personne WHERE email = 'serge.labbe@hotmail.com');
DELETE FROM Personne WHERE email = 'serge.labbe@hotmail.com';

-- Tests de contraintes *LES TESTS SUIVANTS NE DEVRAIENT PAS FONCTIONNER*
-- Insertion d'un id invalide pour chaque table
INSERT INTO Personne (id_personne) VALUES (0);
INSERT INTO Administrateur (id_admin) VALUES (0);
INSERT INTO Clients (id_client) VALUES (0);
INSERT INTO Employe (id_employe) VALUES (0);
INSERT INTO Fournisseur (id_fournisseur) VALUES (0);
INSERT INTO Produits (id_produit) VALUES (0);
INSERT INTO Commandes (id_commande) VALUES (0);
INSERT INTO CommandesClient (id_commande_client) VALUES (0);
INSERT INTO CommandesFournisseur (id_commande_fournisseur) VALUES (0);
INSERT INTO HistoriqueCommande (id_historique) VALUES (0);
INSERT INTO HistoriqueVente (id_historique) VALUES (0); 
INSERT INTO Rapport (id_rapport) VALUES (0);
INSERT INTO Retour (id_retour) VALUES (0);

-- Insertion d'un prix de produit négatif, nul ou valide
INSERT INTO Produits (nom_produit, description, prix, quantite_en_stock, quantite_en_commande) VALUES
('Produit 6', 'Description 6', -50.00, 10, 5);
INSERT INTO Produits (nom_produit, description, prix, quantite_en_stock, quantite_en_commande) VALUES
('Produit 7', 'Description 7', 0.00, 10, 5);

-- Insertion d'une quantite d'un produit en commande négative
INSERT INTO Commandes (date_commande, quantite, statut) VALUES
('2024-12-31', -1, 'En traitement');
INSERT INTO Produits (nom_produit, description, prix, quantite_en_stock, quantite_en_commande) VALUES
('Produit 8', 'Description 8', 10.00, 1, -1);

-- Insertion d'une quantité en stock nulle ou négative d'un produit
INSERT INTO Produits (nom_produit, description, prix, quantite_en_stock, quantite_en_commande) VALUES
('Produit 9', 'Description 9', 10.00, -5, 5);
INSERT INTO Produits (nom_produit, description, prix, quantite_en_stock, quantite_en_commande) VALUES
('Produit 10', 'Description 10', 10.00, 0, 5);

-- Insertion d'une date invalide
INSERT INTO CommandesFournisseur (id_commande_fournisseur, date_livraison, adresse, id_fournisseur) VALUES
(1, '2024-13-01', 'Adresse Invalide', 1);




