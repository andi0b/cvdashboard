#!/bin/bash
cd /db
psql -U $POSTGRES_USER -d postgres -h $POSTGRES_HOST -f init.sql
