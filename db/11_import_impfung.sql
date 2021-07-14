rollback;
begin;

drop table if exists import_impfung;
create temporary table import_impfung
(
    datum                                    date,
    bundesland_id                            int,
    bevölkerung                              int,
    name                                     varchar,
    eingetragene_impfungen                   int,
    eingetragene_impfungen_pro_100           float,
    teilgeimpfte                             int,
    teilgeimpfte_pro_100                     float,
    vollimmunisierte                         int,
    vollimmunisierte_pro_100                 float,
    gruppe_lt_15_m_1                         int,
    gruppe_lt_15_w_1                         int,
    gruppe_lt_15_d_1                         int,
    gruppe_15_24_m_1                         int,
    gruppe_15_24_w_1                         int,
    gruppe_15_24_d_1                         int,
    gruppe_25_34_m_1                         int,
    gruppe_25_34_w_1                         int,
    gruppe_25_34_d_1                         int,
    gruppe_35_44_m_1                         int,
    gruppe_35_44_w_1                         int,
    gruppe_35_44_d_1                         int,
    gruppe_45_54_m_1                         int,
    gruppe_45_54_w_1                         int,
    gruppe_45_54_d_1                         int,
    gruppe_55_64_m_1                         int,
    gruppe_55_64_w_1                         int,
    gruppe_55_64_d_1                         int,
    gruppe_65_74_m_1                         int,
    gruppe_65_74_w_1                         int,
    gruppe_65_74_d_1                         int,
    gruppe_75_84_m_1                         int,
    gruppe_75_84_w_1                         int,
    gruppe_75_84_d_1                         int,
    gruppe_gt_84_m_1                         int,
    gruppe_gt_84_w_1                         int,
    gruppe_gt_84_d_1                         int,
    gruppe_lt_15_m_2                         int,
    gruppe_lt_15_w_2                         int,
    gruppe_lt_15_d_2                         int,
    gruppe_15_24_m_2                         int,
    gruppe_15_24_w_2                         int,
    gruppe_15_24_d_2                         int,
    gruppe_25_34_m_2                         int,
    gruppe_25_34_w_2                         int,
    gruppe_25_34_d_2                         int,
    gruppe_35_44_m_2                         int,
    gruppe_35_44_w_2                         int,
    gruppe_35_44_d_2                         int,
    gruppe_45_54_m_2                         int,
    gruppe_45_54_w_2                         int,
    gruppe_45_54_d_2                         int,
    gruppe_55_64_m_2                         int,
    gruppe_55_64_w_2                         int,
    gruppe_55_64_d_2                         int,
    gruppe_65_74_m_2                         int,
    gruppe_65_74_w_2                         int,
    gruppe_65_74_d_2                         int,
    gruppe_75_84_m_2                         int,
    gruppe_75_84_w_2                         int,
    gruppe_75_84_d_2                         int,
    gruppe_gt_84_m_2                         int,
    gruppe_gt_84_w_2                         int,
    gruppe_gt_84_d_2                         int,
    gruppe_nicht_zuordenbar                  int,
    eingetragene_impfungen_biontech_pfizer_1 int,
    eingetragene_impfungen_moderna_1         int,
    eingetragene_impfungen_astra_zeneca_1    int,
    eingetragene_impfungen_biontech_pfizer_2 int,
    eingetragene_impfungen_moderna_2         int,
    eingetragene_impfungen_astra_zeneca_2    int,
    eingetragene_impfungen_janssen           int,
    ImpfstoffNichtZugeordnet_1               int,
    ImpfstoffNichtZugeordnet_2               int
);

