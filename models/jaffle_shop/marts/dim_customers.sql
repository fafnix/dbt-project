{{ 
    config (
        materialized="table"
    )
}}

WITH customer_orders AS (

    select
        stg_orders.customer_id,
        min(stg_orders.order_date) as first_order_date,
        max(stg_orders.order_date) as most_recent_order_date,
        count(stg_orders.order_id) as number_of_orders,
        SUM(stg_payments.amount) AS lifetime_value

    from stg_orders
    LEFT JOIN stg_payments
    ON stg_orders.order_id = stg_payments.payment_id

    group by 1

),


final as (

    select
        stg_customers.customer_id,
        stg_customers.first_name,
        stg_customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        COALESCE(customer_orders.lifetime_value, 0) AS lifetime_value

    from stg_customers

    left join customer_orders using (customer_id)

)

select * from final