--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: tank; Type: TABLE; Schema: public; Owner: brendon; Tablespace: 
--

CREATE TABLE tank (
    tank_id integer NOT NULL,
    water_id integer NOT NULL,
    tank_name text NOT NULL,
    notes text,
    updated_on timestamp(0) without time zone DEFAULT now()
);


ALTER TABLE public.tank OWNER TO brendon;

--
-- Name: tank_diary; Type: TABLE; Schema: public; Owner: brendon; Tablespace: 
--

CREATE TABLE tank_diary (
    diary_id integer NOT NULL,
    tank_id integer NOT NULL,
    diary_date timestamp(0) without time zone NOT NULL,
    diary_note text NOT NULL
);


ALTER TABLE public.tank_diary OWNER TO brendon;

--
-- Name: tank_diary_diary_id_seq; Type: SEQUENCE; Schema: public; Owner: brendon
--

CREATE SEQUENCE tank_diary_diary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tank_diary_diary_id_seq OWNER TO brendon;

--
-- Name: tank_diary_diary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendon
--

ALTER SEQUENCE tank_diary_diary_id_seq OWNED BY tank_diary.diary_id;


--
-- Name: tank_diary_diary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('tank_diary_diary_id_seq', 1, false);


--
-- Name: tank_tank_id_seq; Type: SEQUENCE; Schema: public; Owner: brendon
--

CREATE SEQUENCE tank_tank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tank_tank_id_seq OWNER TO brendon;

--
-- Name: tank_tank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendon
--

ALTER SEQUENCE tank_tank_id_seq OWNED BY tank.tank_id;


--
-- Name: tank_tank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('tank_tank_id_seq', 3, true);


--
-- Name: tank_water_id_seq; Type: SEQUENCE; Schema: public; Owner: brendon
--

CREATE SEQUENCE tank_water_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tank_water_id_seq OWNER TO brendon;

--
-- Name: tank_water_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendon
--

ALTER SEQUENCE tank_water_id_seq OWNED BY tank.water_id;


--
-- Name: tank_water_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('tank_water_id_seq', 1, false);


--
-- Name: water_tests; Type: TABLE; Schema: public; Owner: brendon; Tablespace: 
--

CREATE TABLE water_tests (
    test_id integer NOT NULL,
    tank_id integer NOT NULL,
    test_date date DEFAULT ('now'::text)::date,
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
    water_change numeric,
    notes text
);


ALTER TABLE public.water_tests OWNER TO brendon;

--
-- Name: water_tests_test_id_seq; Type: SEQUENCE; Schema: public; Owner: brendon
--

CREATE SEQUENCE water_tests_test_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.water_tests_test_id_seq OWNER TO brendon;

--
-- Name: water_tests_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendon
--

ALTER SEQUENCE water_tests_test_id_seq OWNED BY water_tests.test_id;


--
-- Name: water_tests_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('water_tests_test_id_seq', 71, true);


--
-- Name: water_type; Type: TABLE; Schema: public; Owner: brendon; Tablespace: 
--

CREATE TABLE water_type (
    water_id integer NOT NULL,
    water_type text NOT NULL
);


ALTER TABLE public.water_type OWNER TO brendon;

--
-- Name: water_type_water_id_seq; Type: SEQUENCE; Schema: public; Owner: brendon
--

CREATE SEQUENCE water_type_water_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.water_type_water_id_seq OWNER TO brendon;

--
-- Name: water_type_water_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brendon
--

ALTER SEQUENCE water_type_water_id_seq OWNED BY water_type.water_id;


--
-- Name: water_type_water_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('water_type_water_id_seq', 2, true);


--
-- Name: tank_id; Type: DEFAULT; Schema: public; Owner: brendon
--

ALTER TABLE tank ALTER COLUMN tank_id SET DEFAULT nextval('tank_tank_id_seq'::regclass);


--
-- Name: water_id; Type: DEFAULT; Schema: public; Owner: brendon
--

ALTER TABLE tank ALTER COLUMN water_id SET DEFAULT nextval('tank_water_id_seq'::regclass);


--
-- Name: diary_id; Type: DEFAULT; Schema: public; Owner: brendon
--

ALTER TABLE tank_diary ALTER COLUMN diary_id SET DEFAULT nextval('tank_diary_diary_id_seq'::regclass);


--
-- Name: test_id; Type: DEFAULT; Schema: public; Owner: brendon
--

ALTER TABLE water_tests ALTER COLUMN test_id SET DEFAULT nextval('water_tests_test_id_seq'::regclass);


--
-- Name: water_id; Type: DEFAULT; Schema: public; Owner: brendon
--

ALTER TABLE water_type ALTER COLUMN water_id SET DEFAULT nextval('water_type_water_id_seq'::regclass);


--
-- Data for Name: tank; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY tank (tank_id, water_id, tank_name, notes, updated_on) FROM stdin;
1	1	RedSea Max 130	\N	\N
2	2	Tropical	\N	\N
3	1	1000L Reef	\N	\N
\.


--
-- Data for Name: tank_diary; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY tank_diary (diary_id, tank_id, diary_date, diary_note) FROM stdin;
\.


