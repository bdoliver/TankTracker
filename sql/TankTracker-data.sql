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
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO users (user_id, username, password, role, first_name, last_name, email, active, parent_id, login_attempts, reset_hash, last_login, created_on, updated_on) VALUES (1, 'bdo', 'JAFc6LS5KdpmrA7JE544fypmWqPdJHa', 'owner', 'Brendon', 'Oliver', 'brendon.oliver@gmail.com', NULL, 1, 0, NULL, '2016-02-26 20:55:15', '2015-09-26 13:58:53', '2015-09-26 13:58:53');


--
-- Data for Name: tank; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tank (tank_id, owner_id, water_type, tank_name, notes, capacity_units, capacity, dimension_units, length, width, depth, temperature_scale, test_reminder, last_reminder, reminder_freq, reminder_time, active, created_on, updated_on) VALUES (3, 1, 'salt', 'RedSea Max 130', '', 'litres', 129.50, 'mm', 600, 485, 445, 'C', true, NULL, 'daily', '09:00:00', true, '2015-09-27 09:04:56', '2015-09-27 09:04:56');
INSERT INTO tank (tank_id, owner_id, water_type, tank_name, notes, capacity_units, capacity, dimension_units, length, width, depth, temperature_scale, test_reminder, last_reminder, reminder_freq, reminder_time, active, created_on, updated_on) VALUES (2, 1, 'fresh', 'Community Tank', '', 'litres', 174.22, 'mm', 1220, 340, 420, 'C', true, NULL, 'daily', '09:00:00', true, '2015-09-27 08:52:10', '2015-09-27 08:52:10');
INSERT INTO tank (tank_id, owner_id, water_type, tank_name, notes, capacity_units, capacity, dimension_units, length, width, depth, temperature_scale, test_reminder, last_reminder, reminder_freq, reminder_time, active, created_on, updated_on) VALUES (1, 1, 'salt', 'Reef Tank', '', 'litres', 840.00, 'mm', 2000, 600, 700, 'C', true, NULL, 'daily', '09:00:00', true, '2015-09-27 08:29:55', '2015-09-27 08:29:55');


