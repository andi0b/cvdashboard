#!/bin/bash
docker-compose stop grafana
docker-compose rm -vf grafana
docker-compose up -d grafana