--
-- Data for Name: water_tests; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY water_tests (test_id, tank_id, test_date, result_salinity, result_ph, result_ammonia, result_nitrite, result_nitrate, result_calcium, result_phosphate, result_magnesium, result_kh, result_alkalinity, water_change, notes) FROM stdin;
38	2	2011-09-24	\N	7.2	\N	\N	10	\N	\N	\N	\N	\N	\N	\N
39	2	2011-10-02	\N	7	0	0	10	\N	\N	\N	\N	\N	\N	\N
40	2	2011-10-09	\N	7.2	0	0	20	\N	\N	\N	\N	\N	\N	\N
41	2	2011-10-16	\N	7	0	0	10	\N	\N	\N	\N	\N	\N	\N
42	2	2011-11-05	\N	7.2	0	0	80	\N	\N	\N	\N	\N	\N	\N
43	2	2011-11-08	\N	7.2	0	0	40	\N	\N	\N	\N	\N	\N	\N
44	2	2011-11-20	\N	7	0.25	0	80	\N	\N	\N	\N	\N	\N	\N
45	2	2011-11-28	\N	6.8	0	0	40	\N	\N	\N	\N	\N	\N	\N
46	1	2011-09-24	1.025	8.2	0	0	5	340	\N	\N	\N	\N	\N	\N
47	1	2011-09-27	1.025	8.2	0	0	0	340	\N	\N	\N	\N	\N	\N
48	1	2011-09-29	1.025	8.2	0	0	0	420	\N	\N	\N	\N	\N	\N
49	1	2011-10-02	1.025	8.2	0	0	5	360	\N	\N	\N	\N	\N	\N
50	1	2011-10-09	1.025	8.2	0	0	0	360	\N	\N	\N	\N	\N	\N
51	1	2011-10-16	1.026	8.2	0	0	0	380	\N	\N	\N	\N	\N	\N
52	1	2011-11-08	1.024	8.2	0	0	0	440	\N	\N	\N	\N	\N	\N
53	1	2011-11-20	1.028	8.2	0	0	0	380	\N	\N	\N	\N	\N	\N
54	1	2011-11-28	1.027	8.4	0	0	0	440	\N	\N	\N	\N	\N	\N
55	3	2011-11-28	1.025	8.4	0	0	5	280	\N	\N	\N	\N	\N	\N
56	3	2011-12-06	1.026	8.4	0	0	5	\N	\N	\N	\N	\N	\N	\N
57	2	2011-12-10	\N	6.6	0	0	10	\N	\N	\N	\N	\N	110	\N
58	1	2011-12-10	\N	8.2	0	0	0	\N	\N	\N	\N	\N	1.026	\N
60	3	2011-12-10	1.023	8	0	0	0	440	0	\N	4	\N	\N	\N
61	1	2011-12-18	\N	8.4	0	0	0	\N	\N	\N	\N	\N	\N	\N
62	3	2011-12-18	1.024	8.4	0	0	5	415	0.03	1215	\N	1.7	\N	\N
63	2	2011-12-18	\N	6.8	0	0	40	\N	\N	\N	\N	\N	\N	\N
64	3	2011-12-27	1.024	8.2	0	0	5	360	0.03	1305	9	1.7	\N	\N
65	2	2011-12-27	\N	7	0	0	80	\N	\N	\N	\N	\N	\N	\N
66	2	2012-01-01	\N	7	0	0	20	\N	\N	\N	\N	\N	\N	\N
67	1	2012-01-01	1.024	8.4	0	0	0	\N	\N	\N	\N	\N	\N	\N
69	2	2012-01-09	\N	6.8	0	0	20	\N	\N	\N	\N	\N	\N	\N
70	1	2012-01-09	\N	8.4	0	0	0	\N	\N	\N	\N	\N	1.027	\N
71	3	2012-01-09	1.024	8.2	0	0	0	360	0.03	1140	8	1.7	\N	\N
68	3	2012-01-01	1.023	8.2	0	0	5	380	0.03	1170	9	1.7	\N	\N
59	3	2011-12-10	1.024	8.2	0	0	5	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: water_type; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY water_type (water_id, water_type) FROM stdin;
1	Salt Water
2	Fresh Water
\.


--
-- Name: tank_diary_pkey; Type: CONSTRAINT; Schema: public; Owner: brendon; Tablespace: 
--

ALTER TABLE ONLY tank_diary
    ADD CONSTRAINT tank_diary_pkey PRIMARY KEY (diary_id);


--
-- Name: tank_pkey; Type: CONSTRAINT; Schema: public; Owner: brendon; Tablespace: 
--

ALTER TABLE ONLY tank
    ADD CONSTRAINT tank_pkey PRIMARY KEY (tank_id);


--
-- Name: water_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: brendon; Tablespace: 
--

ALTER TABLE ONLY water_tests
    ADD CONSTRAINT water_tests_pkey PRIMARY KEY (test_id);


--
-- Name: water_type_pkey; Type: CONSTRAINT; Schema: public; Owner: brendon; Tablespace: 
--

ALTER TABLE ONLY water_type
    ADD CONSTRAINT water_type_pkey PRIMARY KEY (water_id);


--
-- Name: tank_diary_date; Type: INDEX; Schema: public; Owner: brendon; Tablespace: 
--

CREATE INDEX tank_diary_date ON tank_diary USING btree (tank_id, diary_date);


--
-- Name: tank_diary_tank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendon
--

ALTER TABLE ONLY tank_diary
    ADD CONSTRAINT tank_diary_tank_id_fkey FOREIGN KEY (tank_id) REFERENCES tank(tank_id);


--
-- Name: tank_water_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendon
--

ALTER TABLE ONLY tank
    ADD CONSTRAINT tank_water_id_fkey FOREIGN KEY (water_id) REFERENCES water_type(water_id);


--
-- Name: water_tests_tank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendon
--

ALTER TABLE ONLY water_tests
    ADD CONSTRAINT water_tests_tank_id_fkey FOREIGN KEY (tank_id) REFERENCES tank(tank_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

