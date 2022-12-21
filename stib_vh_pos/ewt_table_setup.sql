create table ewt as 

with nom_denom as (
	select
	  day_category
	, vh_date
	, vehicle
	, line
	, direction
	, stop_name
	, stop_seq
	, sched_timegroup
	, timegroup_start_in
	, timegroup_end_ex
	, avg(sched_avg_headway)::numeric(9, 2) as sched_headway_avg
	, sum(power(sched_avg_headway, 2)) as swt_nom
	, (2 * sum(sched_avg_headway)) as swt_denom
	, sum(power(actual_headway, 2)) as awt_nom
	, (2 * sum(actual_headway)) as awt_denom
	from actual_headways
	where qos = 'Regularity'
	group by
		  day_category
		, vh_date
		, vehicle
		, line
		, direction
		, stop_name
		, stop_seq
		, sched_timegroup
		, timegroup_start_in
		, timegroup_end_ex
)

, swt_awt as (
	select
	  *
	, (swt_nom/swt_denom)::numeric(9, 2) as swt
	, (awt_nom/awt_denom)::numeric(9, 2) as awt
	from nom_denom
)

, ewt as (
	select
	  day_category
	, vh_date
	, vehicle
	, line
	, direction
	, stop_name
	, stop_seq
	, sched_timegroup
	, sched_headway_avg
	, timegroup_start_in
	, timegroup_end_ex
	, awt - swt as ewt_min
	, (awt - swt) * 60 as ewt_sec
	from swt_awt
	order by
		  vh_date
		, vehicle
		, line
		, direction
		, stop_seq
		, sched_timegroup
)

select * from ewt