-- Contrainte : le id d'une personne doit être positif
alter table personne
    add constraint check_id_personne
        check (id_personne > 0);

-- Contrainte : le id d'un administrateur doit être positif
alter table administrateur
    add constraint check_id_admin
        check (id_admin > 0);

-- Contrainte : le id d'un client doit être positif
alter table clients
    add constraint check_id_client
        check (id_client > 0);

-- Contrainte : le id d'un employé doit être positif
alter table employe
    add constraint check_id_employe
        check (id_employe > 0);

-- Contrainte : le id d'un fournisseur doit être positif
alter table fournisseur
    add constraint check_id_fournisseur
        check (id_fournisseur > 0);

-- Contrainte : le prix d'un produit doit être positif
alter table produits
    add constraint check_prix
        check (prix > 0.0);

-- Contrainte : la quantité en stock d'un produit doit être positive
alter table produits
    add constraint check_quantite_en_stock
        check (quantite_en_stock > 0);

-- Contrainte : la quantité en commande d'un produit doit être positive ou nulle
alter table produits
    add constraint check_quantite_en_commande
        check (quantite_en_commande >= 0);

-- Contrainte : le id d'un produit doit être positif
alter table produits
    add constraint check_id_produit
        check (id_produit > 0);

-- Contrainte : le quantité d'un produit dans une commande doit être positive
alter table commandes
    add constraint check_quantite
        check (quantite > 0);

-- Contrainte : le id d'une commande doit être positif
alter table commandes
    add constraint check_id_commande
        check (id_commande > 0);

-- Contrainte : le id d'une commande de client doit être positif
alter table commandesclient
    add constraint check_id_commande_client
        check (id_commande_client > 0);

-- Contrainte : le id d'une commande d'un fournisseur doit être positif
alter table commandesfournisseur
    add constraint check_id_commande_fournisseur
        check (id_commande_fournisseur > 0);

-- Contrainte : le montant d'une commande doit être positif
alter table historiquecommande
    add constraint check_montant
        check (montant > 0.0);

-- Contrainte : le id d'un historique de commande doit être positif
alter table historiquecommande
    add constraint check_id_historique_commande
        check (id_historique > 0);

-- Contrainte : la quantité d'un produit vendu doit être positive
alter table historiquevente
    add constraint check_quantite
        check (quantite > 0);

-- Contrainte : le id d'un historique de vente doit être positif
alter table historiquevente
    add constraint check_id_historique_vente
        check (id_historique > 0);

-- Contrainte : le id d'un rapport doit être positif
alter table rapport
    add constraint check_id_rapport
        check (id_rapport > 0);

-- Contrainte : le id d'un retour doit être positif
alter table retour
    add constraint check_id_retour
        check (id_retour > 0);


