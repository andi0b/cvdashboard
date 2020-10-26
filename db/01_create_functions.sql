drop function inzidenz(days integer, per_capita integer);
create function inzidenz(days int default 7, per_capita int default 100000)
    returns table
            (
                date         timestamp,
                bundesland   varchar,
                w_anz_faelle int,
                w_inz_faelle float
            )
    language SQL
as
$$
select date,
       bundesland,
       sum(anz_faelle) over w                                       as w_anz_faelle,
       (sum(anz_faelle) over w)::float / anz_einwohner * per_capita as w_inz_faelle
from timeline_laender
    window w as (partition by bundesland order by date rows between days preceding and 1 preceding)
$$;

