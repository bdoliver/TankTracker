\set ON_ERROR_STOP 1
BEGIN TRANSACTION;

CREATE TABLE tracker_role (
    role_id     SERIAL
                NOT NULL
                PRIMARY KEY,

    name        TEXT NOT NULL
);
INSERT INTO tracker_role VALUES ( default, 'Admin' );
INSERT INTO tracker_role VALUES ( default, 'Guest' );
INSERT INTO tracker_role VALUES ( default, 'Owner' );
INSERT INTO tracker_role VALUES ( default, 'User'  );

CREATE TABLE tracker_user (
    user_id       SERIAL
                  NOT NULL
                  PRIMARY KEY,

    username      TEXT NOT NULL,
    password      TEXT NOT NULL,
    first_name    TEXT,
    last_name     TEXT,
    email         TEXT NOT NULL,
    active        BOOLEAN DEFAULT TRUE,
    last_login    TIMESTAMP(0),
    created_on    TIMESTAMP(0) NOT NULL DEFAULT now(),
    updated_on    TIMESTAMP(0) DEFAULT now()
);
CREATE UNIQUE INDEX email_address_idx ON tracker_user ( lower(email) );

CREATE TABLE tracker_user_role (
    user_id     INT
                NOT NULL
                REFERENCES tracker_user ( user_id ),

    role_id     INT
                NOT NULL
                REFERENCES tracker_role ( role_id ),

    PRIMARY KEY ( user_id, role_id )
);

CREATE TABLE sessions (
    session_id   VARCHAR(72)
                 NOT NULL
                 PRIMARY KEY,

    session_ts   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires      INTEGER,
    session_data TEXT
);

CREATE TYPE water_type AS ENUM (
    'salt',
    'fresh'
);

CREATE TABLE tank (
    tank_id         SERIAL
                    NOT NULL
                    PRIMARY KEY,

    owner_id        INTEGER
                    NOT NULL
                    REFERENCES tracker_user ( user_id ),

    water_type      water_type NOT NULL,
    tank_name       TEXT NOT NULL,

    notes           TEXT,
    capacity        NUMERIC DEFAULT 0,
    length          NUMERIC DEFAULT 0,
    width           NUMERIC DEFAULT 0,
    depth           NUMERIC DEFAULT 0,
    active          BOOLEAN DEFAULT TRUE,
    created_on      TIMESTAMP(0) NOT NULL DEFAULT now(),
    updated_on      TIMESTAMP(0) DEFAULT now()
);
CREATE UNIQUE INDEX tank_name_idx ON tank (lower(tank_name));

CREATE TABLE tank_user_access (
    tank_id   INTEGER
              NOT NULL
              REFERENCES tank ( tank_id  ),

    user_id   INTEGER
              NOT NULL
              REFERENCES tracker_user ( user_id  ),

    admin     BOOLEAN DEFAULT FALSE,

    PRIMARY KEY ( tank_id, user_id )
);

CREATE TABLE water_test (
    test_id           SERIAL
                      NOT NULL
                      PRIMARY KEY,

    tank_id           INTEGER
                      NOT NULL
                      REFERENCES tank ( tank_id ),

    user_id           INTEGER
                      NOT NULL
                      REFERENCES tracker_user ( user_id ),

    test_date         TIMESTAMP(0) NULL DEFAULT current_date,
    result_salinity   NUMERIC,
    result_ph         NUMERIC,
    result_ammonia    NUMERIC,
    result_nitrite    NUMERIC,
    result_nitrate    NUMERIC,
    result_calcium    NUMERIC,
    result_phosphate  NUMERIC,
    result_magnesium  NUMERIC,
    result_kh         NUMERIC,
    result_alkalinity NUMERIC,
    temperature       NUMERIC,
    water_change      NUMERIC,
    notes             TEXT
);
/* Not sure whether to allow multiple tests to be run on same day/date: */
CREATE UNIQUE INDEX ON water_test (tank_id, ( test_date::date ));

CREATE TABLE diary (
    diary_id    SERIAL
                NOT NULL
                PRIMARY KEY,

    tank_id     INTEGER
                NOT NULL
                REFERENCES tank         ( tank_id ),

    user_id     INTEGER
                NOT NULL
                REFERENCES tracker_user ( user_id ),

    diary_date  TIMESTAMP(0) NOT NULL DEFAULT now(),
    diary_note  TEXT NOT NULL,
    updated_on  TIMESTAMP(0) NOT NULL DEFAULT now(),
    test_id     INT
                REFERENCES water_test  ( test_id ) ON DELETE CASCADE
);
CREATE INDEX tank_diary_date ON diary ( tank_id, diary_date );

CREATE TYPE inventory_type AS ENUM (
    'consumable',
    'equipment',
    'fish',
    'invertebrate',
    'coral'
);

CREATE TABLE inventory (
    inventory_id      SERIAL
                      NOT NULL
                      PRIMARY KEY,

    inventory_type    inventory_type NOT NULL,

    tank_id           INTEGER
                      NOT NULL
                      REFERENCES tank ( tank_id ),

    user_id           INTEGER
                      NOT NULL
                      REFERENCES tracker_user ( user_id ),

    description       TEXT NOT NULL,
    purchase_date     DATE NOT NULL,
    purchase_price    MONEY NOT NULL,
    created_on        TIMESTAMP(0) NOT NULL DEFAULT now(),
    updated_on        TIMESTAMP(0) DEFAULT now()
);

CREATE TYPE capacity_unit AS ENUM (
    'litres',
    'gallons',
    'us gallons'
);

CREATE TYPE dimension_unit AS ENUM (
    'mm',
    'cm',
    'm',
    'inches',
    'feet'
);

CREATE TYPE temperature_scale AS ENUM (
    'C',
    'F'
);

CREATE TABLE preferences (
    user_id         INTEGER
                    NOT NULL
                    REFERENCES tracker_user ( user_id )
                    ON DELETE CASCADE,

    capacity_units    capacity_unit NOT NULL,
    dimension_units   dimension_unit NOT NULL,
    temperature_scale temperature_scale NOT NULL,

    recs_per_page   INTEGER
                    NOT NULL
                    DEFAULT 10
                    CHECK (recs_per_page > 0),

    updated_on      TIMESTAMP(0) DEFAULT now(),
    PRIMARY KEY ( user_id )
);

CREATE VIEW user_tanks AS (
    SELECT tank_id,
           tank_name,
           water_type,
           active,
           admin,
           owner_id,
           user_id
    FROM tank_user_access JOIN tank USING ( tank_id )
);

COMMIT;
