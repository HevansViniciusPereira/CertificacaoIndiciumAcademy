with
    fonte_countryregion as (
        select
            cast(countryregioncode as string) as countryregioncode
            , cast(name as string) as name
        from {{ source('sap_adventure_works', 'countryregion') }}
    )

select *
from fonte_countryregion