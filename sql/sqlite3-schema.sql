BEGIN TRANSACTION;

PRAGMA foreign_keys = ON;

-- NB: sqlite uses UTC for CURRENT_TIMESTAMP - BEWARE!!
CREATE TABLE sessions (
    session_id  VARCHAR(40) PRIMARY KEY NOT NULL,
    session_ts  DATETIME DEFAULT CURRENT_TIMESTAMP,
    session     TEXT
);

CREATE TABLE tracker_role (
	role_id		INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	name		TEXT NOT NULL
);
INSERT INTO tracker_role VALUES ( null, 'Admin' );
INSERT INTO tracker_role VALUES ( null, 'Guest' );
INSERT INTO tracker_role VALUES ( null, 'Owner' );
INSERT INTO tracker_role VALUES ( null, 'User'  );

CREATE TABLE tracker_user (
	user_id		INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	login		TEXT NOT NULL,
	user_name	TEXT,
	email_address	TEXT NOT NULL,
	password	TEXT NOT NULL,
	active		BOOLEAN DEFAULT 1
);
-- BAH! SQLite3 doesn't appear to allow use of functions in an index:
--CREATE UNIQUE INDEX email_address_idx ON tracker_user ( lower(email_address) );
CREATE UNIQUE INDEX email_address_idx ON tracker_user ( email_address );

CREATE TABLE tracker_user_role (
	user_id		INT NOT NULL,
	role_id		INT NOT NULL,

	PRIMARY KEY	( user_id, role_id ),
	FOREIGN KEY	( user_id ) REFERENCES tracker_user ( user_id ),
	FOREIGN KEY	( role_id ) REFERENCES tracker_role ( role_id )
);

CREATE TABLE water_type (
	water_id	INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	water_type	TEXT NOT NULL
);

INSERT INTO water_type VALUES ( null, 'Salt Water'  );
INSERT INTO water_type VALUES ( null, 'Fresh Water' );

CREATE TABLE capacity (
	capacity_id	INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	capacity_desc	TEXT NOT NULL
);

INSERT INTO capacity VALUES ( null, 'Litres'  );
INSERT INTO capacity VALUES ( null, 'Gallons' );

CREATE TABLE dimension (
	dimension_id	INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	dimension_desc	TEXT NOT NULL
);

INSERT INTO dimension VALUES ( null, 'mm'  );
INSERT INTO dimension VALUES ( null, 'cm' );
INSERT INTO dimension VALUES ( null, 'm' );
INSERT INTO dimension VALUES ( null, 'inches' );
INSERT INTO dimension VALUES ( null, 'feet' );

CREATE TABLE tank (
        tank_id		INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        water_id	INTEGER NOT NULL,
        tank_name	TEXT NOT NULL,
        user_id		INTEGER NOT NULL,
        notes           TEXT,
        capacity        NUMERIC NOT NULL,
        capacity_id     INTEGER NOT NULL,
        length          NUMERIC DEFAULT 0,
        width           NUMERIC DEFAULT 0,
        depth           NUMERIC DEFAULT 0,
        dimension_id    INTEGER NOT NULL,
        updated_on	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY ( user_id  ) REFERENCES tracker_user ( user_id  ),
        FOREIGN KEY ( water_id ) REFERENCES water_type   ( water_id ),
        FOREIGN KEY ( capacity_id  ) REFERENCES capacity  ( capacity_id ),
        FOREIGN KEY ( dimension_id ) REFERENCES dimension ( dimension_id )
);
CREATE UNIQUE INDEX tank_name_idx ON tank ( tank_name );

CREATE TABLE tank_user (
        tank_id	INTEGER NOT NULL,
        user_id	INTEGER NOT NULL,
        admin	BOOLEAN DEFAULT FALSE,

        PRIMARY KEY ( tank_id, user_id ),
        FOREIGN KEY ( tank_id ) REFERENCES tank ( tank_id  ),
        FOREIGN KEY ( user_id ) REFERENCES tracker_user ( user_id  )
);

