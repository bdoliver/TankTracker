\set ON_ERROR_STOP 1
BEGIN TRANSACTION;

CREATE TYPE user_role AS ENUM (
    'admin',
    'guest',
    'owner',
    'user'
);

CREATE TABLE "user" (
    user_id        SERIAL
                   NOT NULL
                   PRIMARY KEY,

    username       TEXT NOT NULL,
    password       TEXT NOT NULL,
    role           user_role NOT NULL,
    first_name     TEXT,
    last_name      TEXT,
    email          TEXT NOT NULL,
    active         BOOLEAN DEFAULT TRUE,
    parent_id      INTEGER NOT NULL
                   REFERENCES "user" (user_id),

    login_attempts INTEGER DEFAULT 0,
    last_login     TIMESTAMP(0),
    created_on     TIMESTAMP(0) NOT NULL DEFAULT now(),
    updated_on     TIMESTAMP(0) DEFAULT now()
);
CREATE UNIQUE INDEX email_address_idx ON "user" ( lower(email) );

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

CREATE TYPE frequency AS ENUM (
    'daily',
    'weekly',
    'monthly'
);

CREATE TABLE tank (
    tank_id         SERIAL
                    NOT NULL
                    PRIMARY KEY,

    owner_id        INTEGER
                    NOT NULL
                    REFERENCES "user" ( user_id ),

    water_type      water_type NOT NULL,
    tank_name       TEXT NOT NULL,

    notes           TEXT,
    capacity_units  capacity_unit NOT NULL,
    capacity        NUMERIC DEFAULT 0,

    dimension_units dimension_unit NOT NULL,
    length          NUMERIC DEFAULT 0,
    width           NUMERIC DEFAULT 0,
    depth           NUMERIC DEFAULT 0,

    temperature_scale temperature_scale NOT NULL,

    test_reminder   BOOLEAN DEFAULT TRUE NOT NULL,
    last_reminder   DATE,
    reminder_freq   frequency DEFAULT 'daily',
    reminder_time   TIME DEFAULT '09:00'::TIME,

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
              REFERENCES "user" ( user_id  ),

    role      user_role NOT
              NULL,

    PRIMARY KEY ( tank_id, user_id )
);

CREATE TABLE tank_photo (
    photo_id     SERIAL
                 NOT NULL
                 PRIMARY KEY,

    tank_id      INTEGER
                 NOT NULL
                 REFERENCES tank ( tank_id ),

    user_id      INTEGER
                 NOT NULL
                 REFERENCES "user" ( user_id ),

    file_name    TEXT
                 NOT NULL,

    caption      TEXT,

    FOREIGN KEY ( tank_id, user_id ) REFERENCES tank_user_access ( tank_id, user_id )
);
CREATE INDEX tank_photo_idx ON tank_photo ( tank_id, photo_id );

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

CREATE TABLE water_test_parameter (
    parameter_id      SERIAL
                      NOT NULL
                      PRIMARY KEY,
    parameter         parameter_type NOT NULL UNIQUE,

    salt_water        BOOLEAN NOT NULL,
    fresh_water       BOOLEAN NOT NULL,
    title             TEXT NOT NULL,
    label             TEXT NOT NULL,
    rgb_colour        CHAR(7)
                      NOT NULL
                      CHECK ( rgb_colour ~* '^#[\da-f]{6}$' )
);

INSERT INTO water_test_parameter VALUES ( default, 'salinity', true, false, 'Salinity', 'NaCl',           '#7633BD' );
INSERT INTO water_test_parameter VALUES ( default, 'ph',       true, true,  'Ph',       'Ph',             '#A23C3C' );
INSERT INTO water_test_parameter VALUES ( default, 'ammonia',  true, true,  'Ammonia',  'NH<sub>4</sub>', '#AFD8F8' );
INSERT INTO water_test_parameter VALUES ( default, 'nitrite',  true, true,  'Nitrite',  'NO<sub>2</sub>', '#8CACC6' );
INSERT INTO water_test_parameter VALUES ( default, 'nitrate',  true, true,  'Nitrate',  'NO<sub>3</sub>', '#BD9B33' );
INSERT INTO water_test_parameter VALUES ( default, 'calcium',  true, false, 'Calcium',  'Ca',             '#CB4B4B' );
INSERT INTO water_test_parameter VALUES ( default, 'phosphate',true, false, 'Phosphate','PO<sub>4</sub>', '#3D853D' );
INSERT INTO water_test_parameter VALUES ( default, 'magnesium',true, false, 'Magnesium','Mg',             '#9440ED' );
INSERT INTO water_test_parameter VALUES ( default, 'kh',       true, false, 'Carbonate Hardness', '&deg;KH', '#4DA74D' );
-- FIXME: get unique default colours for the next rows:
INSERT INTO water_test_parameter VALUES ( default, 'gh',       false, true, 'General Hardness',   'GH',   '#4DA74D' );
INSERT INTO water_test_parameter VALUES ( default, 'copper',   false, false, 'Copper',    'Cu', '#4DA74D' );
INSERT INTO water_test_parameter VALUES ( default, 'iodine',   false, false,'Iodine',    'I',   '#4DA74D' );
INSERT INTO water_test_parameter VALUES ( default, 'strontium',false, false,'Strontium', 'Sr',  '#4DA74D' );
INSERT INTO water_test_parameter VALUES ( default, 'temperature',  true, true, 'Temperature',    'Temp', '#4DA74D' );
INSERT INTO water_test_parameter VALUES ( default, 'water_change', true, true, 'Water Change', 'Water Change', '#4DA74D' );
INSERT INTO water_test_parameter VALUES ( default, 'tds', false, false, 'Total Dissolved Solids', 'TDS', '#4DA74D' );

