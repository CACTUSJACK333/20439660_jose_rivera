SELECT
    CASE
        WHEN edad BETWEEN 18 AND 35 THEN '18-35'
        WHEN edad BETWEEN 36 AND 55 THEN '36-55'
        ELSE '56+'
    END AS rango_edad,

    LEFT(codigo_postal, 1) AS region,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2

HAVING COUNT(*) >= 10;