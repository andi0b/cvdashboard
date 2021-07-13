begin;

drop materialized view if exists timeline_full;
drop materialized view if exists tests_weekly;
drop materialized view if exists tests;
drop materialized view if exists  faelle_prediction_cache;
drop table if exists timeline_bezirke;
drop table if exists timeline_laender;
drop table if exists fallzahlen;


create table timeline_bezirke
(
    id                    serial    not null,
    date                  timestamp not null,
    bezirk                varchar   not null,
    gkz                   int       not null,
    anz_einwohner         int       not null,
    anz_faelle            int       not null,
    anz_faelle_sum        int       not null,
    anz_faelle_7d         int       not null,
    inz_faelle_7d         float     not null,
    anz_tot_taeglich      int       not null,
    anz_tot_sum           int       not null,
    anz_geheilte_taeglich int       not null,
    anz_geheilte_sum      int       not null,
    primary key (id)
);
create index idx_timeline_bezirke_date on timeline_bezirke (date asc);
create index idx_timeline_bezirke_gkz on timeline_bezirke (gkz asc);

create table timeline_laender
(
    id                    serial    not null,
    date                  timestamp not null,
    bundesland            varchar   not null,
    bid                   int       not null,
    anz_einwohner         int       not null,
    anz_faelle            int       not null,
    anz_faelle_sum        int       not null,
    anz_faelle_7d         int       not null,
    inz_faelle_7d         float     not null,
    anz_tot_taeglich      int       not null,
    anz_tot_sum           int       not null,
    anz_geheilte_taeglich int       not null,
    anz_geheilte_sum      int       not null,
    primary key (id)
);
create index idx_timeline_laender_date on timeline_laender (date asc);
create index idx_timeline_laender_gkz on timeline_laender (bid asc);


create table fallzahlen
(
    id           serial    not null,
    date         timestamp not null,
    bundesland   varchar   not null,
    bid          int       not null,
    fz_hosp      int       not null,
    fz_icu       int       not null,
    fz_hosp_free int       not null,
    fz_icu_free  int       not null,
    test_gesamt  int       not null,
    primary key (id)
);



create materialized view timeline_full as
select date,
       bezirk as region,
       gkz    as rid,
       'b'    as typ,
       anz_einwohner,
       anz_faelle,
       anz_faelle_sum,
       anz_faelle_7d,
       inz_faelle_7d,
       anz_tot_taeglich,
       anz_tot_sum,
       anz_geheilte_taeglich,
       anz_geheilte_sum
from timeline_bezirke
union
select date,
       bundesland as region,
       bid        as rid,
       'l'        as typ,
       anz_einwohner,
       anz_faelle,
       anz_faelle_sum,
       anz_faelle_7d,
       inz_faelle_7d,
       anz_tot_taeglich,
       anz_tot_sum,
       anz_geheilte_taeglich,
       anz_geheilte_sum
from timeline_laender
order by rid asc, date asc;

create index IDX_timeline_full_rid on timeline_full (rid asc);
create index IDX_timeline_full_date on timeline_full (date desc);


create materialized view tests as
select tl.date,
       tl.bundesland,
       tl.bid,
       anz_einwohner,
       anz_faelle,
       anz_faelle_sum,
       anz_faelle_7d,
       inz_faelle_7d,
       anz_tot_taeglich,
       anz_tot_sum,
       anz_geheilte_taeglich,
       anz_geheilte_sum,
       f.fz_hosp,
       f.fz_hosp_free,
       f.fz_icu,
       f.fz_icu_free,
       f.test_gesamt                                            as anz_test_sum,
       f.test_gesamt - lag(f.test_gesamt) over w_current_period as anz_test_taeglich
from timeline_laender tl
         join fallzahlen f on tl.bid = f.bid and tl.date = f.date
    window w_current_period as (partition by f.bid order by f.date rows 1 preceding)
order by date desc;

create materialized view tests_weekly as
select date_trunc('week', date) + interval '7 days' - interval '1 minute' as week,
       bid,
       max(bundesland)                                                    as bundesland,
       max(anz_einwohner)                                                 as anz_einwohner,
       sum(anz_faelle)                                                    as anz_faelle_7d,
       sum(anz_tot_taeglich)                                              as anz_tot_7d,
       sum(anz_geheilte_taeglich)                                         as anz_geheilte_7d,
       ((sum(anz_faelle) * 100000) / max(anz_einwohner))                  as inz_faelle_7d,
       avg(fz_hosp)                                                       as avg_fz_hosp_7d,
       avg(fz_hosp_free)                                                  as avg_fz_hosp_free_7d,
       avg(fz_icu)                                                        as avg_fz_icu_7d,
       avg(fz_icu_free)                                                   as avg_fz_icu_free_7d,
       sum(anz_test_taeglich)                                             as anz_test_7d,
       case
           when sum(anz_test_taeglich) > 0 then
               sum(anz_faelle)::float / sum(anz_test_taeglich)
           else 0 end                                                     as test_positivrate
from tests
group by week, bid
order by week desc, bid;


drop table if exists bundesland;
create table bundesland
(
    bid        int     not null,
    bundesland varchar not null,
    primary key (bid)
);

drop table if exists bezirk;
create table bezirk
(
    gkz        int     not null,
    bezirk     varchar not null,
    bid        int     not null,
    bundesland varchar not null,
    primary key (gkz)
);



drop table if exists impfung cascade ;

drop type if exists geschlecht cascade ;
create type geschlecht as enum ('undefined', 'm', 'w', 'd', 'Alle Geschlechter');

drop type if exists gruppe cascade ;
create type gruppe as enum ('undefined', '12-24', '25-34', '35-44', '45-54', '55-64', '65-74', '75-84', '>84', 'Impfbare Bevölkerung', 'Alle Altersgruppen');

drop type if exists impfstoff cascade ;
create type impfstoff as enum ('undefined', 'BioNTech Pfizer', 'AstraZeneca', 'Moderna', 'Janssen', 'Alle Impfstoffe');

create table impfung
(
    id         serial     not null,
    date       timestamp  not null,
    bid        int        not null,
    gruppe     gruppe     not null,
    geschlecht geschlecht not null,
    dosis      int        not null,
    impfstoff   impfstoff  not null,
    anzahl     int        not null
);

create index IDX_impfung_date_bid on impfung(bid asc, date desc);

commit;