copy import_impfung
    (datum, bundesland_id, bevölkerung, name, eingetragene_impfungen, eingetragene_impfungen_pro_100, teilgeimpfte,
     teilgeimpfte_pro_100, vollimmunisierte, vollimmunisierte_pro_100, gruppe_lt_15_m_1, gruppe_lt_15_w_1,
     gruppe_lt_15_d_1, gruppe_15_24_m_1, gruppe_15_24_w_1, gruppe_15_24_d_1, gruppe_25_34_m_1, gruppe_25_34_w_1,
     gruppe_25_34_d_1, gruppe_35_44_m_1, gruppe_35_44_w_1, gruppe_35_44_d_1, gruppe_45_54_m_1, gruppe_45_54_w_1,
     gruppe_45_54_d_1, gruppe_55_64_m_1, gruppe_55_64_w_1, gruppe_55_64_d_1, gruppe_65_74_m_1, gruppe_65_74_w_1,
     gruppe_65_74_d_1, gruppe_75_84_m_1, gruppe_75_84_w_1, gruppe_75_84_d_1, gruppe_gt_84_m_1, gruppe_gt_84_w_1,
     gruppe_gt_84_d_1, gruppe_lt_15_m_2, gruppe_lt_15_w_2, gruppe_lt_15_d_2, gruppe_15_24_m_2, gruppe_15_24_w_2,
     gruppe_15_24_d_2, gruppe_25_34_m_2, gruppe_25_34_w_2, gruppe_25_34_d_2, gruppe_35_44_m_2, gruppe_35_44_w_2,
     gruppe_35_44_d_2, gruppe_45_54_m_2, gruppe_45_54_w_2, gruppe_45_54_d_2, gruppe_55_64_m_2, gruppe_55_64_w_2,
     gruppe_55_64_d_2, gruppe_65_74_m_2, gruppe_65_74_w_2, gruppe_65_74_d_2, gruppe_75_84_m_2, gruppe_75_84_w_2,
     gruppe_75_84_d_2, gruppe_gt_84_m_2, gruppe_gt_84_w_2, gruppe_gt_84_d_2, gruppe_nicht_zuordenbar,
     eingetragene_impfungen_biontech_pfizer_1, eingetragene_impfungen_moderna_1, eingetragene_impfungen_astra_zeneca_1,
     eingetragene_impfungen_biontech_pfizer_2, eingetragene_impfungen_moderna_2, eingetragene_impfungen_astra_zeneca_2,
     eingetragene_impfungen_janssen, ImpfstoffNichtZugeordnet_1, ImpfstoffNichtZugeordnet_2)
    from '/data/import/timeline-eimpfpass.csv'
    delimiter ';'
    csv header;

delete
from impfung
where 1 = 1;

insert into impfung (date, bid, gruppe, geschlecht, dosis, impfstoff, anzahl)
select datum                           as date,
       bundesland_id,
       'Impfbare Bevölkerung'::gruppe  as gruppe,
       'Alle Geschlechter'::geschlecht as geschlecht,
       dosis,
       impfstoff::impfstoff,
       anzahl
from import_impfung
         cross join lateral (
    values (1, 'BioNTech Pfizer', eingetragene_impfungen_biontech_pfizer_1),
           (2, 'BioNTech Pfizer', eingetragene_impfungen_biontech_pfizer_2),
           (1, 'AstraZeneca', eingetragene_impfungen_astra_zeneca_1),
           (2, 'AstraZeneca', eingetragene_impfungen_astra_zeneca_2),
           (1, 'Moderna', eingetragene_impfungen_moderna_1),
           (2, 'Moderna', eingetragene_impfungen_moderna_2),
           (1, 'Janssen', eingetragene_impfungen_janssen),
           (1, 'Alle Impfstoffe', eingetragene_impfungen_biontech_pfizer_1
               + eingetragene_impfungen_astra_zeneca_1
               + eingetragene_impfungen_moderna_1
               + eingetragene_impfungen_janssen),
           (2, 'Alle Impfstoffe', eingetragene_impfungen_biontech_pfizer_2
               + eingetragene_impfungen_astra_zeneca_2
               + eingetragene_impfungen_moderna_2)
    ) as unpivot (dosis, impfstoff, anzahl)

union all

select datum as date,
       bundesland_id,
       gruppe::gruppe,
       geschlecht::geschlecht,
       dosis,
       'Alle Impfstoffe'::impfstoff,
       anzahl
