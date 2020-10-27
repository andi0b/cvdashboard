drop function if exists inzidenz(days integer, per_capita integer, delta_days integer);
create or replace function inzidenz(days int default 7, per_capita int default 100000, delta_days int default 5)
    returns table
            (
                date                            timestamp,
                region                          varchar,
                rid                             int,
                typ                             varchar,
                anz_faelle                      int,
                inzidenz                        float,
                inzidenz_days_ago               float,
                inzidenz_delta                  float,
                inzidenz_delta_daily            float,
                inzidenz_increase_percent       float,
                inzidenz_increase_daily_percent float
            )
    language SQL
as
$$
select *,
       (pow(1 + abs((inzidenz_increase_percent / 100.0)), 1.0 / delta_days) - 1) * 100
           * (case when inzidenz_increase_percent < 0 then -1 else 1 end)
           as inzidenz_increase_daily_percent

from (
         select *,
                inzidenz_delta / delta_days as inzidenz_delta_daily,
                case
                    when inzidenz_days_ago = 0
                        then 0
                    else
                        inzidenz_delta / inzidenz_days_ago * 100
                    end                     as inzidenz_increase_percent

         from (
                  select *,
                         lag(inzidenz, delta_days) over w_delta              as inzidenz_days_ago,
                         inzidenz - (lag(inzidenz, delta_days) over w_delta) as inzidenz_delta
                  from (
                           select date,
                                  region,
                                  rid,
                                  typ,
                                  sum(anz_faelle) over w_inz                                       as anz_faelle,
                                  (sum(anz_faelle) over w_inz)::float / anz_einwohner * per_capita as inzidenz
                           from timeline_full
                               window w_inz as (partition by region order by date rows between days preceding and 1 preceding)) inz
                      window w_delta as (partition by region order by date)
              ) delta
     ) deltapercent
$$;