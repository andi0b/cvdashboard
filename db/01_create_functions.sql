create or replace function calculate_deltas(value_current float, value_days_ago float, delta_days int default 1,
                                            out delta float,
                                            out delta_daily float,
                                            out increase_percent float,
                                            out increase_percent_daily float)
    language plpgsql immutable
as
$$
declare
    increase_ratio       float;
    increase_ratio_daily float;
begin
    delta := value_current - value_days_ago;
    delta_daily := delta / delta_days;

    increase_ratio := case
                          when value_days_ago = 0 then 0
                          else delta / value_days_ago end;

    -- calculate the daily ratio. applying it delta_days times,
    -- will result in the same as applying increase_ratio once
    increase_ratio_daily :=
                (pow(1 + abs(increase_ratio), 1.0 / delta_days) - 1)
                * (case when increase_ratio < 0 then -1 else 1 end);

    increase_percent := increase_ratio * 100;
    increase_percent_daily := increase_ratio_daily * 100;
end;
$$;

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
                inzidenz_delta                  float,
                inzidenz_delta_daily            float,
                inzidenz_increase_percent       float,
                inzidenz_increase_daily_percent float
            )
    language sql stable
as
$$
select date, region, rid, typ, anz_faelle, inzidenz, deltas.*
from (
         select *, lag(inzidenz, delta_days) over w_delta as inzidenz_days_ago
         from (
                  select date,
                         region,
                         rid,
                         typ,
                         sum(anz_faelle) over w_inz                                       as anz_faelle,
                         (sum(anz_faelle) over w_inz)::float / anz_einwohner * per_capita as inzidenz
                  from timeline_full
                      window w_inz as (partition by region order by date rows days-1 preceding)
              ) inz
             window w_delta as (partition by region order by date)
     ) days_ago,
     calculate_deltas(inzidenz, inzidenz_days_ago, delta_days) deltas
$$;

drop function if exists faelle(delta_days int);
create or replace function faelle(delta_days int, rids int[])
    returns table
            (
                date                          timestamp,
                region                        varchar,
                rid                           int,
                typ                           varchar,
                faelle_delta                  float,
                faelle_delta_daily            float,
                faelle_increase_percent       float,
                faelle_increase_daily_percent float
            )
    language sql
    stable
as
$$
select date, region, rid, typ, deltas.*
from (
         select *,
                avg(anz_faelle) over w_current_period  as faelle_current_period,
                avg(anz_faelle) over w_previous_period as faelle_previous_period
         from timeline_full
         where rid = any (rids)
             window w_current_period as (partition by region order by date rows delta_days - 1 preceding),
                 w_previous_period as (partition by region order by date rows between delta_days * 2 - 1 preceding and delta_days preceding)) a,
     calculate_deltas(faelle_current_period, faelle_previous_period, delta_days) deltas
$$;


-- functions to resolve JSON arrays of bezirk/bundesland to rids

drop function if exists get_rids_for_bundesland(p_bundesland varchar);
create or replace function get_rids_for_bundesland(p_bundesland varchar)
    returns int[]
    language sql
    stable
as
$$
select array_agg(bid)
from bundesland
where bundesland in (select * from json_array_elements_text(p_bundesland::json))
$$;

drop function if exists get_rids_for_bezirk(p_bezirk varchar);
create or replace function get_rids_for_bezirk(p_bezirk varchar)
    returns int[]
    language sql
    stable
as
$$
select array_agg(gkz)
from bezirk
where bezirk in (select * from json_array_elements_text(p_bezirk::json))
$$;

drop function if exists get_rids(bundesland varchar, bezirk varchar);
create or replace function get_rids(bundesland varchar, bezirk varchar)
    returns int[]
    language sql
    stable
as
$$
select (get_rids_for_bundesland(bundesland) || get_rids_for_bezirk(bezirk))
$$;

