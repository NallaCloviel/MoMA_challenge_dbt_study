SELECT DISTINCT 
    Department AS department
FROM {{ ref('raw_artworks') }}
WHERE Department IS NOT NULL