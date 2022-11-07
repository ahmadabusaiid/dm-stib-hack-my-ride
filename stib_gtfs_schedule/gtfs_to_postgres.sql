DROP TABLE IF EXISTS agency;


CREATE TABLE agency (
  agency_id VARCHAR(255) PRIMARY KEY,
  agency_name VARCHAR(255),
  agency_url VARCHAR(255),
  agency_timezone VARCHAR(50),
  agency_lang VARCHAR(255),
  agency_phone VARCHAR(50)
);

DROP TABLE IF EXISTS calendar;

CREATE TABLE calendar (
  service_id INT,
  monday SMALLINT,
  tuesday SMALLINT,
  wednesday SMALLINT,
  thursday SMALLINT,
  friday SMALLINT,
  saturday SMALLINT,
  sunday SMALLINT,
  start_date VARCHAR(8),
  end_date VARCHAR(8)
);

CREATE INDEX service_id_on_calendar ON calendar (service_id);

DROP TABLE IF EXISTS calendar_dates;

CREATE TABLE calendar_dates (
  service_id INT,
  date VARCHAR(8),
  exception_type INT
);

CREATE INDEX service_id_on_dates ON calendar_dates (service_id);
--CREATE INDEX exception_type ON calendar_dates (exception_type); --why index?

--DROP TABLE IF EXISTS fare_attributes; --fare_attributes table doesnt exist in STIB data

-- SQLINES LICENSE FOR EVALUATION USE ONLY
/*CREATE TABLE fare_attributes (
  fare_id INT,
  price DECIMAL(9,6),
  currency_type VARCHAR(8),
  payment_method INT,
  transfers INT
);*/

--CREATE INDEX fare_id ON fare_attributes (fare_id);

--DROP TABLE IF EXISTS fare_rules; --fare_rules table doesnt exist in STIB data 

-- SQLINES LICENSE FOR EVALUATION USE ONLY
/*CREATE TABLE fare_rules (
  fare_id INT,
  route_id INT
);*/

--CREATE INDEX fare_id ON fare_rules (fare_id);
--CREATE INDEX route_id ON fare_rules (route_id);


DROP TABLE IF EXISTS routes;

--route_id,
--route_short_name,
--route_long_name,
--route_desc,
--route_type,
--route_url,
--route_color,
--route_text_color

CREATE TABLE routes (
  route_id INT PRIMARY KEY,
  route_short_name VARCHAR(50),
  route_long_name VARCHAR(255),
  route_desc VARCHAR(255),
  route_type INT,
  route_url VARCHAR(255),
  route_color VARCHAR(255),
  route_text_color VARCHAR(255)

);

CREATE INDEX route_type ON routes (route_type);

DROP TABLE IF EXISTS shapes;

--shape_id,
--shape_pt_lat,
--shape_pt_lon,
--shape_pt_sequence

CREATE TABLE shapes (
  shape_id VARCHAR(50), --there are duplicates, we cant have this as a key
  shape_pt_lat DECIMAL(9,6),
  shape_pt_lon DECIMAL(9,6),
  shape_pt_sequence INT
);

CREATE INDEX shape_id ON shapes (shape_id); --we cant have a pkey on shape_id, thus, we put an index 

DROP TABLE IF EXISTS stop_times;

--trip_id,
--arrival_time,
--departure_time,
--stop_id,
--stop_sequence,
--pickup_type,
--drop_off_type

CREATE TABLE stop_times (
  trip_id BIGSERIAL, --112387248235954071 .. pretty long using INT or SERIAL didnt work
  arrival_time VARCHAR(8),
  departure_time VARCHAR(8),
  stop_id VARCHAR(8), -- changed to varchar -> it has int and char
  stop_sequence INT,
  pickup_type INT,
  drop_off_type INT
);

CREATE INDEX trip_id ON stop_times (trip_id);
CREATE INDEX stop_id ON stop_times (stop_id);
CREATE INDEX stop_sequence ON stop_times (stop_sequence);

DROP TABLE IF EXISTS stops;

--stop_id,
--stop_code,
--stop_name,
--stop_desc,
--stop_lat,
--stop_lon,
--zone_id,
--stop_url,
--location_type,
--parent_station

CREATE TABLE stops (
  stop_id VARCHAR(8) PRIMARY KEY, --choose varchar cause: 0470F 
  stop_code INT,
  stop_name VARCHAR(255),
  stop_desc VARCHAR(255),
  stop_lat DECIMAL(9,6),
  stop_lon DECIMAL(9,6),
  zone_id INT,
  stop_url VARCHAR(255),
  location_type INT,
  parent_station INT
);

CREATE INDEX stop_lat ON stops (stop_lat); --do we need this?
CREATE INDEX stop_lon ON stops (stop_lon); --do we need this?

DROP TABLE IF EXISTS trips;

--route_id,
--service_id,
--trip_id,
--trip_headsign,
--direction_id,
--block_id,
--shape_id

CREATE TABLE trips (
  route_id INT,
  service_id INT,
  trip_id BIGSERIAL PRIMARY KEY,
  trip_headsign VARCHAR(255),
  direction_id SMALLINT,
  block_id INT,
  shape_id VARCHAR(50)
);

CREATE INDEX route_id ON trips (route_id);
CREATE INDEX service_id_on_trips ON trips (service_id);
CREATE INDEX direction_id ON trips (direction_id);--do we need this?
CREATE INDEX shape_id ON trips (shape_id);

COPY agency FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/agency.txt' ( FORMAT CSV, HEADER);
COPY calendar FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/calendar.txt' ( FORMAT CSV, HEADER);
COPY calendar_dates FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/calendar_dates.txt' ( FORMAT CSV, HEADER);
COPY routes FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/routes.txt' ( FORMAT CSV, DELIMITER(','),HEADER);
COPY shapes FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/shapes.txt' ( FORMAT CSV, HEADER);
COPY stop_times FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/stop_times.txt' ( FORMAT CSV, HEADER);
COPY stops FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/stops.txt' ( FORMAT CSV, HEADER);
--COPY translations FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/translations.txt' ( FORMAT CSV, HEADER);
COPY trips FROM '/Users/alaaalmutawa/Documents/INFO423/Project/Project Data-20221101/gtfs3Sept/trips.txt' ( FORMAT CSV, HEADER);

--did not create a translation table 

