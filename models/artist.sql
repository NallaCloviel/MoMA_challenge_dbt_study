SELECT
    constituent_id AS id,
    artist AS name,
    NULLIF(nationality, '') AS nationality,
    NULLIF(gender, '') AS gender,
    TRY_CAST(begin_date AS INTEGER) AS birth_year,
    CASE 
        WHEN end_date = '0' OR end_date = '' THEN NULL 
        ELSE TRY_CAST(end_date AS INTEGER) 
    END AS death_year
FROM {{ ref('stg_artist') }}