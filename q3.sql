-- Výzkumná otázka č. 3
--
-- Která kategorie potravin zdražuje nejpomaleji
-- (má nejnižší průměrný procentuální meziroční nárůst)?
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
        ) AS previous_price_value

    FROM yearly_prices

),

yearly_price_growth AS (

    SELECT
        year,
        product_code,
        product_name,

        (
            (avg_price_value - previous_price_value)
            / NULLIF(previous_price_value, 0)
            * 100
        ) AS price_growth_percent

    FROM price_comparison

    WHERE previous_price_value IS NOT NULL

)

SELECT
    product_code,
    product_name,

    ROUND(
        AVG(price_growth_percent)::numeric,
        2
    ) AS average_yearly_growth_percent

FROM yearly_price_growth

GROUP BY
    product_code,
    product_name

ORDER BY
    average_yearly_growth_percent,
    product_name;