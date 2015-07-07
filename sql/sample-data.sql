--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: tracker_user; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY tracker_user (user_id, username, password, first_name, last_name, email, active) FROM stdin;
1	bdo	JAFc6LS5KdpmrA7JE544fypmWqPdJHa	Brendon	Oliver	brendon.oliver@gmail.com	t
\.


--
-- Data for Name: tank; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY tank (tank_id, owner_id, water_type, tank_name, notes, capacity, capacity_units, length, width, depth, dimension_units, updated_on) FROM stdin;
3	1	salt	Reef Tank	\N	1000	litres	2000	600	700	mm	2015-05-21 11:12:56
7	1	salt	RedSea Max 130	\N	130	litres	600	600	600	mm	2015-05-22 15:57:42
4	1	fresh	Community Tank	notes....\r\n\r\ngot\r\n\r\n\r\nhere....	200	litres	1200	450	500	mm	2015-05-21 11:12:56
8	1	salt	test	sdcasdcasd	100	litres	10	10	10	mm	2015-05-27 13:02:40
11	1	salt	test-4		250	litres	100	50	60	cm	2015-05-27 13:17:23
10	1	salt	test-2	dasdcasdc\r\n\r\nasdcasdsa\r\n\r\nasdcasc\r\nasdsac\r\nacsacas	120	litres	100	50	50	mm	2015-05-27 13:04:04
\.


--
-- Data for Name: water_test; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY water_test (test_id, tank_id, user_id, test_date, result_salinity, result_ph, result_ammonia, result_nitrite, result_nitrate, result_calcium, result_phosphate, result_magnesium, result_kh, result_alkalinity, water_change, notes) FROM stdin;
133	7	1	2013-10-06	0	8.2	0.5	0	0	0	0	0	0	0	0	\N
134	7	1	2013-10-10	0	8.2	0.5	0.25	5	0	0	0	0	0	0	\N
135	4	1	2013-09-17	\N	6.6	0	0	20	\N	\N	\N	\N	\N	0	\N
136	4	1	2013-09-23	\N	7	0.25	0	10	\N	\N	\N	\N	\N	0	\N
137	4	1	2013-10-06	\N	7	0	0	40	\N	\N	\N	\N	\N	0	\N
138	4	1	2013-10-10	\N	7.2	0	0	10	\N	\N	\N	\N	\N	0	\N
139	3	1	2013-09-23	1.026	8.2	0	0	20	360	0.5	1200	11	0	0	\N
140	3	1	2013-10-01	1.027	8.2	0	0	10	400	0.5	1360	10	0	0	\N
141	3	1	2013-07-06	1.027	8.2	0	0	20	320	2.5	0	14	0	0	\N
142	3	1	2013-07-14	1.029	8.2	0	0	10	300	2	0	14	0	0	\N
143	3	1	2013-07-22	1.029	8.2	0	0	10	340	1	0	11	0	0	\N
144	3	1	2013-07-29	1.028	8	0	0	10	340	0.5	0	11	0	0	\N
145	4	1	2013-07-29	\N	6.6	0	0	5	\N	\N	\N	\N	\N	0	\N
146	4	1	2013-08-20	\N	6	0	0	160	\N	\N	\N	\N	\N	155	\N
147	4	1	2013-08-23	\N	6.6	0	0	80	\N	\N	\N	\N	\N	0	\N
148	4	1	2013-08-26	\N	7	0	0	40	\N	\N	\N	\N	\N	0	\N
149	4	1	2013-09-02	\N	6.8	0	0	10	\N	\N	\N	\N	\N	0	\N
150	4	1	2013-09-09	\N	6.8	0	0	20	\N	\N	\N	\N	\N	0	\N
151	3	1	2013-08-05	1.029	8.2	0	0	10	340	0.5	0	10	0	0	\N
152	3	1	2013-08-12	1.028	8.2	0	0	10	380	0.5	0	10	0	0	\N
153	3	1	2013-08-26	1.029	8.2	0	0	20	400	0.5	0	9	0	0	\N
154	3	1	2013-09-05	1.026	8.2	0	0	10	380	0.5	0	9	0	0	\N
155	3	1	2013-09-09	1.027	8	0	0	10	410	0.5	800	9	0	0	\N
156	3	1	2013-10-13	1.028	8.2	0	0	20	460	0.5	1160	13	0	0	\N
157	4	1	2013-10-13	\N	7.2	0.25	0	10	\N	\N	\N	\N	\N	0	\N
158	7	1	2013-10-13	0	8.2	0.25	0	5	0	0	0	0	0	0	\N
159	3	1	2013-10-21	1.028	8.2	0	0	10	420	0.5	1240	10	0	0	\N
160	4	1	2013-10-21	\N	7.2	0	0	5	\N	\N	\N	\N	\N	0	\N
161	7	1	2013-10-21	0	8.5	0.25	0	0	0	0	0	0	0	0	\N
162	4	1	2013-11-05	\N	7.2	0	0	20	\N	\N	\N	\N	\N	0	\N
163	3	1	2013-11-05	1.027	8.2	0	0	20	460	0.5	1240	11	0	0	\N
\.