from import_impfung
         cross join lateral (
    values -- 1,m
           (1, '12-14', 'm', gruppe_lt_15_m_1),
           (1, '15-24', 'm', gruppe_15_24_m_1),
           (1, '25-34', 'm', gruppe_25_34_m_1),
           (1, '35-44', 'm', gruppe_35_44_m_1),
           (1, '45-54', 'm', gruppe_45_54_m_1),
           (1, '55-64', 'm', gruppe_55_64_m_1),
           (1, '65-74', 'm', gruppe_65_74_m_1),
           (1, '75-84', 'm', gruppe_75_84_m_1),
           (1, '>84', 'm', gruppe_gt_84_m_1),

           -- 2,m
           (2, '12-14', 'm', gruppe_lt_15_m_2),
           (2, '15-24', 'm', gruppe_15_24_m_2),
           (2, '25-34', 'm', gruppe_25_34_m_2),
           (2, '35-44', 'm', gruppe_35_44_m_2),
           (2, '45-54', 'm', gruppe_45_54_m_2),
           (2, '55-64', 'm', gruppe_55_64_m_2),
           (2, '65-74', 'm', gruppe_65_74_m_2),
           (2, '75-84', 'm', gruppe_75_84_m_2),
           (2, '>84', 'm', gruppe_gt_84_m_2),

           -- 1,w
           (1, '12-14', 'w', gruppe_lt_15_w_1),
           (1, '15-24', 'w', gruppe_15_24_w_1),
           (1, '25-34', 'w', gruppe_25_34_w_1),
           (1, '35-44', 'w', gruppe_35_44_w_1),
           (1, '45-54', 'w', gruppe_45_54_w_1),
           (1, '55-64', 'w', gruppe_55_64_w_1),
           (1, '65-74', 'w', gruppe_65_74_w_1),
           (1, '75-84', 'w', gruppe_75_84_w_1),
           (1, '>84', 'w', gruppe_gt_84_w_1),

           -- 2,w
           (2, '12-14', 'm', gruppe_lt_15_w_2),
           (2, '15-24', 'w', gruppe_15_24_w_2),
           (2, '25-34', 'w', gruppe_25_34_w_2),
           (2, '35-44', 'w', gruppe_35_44_w_2),
           (2, '45-54', 'w', gruppe_45_54_w_2),
           (2, '55-64', 'w', gruppe_55_64_w_2),
           (2, '65-74', 'w', gruppe_65_74_w_2),
           (2, '75-84', 'w', gruppe_75_84_w_2),
           (2, '>84', 'w', gruppe_gt_84_w_2),

           -- 1,d
           (1, '12-14', 'd', gruppe_lt_15_d_1),
           (1, '15-24', 'd', gruppe_15_24_d_1),
           (1, '25-34', 'd', gruppe_25_34_d_1),
           (1, '35-44', 'd', gruppe_35_44_d_1),
           (1, '45-54', 'd', gruppe_45_54_d_1),
           (1, '55-64', 'd', gruppe_55_64_d_1),
           (1, '65-74', 'd', gruppe_65_74_d_1),
           (1, '75-84', 'd', gruppe_75_84_d_1),
           (1, '>84', 'd', gruppe_gt_84_d_1),

           -- 2,d
           (1, '12-14', 'd', gruppe_lt_15_d_1),
           (1, '15-24', 'd', gruppe_15_24_d_1),
           (2, '25-34', 'd', gruppe_25_34_d_2),
           (2, '35-44', 'd', gruppe_35_44_d_2),
           (2, '45-54', 'd', gruppe_45_54_d_2),
           (2, '55-64', 'd', gruppe_55_64_d_2),
           (2, '65-74', 'd', gruppe_65_74_d_2),
           (2, '75-84', 'd', gruppe_75_84_d_2),
           (2, '>84', 'd', gruppe_gt_84_d_2)
    ) as unpivot (dosis, gruppe, geschlecht, anzahl);


insert into impfung (date, bid, gruppe, geschlecht, dosis, impfstoff, anzahl)

-- altersgruppen für 'Alle Geschlechter' berechnen
    (select date, bid, gruppe, 'Alle Geschlechter'::geschlecht, dosis, impfstoff, sum(anzahl)
     from impfung
     where geschlecht <> 'Alle Geschlechter'
     group by date, bid, gruppe, dosis, impfstoff)

union
-- Werte für alle Geschlechter für Altersgruppen "Impfbare Bevölkerung" und "Alle Altersgruppen" berechnen
(select date, bid, 'Impfbare Bevölkerung'::gruppe, geschlecht, dosis, impfstoff, sum(anzahl)
 from impfung
 where gruppe <> 'Impfbare Bevölkerung'
 group by date, bid, geschlecht, dosis, impfstoff);

cluster impfung using idx_impfung_date_bid;


--- importiere demographische daten
drop table if exists import_bevoelkerung;
create temporary table import_bevoelkerung
(
    dataset_id char(8)  not null,
    geschlecht char(5)  not null,
    gemeinde   char(14) not null,
    alter      varchar  not null,
    anzahl     int      not null
);

copy import_bevoelkerung (dataset_id, geschlecht, gemeinde, alter, anzahl)
    from '/data/import/OGD_bevstandjbab2002_BevStand_2021.csv'
    delimiter ';'
    csv header;

drop table if exists alter_by_bundesland cascade;
select substring(gemeinde from 10 for 1)::int as bid,
       case
           when (alter = 'GALT5J100-21') then 100
           else substring(alter from 11)::int - 1
           end
                                              as alter,
       (case
            when (geschlecht = 'C11-1') then 'm'
            when (geschlecht = 'C11-2') then 'w'
            else 'undefined'
           end)::geschlecht                   as geschlecht,
       sum(anzahl)                            as anzahl
