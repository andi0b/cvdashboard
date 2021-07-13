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
    gruppe_lt_25_m_1                         int,
    gruppe_lt_25_w_1                         int,
    gruppe_lt_25_d_1                         int,
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
    gruppe_lt_25_m_2                         int,
    gruppe_lt_25_w_2                         int,
    gruppe_lt_25_d_2                         int,
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
    eingetragene_impfungen_janssen           int
);

copy import_impfung (datum, bundesland_id, bevölkerung, name, eingetragene_impfungen, eingetragene_impfungen_pro_100,
                     teilgeimpfte, teilgeimpfte_pro_100, vollimmunisierte, vollimmunisierte_pro_100, gruppe_lt_25_m_1,
                     gruppe_lt_25_w_1, gruppe_lt_25_d_1, gruppe_25_34_m_1, gruppe_25_34_w_1, gruppe_25_34_d_1,
                     gruppe_35_44_m_1, gruppe_35_44_w_1, gruppe_35_44_d_1, gruppe_45_54_m_1, gruppe_45_54_w_1,
                     gruppe_45_54_d_1, gruppe_55_64_m_1, gruppe_55_64_w_1, gruppe_55_64_d_1, gruppe_65_74_m_1,
                     gruppe_65_74_w_1, gruppe_65_74_d_1, gruppe_75_84_m_1, gruppe_75_84_w_1, gruppe_75_84_d_1,
                     gruppe_gt_84_m_1, gruppe_gt_84_w_1, gruppe_gt_84_d_1, gruppe_lt_25_m_2, gruppe_lt_25_w_2,
                     gruppe_lt_25_d_2, gruppe_25_34_m_2, gruppe_25_34_w_2, gruppe_25_34_d_2, gruppe_35_44_m_2,
                     gruppe_35_44_w_2, gruppe_35_44_d_2, gruppe_45_54_m_2, gruppe_45_54_w_2, gruppe_45_54_d_2,
                     gruppe_55_64_m_2, gruppe_55_64_w_2, gruppe_55_64_d_2, gruppe_65_74_m_2, gruppe_65_74_w_2,
                     gruppe_65_74_d_2, gruppe_75_84_m_2, gruppe_75_84_w_2, gruppe_75_84_d_2, gruppe_gt_84_m_2,
                     gruppe_gt_84_w_2, gruppe_gt_84_d_2, gruppe_nicht_zuordenbar,
                     eingetragene_impfungen_biontech_pfizer_1, eingetragene_impfungen_moderna_1,
                     eingetragene_impfungen_astra_zeneca_1, eingetragene_impfungen_biontech_pfizer_2,
                     eingetragene_impfungen_moderna_2, eingetragene_impfungen_astra_zeneca_2,
                     eingetragene_impfungen_janssen)
    from '/data/import/timeline-eimpfpass.csv'
    delimiter ';'
    csv header;

delete
from impfung
where 1 = 1;

insert into impfung (date, bid, gruppe, geschlecht, dosis, impfstoff, anzahl)
select datum                   as date,
       bundesland_id,
       'undefined'::gruppe     as gruppe,
       'undefined'::geschlecht as geschlecht,
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
           (1, 'Janssen', eingetragene_impfungen_janssen)
    ) as unpivot (dosis, impfstoff, anzahl)

union all