CREATE TABLE tank_water_test_parameter (
    tank_id           INTEGER
                      NOT NULL
                      REFERENCES tank ( tank_id ),

    parameter_id      INTEGER
                      NOT NULL
                      REFERENCES water_test_parameter ( parameter_id ),
    -- this is redundant but saves an awkward 'prefetch'
    parameter         TEXT NOT NULL,

    -- the following provide overrides from the parameter defaults:
    title             TEXT NOT NULL,
    label             TEXT NOT NULL,
    rgb_colour        CHAR(7)
                      NOT NULL
                      CHECK ( rgb_colour ~* '^#[\da-f]{6}$' ),

    active            BOOLEAN DEFAULT TRUE,
    chart             BOOLEAN DEFAULT TRUE,
    param_order       INTEGER,

    PRIMARY KEY ( tank_id, parameter_id )
);

CREATE OR REPLACE FUNCTION upd_tank_water_test_parameter() RETURNS TRIGGER AS
$$
DECLARE
    param_rec water_test_parameter%ROWTYPE;

BEGIN
    IF NEW.title IS NULL OR
       NEW.label IS NULL OR
       NEW.rgb_colour IS NULL THEN
        SELECT INTO param_rec * FROM water_test_parameter
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
        IF NEW.param_order IS NULL THEN
            NEW.param_order = NEW.parameter_id - 1;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chk_tank_water_test_parameter
    BEFORE INSERT OR UPDATE ON tank_water_test_parameter
    FOR EACH ROW EXECUTE PROCEDURE upd_tank_water_test_parameter();

/*
 This gives us a view which returns either all tank-specific
 water test water_test_parameter (if set); or if there's no tank-specific
 params, we get the system-default settings for either salt or
 freshwater (depending on the requested tank)
*/
CREATE VIEW water_test_parameter_view AS (
  SELECT * FROM (
    -- existing tank-specific water_test_parameter:
    SELECT tp.tank_id,
           tp.param_order,
           tp.parameter_id,
           p.parameter,
           tp.title,
           tp.label,
           tp.rgb_colour,
           tp.active,
           tp.chart
      FROM tank_water_test_parameter tp
      JOIN water_test_parameter      p USING ( parameter_id )
     WHERE tp.active IS TRUE
UNION
     -- ... plus all default salt-specific params (for saltwater tanks)
     SELECT t.tank_id,
            null,  -- parameter order
            p.parameter_id,
            p.parameter,
            p.title,
            p.label,
            p.rgb_colour,
            true,  -- default active
            true   -- default chart
       FROM tank t, water_test_parameter p --wheee! cartesian product ftw! :-)
      WHERE t.tank_id NOT IN (SELECT DISTINCT tank_id FROM tank_water_test_parameter)
        AND t.water_type = 'salt'
        AND p.salt_water
UNION
     -- ... plus all default fresh-specific params (for freshwater tanks)
     SELECT t.tank_id,
            null,  -- parameter order
            p.parameter_id,
            p.parameter,
            p.title,
            p.label,
            p.rgb_colour,
            true,  -- default active
            true   -- default chart
       FROM tank t, water_test_parameter p --wheee! cartesian product ftw! :-)
      WHERE t.tank_id NOT IN (SELECT DISTINCT tank_id FROM tank_water_test_parameter)
        AND t.water_type = 'fresh'
        AND p.fresh_water
  ) AS wtp
  ORDER BY 1, 2, 3
);

CREATE TABLE diary (
    diary_id    SERIAL
                NOT NULL
                PRIMARY KEY,

    tank_id     INTEGER
                NOT NULL
                REFERENCES tank   ( tank_id ),

    user_id     INTEGER
                NOT NULL
                REFERENCES "user" ( user_id ),

    diary_date  TIMESTAMP(0) NOT NULL DEFAULT now(),
    diary_note  TEXT,
    updated_on  TIMESTAMP(0) NOT NULL DEFAULT now(),
    test_id     INT
);
CREATE INDEX tank_diary_date ON diary ( tank_id, diary_date );
CREATE INDEX test_diary_note ON diary ( test_id );

