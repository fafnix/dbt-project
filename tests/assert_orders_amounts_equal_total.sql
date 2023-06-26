WITH customer_orders AS (
    SELECT * FROM {{ ref('orders')}}
)

SELECT *
FROM customer_orders
WHERE (credit_card_amount + coupon_amount + bank_transfer_amount + gift_card_amount) != (amount)