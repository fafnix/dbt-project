{{ 
    config (
        materialized="table"
    )
}}

WITH orders AS (
    SELECT * FROM {{ref('stg_orders')}}
), payments AS (
    SELECT * FROM {{ref('stg_payments')}}
), customers AS (
    SELECT * FROM {{ref('stg_customers')}}
), customer_orders AS (
    select
        orders.customer_id,
        min(orders.order_date) as first_order_date,
        max(orders.order_date) as most_recent_order_date,
        count(orders.order_id) as number_of_orders,
        SUM(payments.amount) AS lifetime_value

    from orders
    LEFT JOIN payments
    ON orders.order_id = payments.payment_id

    group by 1

), final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        COALESCE(customer_orders.lifetime_value, 0) AS lifetime_value

    from customers

    LEFT JOIN customer_orders using (customer_id)

)

select * from final