--Ref: https://docs.mobilitydb.com/MobilityDB-workshop/master/ch04.html
--Adjusted to fit our use case 

DROP TABLE IF EXISTS agency;

CREATE TABLE agency (
  agency_id text DEFAULT '',
  agency_name text DEFAULT NULL,
  agency_url text DEFAULT NULL,
  agency_timezone text DEFAULT NULL,
  agency_lang text DEFAULT NULL,
  agency_phone text DEFAULT NULL,
  CONSTRAINT agency_pkey PRIMARY KEY (agency_id)
);

DROP TABLE IF EXISTS calendar;

CREATE TABLE calendar (
  service_id text,
  monday int NOT NULL,
  tuesday int NOT NULL,
  wednesday int NOT NULL,
  thursday int NOT NULL,
  friday int NOT NULL,
  saturday int NOT NULL,
  sunday int NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  CONSTRAINT calendar_pkey PRIMARY KEY (service_id)
);
CREATE INDEX calendar_service_id ON calendar (service_id);

DROP TABLE IF EXISTS calendar_dates;

CREATE TABLE calendar_dates (
  service_id text,
  date date NOT NULL,
  exception_type int
);
CREATE INDEX calendar_dates_dateidx ON calendar_dates (date);

DROP TABLE IF EXISTS routes;

CREATE TABLE routes (
  route_id text,
  route_short_name text DEFAULT '',
  route_long_name text DEFAULT '',
  route_desc text DEFAULT '',
  route_type int,
  route_url text,
  route_color text,
  route_text_color text,
  CONSTRAINT routes_pkey PRIMARY KEY (route_id)
);

DROP TABLE IF EXISTS shapes;

CREATE TABLE shapes (
  shape_id text NOT NULL,
  shape_pt_lat double precision NOT NULL,
  shape_pt_lon double precision NOT NULL,
  shape_pt_sequence int NOT NULL
);
CREATE INDEX shapes_shape_key ON shapes (shape_id);

DROP TABLE IF EXISTS stops;

CREATE TABLE stops (
  stop_id text,
  stop_code text,
  stop_name text DEFAULT NULL,
  stop_desc text DEFAULT NULL,
  stop_lat double precision,
  stop_lon double precision,
  zone_id text,
  stop_url text,
  location_type integer,
  parent_station integer,
  CONSTRAINT stops_pkey PRIMARY KEY (stop_id)
);

DROP TABLE IF EXISTS stop_times;

CREATE TABLE stop_times (
  trip_id text NOT NULL,
  -- Check that casting to time interval works.
  arrival_time interval CHECK (arrival_time::interval = arrival_time::interval),
  departure_time interval CHECK (departure_time::interval = departure_time::interval),
  stop_id text,
  stop_sequence int,
  pickup_type INT,
  drop_off_type int,
  CONSTRAINT stop_times_pkey PRIMARY KEY (trip_id, stop_sequence)
);

CREATE INDEX stop_times_key ON stop_times (trip_id, stop_id);
CREATE INDEX arr_time_index ON stop_times (arrival_time);
CREATE INDEX dep_time_index ON stop_times (departure_time);

DROP TABLE IF EXISTS trips;

CREATE TABLE trips (
  route_id text NOT NULL,
  service_id text NOT NULL,
  trip_id text NOT NULL,
  trip_headsign text,
  direction_id int,
  block_id text,
  shape_id text,
  CONSTRAINT trips_pkey PRIMARY KEY (trip_id)
);
CREATE INDEX trips_trip_id ON trips (trip_id);


COPY agency FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/agency.txt' ( FORMAT CSV, HEADER);
COPY calendar FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/calendar.txt' ( FORMAT CSV, HEADER);
COPY calendar_dates FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/calendar_dates.txt' ( FORMAT CSV, HEADER);
COPY routes FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/routes.txt' ( FORMAT CSV, DELIMITER(','),HEADER);
COPY shapes FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/shapes.txt' ( FORMAT CSV, HEADER);
COPY stop_times FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/stop_times.txt' ( FORMAT CSV, HEADER);
COPY stops FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/stops.txt' ( FORMAT CSV, HEADER);
--COPY translations FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/translations.txt' ( FORMAT CSV, HEADER);
COPY trips FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/trips.txt' ( FORMAT CSV, HEADER);
