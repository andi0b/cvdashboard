begin;

set local DATESTYLE to German;

copy timeline_bezirke (date, bezirk, gkz, anz_einwohner, anz_faelle, anz_faelle_sum, anz_faelle_7d,
                       inz_faelle_7d, anz_tot_taeglich, anz_tot_sum, anz_geheilte_taeglich,
                       anz_geheilte_sum)
    from '/data/import/CovidFaelle_Timeline_GKZ.csv'
    delimiter ';'
    csv header;

update timeline_bezirke
set bezirk = 'Wien (Bezirk)'
where (bezirk = 'Wien');

copy timeline_laender (date, bundesland, bid, anz_einwohner, anz_faelle, anz_faelle_sum, anz_faelle_7d,
                       inz_faelle_7d, anz_tot_taeglich, anz_tot_sum, anz_geheilte_taeglich,
                       anz_geheilte_sum)
    from '/data/import/CovidFaelle_Timeline.csv'
    delimiter ';'
    csv header;


drop table if exists import_fallzahlen;
create temporary table import_fallzahlen
(
    meldedat      timestamp,
    test_gesamt   int,
    melde_datum   timestamp,
    fz_hosp       int,
    fz_icu        int,
    fz_hosp_free  int,
    fz_icu_free   int,
    bundesland_id int,
    bundesland    varchar
);

copy import_fallzahlen (meldedat, test_gesamt, melde_datum, fz_hosp, fz_icu, fz_hosp_free, fz_icu_free, bundesland_id,
                        bundesland)
    from '/data/import/CovidFallzahlen.csv'
    delimiter ';'
    csv header;

insert into fallzahlen (date, bundesland, bid, fz_hosp, fz_icu, fz_hosp_free, fz_icu_free)
select meldedat, bundesland, bundesland_id, fz_hosp, fz_icu, fz_hosp_free, fz_icu_free
from import_fallzahlen;

commit;