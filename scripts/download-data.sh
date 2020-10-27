#!/bin/bash
DIR=$(dirname "$0")/../data/import


mkdir -p $DIR

rm $DIR/*csv

# the ages.at server uses really old TLS settings, set some custom openssl settings, so it can be downloaded
export OPENSSL_CONF=$(dirname "$0")/openssl.cnf

curl -o $DIR/CovidFaelle_Timeline_GKZ.csv https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline_GKZ.csv
curl -o $DIR/CovidFaelle_Timeline.csv https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline.csv

sed -i 's/,/./g' $DIR/*csv