SELECT DISTINCT
    ObjectID AS artwork_id,
    trim(unnest(str_split(ConstituentID, ','))) AS artist_id
FROM {{ ref('raw_artworks') }}
WHERE ConstituentID IS NOT NULL
  AND ConstituentID <> ''