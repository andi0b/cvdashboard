#!/bin/bash
DIR=$(dirname "$0")/../data/import


mkdir -p $DIR

rm $DIR/*csv

# the ages.at server uses really old TLS settings, set some custom openssl settings, so it can be downloaded
export OPENSSL_CONF=$(dirname "$0")/openssl.cnf

curl -o $DIR/CovidFaelle_Timeline_GKZ.csv https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline_GKZ.csv
curl -o $DIR/CovidFaelle_Timeline.csv https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline.csv
curl -o $DIR/CovidFallzahlen.csv https://covid19-dashboard.ages.at/data/CovidFallzahlen.csv
curl -o $DIR/timeline-eimpfpass.csv https://info.gesundheitsministerium.gv.at/data/timeline-eimpfpass.csv

# only download demographic data once, it won't change
if ! [ -f $DIR/OGD_bevstandjbab2002_BevStand_2021.csv ]; then
  curl -o $DIR/OGD_bevstandjbab2002_BevStand_2021.csv https://data.statistik.gv.at/data/OGD_bevstandjbab2002_BevStand_2021.csv
fi

sed -i 's/,/./g' $DIR/*csv