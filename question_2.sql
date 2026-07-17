-- Výzkumná otázka č. 2
--
-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední 
-- srovnatelné období v dostupných datech cen a mezd?
-- =========================================================

WITH comparable_years AS (
    SELECT
        MIN(year) AS first_year,
        MAX(year) AS last_year
    FROM t_veronika_ziburova_project_SQL_primary_final
),
yearly_payroll AS (
    SELECT DISTINCT
        year,
        branch_code,
        industry_branch_name,
        avg_payroll_value
    FROM t_veronika_ziburova_project_SQL_primary_final
),
average_payroll AS (
    SELECT
        year,
        AVG(avg_payroll_value) AS avg_payroll
    FROM yearly_payroll
    GROUP BY year
),
selected_food_prices AS (
    SELECT DISTINCT
        year,
        product_code,
        product_name,
        avg_price_value,
        price_unit
    FROM t_veronika_ziburova_project_SQL_primary_final
    WHERE product_code IN (
        111301,  -- Chléb konzumní kmínový
        114201   -- Mléko polotučné pasterované
    )
)
SELECT
    fp.year,
    fp.product_name,
    fp.price_unit,
    ROUND(
        ap.avg_payroll::numeric,
        2
    ) AS avg_payroll,
    ROUND(
        fp.avg_price_value::numeric,
        2
    ) AS avg_price,
    FLOOR(
        ap.avg_payroll
        / NULLIF(fp.avg_price_value, 0)
    ) AS purchasable_units
FROM selected_food_prices fp
JOIN average_payroll ap
    ON fp.year = ap.year
CROSS JOIN comparable_years cy
WHERE fp.year IN (
    cy.first_year,
    cy.last_year
)
ORDER BY
    fp.product_name,
    fp.year;
