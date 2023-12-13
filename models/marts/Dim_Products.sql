with
    SalesOrderDetail as (
        select distinct productid
        from {{ref('stg_sap__salesorderdetail')}}
    )

    , Product as (
        select
            productid
            , name
        from {{ref('stg_sap__product')}}
    )

    , Final as (
        select 
            row_number() over (order by SalesOrderDetail.productid) as sk_product
            , SalesOrderDetail.productid
            , Product.name 
        from SalesOrderDetail
        left join Product 
            on SalesOrderDetail.productid = Product.productid
    )

select * from Final