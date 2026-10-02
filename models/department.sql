SELECT
    ROW_NUMBER() OVER (ORDER BY department) AS id,
    department
FROM {{ ref('stg_department') }}