{{ 
    config (
        materialized="table"
    )
}}

with store_customers as (

    select
        customer_id,
        first_name,
        last_name

    from customers

),

store_orders as (

    select
        order_id,
        customer_id,
        order_date,
        status

    from orders

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from store_orders

    group by 1

),


final as (

    select
        store_customers.customer_id,
        store_customers.first_name,
        store_customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from store_customers

    left join customer_orders using (customer_id)

)

select * from final