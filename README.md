# Base de données Tifosi

Projet MySQL réalisé à partir du modèle conceptuel et des quatre classeurs fournis
pour le restaurant Tifosi.

## Prérequis

- MySQL 8.0 ou une version plus récente ;
- un compte administrateur MySQL pour la création de la base et de l'utilisateur.

## Installation

Depuis la racine du dépôt, exécuter les scripts dans cet ordre :

```bash
mysql -u root -p < 01_creation_schema.sql
mysql -u tifosi -p < 02_peuplement.sql
mysql -u tifosi -p < 03_requetes_test.sql
```

Le mot de passe initial du compte local `tifosi` est indiqué dans le premier
script.

## Contenu

- `01_creation_schema.sql` recrée la base, crée le compte local et toutes les
  tables du MCD avec leurs contraintes d'intégrité ;
- `02_peuplement.sql` insère dans une transaction les 8 focaccias, 25
  ingrédients, 4 marques, 12 boissons et 70 associations de composition ;
- `03_requetes_test.sql` contient les 10 contrôles demandés, leur but, leurs
  résultats attendus et obtenus, ainsi que les explications utiles.

Les quantités des ingrédients sont exprimées en grammes. Les orthographes du
référentiel `ingredient.xlsx` sont conservées afin d'éviter les doublons ; les
variantes présentes dans les recettes (`Chèvre`, `œuf`) sont donc rattachées à
`Chevre` et `Oeuf`. L'espace final de `Eau de source ` a été supprimé car il ne
fait pas partie du nom de la boisson.
