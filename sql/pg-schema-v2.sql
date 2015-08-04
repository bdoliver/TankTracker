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
    parent_id     INTEGER NOT NULL
                  REFERENCES tracker_user (user_id),

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

CREATE TYPE parameter_type AS ENUM (
    'salinity',
    'ph',
    'ammonia',
    'nitrite',
    'nitrate',
    'calcium',
    'phosphate',
    'magnesium',
    'kh',
    'gh',
    'copper',
    'iodine',
    'strontium',
    'temperature',
    'water_change',
    'tds'
);

-- useful query, list contents of an enum:
-- SELECT unnest(enum_range(NULL::parameter_type))

CREATE TABLE parameters (
    parameter_id      SERIAL
                      NOT NULL
                      PRIMARY KEY,
    parameter         parameter_type NOT NULL UNIQUE,

    description       TEXT NOT NULL,
    title             TEXT NOT NULL,
    label             TEXT NOT NULL,
    rgb_colour        CHAR(7)
                      NOT NULL
                      CHECK ( rgb_colour ~* '^#[\da-f]{6}$' )
);

INSERT INTO parameters VALUES ( default, 'salinity', 'Salinity', 'NaCl',           '#7633BD' );
INSERT INTO parameters VALUES ( default, 'ph',       'Ph',       'Ph',             '#A23C3C' );
INSERT INTO parameters VALUES ( default, 'ammonia',  'Ammonia',  'NH<sub>4</sub>', '#AFD8F8' );
INSERT INTO parameters VALUES ( default, 'nitrite',  'Nitrite',  'NO<sub>2</sub>', '#8CACC6' );
INSERT INTO parameters VALUES ( default, 'nitrate',  'Nitrate',  'NO<sub>3</sub>', '#BD9B33' );
INSERT INTO parameters VALUES ( default, 'calcium',  'Calcium',  'Ca',             '#CB4B4B' );
INSERT INTO parameters VALUES ( default, 'phosphate','Phosphate','PO<sub>4</sub>', '#3D853D' );
INSERT INTO parameters VALUES ( default, 'magnesium','Magnesium','Mg',             '#9440ED' );
INSERT INTO parameters VALUES ( default, 'kh',       'Carbonate Hardness', '&deg;KH', '#4DA74D' );
-- FIXME: get unique default colours for the next rows:
INSERT INTO parameters VALUES ( default, 'gh',       'General Hardness',   'GH',   '#4DA74D' );
INSERT INTO parameters VALUES ( default, 'copper',   'Copper',    'Cu', '#4DA74D' );
INSERT INTO parameters VALUES ( default, 'iodine',   'Iodine',    'I',   '#4DA74D' );
INSERT INTO parameters VALUES ( default, 'strontium','Strontium', 'Sr',  '#4DA74D' );
INSERT INTO parameters VALUES ( default, 'temperature','Temperature',    'Temp', '#4DA74D' );
INSERT INTO parameters VALUES ( default, 'water_change', 'Water Change', 'Water Change', '#4DA74D' );
INSERT INTO parameters VALUES ( default, 'tds', 'Total Dissolved Solids', 'TDS', '#4DA74D' );

--     result_salinity   BOOLEAN NOT NULL DEFAULT TRUE,
--     result_ph         BOOLEAN NOT NULL DEFAULT TRUE,
--     result_ammonia    BOOLEAN NOT NULL DEFAULT TRUE,
--     result_nitrite    BOOLEAN NOT NULL DEFAULT TRUE,
--     result_nitrate    BOOLEAN NOT NULL DEFAULT TRUE,
--     result_calcium    BOOLEAN NOT NULL DEFAULT TRUE,
--     result_phosphate  BOOLEAN NOT NULL DEFAULT TRUE,
--     result_magnesium  BOOLEAN NOT NULL DEFAULT TRUE,
--     result_kh         BOOLEAN NOT NULL DEFAULT TRUE,
--     result_gh         BOOLEAN NOT NULL DEFAULT TRUE,
--     result_copper     BOOLEAN NOT NULL DEFAULT TRUE,
--     result_iodine     BOOLEAN NOT NULL DEFAULT TRUE,
--     result_strontium  BOOLEAN NOT NULL DEFAULT TRUE,

);

CREATE TABLE tank_parameters (
    tank_id           INTEGER
                      NOT NULL
                      REFERENCES tank ( tank_id ),

    parameter_id      INTEGER
                      NOT NULL
                      REFERENCES parameters ( parameter_id ),

    -- the following provide overrides from the parameter defaults:
    title             TEXT NOT NULL,
    label             TEXT NOT NULL,
    rgb_colour        CHAR(7)
                      NOT NULL
                      CHECK ( rgb_colour ~* '^#[\da-f]{6}$' ),

    active            BOOLEAN DEFAULT TRUE,
    chart             BOOLEAN DEFAULT TRUE,

    PRIMARY KEY ( tank_id, parameter_id )
);

CREATE OR REPLACE FUNCTION upd_tank_parameters() RETURNS TRIGGER AS
$$
DECLARE
    param_rec parameters%ROWTYPE;

BEGIN
    IF NEW.title IS NULL OR
       NEW.label IS NULL OR
       NEW.rgb_colour IS NULL THEN
        SELECT INTO param_rec * FROM parameters
                                WHERE parameter_id = NEW.parameter_id;
        IF NEW.title IS NULL THEN
            NEW.title = param_rec.title;
        END IF;
        IF NEW.label IS NULL THEN
            NEW.label = param_rec.label;
        END IF;
        IF NEW.title IS NULL THEN
            NEW.rgb_colour = param_rec.rgb_colour;
        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chk_tank_parameters
    BEFORE INSERT OR UPDATE ON tank_parameters
    FOR EACH ROW EXECUTE PROCEDURE upd_tank_parameters();

CREATE VIEW water_test_parameters AS (
    SELECT tp.tank_id,
           p.parameter,
           tp.title,
           tp.label,
           tp.rgb_colour,
           tp.chart
      FROM tank_parameters tp JOIN parameters p USING ( parameter_id )
     WHERE tp.active IS TRUE
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
