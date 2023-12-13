with
    stg_sap__customer as (
        select 
            customerid
            , personid
            , storeid
        from {{ref('stg_sap__customer')}}
    )

    , stg_sap__person as (
        select
            businessentityid as buid_person
            , firstname
            , middlename
            , lastname
        from {{ref('stg_sap__person')}}
    )

    , stg_sap__store as (
        select
            businessentityid as buid_store
            , name as store_name
        from {{ref('stg_sap__store')}}
    )

    , Final as (
        select
            row_number() over (order by stg_sap__customer.customerid, stg_sap__store.buid_store) as customer_sk
            , stg_sap__customer.customerid
            --, stg_sap__person.buid_person
            , stg_sap__person.firstname
            , stg_sap__person.middlename
            , stg_sap__person.lastname
            --, stg_sap__store.buid_store
            , stg_sap__store.store_name
        from stg_sap__customer
        left join stg_sap__person 
            on stg_sap__customer.personid = stg_sap__person.buid_person
        left join stg_sap__store 
            on stg_sap__customer.storeid = stg_sap__store.buid_store
    )

select * from Final