CREATE TABLE t_veronika_ziburova_project_SQL_secondary_final AS

SELECT
    c.country,
    e.year,
    e.gdp,
    e.gini,
    e.population

FROM countries c

JOIN economies e
    ON e.country = c.country

WHERE 
    e.year BETWEEN 2006 AND 2018
    AND c.continent = 'Europe';


-- kontrola výsledku

SELECT *
FROM t_veronika_ziburova_project_SQL_secondary_final;