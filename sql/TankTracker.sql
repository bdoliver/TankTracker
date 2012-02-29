--\set ON_ERROR_STOP 1
BEGIN TRANSACTION;

CREATE TABLE tank_user (
	user_id		SERIAL NOT NULL,
	first_name	TEXT NOT NULL,
	last_name	TEXT,
	email_address	TEXT NOT NULL,
	password	TEXT NOT NULL,

	PRIMARY KEY ( user_id )
);
CREATE UNIQUE INDEX email_address_idx ON tank_user ( lower(email_address) );

INSERT INTO tank_user VALUES ( 0, 'Guest', null, 'guest@example.com', 'guest' );

CREATE TABLE session (
	session_id      BIGINT NOT NULL,
	user_id		INT    NOT NULL,
	created_on	TIMESTAMP(0) NOT NULL,

	PRIMARY KEY ( session_id ),

	FOREIGN KEY ( user_id ) REFERENCES tank_user ( user_id ) ON DELETE CASCADE
);

CREATE TABLE water_type (
	water_id	SERIAL NOT NULL,
	water_type   	TEXT NOT NULL,

	PRIMARY KEY ( water_id )
);

INSERT INTO water_type VALUES ( default, 'Salt Water'  );
INSERT INTO water_type VALUES ( default, 'Fresh Water' );


CREATE TABLE tank (
	tank_id		SERIAL NOT NULL,
	water_id	SERIAL NOT NULL,
	tank_name	TEXT NOT NULL,
	user_id		INT NOT NULL,
	notes           TEXT,
	updated_on	TIMESTAMP(0) DEFAULT now(),

	PRIMARY KEY ( tank_id ),
	FOREIGN KEY ( user_id  ) REFERENCES tanke_user ( user_id  ),
	FOREIGN KEY ( water_id ) REFERENCES water_type ( water_id )
);

CREATE TABLE water_tests (
	test_id		  SERIAL NOT NULL,
	tank_id		  INTEGER NOT NULL,
	test_date	  DATE NULL DEFAULT current_date,
	result_salinity	  NUMERIC,
	result_ph	  NUMERIC,
	result_ammonia	  NUMERIC,
	result_nitrite    NUMERIC,
	result_nitrate	  NUMERIC,
	result_calcium	  NUMERIC,
	result_phosphate  NUMERIC,
	result_magnesium  NUMERIC,
	result_kh  	  NUMERIC,
	result_alkalinity NUMERIC,
	water_change	  NUMERIC,
	notes		  TEXT,

	PRIMARY KEY ( test_id ),
	FOREIGN KEY ( tank_id ) REFERENCES tank ( tank_id )
);
/* Not sure whether to allow multiple tests to be run on same day/date: */
-- CREATE UNIQUE INDEX ON water_tests (tank_id, ( test_timestamp::date ));

CREATE TABLE tank_diary (
	diary_id	SERIAL NOT NULL,
	tank_id		INTEGER NOT NULL,
	diary_date	TIMESTAMP(0) NOT NULL DEFAULT now(),
	diary_note	TEXT NOT NULL,
	updated_on      TIMESTAMP(0) NOT NULL DEFAULT now(),
	test_id		INT,
	
	PRIMARY KEY ( diary_id ),
	FOREIGN KEY ( tank_id  ) REFERENCES tank ( tank_id ),
	FOREIGN KEY ( test_id  ) REFERENCES water_tests ( test_id ) ON DELETE CASCADE;
);
CREATE INDEX tank_diary_date ON tank_diary ( tank_id, diary_date );

INSERT INTO tank VALUES ( 
	default,
	( SELECT water_id FROM water_type WHERE water_type = 'Salt Water' ),
	'1000l Reef'
);
INSERT INTO tank VALUES ( 
	default,
	( SELECT water_id FROM water_type WHERE water_type = 'Salt Water' ),
	'RedSea Max 130'
);
INSERT INTO tank VALUES ( 
	default,
	( SELECT water_id FROM water_type WHERE water_type = 'Fresh Water' ),
	'Tropical'
);

COMMIT;
