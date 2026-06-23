--  Задача 1: найти регион абонента в момент его последней активности за каждый день

with days as (
	select abonent, max(dttm) over (partition by day(dttm), abonent) dttm from t
)
select days.abonent, region_id, days.dttm from t right join days using(dttm)


-- Задача 2: помесячный расчета динамики числа публикаций

with posts_count as(
	select date_format(created_at, '%Y-%m-01') dt, count(*) `count`
	from posts
	group by date_format(created_at, '%Y-%m-01')
)
select dt, `count`,
	case
		when `count` / lag(`count`) over (order by dt) is null
		then null
		else concat(cast(round((`count` / lag(`count`) over (order by dt) - 1) * 100, 1) as char), '%')
	end
	as percent
from posts_count

