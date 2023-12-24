with
    Customer as (
        select *
        from {{ ref('stg_sap__customer') }}
    )

    , BusinessEntityAddress as (
        select *
        from {{ ref('stg_sap__businessentityaddress') }}
    )

    , CountryRegion as (
        select *
        from {{ ref('stg_sap__countryregion') }}
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
            row_number() over (order by Customer.customerid, Person.businessentityid) as pk_customer
            , Customer.customerid
            , Person.businessentityid
            , BusinessEntityAddress.addressid
            --, Person.firstname
            --, Person.middlename
            --, Person.lastname
            , concat(ifnull(Person.firstname,' '),' ',ifnull(Person.middlename,' '),' ',ifnull(Person.lastname,' ')) as fullname
            , Address.city
            , StateProvince.name as provincename
            , CountryRegion.name as countryname
        from Person
        left join Customer
            on Customer.personid = Person.businessentityid
        left join BusinessEntityAddress
            on BusinessEntityAddress.businessentityid = Person.businessentityid
        left join Address
            on Address.addressid = BusinessEntityAddress.addressid
        left join StateProvince
            on StateProvince.stateprovinceid = Address.stateprovinceid
        left join CountryRegion
            on StateProvince.countryregioncode = CountryRegion.countryregioncode
    )

select * from Final
