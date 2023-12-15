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
            row_number() over (order by SalesOrderDetail.productid) as pk_product
            , Product.productid
            , Product.name 
        from Product 
        left join SalesOrderDetail
            on SalesOrderDetail.productid = Product.productid
    )

select * from Final