with
    fonte_businessentityaddress as (
        select * 
        from {{ source('sap_adventure_works', 'businessentityaddress') }}
    )

select *
from fonte_businessentityaddress