# cvdashboard: COVID-19 Dashboard for Austria

Grafana Dashboard with Postgres backend, based on data provided by [AGES/Open Data Austra](https://www.data.gv.at/covid-19/)

See it live: [covid.greenwasp.at](https://covid.greenwasp.at)

![screenshot](docs/screenshot1.png)

# How to run it

You need docker, docker-compose, sed and curl. Tested on Linux only.

start the services:
```sh
docker-compose up -d
```
wait a bit until the data is loaded an imported

Open grafana: http://localhost:3000

Default grafana credentials are user/pass

# Deploy it

Copy `.env.sample` to `.env` and set a password for the Grafana admin user.

# Develop

- Copy `docker-compose.override.yml.development` to `docker-compose.override.yml` to access the Postgres database on `localhost`
- Modify scripts inside `db` folder to do changes on the database
- run `sh scripts/download-data` to download/update the source data
- run `sh scripts/init-db-docker.sh` to rebuild the database
- Modify/add Grafana dashboards inside `grafana-provisioning/dashboard-content`
