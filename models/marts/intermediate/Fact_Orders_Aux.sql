with
    SalesReason as (
        select *
        from {{ ref('stg_sap__salesreason') }}
    )

    , CreditCard as (
        select *
        from {{ ref('stg_sap__creditcard') }}
    )

    , SalesOrderHeaderSalesReason as (
        select *
        from {{ ref('stg_sap__salesorderheadersalesreason') }}
    )

    , SalesOrderDetail as (
        select *
        from {{ ref('stg_sap__salesorderdetail') }}
    )

    , SalesOrderHeader as (
        select *
        from {{ ref('stg_sap__salesorderheader') }}
    )

    , Final as (
        select
            row_number() over(order by SalesOrderDetail.salesorderid, SalesOrderHeader.customerid) as sk_orders
            , SalesOrderDetail.salesorderid
            , SalesOrderDetail.salesorderdetailid
            , SalesOrderHeader.customerid
            , SalesOrderHeader.territoryid
            , SalesOrderDetail.productid
            , SalesOrderDetail.orderqty
            , SalesOrderDetail.unitprice
            , SalesOrderDetail.unitpricediscount
            , SalesOrderHeader.orderdate
            , SalesOrderHeader.shipdate
            , SalesOrderHeader.status
            , CreditCard.cardtype
            , SalesOrderHeader.subtotal
            , SalesOrderHeader.taxamt
            , SalesOrderHeader.freight
            , SalesOrderHeader.totaldue
            , SalesReason.name as reason_name
            , SalesOrderDetail.unitprice * SalesOrderDetail.orderqty as total_trated_value
            , SalesOrderDetail.unitprice * SalesOrderDetail.orderqty * (1 - SalesOrderDetail.unitpricediscount) as total_net_trated_value
        from SalesOrderHeader
        inner join SalesOrderDetail
            on SalesOrderHeader.salesorderid = SalesOrderDetail.salesorderid
        left join SalesOrderHeaderSalesReason
            on SalesOrderHeaderSalesReason.salesreasonid = SalesOrderDetail.salesorderid
        left join SalesReason
            on SalesReason.salesreasonid = SalesOrderHeaderSalesReason.salesreasonid
        left join CreditCard
            on CreditCard.creditcardid = SalesOrderHeader.creditcardid
    )

select * from Final