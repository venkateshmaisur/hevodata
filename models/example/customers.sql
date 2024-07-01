{{ config(materialized='table') }}

with customers as (
    select
        CUSTOMER_ID as customer_id,
        FIRST_NAME,
        LAST_NAME
    from HEVO_DB.HEVO_SCHEMA.RAW_CUSTOMERS
),

first_order as (
    select
        CUSTOMER_ID as customer_id,
        min(order_date) as first_order_date
    from HEVO_DB.HEVO_SCHEMA.RAW_ORDERS
    group by CUSTOMER_ID
),

most_recent_order as (
    select
        CUSTOMER_ID as customer_id,
        max(order_date) as most_recent_order_date
    from HEVO_DB.HEVO_SCHEMA.RAW_ORDERS
    group by CUSTOMER_ID
),

number_of_orders as (
    select
        CUSTOMER_ID as customer_id,
        count(ORDER_ID) as number_of_orders
    from HEVO_DB.HEVO_SCHEMA.RAW_ORDERS
    group by CUSTOMER_ID
),

customer_lifetime_value as (
    select
        o.CUSTOMER_ID as customer_id,
        sum(p.amount) as customer_lifetime_value
    from HEVO_DB.HEVO_SCHEMA.RAW_ORDERS o
    join HEVO_DB.HEVO_SCHEMA.RAW_PAYMENTS p on o.CUSTOMER_ID = p.CUSTOMER_ID
    group by o.CUSTOMER_ID
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    fo.first_order_date as first_order,
    mro.most_recent_order_date as most_recent_order,
    no.number_of_orders,
    clv.customer_lifetime_value
from customers c
left join first_order fo on c.customer_id = fo.customer_id
left join most_recent_order mro on c.customer_id = mro.customer_id
left join number_of_orders no on c.customer_id = no.customer_id
left join customer_lifetime_value clv on c.customer_id = clv.customer_id

