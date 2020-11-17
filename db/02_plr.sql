-- create function plr_call_handler()
--    returns language_handler
-- as '$libdir/plr' language c;

-- create language plr handler plr_call_handler;

drop function if exists predict(vals float[], vals_frequency float, predict_h integer);
drop function if exists faelle_prediction(region_filter varchar);
drop type if exists predict_result;


create type predict_result as
(
    forecast float,
    lo80     float,
    hi80     float,
    lo95     float,
    hi95     float
);


create or replace function predict(vals integer[], vals_frequency float default 7, predict_h integer default 14)
    returns setof predict_result
    language plr
as
$$
library('forecast')

vals_ts <- ts(vals, frequency = vals_frequency)

prediction <- hw(vals_ts, h = predict_h, damped = TRUE)

return(data.frame(prediction))
$$;


create or replace function faelle_prediction(region_filter varchar default 'Österreich')
    returns table
            (
                date       timestamp,
                anz_faelle integer,
                forecast   float,
                hi80       float,
                hi95       float,
                lo80       float,
                lo95       float
            )
    language sql
as
$$
select *
from (
         select COALESCE(y.date, tml.date) as date, anz_faelle, y.forecast, y.hi80, y.hi95, y.lo80, y.lo95
         from (select date, anz_faelle from timeline_full where region = region_filter) tml
                  full outer join (
             select dates.date, prediction.*
             from (
                      select row_number() over () as rownum, *
                      from predict((select array_agg(anz_faelle) from timeline_full where region = region_filter))) prediction

                      inner join (
                 select row_number() over () as rownum, date
                 from (
                          select generate_series(m.max_date + '1 day'::interval,
                                                 m.max_date + '15 days'::interval,
                                                 '1 day'::interval) as date
                          from (select max(date) as max_date from timeline_laender) m) gseries) dates

                                 on dates.rownum = prediction.rownum) y
                                  on tml.date = y.date) z
order by z.date
$$;
