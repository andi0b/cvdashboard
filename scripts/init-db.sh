#!/bin/bash
docker exec -it cvdashboard_db_1 bash -c "cd /db && psql -U postgres -d postgres -f init.sql"
