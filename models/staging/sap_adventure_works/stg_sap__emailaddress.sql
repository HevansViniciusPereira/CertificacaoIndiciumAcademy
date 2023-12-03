with
    fonte_emailaddress as (
        select
            cast(businessentityid as int) as businessentityid
            , cast(emailaddressid as int) as emailaddressid
            , cast(emailaddress as string) as emailaddress
            , cast(rowguid as string) as rowguid
            , cast(modifieddate as timestamp) as modifieddate
        from {{ source('sap_adventure_works', 'emailaddress') }}
    )

select *
from fonte_emailaddress