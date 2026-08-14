-- Tifosi - Création de la base, de l'utilisateur et du schéma
-- Cible : MySQL 8.0+
-- À exécuter avec un compte administrateur MySQL.

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS tifosi;
CREATE DATABASE tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Le compte est volontairement limité à la base tifosi et aux connexions locales.
CREATE USER IF NOT EXISTS 'tifosi'@'localhost'
    IDENTIFIED BY 'Tifosi_2026!ChangeMe';
ALTER USER 'tifosi'@'localhost'
    IDENTIFIED BY 'Tifosi_2026!ChangeMe';
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';

USE tifosi;

CREATE TABLE ingredient (
    id_ingredient INT UNSIGNED AUTO_INCREMENT,
    nom_ingredient VARCHAR(50) NOT NULL,
    CONSTRAINT pk_ingredient PRIMARY KEY (id_ingredient),
    CONSTRAINT uq_ingredient_nom UNIQUE (nom_ingredient)
) ENGINE = InnoDB;

CREATE TABLE focaccia (
    id_focaccia INT UNSIGNED AUTO_INCREMENT,
    nom_focaccia VARCHAR(50) NOT NULL,
    prix DECIMAL(5,2) UNSIGNED NOT NULL,
    CONSTRAINT pk_focaccia PRIMARY KEY (id_focaccia),
    CONSTRAINT uq_focaccia_nom UNIQUE (nom_focaccia),
    CONSTRAINT chk_focaccia_prix CHECK (prix > 0)
) ENGINE = InnoDB;

CREATE TABLE comprend (
    id_focaccia INT UNSIGNED NOT NULL,
    id_ingredient INT UNSIGNED NOT NULL,
    quantite INT UNSIGNED NOT NULL,
    CONSTRAINT pk_comprend PRIMARY KEY (id_focaccia, id_ingredient),
    CONSTRAINT chk_comprend_quantite CHECK (quantite > 0),
    CONSTRAINT fk_comprend_focaccia FOREIGN KEY (id_focaccia)
        REFERENCES focaccia (id_focaccia)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_comprend_ingredient FOREIGN KEY (id_ingredient)
        REFERENCES ingredient (id_ingredient)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE client (
    id_client INT UNSIGNED AUTO_INCREMENT,
    nom_client VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,
    -- CHAR préserve les éventuels zéros initiaux d'un code postal français.
    code_postal CHAR(5) NOT NULL,
    CONSTRAINT pk_client PRIMARY KEY (id_client),
    CONSTRAINT uq_client_email UNIQUE (email),
    CONSTRAINT chk_client_email CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT chk_client_code_postal CHECK (code_postal REGEXP '^[0-9]{5}$')
) ENGINE = InnoDB;

CREATE TABLE menu (
    id_menu INT UNSIGNED AUTO_INCREMENT,
    nom_menu VARCHAR(50) NOT NULL,
    prix DECIMAL(5,2) UNSIGNED NOT NULL,
    id_focaccia INT UNSIGNED NOT NULL,
    CONSTRAINT pk_menu PRIMARY KEY (id_menu),
    CONSTRAINT uq_menu_nom UNIQUE (nom_menu),
    CONSTRAINT chk_menu_prix CHECK (prix > 0),
    CONSTRAINT fk_menu_focaccia FOREIGN KEY (id_focaccia)
        REFERENCES focaccia (id_focaccia)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE marque (
    id_marque INT UNSIGNED AUTO_INCREMENT,
    nom_marque VARCHAR(50) NOT NULL,
    CONSTRAINT pk_marque PRIMARY KEY (id_marque),
    CONSTRAINT uq_marque_nom UNIQUE (nom_marque)
) ENGINE = InnoDB;

CREATE TABLE boisson (
    id_boisson INT UNSIGNED AUTO_INCREMENT,
    nom_boisson VARCHAR(50) NOT NULL,
    id_marque INT UNSIGNED NOT NULL,
    CONSTRAINT pk_boisson PRIMARY KEY (id_boisson),
    CONSTRAINT uq_boisson_nom UNIQUE (nom_boisson),
    CONSTRAINT fk_boisson_marque FOREIGN KEY (id_marque)
        REFERENCES marque (id_marque)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE contient (
    id_menu INT UNSIGNED NOT NULL,
    id_boisson INT UNSIGNED NOT NULL,
    CONSTRAINT pk_contient PRIMARY KEY (id_menu, id_boisson),
    CONSTRAINT fk_contient_menu FOREIGN KEY (id_menu)
        REFERENCES menu (id_menu)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_contient_boisson FOREIGN KEY (id_boisson)
        REFERENCES boisson (id_boisson)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE achete (
    id_client INT UNSIGNED NOT NULL,
    id_menu INT UNSIGNED NOT NULL,
    date_achat DATE NOT NULL,
    CONSTRAINT pk_achete PRIMARY KEY (id_client, id_menu, date_achat),
    CONSTRAINT fk_achete_client FOREIGN KEY (id_client)
        REFERENCES client (id_client)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_achete_menu FOREIGN KEY (id_menu)
        REFERENCES menu (id_menu)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;
