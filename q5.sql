-- Výzkumná otázka č. 5
--
-- Má růst HDP vliv na změny mezd a cen potravin
-- ve stejném nebo následujícím roce?
-- =========================================================

WITH gdp_values AS (

    SELECT
        year,
        gdp,

        LAG(gdp) OVER (
            ORDER BY year
        ) AS previous_gdp

    FROM t_veronika_ziburova_project_SQL_secondary_final

    WHERE country = 'Czech Republic'

),

gdp_growth AS (

    SELECT
        year,

        (
            (gdp - previous_gdp)
            / NULLIF(previous_gdp, 0)
            * 100
        ) AS gdp_growth_percent

    FROM gdp_values

    WHERE previous_gdp IS NOT NULL

),

yearly_prices AS (

    SELECT DISTINCT
        year,
        product_code,
        product_name,
        avg_price_value

    FROM t_veronika_ziburova_project_SQL_primary_final

),

price_values AS (

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

    FROM price_values

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

payroll_values AS (

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

    FROM payroll_values

    WHERE previous_payroll IS NOT NULL

),

average_payroll_growth AS (

    SELECT
        year,
        AVG(payroll_growth_percent) AS avg_payroll_growth_percent

    FROM payroll_growth

    GROUP BY year

),

current_year_comparison AS (

    SELECT
        g.year,
        g.gdp_growth_percent,
        p.avg_payroll_growth_percent,
        f.avg_price_growth_percent

    FROM gdp_growth g

    JOIN average_payroll_growth p
        ON p.year = g.year

    JOIN average_price_growth f
        ON f.year = g.year

)

SELECT
    c.year,

    ROUND(
        c.gdp_growth_percent::numeric,
        2
    ) AS gdp_growth_percent,

    ROUND(
        c.avg_payroll_growth_percent::numeric,
        2
    ) AS payroll_growth_same_year_percent,

    ROUND(
        c.avg_price_growth_percent::numeric,
        2
    ) AS price_growth_same_year_percent,

    ROUND(
        next_pay.avg_payroll_growth_percent::numeric,
        2
    ) AS payroll_growth_next_year_percent,

    ROUND(
        next_price.avg_price_growth_percent::numeric,
        2
    ) AS price_growth_next_year_percent

FROM current_year_comparison c

LEFT JOIN average_payroll_growth next_pay
    ON next_pay.year = c.year + 1

LEFT JOIN average_price_growth next_price
    ON next_price.year = c.year + 1

ORDER BY c.year;