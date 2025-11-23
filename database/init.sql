--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg120+2)
-- Dumped by pg_dump version 17.4 (Debian 17.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cui; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.cui (
    clientipaddress inet DEFAULT '0.0.0.0'::inet NOT NULL,
    callingstationid character varying(50) DEFAULT ''::character varying NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    cui character varying(32) DEFAULT ''::character varying NOT NULL,
    creationdate timestamp with time zone DEFAULT '2025-04-04 01:37:30.984001+00'::timestamp with time zone NOT NULL,
    lastaccounting timestamp with time zone DEFAULT '-infinity'::timestamp without time zone NOT NULL
);


ALTER TABLE public.cui OWNER TO radius;

--
-- Name: nas; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.nas (
    id integer NOT NULL,
    nasname text NOT NULL,
    shortname text NOT NULL,
    type text DEFAULT 'other'::text NOT NULL,
    ports integer,
    secret text NOT NULL,
    server text,
    community text,
    description text
);


ALTER TABLE public.nas OWNER TO radius;

--
-- Name: nas_id_seq; Type: SEQUENCE; Schema: public; Owner: radius
--

CREATE SEQUENCE public.nas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nas_id_seq OWNER TO radius;

--
-- Name: nas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: radius
--

ALTER SEQUENCE public.nas_id_seq OWNED BY public.nas.id;


--
-- Name: radacct; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.radacct (
    radacctid bigint NOT NULL,
    acctsessionid text NOT NULL,
    acctuniqueid text NOT NULL,
    username text,
    realm text,
    nasipaddress inet NOT NULL,
    nasportid text,
    nasporttype text,
    acctstarttime timestamp with time zone,
    acctupdatetime timestamp with time zone,
    acctstoptime timestamp with time zone,
    acctinterval bigint,
    acctsessiontime bigint,
    acctauthentic text,
    connectinfo_start text,
    connectinfo_stop text,
    acctinputoctets bigint,
    acctoutputoctets bigint,
    calledstationid text,
    callingstationid text,
    acctterminatecause text,
    servicetype text,
    framedprotocol text,
    framedipaddress inet,
    framedipv6address inet,
    framedipv6prefix inet,
    framedinterfaceid text,
    delegatedipv6prefix inet,
    class text
);


ALTER TABLE public.radacct OWNER TO radius;

--
-- Name: radacct_radacctid_seq; Type: SEQUENCE; Schema: public; Owner: radius
--

CREATE SEQUENCE public.radacct_radacctid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.radacct_radacctid_seq OWNER TO radius;

--
-- Name: radacct_radacctid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: radius
--

ALTER SEQUENCE public.radacct_radacctid_seq OWNED BY public.radacct.radacctid;


--
-- Name: radcheck; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.radcheck (
    id integer NOT NULL,
    username text DEFAULT ''::text NOT NULL,
    attribute text DEFAULT 'Cleartext-Password'::text NOT NULL,
    op character varying(2) DEFAULT ':='::character varying NOT NULL,
    value text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.radcheck OWNER TO radius;

--
-- Name: radcheck_id_seq; Type: SEQUENCE; Schema: public; Owner: radius
--

CREATE SEQUENCE public.radcheck_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.radcheck_id_seq OWNER TO radius;

--
-- Name: radcheck_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: radius
--

ALTER SEQUENCE public.radcheck_id_seq OWNED BY public.radcheck.id;


--
-- Name: radgroupcheck; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.radgroupcheck (
    id integer NOT NULL,
    groupname text DEFAULT ''::text NOT NULL,
    attribute text DEFAULT ''::text NOT NULL,
    op character varying(2) DEFAULT ':='::character varying NOT NULL,
    value text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.radgroupcheck OWNER TO radius;

--
-- Name: radgroupcheck_id_seq; Type: SEQUENCE; Schema: public; Owner: radius
--

CREATE SEQUENCE public.radgroupcheck_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.radgroupcheck_id_seq OWNER TO radius;

--
-- Name: radgroupcheck_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: radius
--

ALTER SEQUENCE public.radgroupcheck_id_seq OWNED BY public.radgroupcheck.id;


--
-- Name: radgroupreply; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.radgroupreply (
    id integer NOT NULL,
    groupname text DEFAULT ''::text NOT NULL,
    attribute text DEFAULT ''::text NOT NULL,
    op character varying(2) DEFAULT '='::character varying NOT NULL,
    value text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.radgroupreply OWNER TO radius;

--
-- Name: radgroupreply_id_seq; Type: SEQUENCE; Schema: public; Owner: radius
--

CREATE SEQUENCE public.radgroupreply_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.radgroupreply_id_seq OWNER TO radius;

--
-- Name: radgroupreply_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: radius
--

ALTER SEQUENCE public.radgroupreply_id_seq OWNED BY public.radgroupreply.id;


--
-- Name: radpostauth; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.radpostauth (
    id bigint NOT NULL,
    username text NOT NULL,
    pass text,
    reply text,
    calledstationid text,
    callingstationid text,
    authdate timestamp with time zone DEFAULT now() NOT NULL,
    class text
);


ALTER TABLE public.radpostauth OWNER TO radius;

--
-- Name: radpostauth_id_seq; Type: SEQUENCE; Schema: public; Owner: radius
--

CREATE SEQUENCE public.radpostauth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.radpostauth_id_seq OWNER TO radius;

--
-- Name: radpostauth_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: radius
--

ALTER SEQUENCE public.radpostauth_id_seq OWNED BY public.radpostauth.id;


--
-- Name: radreply; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.radreply (
    id integer NOT NULL,
    username text DEFAULT ''::text NOT NULL,
    attribute text DEFAULT ''::text NOT NULL,
    op character varying(2) DEFAULT '='::character varying NOT NULL,
    value text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.radreply OWNER TO radius;

--
-- Name: radreply_id_seq; Type: SEQUENCE; Schema: public; Owner: radius
--

CREATE SEQUENCE public.radreply_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.radreply_id_seq OWNER TO radius;

--
-- Name: radreply_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: radius
--

ALTER SEQUENCE public.radreply_id_seq OWNED BY public.radreply.id;


--
-- Name: radusergroup; Type: TABLE; Schema: public; Owner: radius
--

CREATE TABLE public.radusergroup (
    id integer NOT NULL,
    username text DEFAULT ''::text NOT NULL,
    groupname text DEFAULT ''::text NOT NULL,
    priority integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.radusergroup OWNER TO radius;

--
-- Name: radusergroup_id_seq; Type: SEQUENCE; Schema: public; Owner: radius
--

CREATE SEQUENCE public.radusergroup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.radusergroup_id_seq OWNER TO radius;

--
-- Name: radusergroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: radius
--

ALTER SEQUENCE public.radusergroup_id_seq OWNED BY public.radusergroup.id;


--
-- Name: nas id; Type: DEFAULT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.nas ALTER COLUMN id SET DEFAULT nextval('public.nas_id_seq'::regclass);


--
-- Name: radacct radacctid; Type: DEFAULT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radacct ALTER COLUMN radacctid SET DEFAULT nextval('public.radacct_radacctid_seq'::regclass);


--
-- Name: radcheck id; Type: DEFAULT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radcheck ALTER COLUMN id SET DEFAULT nextval('public.radcheck_id_seq'::regclass);


--
-- Name: radgroupcheck id; Type: DEFAULT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radgroupcheck ALTER COLUMN id SET DEFAULT nextval('public.radgroupcheck_id_seq'::regclass);


--
-- Name: radgroupreply id; Type: DEFAULT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radgroupreply ALTER COLUMN id SET DEFAULT nextval('public.radgroupreply_id_seq'::regclass);


--
-- Name: radpostauth id; Type: DEFAULT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radpostauth ALTER COLUMN id SET DEFAULT nextval('public.radpostauth_id_seq'::regclass);


--
-- Name: radreply id; Type: DEFAULT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radreply ALTER COLUMN id SET DEFAULT nextval('public.radreply_id_seq'::regclass);


--
-- Name: radusergroup id; Type: DEFAULT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radusergroup ALTER COLUMN id SET DEFAULT nextval('public.radusergroup_id_seq'::regclass);


--
-- Data for Name: cui; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.cui (clientipaddress, callingstationid, username, cui, creationdate, lastaccounting) FROM stdin;
\.


--
-- Data for Name: nas; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.nas (id, nasname, shortname, type, ports, secret, server, community, description) FROM stdin;
1	0.0.0.0/0	all	other	\N	94y3k64jZw5J75h	default	\N	\N
\.


--
-- Data for Name: radacct; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.radacct (radacctid, acctsessionid, acctuniqueid, username, realm, nasipaddress, nasportid, nasporttype, acctstarttime, acctupdatetime, acctstoptime, acctinterval, acctsessiontime, acctauthentic, connectinfo_start, connectinfo_stop, acctinputoctets, acctoutputoctets, calledstationid, callingstationid, acctterminatecause, servicetype, framedprotocol, framedipaddress, framedipv6address, framedipv6prefix, framedinterfaceid, delegatedipv6prefix, class) FROM stdin;
\.


--
-- Data for Name: radcheck; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.radcheck (id, username, attribute, op, value) FROM stdin;
1	lfsegoro@github.com	Cleartext-Password	:=	8888
\.


--
-- Data for Name: radgroupcheck; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.radgroupcheck (id, groupname, attribute, op, value) FROM stdin;
\.


--
-- Data for Name: radgroupreply; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.radgroupreply (id, groupname, attribute, op, value) FROM stdin;
\.


--
-- Data for Name: radpostauth; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.radpostauth (id, username, pass, reply, calledstationid, callingstationid, authdate, class) FROM stdin;
\.


--
-- Data for Name: radreply; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.radreply (id, username, attribute, op, value) FROM stdin;
\.


--
-- Data for Name: radusergroup; Type: TABLE DATA; Schema: public; Owner: radius
--

COPY public.radusergroup (id, username, groupname, priority) FROM stdin;
\.


--
-- Name: nas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: radius
--

SELECT pg_catalog.setval('public.nas_id_seq', 1, true);


--
-- Name: radacct_radacctid_seq; Type: SEQUENCE SET; Schema: public; Owner: radius
--

SELECT pg_catalog.setval('public.radacct_radacctid_seq', 1, false);


--
-- Name: radcheck_id_seq; Type: SEQUENCE SET; Schema: public; Owner: radius
--

SELECT pg_catalog.setval('public.radcheck_id_seq', 1, true);


--
-- Name: radgroupcheck_id_seq; Type: SEQUENCE SET; Schema: public; Owner: radius
--

SELECT pg_catalog.setval('public.radgroupcheck_id_seq', 1, false);


--
-- Name: radgroupreply_id_seq; Type: SEQUENCE SET; Schema: public; Owner: radius
--

SELECT pg_catalog.setval('public.radgroupreply_id_seq', 1, false);


--
-- Name: radpostauth_id_seq; Type: SEQUENCE SET; Schema: public; Owner: radius
--

SELECT pg_catalog.setval('public.radpostauth_id_seq', 1, false);


--
-- Name: radreply_id_seq; Type: SEQUENCE SET; Schema: public; Owner: radius
--

SELECT pg_catalog.setval('public.radreply_id_seq', 1, false);


--
-- Name: radusergroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: radius
--

SELECT pg_catalog.setval('public.radusergroup_id_seq', 1, false);


--
-- Name: cui cui_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.cui
    ADD CONSTRAINT cui_pkey PRIMARY KEY (username, clientipaddress, callingstationid);


--
-- Name: nas nas_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.nas
    ADD CONSTRAINT nas_pkey PRIMARY KEY (id);


--
-- Name: radacct radacct_acctuniqueid_key; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radacct
    ADD CONSTRAINT radacct_acctuniqueid_key UNIQUE (acctuniqueid);


--
-- Name: radacct radacct_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radacct
    ADD CONSTRAINT radacct_pkey PRIMARY KEY (radacctid);


--
-- Name: radcheck radcheck_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radcheck
    ADD CONSTRAINT radcheck_pkey PRIMARY KEY (id);


--
-- Name: radgroupcheck radgroupcheck_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radgroupcheck
    ADD CONSTRAINT radgroupcheck_pkey PRIMARY KEY (id);


--
-- Name: radgroupreply radgroupreply_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radgroupreply
    ADD CONSTRAINT radgroupreply_pkey PRIMARY KEY (id);


--
-- Name: radpostauth radpostauth_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radpostauth
    ADD CONSTRAINT radpostauth_pkey PRIMARY KEY (id);


--
-- Name: radreply radreply_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radreply
    ADD CONSTRAINT radreply_pkey PRIMARY KEY (id);


--
-- Name: radusergroup radusergroup_pkey; Type: CONSTRAINT; Schema: public; Owner: radius
--

ALTER TABLE ONLY public.radusergroup
    ADD CONSTRAINT radusergroup_pkey PRIMARY KEY (id);


--
-- Name: nas_nasname; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX nas_nasname ON public.nas USING btree (nasname);


--
-- Name: radacct_active_session_idx; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radacct_active_session_idx ON public.radacct USING btree (acctuniqueid) WHERE (acctstoptime IS NULL);


--
-- Name: radacct_bulk_close; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radacct_bulk_close ON public.radacct USING btree (nasipaddress, acctstarttime) WHERE (acctstoptime IS NULL);


--
-- Name: radacct_calss_idx; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radacct_calss_idx ON public.radacct USING btree (class);


--
-- Name: radacct_start_user_idx; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radacct_start_user_idx ON public.radacct USING btree (acctstarttime, username);


--
-- Name: radcheck_username; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radcheck_username ON public.radcheck USING btree (username, attribute);


--
-- Name: radgroupcheck_groupname; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radgroupcheck_groupname ON public.radgroupcheck USING btree (groupname, attribute);


--
-- Name: radgroupreply_groupname; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radgroupreply_groupname ON public.radgroupreply USING btree (groupname, attribute);


--
-- Name: radpostauth_class_idx; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radpostauth_class_idx ON public.radpostauth USING btree (class);


--
-- Name: radpostauth_username_idx; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radpostauth_username_idx ON public.radpostauth USING btree (username);


--
-- Name: radreply_username; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radreply_username ON public.radreply USING btree (username, attribute);


--
-- Name: radusergroup_username; Type: INDEX; Schema: public; Owner: radius
--

CREATE INDEX radusergroup_username ON public.radusergroup USING btree (username);


--
-- Name: cui postauth_query; Type: RULE; Schema: public; Owner: radius
--

CREATE RULE postauth_query AS
    ON INSERT TO public.cui
   WHERE (EXISTS ( SELECT 1
           FROM public.cui cui_1
          WHERE (((cui_1.username)::text = (new.username)::text) AND (cui_1.clientipaddress = new.clientipaddress) AND ((cui_1.callingstationid)::text = (new.callingstationid)::text)))) DO INSTEAD  UPDATE public.cui SET lastaccounting = '-infinity'::timestamp with time zone, cui = new.cui
  WHERE (((cui.username)::text = (new.username)::text) AND (cui.clientipaddress = new.clientipaddress) AND ((cui.callingstationid)::text = (new.callingstationid)::text));


--
-- PostgreSQL database dump complete
--

