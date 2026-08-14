-- Tifosi - Requêtes de vérification
-- Prérequis : exécuter 01_creation_schema.sql puis 02_peuplement.sql.

SET NAMES utf8mb4;
USE tifosi;

-- 1. Afficher les noms des focaccias par ordre alphabétique croissant.
-- Attendu / obtenu : Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne,
-- Mozaccia, Paysanne, Raclaccia, Tradizione. Aucun écart.
SELECT nom_focaccia
FROM focaccia
ORDER BY nom_focaccia ASC;

-- 2. Afficher le nombre total d'ingrédients.
-- Attendu / obtenu : 25. Aucun écart.
SELECT COUNT(*) AS nombre_ingredients
FROM ingredient;

-- 3. Afficher le prix moyen des focaccias.
-- Attendu / obtenu : 10,38 € (valeur exacte 10,375 arrondie à 2 décimales).
-- Aucun écart.
SELECT ROUND(AVG(prix), 2) AS prix_moyen
FROM focaccia;

-- 4. Afficher les boissons avec leur marque, triées par nom de boisson.
-- Attendu / obtenu : 12 lignes, de Capri-sun/Coca-cola à
-- Pepsi Max Zéro/Pepsico dans l'ordre alphabétique. Aucun écart.
SELECT b.nom_boisson, m.nom_marque
FROM boisson AS b
INNER JOIN marque AS m ON m.id_marque = b.id_marque
ORDER BY b.nom_boisson ASC;

-- 5. Afficher les ingrédients de la Raclaccia.
-- Attendu / obtenu : Ail, Base Tomate, Champignon, Cresson, Parmesan, Poivre,
-- Raclette. Aucun écart.
SELECT i.nom_ingredient
FROM focaccia AS f
INNER JOIN comprend AS c ON c.id_focaccia = f.id_focaccia
INNER JOIN ingredient AS i ON i.id_ingredient = c.id_ingredient
WHERE f.nom_focaccia = 'Raclaccia'
ORDER BY i.nom_ingredient ASC;

-- 6. Afficher le nom et le nombre d'ingrédients de chaque focaccia.
-- Attendu / obtenu : Américaine 8, Emmentalaccia 7, Gorgonzollaccia 8,
-- Hawaienne 9, Mozaccia 10, Paysanne 12, Raclaccia 7, Tradizione 9.
-- Aucun écart.
SELECT f.nom_focaccia, COUNT(c.id_ingredient) AS nombre_ingredients
FROM focaccia AS f
LEFT JOIN comprend AS c ON c.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY f.nom_focaccia ASC;

-- 7. Afficher la ou les focaccias qui ont le plus d'ingrédients.
-- Attendu / obtenu : Paysanne, 12. Aucun écart. La formulation conserve les
-- ex aequo éventuels plutôt que d'en masquer un avec LIMIT 1.
WITH nombre_par_focaccia AS (
    SELECT f.id_focaccia, f.nom_focaccia,
           COUNT(c.id_ingredient) AS nombre_ingredients
    FROM focaccia AS f
    LEFT JOIN comprend AS c ON c.id_focaccia = f.id_focaccia
    GROUP BY f.id_focaccia, f.nom_focaccia
)
SELECT nom_focaccia, nombre_ingredients
FROM nombre_par_focaccia
WHERE nombre_ingredients = (
    SELECT MAX(nombre_ingredients)
    FROM nombre_par_focaccia
)
ORDER BY nom_focaccia ASC;

-- 8. Afficher les focaccias qui contiennent de l'ail.
-- Attendu / obtenu : Gorgonzollaccia, Mozaccia, Paysanne, Raclaccia.
-- Aucun écart.
SELECT f.nom_focaccia
FROM focaccia AS f
WHERE EXISTS (
    SELECT 1
    FROM comprend AS c
    INNER JOIN ingredient AS i ON i.id_ingredient = c.id_ingredient
    WHERE c.id_focaccia = f.id_focaccia
      AND i.nom_ingredient = 'Ail'
)
ORDER BY f.nom_focaccia ASC;

-- 9. Afficher les ingrédients inutilisés.
-- Attendu / obtenu : Salami, Tomate cerise. Aucun écart.
SELECT i.nom_ingredient
FROM ingredient AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM comprend AS c
    WHERE c.id_ingredient = i.id_ingredient
)
ORDER BY i.nom_ingredient ASC;

-- 10. Afficher les focaccias qui n'ont pas de champignons.
-- Attendu / obtenu : Américaine, Hawaienne. Aucun écart.
SELECT f.nom_focaccia
FROM focaccia AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM comprend AS c
    INNER JOIN ingredient AS i ON i.id_ingredient = c.id_ingredient
    WHERE c.id_focaccia = f.id_focaccia
      AND i.nom_ingredient = 'Champignon'
)
ORDER BY f.nom_focaccia ASC;
