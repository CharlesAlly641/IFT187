DROP TABLE IF EXISTS personne
DROP TABLE IF EXISTS clients
DROP TABLE IF EXISTS employe
DROP TABLE IF EXISTS commandesclient
DROP TABLE IF EXISTS commandes
DROP TABLE IF EXISTS commandesfournisseur
DROP TABLE IF EXISTS retour
DROP TABLE IF EXISTS historiquecommande
DROP TABLE IF EXISTS fournisseur
DROP TABLE IF EXISTS administrateur
DROP TABLE IF EXISTS produits
DROP TABLE IF EXISTS historiquevente
DROP TABLE IF EXISTS rapport
DROP TABLE IF EXISTS administrateurrapport
DROP TABLE IF EXISTS administrateurproduits
DROP TABLE IF EXISTS commandesfournisseurproduits
DROP TABLE IF EXISTS commandesclientproduits
DROP TABLE IF EXISTS employecommandesclient

-- Creation de la table Personne qui est une generalisation des tables administrateur, 
-- employe et clients.
create table personne
(
    id_personne serial
        primary key,
    nom         varchar(100) not null,
    prenom      varchar(100) not null,
    email       varchar(100) not null,
    telephone   varchar(20)  not null
);

-- Creation de la table Administrateur : Administrateurs du système, ils ont des accès à 
-- certaines parties du système innaccessibles aux employés réguliers.
create table administrateur
(
    id_admin    serial
        primary key,
    id_personne integer
        references personne
);

-- Creation de la table Clients : Les clients du magasin.
create table clients
(
    id_client   serial
        primary key,
    id_personne integer
        references personne
);

-- Creation de la table Employe : Les employes qui travaillent au magasin 
-- (excluant les administrateurs qui ont des rôles plus complexes).
create table employe
(
    id_employe  serial
        primary key,
    id_personne integer
        references personne
);

-- Creation de la table Fournisseur : Les fournisseurs (compagnies) qui fournissent 
-- les produits qui sont tenus en stock.
create table fournisseur
(
    id_fournisseur serial
        primary key,
    nom            varchar(100) not null,
    adresse        varchar(200) not null,
    email          varchar(100) not null,
    telephone      varchar(20)  not null
);

-- Creation de la table Produits : Les produits tenus en magasin.
create table produits
(
    id_produit           serial
        primary key,
    nom_produit          varchar(100)   not null,
    description          varchar(200)   not null,
    prix                 numeric(10, 2) not null,
    quantite_en_stock    integer        not null,
    quantite_en_commande integer        not null
);

-- Creation de la table Commandes qui est une generalisation des commandes des fournisseurs 
-- et des clients.
create table commandes
(
    id_commande   serial
        primary key,
    date_commande date        not null,
    quantite      integer     not null, -- la quantite commandé
    statut        varchar(50) not null  -- le statut de la livraison
);

-- Creation de la table CommandesClient : Les commandes passées par les clients.
create table commandesclient
(
    id_commande_client serial
        primary key
        references commandes,
    type        varchar(50)    not null,	--En magasin ou en livraison
    montant     numeric(10, 2) not null,
    adresse     varchar(100),			-- L'adresse de livraison si appliquable
    id_client   integer
        references clients
);

-- Creation de la table CommandesFournisseur : Les commandes passées aux fournisseurs.
create table commandesfournisseur
(
    id_commande_fournisseur    serial
        primary key
        references commandes,
    date_livraison date         not null,
    adresse        varchar(100) not null,
    id_fournisseur integer
        references fournisseur
);

-- Creation de la table HistoriqueCommande : Enregistremement de toutes les commandes
-- passées par les clients ou reçues par les fournisseurs.
create table historiquecommande
(
    id_historique  serial
        primary key,
    date_commande  date           not null,
    montant        numeric(10, 2) not null,
    type           varchar(50)    not null,	-- Client ou fournisseur
    id_fournisseur integer
        references fournisseur,
    id_client      integer
        references clients
);

-- Creation de la table HistoriqueVente : Enregistrement de toutes les ventes d'un
-- produit en magasin.
create table historiquevente
(
    id_historique serial
        primary key,
    date_vente    date    not null,
    quantite      integer not null,		-- Quantité vendu
    id_produit    integer
        references produits
);

-- Creation de la table Rapport : Les rapports générés par les administrateurs du 
-- système.
create table rapport
(
    id_rapport   serial
        primary key,
    date_rapport date         not null,
    type         varchar(100) not null,		-- Type du rapport (rapport des stocks en magasin, des commandes client et fournisseur, des produits les plus populaires du moment) 
    description  varchar(1000)
);

-- Creation de la table Retour : Les retours de produits vendus aux Clients.
create table retour
(
    id_retour   serial
        primary key,
    date_retour date         not null,
    raison      varchar(200) not null,
    id_employe  integer
        references employe,
    id_produit  integer
        references produits
);

-- Creation de la table AdministrateurRapport : Table associative entre Administrateur et 
-- Rapport.
create table administrateurrapport
(
    id_admin integer not null
        references administrateur,
    id_rapport integer not null
        references rapport,
    primary key (id_admin, id_rapport)
);

-- Creation de la table AdministrateurProduits : Table associative entre Administrateur et 
-- Produits
create table administrateurproduits
(
    id_admin integer not null
        references administrateur,
    id_produit integer not null
        references produits,
    primary key (id_admin, id_produit)
);

-- Creation de la table CommandesFournisseurProduits : Table associative entre Produits et 
-- CommandesFournisseur.
create table commandesfournisseurproduits
(
    id_produit  integer not null
        references produits,
    id_commande_fournisseur integer not null
        references commandesfournisseur,
    primary key (id_produit, id_commande_fournisseur)
);

-- Creation de la table CommandesClientProduits : Table associative entre CommandesClients 
-- et Produits.
create table commandesclientproduits
(
    id_produit  integer not null
        references produits,
    id_commande_client integer not null
        references commandesclient,
    primary key (id_produit, id_commande_client)
);

-- Creation de la table EmployeCommandesClient : Table associative entre Employe et 
-- CommandesClient.
create table employecommandesclient
(
    id_employe  integer not null
        references employe,
    id_commande_client integer not null
        references commandesclient,
    primary key (id_employe, id_commande_client)
);



