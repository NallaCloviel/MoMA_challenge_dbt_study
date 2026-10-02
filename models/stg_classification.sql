SELECT DISTINCT 
    Classification AS classification
FROM {{ ref('raw_artworks') }}
WHERE Classification IS NOT NULL