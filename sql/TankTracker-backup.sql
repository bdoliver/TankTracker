--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: capacity_unit; Type: TYPE; Schema: public; Owner: brendono
--

CREATE TYPE capacity_unit AS ENUM (
    'litres',
    'gallons',
    'us gallons'
);


ALTER TYPE capacity_unit OWNER TO brendono;

--
-- Name: dimension_unit; Type: TYPE; Schema: public; Owner: brendono
--

CREATE TYPE dimension_unit AS ENUM (
    'mm',
    'cm',
    'm',
    'inches',
    'feet'
);


ALTER TYPE dimension_unit OWNER TO brendono;

--
-- Name: inventory_type; Type: TYPE; Schema: public; Owner: brendono
--

CREATE TYPE inventory_type AS ENUM (
    'consumable',
    'equipment',
    'fish',
    'invertebrate',
    'coral'
);


ALTER TYPE inventory_type OWNER TO brendono;

--
-- Name: parameter_type; Type: TYPE; Schema: public; Owner: brendono
--

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


ALTER TYPE parameter_type OWNER TO brendono;

--
-- Name: temperature_scale; Type: TYPE; Schema: public; Owner: brendono
--

CREATE TYPE temperature_scale AS ENUM (
    'C',
    'F'
);


ALTER TYPE temperature_scale OWNER TO brendono;

--
-- Name: water_type; Type: TYPE; Schema: public; Owner: brendono
--

CREATE TYPE water_type AS ENUM (
    'salt',
    'fresh'
);


ALTER TYPE water_type OWNER TO brendono;

--
-- Name: upd_tank_parameters(); Type: FUNCTION; Schema: public; Owner: brendono
--

CREATE FUNCTION upd_tank_parameters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.upd_tank_parameters() OWNER TO brendono;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: diary; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE diary (
    diary_id integer NOT NULL,
    tank_id integer NOT NULL,
    user_id integer NOT NULL,
    diary_date timestamp(0) without time zone DEFAULT now() NOT NULL,
    diary_note text NOT NULL,
    updated_on timestamp(0) without time zone DEFAULT now() NOT NULL,
    test_id integer
);


ALTER TABLE diary OWNER TO brendono;

--
-- Name: diary_diary_id_seq; Type: SEQUENCE; Schema: public; Owner: brendono
--

CREATE SEQUENCE diary_diary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE diary_diary_id_seq OWNER TO brendono;

--
-- Name: diary_diary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendono
--

ALTER SEQUENCE diary_diary_id_seq OWNED BY diary.diary_id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE inventory (
    inventory_id integer NOT NULL,
    inventory_type inventory_type NOT NULL,
    tank_id integer NOT NULL,
    user_id integer NOT NULL,
    description text NOT NULL,
    purchase_date date NOT NULL,
    purchase_price money NOT NULL,
    created_on timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_on timestamp(0) without time zone DEFAULT now()
);


ALTER TABLE inventory OWNER TO brendono;

--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: brendono
--

CREATE SEQUENCE inventory_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventory_inventory_id_seq OWNER TO brendono;

--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendono
--

ALTER SEQUENCE inventory_inventory_id_seq OWNED BY inventory.inventory_id;


--
-- Name: parameters; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE parameters (
    parameter_id integer NOT NULL,
    parameter parameter_type NOT NULL,
    salt_water boolean NOT NULL,
    fresh_water boolean NOT NULL,
    title text NOT NULL,
    label text NOT NULL,
    rgb_colour character(7) NOT NULL,
    CONSTRAINT parameters_rgb_colour_check CHECK ((rgb_colour ~* '^#[\da-f]{6}$'::text))
);


ALTER TABLE parameters OWNER TO brendono;

--
-- Name: parameters_parameter_id_seq; Type: SEQUENCE; Schema: public; Owner: brendono
--

CREATE SEQUENCE parameters_parameter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE parameters_parameter_id_seq OWNER TO brendono;

--
-- Name: parameters_parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendono
--

ALTER SEQUENCE parameters_parameter_id_seq OWNED BY parameters.parameter_id;


--
-- Name: preferences; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE preferences (
    user_id integer NOT NULL,
    capacity_units capacity_unit NOT NULL,
    dimension_units dimension_unit NOT NULL,
    temperature_scale temperature_scale NOT NULL,
    recs_per_page integer DEFAULT 10 NOT NULL,
    updated_on timestamp(0) without time zone DEFAULT now(),
    CONSTRAINT preferences_recs_per_page_check CHECK ((recs_per_page > 0))
);


ALTER TABLE preferences OWNER TO brendono;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE sessions (
    session_id character varying(72) NOT NULL,
    session_ts timestamp without time zone DEFAULT now(),
    expires integer,
    session_data text
);


ALTER TABLE sessions OWNER TO brendono;

--
-- Name: tank; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE tank (
    tank_id integer NOT NULL,
    owner_id integer NOT NULL,
    water_type water_type NOT NULL,
    tank_name text NOT NULL,
    notes text,
    capacity numeric DEFAULT 0,
    length numeric DEFAULT 0,
    width numeric DEFAULT 0,
    depth numeric DEFAULT 0,
    active boolean DEFAULT true,
    created_on timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_on timestamp(0) without time zone DEFAULT now()
);