--
-- Data for Name: water_test; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO water_test (test_id, user_id, test_date) VALUES (1, 1, '2013-07-06 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (2, 1, '2013-07-14 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (3, 1, '2013-07-22 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (4, 1, '2013-07-29 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (5, 1, '2013-07-29 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (6, 1, '2013-08-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (7, 1, '2013-08-12 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (8, 1, '2013-08-26 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (9, 1, '2013-08-20 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (10, 1, '2013-08-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (11, 1, '2013-08-26 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (12, 1, '2013-09-02 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (13, 1, '2013-09-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (14, 1, '2013-09-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (15, 1, '2013-09-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (16, 1, '2011-11-28 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (17, 1, '2011-12-06 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (18, 1, '2011-12-10 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (19, 1, '2011-12-18 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (20, 1, '2011-12-27 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (21, 1, '2012-01-01 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (22, 1, '2012-01-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (23, 1, '2012-01-18 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (24, 1, '2012-01-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (25, 1, '2012-01-30 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (26, 1, '2012-02-06 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (27, 1, '2012-02-14 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (28, 1, '2012-02-26 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (29, 1, '2012-03-10 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (30, 1, '2012-03-18 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (31, 1, '2012-04-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (32, 1, '2012-04-21 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (33, 1, '2012-05-01 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (34, 1, '2012-05-28 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (35, 1, '2011-09-25 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (36, 1, '2011-10-02 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (37, 1, '2011-10-11 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (38, 1, '2011-10-16 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (39, 1, '2011-11-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (40, 1, '2011-11-08 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (41, 1, '2011-11-20 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (42, 1, '2011-11-28 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (43, 1, '2011-12-10 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (44, 1, '2011-12-18 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (45, 1, '2011-12-27 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (46, 1, '2012-01-01 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (47, 1, '2012-01-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (48, 1, '2012-01-15 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (49, 1, '2012-01-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (50, 1, '2012-02-06 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (51, 1, '2012-02-14 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (52, 1, '2012-02-26 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (53, 1, '2012-03-10 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (54, 1, '2012-03-19 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (55, 1, '2012-04-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (56, 1, '2012-04-21 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (57, 1, '2012-05-01 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (58, 1, '2012-05-11 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (59, 1, '2012-05-29 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (60, 1, '2011-09-20 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (61, 1, '2011-09-27 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (62, 1, '2011-09-29 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (63, 1, '2011-10-02 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (64, 1, '2011-10-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (65, 1, '2011-10-16 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (66, 1, '2011-11-08 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (67, 1, '2011-11-20 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (68, 1, '2011-11-28 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (69, 1, '2011-12-10 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (70, 1, '2011-12-18 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (71, 1, '2012-01-01 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (72, 1, '2012-01-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (73, 1, '2012-04-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (74, 1, '2012-04-22 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (75, 1, '2013-06-04 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (76, 1, '2013-06-04 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (77, 1, '2013-06-30 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (78, 1, '2013-09-17 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (79, 1, '2013-09-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (80, 1, '2013-09-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (81, 1, '2013-10-01 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (82, 1, '2013-10-06 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (83, 1, '2013-10-06 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (84, 1, '2013-10-10 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (85, 1, '2013-10-10 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (86, 1, '2013-10-13 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (87, 1, '2013-10-13 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (88, 1, '2013-10-13 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (89, 1, '2013-10-21 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (90, 1, '2013-10-21 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (91, 1, '2013-10-21 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (92, 1, '2013-11-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (93, 1, '2013-11-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (94, 1, '2013-11-12 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (95, 1, '2013-11-12 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (96, 1, '2013-11-12 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (97, 1, '2013-11-25 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (98, 1, '2013-11-25 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (99, 1, '2013-11-25 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (100, 1, '2013-12-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (101, 1, '2013-12-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (102, 1, '2013-12-09 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (103, 1, '2013-12-28 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (104, 1, '2014-01-07 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (105, 1, '2014-01-07 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (106, 1, '2014-01-08 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (107, 1, '2014-01-21 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (108, 1, '2014-01-21 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (109, 1, '2014-02-22 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (110, 1, '2014-04-05 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (111, 1, '2014-04-10 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (112, 1, '2014-04-13 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (113, 1, '2014-04-13 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (114, 1, '2014-07-13 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (115, 1, '2014-08-29 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (116, 1, '2014-08-29 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (117, 1, '2014-08-29 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (118, 1, '2014-11-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (119, 1, '2014-11-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (120, 1, '2014-11-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (121, 1, '2015-06-06 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (122, 1, '2015-06-07 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (123, 1, '2015-06-07 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (124, 1, '2015-06-21 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (125, 1, '2015-06-28 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (126, 1, '2015-06-28 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (127, 1, '2015-07-12 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (128, 1, '2015-07-19 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (129, 1, '2015-07-26 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (130, 1, '2015-07-26 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (131, 1, '2015-08-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (132, 1, '2015-08-23 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (133, 1, '2015-10-03 00:00:00');
INSERT INTO water_test (test_id, user_id, test_date) VALUES (134, 1, '2015-10-03 00:00:00');


--
-- Data for Name: diary; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (1, 1, 1, '2015-09-27 08:29:55', 'Created tank', '2015-09-27 08:29:55', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (2, 2, 1, '2015-09-27 08:52:10', 'Created tank', '2015-09-27 08:52:10', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (3, 3, 1, '2015-09-27 09:04:56', 'Created tank', '2015-09-27 09:04:56', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (9, 1, 1, '2013-07-29 00:00:00', 'Recorded water test results', '2015-09-27 21:06:33', 4);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (16, 2, 1, '2013-07-29 00:00:00', 'Recorded water test results', '2015-09-27 21:31:14', 5);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (17, 1, 1, '2013-08-05 00:00:00', 'Recorded water test results', '2015-09-27 21:32:01', 6);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (18, 1, 1, '2013-08-12 00:00:00', 'Recorded water test results', '2015-09-27 21:32:46', 7);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (19, 1, 1, '2013-08-26 00:00:00', 'Recorded water test results', '2015-09-27 21:33:24', 8);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (20, 2, 1, '2013-08-20 00:00:00', 'Recorded water test results', '2015-09-27 21:34:00', 9);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (10, 1, 1, '2015-09-27 21:07:29', 'Updated tank details', '2015-09-27 21:07:29', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (11, 1, 1, '2015-09-27 21:13:45', 'Updated tank details', '2015-09-27 21:13:45', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (12, 1, 1, '2015-09-27 21:21:07', 'Updated tank details', '2015-09-27 21:21:07', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (13, 1, 1, '2015-09-27 21:22:23', 'Updated tank details', '2015-09-27 21:22:23', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (14, 1, 1, '2015-09-27 21:25:17', 'Updated tank details', '2015-09-27 21:25:17', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (15, 2, 1, '2015-09-27 21:30:48', 'Updated tank details', '2015-09-27 21:30:48', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (21, 2, 1, '2013-08-23 00:00:00', 'Recorded water test results', '2015-09-27 21:34:23', 10);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (22, 2, 1, '2013-08-26 00:00:00', 'Recorded water test results', '2015-09-27 21:34:45', 11);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (23, 2, 1, '2013-09-02 00:00:00', 'Recorded water test results', '2015-09-27 21:35:12', 12);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (24, 1, 1, '2013-09-05 00:00:00', 'Recorded water test results', '2015-09-27 21:36:01', 13);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (25, 2, 1, '2013-09-09 00:00:00', 'Recorded water test results', '2015-09-27 21:36:32', 14);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (26, 1, 1, '2013-09-09 00:00:00', 'Recorded water test results', '2015-09-27 21:37:20', 15);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (27, 1, 1, '2011-11-28 00:00:00', 'Recorded water test results', '2015-09-27 21:43:51', 16);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (28, 1, 1, '2011-12-06 00:00:00', 'Recorded water test results', '2015-09-27 21:45:10', 17);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (29, 1, 1, '2011-12-10 00:00:00', 'Recorded water test results', '2015-09-27 21:46:02', 18);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (30, 1, 1, '2011-12-18 00:00:00', 'Recorded water test results', '2015-09-27 21:47:10', 19);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (31, 1, 1, '2011-12-27 00:00:00', 'Recorded water test results', '2015-09-27 21:48:10', 20);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (32, 1, 1, '2012-01-01 00:00:00', 'Recorded water test results', '2015-09-27 21:48:57', 21);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (33, 1, 1, '2012-01-09 00:00:00', 'Recorded water test results', '2015-09-27 21:49:52', 22);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (34, 1, 1, '2012-01-18 00:00:00', 'Recorded water test results', '2015-09-27 21:50:50', 23);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (35, 1, 1, '2012-01-23 00:00:00', 'Recorded water test results', '2015-09-27 21:51:46', 24);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (36, 1, 1, '2012-01-30 00:00:00', 'Recorded water test results', '2015-09-27 21:52:29', 25);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (37, 1, 1, '2012-02-06 00:00:00', 'Recorded water test results', '2015-09-27 21:53:32', 26);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (38, 1, 1, '2012-02-14 00:00:00', 'Recorded water test results', '2015-09-27 21:55:03', 27);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (39, 1, 1, '2012-02-26 00:00:00', 'Recorded water test results', '2015-09-27 21:56:20', 28);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (40, 1, 1, '2012-03-10 00:00:00', 'Recorded water test results', '2015-09-27 21:57:22', 29);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (41, 1, 1, '2012-03-18 00:00:00', 'Recorded water test results', '2015-09-27 21:58:20', 30);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (42, 1, 1, '2012-04-05 00:00:00', 'Recorded water test results', '2015-09-27 21:59:35', 31);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (43, 1, 1, '2012-04-21 00:00:00', 'Recorded water test results', '2015-09-27 22:00:23', 32);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (44, 1, 1, '2012-05-01 00:00:00', 'Recorded water test results', '2015-09-27 22:01:05', 33);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (45, 1, 1, '2012-05-28 00:00:00', 'Recorded water test results', '2015-09-27 22:01:49', 34);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (46, 2, 1, '2011-09-25 00:00:00', 'Recorded water test results', '2015-09-27 22:07:20', 35);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (47, 2, 1, '2011-10-02 00:00:00', 'Recorded water test results', '2015-09-27 22:07:52', 36);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (48, 2, 1, '2011-10-11 00:00:00', 'Recorded water test results', '2015-09-27 22:08:26', 37);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (49, 2, 1, '2011-10-16 00:00:00', 'Recorded water test results', '2015-09-27 22:08:52', 38);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (50, 2, 1, '2011-11-05 00:00:00', 'Recorded water test results', '2015-09-27 22:09:32', 39);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (51, 2, 1, '2011-11-08 00:00:00', 'Recorded water test results', '2015-09-27 22:10:02', 40);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (52, 2, 1, '2011-11-20 00:00:00', 'Recorded water test results', '2015-09-27 22:10:27', 41);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (53, 2, 1, '2011-11-28 00:00:00', 'Recorded water test results', '2015-09-27 22:10:56', 42);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (54, 2, 1, '2011-12-10 00:00:00', 'Recorded water test results', '2015-09-27 22:11:24', 43);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (55, 2, 1, '2011-12-18 00:00:00', 'Recorded water test results', '2015-09-27 22:11:55', 44);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (56, 2, 1, '2011-12-27 00:00:00', 'Recorded water test results', '2015-09-27 22:12:16', 45);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (57, 2, 1, '2012-01-01 00:00:00', 'Recorded water test results', '2015-09-27 22:12:44', 46);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (58, 2, 1, '2012-01-09 00:00:00', 'Recorded water test results', '2015-09-27 22:13:07', 47);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (59, 2, 1, '2012-01-15 00:00:00', 'Recorded water test results', '2015-09-27 22:13:33', 48);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (61, 2, 1, '2012-01-23 00:00:00', 'Recorded water test results', '2015-09-27 22:14:33', 49);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (62, 2, 1, '2012-02-06 00:00:00', 'Recorded water test results', '2015-09-27 22:14:55', 50);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (63, 2, 1, '2012-02-14 00:00:00', 'Recorded water test results', '2015-09-27 22:15:20', 51);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (64, 2, 1, '2012-02-26 00:00:00', 'Recorded water test results', '2015-09-27 22:15:47', 52);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (65, 2, 1, '2012-03-10 00:00:00', 'Recorded water test results', '2015-09-27 22:16:05', 53);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (60, 2, 1, '2015-09-27 22:14:05', 'Updated tank details', '2015-09-27 22:14:05', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (66, 2, 1, '2012-03-19 00:00:00', 'Recorded water test results', '2015-09-27 22:16:29', 54);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (67, 2, 1, '2012-04-05 00:00:00', 'Recorded water test results', '2015-09-27 22:16:46', 55);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (69, 2, 1, '2012-04-21 00:00:00', 'Updated water test results', '2015-09-27 22:18:25', 56);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (68, 2, 1, '2012-04-21 00:00:00', 'Before water change', '2015-09-27 22:17:09', 56);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (70, 2, 1, '2012-05-01 00:00:00', 'Recorded water test results', '2015-09-27 22:19:02', 57);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (71, 2, 1, '2012-05-11 00:00:00', 'Recorded water test results', '2015-09-27 22:19:25', 58);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (72, 2, 1, '2012-05-29 00:00:00', 'Recorded water test results', '2015-09-27 22:20:04', 59);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (73, 3, 1, '2011-09-20 00:00:00', 'Recorded water test results', '2015-09-27 22:23:17', 60);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (75, 3, 1, '2011-09-27 00:00:00', 'Recorded water test results', '2015-09-27 22:24:37', 61);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (76, 3, 1, '2011-09-29 00:00:00', 'Recorded water test results', '2015-09-27 22:25:19', 62);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (77, 3, 1, '2011-10-02 00:00:00', 'Recorded water test results', '2015-09-27 22:26:00', 63);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (78, 3, 1, '2011-10-09 00:00:00', 'Recorded water test results', '2015-09-27 22:26:27', 64);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (79, 3, 1, '2011-10-16 00:00:00', 'Recorded water test results', '2015-09-27 22:26:57', 65);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (74, 3, 1, '2015-09-27 22:23:36', 'Updated tank details', '2015-09-27 22:23:36', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (80, 3, 1, '2011-11-08 00:00:00', 'Recorded water test results', '2015-09-27 22:27:40', 66);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (81, 3, 1, '2011-11-20 00:00:00', 'Recorded water test results', '2015-09-27 22:28:06', 67);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (82, 3, 1, '2011-11-28 00:00:00', 'Recorded water test results', '2015-09-27 22:28:36', 68);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (83, 3, 1, '2011-12-10 00:00:00', 'Recorded water test results', '2015-09-27 22:29:14', 69);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (84, 3, 1, '2011-12-18 00:00:00', 'Recorded water test results', '2015-09-27 22:29:46', 70);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (85, 3, 1, '2012-01-01 00:00:00', 'Recorded water test results', '2015-09-27 22:30:14', 71);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (86, 3, 1, '2012-01-09 00:00:00', 'Recorded water test results', '2015-09-27 22:30:52', 72);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (87, 3, 1, '2012-04-05 00:00:00', 'Recorded water test results', '2015-09-27 22:32:17', 73);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (89, 1, 1, '2015-09-28 14:51:00', 'Updated tank details', '2015-09-28 14:51:00', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (4, 1, 1, '2013-07-06 00:00:00', 'Recorded water test results', '2015-09-27 20:54:34', 1);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (8, 1, 1, '2013-07-14 00:00:00', 'Updated water test results', '2015-09-27 21:05:09', 2);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (7, 1, 1, '2013-07-14 00:00:00', 'Updated water test results', '2015-09-27 21:01:45', 2);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (5, 1, 1, '2013-07-14 00:00:00', 'Recorded water test results', '2015-09-27 20:55:30', 2);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (6, 1, 1, '2013-07-22 00:00:00', 'Recorded water test results', '2015-09-27 20:56:14', 3);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (90, 1, 1, '2015-09-29 10:03:46', 'Updated tank details', '2015-09-29 10:03:46', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (88, 3, 1, '2012-04-22 00:00:00', 'Recorded water test results', '2015-09-27 22:33:24', 74);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (91, 2, 1, '2013-06-04 00:00:00', 'Recorded water test results', '2015-10-03 10:55:44', 75);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (92, 1, 1, '2013-06-04 00:00:00', 'Recorded water test results', '2015-10-03 10:57:10', 76);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (93, 1, 1, '2013-06-30 00:00:00', 'Recorded water test results', '2015-10-03 10:57:57', 77);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (94, 2, 1, '2013-09-17 00:00:00', 'Recorded water test results', '2015-10-03 10:58:50', 78);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (95, 1, 1, '2013-09-23 00:00:00', 'Recorded water test results', '2015-10-03 10:59:37', 79);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (96, 2, 1, '2013-09-23 00:00:00', 'Recorded water test results', '2015-10-03 11:00:09', 80);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (97, 1, 1, '2013-10-01 00:00:00', 'Recorded water test results', '2015-10-03 11:01:05', 81);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (98, 3, 1, '2013-10-06 00:00:00', 'Re-started tank.  Fill date: 2013/10/05.

NH4 today: 0.50', '2015-10-03 11:02:31', 82);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (99, 2, 1, '2013-10-06 00:00:00', 'Recorded water test results', '2015-10-03 11:03:00', 83);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (100, 3, 1, '2013-10-10 00:00:00', 'NH4: 0.50
NO2: 0.25', '2015-10-03 11:03:46', 84);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (101, 2, 1, '2013-10-10 00:00:00', 'Recorded water test results', '2015-10-03 11:04:10', 85);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (102, 1, 1, '2013-10-13 00:00:00', 'Recorded water test results', '2015-10-03 11:05:09', 86);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (103, 3, 1, '2013-10-13 00:00:00', 'NH4: 0.25', '2015-10-03 11:05:49', 87);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (104, 3, 1, '2013-10-13 00:00:00', 'NH4: 0.25
NO2: 0.00', '2015-10-03 11:06:19', 87);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (105, 2, 1, '2013-10-13 00:00:00', 'Recorded water test results', '2015-10-03 11:07:03', 88);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (106, 2, 1, '2013-10-21 00:00:00', 'Recorded water test results', '2015-10-03 11:07:18', 89);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (107, 3, 1, '2013-10-10 00:00:00', 'Updated water test results', '2015-10-03 11:07:44', 84);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (108, 3, 1, '2013-10-10 00:00:00', 'Updated water test results', '2015-10-03 11:07:59', 84);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (109, 3, 1, '2013-10-21 00:00:00', 'NH4: 0.25
NO2: 0', '2015-10-03 11:08:37', 90);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (110, 1, 1, '2013-10-21 00:00:00', 'Recorded water test results', '2015-10-03 11:09:19', 91);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (111, 2, 1, '2013-11-05 00:00:00', 'Recorded water test results', '2015-10-03 11:09:55', 92);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (112, 1, 1, '2013-11-05 00:00:00', 'Recorded water test results', '2015-10-03 11:10:40', 93);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (113, 2, 1, '2013-11-12 00:00:00', 'Recorded water test results', '2015-10-03 11:11:14', 94);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (114, 3, 1, '2013-11-12 00:00:00', 'NH4: 0
NO2: 0', '2015-10-03 11:11:45', 95);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (115, 1, 1, '2013-11-12 00:00:00', 'Recorded water test results', '2015-10-03 11:12:35', 96);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (116, 1, 1, '2013-11-25 00:00:00', 'Recorded water test results', '2015-10-03 11:13:17', 97);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (117, 2, 1, '2013-11-25 00:00:00', 'Recorded water test results', '2015-10-03 11:13:46', 98);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (118, 3, 1, '2013-11-25 00:00:00', 'Installed Purigen + Chemi-pure on 2013/11/30', '2015-10-03 11:14:46', 99);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (119, 2, 1, '2013-12-09 00:00:00', 'Recorded water test results', '2015-10-03 11:15:08', 100);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (120, 3, 1, '2013-12-09 00:00:00', 'Recorded water test results', '2015-10-03 11:15:48', 101);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (121, 1, 1, '2013-12-09 00:00:00', 'Recorded water test results', '2015-10-03 11:16:32', 102);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (122, 2, 1, '2013-12-28 00:00:00', 'Recorded water test results', '2015-10-03 11:17:02', 103);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (123, 1, 1, '2014-01-07 00:00:00', 'Recorded water test results', '2015-10-03 11:17:51', 104);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (124, 3, 1, '2014-01-07 00:00:00', 'Recorded water test results', '2015-10-03 11:18:22', 105);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (125, 2, 1, '2014-01-08 00:00:00', 'Recorded water test results', '2015-10-03 11:18:50', 106);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (126, 2, 1, '2014-01-21 00:00:00', 'Recorded water test results', '2015-10-03 11:20:30', 107);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (127, 1, 1, '2014-01-21 00:00:00', 'Recorded water test results', '2015-10-03 11:21:30', 108);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (128, 2, 1, '2014-02-22 00:00:00', 'Recorded water test results', '2015-10-03 11:22:37', 109);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (129, 3, 1, '2014-04-05 00:00:00', 'Recorded water test results', '2015-10-03 11:23:54', 110);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (130, 3, 1, '2014-04-10 00:00:00', 'Recorded water test results', '2015-10-03 11:24:47', 111);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (131, 1, 1, '2014-04-13 00:00:00', 'Recorded water test results', '2015-10-03 11:25:22', 112);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (132, 2, 1, '2014-04-13 00:00:00', 'Recorded water test results', '2015-10-03 11:26:10', 113);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (133, 2, 1, '2014-07-13 00:00:00', 'Recorded water test results', '2015-10-03 11:26:39', 114);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (134, 2, 1, '2014-08-29 00:00:00', 'Water change + filter clean', '2015-10-03 11:27:33', 115);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (135, 3, 1, '2014-08-29 00:00:00', 'Recorded water test results', '2015-10-03 11:28:13', 116);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (136, 1, 1, '2014-08-29 00:00:00', 'Recorded water test results', '2015-10-03 11:29:07', 117);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (137, 2, 1, '2014-11-23 00:00:00', 'Results before water change', '2015-10-03 11:30:04', 118);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (138, 2, 1, '2014-11-23 00:00:00', 'Results after water change', '2015-10-03 11:30:36', 119);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (139, 1, 1, '2014-11-23 00:00:00', 'Recorded water test results', '2015-10-03 11:31:21', 120);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (140, 2, 1, '2015-06-06 00:00:00', 'Results before water change', '2015-10-03 11:32:57', 121);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (141, 2, 1, '2015-06-07 00:00:00', 'Results after water change', '2015-10-03 11:33:17', 122);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (142, 1, 1, '2015-06-07 00:00:00', 'Water change.', '2015-10-03 11:34:19', 123);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (143, 2, 1, '2015-06-21 00:00:00', 'Recorded water test results', '2015-10-03 11:34:42', 124);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (144, 2, 1, '2015-06-28 00:00:00', 'Results before water change', '2015-10-03 11:35:12', 125);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (145, 2, 1, '2015-06-28 00:00:00', 'Results after water change', '2015-10-03 11:35:43', 126);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (146, 2, 1, '2015-07-12 00:00:00', 'Recorded water test results', '2015-10-03 11:38:00', 127);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (147, 2, 1, '2015-07-19 00:00:00', 'dKh: &lt; 1.0', '2015-10-03 11:38:45', 128);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (148, 1, 1, '2015-07-26 00:00:00', 'After water change', '2015-10-03 11:39:51', 129);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (149, 2, 1, '2015-07-26 00:00:00', 'Results before water change.
dKh &lt; 1.0', '2015-10-03 11:40:41', 130);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (150, 2, 1, '2015-08-23 00:00:00', 'Recorded water test results', '2015-10-03 11:41:32', 131);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (151, 3, 1, '2015-08-23 00:00:00', 'Recorded water test results', '2015-10-03 11:42:19', 132);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (152, 2, 1, '2015-10-03 00:00:00', 'Results before water change', '2015-10-03 11:43:10', 133);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (156, 2, 1, '2015-10-03 00:00:00', 'some test guff', '2015-10-03 19:01:49', NULL);
INSERT INTO diary (diary_id, tank_id, user_id, diary_date, diary_note, updated_on, test_id) VALUES (158, 1, 1, '2015-12-30 22:53:16', 'Updated tank details', '2015-12-30 22:53:16', NULL);


--
-- Name: diary_diary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('diary_diary_id_seq', 158, true);


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('inventory_inventory_id_seq', 1, false);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:ee891c5cd3c28ae62ff8bb25c2cf9861683fed96', '2015-09-26 14:02:47.645797', 1443243767, 'BQoDAAAABAlWBhjnAAAACV9fdXBkYXRlZAQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcglW
BhjnAAAACV9fY3JlYXRlZAoIdHRfdXNlcnMAAAAMX191c2VyX3JlYWxt
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:28da28f112fe3f2cf2544900d6f76155a1921426', '2015-09-26 16:03:10.92967', 1443250992, 'BQoDAAAABAlWBjUfAAAACV9fdXBkYXRlZAoIdHRfdXNlcnMAAAAMX191c2VyX3JlYWxtCVYGNR8A
AAAJX19jcmVhdGVkBAMAAAABCgExAAAAB3VzZXJfaWQAAAAGX191c2Vy
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:3153bafcebd614aece1dbd7abe0369382eeb6dc1', '2015-09-26 20:11:13.057196', 1443265873, 'BQoDAAAABAlWBm9BAAAACV9fY3JlYXRlZAQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcgoI
dHRfdXNlcnMAAAAMX191c2VyX3JlYWxtCVYGb0EAAAAJX191cGRhdGVk
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:d506f83407960d7f0e29236eececa7cb1cf1594f', '2015-09-27 20:50:36.042661', 1443360970, 'BQoDAAAABglWB+KWAAAACV9fdXBkYXRlZBcBMQAAAAd0YW5rX2lkBAMAAAABCgExAAAAB3VzZXJf
aWQAAAAGX191c2VyCgh0dF91c2VycwAAAAxfX3VzZXJfcmVhbG0JVgfJ/AAAAAlfX2NyZWF0ZWQX
D3dhdGVyX3Rlc3QvbGlzdAAAAAt0YW5rX2FjdGlvbg==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:295e494fb144428c8712636b959e44e717f665f6', '2015-09-27 08:32:01.85024', 1443312296, 'BQoDAAAABQlWBxzhAAAACV9fY3JlYXRlZAlWBySYAAAACV9fdXBkYXRlZAQDAAAAAQoBMQAAAAd1
c2VyX2lkAAAABl9fdXNlchcBMQAAAAd0YW5rX2lkCgh0dF91c2VycwAAAAxfX3VzZXJfcmVhbG0=
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:0360b8fd5a02ccd4c869a8ae8a63c9dd455994de', '2015-09-28 09:22:56.085719', 1443404215, 'BQoDAAAABglWCHpQAAAACV9fY3JlYXRlZAQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlchcB
MgAAAAd0YW5rX2lkCgh0dF91c2VycwAAAAxfX3VzZXJfcmVhbG0JVgiIdAAAAAlfX3VwZGF0ZWQX
D3dhdGVyX3Rlc3QvbGlzdAAAAAt0YW5rX2FjdGlvbg==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:a152e4f418d04feca4e6e2bbd2d2bcefc12d113f', '2015-09-28 13:06:47.205948', 1443413969, 'BQoDAAAABglWCLG4AAAACV9fdXBkYXRlZAQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlchcB
MQAAAAd0YW5rX2lkFwR2aWV3AAAAC3RhbmtfYWN0aW9uCgh0dF91c2VycwAAAAxfX3VzZXJfcmVh
bG0JVgiuxwAAAAlfX2NyZWF0ZWQ=
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:1c56a782ae104790010bb7bedfc57603c18290c5', '2015-09-28 11:55:42.610948', 1443408951, 'BQoDAAAABglWCJ4nAAAACV9fdXBkYXRlZBcBMQAAAAd0YW5rX2lkBAMAAAABCgExAAAAB3VzZXJf
aWQAAAAGX191c2VyCgh0dF91c2VycwAAAAxfX3VzZXJfcmVhbG0JVgieHgAAAAlfX2NyZWF0ZWQX
BHZpZXcAAAALdGFua19hY3Rpb24=
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:ef9fbe65fe841cc1b040f41e3b8348bd792817af', '2015-09-29 10:03:30.208914', 1443489723, 'BQoDAAAABhcPd2F0ZXJfdGVzdC9saXN0AAAAC3RhbmtfYWN0aW9uCgh0dF91c2VycwAAAAxfX3Vz
ZXJfcmVhbG0XATEAAAAHdGFua19pZAlWCdVmAAAACV9fdXBkYXRlZAlWCdVSAAAACV9fY3JlYXRl
ZAQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcg==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:1a6c9f2954152e7337e43fa9830123b94118a3af', '2015-09-28 14:49:19.898448', 1443419460, 'BQoDAAAABRcBMQAAAAd0YW5rX2lkCVYIxs8AAAAJX19jcmVhdGVkBAMAAAABCgExAAAAB3VzZXJf
aWQAAAAGX191c2VyCVYIxzQAAAAJX191cGRhdGVkCgh0dF91c2VycwAAAAxfX3VzZXJfcmVhbG0=
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:ebc8576c35d9df22a2c4dd45956148458cce4d83', '2015-10-03 13:09:00.72523', 1443846817, 'BQoDAAAABhcPd2F0ZXJfdGVzdC9saXN0AAAAC3RhbmtfYWN0aW9uBAMAAAABCgExAAAAB3VzZXJf
aWQAAAAGX191c2VyFwEyAAAAB3RhbmtfaWQJVg9G0QAAAAlfX3VwZGF0ZWQJVg9GzAAAAAlfX2Ny
ZWF0ZWQKCHR0X3VzZXJzAAAADF9fdXNlcl9yZWFsbQ==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:72e99ad3757ac47d7094cab4ed6dad048789cebf', '2015-10-03 10:55:05.144838', 1443840190, 'BQoDAAAABgoIdHRfdXNlcnMAAAAMX191c2VyX3JlYWxtCVYPMoQAAAAJX191cGRhdGVkFwEyAAAA
B3RhbmtfaWQJVg8naQAAAAlfX2NyZWF0ZWQEAwAAAAEKATEAAAAHdXNlcl9pZAAAAAZfX3VzZXIX
D3dhdGVyX3Rlc3QvbGlzdAAAAAt0YW5rX2FjdGlvbg==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:ea51aaf8e06c7278f7902eceba2ef713d10fcd71', '2015-10-04 10:03:42.811837', 1443923778, 'BQoDAAAABgQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcgoIdHRfdXNlcnMAAAAMX191c2Vy
X3JlYWxtFwExAAAAB3RhbmtfaWQXCmRpYXJ5L2xpc3QAAAALdGFua19hY3Rpb24JVhBezwAAAAlf
X2NyZWF0ZWQJVhBo0wAAAAlfX3VwZGF0ZWQ=
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:c93a61aa506881a128ccc54f06b1f0bc437982cc', '2015-10-03 08:27:11.683553', 1443828700, 'BQoDAAAABhcPd2F0ZXJfdGVzdC9saXN0AAAAC3RhbmtfYWN0aW9uCVYPBMYAAAAJX191cGRhdGVk
FwExAAAAB3RhbmtfaWQEAwAAAAEKATEAAAAHdXNlcl9pZAAAAAZfX3VzZXIKCHR0X3VzZXJzAAAA
DF9fdXNlcl9yZWFsbQlWDwS/AAAACV9fY3JlYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:581fc2a54c59f8a24a0d62948f481f8e5e31d51d', '2015-10-03 14:55:14.258956', 1443854293, 'BQoDAAAABglWD1+yAAAACV9fY3JlYXRlZAlWD1+6AAAACV9fdXBkYXRlZAQDAAAAAQoBMQAAAAd1
c2VyX2lkAAAABl9fdXNlchcKZGlhcnkvbGlzdAAAAAt0YW5rX2FjdGlvbhcBMgAAAAd0YW5rX2lk
Cgh0dF91c2VycwAAAAxfX3VzZXJfcmVhbG0=
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:6232d2303817dc27d08c99fcd58f7eabd5d7b15e', '2015-10-03 16:57:20.004497', 1443866849, 'BQoDAAAABglWD5LyAAAACV9fdXBkYXRlZBcBMgAAAAd0YW5rX2lkFwpkaWFyeS9saXN0AAAAC3Rh
bmtfYWN0aW9uBAMAAAABCgExAAAAB3VzZXJfaWQAAAAGX191c2VyCgh0dF91c2VycwAAAAxfX3Vz
ZXJfcmVhbG0JVg98UAAAAAlfX2NyZWF0ZWQ=
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:f2cbd672bf1c5a251c9e493511555a74da0d7813', '2016-01-04 08:27:15.451322', 1451860035, 'BQoDAAAAAQlWiZIzAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:0c394fcb26a653b48b0de7aee2dcaee57ba6beb7', '2016-01-08 19:25:11.733813', 1452245109, 'BQoDAAAAAQlWj3JpAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:6bf6598e295239d2f90b79bfa85030fcde48064d', '2015-12-30 22:51:41.673106', 1451480053, 'BQoDAAAABQlWg8WxAAAACV9fdXBkYXRlZBcPd2F0ZXJfdGVzdC9saXN0AAAAC3RhbmtfYWN0aW9u
FwExAAAAB3RhbmtfaWQEAwAAAAEKATEAAAAHdXNlcl9pZAAAAAZfX3VzZXIKCHR0X3VzZXJzAAAA
DF9fdXNlcl9yZWFsbQ==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:996b65005696893dab227a8a435fb2cc950b690c', '2016-01-01 20:04:19.654992', 1451642659, 'BQoDAAAAAQlWhkETAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:836365f9f8f1381e40d9195533c5aa8c1d3de287', '2016-01-11 21:32:04.974817', 1452511924, 'BQoDAAAAAQlWk4SlAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:445b4c64040561dcc962669c6636cab0aec3b58e', '2015-12-30 21:02:26.855365', 1451475470, 'BQoDAAAABRcPd2F0ZXJfdGVzdC9saXN0AAAAC3RhbmtfYWN0aW9uCVaDq70AAAAJX191cGRhdGVk
FwExAAAAB3RhbmtfaWQKCHR0X3VzZXJzAAAADF9fdXNlcl9yZWFsbQQDAAAAAQoBMQAAAAd1c2Vy
X2lkAAAABl9fdXNlcg==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:bd7c0cc1486eca3c462b4f1ba58400db7ac50b31', '2016-01-02 08:56:41.673626', 1451689003, 'BQoDAAAAAwoIdHRfdXNlcnMAAAAMX191c2VyX3JlYWxtBAMAAAABCgExAAAAB3VzZXJfaWQAAAAG
X191c2VyCVaG9hsAAAAJX191cGRhdGVk
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:8b7e3d453b54333f7299999bb8e11f1872306fd5', '2016-01-03 09:13:41.099889', 1451776421, 'BQoDAAAAAQlWiEuVAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:7f950fdb142036f718985fc9c6889ee135e9755c', '2016-01-22 10:25:46.128603', 1453422346, 'BQoDAAAAAQlWoWj6AAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:68781c4a104f31125b0bbc04b45216a7b1d39c6e', '2016-01-28 10:22:53.515155', 1453940573, 'BQoDAAAAAQlWqVFRAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:cb5522de773dc66ef610c73eefb50036399175b1', '2016-01-28 10:36:47.917981', 1453941407, 'BQoDAAAAAQlWqVSRAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:305febd9f04af4bcc326bc01d64e855d9922f586', '2016-01-28 10:44:05.19371', 1453941845, 'BQoDAAAAAQlWqVZFAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:a7a6e2c387644428c34594caf7e6c1995b495f7c', '2016-01-28 11:09:21.70711', 1453943361, 'BQoDAAAAAQlWqVwxAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:a7da57f6d8c08f3402d8aa9987dea52b8c67f5e5', '2016-01-28 11:22:09.979922', 1453944129, 'BQoDAAAAAQlWqV8yAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:ba8a033346b194c5a83e3a87404185bd3c6251bf', '2016-02-25 09:47:20.21164', 1456358016, 'BQoDAAAAAQlWzjL4AAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:7081c389b25550ba5de94d222f22dfb6c69ee25e', '2016-02-25 11:02:55.392319', 1456362175, 'BQoDAAAAAQlWzkSvAAAACV9fdXBkYXRlZA==
');
INSERT INTO sessions (session_id, session_ts, expires, session_data) VALUES ('session:9ab5d56b62def543b16497c2012b861dee592ea4', '2016-02-26 20:55:12.397066', 1456484151, 'BQoDAAAABRcBMQAAAAd0YW5rX2lkCgh0dF91c2VycwAAAAxfX3VzZXJfcmVhbG0XD3dhdGVyX3Rl
c3QvbGlzdAAAAAt0YW5rX2FjdGlvbgQDAAAAAQoBMQAAAAd1c2VyX2lkAAAABl9fdXNlcglW0CEm
AAAACV9fdXBkYXRlZA==
');


--
-- Data for Name: tank_inventory; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: tank_user_access; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tank_user_access (tank_id, user_id, role) VALUES (1, 1, 'owner');
INSERT INTO tank_user_access (tank_id, user_id, role) VALUES (2, 1, 'owner');
INSERT INTO tank_user_access (tank_id, user_id, role) VALUES (3, 1, 'owner');


--
-- Data for Name: tank_photo; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: tank_photo_photo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tank_photo_photo_id_seq', 1, false);


--
-- Name: tank_tank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tank_tank_id_seq', 3, true);


--
-- Data for Name: water_test_parameter; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (1, 'salinity', true, false, 'Salinity', 'NaCl', '#7633BD');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (2, 'ph', true, true, 'Ph', 'Ph', '#A23C3C');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (3, 'ammonia', true, true, 'Ammonia', 'NH<sub>4</sub>', '#AFD8F8');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (4, 'nitrite', true, true, 'Nitrite', 'NO<sub>2</sub>', '#8CACC6');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (5, 'nitrate', true, true, 'Nitrate', 'NO<sub>3</sub>', '#BD9B33');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (6, 'calcium', true, false, 'Calcium', 'Ca', '#CB4B4B');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (7, 'phosphate', true, false, 'Phosphate', 'PO<sub>4</sub>', '#3D853D');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (8, 'magnesium', true, false, 'Magnesium', 'Mg', '#9440ED');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (9, 'kh', true, false, 'Carbonate Hardness', '&deg;KH', '#4DA74D');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (10, 'gh', false, true, 'General Hardness', 'GH', '#4DA74D');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (11, 'copper', false, false, 'Copper', 'Cu', '#4DA74D');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (12, 'iodine', false, false, 'Iodine', 'I', '#4DA74D');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (13, 'strontium', false, false, 'Strontium', 'Sr', '#4DA74D');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (14, 'temperature', true, true, 'Temperature', 'Temp', '#4DA74D');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (15, 'water_change', true, true, 'Water Change', 'Water Change', '#4DA74D');
INSERT INTO water_test_parameter (parameter_id, parameter, salt_water, fresh_water, title, label, rgb_colour) VALUES (16, 'tds', false, false, 'Total Dissolved Solids', 'TDS', '#4DA74D');


--
-- Data for Name: tank_water_test_parameter; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 2, 'ph', 'Ph', 'Ph', '#A23C3C', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 5, 'nitrate', 'Nitrate', 'NO<sub>3</sub>', '#BD9B33', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 6, 'calcium', 'Calcium', 'Ca', '#CB4B4B', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 7, 'phosphate', 'Phosphate', 'PO<sub>4</sub>', '#3D853D', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 8, 'magnesium', 'Magnesium', 'Mg', '#9440ED', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 9, 'kh', 'Carbonate Hardness', '&deg;KH', '#A64C9D', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 14, 'temperature', 'Temperature', 'Temp', '#DAF252', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 15, 'water_change', 'Water Change', 'Water Change', '#11F011', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (2, 2, 'ph', 'Ph', 'Ph', '#A23C3C', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (2, 3, 'ammonia', 'Ammonia', 'NH<sub>4</sub>', '#AFD8F8', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (2, 4, 'nitrite', 'Nitrite', 'NO<sub>2</sub>', '#8CACC6', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (2, 5, 'nitrate', 'Nitrate', 'NO<sub>3</sub>', '#BD9B33', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (2, 14, 'temperature', 'Temperature', 'Temp', '#0734A6', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (2, 15, 'water_change', 'Water Change', 'Water Change', '#F01F68', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 1, 'salinity', 'Salinity', 'NaCl', '#7633BD', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 2, 'ph', 'Ph', 'Ph', '#A23C3C', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 5, 'nitrate', 'Nitrate', 'NO<sub>3</sub>', '#BD9B33', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 6, 'calcium', 'Calcium', 'Ca', '#CB4B4B', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 7, 'phosphate', 'Phosphate', 'PO<sub>4</sub>', '#3D853D', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 8, 'magnesium', 'Magnesium', 'Mg', '#9440ED', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 9, 'kh', 'Carbonate Hardness', '&deg;KH', '#F70233', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 14, 'temperature', 'Temperature', 'Temp', '#F7F700', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 15, 'water_change', 'Water Change', 'Water Change', '#E35E1B', true, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 3, 'ammonia', 'Ammonia', 'NH<sub>4</sub>', '#AFD8F8', false, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 4, 'nitrite', 'Nitrite', 'NO<sub>2</sub>', '#8CACC6', false, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (2, 10, 'gh', 'General Hardness', 'GH', '#E8F714', false, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 3, 'ammonia', 'Ammonia', 'NH<sub>4</sub>', '#AFD8F8', false, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (3, 4, 'nitrite', 'Nitrite', 'NO<sub>2</sub>', '#8CACC6', false, true, NULL);
INSERT INTO tank_water_test_parameter (tank_id, parameter_id, parameter, title, label, rgb_colour, active, chart, param_order) VALUES (1, 1, 'salinity', 'Salinity', 'NaCl', '#11F011', true, true, NULL);


--
-- Data for Name: user_preferences; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO user_preferences (user_id, recs_per_page, tank_order_col, tank_order_seq, water_test_order_col, water_test_order_seq, updated_on) VALUES (1, 10, 'tank_id', 'asc', 'test_date', 'desc', '2015-09-26 13:58:53');


--
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_user_id_seq', 1, true);


--
-- Name: water_test_parameter_parameter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('water_test_parameter_parameter_id_seq', 16, true);


--
-- Data for Name: water_test_result; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1, 1, 1, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (2, 1, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (3, 1, 1, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (4, 1, 1, 9, 14);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (5, 1, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (6, 1, 1, 7, 2.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (7, 1, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (8, 1, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (9, 1, 1, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (10, 1, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (11, 1, 1, 6, 320);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (12, 2, 1, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (13, 2, 1, 1, 1.029);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (14, 2, 1, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (15, 2, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (16, 2, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (17, 2, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (18, 2, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (19, 2, 1, 7, 2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (20, 2, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (21, 2, 1, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (23, 3, 1, 1, 1.029);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (24, 3, 1, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (25, 3, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (26, 3, 1, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (27, 3, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (28, 3, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (29, 3, 1, 7, 1.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (30, 3, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (31, 3, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (32, 3, 1, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (33, 3, 1, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (22, 2, 1, 6, 300);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (34, 4, 1, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (35, 4, 1, 2, 8.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (36, 4, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (37, 4, 1, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (38, 4, 1, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (39, 4, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (40, 4, 1, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (41, 4, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (42, 4, 1, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (43, 4, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (44, 4, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (45, 5, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (46, 5, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (47, 5, 2, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (48, 5, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (49, 5, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (50, 5, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (51, 6, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (52, 6, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (53, 6, 1, 9, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (54, 6, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (55, 6, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (56, 6, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (57, 6, 1, 1, 1.029);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (58, 6, 1, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (59, 6, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (60, 7, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (61, 7, 1, 9, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (62, 7, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (63, 7, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (64, 7, 1, 6, 380);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (65, 7, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (66, 7, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (67, 7, 1, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (68, 7, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (69, 8, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (70, 8, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (71, 8, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (72, 8, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (73, 8, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (74, 8, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (75, 8, 1, 6, 400);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (76, 8, 1, 1, 1.029);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (77, 8, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (78, 9, 2, 2, 6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (79, 9, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (80, 9, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (81, 9, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (82, 9, 2, 5, 160);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (83, 9, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (84, 10, 2, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (85, 10, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (86, 10, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (87, 10, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (88, 10, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (89, 10, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (90, 11, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (91, 11, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (92, 11, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (93, 11, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (94, 11, 2, 2, 7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (95, 11, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (96, 12, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (97, 12, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (98, 12, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (99, 12, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (100, 12, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (101, 12, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (102, 13, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (103, 13, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (104, 13, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (105, 13, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (106, 13, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (107, 13, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (108, 13, 1, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (109, 13, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (110, 13, 1, 6, 380);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (111, 14, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (112, 14, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (113, 14, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (114, 14, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (115, 14, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (116, 14, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (117, 15, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (118, 15, 1, 2, 8.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (119, 15, 1, 8, 800);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (120, 15, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (121, 15, 1, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (122, 15, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (123, 15, 1, 6, 410);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (124, 15, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (125, 15, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (126, 16, 1, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (127, 16, 1, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (128, 16, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (129, 16, 1, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (130, 16, 1, 1, 1.025);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (131, 16, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (132, 16, 1, 6, 280);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (133, 16, 1, 5, 5.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (134, 16, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (135, 17, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (136, 17, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (137, 17, 1, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (138, 17, 1, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (139, 17, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (140, 17, 1, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (141, 17, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (142, 17, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (143, 17, 1, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (144, 18, 1, 9, 4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (145, 18, 1, 2, 8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (146, 18, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (147, 18, 1, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (148, 18, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (149, 18, 1, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (150, 18, 1, 6, 440);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (151, 18, 1, 1, 1.023);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (152, 18, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (153, 19, 1, 8, 1215);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (154, 19, 1, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (155, 19, 1, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (156, 19, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (157, 19, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (158, 19, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (159, 19, 1, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (160, 19, 1, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (161, 19, 1, 6, 415);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (162, 20, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (163, 20, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (164, 20, 1, 8, 1305);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (165, 20, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (166, 20, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (167, 20, 1, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (168, 20, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (169, 20, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (170, 20, 1, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (171, 21, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (172, 21, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (173, 21, 1, 1, 1.023);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (174, 21, 1, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (175, 21, 1, 6, 380);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (176, 21, 1, 8, 1170);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (177, 21, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (178, 21, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (179, 21, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (180, 22, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (181, 22, 1, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (182, 22, 1, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (183, 22, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (184, 22, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (185, 22, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (186, 22, 1, 9, 8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (187, 22, 1, 8, 1140);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (188, 22, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (189, 23, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (190, 23, 1, 8, 1170);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (191, 23, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (192, 23, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (193, 23, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (194, 23, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (195, 23, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (196, 23, 1, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (197, 23, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (198, 24, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (199, 24, 1, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (200, 24, 1, 1, 1.023);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (201, 24, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (202, 24, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (203, 24, 1, 7, 0.25);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (204, 24, 1, 9, 8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (205, 24, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (206, 24, 1, 8, 1185);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (207, 25, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (208, 25, 1, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (209, 25, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (210, 25, 1, 1, 1.023);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (211, 25, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (212, 25, 1, 7, 0.25);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (213, 25, 1, 9, 7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (214, 25, 1, 8, 1155);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (215, 25, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (216, 26, 1, 7, 0.10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (217, 26, 1, 9, 8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (218, 26, 1, 8, 1140);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (219, 26, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (220, 26, 1, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (221, 26, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (222, 26, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (223, 26, 1, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (224, 26, 1, 14, 24.7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (225, 27, 1, 7, 0.10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (226, 27, 1, 9, 7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (227, 27, 1, 8, 1185);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (228, 27, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (229, 27, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (230, 27, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (231, 27, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (232, 27, 1, 1, 1.023);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (233, 27, 1, 14, 24.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (234, 28, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (235, 28, 1, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (236, 28, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (237, 28, 1, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (238, 28, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (239, 28, 1, 7, 0.10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (240, 28, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (241, 28, 1, 8, 1065);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (242, 28, 1, 9, 7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (243, 29, 1, 9, 8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (244, 29, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (245, 29, 1, 8, 1260);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (246, 29, 1, 7, 0.10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (247, 29, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (248, 29, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (249, 29, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (250, 29, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (251, 29, 1, 1, 1.025);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (252, 30, 1, 7, 0.10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (253, 30, 1, 8, 1035);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (254, 30, 1, 2, 8.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (255, 30, 1, 9, 7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (256, 30, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (257, 30, 1, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (258, 30, 1, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (259, 30, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (260, 30, 1, 14, 25.9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (261, 31, 1, 9, 7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (262, 31, 1, 8, 1155);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (263, 31, 1, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (264, 31, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (265, 31, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (266, 31, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (267, 31, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (268, 31, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (269, 31, 1, 1, 1.025);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (270, 32, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (271, 32, 1, 8, 1065);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (272, 32, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (273, 32, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (274, 32, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (275, 32, 1, 6, 420);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (276, 32, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (277, 32, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (278, 32, 1, 1, 1.025);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (279, 33, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (280, 33, 1, 6, 420);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (281, 33, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (282, 33, 1, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (283, 33, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (284, 33, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (285, 33, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (286, 33, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (287, 33, 1, 8, 1125);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (288, 34, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (289, 34, 1, 6, 400);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (290, 34, 1, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (291, 34, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (292, 34, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (293, 34, 1, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (294, 34, 1, 9, 8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (295, 34, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (296, 34, 1, 8, 1170);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (297, 35, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (298, 35, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (299, 35, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (300, 35, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (301, 35, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (302, 35, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (303, 36, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (304, 36, 2, 2, 7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (305, 36, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (306, 36, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (307, 36, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (308, 36, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (309, 37, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (310, 37, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (311, 37, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (312, 37, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (313, 37, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (314, 37, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (315, 38, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (316, 38, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (317, 38, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (318, 38, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (319, 38, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (320, 38, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (321, 39, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (322, 39, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (323, 39, 2, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (324, 39, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (325, 39, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (326, 39, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (327, 40, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (328, 40, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (329, 40, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (330, 40, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (331, 40, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (332, 40, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (333, 41, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (334, 41, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (335, 41, 2, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (336, 41, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (337, 41, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (338, 41, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (339, 42, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (340, 42, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (341, 42, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (342, 42, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (343, 42, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (344, 42, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (345, 43, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (346, 43, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (347, 43, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (348, 43, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (349, 43, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (350, 43, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (351, 44, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (352, 44, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (353, 44, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (354, 44, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (355, 44, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (356, 44, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (357, 45, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (358, 45, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (359, 45, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (360, 45, 2, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (361, 45, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (362, 45, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (363, 46, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (364, 46, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (365, 46, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (366, 46, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (367, 46, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (368, 46, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (369, 47, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (370, 47, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (371, 47, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (372, 47, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (373, 47, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (374, 47, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (375, 48, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (376, 48, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (377, 48, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (378, 48, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (379, 48, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (380, 48, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (381, 49, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (382, 49, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (383, 49, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (384, 49, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (385, 49, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (386, 49, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (387, 50, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (388, 50, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (389, 50, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (390, 50, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (391, 50, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (392, 50, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (393, 51, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (394, 51, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (395, 51, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (396, 51, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (397, 51, 2, 14, 26.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (398, 51, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (399, 52, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (400, 52, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (401, 52, 2, 15, 110);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (402, 52, 2, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (403, 52, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (404, 52, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (405, 53, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (406, 53, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (407, 53, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (408, 53, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (409, 53, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (410, 53, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (411, 54, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (412, 54, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (413, 54, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (414, 54, 2, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (415, 54, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (416, 54, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (417, 55, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (418, 55, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (419, 55, 2, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (420, 55, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (421, 55, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (422, 55, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (423, 56, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (424, 56, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (425, 56, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (426, 56, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (427, 56, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (428, 56, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (429, 57, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (430, 57, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (431, 57, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (432, 57, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (433, 57, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (434, 57, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (435, 58, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (436, 58, 2, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (437, 58, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (438, 58, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (439, 58, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (440, 58, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (441, 59, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (442, 59, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (443, 59, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (444, 59, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (445, 59, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (446, 59, 2, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (447, 60, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (448, 60, 3, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (449, 60, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (450, 60, 3, 1, 1.025);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (451, 60, 3, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (452, 60, 3, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (453, 60, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (454, 60, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (455, 60, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (456, 60, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (457, 60, 3, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (458, 61, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (459, 61, 3, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (460, 61, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (461, 61, 3, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (462, 61, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (463, 61, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (464, 61, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (465, 61, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (466, 61, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (467, 62, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (468, 62, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (469, 62, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (470, 62, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (471, 62, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (472, 62, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (473, 62, 3, 1, 1.025);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (474, 62, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (475, 62, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (476, 63, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (477, 63, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (478, 63, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (479, 63, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (480, 63, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (481, 63, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (482, 63, 3, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (483, 63, 3, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (484, 63, 3, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (485, 64, 3, 1, 1.025);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (486, 64, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (487, 64, 3, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (488, 64, 3, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (489, 64, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (490, 64, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (491, 64, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (492, 64, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (493, 64, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (494, 65, 3, 6, 380);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (495, 65, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (496, 65, 3, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (497, 65, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (498, 65, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (499, 65, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (500, 65, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (501, 65, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (502, 65, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (503, 66, 3, 6, 440);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (504, 66, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (505, 66, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (506, 66, 3, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (507, 66, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (508, 66, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (509, 66, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (510, 66, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (511, 66, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (512, 67, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (513, 67, 3, 6, 380);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (514, 67, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (515, 67, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (516, 67, 3, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (517, 67, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (518, 67, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (519, 67, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (520, 67, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (521, 68, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (522, 68, 3, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (523, 68, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (524, 68, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (525, 68, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (526, 68, 3, 6, 440);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (527, 68, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (528, 68, 3, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (529, 68, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (530, 69, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (531, 69, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (532, 69, 3, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (533, 69, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (534, 69, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (535, 69, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (536, 69, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (537, 69, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (538, 69, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (539, 70, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (540, 70, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (541, 70, 3, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (542, 70, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (543, 70, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (544, 70, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (545, 70, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (546, 70, 3, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (547, 70, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (548, 71, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (549, 71, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (550, 71, 3, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (551, 71, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (552, 71, 3, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (553, 71, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (554, 71, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (555, 71, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (556, 71, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (557, 72, 3, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (558, 72, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (559, 72, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (560, 72, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (561, 72, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (562, 72, 3, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (563, 72, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (564, 72, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (565, 72, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (566, 73, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (567, 73, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (568, 73, 3, 6, 380);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (569, 73, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (570, 73, 3, 1, 1.025);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (571, 73, 3, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (572, 73, 3, 8, 1065);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (573, 73, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (574, 73, 3, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (575, 74, 3, 8, 1140);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (576, 74, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (577, 74, 3, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (578, 74, 3, 7, 0.03);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (579, 74, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (580, 74, 3, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (581, 74, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (582, 74, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (583, 74, 3, 6, 400);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (584, 75, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (585, 75, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (586, 75, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (587, 75, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (588, 75, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (589, 75, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (590, 76, 1, 9, 15);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (591, 76, 1, 6, 320);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (592, 76, 1, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (593, 76, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (594, 76, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (595, 76, 1, 7, 0.10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (596, 76, 1, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (597, 76, 1, 8, 1095);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (598, 76, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (599, 77, 1, 7, 0.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (600, 77, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (601, 77, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (602, 77, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (603, 77, 1, 6, 280);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (604, 77, 1, 9, 17);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (605, 77, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (606, 77, 1, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (607, 77, 1, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (608, 78, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (609, 78, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (610, 78, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (611, 78, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (612, 78, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (613, 78, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (614, 79, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (615, 79, 1, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (616, 79, 1, 8, 1200);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (617, 79, 1, 9, 11);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (618, 79, 1, 6, 360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (619, 79, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (620, 79, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (621, 79, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (622, 79, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (623, 80, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (624, 80, 2, 3, 0.25);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (625, 80, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (626, 80, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (627, 80, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (628, 80, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (629, 81, 1, 7, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (630, 81, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (631, 81, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (632, 81, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (633, 81, 1, 6, 400);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (634, 81, 1, 9, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (635, 81, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (636, 81, 1, 8, 1360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (637, 81, 1, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (638, 82, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (639, 82, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (640, 82, 3, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (641, 82, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (642, 82, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (643, 82, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (644, 82, 3, 2, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (645, 82, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (646, 82, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (647, 83, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (648, 83, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (649, 83, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (650, 83, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (651, 83, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (652, 83, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (653, 84, 3, 5, 5.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (654, 84, 3, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (655, 84, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (656, 84, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (657, 84, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (658, 84, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (659, 84, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (660, 84, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (661, 84, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (662, 85, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (663, 85, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (664, 85, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (665, 85, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (666, 85, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (667, 85, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (668, 86, 1, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (669, 86, 1, 8, 1160);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (670, 86, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (671, 86, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (672, 86, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (673, 86, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (674, 86, 1, 7, 0.50);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (675, 86, 1, 9, 13);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (676, 86, 1, 6, 460);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (677, 87, 3, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (678, 87, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (679, 87, 3, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (680, 87, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (681, 87, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (682, 87, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (683, 87, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (684, 87, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (685, 87, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (686, 88, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (687, 88, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (688, 88, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (689, 88, 2, 2, 7.20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (690, 88, 2, 3, 0.25);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (691, 88, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (692, 89, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (693, 89, 2, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (694, 89, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (695, 89, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (696, 89, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (697, 89, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (698, 90, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (699, 90, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (700, 90, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (701, 90, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (702, 90, 3, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (703, 90, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (704, 90, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (705, 90, 3, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (706, 90, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (707, 91, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (708, 91, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (709, 91, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (710, 91, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (711, 91, 1, 9, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (712, 91, 1, 6, 420);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (713, 91, 1, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (714, 91, 1, 8, 1240);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (715, 91, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (716, 92, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (717, 92, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (718, 92, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (719, 92, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (720, 92, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (721, 92, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (722, 93, 1, 8, 1240);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (723, 93, 1, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (724, 93, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (725, 93, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (726, 93, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (727, 93, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (728, 93, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (729, 93, 1, 9, 11);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (730, 93, 1, 6, 460);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (731, 94, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (732, 94, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (733, 94, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (734, 94, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (735, 94, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (736, 94, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (737, 95, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (738, 95, 3, 1, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (739, 95, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (740, 95, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (741, 95, 3, 2, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (742, 95, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (743, 95, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (744, 95, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (745, 95, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (746, 96, 1, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (747, 96, 1, 8, 1200);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (748, 96, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (749, 96, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (750, 96, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (751, 96, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (752, 96, 1, 7, 0.25);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (753, 96, 1, 9, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (754, 96, 1, 6, 420);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (755, 97, 1, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (756, 97, 1, 8, 1220);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (757, 97, 1, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (758, 97, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (759, 97, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (760, 97, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (761, 97, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (762, 97, 1, 6, 420);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (763, 97, 1, 9, 11);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (764, 98, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (765, 98, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (766, 98, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (767, 98, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (768, 98, 2, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (769, 98, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (770, 99, 3, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (771, 99, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (772, 99, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (773, 99, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (774, 99, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (775, 99, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (776, 99, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (777, 99, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (778, 99, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (779, 100, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (780, 100, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (781, 100, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (782, 100, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (783, 100, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (784, 100, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (785, 101, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (786, 101, 3, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (787, 101, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (788, 101, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (789, 101, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (790, 101, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (791, 101, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (792, 101, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (793, 101, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (794, 102, 1, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (795, 102, 1, 8, 1100);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (796, 102, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (797, 102, 1, 6, 480);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (798, 102, 1, 9, 11);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (799, 102, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (800, 102, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (801, 102, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (802, 102, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (803, 103, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (804, 103, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (805, 103, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (806, 103, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (807, 103, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (808, 103, 2, 2, 7.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (809, 104, 1, 6, 480);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (810, 104, 1, 9, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (811, 104, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (812, 104, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (813, 104, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (814, 104, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (815, 104, 1, 8, 1120);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (816, 104, 1, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (817, 104, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (818, 105, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (819, 105, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (820, 105, 3, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (821, 105, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (822, 105, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (823, 105, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (824, 105, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (825, 105, 3, 9, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (826, 105, 3, 6, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (827, 106, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (828, 106, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (829, 106, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (830, 106, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (831, 106, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (832, 106, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (833, 107, 2, 2, 7.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (834, 107, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (835, 107, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (836, 107, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (837, 107, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (838, 107, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (839, 108, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (840, 108, 1, 6, 420);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (841, 108, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (842, 108, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (843, 108, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (844, 108, 1, 7, 0.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (845, 108, 1, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (846, 108, 1, 8, 1160);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (847, 108, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (848, 109, 2, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (849, 109, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (850, 109, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (851, 109, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (852, 109, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (853, 109, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (854, 110, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (855, 110, 3, 8, 1120);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (856, 110, 3, 1, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (857, 110, 3, 9, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (858, 110, 3, 6, 280);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (859, 110, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (860, 110, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (861, 110, 3, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (862, 110, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (863, 111, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (864, 111, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (865, 111, 3, 2, 8.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (866, 111, 3, 14, 25.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (867, 111, 3, 6, 320);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (868, 111, 3, 9, 7);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (869, 111, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (870, 111, 3, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (871, 111, 3, 8, 1160);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (872, 112, 1, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (873, 112, 1, 8, 1360);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (874, 112, 1, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (875, 112, 1, 7, 1.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (876, 112, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (877, 112, 1, 14, 24.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (878, 112, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (879, 112, 1, 6, 380);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (880, 112, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (881, 113, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (882, 113, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (883, 113, 2, 2, 6.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (884, 113, 2, 14, 23.9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (885, 113, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (886, 113, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (887, 114, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (888, 114, 2, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (889, 114, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (890, 114, 2, 3, 0.25);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (891, 114, 2, 2, 6.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (892, 114, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (893, 115, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (894, 115, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (895, 115, 2, 15, 100);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (896, 115, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (897, 115, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (898, 115, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (899, 116, 3, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (900, 116, 3, 1, 1.028);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (901, 116, 3, 8, 1140);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (902, 116, 3, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (903, 116, 3, 9, 6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (904, 116, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (905, 116, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (906, 116, 3, 2, 8.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (907, 116, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (908, 117, 1, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (909, 117, 1, 1, 1.027);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (910, 117, 1, 8, 1080);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (911, 117, 1, 6, 320);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (912, 117, 1, 9, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (913, 117, 1, 7, 0.25);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (914, 117, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (915, 117, 1, 2, 8.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (916, 117, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (917, 118, 2, 5, 160);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (918, 118, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (919, 118, 2, 2, 6.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (920, 118, 2, 14, 23.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (921, 118, 2, 15, 150);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (922, 118, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (923, 119, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (924, 119, 2, 2, 7.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (925, 119, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (926, 119, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (927, 119, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (928, 119, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (929, 120, 1, 7, 2.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (930, 120, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (931, 120, 1, 14, 25.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (932, 120, 1, 2, 8.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (933, 120, 1, 6, 400);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (934, 120, 1, 9, 8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (935, 120, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (936, 120, 1, 8, 1120);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (937, 120, 1, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (938, 121, 2, 5, 160);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (939, 121, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (940, 121, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (941, 121, 2, 15, 120);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (942, 121, 2, 2, 6.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (943, 121, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (944, 122, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (945, 122, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (946, 122, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (947, 122, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (948, 122, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (949, 122, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (950, 123, 1, 6, 400);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (951, 123, 1, 9, 9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (952, 123, 1, 7, 2.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (953, 123, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (954, 123, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (955, 123, 1, 2, 8.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (956, 123, 1, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (957, 123, 1, 8, 1080);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (958, 123, 1, 1, 1.024);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (959, 124, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (960, 124, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (961, 124, 2, 2, 6.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (962, 124, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (963, 124, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (964, 124, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (965, 125, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (966, 125, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (967, 125, 2, 14, 23.3);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (968, 125, 2, 2, 6.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (969, 125, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (970, 125, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (971, 126, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (972, 126, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (973, 126, 2, 2, 6.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (974, 126, 2, 14, 24.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (975, 126, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (976, 126, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (977, 127, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (978, 127, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (979, 127, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (980, 127, 2, 2, 6.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (981, 127, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (982, 127, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (983, 128, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (984, 128, 2, 5, 20);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (985, 128, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (986, 128, 2, 2, 6.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (987, 128, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (988, 128, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (989, 129, 1, 7, 0.1);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (990, 129, 1, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (991, 129, 1, 2, 8.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (992, 129, 1, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (993, 129, 1, 6, 440);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (994, 129, 1, 9, 8.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (995, 129, 1, 5, 5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (996, 129, 1, 1, 1.029);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (997, 129, 1, 8, 1040);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (998, 130, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (999, 130, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1000, 130, 2, 2, 7.6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1001, 130, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1002, 130, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1003, 130, 2, 5, 40);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1004, 131, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1005, 131, 2, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1006, 131, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1007, 131, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1008, 131, 2, 2, 6.2);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1009, 131, 2, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1010, 132, 3, 9, 6);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1011, 132, 3, 6, 340);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1012, 132, 3, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1013, 132, 3, 7, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1014, 132, 3, 2, 7.8);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1015, 132, 3, 14, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1016, 132, 3, 5, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1017, 132, 3, 8, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1018, 132, 3, 1, 1.026);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1019, 133, 2, 2, 6.0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1020, 133, 2, 14, 23.5);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1021, 133, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1022, 133, 2, 15, 140);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1023, 133, 2, 4, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1024, 133, 2, 5, 80);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1025, 134, 2, 3, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1026, 134, 2, 15, 0);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1027, 134, 2, 2, 6.4);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1028, 134, 2, 14, 23.9);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1029, 134, 2, 5, 10);
INSERT INTO water_test_result (test_result_id, test_id, tank_id, parameter_id, test_result) VALUES (1030, 134, 2, 4, 0);


--
-- Name: water_test_result_test_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('water_test_result_test_result_id_seq', 1030, true);


--
-- Name: water_test_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('water_test_test_id_seq', 134, true);


--
-- PostgreSQL database dump complete
--

