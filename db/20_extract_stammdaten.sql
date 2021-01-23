begin;

insert into bundesland
select *
from (
         select distinct (bid) bid, bundesland
         from timeline_laender
    ) x
order by case
             when bid = 10
                 then 0
             else 1
             end,
         bundesland;


insert into bezirk
select distinct(gkz) gkz, bezirk, b.bid, b.bundesland
from timeline_bezirke tl
         join bundesland b on tl.gkz / 100 = b.bid
order by gkz;

commit;