ALTER TABLE tank OWNER TO brendono;

--
-- Name: tank_parameters; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE tank_parameters (
    tank_id integer NOT NULL,
    parameter_id integer NOT NULL,
    title text NOT NULL,
    label text NOT NULL,
    rgb_colour character(7) NOT NULL,
    active boolean DEFAULT true,
    chart boolean DEFAULT true,
    CONSTRAINT tank_parameters_rgb_colour_check CHECK ((rgb_colour ~* '^#[\da-f]{6}$'::text))
);


ALTER TABLE tank_parameters OWNER TO brendono;

--
-- Name: tank_tank_id_seq; Type: SEQUENCE; Schema: public; Owner: brendono
--

CREATE SEQUENCE tank_tank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tank_tank_id_seq OWNER TO brendono;

--
-- Name: tank_tank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendono
--

ALTER SEQUENCE tank_tank_id_seq OWNED BY tank.tank_id;


--
-- Name: tank_user_access; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE tank_user_access (
    tank_id integer NOT NULL,
    user_id integer NOT NULL,
    admin boolean DEFAULT false
);


ALTER TABLE tank_user_access OWNER TO brendono;

--
-- Name: tracker_role; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE tracker_role (
    role_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE tracker_role OWNER TO brendono;

--
-- Name: tracker_role_role_id_seq; Type: SEQUENCE; Schema: public; Owner: brendono
--

CREATE SEQUENCE tracker_role_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tracker_role_role_id_seq OWNER TO brendono;

--
-- Name: tracker_role_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendono
--

ALTER SEQUENCE tracker_role_role_id_seq OWNED BY tracker_role.role_id;


--
-- Name: tracker_user; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE tracker_user (
    user_id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    active boolean DEFAULT true,
    parent_id integer NOT NULL,
    last_login timestamp(0) without time zone,
    created_on timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_on timestamp(0) without time zone DEFAULT now()
);


ALTER TABLE tracker_user OWNER TO brendono;

--
-- Name: tracker_user_role; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE tracker_user_role (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE tracker_user_role OWNER TO brendono;

--
-- Name: tracker_user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: brendono
--

CREATE SEQUENCE tracker_user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tracker_user_user_id_seq OWNER TO brendono;

--
-- Name: tracker_user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendono
--

ALTER SEQUENCE tracker_user_user_id_seq OWNED BY tracker_user.user_id;


--
-- Name: user_tanks; Type: VIEW; Schema: public; Owner: brendono
--

CREATE VIEW user_tanks AS
 SELECT tank_user_access.tank_id,
    tank.tank_name,
    tank.water_type,
    tank.active,
    tank_user_access.admin,
    tank.owner_id,
    tank_user_access.user_id
   FROM (tank_user_access
     JOIN tank USING (tank_id));


ALTER TABLE user_tanks OWNER TO brendono;

--
-- Name: water_test; Type: TABLE; Schema: public; Owner: brendono; Tablespace: 
--

CREATE TABLE water_test (
    test_id integer NOT NULL,
    tank_id integer NOT NULL,
    user_id integer NOT NULL,
    test_date timestamp(0) without time zone DEFAULT ('now'::text)::date,
    result_salinity numeric,
    result_ph numeric,
    result_ammonia numeric,
    result_nitrite numeric,
    result_nitrate numeric,
    result_calcium numeric,
    result_phosphate numeric,
    result_magnesium numeric,
    result_kh numeric,
    result_alkalinity numeric,
    temperature numeric,
    water_change numeric,
    notes text
);


ALTER TABLE water_test OWNER TO brendono;

--
-- Name: water_test_parameters; Type: VIEW; Schema: public; Owner: brendono
--

CREATE VIEW water_test_parameters AS
 SELECT wtp.tank_id,
    wtp.parameter_id,
    wtp.parameter,
    wtp.title,
    wtp.label,
    wtp.rgb_colour,
    wtp.active,
    wtp.chart
   FROM ( SELECT tp.tank_id,
            tp.parameter_id,
            p.parameter,
            tp.title,
            tp.label,
            tp.rgb_colour,
            tp.active,
            tp.chart
           FROM (tank_parameters tp
             JOIN parameters p USING (parameter_id))
          WHERE (tp.active IS TRUE)
        UNION
         SELECT t.tank_id,
            p.parameter_id,
            p.parameter,
            p.title,
            p.label,
            p.rgb_colour,
            true AS bool,
            true AS bool
           FROM tank t,
            parameters p
          WHERE (((NOT (t.tank_id IN ( SELECT DISTINCT tank_parameters.tank_id
                   FROM tank_parameters))) AND (t.water_type = 'salt'::water_type)) AND p.salt_water)
        UNION
         SELECT t.tank_id,
            p.parameter_id,
            p.parameter,
            p.title,
            p.label,
            p.rgb_colour,
            true AS bool,
            true AS bool
           FROM tank t,
            parameters p
          WHERE (((NOT (t.tank_id IN ( SELECT DISTINCT tank_parameters.tank_id
                   FROM tank_parameters))) AND (t.water_type = 'fresh'::water_type)) AND p.fresh_water)) wtp
  ORDER BY wtp.tank_id, wtp.parameter_id;


ALTER TABLE water_test_parameters OWNER TO brendono;

--
-- Name: water_test_test_id_seq; Type: SEQUENCE; Schema: public; Owner: brendono
--

CREATE SEQUENCE water_test_test_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE water_test_test_id_seq OWNER TO brendono;

--
-- Name: water_test_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendono
--

ALTER SEQUENCE water_test_test_id_seq OWNED BY water_test.test_id;


--
-- Name: diary_id; Type: DEFAULT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY diary ALTER COLUMN diary_id SET DEFAULT nextval('diary_diary_id_seq'::regclass);


--
-- Name: inventory_id; Type: DEFAULT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY inventory ALTER COLUMN inventory_id SET DEFAULT nextval('inventory_inventory_id_seq'::regclass);


--
-- Name: parameter_id; Type: DEFAULT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY parameters ALTER COLUMN parameter_id SET DEFAULT nextval('parameters_parameter_id_seq'::regclass);


--
-- Name: tank_id; Type: DEFAULT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tank ALTER COLUMN tank_id SET DEFAULT nextval('tank_tank_id_seq'::regclass);


--
-- Name: role_id; Type: DEFAULT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tracker_role ALTER COLUMN role_id SET DEFAULT nextval('tracker_role_role_id_seq'::regclass);


--
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tracker_user ALTER COLUMN user_id SET DEFAULT nextval('tracker_user_user_id_seq'::regclass);


--
-- Name: test_id; Type: DEFAULT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY water_test ALTER COLUMN test_id SET DEFAULT nextval('water_test_test_id_seq'::regclass);


--
-- Data for Name: diary; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) FROM stdin;
1	3	1	2015-05-29 21:58:13	Added inventory item #1	2015-05-29 21:58:13	\N
2	3	1	2015-05-30 07:49:09	Added inventory item #2	2015-05-30 07:49:09	\N
3	3	1	2015-05-30 08:15:36	Added inventory item #3	2015-05-30 08:15:36	\N
4	3	1	2015-05-30 08:17:29	Added inventory item #4	2015-05-30 08:17:29	\N
5	3	1	2015-06-08 19:29:13	Updated water test results	2015-06-08 19:29:13	141
6	3	1	2015-06-08 19:29:14	Updated water test results	2015-06-08 19:29:14	142
7	3	1	2015-06-08 19:29:14	Updated water test results	2015-06-08 19:29:14	143
8	3	1	2015-06-08 19:29:14	Updated water test results	2015-06-08 19:29:14	144
9	3	1	2015-06-08 19:29:14	Updated water test results	2015-06-08 19:29:14	151
10	3	1	2015-06-08 19:29:14	Updated water test results	2015-06-08 19:29:14	152
11	3	1	2015-06-08 19:29:14	Updated water test results	2015-06-08 19:29:14	153
12	3	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	154
13	3	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	155
14	3	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	139
15	3	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	140
16	3	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	156
17	3	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	159
18	3	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	163
19	4	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	145
20	4	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	146
21	4	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	147
22	4	1	2015-06-08 19:29:15	Updated water test results	2015-06-08 19:29:15	148
23	4	1	2015-06-08 19:29:16	Updated water test results	2015-06-08 19:29:16	149
24	4	1	2015-06-08 19:29:16	Updated water test results	2015-06-08 19:29:16	150
25	4	1	2015-06-08 19:29:16	Updated water test results	2015-06-08 19:29:16	135
26	4	1	2015-06-08 19:29:16	Updated water test results	2015-06-08 19:29:16	136
27	4	1	2015-06-08 19:29:16	Updated water test results	2015-06-08 19:29:16	137
28	4	1	2015-06-08 19:29:16	Updated water test results	2015-06-08 19:29:16	138
29	4	1	2015-06-08 19:29:17	Updated water test results	2015-06-08 19:29:17	157
30	4	1	2015-06-08 19:29:17	Updated water test results	2015-06-08 19:29:17	160
31	4	1	2015-06-08 19:29:17	Updated water test results	2015-06-08 19:29:17	162
32	7	1	2015-06-08 19:29:17	Updated water test results	2015-06-08 19:29:17	133
33	7	1	2015-06-08 19:29:17	Updated water test results	2015-06-08 19:29:17	134
34	7	1	2015-06-08 19:29:17	Updated water test results	2015-06-08 19:29:17	158
35	7	1	2015-06-08 19:29:17	Updated water test results	2015-06-08 19:29:17	161
36	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	141
37	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	142
38	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	143
39	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	144
40	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	151
41	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	152
42	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	153
43	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	154
44	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	155
45	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	139
46	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	140
47	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	156
48	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	159
49	3	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	163
50	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	145
51	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	146
52	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	147
53	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	148
54	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	149
55	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	150
56	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	135
57	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	136
58	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	137
59	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	138
60	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	157
61	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	160
62	4	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	162
63	7	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	133
64	7	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	134
65	7	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	158
66	7	1	2015-06-08 19:30:50	Updated water test results	2015-06-08 19:30:50	161
67	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	141
68	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	142
69	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	143
70	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	144
71	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	151
72	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	152
73	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	153
74	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	154
75	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	155
76	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	139
77	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	140
78	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	156
79	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	159
80	3	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	163
81	4	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	145
82	4	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	146
83	4	1	2015-06-08 19:53:13	Updated water test results	2015-06-08 19:53:13	147
84	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	148
85	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	149
86	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	150
87	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	135
88	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	136
89	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	137
90	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	138
91	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	157
92	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	160
93	4	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	162
94	7	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	133
95	7	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	134
96	7	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	158
97	7	1	2015-06-08 19:53:14	Updated water test results	2015-06-08 19:53:14	161
98	3	1	2015-06-08 19:57:46	Updated water test results	2015-06-08 19:57:46	141
99	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	142
100	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	143
101	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	144
102	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	151
103	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	152
104	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	153
105	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	154
106	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	155
107	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	139
108	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	140
109	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	156
110	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	159
111	3	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	163
112	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	145
113	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	146
114	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	147
115	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	148
116	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	149
117	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	150
118	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	135
119	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	136
120	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	137
121	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	138
122	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	157
123	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	160
124	4	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	162
125	7	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	133
126	7	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	134
127	7	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	158
128	7	1	2015-06-08 19:57:47	Updated water test results	2015-06-08 19:57:47	161
129	3	1	2015-06-12 21:46:55	Updated water test results	2015-06-12 21:46:55	163
130	7	1	2015-06-15 22:24:29	Updated tank details	2015-06-15 22:24:29	\N
131	7	1	2015-06-15 22:24:49	Updated tank details	2015-06-15 22:24:49	\N
132	7	1	2015-06-15 22:27:58	Added inventory item #5	2015-06-15 22:27:58	\N
133	12	1	2015-07-06 10:59:25	Created tank	2015-07-06 10:59:25	\N
134	3	1	2015-08-07 14:02:35	Updated tank details	2015-08-07 14:02:35	\N
135	15	1	2015-08-07 14:16:26	Created tank	2015-08-07 14:16:26	\N
136	15	1	2015-08-07 14:25:55	Updated tank details	2015-08-07 14:25:55	\N
137	15	1	2015-08-07 14:26:58	Updated tank details	2015-08-07 14:26:58	\N
138	15	1	2015-08-07 14:28:05	Updated tank details	2015-08-07 14:28:05	\N
139	15	1	2015-08-07 14:28:49	Updated tank details	2015-08-07 14:28:49	\N
140	15	1	2015-08-07 14:30:32	Updated tank details	2015-08-07 14:30:32	\N
141	15	1	2015-08-07 14:31:27	Updated tank details	2015-08-07 14:31:27	\N
142	16	1	2015-08-07 14:35:13	Created tank	2015-08-07 14:35:13	\N
143	16	1	2015-08-07 14:37:41	Updated tank details	2015-08-07 14:37:41	\N
144	16	1	2015-08-07 14:50:23	Updated tank details	2015-08-07 14:50:23	\N
145	16	1	2015-08-07 14:52:58	Updated tank details	2015-08-07 14:52:58	\N
146	16	1	2015-08-07 14:54:39	Updated tank details	2015-08-07 14:54:39	\N
147	16	1	2015-08-07 14:56:32	Updated tank details	2015-08-07 14:56:32	\N
148	16	1	2015-08-07 14:57:33	Updated tank details	2015-08-07 14:57:33	\N
149	16	1	2015-08-07 14:59:13	Updated tank details	2015-08-07 14:59:13	\N
150	16	1	2015-08-07 15:04:51	Updated tank details	2015-08-07 15:04:51	\N
151	16	1	2015-08-07 15:06:36	Updated tank details	2015-08-07 15:06:36	\N
\.


--
-- Name: diary_diary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendono
--

SELECT pg_catalog.setval('diary_diary_id_seq', 151, true);


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY inventory (inventory_id, inventory_type, tank_id, user_id, description, purchase_date, purchase_price, created_on, updated_on) FROM stdin;
1	consumable	3	1	fish food	2015-05-04	$5.50	2015-07-06 14:51:14	2015-07-06 14:51:14
2	consumable	3	1	more fish fud	2015-05-08	$10.25	2015-07-06 14:51:14	2015-07-06 14:51:14
3	consumable	3	1	moar fud	2015-05-05	$12.95	2015-07-06 14:51:14	2015-07-06 14:51:14
4	consumable	3	1	anudder item	2015-05-06	$75.50	2015-07-06 14:51:14	2015-07-06 14:51:14
5	consumable	7	1	Food	2015-06-01	$5.50	2015-07-06 14:51:14	2015-07-06 14:51:14
\.


--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendono
--

SELECT pg_catalog.setval('inventory_inventory_id_seq', 5, true);


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY parameters (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) FROM stdin;
1	salinity	t	f	Salinity	NaCl	#7633BD
2	ph	t	t	Ph	Ph	#A23C3C
3	ammonia	t	t	Ammonia	NH<sub>4</sub>	#AFD8F8
4	nitrite	t	t	Nitrite	NO<sub>2</sub>	#8CACC6
5	nitrate	t	t	Nitrate	NO<sub>3</sub>	#BD9B33
6	calcium	t	f	Calcium	Ca	#CB4B4B
7	phosphate	t	f	Phosphate	PO<sub>4</sub>	#3D853D
8	magnesium	t	f	Magnesium	Mg	#9440ED
10	gh	f	t	General Hardness	GH	#4DA74D
11	copper	f	f	Copper	Cu	#4DA74D
12	iodine	f	f	Iodine	I	#4DA74D
13	strontium	f	f	Strontium	Sr	#4DA74D
14	temperature	t	t	Temperature	Temp	#4DA74D
15	water_change	t	t	Water Change	Water Change	#4DA74D
16	tds	f	f	Total Dissolved Solids	TDS	#4DA74D
9	kh	t	f	Carbonate Hardness	&deg;KH	#99DE99
\.


--
-- Name: parameters_parameter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendono
--

SELECT pg_catalog.setval('parameters_parameter_id_seq', 16, true);


--
-- Data for Name: preferences; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY preferences (user_id, capacity_units, dimension_units, temperature_scale, recs_per_page, updated_on) FROM stdin;
1	litres	mm	C	15	2015-07-06 14:55:19
8	litres	mm	C	10	2015-07-28 14:24:13
9	litres	cm	C	10	2015-07-28 14:30:33
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY sessions (session_id, session_ts, expires, session_data) FROM stdin;
session:4de150f5267d1f8a59b8062a887d8877e5ddce6c	2015-07-30 09:06:00.401219	1438239837	BQoDAAAABAQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcgoNdHJhY2tlcl91c2VycwAAAAxf\nX3VzZXJfcmVhbG0JVblcWAAAAAlfX3VwZGF0ZWQJVblcWAAAAAlfX2NyZWF0ZWQ=\n
session:66d1fb18b6a2ceb44eb2fc9b383d4f7593603d6c	2015-08-05 14:16:40.290277	1438758470	BQoDAAAABhcEdmlldwAAAAt0YW5rX2FjdGlvbglVwY4zAAAACV9fdXBkYXRlZAQDAAAAAQoBMQAA\nAAd1c2VyX2lkAAAABl9fdXNlchcBMwAAAAd0YW5rX2lkCVXBjigAAAAJX19jcmVhdGVkCg10cmFj\na2VyX3VzZXJzAAAADF9fdXNlcl9yZWFsbQ==\n
session:5c30210a6aa029ea17d5cff97ab6ed58345ed31c	2015-08-04 12:06:41.616983	1438659817	BQoDAAAABQQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcglVwB4xAAAACV9fY3JlYXRlZBcB\nMQAAAA5hY2Nlc3NfYnlfdGFuawlVwCZmAAAACV9fdXBkYXRlZAoNdHJhY2tlcl91c2VycwAAAAxf\nX3VzZXJfcmVhbG0=\n
session:363393090b96631edc21ab3396df5bdd0f2708e1	2015-08-06 13:45:58.532468	1438843044	BQoDAAAABhcIYWRkL3NhbHQAAAALdGFua19hY3Rpb24XAAAAAAd0YW5rX2lkBAMAAAABCgExAAAA\nB3VzZXJfaWQAAAAGX191c2VyCg10cmFja2VyX3VzZXJzAAAADF9fdXNlcl9yZWFsbQlVwu8vAAAA\nCV9fdXBkYXRlZAoKMTQzODgzMjc1OAAAAAlfX2NyZWF0ZWQ=\n
session:096fbca15485c177b07cb5d2643f419800a95979	2015-08-06 09:55:20.079389	1438823032	BQoDAAAABgQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcglVwqJwAAAACV9fdXBkYXRlZBcB\nMwAAAAd0YW5rX2lkFwR2aWV3AAAAC3RhbmtfYWN0aW9uCg10cmFja2VyX3VzZXJzAAAADF9fdXNl\ncl9yZWFsbQlVwqJoAAAACV9fY3JlYXRlZA==\n
session:e5c66f44e7e6c5794fbd51e9b5a3b64c98a8b89d	2015-08-05 08:48:11.057577	1438747005	BQoDAAAABhcBMwAAAAd0YW5rX2lkBAMAAAABCgExAAAAB3VzZXJfaWQAAAAGX191c2VyCg10cmFj\na2VyX3VzZXJzAAAADF9fdXNlcl9yZWFsbQoKMTQzODcyODQ5MQAAAAlfX2NyZWF0ZWQJVcF7ZgAA\nAAlfX3VwZGF0ZWQXD3dhdGVyX3Rlc3QvbGlzdAAAAAt0YW5rX2FjdGlvbg==\n
session:6067cd6af7bb005140fd319bb5712249bde1c5ad	2015-08-07 09:38:45.869664	1438927596	BQoDAAAABhcCMTYAAAAHdGFua19pZAlVw/AFAAAACV9fY3JlYXRlZAoNdHJhY2tlcl91c2VycwAA\nAAxfX3VzZXJfcmVhbG0JVcQ12wAAAAlfX3VwZGF0ZWQEAwAAAAEKATEAAAAHdXNlcl9pZAAAAAZf\nX3VzZXIXBHZpZXcAAAALdGFua19hY3Rpb24=\n
session:721fbc36ddb727f430ee6ad0244e5d3b18864a86	2015-07-29 16:19:19.779157	1438154561	BQoDAAAABAlVuHBoAAAACV9fdXBkYXRlZAoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0E\nAwAAAAEKATEAAAAHdXNlcl9pZAAAAAZfX3VzZXIJVbhwZwAAAAlfX2NyZWF0ZWQ=\n
session:3e974e1cd4103d853e52abeb58ec6e2bca9bc92c	2015-08-06 11:21:36.596468	1438829817	BQoDAAAABglVwragAAAACV9fY3JlYXRlZBcEdmlldwAAAAt0YW5rX2FjdGlvbgQDAAAAAQoBMQAA\nAAd1c2VyX2lkAAAABl9fdXNlcgoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0XATMAAAAH\ndGFua19pZAlVwranAAAACV9fdXBkYXRlZA==\n
session:521ee101dc4efca71cc076b9a8c28d34e9e107df	2015-07-31 09:11:24.94002	1438308906	BQoDAAAABQlVusEWAAAACV9fdXBkYXRlZAQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlchcB\nMAAAAA5hY2Nlc3NfYnlfdGFuawoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0JVbqvHAAA\nAAlfX2NyZWF0ZWQ=\n
\.


--
-- Data for Name: tank; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY tank (tank_id, owner_id, water_type, tank_name, notes, capacity, length, width, depth, active, created_on, updated_on) FROM stdin;
4	1	fresh	Community Tank	notes....\r\n\r\ngot\r\n\r\n\r\nhere....	200	1200	450	500	t	2015-05-21 11:12:56	2015-05-21 11:12:56
8	1	salt	test	sdcasdcasd	100	10	10	10	t	2015-05-27 13:02:40	2015-05-27 13:02:40
11	1	salt	test-4		250	100	50	60	t	2015-05-27 13:17:23	2015-05-27 13:17:23
10	1	salt	test-2	dasdcasdc\r\n\r\nasdcasdsa\r\n\r\nasdcasc\r\nasdsac\r\nacsacas	120	100	50	50	t	2015-05-27 13:04:04	2015-05-27 13:04:04
7	1	salt	RedSea Max 130	Notes about the RSM130...\n\n\nlast line.	130	600	250	600	t	2015-05-22 15:57:42	2015-05-22 15:57:42
12	1	salt	Test tank		2500	2500	600	700	t	2015-07-06 10:59:24	2015-07-06 10:59:24
3	1	salt	Reef Tank	asdcasdcasdc	1000	2000	600	700	t	2015-05-21 11:12:56	2015-05-21 11:12:56
15	1	salt	foobarbaz	asdcascasdasd\nasdcascasdc	0	0	0	0	t	2015-08-07 14:16:25	2015-08-07 14:16:25
16	1	salt	asdcasdcasdc	asdcasdcascasdasdc\n234r23r\nasdcasdc	0	500	0	0	t	2015-08-07 14:35:13	2015-08-07 14:35:13
\.


--
-- Data for Name: tank_parameters; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY tank_parameters (tank_id, parameter_id, title, label, rgb_colour, active, chart) FROM stdin;
16	1	Salinity	NaCl	#7633BD	t	t
16	2	Ph	Ph	#A23C3C	t	t
16	3	Ammonia	NH<sub>4</sub>	#AFD8F8	t	t
16	4	Nitrite	NO<sub>2</sub>	#8CACC6	t	t
16	5	Nitrate	NO<sub>3</sub>	#BD9B33	t	t
16	6	Calcium	Ca	#CB4B4B	t	t
16	7	Phosphate	PO<sub>4</sub>	#3D853D	t	t
16	8	Magnesium	Mg	#9440ED	t	t
16	9	Carbonate Hardness	&deg;KH	#99DE99	t	t
16	14	Temperature	Temp	#4DA74D	t	t
16	15	Water Change	Water Change	#4DA74D	t	t
\.


--
-- Name: tank_tank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendono
--

SELECT pg_catalog.setval('tank_tank_id_seq', 16, true);


--
-- Data for Name: tank_user_access; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY tank_user_access (tank_id, user_id, admin) FROM stdin;
12	1	t
3	1	t
4	1	t
7	1	t
10	1	t
11	1	t
8	1	t
3	9	\N
7	9	\N
8	9	t
12	8	\N
11	8	\N
10	8	\N
8	8	\N
15	1	t
16	1	t
\.


--
-- Data for Name: tracker_role; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY tracker_role (role_id, name) FROM stdin;
1	Admin
2	Guest
3	Owner
4	User
\.


--
-- Name: tracker_role_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendono
--

SELECT pg_catalog.setval('tracker_role_role_id_seq', 4, true);


--
-- Data for Name: tracker_user; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY tracker_user (user_id, username, password, first_name, last_name, email, active, parent_id, last_login, created_on, updated_on) FROM stdin;
8	test	gsUFqYo2FykcU8vzmsfqD7vM.IoKbIW	Test	User	test@example.com	t	1	\N	2015-07-28 14:24:13	2015-07-28 14:24:13
9	test2	rGRcvpifobG6FTe15Giw1j3fZfM/.Dy	Test02	last-name	test2@email.com	t	1	\N	2015-07-28 14:30:32	2015-07-28 14:30:32
1	bdo	JAFc6LS5KdpmrA7JE544fypmWqPdJHa	Brendon	Oliver	brendon.oliver@gmail.com	t	1	2015-08-07 09:38:45	2015-05-24 15:14:44	\N
\.


--
-- Data for Name: tracker_user_role; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY tracker_user_role (user_id, role_id) FROM stdin;
1	1
\.


--
-- Name: tracker_user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendono
--

SELECT pg_catalog.setval('tracker_user_user_id_seq', 9, true);


--
-- Data for Name: water_test; Type: TABLE DATA; Schema: public; Owner: brendono
--

COPY water_test (test_id, tank_id, user_id, test_date, result_salinity, result_ph, result_ammonia, result_nitrite, result_nitrate, result_calcium, result_phosphate, result_magnesium, result_kh, result_alkalinity, temperature, water_change, notes) FROM stdin;
133	7	1	2013-10-06 00:00:00	0	8.2	0.5	0	0	0	0	0	0	0	\N	0	\N
134	7	1	2013-10-10 00:00:00	0	8.2	0.5	0.25	5	0	0	0	0	0	\N	0	\N
135	4	1	2013-09-17 00:00:00	\N	6.6	0	0	20	\N	\N	\N	\N	\N	\N	0	\N
136	4	1	2013-09-23 00:00:00	\N	7	0.25	0	10	\N	\N	\N	\N	\N	\N	0	\N
137	4	1	2013-10-06 00:00:00	\N	7	0	0	40	\N	\N	\N	\N	\N	\N	0	\N
138	4	1	2013-10-10 00:00:00	\N	7.2	0	0	10	\N	\N	\N	\N	\N	\N	0	\N
139	3	1	2013-09-23 00:00:00	1.026	8.2	0	0	20	360	0.5	1200	11	0	\N	0	\N
140	3	1	2013-10-01 00:00:00	1.027	8.2	0	0	10	400	0.5	1360	10	0	\N	0	\N
141	3	1	2013-07-06 00:00:00	1.027	8.2	0	0	20	320	2.5	0	14	0	\N	0	\N
142	3	1	2013-07-14 00:00:00	1.029	8.2	0	0	10	300	2	0	14	0	\N	0	\N
145	4	1	2013-07-29 00:00:00	\N	6.6	0	0	5	\N	\N	\N	\N	\N	\N	0	\N
146	4	1	2013-08-20 00:00:00	\N	6	0	0	160	\N	\N	\N	\N	\N	\N	155	\N
147	4	1	2013-08-23 00:00:00	\N	6.6	0	0	80	\N	\N	\N	\N	\N	\N	0	\N
148	4	1	2013-08-26 00:00:00	\N	7	0	0	40	\N	\N	\N	\N	\N	\N	0	\N
149	4	1	2013-09-02 00:00:00	\N	6.8	0	0	10	\N	\N	\N	\N	\N	\N	0	\N
150	4	1	2013-09-09 00:00:00	\N	6.8	0	0	20	\N	\N	\N	\N	\N	\N	0	\N
151	3	1	2013-08-05 00:00:00	1.029	8.2	0	0	10	340	0.5	0	10	0	\N	0	\N
152	3	1	2013-08-12 00:00:00	1.028	8.2	0	0	10	380	0.5	0	10	0	\N	0	\N
153	3	1	2013-08-26 00:00:00	1.029	8.2	0	0	20	400	0.5	0	9	0	\N	0	\N
154	3	1	2013-09-05 00:00:00	1.026	8.2	0	0	10	380	0.5	0	9	0	\N	0	\N
155	3	1	2013-09-09 00:00:00	1.027	8	0	0	10	410	0.5	800	9	0	\N	0	\N
156	3	1	2013-10-13 00:00:00	1.028	8.2	0	0	20	460	0.5	1160	13	0	\N	0	\N
157	4	1	2013-10-13 00:00:00	\N	7.2	0.25	0	10	\N	\N	\N	\N	\N	\N	0	\N
158	7	1	2013-10-13 00:00:00	0	8.2	0.25	0	5	0	0	0	0	0	\N	0	\N
159	3	1	2013-10-21 00:00:00	1.028	8.2	0	0	10	420	0.5	1240	10	0	\N	0	\N
160	4	1	2013-10-21 00:00:00	\N	7.2	0	0	5	\N	\N	\N	\N	\N	\N	0	\N
161	7	1	2013-10-21 00:00:00	0	8.5	0.25	0	0	0	0	0	0	0	\N	0	\N
162	4	1	2013-11-05 00:00:00	\N	7.2	0	0	20	\N	\N	\N	\N	\N	\N	0	\N
163	3	1	2013-11-05 00:00:00	1.027	8.2	0	0	20	460	0.5	1240	11	0	\N	0	This is a note....
143	3	1	2013-07-22 00:00:00	1.029	8.2	0	0	10	340	1	0	11	0	\N	0	This is note for 22 July
144	3	1	2013-07-29 00:00:00	1.028	8	0	0	10	340	0.5	0	11	0	\N	0	This is note for 29 July
\.


--
-- Name: water_test_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendono
--

SELECT pg_catalog.setval('water_test_test_id_seq', 12, true);


--
-- Name: diary_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY diary
    ADD CONSTRAINT diary_pkey PRIMARY KEY (diary_id);


--
-- Name: inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- Name: parameters_parameter_key; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY parameters
    ADD CONSTRAINT parameters_parameter_key UNIQUE (parameter);


--
-- Name: parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (parameter_id);


--
-- Name: preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY preferences
    ADD CONSTRAINT preferences_pkey PRIMARY KEY (user_id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (session_id);


--
-- Name: tank_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY tank_parameters
    ADD CONSTRAINT tank_parameters_pkey PRIMARY KEY (tank_id, parameter_id);


--
-- Name: tank_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY tank
    ADD CONSTRAINT tank_pkey PRIMARY KEY (tank_id);


--
-- Name: tank_user_access_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY tank_user_access
    ADD CONSTRAINT tank_user_access_pkey PRIMARY KEY (tank_id, user_id);


--
-- Name: tracker_role_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY tracker_role
    ADD CONSTRAINT tracker_role_pkey PRIMARY KEY (role_id);


--
-- Name: tracker_user_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY tracker_user
    ADD CONSTRAINT tracker_user_pkey PRIMARY KEY (user_id);


--
-- Name: tracker_user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY tracker_user_role
    ADD CONSTRAINT tracker_user_role_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: water_test_pkey; Type: CONSTRAINT; Schema: public; Owner: brendono; Tablespace: 
--

ALTER TABLE ONLY water_test
    ADD CONSTRAINT water_test_pkey PRIMARY KEY (test_id);


--
-- Name: email_address_idx; Type: INDEX; Schema: public; Owner: brendono; Tablespace: 
--

CREATE UNIQUE INDEX email_address_idx ON tracker_user USING btree (lower(email));


--
-- Name: tank_diary_date; Type: INDEX; Schema: public; Owner: brendono; Tablespace: 
--

CREATE INDEX tank_diary_date ON diary USING btree (tank_id, diary_date);


--
-- Name: tank_name_idx; Type: INDEX; Schema: public; Owner: brendono; Tablespace: 
--

CREATE UNIQUE INDEX tank_name_idx ON tank USING btree (lower(tank_name));


--
-- Name: water_test_tank_id_test_date_idx; Type: INDEX; Schema: public; Owner: brendono; Tablespace: 
--

CREATE UNIQUE INDEX water_test_tank_id_test_date_idx ON water_test USING btree (tank_id, ((test_date)::date));


--
-- Name: chk_tank_parameters; Type: TRIGGER; Schema: public; Owner: brendono
--

CREATE TRIGGER chk_tank_parameters BEFORE INSERT OR UPDATE ON tank_parameters FOR EACH ROW EXECUTE PROCEDURE upd_tank_parameters();


--
-- Name: diary_tank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY diary
    ADD CONSTRAINT diary_tank_id_fkey FOREIGN KEY (tank_id) REFERENCES tank(tank_id);


--
-- Name: diary_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY diary
    ADD CONSTRAINT diary_test_id_fkey FOREIGN KEY (test_id) REFERENCES water_test(test_id) ON DELETE CASCADE;


--
-- Name: diary_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY diary
    ADD CONSTRAINT diary_user_id_fkey FOREIGN KEY (user_id) REFERENCES tracker_user(user_id);


--
-- Name: inventory_tank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_tank_id_fkey FOREIGN KEY (tank_id) REFERENCES tank(tank_id);


--
-- Name: inventory_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_user_id_fkey FOREIGN KEY (user_id) REFERENCES tracker_user(user_id);


--
-- Name: preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY preferences
    ADD CONSTRAINT preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES tracker_user(user_id) ON DELETE CASCADE;


--
-- Name: tank_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tank
    ADD CONSTRAINT tank_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES tracker_user(user_id);


--
-- Name: tank_parameters_parameter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tank_parameters
    ADD CONSTRAINT tank_parameters_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES parameters(parameter_id);


--
-- Name: tank_parameters_tank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tank_parameters
    ADD CONSTRAINT tank_parameters_tank_id_fkey FOREIGN KEY (tank_id) REFERENCES tank(tank_id);


--
-- Name: tank_user_access_tank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tank_user_access
    ADD CONSTRAINT tank_user_access_tank_id_fkey FOREIGN KEY (tank_id) REFERENCES tank(tank_id);


--
-- Name: tank_user_access_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tank_user_access
    ADD CONSTRAINT tank_user_access_user_id_fkey FOREIGN KEY (user_id) REFERENCES tracker_user(user_id);


--
-- Name: tracker_user_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tracker_user
    ADD CONSTRAINT tracker_user_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES tracker_user(user_id);


--
-- Name: tracker_user_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tracker_user_role
    ADD CONSTRAINT tracker_user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES tracker_role(role_id);


--
-- Name: tracker_user_role_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY tracker_user_role
    ADD CONSTRAINT tracker_user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES tracker_user(user_id);


--
-- Name: water_test_tank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY water_test
    ADD CONSTRAINT water_test_tank_id_fkey FOREIGN KEY (tank_id) REFERENCES tank(tank_id);


--
-- Name: water_test_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendono
--

ALTER TABLE ONLY water_test
    ADD CONSTRAINT water_test_user_id_fkey FOREIGN KEY (user_id) REFERENCES tracker_user(user_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: brendono
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM brendono;
GRANT ALL ON SCHEMA public TO brendono;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

