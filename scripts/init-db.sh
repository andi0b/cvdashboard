#!/bin/bash
cd /db
psql -U $PGUSER -d postgres -h db -f init.sql
