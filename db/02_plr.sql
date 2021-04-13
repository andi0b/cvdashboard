do
$$
    begin
        if not EXISTS(select * from pg_language where lanname = 'plr') then

            -- initialize PLR
            create function plr_call_handler()
                returns language_handler
            as
            '$libdir/plr' language c;

            create language plr handler plr_call_handler;

        end if;
    end
$$;


drop function if exists predict(input_dates timestamp[], input_values float[], inputs_frequency float,
    predict_h integer, remove_values_tail integer);

drop function if exists faelle_prediction(region_filter varchar, predict_h integer, remove_values_tail integer);

drop type if exists predict_result;

create type predict_result as
(
    date     timestamp,
    value    float,
    forecast float,
    lo80     float,
    hi80     float,
    lo95     float,
    hi95     float
);

create or replace function predict(input_dates timestamp[], input_values float[], inputs_frequency float default 7,
                                   predict_h integer default 14,
                                   remove_values_tail integer default 1)
    returns setof predict_result
    language plr stable
as
$$
library('forecast')

# functions
date_series <- function(startDate, days) startDate + (0:(days - 1) * 3600 * 24)
my_forecast <- function(ts, h) hw(ts, h = h, damped = TRUE, lambda='auto')

#### prepare data
# create dataframe from input arrays
inputs <- data.frame(date = as.POSIXct(input_dates), value = input_values)

# subset for prediction; and create ts with defined frequency
inputs.subset <- head(inputs, n = nrow(inputs) - remove_values_tail)
inputs.subset.lastdate <- tail(inputs.subset, n = 1)$date
inputs.subset.ts <- ts(inputs.subset$value, frequency = inputs_frequency)

# do forecast
forecast.result <- my_forecast(inputs.subset.ts, predict_h)
forecast.timestamps <- date_series(inputs.subset.lastdate + 3600 * 24, predict_h)

forecast.dataframe <- data.frame(forecast.result)
forecast.dataframe$date <- forecast.timestamps

# join forecast together with inputs on common column date
joined <- merge(inputs, forecast.dataframe, on = "date", all = TRUE)

joined$date <- as.character(joined$date)

return(joined)
$$;

create or replace function faelle_prediction(region_filter varchar default 'Österreich', predict_h integer default 14,
                                             remove_values_tail integer default 1)
    returns setof predict_result
    language sql stable
as
$$
with source as (
    select array_agg(date) as dates, array_agg(anz_faelle::float) as faelle
    from timeline_full
    where region = region_filter
)
select prediction.*
from source,
     predict(source.dates, source.faelle,
             predict_h := predict_h, remove_values_tail := remove_values_tail) prediction
$$;
