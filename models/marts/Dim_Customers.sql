with
    Customer as (
        select *
        from {{ ref('stg_sap__customer') }}
    )

    , BusinessEntityAddress as (
        select *
        from {{ ref('stg_sap__businessentityaddress') }}
    )

    , Address as (
        select *
        from {{ ref('stg_sap__address') }}
    )

    , StateProvince as (
        select *
        from {{ ref('stg_sap__stateprovince') }}
    )

    , Person as (
        select *
        from {{ ref('stg_sap__person') }}
    )

    , SalesOrderDetail as (
        select *
        from {{ ref('stg_sap__salesorderdetail') }}
    )

    , Final as (
        select
            row_number() over (order by Customer.customerid) as sk_customer
            , Customer.customerid
            , Person.businessentityid
            , Person.firstname
            , Person.middlename
            , Person.lastname
            , BusinessEntityAddress.addressid
            , Address.city
            , StateProvince.stateprovincecode
            , StateProvince.countryregioncode
        from Person
        left join Customer
            on Customer.personid = Person.businessentityid
        left join BusinessEntityAddress
            on BusinessEntityAddress.businessentityid = Person.businessentityid
        left join Address
            on Address.addressid = BusinessEntityAddress.addressid
        left join StateProvince
            on StateProvince.stateprovinceid = Address.stateprovinceid
    )

select * from Final
