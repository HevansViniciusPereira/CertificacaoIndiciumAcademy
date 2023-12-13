with
    Customer as (
        select 
            customerid
            , personid
            , storeid
        from {{ref('stg_sap__customer')}}
    )

    , Person as (
        select
            businessentityid as buid_person
            , firstname
            , middlename
            , lastname
        from {{ref('stg_sap__person')}}
    )

    , Store as (
        select
            businessentityid as buid_store
            , name as store_name
        from {{ref('stg_sap__store')}}
    )

    , Final as (
        select
            row_number() over (order by Customer.customerid, Store.buid_store) as sk_person
            , Customer.customerid
            --, Person.buid_person
            , Person.firstname
            , Person.middlename
            , Person.lastname
            --, Store.buid_store
            , Store.store_name
        from Customer
        left join Person 
            on Customer.personid = Person.buid_person
        left join Store 
            on Customer.storeid = Store.buid_store
    )

select * from Final