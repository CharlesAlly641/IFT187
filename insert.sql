-- Insertion de données dans la table Personne
INSERT INTO Personne (nom, prenom, email, telephone) VALUES
('Tremblay', 'Jean', 'jean.tremblay@hotmail.com', '4503456789'),
('Beaulieu', 'Sophie', 'sophie.beaulieu@gmail.com', '5147657320'),
('Bouchard', 'Pierre', 'pierre.bouchard@outlook.com', '4381273445'),
('Lefevre', 'Thomas', 'thomas.lefevre@hotmail.com', '4503344776'),
('Bouvier', 'Luc', 'luc.larose@gmail.com', '4384455997'),
('Falardeau', 'Xavier', 'xavier.falardeau@hotmail.com', '4503459876'),
('Ally', 'Pierre', 'pierre.ally@gmail.com', '5147657321'),
('Ménard', 'Alexis', 'alexis.menard@outlook.com', '4381433445'),
('Cassidy', 'Zachary', 'zachary.cassidy@hotmail.com', '4503346576'),
('Roy', 'Roger', 'roger.roy@gmail.com', '4384451097'),
('Dumas', 'Michel', 'michel.dumas@hotmail.com', '4501236789'),
('Brassard', 'Sophie', 'sophie.brassard@gmail.com', '5147689620'),
('Baillargeon', 'Victor', 'victor.baillargeon@outlook.com', '4386473445'),
('Leroux', 'Antoine', 'antoine.leroux@hotmail.com', '4503397676'),
('Ouellet', 'Sandrine', 'sandrine.ouellet@gmail.com', '4384466697');

-- Insertion de données dans la table Administrateur
INSERT INTO Administrateur (id_personne) VALUES
(1), (2), (3), (4), (5);

-- Insertion de donées dans la table Clients
INSERT INTO Clients (id_personne) VALUES
(6), (7), (8), (9), (10);

-- Insertion de données dans la table Employe
INSERT INTO Employe (id_personne) VALUES
(11), (12), (13), (14), (15);

-- Insertion de données dans la table Fournisseur
INSERT INTO Fournisseur (nom, adresse, email, telephone) VALUES
('Fournisseur A', '123 Rue A', 'fournisseurA@hotmail.com', '4503000789'),
('Fournisseur B', '456 Rue B', 'fournisseurB@hotmail.com', '5149904321'),
('Fournisseur C', '789 Rue C', 'fournisseurC@gmail.com', '4382237485'),
('Fournisseur D', '123 Rue D', 'fournisseurD@outlook.com', '4383313256'),
('Fournisseur E', '456 Rue E', 'fournisseurE@outlook.com', '5144455567');

-- Insertion de données dans la table Produits
INSERT INTO Produits (nom_produit, description, prix, quantite_en_stock, quantite_en_commande) VALUES
('Produit 1', 'Description 1', 10.00, 100, 0),
('Produit 2', 'Description 2', 20.00, 200, 50),
('Produit 3', 'Description 3', 30.00, 300, 100),
('Produit 4', 'Description 4', 40.00, 400, 150),
('Produit 5', 'Description 5', 50.00, 500, 200);

-- Insertion de données dans la table Commandes
INSERT INTO Commandes (date_commande, quantite, statut) VALUES
('2024-02-13', 1, 'En traitement'),
('2024-07-14', 2, 'Livrée'),
('2024-09-01', 3, 'Annulée'),
('2024-10-31', 4, 'En traitement'),
('2024-11-23', 5, 'Commande reçue'),
('2024-02-15', 6, 'En traitement'),
('2024-09-14', 7, 'Livrée'),
('2024-01-01', 8, 'Annulée'),
('2024-01-31', 9, 'En traitement'),
('2024-09-26', 10, 'Commande reçue'),
('2024-02-21', 11, 'En traitement'),
('2024-11-22', 12, 'Livrée'),
('2024-09-24', 13, 'Annulée'),
('2024-10-31', 14, 'En traitement'),
('2024-10-25', 15, 'Commande reçue');

-- Insertion de données dans la table CommandesClient
INSERT INTO CommandesClient (id_commande_client, type, montant, adresse, id_client) VALUES
(1, 'Livraison', 10.00, 'Adresse 1', 1),
(2, 'En magasin', 20.00, NULL, 2),
(3, 'Livraison', 30.00, 'Adresse 3', 3),
(4, 'Livraison', 40.00, 'Adresse 4', 4),
(5, 'En magasin', 100.00, NULL, 5);

-- Insertion de données dans la table CommandesFournisseur
INSERT INTO CommandesFournisseur (id_commande_fournisseur, date_livraison, adresse, id_fournisseur) VALUES
(1, '2024-01-01', 'Adresse A', 1),
(2, '2024-02-14', 'Adresse B', 2),
(3, '2024-08-01', 'Adresse C', 3),
(4, '2024-09-11', 'Adresse D', 4),
(5, '2024-11-13', 'Adresse E', 5);

-- Insertion de données dans la table HistoriqueCommande
INSERT INTO HistoriqueCommande (date_commande, montant, type, id_fournisseur, id_client) VALUES
('2024-01-01', 100.00, 'client', NULL, 1),
('2024-12-01', 200.00, 'client', NULL, 2),
('2024-03-30', 300.00, 'fournisseur', 3, NULL),
('2024-04-04', 400.00, 'fournisseur', 4, NULL),
('2024-11-11', 500.00, 'client', NULL, 5);

-- Insertion de données dans la table HistoriqueVente
INSERT INTO HistoriqueVente (date_vente, quantite, id_produit) VALUES
('2024-01-01', 10, 1),
('2024-12-01', 20, 2),
('2024-03-26', 30, 3),
('2024-04-12', 40, 4),
('2024-07-01', 50, 5);

-- Insertion de données dans la table Rapport
INSERT INTO Rapport (date_rapport, type, description) VALUES
('2024-01-01', 'Stocks en magasin', 'Description 1'),
('2024-02-01', 'Commandes clients', 'Description 2'),
('2024-03-01', 'Commandes fournisseurs', 'Description 3'),
('2024-04-01', 'Produits les plus populaires', 'Description 4'),
('2024-05-01', 'Produits les moins populaires', 'Description 5');

-- Insertion de données dans la table Retour
INSERT INTO Retour (date_retour, raison, id_employe, id_produit) VALUES
('2024-01-11', 'Produit brisé', 1, 1),
('2024-02-01', 'Mauvais produit', 2, 2),
('2024-12-11', 'Ne fonctionne pas', 3, 3),
('2024-05-17', 'Non satisfait', 4, 4),
('2024-05-15', 'Cadeau non désiré', 5, 5);

-- Insertion de données dans la table AdministrateurRapport
INSERT INTO AdministrateurRapport (id_admin, id_rapport) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- Insertion de données dans la table AdministrateurProduits
INSERT INTO AdministrateurProduits (id_admin, id_produit) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- Insertion de données dans la table CommandesFournisseurProduits
INSERT INTO CommandesFournisseurProduits (id_produit, id_commande_fournisseur) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- Insertion de données dans la table CommandesClientProduits
INSERT INTO CommandesClientProduits (id_produit, id_commande_client) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- Insertion de données dans la table EmployeCommandesClient
INSERT INTO EmployeCommandesClient (id_employe, id_commande_client) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

