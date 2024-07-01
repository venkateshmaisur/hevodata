SELECT *
FROM {{ ref('raw_payments') }}
WHERE payment_id IS NULL

