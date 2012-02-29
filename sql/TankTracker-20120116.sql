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
    diary_note text NOT NULL,
    updated_on timestamp(0) without time zone DEFAULT now(),
    test_id integer
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

SELECT pg_catalog.setval('tank_diary_diary_id_seq', 40, true);


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

SELECT pg_catalog.setval('water_tests_test_id_seq', 73, true);


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

COPY tank_diary (diary_id, tank_id, diary_date, diary_note, updated_on, test_id) FROM stdin;
2	1	2012-01-12 18:38:17	Diary note #1	2012-01-12 18:38:17	\N
3	1	2012-01-12 18:38:27	Diary note #2	2012-01-12 18:38:27	\N
4	1	2012-01-12 18:38:34	Diary note #3	2012-01-12 18:38:34	\N
5	1	2012-01-12 18:38:38	Diary note #4	2012-01-12 18:38:38	\N
6	1	2012-01-12 18:38:44	Diary note #5	2012-01-12 18:38:44	\N
7	1	2012-01-12 18:38:50	Diary note #6	2012-01-12 18:38:50	\N
8	1	2012-01-12 18:38:55	Diary note #7	2012-01-12 18:38:55	\N
9	1	2012-01-12 18:39:01	Diary note #8	2012-01-12 18:39:01	\N
10	1	2012-01-12 18:39:06	Diary note #9	2012-01-12 18:39:06	\N
11	1	2012-01-12 18:39:11	Diary note #10	2012-01-12 18:39:11	\N
12	1	2012-01-12 18:39:18	Diary note #11	2012-01-12 18:39:18	\N
13	1	2012-01-12 18:39:23	Diary note #12	2012-01-12 18:39:23	\N
14	1	2012-01-12 18:39:30	Diary note #13	2012-01-12 18:39:30	\N
15	1	2012-01-12 18:39:37	Diary note #14	2012-01-12 18:39:37	\N
16	1	2012-01-12 18:39:43	Diary note #15	2012-01-12 18:39:43	\N
17	1	2012-01-12 18:39:50	Diary note #16	2012-01-12 18:39:50	\N
18	1	2012-01-14 21:54:05	diary note #1	2012-01-14 21:54:05	\N
19	1	2012-01-14 21:54:30	diary note #2	2012-01-14 21:54:30	\N
20	1	2012-01-14 21:54:41	diary note #3	2012-01-14 21:54:41	\N
21	1	2012-01-14 21:55:01	diary note #4\n\nmultiline..\n\n\n<<ends here>>>	2012-01-14 21:55:01	\N
22	1	2012-01-14 21:55:09	diary note #4	2012-01-14 21:55:09	\N
23	1	2012-01-14 21:55:17	diary note #6	2012-01-14 21:55:17	\N
24	1	2012-01-14 21:55:26	diary note #7	2012-01-14 21:55:26	\N
25	1	2012-01-14 21:55:34	diary note #8	2012-01-14 21:55:34	\N
26	1	2012-01-14 21:55:42	diary note #9	2012-01-14 21:55:42	\N
27	1	2012-01-14 21:55:50	diary note #10	2012-01-14 21:55:50	\N
28	1	2012-01-14 21:55:58	diary note #11	2012-01-14 21:55:58	\N
29	1	2012-01-14 21:56:06	diary note #12	2012-01-14 21:56:06	\N
30	1	2012-01-14 21:56:18	diary note #13	2012-01-14 21:56:18	\N
31	1	2012-01-14 21:56:25	diary note #14	2012-01-14 21:56:25	\N
32	1	2012-01-14 21:56:47	diary note #15\n\nanother multi=line job...\n\n\n\nlast line here.	2012-01-14 21:56:47	\N
33	1	2012-01-14 21:57:09	diary note #16	2012-01-14 21:57:09	\N
34	1	2012-01-14 21:59:04	diary note #17	2012-01-14 21:59:04	\N
35	1	2012-01-14 21:59:25	diary note #18\n\n\nnother multiline job.\n\n\n\nfinishes here.	2012-01-14 21:59:25	\N
36	1	2012-01-14 21:59:33	diary note #19	2012-01-14 21:59:33	\N
37	1	2012-01-14 21:59:40	diary note #20	2012-01-14 21:59:40	\N
38	1	2012-01-14 21:59:46	diary note #21	2012-01-14 21:59:46	\N
39	1	2012-01-14 21:59:57	diary note #22	2012-01-14 21:59:57	\N
40	2	2012-01-15 00:00:00	Water test.	2012-01-15 20:47:23	73
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
60	3	2011-12-10	1.023	8	0	0	0	440	0	\N	4	\N	\N	\N
62	3	2011-12-18	1.024	8.4	0	0	5	415	0.03	1215	\N	1.7	\N	\N
63	2	2011-12-18	\N	6.8	0	0	40	\N	\N	\N	\N	\N	\N	\N
64	3	2011-12-27	1.024	8.2	0	0	5	360	0.03	1305	9	1.7	\N	\N
65	2	2011-12-27	\N	7	0	0	80	\N	\N	\N	\N	\N	\N	\N
66	2	2012-01-01	\N	7	0	0	20	\N	\N	\N	\N	\N	\N	\N
67	1	2012-01-01	1.024	8.4	0	0	0	\N	\N	\N	\N	\N	\N	\N
69	2	2012-01-09	\N	6.8	0	0	20	\N	\N	\N	\N	\N	\N	\N
71	3	2012-01-09	1.024	8.2	0	0	0	360	0.03	1140	8	1.7	\N	\N
68	3	2012-01-01	1.023	8.2	0	0	5	380	0.03	1170	9	1.7	\N	\N
59	3	2011-12-10	1.024	8.2	0	0	5	\N	\N	\N	\N	\N	\N	\N
70	1	2012-01-09	1.027	8.4	0	0	0	\N	\N	\N	\N	\N	\N	\N
58	1	2011-12-10	1.026	8.2	0	0	0	\N	\N	\N	\N	\N	\N	\N
61	1	2011-12-18	\N	8.4	0	0	0	\N	\N	\N	\N	\N	\N	Forgot to measure salinity.
73	2	2012-01-15	\N	6.8	0	0	20	\N	\N	\N	\N	\N	120	\N
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
-- Name: water_test_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brendon
--

ALTER TABLE ONLY tank_diary
    ADD CONSTRAINT water_test_fkey FOREIGN KEY (test_id) REFERENCES water_tests(test_id);


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