CREATE OR REPLACE FUNCTION chk_diary_note() RETURNS TRIGGER AS
$$
BEGIN
    -- diary_note can be null if this is associated with a water test.
    -- otherwise, diary_note cannot be null.
    IF NEW.test_id IS NULL AND NEW.diary_note IS NULL THEN
        RAISE EXCEPTION 'diary_note cannot be null';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chk_diary_note
    BEFORE INSERT OR UPDATE ON diary
    FOR EACH ROW EXECUTE PROCEDURE chk_diary_note();


CREATE TABLE water_test (
    test_id           SERIAL
                      NOT NULL
                      PRIMARY KEY,

    user_id           INTEGER
                      NOT NULL
                      REFERENCES "user" ( user_id ),

    test_date         TIMESTAMP(0) NOT NULL DEFAULT current_date
);

ALTER TABLE diary ADD FOREIGN KEY ( test_id )
      REFERENCES water_test ( test_id ) ON DELETE CASCADE;

CREATE TABLE water_test_result (
    test_result_id   SERIAL
                     NOT NULL
                     PRIMARY KEY,

    test_id          INTEGER
                     NOT NULL
                     REFERENCES water_test ( test_id ),

    tank_id          INTEGER NOT NULL,
    parameter_id     INTEGER NOT NULL,
    test_result      NUMERIC,

    FOREIGN KEY ( tank_id, parameter_id )
     REFERENCES tank_water_test_parameter ( tank_id, parameter_id )
);

CREATE VIEW last_water_test AS (
    SELECT tank_id,
           max(test_date) AS last_test_date,
           extract( days FROM ( now() - max(test_date) ) ) AS days_overdue
      FROM water_test_result
      JOIN water_test using ( test_id ) GROUP BY tank_id
);

CREATE VIEW tank_water_test_result_view AS (
    SELECT wtr.tank_id,
           t.tank_name,
           t.water_type,
           t.owner_id,
           tu.first_name AS owner_first_name,
           tu.last_name  AS owner_last_name,
           wt.test_id,
           wt.test_date,
           wt.user_id,
           u.first_name  AS tester_first_name,
           u.last_name   AS tester_last_name,
           wtp.parameter,
           twtp.param_order,
           twtp.title,
           twtp.label,
           twtp.rgb_colour,
           twtp.active,
           twtp.chart,
           wtr.test_result
      FROM water_test_result    wtr
      JOIN water_test           wt  USING ( test_id )
      JOIN water_test_parameter wtp USING ( parameter_id )
      JOIN tank_water_test_parameter twtp USING ( tank_id, parameter_id )
      JOIN tank                 t   USING ( tank_id )
      JOIN "user"               u   USING ( user_id )
      JOIN "user"               tu  ON ( t.owner_id = tu.user_id )
  ORDER BY wtr.tank_id, wt.test_date, wt.test_id, twtp.param_order, wtr.parameter_id
);

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

    user_id           INTEGER
                      NOT NULL
                      REFERENCES "user" ( user_id ),

    description       TEXT NOT NULL,
    purchase_date     DATE NOT NULL,
    purchase_price    MONEY NOT NULL,
    external_ref      TEXT,
    photo_filename    TEXT,
    created_on        TIMESTAMP(0) NOT NULL DEFAULT now(),
    updated_on        TIMESTAMP(0) DEFAULT now()
);

CREATE TABLE tank_inventory (
    tank_id           INTEGER
                      NOT NULL
                      REFERENCES tank ( tank_id ),

    inventory_id      INTEGER
                      NOT NULL
                      REFERENCES inventory ( inventory_id ),

    created_on        TIMESTAMP(0) NOT NULL DEFAULT now(),
    updated_on        TIMESTAMP(0) DEFAULT now(),

    PRIMARY KEY ( tank_id, inventory_id )
);

CREATE TYPE tank_order_type AS ENUM (
    'tank_id',
    'tank_name',
    'created_on',
    'updated_on'
);

CREATE TYPE water_test_order_type AS ENUM (
    'test_id',
    'test_date'
);

