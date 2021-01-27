#!/bin/sh

echo "initial db import, waiting 30s until DB is up"
echo

sleep 30

sh /scripts/download-data.sh && sh /scripts/init-db.sh

echo
echo "db import finished, starting cron"
echo

crond -f -l 2