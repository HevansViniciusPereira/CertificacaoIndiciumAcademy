with
    stg_sap__salesreason as (
        select *
        from {{ ref('stg_sap__salesreason') }}
    )

    , stg_sap__creditcard as (
        select *
        from {{ ref('stg_sap__creditcard') }}
    )

    , stg_sap__salesorderheadersalesreason as (
        select *
        from {{ ref('stg_sap__salesorderheadersalesreason') }}
    )

    , stg_sap__salesorderdetail as (
        select *
        from {{ ref('stg_sap__salesorderdetail') }}
    )

    , stg_sap__salesorderheader as (
        select *
        from {{ ref('stg_sap__salesorderheader') }}
    )

    , Final as (
        select
            row_number() over(order by stg_sap__salesorderdetail.salesorderid, stg_sap__salesorderheader.customerid) as sk_orders
            , stg_sap__salesorderdetail.salesorderid
            , stg_sap__salesorderdetail.salesorderdetailid
            , stg_sap__salesorderdetail.orderqty
            , stg_sap__salesorderdetail.productid
            , stg_sap__salesorderdetail.unitprice
            , stg_sap__salesorderdetail.unitpricediscount
            , stg_sap__salesorderdetail.unitprice * stg_sap__salesorderdetail.orderqty as total_trated_value
            , stg_sap__salesorderdetail.unitprice * stg_sap__salesorderdetail.orderqty * (1 - stg_sap__salesorderdetail.unitpricediscount) as total_net_trated_value
            --, stg_sap__salesorderheader.revisionnumber
            , stg_sap__salesorderheader.orderdate
            --, stg_sap__salesorderheader.duedate
            , stg_sap__salesorderheader.shipdate
            , stg_sap__salesorderheader.status
            --, stg_sap__salesorderheader.onlineorderflag
            --, stg_sap__salesorderheader.purchaseordernumber
            --, stg_sap__salesorderheader.accountnumber
            --, stg_sap__salesorderheader.customerid
            --, stg_sap__salesorderheader.salespersonid
            --, stg_sap__salesorderheader.territoryid
            --, stg_sap__salesorderheader.billtoaddressid
            --, stg_sap__salesorderheader.shiptoaddressid
            --, stg_sap__salesorderheader.shipmethodid
            --, stg_sap__salesorderheader.creditcardid
            , stg_sap__creditcard.cardtype as creditcardname
            --, stg_sap__salesorderheader.creditcardapprovalcode
            --, stg_sap__salesorderheader.currencyrateid
            , stg_sap__salesorderheader.subtotal
            , stg_sap__salesorderheader.taxamt
            , stg_sap__salesorderheader.freight
            , stg_sap__salesorderheader.totaldue
            , stg_sap__salesreason.name as reason_name
        from stg_sap__salesorderheader
        inner join stg_sap__salesorderdetail
            on stg_sap__salesorderheader.salesorderid = stg_sap__salesorderdetail.salesorderid
        left join stg_sap__salesorderheadersalesreason
            on stg_sap__salesorderheadersalesreason.salesreasonid = stg_sap__salesorderdetail.salesorderid
        left join stg_sap__salesreason
            on stg_sap__salesreason.salesreasonid = stg_sap__salesorderheadersalesreason.salesreasonid
        left join stg_sap__creditcard
            on stg_sap__creditcard.creditcardid = stg_sap__salesorderheader.creditcardid
    )

select * from Final