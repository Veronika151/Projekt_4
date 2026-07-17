-- Výzkumná otázka č. 4
--
-- Existuje rok, ve kterém byl meziroční nárůst cen
-- potravin výrazně vyšší než růst mezd
-- (větší než 10 procentních bodů)?
-- =========================================================

WITH yearly_prices AS (
    SELECT DISTINCT
        year,
        product_code,
        product_name,
        avg_price_value
    FROM t_veronika_ziburova_project_SQL_primary_final
),
price_comparison AS (
    SELECT
        year,
        product_code,
        product_name,
        avg_price_value,
        LAG(avg_price_value) OVER (
            PARTITION BY product_code
            ORDER BY year
        ) AS previous_price
    FROM yearly_prices
),
price_growth AS (
    SELECT
        year,
        (
            (avg_price_value - previous_price)
            / NULLIF(previous_price, 0)
            * 100
        ) AS price_growth_percent
    FROM price_comparison
    WHERE previous_price IS NOT NULL
),
average_price_growth AS (
    SELECT
        year,
        AVG(price_growth_percent) AS avg_price_growth_percent
    FROM price_growth
    GROUP BY year
),
yearly_payroll AS (
    SELECT DISTINCT
        year,
        branch_code,
        industry_branch_name,
        avg_payroll_value
    FROM t_veronika_ziburova_project_SQL_primary_final
),
payroll_comparison AS (
    SELECT
        year,
        branch_code,
        industry_branch_name,
        avg_payroll_value,
        LAG(avg_payroll_value) OVER (
            PARTITION BY branch_code
            ORDER BY year
        ) AS previous_payroll
    FROM yearly_payroll
),
payroll_growth AS (
    SELECT
        year,
        (
            (avg_payroll_value - previous_payroll)
            / NULLIF(previous_payroll, 0)
            * 100
        ) AS payroll_growth_percent
    FROM payroll_comparison
    WHERE previous_payroll IS NOT NULL
),
average_payroll_growth AS (
    SELECT
        year,
        AVG(payroll_growth_percent) AS avg_payroll_growth_percent
    FROM payroll_growth
    GROUP BY year
)
SELECT
    p.year,
    ROUND(
        p.avg_payroll_growth_percent::numeric,
        2
    ) AS payroll_growth_percent,
    ROUND(
        pr.avg_price_growth_percent::numeric,
        2
    ) AS price_growth_percent,
    ROUND(
        (
            pr.avg_price_growth_percent
            - p.avg_payroll_growth_percent
        )::numeric,
        2
    ) AS difference_percentage_points
FROM average_payroll_growth p
JOIN average_price_growth pr
    ON p.year = pr.year
ORDER BY
    p.year;
