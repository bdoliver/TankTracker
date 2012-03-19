\set ON_ERROR_STOP 1
BEGIN TRANSACTION;

CREATE TABLE tracker_role (
	role_id		SERIAL NOT NULL,
	name		TEXT NOT NULL,

	PRIMARY KEY ( role_id )
);
INSERT INTO tracker_role VALUES ( default, 'Admin' );
INSERT INTO tracker_role VALUES ( default, 'Guest' );
INSERT INTO tracker_role VALUES ( default, 'Owner' );
INSERT INTO tracker_role VALUES ( default, 'User'  );

CREATE TABLE tracker_user (
	user_id		SERIAL NOT NULL,
	login		TEXT NOT NULL,
	user_name	TEXT,
	email_address	TEXT NOT NULL,
	password	TEXT NOT NULL,

	PRIMARY KEY ( user_id )
);
CREATE UNIQUE INDEX email_address_idx ON tracker_user ( lower(email_address) );

CREATE TABLE tracker_user_role (
	user_id		INT NOT NULL,
	role_id		INT NOT NULL,

	PRIMARY KEY	( user_id, role_id ),
	FOREIGN KEY	( user_id ) REFERENCES tracker_user ( user_id ),
	FOREIGN KEY	( role_id ) REFERENCES tracker_role ( role_id )
);

CREATE TABLE session (
	session_id      BIGINT NOT NULL,
	user_id		INTEGER NOT NULL,
	created_on	TIMESTAMP(0) NOT NULL,

	PRIMARY KEY ( session_id ),

	FOREIGN KEY ( user_id ) REFERENCES tracker_user ( user_id ) ON DELETE CASCADE
);

CREATE TABLE water_type (
	water_id	SERIAL NOT NULL,
	water_type	TEXT NOT NULL,

	PRIMARY KEY ( water_id )
);

INSERT INTO water_type VALUES ( default, 'Salt Water'  );
INSERT INTO water_type VALUES ( default, 'Fresh Water' );

CREATE TABLE tank (
	tank_id		SERIAL NOT NULL,
	water_id	SERIAL NOT NULL,
	tank_name	TEXT NOT NULL,
	user_id		INTEGER NOT NULL,
	notes           TEXT,
	updated_on	TIMESTAMP(0) DEFAULT now(),

	PRIMARY KEY ( tank_id ),
	FOREIGN KEY ( user_id  ) REFERENCES tracker_user ( user_id  ),
	FOREIGN KEY ( water_id ) REFERENCES water_type   ( water_id )
);

CREATE TABLE tank_user (
	tank_id	INTEGER NOT NULL,
	user_id	INTEGER NOT NULL,
	admin	BOOLEAN DEFAULT FALSE,
	
	PRIMARY KEY ( tank_id, user_id ),
	FOREIGN KEY ( tank_id ) REFERENCES tank ( tank_id  ),
	FOREIGN KEY ( user_id ) REFERENCES tracker_user ( user_id  )
);

CREATE TABLE water_tests (
	test_id		  SERIAL NOT NULL,
	tank_id		  INTEGER NOT NULL,
	user_id		  INTEGER NOT NULL,
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
	FOREIGN KEY ( tank_id ) REFERENCES tank ( tank_id ),
	FOREIGN KEY ( user_id ) REFERENCES tracker_user ( user_id )
);
/* Not sure whether to allow multiple tests to be run on same day/date: */
-- CREATE UNIQUE INDEX ON water_tests (tank_id, ( test_timestamp::date ));

CREATE TABLE tank_diary (
	diary_id	SERIAL NOT NULL,
	tank_id		INTEGER NOT NULL,
	user_id		INTEGER NOT NULL,
	diary_date	TIMESTAMP(0) NOT NULL DEFAULT now(),
	diary_note	TEXT NOT NULL,
	updated_on      TIMESTAMP(0) NOT NULL DEFAULT now(),
	test_id		INT,
	
	PRIMARY KEY ( diary_id ),
	FOREIGN KEY ( tank_id  ) REFERENCES tank ( tank_id ),
	FOREIGN KEY ( user_id  ) REFERENCES tracker_user ( user_id ),
	FOREIGN KEY ( test_id  ) REFERENCES water_tests  ( test_id ) ON DELETE CASCADE
);
CREATE INDEX tank_diary_date ON tank_diary ( tank_id, diary_date );

CREATE TABLE inventory_type (
	inventory_type_id SERIAL NOT NULL,
	description	  TEXT NOT NULL,

	PRIMARY KEY ( inventory_type_id )
);

INSERT INTO inventory_type VALUES (default, 'Consumable');
INSERT INTO inventory_type VALUES (default, 'Equipment');
INSERT INTO inventory_type VALUES (default, 'Fish');
INSERT INTO inventory_type VALUES (default, 'Invertebrate');
INSERT INTO inventory_type VALUES (default, 'Coral');

CREATE TABLE inventory (
	item_id		  SERIAL NOT NULL,
	inventory_type_id INTEGER NOT NULL,
	tank_id		  INTEGER NOT NULL,
	user_id		  INTEGER NOT NULL,
	description	  TEXT NOT NULL,
	purchase_date	  DATE NOT NULL,
	purchase_price	  MONEY NOT NULL,

	PRIMARY KEY ( item_id ),
	FOREIGN KEY ( tank_id  ) REFERENCES tank ( tank_id ),
	FOREIGN KEY ( user_id )  REFERENCES tracker_user ( user_id ),
	FOREIGN KEY ( inventory_type_id  ) REFERENCES inventory_type ( inventory_type_id ) ON DELETE CASCADE
);



COMMIT;
