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

commit;