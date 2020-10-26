#!/bin/bash
DIR=$(dirname "$0")/../data
WGET="wget --cipher DEFAULT:!DH -P $DIR"

mkdir -p $DIR

rm $DIR/*csv

$WGET https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline_GKZ.csv
$WGET https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline.csv

sed -i 's/,/./g' $DIR/*csv