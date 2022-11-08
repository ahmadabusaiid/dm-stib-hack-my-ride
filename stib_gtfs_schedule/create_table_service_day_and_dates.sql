--Ref: https://docs.mobilitydb.com/MobilityDB-workshop/master/ch04s02.html
/*This table transforms the service patterns in the calendar table valid between 
a start_date and an end_date taking into account the week days, 
and then remove the exceptions of type 2 and add the exceptions of 
type 1 that are specified in table calendar_dates.*/
DROP TABLE IF EXISTS service_dates;
CREATE TABLE service_dates AS (
SELECT service_id, date_trunc('day', d)::date AS date
FROM calendar c, generate_series(start_date, end_date, '1 day'::interval) AS d
WHERE (
	(monday = 1 AND extract(isodow FROM d) = 1) OR
	(tuesday = 1 AND extract(isodow FROM d) = 2) OR
	(wednesday = 1 AND extract(isodow FROM d) = 3) OR
	(thursday = 1 AND extract(isodow FROM d) = 4) OR
	(friday = 1 AND extract(isodow FROM d) = 5) OR
	(saturday = 1 AND extract(isodow FROM d) = 6) OR
	(sunday = 1 AND extract(isodow FROM d) = 7)
)
EXCEPT
SELECT service_id, date
FROM calendar_dates WHERE exception_type = 2
UNION
SELECT c.service_id, date
FROM calendar c JOIN calendar_dates d ON c.service_id = d.service_id
WHERE exception_type = 1 AND start_date <= date AND date <= end_date
);

--create table with the day type?
DROP TABLE IF EXISTS service_day;
CREATE TABLE service_day AS (
SELECT service_id, date, 
	(CASE 
	WHEN (monday = 1 OR 
		 tuesday = 1 OR 
		 wednesday = 1 OR 
		 thursday = 1 OR
		friday = 1) THEN 'weekday'
	WHEN saturday = 1 THEN 'saturday'
	WHEN sunday = 1 THEN 'sunday'END) as day_type
FROM calendar c 
	join service_dates sd using (service_id));
	