CREATE TABLE water_tests (
	test_id		  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	tank_id		  INTEGER NOT NULL,
	user_id		  INTEGER NOT NULL,
	test_date	  DATE NULL DEFAULT CURRENT_TIMESTAMP,
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

	FOREIGN KEY ( tank_id ) REFERENCES tank ( tank_id ),
	FOREIGN KEY ( user_id ) REFERENCES tracker_user ( user_id )
);
/* Not sure whether to allow multiple tests to be run on same day/date: */
-- CREATE UNIQUE INDEX ON water_tests (tank_id, ( test_timestamp::date ));

CREATE TABLE tank_diary (
	diary_id	INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	tank_id		INTEGER NOT NULL,
	user_id		INTEGER NOT NULL,
	diary_date	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	diary_note	TEXT NOT NULL,
	updated_on      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	test_id		INT,
	
	FOREIGN KEY ( tank_id  ) REFERENCES tank ( tank_id ),
	FOREIGN KEY ( user_id  ) REFERENCES tracker_user ( user_id ),
	FOREIGN KEY ( test_id  ) REFERENCES water_tests  ( test_id ) ON DELETE CASCADE,
        UNIQUE ( test_id )
);
CREATE INDEX tank_diary_date ON tank_diary ( tank_id, diary_date );

CREATE TABLE inventory_class (
	class_id  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	class	  TEXT NOT NULL
);

INSERT INTO inventory_class VALUES (null, 'Consumable');
INSERT INTO inventory_class VALUES (null, 'Livestock');
INSERT INTO inventory_class VALUES (null, 'Equipment');

CREATE TABLE inventory_type (
	type_id      INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        class_id     INTEGER NOT NULL,
	type	     TEXT NOT NULL,
        FOREIGN KEY ( class_id )
                  REFERENCES inventory_class ( class_id )
);

INSERT INTO inventory_type VALUES (null, 1, 'Food');
INSERT INTO inventory_type VALUES (null, 1, 'Test Chemicals');
INSERT INTO inventory_type VALUES (null, 1, 'Water Additives');
INSERT INTO inventory_type VALUES (null, 1, 'Medication');
INSERT INTO inventory_type VALUES (null, 2, 'Fish');
INSERT INTO inventory_type VALUES (null, 2, 'Shrimp');
INSERT INTO inventory_type VALUES (null, 2, 'Crab');
INSERT INTO inventory_type VALUES (null, 2, 'Other Crustacean');
INSERT INTO inventory_type VALUES (null, 2, 'Snail');
INSERT INTO inventory_type VALUES (null, 2, 'Other Invertebrate');
INSERT INTO inventory_type VALUES (null, 2, 'Hard Coral');
INSERT INTO inventory_type VALUES (null, 2, 'Soft Coral');
INSERT INTO inventory_type VALUES (null, 2, 'Anemone');
INSERT INTO inventory_type VALUES (null, 2, 'Starfish');
INSERT INTO inventory_type VALUES (null, 3, 'Power Head');
INSERT INTO inventory_type VALUES (null, 3, 'Pump');
INSERT INTO inventory_type VALUES (null, 3, 'Skimmer');
INSERT INTO inventory_type VALUES (null, 3, 'Lighting');
INSERT INTO inventory_type VALUES (null, 3, 'Heating');

CREATE TABLE inventory (
	item_id		  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	type_id           INTEGER NOT NULL,
	tank_id		  INTEGER NOT NULL,
	user_id		  INTEGER NOT NULL,
	description	  TEXT NOT NULL,
	purchase_date	  DATE NOT NULL,
	purchase_price	  MONEY NOT NULL,
        quantity          NUMBER NOT NULL,

	FOREIGN KEY ( tank_id  ) REFERENCES tank ( tank_id ),
	FOREIGN KEY ( user_id )  REFERENCES tracker_user ( user_id ),
	FOREIGN KEY ( type_id  ) REFERENCES inventory_type ( type_id )
);



COMMIT;
