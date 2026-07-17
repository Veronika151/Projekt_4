-- =========================================================
-- 1. Příprava dat o cenách potravin
-- =========================================================

CREATE TEMPORARY TABLE czechia_price_temporary AS
SELECT
    EXTRACT(YEAR FROM cp.date_from)::INTEGER AS year,
    cpc.code AS product_code,
    cpc.name AS product_name,
    ROUND(AVG(cp.value)::numeric, 2) AS avg_price_value,
    cpc.price_unit
FROM czechia_price cp
JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code
GROUP BY
    EXTRACT(YEAR FROM cp.date_from),
    cpc.code,
    cpc.name,
    cpc.price_unit;

-- =========================================================
-- 2. Příprava dat o mzdách
-- =========================================================

CREATE TEMPORARY TABLE czechia_payroll_temporary AS
SELECT
    cp.payroll_year AS year,
    cpib.code AS branch_code,
    cpib.name AS industry_branch_name,
    ROUND(AVG(cp.value)::numeric) AS avg_payroll_value
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib
    ON cp.industry_branch_code = cpib.code
WHERE 
    cp.value_type_code = 5958
    -- pouze mzdy
    AND cp.calculation_code = 200
    -- přepočtený počet zaměstnanců na plný úvazek
    AND cp.payroll_year BETWEEN 2006 AND 2018
GROUP BY
    cp.payroll_year,
    cpib.code,
    cpib.name;

-- =========================================================
-- 3. Vytvoření finální primární tabulky
-- =========================================================

DROP TABLE IF EXISTS t_veronika_ziburova_project_SQL_primary_final;

CREATE TABLE t_veronika_ziburova_project_SQL_primary_final AS
SELECT
    pay.year,
    pay.branch_code,
    pay.industry_branch_name,
    pay.avg_payroll_value,
    price.product_code,
    price.product_name,
    price.avg_price_value,
    price.price_unit
FROM czechia_payroll_temporary pay
JOIN czechia_price_temporary price
    ON pay.year = price.year;

-- =========================================================
-- Kontrola výsledné tabulky
-- =========================================================

SELECT *
FROM t_veronika_ziburova_project_SQL_primary_final;