select datum as date, bundesland_id, gruppe::gruppe, geschlecht::geschlecht, dosis, 'undefined'::impfstoff, anzahl
from import_impfung
         cross join lateral (
    values -- 1,m
           (1, '<25', 'm', gruppe_lt_25_m_1),
           (1, '25-34', 'm', gruppe_25_34_m_1),
           (1, '35-44', 'm', gruppe_35_44_m_1),
           (1, '45-54', 'm', gruppe_45_54_m_1),
           (1, '55-64', 'm', gruppe_55_64_m_1),
           (1, '65-74', 'm', gruppe_65_74_m_1),
           (1, '75-84', 'm', gruppe_75_84_m_1),
           (1, '>84', 'm', gruppe_gt_84_m_1),

           -- 2,m
           (2, '<25', 'm', gruppe_lt_25_m_1),
           (2, '25-34', 'm', gruppe_25_34_m_1),
           (2, '35-44', 'm', gruppe_35_44_m_1),
           (2, '45-54', 'm', gruppe_45_54_m_1),
           (2, '55-64', 'm', gruppe_55_64_m_1),
           (2, '65-74', 'm', gruppe_65_74_m_1),
           (2, '75-84', 'm', gruppe_75_84_m_1),
           (2, '>84', 'm', gruppe_gt_84_m_1),

           -- 1,w
           (1, '<25', 'w', gruppe_lt_25_w_1),
           (1, '25-34', 'w', gruppe_25_34_w_1),
           (1, '35-44', 'w', gruppe_35_44_w_1),
           (1, '45-54', 'w', gruppe_45_54_w_1),
           (1, '55-64', 'w', gruppe_55_64_w_1),
           (1, '65-74', 'w', gruppe_65_74_w_1),
           (1, '75-84', 'w', gruppe_75_84_w_1),
           (1, '>84', 'w', gruppe_gt_84_w_1),

           -- 2,w
           (2, '<25', 'w', gruppe_lt_25_w_2),
           (2, '25-34', 'w', gruppe_25_34_w_2),
           (2, '35-44', 'w', gruppe_35_44_w_2),
           (2, '45-54', 'w', gruppe_45_54_w_2),
           (2, '55-64', 'w', gruppe_55_64_w_2),
           (2, '65-74', 'w', gruppe_65_74_w_2),
           (2, '75-84', 'w', gruppe_75_84_w_2),
           (2, '>84', 'w', gruppe_gt_84_w_2),

           -- 1,d
           (1, '<25', 'd', gruppe_lt_25_d_1),
           (1, '25-34', 'd', gruppe_25_34_d_1),
           (1, '35-44', 'd', gruppe_35_44_d_1),
           (1, '45-54', 'd', gruppe_45_54_d_1),
           (1, '55-64', 'd', gruppe_55_64_d_1),
           (1, '65-74', 'd', gruppe_65_74_d_1),
           (1, '75-84', 'd', gruppe_75_84_d_1),
           (1, '>84', 'd', gruppe_gt_84_d_1),

           -- 2,d
           (2, '<25', 'd', gruppe_lt_25_d_2),
           (2, '25-34', 'd', gruppe_25_34_d_2),
           (2, '35-44', 'd', gruppe_35_44_d_2),
           (2, '45-54', 'd', gruppe_45_54_d_2),
           (2, '55-64', 'd', gruppe_55_64_d_2),
           (2, '65-74', 'd', gruppe_65_74_d_2),
           (2, '75-84', 'd', gruppe_75_84_d_2),
           (2, '>84', 'd', gruppe_gt_84_d_2)
    ) as unpivot (dosis, gruppe, geschlecht, anzahl);

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

drop materialized view if exists impfraten;
drop materialized view if exists altersgruppen_by_bundesland;
drop table if exists alter_by_bundesland;
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

create materialized view altersgruppen_by_bundesland as
select bid,
       (
           case
               when alter < 12 then 'undefined'
               when alter < 25 then '<25'
               when alter < 35 then '25-34'
               when alter < 45 then '35-44'
               when alter < 55 then '45-54'
               when alter < 65 then '55-64'
               when alter < 75 then '65-74'
               when alter < 85 then '75-84'
               else '>84'
               end
           )::gruppe as gruppe,
       geschlecht,
       sum(anzahl)   as anzahl
from alter_by_bundesland
group by bid, gruppe, geschlecht
order by bid, gruppe;

create materialized view impfraten as
with total as (
    select *,
           anzahl                                     as anzahl_total,
           anzahl - coalesce((lag(anzahl) over w), 0) as anzahl_tag
    from impfung
        window w as (
            partition by (bid, gruppe, geschlecht, dosis, impfstoff)
            order by date asc )
    order by bid, date)
select t.*,
       a.anzahl                             as bevoelkerung,
       t.anzahl_total / nullif(a.anzahl, 0) as impfrate,
       t.anzahl_tag / nullif(a.anzahl, 0)   as impfrate_tag
from total t
         left join altersgruppen_by_bundesland a
                   on t.geschlecht = a.geschlecht and t.gruppe = a.gruppe and t.bid = a.bid
where t.bid = 1
  and t.gruppe = '>84'
  and t.geschlecht = 'w'
  and t.dosis = 1;

commit;