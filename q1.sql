
-- Výzkumná otázka č. 1
--
-- Rostou v průběhu let mzdy ve všech odvětvích,
-- nebo v některých odvětvích klesají?
-- =========================================================

WITH yearly_salary AS (

    SELECT
        year,
        industry_branch_name,
        AVG(avg_payroll_value) AS avg_payroll_value

    FROM t_veronika_ziburova_project_SQL_primary_final

    GROUP BY
        year,
        industry_branch_name

),

salary_changes AS (

    SELECT
        year,
        industry_branch_name,
        avg_payroll_value,

        LAG(avg_payroll_value) OVER (
            PARTITION BY industry_branch_name
            ORDER BY year
        ) AS previous_payroll

    FROM yearly_salary

)

SELECT
    year,
    industry_branch_name,
    avg_payroll_value,
    previous_payroll,

    ROUND(
        (
            (avg_payroll_value - previous_payroll)::numeric
            / previous_payroll * 100
        ),
        2
    ) AS salary_change_percent,

    CASE
        WHEN avg_payroll_value > previous_payroll THEN 'Růst'
        WHEN avg_payroll_value < previous_payroll THEN 'Pokles'
        ELSE 'Beze změny'
    END AS salary_change

FROM salary_changes

WHERE previous_payroll IS NOT NULL

ORDER BY
    industry_branch_name,
    year;