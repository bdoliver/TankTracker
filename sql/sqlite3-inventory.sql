BEGIN TRANSACTION;

PRAGMA foreign_keys = ON;

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
