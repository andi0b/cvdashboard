#!/bin/sh
exit $(psql -qtAX -U postgres -c "SELECT case when count(*) > 0 THEN 0 ELSE 1 END FROM faelle_prediction_cache")