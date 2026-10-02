WITH parsed AS (
    SELECT
        str_split(ConstituentID, ', ') AS ids,
        str_split(Artist, ', ') AS artists,
        str_split(replace(replace(Nationality, ')', ''), '(', ''), ' ') AS nationalities,
        str_split(replace(replace(Gender, ')', ''), '(', ''), ' ') AS genders,
        str_split(replace(replace(BeginDate, ')', ''), '(', ''), ' ') AS begin_dates,
        str_split(replace(replace(EndDate, ')', ''), '(', ''), ' ') AS end_dates
    FROM {{ ref('raw_artworks') }}
    WHERE ConstituentID IS NOT NULL
),
filtered AS (
    SELECT *
    FROM parsed
    WHERE len(ids) = len(artists)
),
exploded AS (
    SELECT
        trim(unnest(ids)) AS constituent_id,
        trim(unnest(artists)) AS artist,
        trim(unnest(nationalities)) AS nationality,
        trim(unnest(genders)) AS gender,
        trim(unnest(begin_dates)) AS begin_date,
        trim(unnest(end_dates)) AS end_date
    FROM filtered
)
SELECT DISTINCT *
FROM exploded
WHERE constituent_id <> ''