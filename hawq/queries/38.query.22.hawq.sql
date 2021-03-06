select
	cntrycode,
	count(*) as numcust,
	sum(c_acctbal) as totacctbal
from
	(
		select
			substring(c_phone from 1 for 2) as cntrycode,
			c_acctbal
		from
			tpch.customer
		where
			substring(c_phone from 1 for 2) in
				('25', '22', '35', '20', '26', '21', '30')
			and c_acctbal > (
				select
					avg(c_acctbal)
				from
					tpch.customer
				where
					c_acctbal > 0.00
					and substring(c_phone from 1 for 2) in
						('25', '22', '35', '20', '26', '21', '30')
			)
			and not exists (
				select
					*
				from
					tpch.orders
				where
					o_custkey = c_custkey
			)
	) as custsale
group by
	cntrycode
order by
	cntrycode;
