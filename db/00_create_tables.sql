begin;

drop view if exists timeline_full;
drop table if exists timeline_bezirke;
drop table if exists timeline_laender;


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


create view timeline_full as
select date,
       bezirk as region,
       gkz    as rid,
       'b'        as typ,
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
order by date asc, rid asc;

commit;