CREATE TABLE user_preferences (
    user_id         INTEGER
                    NOT NULL
                    REFERENCES "user" ( user_id )
                    ON DELETE CASCADE,

    recs_per_page   INTEGER
                    NOT NULL
                    DEFAULT 10
                    CHECK (recs_per_page > 0),

    tank_order_col  tank_order_type
                    NOT NULL
                    DEFAULT 'tank_id',
    tank_order_seq  TEXT
                    NOT NULL
                    DEFAULT 'asc'
                    CHECK ( lower(tank_order_seq) = 'asc'
                                OR
                            lower(tank_order_seq) = 'desc' ),

    water_test_order_col water_test_order_type
                    NOT NULL
                    DEFAULT 'test_id',
    water_test_order_seq TEXT
                    NOT NULL
                    DEFAULT 'desc'
                    CHECK ( lower(tank_order_seq) = 'asc'
                                OR
                            lower(tank_order_seq) = 'desc' ),

    updated_on       TIMESTAMP(0) DEFAULT now(),
    PRIMARY KEY ( user_id )
);

CREATE VIEW user_tanks AS (
    SELECT tank_id,
           tank_name,
           water_type,
           active,
           role,
           owner_id,
           user_id
    FROM tank_user_access JOIN tank USING ( tank_id )
);

CREATE TYPE water_test_csv_record AS (
    tank_id           INTEGER,
    tank_name         TEXT,
    water_type        water_type,
    owner_id          INTEGER,
    owner_first_name  TEXT,
    owner_last_name   TEXT,
    test_id           INTEGER,
    test_date         TIMESTAMP(0) WITHOUT TIME ZONE,
    user_id           INTEGER,
    tester_first_name TEXT,
    tester_last_name  TEXT,
    salinity          NUMERIC,
    ph                NUMERIC,
    ammonia           NUMERIC,
    nitrite           NUMERIC,
    nitrate           NUMERIC,
    calcium           NUMERIC,
    phosphate         NUMERIC,
    magnesium         NUMERIC,
    kh                NUMERIC,
    gh                NUMERIC,
    copper            NUMERIC,
    iodine            NUMERIC,
    strontium         NUMERIC,
    temperature       NUMERIC,
    water_change      NUMERIC,
    tds               NUMERIC
);

CREATE OR REPLACE FUNCTION export_water_test()
RETURNS SETOF water_test_csv_record AS
$$
DECLARE
    test_rec tank_water_test_result_view%ROWTYPE;
    rec water_test_csv_record;
    test_id INT;

BEGIN
    FOR test_rec IN SELECT * FROM tank_water_test_result_view ORDER BY tank_id, test_date
    LOOP
        IF test_id IS NULL THEN
            test_id = test_rec.test_id;
        END IF;

        IF test_id != test_rec.test_id THEN
            RETURN NEXT rec;
            -- clear current rec:
            rec = null;
            test_id = test_rec.test_id;
        END IF;

        IF test_rec.test_id = test_id THEN
            IF rec.tank_id IS NULL THEN
                rec.tank_id           = test_rec.tank_id;
                rec.tank_name         = test_rec.tank_name;
                rec.water_type        = test_rec.water_type;
                rec.owner_id          = test_rec.owner_id;
                rec.owner_first_name  = test_rec.owner_first_name;
                rec.owner_last_name   = test_rec.owner_last_name;
                rec.test_id           = test_rec.test_id;
                rec.test_date         = test_rec.test_date;
                rec.user_id           = test_rec.user_id;
                rec.tester_first_name = test_rec.tester_first_name;
                rec.tester_last_name  = test_rec.tester_last_name;
            END IF;

            CASE test_rec.parameter
                WHEN 'salinity'     THEN rec.salinity     = test_rec.test_result;
                WHEN 'ph'           THEN rec.ph           = test_rec.test_result;
                WHEN 'ammonia'      THEN rec.ammonia      = test_rec.test_result;
                WHEN 'nitrite'      THEN rec.nitrite      = test_rec.test_result;
                WHEN 'nitrate'      THEN rec.nitrate      = test_rec.test_result;
                WHEN 'calcium'      THEN rec.calcium      = test_rec.test_result;
                WHEN 'phosphate'    THEN rec.phosphate    = test_rec.test_result;
                WHEN 'magnesium'    THEN rec.magnesium    = test_rec.test_result;
                WHEN 'kh'           THEN rec.kh           = test_rec.test_result;
                WHEN 'gh'           THEN rec.gh           = test_rec.test_result;
                WHEN 'copper'       THEN rec.copper       = test_rec.test_result;
                WHEN 'iodine'       THEN rec.iodine       = test_rec.test_result;
                WHEN 'strontium'    THEN rec.strontium    = test_rec.test_result;
                WHEN 'temperature'  THEN rec.temperature  = test_rec.test_result;
                WHEN 'water_change' THEN rec.water_change = test_rec.test_result;
                WHEN 'tds'          THEN rec.tds          = test_rec.test_result;
            END CASE;
        END IF;
    END LOOP;

    -- flush out remaining record...
    RETURN NEXT rec;
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE VIEW water_test_csv_view AS SELECT * FROM export_water_test();

COMMIT;