--
-- Data for Name: diary; Type: TABLE DATA; Schema: public; Owner: brendon
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
\.


--
-- Name: diary_diary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('diary_diary_id_seq', 128, true);


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY inventory (inventory_id, inventory_type, tank_id, user_id, description, purchase_date, purchase_price) FROM stdin;
1	consumable	3	1	fish food	2015-05-04	$5.50
2	consumable	3	1	more fish fud	2015-05-08	$10.25
3	consumable	3	1	moar fud	2015-05-05	$12.95
4	consumable	3	1	anudder item	2015-05-06	$75.50
\.


--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('inventory_inventory_id_seq', 4, true);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY sessions (session_id, session_ts, expires, session_data) FROM stdin;
session:13c57a99c1a68bf127152b9f1cd0f0773c727e2e	2015-05-25 10:23:53.58507	1432517043	BQoDAAAABhcKd2F0ZXJfdGVzdAAAAAt0YW5rX2FjdGlvbgQDAAAAAQiBAAAAB3VzZXJfaWQAAAAG\nX191c2VyCg10cmFja2VyX3VzZXJzAAAADF9fdXNlcl9yZWFsbQlVYmugAAAACV9fdXBkYXRlZAlV\nYmuZAAAACV9fY3JlYXRlZBcBMwAAAAd0YW5rX2lk\n
session:b7c5e9eaeadb39fc534d3cc4b840723277895f81	2015-05-25 13:05:47.811656	1432536896	BQoDAAAABglVYrXgAAAACV9fdXBkYXRlZAQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcgoK\nMTQzMjUyMzE0NwAAAAlfX2NyZWF0ZWQXCndhdGVyX3Rlc3QAAAALdGFua19hY3Rpb24KDXRyYWNr\nZXJfdXNlcnMAAAAMX191c2VyX3JlYWxtFwEzAAAAB3RhbmtfaWQ=\n
session:eee462b5a0f8a3a649326c87dee65ac145885754	2015-05-27 09:10:18.818932	1432708461	BQoDAAAABhcBMwAAAAd0YW5rX2lkCg10cmFja2VyX3VzZXJzAAAADF9fdXNlcl9yZWFsbRcPd2F0\nZXJfdGVzdC9saXN0AAAAC3RhbmtfYWN0aW9uBAMAAAABCgExAAAAB3VzZXJfaWQAAAAGX191c2Vy\nCgoxNDMyNjgxODE5AAAACV9fY3JlYXRlZAlVZVDKAAAACV9fdXBkYXRlZA==\n
session:e946d24b656a81103c1b2fdb48044665aabccfd3	2015-05-26 12:22:05.244956	1432624512	BQoDAAAABhcBMwAAAAd0YW5rX2lkCVVkD2gAAAAJX191cGRhdGVkFw93YXRlcl90ZXN0L2xpc3QA\nAAALdGFua19hY3Rpb24KCjE0MzI2MDY5MjUAAAAJX19jcmVhdGVkBAMAAAABCgExAAAAB3VzZXJf\naWQAAAAGX191c2VyCg10cmFja2VyX3VzZXJzAAAADF9fdXNlcl9yZWFsbQ==\n
session:a0c74a5c8fa97ae1db210e7cf8a2b190237c0fc2	2015-05-26 08:47:14.687456	1432601461	BQoDAAAABgoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0JVWOmcgAAAAlfX2NyZWF0ZWQE\nAwAAAAEIgQAAAAd1c2VyX2lkAAAABl9fdXNlchcKd2F0ZXJfdGVzdAAAAAt0YW5rX2FjdGlvbglV\nY6Z5AAAACV9fdXBkYXRlZBcBMwAAAAd0YW5rX2lk\n
session:6193cb87e04cd7e2a76aee133abc446c2a46115a	2015-05-30 12:30:03.740301	1432956613	BQoDAAAABAoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0EAwAAAAEKFFlvdSBoYXZlIGxv\nZ2dlZCBvdXQuAAAADmxvZ291dF9tZXNzYWdlAAAAB19fZmxhc2gEAwAAAAEIgQAAAAd1c2VyX2lk\nAAAABl9fdXNlcglVaSC1AAAACV9fdXBkYXRlZA==\n
session:cb60df708b7c5fc04cb9990877629f98ce2c0bba	2015-05-29 21:57:50.222466	1432904293	BQoDAAAABgoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0EAwAAAAEKATEAAAAHdXNlcl9p\nZAAAAAZfX3VzZXIJVWhUVQAAAAlfX3VwZGF0ZWQXATMAAAAHdGFua19pZAoKMTQzMjkwMDY3MAAA\nAAlfX2NyZWF0ZWQXDmludmVudG9yeS9saXN0AAAAC3RhbmtfYWN0aW9u\n
session:d79f11839a710e2eb32d312af8a5564a89115f49	2015-06-07 09:58:53.523509	1433639502	BQoDAAAABgQDAAAAAQiBAAAAB3VzZXJfaWQAAAAGX191c2VyCVVzjCoAAAAJX191cGRhdGVkFw93\nYXRlcl90ZXN0L2xpc3QAAAALdGFua19hY3Rpb24JVXOJPQAAAAlfX2NyZWF0ZWQXATMAAAAHdGFu\na19pZAoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0=\n
session:472fa023b57b1df7b31adce7fcf8f055e637bb41	2015-06-06 10:08:57.442955	1433553405	BQoDAAAABgoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0EAwAAAAEKFFlvdSBoYXZlIGxv\nZ2dlZCBvdXQuAAAADmxvZ291dF9tZXNzYWdlAAAAB19fZmxhc2gJVXI7lAAAAAlfX3VwZGF0ZWQX\nD3dhdGVyX3Rlc3QvbGlzdAAAAAt0YW5rX2FjdGlvbgQDAAAAAQiBAAAAB3VzZXJfaWQAAAAGX191\nc2VyFwEzAAAAB3RhbmtfaWQ=\n
session:daf20a1d5fb4a9b072a9071bbfadfe24a1eebf5e	2015-05-30 20:21:51.546294	1432984953	BQoDAAAABgQDAAAAAQiBAAAAB3VzZXJfaWQAAAAGX191c2VyFwEzAAAAB3RhbmtfaWQKDXRyYWNr\nZXJfdXNlcnMAAAAMX191c2VyX3JlYWxtCVVpjz8AAAAJX19jcmVhdGVkFw93YXRlcl90ZXN0L2xp\nc3QAAAALdGFua19hY3Rpb24JVWmPSAAAAAlfX3VwZGF0ZWQ=\n
session:3e0a2aaafb38a1d80dbf8c7904b012243e3422db	2015-05-30 10:40:15.322909	1432951241	BQoDAAAABglVaQbvAAAACV9fY3JlYXRlZBcKZGlhcnkvbGlzdAAAAAt0YW5rX2FjdGlvbgoNdHJh\nY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0JVWkG+QAAAAlfX3VwZGF0ZWQXATMAAAAHdGFua19p\nZAQDAAAAAQiBAAAAB3VzZXJfaWQAAAAGX191c2Vy\n
session:e4dbbe25e310417f31a09ad11f7a877e93056567	2015-05-30 15:33:39.152878	1432968094	BQoDAAAABgQDAAAAAQiBAAAAB3VzZXJfaWQAAAAGX191c2VyFwEzAAAAB3RhbmtfaWQJVWlM8AAA\nAAlfX3VwZGF0ZWQKDXRyYWNrZXJfdXNlcnMAAAAMX191c2VyX3JlYWxtBAMAAAABChRZb3UgaGF2\nZSBsb2dnZWQgb3V0LgAAAA5sb2dvdXRfbWVzc2FnZQAAAAdfX2ZsYXNoFwpkaWFyeS9saXN0AAAA\nC3RhbmtfYWN0aW9u\n
session:53bfef6727ebe531d625eb217b5bade26560f295	2015-05-30 07:48:44.562794	1432944662	BQoDAAAABglVaPG7AAAACV9fdXBkYXRlZBcBMwAAAAd0YW5rX2lkBAMAAAABCIEAAAAHdXNlcl9p\nZAAAAAZfX3VzZXIJVWjevAAAAAlfX2NyZWF0ZWQKDXRyYWNrZXJfdXNlcnMAAAAMX191c2VyX3Jl\nYWxtFwpkaWFyeS9saXN0AAAAC3RhbmtfYWN0aW9u\n
session:b9f5554e6a114092cbe1c11a8833cc9c080b5d91	2015-05-30 18:50:10.410202	1432979718	BQoDAAAABhcBMwAAAAd0YW5rX2lkBAMAAAABCIEAAAAHdXNlcl9pZAAAAAZfX3VzZXIKDXRyYWNr\nZXJfdXNlcnMAAAAMX191c2VyX3JlYWxtCVVpevAAAAAJX191cGRhdGVkCVVpecIAAAAJX19jcmVh\ndGVkFw5pbnZlbnRvcnkvbGlzdAAAAAt0YW5rX2FjdGlvbg==\n
session:6e1cafe482d5225ab5811aafafc9c620cbf0f23b	2015-06-02 21:04:17.908887	1433248748	BQoDAAAABgoKMTQzMzI0MzA1NwAAAAlfX2NyZWF0ZWQXD3dhdGVyX3Rlc3QvbGlzdAAAAAt0YW5r\nX2FjdGlvbgQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcgoNdHJhY2tlcl91c2VycwAAAAxf\nX3VzZXJfcmVhbG0XATMAAAAHdGFua19pZAlVbZVJAAAACV9fdXBkYXRlZA==\n
session:49d4728dc7cdd732e4f453b067e6ff72391beca4	2015-06-03 19:45:08.414873	1433328348	BQoDAAAABgoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0JVW7MzAAAAAlfX3VwZGF0ZWQX\nDmludmVudG9yeS9saXN0AAAAC3RhbmtfYWN0aW9uFwEzAAAAB3RhbmtfaWQEAwAAAAEIgQAAAAd1\nc2VyX2lkAAAABl9fdXNlcglVbsykAAAACV9fY3JlYXRlZA==\n
session:bbd9ab3507a9607620441dde93f668c4950a8cf0	2015-06-06 19:22:56.37554	1433588106	BQoDAAAABglVcsNDAAAACV9fdXBkYXRlZBcBNAAAAAd0YW5rX2lkBAMAAAABCgExAAAAB3VzZXJf\naWQAAAAGX191c2VyCg10cmFja2VyX3VzZXJzAAAADF9fdXNlcl9yZWFsbRcOaW52ZW50b3J5L2xp\nc3QAAAALdGFua19hY3Rpb24KCjE0MzM1ODI1NzYAAAAJX19jcmVhdGVk\n
session:0b93cbb2fe0833fadf0cbb440f707a39c489b4f2	2015-06-06 21:52:48.863624	1433600017	BQoDAAAABgQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcgoKMTQzMzU5MTU2OAAAAAlfX2Ny\nZWF0ZWQKDXRyYWNrZXJfdXNlcnMAAAAMX191c2VyX3JlYWxtCVVy35kAAAAJX191cGRhdGVkFw5p\nbnZlbnRvcnkvbGlzdAAAAAt0YW5rX2FjdGlvbhcBMwAAAAd0YW5rX2lk\n
session:3a01ca9d76ea7a02d7f40958532fa85cbac6cb1e	2015-06-07 16:41:57.521411	1433663189	BQoDAAAABgQDAAAAAQiBAAAAB3VzZXJfaWQAAAAGX191c2VyCg10cmFja2VyX3VzZXJzAAAADF9f\ndXNlcl9yZWFsbRcBMwAAAAd0YW5rX2lkCVVz6KsAAAAJX191cGRhdGVkFw5pbnZlbnRvcnkvbGlz\ndAAAAAt0YW5rX2FjdGlvbglVc+e1AAAACV9fY3JlYXRlZA==\n
session:4577d228232638b36c0c68ba36169e02e503a9ca	2015-06-07 14:11:54.18751	1433654013	BQoDAAAABgQDAAAAAQiBAAAAB3VzZXJfaWQAAAAGX191c2VyCVVzxOYAAAAJX191cGRhdGVkCVVz\nxIoAAAAJX19jcmVhdGVkFwEzAAAAB3RhbmtfaWQXCmRpYXJ5L2xpc3QAAAALdGFua19hY3Rpb24K\nDXRyYWNrZXJfdXNlcnMAAAAMX191c2VyX3JlYWxt\n
session:bc80dffe167f31ef593afd6c3bec4be96842a901	2015-06-07 20:15:26.375896	1433675751	BQoDAAAABgoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0XATMAAAAHdGFua19pZAQDAAAA\nAQiBAAAAB3VzZXJfaWQAAAAGX191c2VyFwpkaWFyeS9saXN0AAAAC3RhbmtfYWN0aW9uCVV0Gb4A\nAAAJX19jcmVhdGVkCVV0GdQAAAAJX191cGRhdGVk\n
session:6283b659286bad74f9ddef421ed55f72be4f1c50	2015-06-07 11:57:32.772567	1433646308	BQoDAAAABhcOaW52ZW50b3J5L2xpc3QAAAALdGFua19hY3Rpb24XATMAAAAHdGFua19pZAoNdHJh\nY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0JVXOlDAAAAAlfX2NyZWF0ZWQEAwAAAAEIgQAAAAd1\nc2VyX2lkAAAABl9fdXNlcglVc6WCAAAACV9fdXBkYXRlZA==\n
session:56f273ab998a27991226cabf438d4c1eb22039b3	2015-06-08 17:22:18.280609	1433761077	BQoDAAAABgoNdHJhY2tlcl91c2VycwAAAAxfX3VzZXJfcmVhbG0KCjE0MzM3NDgxMzgAAAAJX19j\ncmVhdGVkBAMAAAABCgExAAAAB3VzZXJfaWQAAAAGX191c2VyCVV1YEcAAAAJX191cGRhdGVkFw93\nYXRlcl90ZXN0L2xpc3QAAAALdGFua19hY3Rpb24XATMAAAAHdGFua19pZA==\n
\.


--
-- Name: tank_tank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('tank_tank_id_seq', 11, true);


--
-- Data for Name: tank_user_access; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY tank_user_access (tank_id, user_id, admin) FROM stdin;
\.


--
-- Data for Name: tracker_role; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY tracker_role (role_id, name) FROM stdin;
1	Admin
2	Guest
3	Owner
4	User
\.


--
-- Name: tracker_role_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('tracker_role_role_id_seq', 4, true);


--
-- Data for Name: tracker_user_role; Type: TABLE DATA; Schema: public; Owner: brendon
--

COPY tracker_user_role (user_id, role_id) FROM stdin;
\.


--
-- Name: tracker_user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('tracker_user_user_id_seq', 1, true);


--
-- Name: water_test_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brendon
--

SELECT pg_catalog.setval('water_test_test_id_seq', 12, true);


--
-- PostgreSQL database dump complete
--

