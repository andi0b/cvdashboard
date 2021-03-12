begin;

drop procedure if exists insert_bezirk_summary(int, varchar, int[]);
create procedure insert_bezirk_summary(newGkz int, newBezirk varchar, mergeGkzs int[])
    language sql
as
$$
insert into timeline_bezirke (date, bezirk, gkz, anz_einwohner, anz_faelle, anz_faelle_sum, anz_faelle_7d,
                              inz_faelle_7d, anz_tot_taeglich, anz_tot_sum, anz_geheilte_taeglich, anz_geheilte_sum)
select date,
       newBezirk                  as bezirk,
       newGkz                     as gkz,
       sum(anz_einwohner)         as anz_einwohner,
       sum(anz_faelle)            as anz_faelle,
       sum(anz_faelle_sum)        as anz_faelle_sum,
       sum(anz_faelle_7d)         as anz_faelle_7d,
       -1                         as inz_faelle_7d,
       sum(anz_tot_taeglich)      as anz_tot_taeglich,
       sum(anz_tot_sum)           as anz_tot_sum,
       sum(anz_geheilte_taeglich) as anz_geheilte_taeglich,
       sum(anz_geheilte_sum)      as anz_geheilte_sum

from timeline_bezirke
where gkz = ANY(mergeGkzs)
group by date;
$$;

call insert_bezirk_summary(199, 'Eisenstadt (Stadt und Umgebung, Rust)', ARRAY [101,102,103]);

call insert_bezirk_summary(299, 'Klagenfurt (Stadt und Land)', ARRAY [201, 204]);
call insert_bezirk_summary(298, 'Villach (Stadt und Land)', ARRAY [202,207]);

call insert_bezirk_summary(399, 'Krems (Stadt und Land)', ARRAY [301, 313]);
call insert_bezirk_summary(398, 'Sankt Pölten (Stadt und Land)', ARRAY [302, 319]);
call insert_bezirk_summary(397, 'Amstetten mit Waidhofen/Ybbs', ARRAY [305, 303]);
call insert_bezirk_summary(396, 'Wiener Neustadt (Stadt und Land)', ARRAY [304,323]);

call insert_bezirk_summary(499, 'Linz (Stadt und Land, Urfahr-Umgebung)', ARRAY [401, 410, 416]);
call insert_bezirk_summary(498, 'Steyr (Stadt und Land)', ARRAY [402, 415]);
call insert_bezirk_summary(497, 'Wels (Stadt und Land)', ARRAY [403, 418]);

call insert_bezirk_summary(599, 'Salzburg (Stadt und Umgebung)', ARRAY [501, 503]);

call insert_bezirk_summary(699, 'Graz (Stadt und Umgebung)', ARRAY [601, 606]);

call insert_bezirk_summary(799, 'Innsbruck (Stadt und Land)', ARRAY [701, 703]);

call insert_bezirk_summary(999, 'Wien mit Umland (W, MD, BL, GF, KO, TU, PL, MI, BN)', ARRAY [900, 317, 307, 308, 312, 321, 319, 316, 306]);

refresh materialized view timeline_full;

commit;