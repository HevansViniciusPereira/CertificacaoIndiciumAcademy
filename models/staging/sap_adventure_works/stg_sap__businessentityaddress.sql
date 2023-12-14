with
    fonte_businessentityaddress as (
        select
            cast(businessentityid as int) as businessentityid
            , cast(addressid as int) as addressid
            , cast(addresstypeid as int) as addresstypeid
            --, rowguid
            --, modifieddate
        from {{ source('sap_adventure_works', 'businessentityaddress') }}
    )

select *
from fonte_businessentityaddress