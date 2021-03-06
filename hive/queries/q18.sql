!echo ============================== Q18 START ====================================;
drop view q18_tmp_cached;
drop table q18_large_volume_customer_cached;

create view q18_tmp_cached as
select
  l_orderkey, sum(l_quantity) as t_sum_quantity
from
  lineitem
where l_orderkey is not null
group by l_orderkey;

EXPLAIN
select
  c_name,c_custkey,o_orderkey,o_orderdate,o_totalprice,sum(l_quantity)
from
  customer c join orders o
  on
    c.c_custkey = o.o_custkey
  join q18_tmp_cached t
  on
    o.o_orderkey = t.l_orderkey and o.o_orderkey is not null and t.t_sum_quantity > 315
  join lineitem l
  on
    o.o_orderkey = l.l_orderkey and l.l_orderkey is not null
group by c_name,c_custkey,o_orderkey,o_orderdate,o_totalprice
order by o_totalprice desc,o_orderdate 
limit 100;

select
  c_name,c_custkey,o_orderkey,o_orderdate,o_totalprice,sum(l_quantity)
from
  customer c join orders o
  on
    c.c_custkey = o.o_custkey
  join q18_tmp_cached t
  on
    o.o_orderkey = t.l_orderkey and o.o_orderkey is not null and t.t_sum_quantity > 315
  join lineitem l
  on
    o.o_orderkey = l.l_orderkey and l.l_orderkey is not null
group by c_name,c_custkey,o_orderkey,o_orderdate,o_totalprice
order by o_totalprice desc,o_orderdate
limit 100;
!echo ============================== Q18 END ====================================;
