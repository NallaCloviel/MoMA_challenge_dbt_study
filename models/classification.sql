SELECT
    ROW_NUMBER() OVER (ORDER BY classification) AS id,
    classification
FROM {{ ref('stg_classification') }}