into alter_by_bundesland
from import_bevoelkerung
group by alter, bid, import_bevoelkerung.geschlecht
order by bid, alter;

create unique index on alter_by_bundesland (bid, alter, geschlecht);

-- aggregiere daten für österreich (bid = 10)
insert into alter_by_bundesland (bid, geschlecht, alter, anzahl)
select 10, geschlecht, alter, sum(anzahl)
from alter_by_bundesland
group by alter, geschlecht;

drop materialized view if exists altersgruppen_by_bundesland cascade;
create materialized view altersgruppen_by_bundesland as
with parameters as (
    select *
    from (values ('12-14', 12, 14),
                 ('15-24', 15, 24),
                 ('25-34', 25, 34),
                 ('35-44', 35, 44),
                 ('45-54', 45, 54),
                 ('55-64', 55, 64),
                 ('65-74', 65, 74),
                 ('75-84', 75, 84),
                 ('>84', 85, 100),
                 ('Impfbare Bevölkerung', 12, 100),
                 ('Alle Altersgruppen', 0, 100)
         ) as gruppe(gruppe, lowerInclusive, upperInclusive),
         (values ('m'), ('w'), ('Alle Geschlechter')) as geschlecht_tbl(geschlecht),
         generate_series(1, 10) as bid
)
select p.bid, p.gruppe::gruppe, p.geschlecht::geschlecht, sum(anzahl) as anzahl
from alter_by_bundesland a,
     parameters p
where a.bid = p.bid
  and (a.alter >= p.lowerInclusive and a.alter <= p.upperInclusive)
  and (p.geschlecht = 'Alle Geschlechter' or a.geschlecht = p.geschlecht::geschlecht)
group by p.gruppe, p.bid, p.geschlecht
order by bid, geschlecht, gruppe;



drop materialized view if exists impfraten;
create materialized view impfraten as
with total as (
    select *,
           anzahl                                        as anzahl_total,
           anzahl - coalesce((lag(anzahl) over w), 0)    as anzahl_tag,
           anzahl - coalesce((lag(anzahl, 7) over w), 0) as anzahl_7d
    from impfung
        window w as (
            partition by (bid, gruppe, geschlecht, dosis, impfstoff)
            order by date asc)
    order by bid, date)
select t.*,
       a.anzahl                             as bevoelkerung,
       t.anzahl_total / nullif(a.anzahl, 0) as impfrate,
       t.anzahl_tag / nullif(a.anzahl, 0)   as impfrate_tag,
       t.anzahl_7d / nullif(a.anzahl, 0)    as impfrate_7d
from total t
         left join altersgruppen_by_bundesland a
                   on t.geschlecht = a.geschlecht and t.gruppe = a.gruppe and t.bid = a.bid;


create type t_gruppe_bundeslaender as
(
    "Gruppe"           gruppe,
    "Österreich"       float,
    "Burgenland"       float,
    "Kärnten"          float,
    "Niederösterreich" float,
    "Oberösterreich"   float,
    "Salzburg"         float,
    "Steiermark"       float,
    "Tirol"            float,
    "Vorarlberg"       float,
    "Wien"             float
);


create or replace function crosstab_gruppe_bundeslaender(text, text)
    returns setof t_gruppe_bundeslaender
as
'$libdir/tablefunc',
'crosstab_hash' language C stable
                      strict;



drop function if exists impfraten_over_bundesland(int, text, geschlecht, impfstoff);
create or replace function impfraten_over_bundesland(dosis int, metric text default 'impfrate',
                                                     geschlecht geschlecht default 'Alle Geschlechter',
                                                     impfstoff impfstoff default 'Alle Impfstoffe')
    returns setof t_gruppe_bundeslaender
    language sql
    stable
as
$$
select *
from crosstab_gruppe_bundeslaender('
SELECT distinct on (impfraten.bid, gruppe)
   gruppe, bl.bundesland, ' || metric || '
FROM impfraten
left join bundesland bl on bl.bid = impfraten.bid
WHERE (impfraten.bid>0)
  and geschlecht=''' || geschlecht::text || '''
  and impfstoff=''' || impfstoff::text || '''
  and dosis=' || dosis::text || '
ORDER BY gruppe, impfraten.bid, gruppe, date desc',
                                   'select bundesland from bundesland')
$$;

commit;
