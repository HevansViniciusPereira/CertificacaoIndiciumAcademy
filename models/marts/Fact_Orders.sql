with
    Dim_Products as (
        select *
        from {{ ref('Dim_Products') }}
    )

    , Dim_Customers as (
        select *
        from {{ ref('Dim_Customers') }}
    )

    , Orders_Aux as (
        select *
        from {{ ref('Fact_Orders_Aux') }}
    )

    , Final as (
        select
            Orders_Aux.sk_orders
            , Orders_Aux.salesorderid
            , Orders_Aux.salesorderdetailid
            , Dim_Customers.pk_customer
            , Orders_Aux.territoryid
            , Dim_Products.pk_product
            , Orders_Aux.orderqty
            , Orders_Aux.unitprice
            , Orders_Aux.unitpricediscount
            , Orders_Aux.total_trated_value
            , Orders_Aux.total_net_trated_value
            , Orders_Aux.orderdate
            --, Orders_Aux.shipdate
            , Orders_Aux.status
            , Orders_Aux.cardtype
            , Orders_Aux.subtotal
            , Orders_Aux.taxamt
            , Orders_Aux.freight
            , Orders_Aux.totaldue
            , case
                when Orders_Aux.reasontype is null then 'Not Informed'
                else Orders_Aux.reasontype
            end as reasonname
        from Orders_Aux
        left join Dim_Products
            on Orders_Aux.productid = Dim_Products.productid
        left join Dim_Customers
            on Orders_Aux.customerid = Dim_Customers.customerid
    )

select * from Final