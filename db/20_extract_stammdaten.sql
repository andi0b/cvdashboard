begin;

insert into bundesland
select distinct(bid) bid, bundesland
from timeline_laender
order by bid;

insert into bezirk
select distinct(gkz) gkz, bezirk, b.bid, b.bundesland
from timeline_bezirke tl
         join bundesland b on tl.gkz / 100 = b.bid
order by gkz;

commit;