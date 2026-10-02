SELECT
    a.object_id,
    a.title,
    a.creation_date,
    a.medium,
    a.dimensions,
    a.creditline,
    a.accession_number,
    a.date_acquired,
    a.cataloged,
    a.url,
    a.image_url,
    a.on_view,
    a.circumference_cm,
    a.depth_cm,
    a.diameter_cm,
    a.height_cm,
    a.length_cm,
    a.weight_kg,
    a.width_cm,
    a.seat_height_cm,
    a.duration_sec,
    d.id AS department_id,
    c.id AS classification_id
FROM {{ ref('stg_artwork') }} AS a
LEFT JOIN {{ ref('department') }} AS d
    ON a.department = d.department
LEFT JOIN {{ ref('classification') }} AS c
    ON a.classification = c.classification