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
    capacity_units  capacity_unit NOT NULL,
    capacity        NUMERIC DEFAULT 0,

    dimension_units dimension_unit NOT NULL,
    length          NUMERIC DEFAULT 0,
    width           NUMERIC DEFAULT 0,
    depth           NUMERIC DEFAULT 0,

    temperature_scale temperature_scale NOT NULL,

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
                REFERENCES tank         ( tank_id ),

    user_id     INTEGER
                NOT NULL
                REFERENCES tracker_user ( user_id ),

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
                      REFERENCES tracker_user ( user_id ),

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

CREATE VIEW tank_water_test_result_view AS (
    SELECT wtr.tank_id,
           wt.test_id,
           wt.test_date,
           wt.user_id,
           wtp.parameter,
           t.param_order,
           t.title,
           t.label,
           t.rgb_colour,
           t.active,
           t.chart,
           wtr.test_result
      FROM water_test_result    wtr
      JOIN water_test           wt  USING ( test_id )
      JOIN water_test_parameter wtp USING ( parameter_id )
      JOIN tank_water_test_parameter t USING ( tank_id, parameter_id )
  ORDER BY wtr.tank_id, wt.test_date, wt.test_id, t.param_order, wtr.parameter_id
);

CREATE AGGREGATE array_accum (anyelement) (
    sfunc    = array_append,
    stype    = anyarray,
    initcond = '{}'
);

CREATE VIEW tank_export_test_result_view AS (
    SELECT tank_id,
           user_id,
           test_date,
           test_id,
           array_accum(test_result) AS test_results
      FROM tank_water_test_result_view
  GROUP BY 1, 2, 3, 4
  ORDER BY 1, 2, 3, 4
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

CREATE TABLE user_preferences (
    user_id         INTEGER
                    NOT NULL
                    REFERENCES tracker_user ( user_id )
                    ON DELETE CASCADE,

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
