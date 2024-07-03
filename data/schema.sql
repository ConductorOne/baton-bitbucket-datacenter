--
-- PostgreSQL database dump
--

-- Dumped from database version 15.6 (Debian 15.6-1.pgdg120+2)
-- Dumped by pg_dump version 15.6 (Debian 15.6-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: AO_02A6C0_REJECTED_REF; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_02A6C0_REJECTED_REF" (
    "ID" integer NOT NULL,
    "REF_DISPLAY_ID" character varying(450) NOT NULL,
    "REF_ID" character varying(450) NOT NULL,
    "REF_STATUS" integer DEFAULT 0 NOT NULL,
    "REPOSITORY_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_02A6C0_REJECTED_REF" OWNER TO bitbucket;

--
-- Name: AO_02A6C0_REJECTED_REF_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_02A6C0_REJECTED_REF_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_02A6C0_REJECTED_REF_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_02A6C0_REJECTED_REF_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_02A6C0_REJECTED_REF_ID_seq" OWNED BY public."AO_02A6C0_REJECTED_REF"."ID";


--
-- Name: AO_02A6C0_SYNC_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_02A6C0_SYNC_CONFIG" (
    "IS_ENABLED" boolean NOT NULL,
    "LAST_SYNC" timestamp without time zone NOT NULL,
    "REPOSITORY_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_02A6C0_SYNC_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_0E97B5_REPOSITORY_SHORTCUT; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_0E97B5_REPOSITORY_SHORTCUT" (
    "APPLICATION_LINK_ID" character varying(255),
    "CREATED_DATE" timestamp without time zone NOT NULL,
    "ID" integer NOT NULL,
    "LABEL" character varying(255) NOT NULL,
    "PRODUCT_TYPE" character varying(255),
    "REPOSITORY_ID" integer DEFAULT 0 NOT NULL,
    "URL" character varying(450) NOT NULL
);


ALTER TABLE public."AO_0E97B5_REPOSITORY_SHORTCUT" OWNER TO bitbucket;

--
-- Name: AO_0E97B5_REPOSITORY_SHORTCUT_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_0E97B5_REPOSITORY_SHORTCUT_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_0E97B5_REPOSITORY_SHORTCUT_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_0E97B5_REPOSITORY_SHORTCUT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_0E97B5_REPOSITORY_SHORTCUT_ID_seq" OWNED BY public."AO_0E97B5_REPOSITORY_SHORTCUT"."ID";


--
-- Name: AO_2AD648_INSIGHT_ANNOTATION; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_2AD648_INSIGHT_ANNOTATION" (
    "EXTERNAL_ID" character varying(450),
    "FK_REPORT_ID" bigint NOT NULL,
    "ID" bigint NOT NULL,
    "LINE" integer DEFAULT 0 NOT NULL,
    "LINK" text,
    "MESSAGE" text NOT NULL,
    "PATH" text,
    "PATH_MD5" character varying(32),
    "SEVERITY_ID" integer DEFAULT 0 NOT NULL,
    "TYPE_ID" integer
);


ALTER TABLE public."AO_2AD648_INSIGHT_ANNOTATION" OWNER TO bitbucket;

--
-- Name: AO_2AD648_INSIGHT_ANNOTATION_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_2AD648_INSIGHT_ANNOTATION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_2AD648_INSIGHT_ANNOTATION_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_2AD648_INSIGHT_ANNOTATION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_2AD648_INSIGHT_ANNOTATION_ID_seq" OWNED BY public."AO_2AD648_INSIGHT_ANNOTATION"."ID";


--
-- Name: AO_2AD648_INSIGHT_REPORT; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_2AD648_INSIGHT_REPORT" (
    "AUTHOR_ID" integer,
    "COMMIT_ID" character varying(40) NOT NULL,
    "COVERAGE_PROVIDER_KEY" character varying(450),
    "CREATED_DATE" timestamp without time zone NOT NULL,
    "DATA" text,
    "DETAILS" text,
    "ID" bigint NOT NULL,
    "LINK" text,
    "LOGO" text,
    "REPORTER" character varying(450),
    "REPORT_KEY" character varying(450) NOT NULL,
    "REPOSITORY_ID" integer NOT NULL,
    "RESULT_ID" integer,
    "TITLE" character varying(450) NOT NULL
);


ALTER TABLE public."AO_2AD648_INSIGHT_REPORT" OWNER TO bitbucket;

--
-- Name: AO_2AD648_INSIGHT_REPORT_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_2AD648_INSIGHT_REPORT_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_2AD648_INSIGHT_REPORT_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_2AD648_INSIGHT_REPORT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_2AD648_INSIGHT_REPORT_ID_seq" OWNED BY public."AO_2AD648_INSIGHT_REPORT"."ID";


--
-- Name: AO_2AD648_MERGE_CHECK; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_2AD648_MERGE_CHECK" (
    "ANNOTATION_SEVERITY" character varying(255),
    "ID" bigint NOT NULL,
    "MUST_PASS" boolean,
    "REPORT_KEY" character varying(450) NOT NULL,
    "RESOURCE_ID" integer NOT NULL,
    "SCOPE_TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_2AD648_MERGE_CHECK" OWNER TO bitbucket;

--
-- Name: AO_2AD648_MERGE_CHECK_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_2AD648_MERGE_CHECK_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_2AD648_MERGE_CHECK_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_2AD648_MERGE_CHECK_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_2AD648_MERGE_CHECK_ID_seq" OWNED BY public."AO_2AD648_MERGE_CHECK"."ID";


--
-- Name: AO_33D892_COMMENT_JIRA_ISSUE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_33D892_COMMENT_JIRA_ISSUE" (
    "COMMENT_ID" bigint DEFAULT 0 NOT NULL,
    "ID" integer NOT NULL,
    "ISSUE_KEY" character varying(450) NOT NULL
);


ALTER TABLE public."AO_33D892_COMMENT_JIRA_ISSUE" OWNER TO bitbucket;

--
-- Name: AO_33D892_COMMENT_JIRA_ISSUE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_33D892_COMMENT_JIRA_ISSUE_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_33D892_COMMENT_JIRA_ISSUE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_33D892_COMMENT_JIRA_ISSUE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_33D892_COMMENT_JIRA_ISSUE_ID_seq" OWNED BY public."AO_33D892_COMMENT_JIRA_ISSUE"."ID";


--
-- Name: AO_38321B_CUSTOM_CONTENT_LINK; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_38321B_CUSTOM_CONTENT_LINK" (
    "CONTENT_KEY" character varying(255),
    "ID" integer NOT NULL,
    "LINK_LABEL" character varying(255),
    "LINK_URL" character varying(255),
    "SEQUENCE" integer DEFAULT 0
);


ALTER TABLE public."AO_38321B_CUSTOM_CONTENT_LINK" OWNER TO bitbucket;

--
-- Name: AO_38321B_CUSTOM_CONTENT_LINK_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_38321B_CUSTOM_CONTENT_LINK_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_38321B_CUSTOM_CONTENT_LINK_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_38321B_CUSTOM_CONTENT_LINK_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_38321B_CUSTOM_CONTENT_LINK_ID_seq" OWNED BY public."AO_38321B_CUSTOM_CONTENT_LINK"."ID";


--
-- Name: AO_38F373_COMMENT_LIKE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_38F373_COMMENT_LIKE" (
    "COMMENT_ID" bigint DEFAULT 0 NOT NULL,
    "CREATED_AT" timestamp without time zone,
    "EMOTICON" character varying(50),
    "ID" bigint NOT NULL,
    "USER_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_38F373_COMMENT_LIKE" OWNER TO bitbucket;

--
-- Name: AO_38F373_COMMENT_LIKE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_38F373_COMMENT_LIKE_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_38F373_COMMENT_LIKE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_38F373_COMMENT_LIKE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_38F373_COMMENT_LIKE_ID_seq" OWNED BY public."AO_38F373_COMMENT_LIKE"."ID";


--
-- Name: AO_4789DD_DISABLED_CHECKS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4789DD_DISABLED_CHECKS" (
    "HEALTH_CHECK_KEY" character varying(255) NOT NULL,
    "ID" integer NOT NULL
);


ALTER TABLE public."AO_4789DD_DISABLED_CHECKS" OWNER TO bitbucket;

--
-- Name: AO_4789DD_DISABLED_CHECKS_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4789DD_DISABLED_CHECKS_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4789DD_DISABLED_CHECKS_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4789DD_DISABLED_CHECKS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4789DD_DISABLED_CHECKS_ID_seq" OWNED BY public."AO_4789DD_DISABLED_CHECKS"."ID";


--
-- Name: AO_4789DD_HEALTH_CHECK_STATUS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4789DD_HEALTH_CHECK_STATUS" (
    "APPLICATION_NAME" character varying(255),
    "COMPLETE_KEY" character varying(255),
    "DESCRIPTION" text,
    "FAILED_DATE" timestamp without time zone,
    "FAILURE_REASON" text,
    "ID" integer NOT NULL,
    "IS_HEALTHY" boolean,
    "IS_RESOLVED" boolean,
    "NODE_ID" character varying(255),
    "RESOLVED_DATE" timestamp without time zone,
    "SEVERITY" character varying(255),
    "STATUS_NAME" character varying(255) NOT NULL
);


ALTER TABLE public."AO_4789DD_HEALTH_CHECK_STATUS" OWNER TO bitbucket;

--
-- Name: AO_4789DD_HEALTH_CHECK_STATUS_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4789DD_HEALTH_CHECK_STATUS_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4789DD_HEALTH_CHECK_STATUS_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4789DD_HEALTH_CHECK_STATUS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4789DD_HEALTH_CHECK_STATUS_ID_seq" OWNED BY public."AO_4789DD_HEALTH_CHECK_STATUS"."ID";


--
-- Name: AO_4789DD_HEALTH_CHECK_WATCHER; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4789DD_HEALTH_CHECK_WATCHER" (
    "ID" integer NOT NULL,
    "USER_KEY" character varying(255) NOT NULL
);


ALTER TABLE public."AO_4789DD_HEALTH_CHECK_WATCHER" OWNER TO bitbucket;

--
-- Name: AO_4789DD_HEALTH_CHECK_WATCHER_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4789DD_HEALTH_CHECK_WATCHER_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4789DD_HEALTH_CHECK_WATCHER_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4789DD_HEALTH_CHECK_WATCHER_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4789DD_HEALTH_CHECK_WATCHER_ID_seq" OWNED BY public."AO_4789DD_HEALTH_CHECK_WATCHER"."ID";


--
-- Name: AO_4789DD_PROPERTIES; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4789DD_PROPERTIES" (
    "ID" integer NOT NULL,
    "PROPERTY_NAME" character varying(255) NOT NULL,
    "PROPERTY_VALUE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_4789DD_PROPERTIES" OWNER TO bitbucket;

--
-- Name: AO_4789DD_PROPERTIES_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4789DD_PROPERTIES_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4789DD_PROPERTIES_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4789DD_PROPERTIES_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4789DD_PROPERTIES_ID_seq" OWNED BY public."AO_4789DD_PROPERTIES"."ID";


--
-- Name: AO_4789DD_READ_NOTIFICATIONS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4789DD_READ_NOTIFICATIONS" (
    "ID" integer NOT NULL,
    "IS_SNOOZED" boolean,
    "NOTIFICATION_ID" integer NOT NULL,
    "SNOOZE_COUNT" integer,
    "SNOOZE_DATE" timestamp without time zone,
    "USER_KEY" character varying(255) NOT NULL
);


ALTER TABLE public."AO_4789DD_READ_NOTIFICATIONS" OWNER TO bitbucket;

--
-- Name: AO_4789DD_READ_NOTIFICATIONS_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4789DD_READ_NOTIFICATIONS_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4789DD_READ_NOTIFICATIONS_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4789DD_READ_NOTIFICATIONS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4789DD_READ_NOTIFICATIONS_ID_seq" OWNED BY public."AO_4789DD_READ_NOTIFICATIONS"."ID";


--
-- Name: AO_4789DD_SHORTENED_KEY; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4789DD_SHORTENED_KEY" (
    "ID" integer NOT NULL,
    "KEY" character varying(255) NOT NULL
);


ALTER TABLE public."AO_4789DD_SHORTENED_KEY" OWNER TO bitbucket;

--
-- Name: AO_4789DD_SHORTENED_KEY_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4789DD_SHORTENED_KEY_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4789DD_SHORTENED_KEY_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4789DD_SHORTENED_KEY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4789DD_SHORTENED_KEY_ID_seq" OWNED BY public."AO_4789DD_SHORTENED_KEY"."ID";


--
-- Name: AO_4789DD_TASK_MONITOR; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4789DD_TASK_MONITOR" (
    "CLUSTERED_TASK_ID" character varying(255),
    "CREATED_TIMESTAMP" bigint DEFAULT 0,
    "ID" integer NOT NULL,
    "NODE_ID" character varying(255),
    "PROGRESS_MESSAGE" text,
    "PROGRESS_PERCENTAGE" integer,
    "SERIALIZED_ERRORS" text,
    "SERIALIZED_WARNINGS" text,
    "TASK_ID" character varying(255) NOT NULL,
    "TASK_MONITOR_KIND" character varying(255),
    "TASK_STATUS" text
);


ALTER TABLE public."AO_4789DD_TASK_MONITOR" OWNER TO bitbucket;

--
-- Name: AO_4789DD_TASK_MONITOR_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4789DD_TASK_MONITOR_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4789DD_TASK_MONITOR_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4789DD_TASK_MONITOR_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4789DD_TASK_MONITOR_ID_seq" OWNED BY public."AO_4789DD_TASK_MONITOR"."ID";


--
-- Name: AO_4C6A26_EXEMPT_MESSAGE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4C6A26_EXEMPT_MESSAGE" (
    "EXEMPTION" character varying(255) NOT NULL,
    "FK_CONFIGURATION_ID" bigint NOT NULL,
    "ID" bigint NOT NULL
);


ALTER TABLE public."AO_4C6A26_EXEMPT_MESSAGE" OWNER TO bitbucket;

--
-- Name: AO_4C6A26_EXEMPT_MESSAGE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4C6A26_EXEMPT_MESSAGE_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4C6A26_EXEMPT_MESSAGE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4C6A26_EXEMPT_MESSAGE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4C6A26_EXEMPT_MESSAGE_ID_seq" OWNED BY public."AO_4C6A26_EXEMPT_MESSAGE"."ID";


--
-- Name: AO_4C6A26_EXEMPT_PUSHER; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4C6A26_EXEMPT_PUSHER" (
    "FK_CONFIGURATION_ID" bigint NOT NULL,
    "ID" bigint NOT NULL,
    "USER_ID" integer NOT NULL
);


ALTER TABLE public."AO_4C6A26_EXEMPT_PUSHER" OWNER TO bitbucket;

--
-- Name: AO_4C6A26_EXEMPT_PUSHER_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4C6A26_EXEMPT_PUSHER_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4C6A26_EXEMPT_PUSHER_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4C6A26_EXEMPT_PUSHER_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4C6A26_EXEMPT_PUSHER_ID_seq" OWNED BY public."AO_4C6A26_EXEMPT_PUSHER"."ID";


--
-- Name: AO_4C6A26_JIRA_HOOK_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_4C6A26_JIRA_HOOK_CONFIG" (
    "HOOK_STATE" character varying(255) NOT NULL,
    "ID" bigint NOT NULL,
    "IGNORE_MERGE_COMMITS" boolean DEFAULT false NOT NULL,
    "RESOURCE_ID" integer NOT NULL,
    "SCOPE_TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_4C6A26_JIRA_HOOK_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_4C6A26_JIRA_HOOK_CONFIG_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_4C6A26_JIRA_HOOK_CONFIG_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_4C6A26_JIRA_HOOK_CONFIG_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_4C6A26_JIRA_HOOK_CONFIG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_4C6A26_JIRA_HOOK_CONFIG_ID_seq" OWNED BY public."AO_4C6A26_JIRA_HOOK_CONFIG"."ID";


--
-- Name: AO_616D7B_BRANCH_MODEL; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_616D7B_BRANCH_MODEL" (
    "DEV_ID" character varying(450),
    "DEV_USE_DEFAULT" boolean NOT NULL,
    "IS_ENABLED" boolean NOT NULL,
    "PROD_ID" character varying(450),
    "PROD_USE_DEFAULT" boolean NOT NULL,
    "REPOSITORY_ID" integer NOT NULL
);


ALTER TABLE public."AO_616D7B_BRANCH_MODEL" OWNER TO bitbucket;

--
-- Name: AO_616D7B_BRANCH_MODEL_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_616D7B_BRANCH_MODEL_CONFIG" (
    "DEV_ID" character varying(450),
    "DEV_USE_DEFAULT" boolean NOT NULL,
    "ID" integer NOT NULL,
    "PROD_ID" character varying(450),
    "PROD_USE_DEFAULT" boolean NOT NULL,
    "RESOURCE_ID" integer DEFAULT 0 NOT NULL,
    "SCOPE_TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_616D7B_BRANCH_MODEL_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_616D7B_BRANCH_MODEL_CONFIG_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_616D7B_BRANCH_MODEL_CONFIG_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_616D7B_BRANCH_MODEL_CONFIG_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_616D7B_BRANCH_MODEL_CONFIG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_616D7B_BRANCH_MODEL_CONFIG_ID_seq" OWNED BY public."AO_616D7B_BRANCH_MODEL_CONFIG"."ID";


--
-- Name: AO_616D7B_BRANCH_TYPE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_616D7B_BRANCH_TYPE" (
    "FK_BM_ID" integer NOT NULL,
    "ID" integer NOT NULL,
    "IS_ENABLED" boolean NOT NULL,
    "PREFIX" character varying(450),
    "TYPE_ID" character varying(450)
);


ALTER TABLE public."AO_616D7B_BRANCH_TYPE" OWNER TO bitbucket;

--
-- Name: AO_616D7B_BRANCH_TYPE_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_616D7B_BRANCH_TYPE_CONFIG" (
    "BM_ID" integer NOT NULL,
    "ID" integer NOT NULL,
    "IS_ENABLED" boolean NOT NULL,
    "PREFIX" character varying(450),
    "TYPE_ID" character varying(450) NOT NULL
);


ALTER TABLE public."AO_616D7B_BRANCH_TYPE_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_616D7B_BRANCH_TYPE_CONFIG_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_616D7B_BRANCH_TYPE_CONFIG_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_616D7B_BRANCH_TYPE_CONFIG_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_616D7B_BRANCH_TYPE_CONFIG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_616D7B_BRANCH_TYPE_CONFIG_ID_seq" OWNED BY public."AO_616D7B_BRANCH_TYPE_CONFIG"."ID";


--
-- Name: AO_616D7B_BRANCH_TYPE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_616D7B_BRANCH_TYPE_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_616D7B_BRANCH_TYPE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_616D7B_BRANCH_TYPE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_616D7B_BRANCH_TYPE_ID_seq" OWNED BY public."AO_616D7B_BRANCH_TYPE"."ID";


--
-- Name: AO_616D7B_DELETE_AFTER_MERGE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_616D7B_DELETE_AFTER_MERGE" (
    "ENABLED" boolean DEFAULT false NOT NULL,
    "ID" integer NOT NULL,
    "RESOURCE_ID" integer NOT NULL,
    "SCOPE_TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_616D7B_DELETE_AFTER_MERGE" OWNER TO bitbucket;

--
-- Name: AO_616D7B_DELETE_AFTER_MERGE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_616D7B_DELETE_AFTER_MERGE_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_616D7B_DELETE_AFTER_MERGE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_616D7B_DELETE_AFTER_MERGE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_616D7B_DELETE_AFTER_MERGE_ID_seq" OWNED BY public."AO_616D7B_DELETE_AFTER_MERGE"."ID";


--
-- Name: AO_616D7B_SCOPE_AUTO_MERGE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_616D7B_SCOPE_AUTO_MERGE" (
    "ENABLED" boolean NOT NULL,
    "ID" integer NOT NULL,
    "MERGE_CHECK_ENABLED" boolean DEFAULT false NOT NULL,
    "RESOURCE_ID" integer NOT NULL,
    "SCOPE_TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_616D7B_SCOPE_AUTO_MERGE" OWNER TO bitbucket;

--
-- Name: AO_616D7B_SCOPE_AUTO_MERGE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_616D7B_SCOPE_AUTO_MERGE_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_616D7B_SCOPE_AUTO_MERGE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_616D7B_SCOPE_AUTO_MERGE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_616D7B_SCOPE_AUTO_MERGE_ID_seq" OWNED BY public."AO_616D7B_SCOPE_AUTO_MERGE"."ID";


--
-- Name: AO_6978BB_PERMITTED_ENTITY; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_6978BB_PERMITTED_ENTITY" (
    "ENTITY_ID" integer NOT NULL,
    "FK_RESTRICTED_ID" integer NOT NULL,
    "GROUP_ID" character varying(255),
    "USER_ID" integer,
    "ACCESS_KEY_ID" integer
);


ALTER TABLE public."AO_6978BB_PERMITTED_ENTITY" OWNER TO bitbucket;

--
-- Name: AO_6978BB_PERMITTED_ENTITY_ENTITY_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_6978BB_PERMITTED_ENTITY_ENTITY_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_6978BB_PERMITTED_ENTITY_ENTITY_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_6978BB_PERMITTED_ENTITY_ENTITY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_6978BB_PERMITTED_ENTITY_ENTITY_ID_seq" OWNED BY public."AO_6978BB_PERMITTED_ENTITY"."ENTITY_ID";


--
-- Name: AO_6978BB_RESTRICTED_REF; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_6978BB_RESTRICTED_REF" (
    "REF_ID" integer NOT NULL,
    "REF_TYPE" character varying(255) NOT NULL,
    "REF_VALUE" character varying(450) NOT NULL,
    "RESTRICTION_TYPE" character varying(255) NOT NULL,
    "RESOURCE_ID" integer NOT NULL,
    "SCOPE_TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_6978BB_RESTRICTED_REF" OWNER TO bitbucket;

--
-- Name: AO_6978BB_RESTRICTED_REF_REF_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_6978BB_RESTRICTED_REF_REF_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_6978BB_RESTRICTED_REF_REF_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_6978BB_RESTRICTED_REF_REF_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_6978BB_RESTRICTED_REF_REF_ID_seq" OWNED BY public."AO_6978BB_RESTRICTED_REF"."REF_ID";


--
-- Name: AO_723324_CLIENT_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_723324_CLIENT_CONFIG" (
    "AUTHORIZATION_ENDPOINT" character varying(255) NOT NULL,
    "CLIENT_ID" character varying(255) NOT NULL,
    "CLIENT_SECRET" character varying(255) NOT NULL,
    "DESCRIPTION" character varying(255),
    "ID" character varying(255) NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "SCOPES" text NOT NULL,
    "TOKEN_ENDPOINT" character varying(255) NOT NULL,
    "TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_723324_CLIENT_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_723324_CLIENT_TOKEN; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_723324_CLIENT_TOKEN" (
    "ACCESS_TOKEN" text NOT NULL,
    "ACCESS_TOKEN_EXPIRATION" bigint DEFAULT 0 NOT NULL,
    "CONFIG_ID" character varying(255) NOT NULL,
    "ID" character varying(255) NOT NULL,
    "LAST_REFRESHED" bigint,
    "LAST_STATUS_UPDATED" bigint NOT NULL,
    "REFRESH_COUNT" integer DEFAULT 0,
    "REFRESH_TOKEN" text,
    "REFRESH_TOKEN_EXPIRATION" bigint,
    "STATUS" character varying(255) NOT NULL
);


ALTER TABLE public."AO_723324_CLIENT_TOKEN" OWNER TO bitbucket;

--
-- Name: AO_777666_DEPLOYMENT_ISSUE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_777666_DEPLOYMENT_ISSUE" (
    "DEPLOYMENT_ID" bigint DEFAULT 0,
    "ID" bigint NOT NULL,
    "ISSUE_KEY" character varying(255),
    "REPOSITORY_ID" integer DEFAULT 0
);


ALTER TABLE public."AO_777666_DEPLOYMENT_ISSUE" OWNER TO bitbucket;

--
-- Name: AO_777666_DEPLOYMENT_ISSUE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_777666_DEPLOYMENT_ISSUE_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_777666_DEPLOYMENT_ISSUE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_777666_DEPLOYMENT_ISSUE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_777666_DEPLOYMENT_ISSUE_ID_seq" OWNED BY public."AO_777666_DEPLOYMENT_ISSUE"."ID";


--
-- Name: AO_777666_JIRA_INDEX; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_777666_JIRA_INDEX" (
    "BRANCH" character varying(255) NOT NULL,
    "ID" bigint NOT NULL,
    "ISSUE" character varying(255) NOT NULL,
    "LAST_UPDATED" timestamp without time zone NOT NULL,
    "PR_ID" bigint,
    "PR_STATE" character varying(255),
    "REPOSITORY" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_777666_JIRA_INDEX" OWNER TO bitbucket;

--
-- Name: AO_777666_JIRA_INDEX_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_777666_JIRA_INDEX_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_777666_JIRA_INDEX_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_777666_JIRA_INDEX_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_777666_JIRA_INDEX_ID_seq" OWNED BY public."AO_777666_JIRA_INDEX"."ID";


--
-- Name: AO_777666_JIRA_SITE_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_777666_JIRA_SITE_CONFIG" (
    "CLIENT_ID" character varying(255) NOT NULL,
    "CLIENT_SECRET" character varying(255) NOT NULL,
    "CLOUD_ID" character varying(255) NOT NULL,
    "CONNECTION_ERROR_DESC" character varying(450),
    "CONNECTION_STATUS" character varying(255) NOT NULL,
    "ID" integer NOT NULL,
    "JIRA_URL" character varying(255) NOT NULL,
    "NAME" character varying(255) NOT NULL
);


ALTER TABLE public."AO_777666_JIRA_SITE_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_777666_JIRA_SITE_CONFIG_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_777666_JIRA_SITE_CONFIG_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_777666_JIRA_SITE_CONFIG_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_777666_JIRA_SITE_CONFIG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_777666_JIRA_SITE_CONFIG_ID_seq" OWNED BY public."AO_777666_JIRA_SITE_CONFIG"."ID";


--
-- Name: AO_777666_UPDATED_ISSUES; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_777666_UPDATED_ISSUES" (
    "ISSUE" character varying(255) NOT NULL,
    "UPDATE_TIME" bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_777666_UPDATED_ISSUES" OWNER TO bitbucket;

--
-- Name: AO_811463_GIT_LFS_LOCK; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_811463_GIT_LFS_LOCK" (
    "DIRECTORY_HASH" character varying(64) NOT NULL,
    "ID" integer NOT NULL,
    "LOCKED_AT" timestamp without time zone NOT NULL,
    "OWNER_ID" integer NOT NULL,
    "PATH" text NOT NULL,
    "REPOSITORY_ID" integer NOT NULL,
    "REPO_PATH_HASH" character varying(75) NOT NULL
);


ALTER TABLE public."AO_811463_GIT_LFS_LOCK" OWNER TO bitbucket;

--
-- Name: AO_811463_GIT_LFS_LOCK_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_811463_GIT_LFS_LOCK_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_811463_GIT_LFS_LOCK_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_811463_GIT_LFS_LOCK_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_811463_GIT_LFS_LOCK_ID_seq" OWNED BY public."AO_811463_GIT_LFS_LOCK"."ID";


--
-- Name: AO_811463_GIT_LFS_REPO_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_811463_GIT_LFS_REPO_CONFIG" (
    "IS_ENABLED" boolean NOT NULL,
    "REPOSITORY_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_811463_GIT_LFS_REPO_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_8752F1_DATA_PIPELINE_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_8752F1_DATA_PIPELINE_CONFIG" (
    "ID" integer NOT NULL,
    "KEY" character varying(250) NOT NULL,
    "VALUE" text
);


ALTER TABLE public."AO_8752F1_DATA_PIPELINE_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_8752F1_DATA_PIPELINE_CONFIG_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_8752F1_DATA_PIPELINE_CONFIG_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_8752F1_DATA_PIPELINE_CONFIG_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_8752F1_DATA_PIPELINE_CONFIG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_8752F1_DATA_PIPELINE_CONFIG_ID_seq" OWNED BY public."AO_8752F1_DATA_PIPELINE_CONFIG"."ID";


--
-- Name: AO_8752F1_DATA_PIPELINE_EOO; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_8752F1_DATA_PIPELINE_EOO" (
    "ENTITY_IDENTIFIER" character varying(255) NOT NULL,
    "ENTITY_TYPE" character varying(255) NOT NULL,
    "ID" integer NOT NULL
);


ALTER TABLE public."AO_8752F1_DATA_PIPELINE_EOO" OWNER TO bitbucket;

--
-- Name: AO_8752F1_DATA_PIPELINE_EOO_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_8752F1_DATA_PIPELINE_EOO_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_8752F1_DATA_PIPELINE_EOO_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_8752F1_DATA_PIPELINE_EOO_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_8752F1_DATA_PIPELINE_EOO_ID_seq" OWNED BY public."AO_8752F1_DATA_PIPELINE_EOO"."ID";


--
-- Name: AO_8752F1_DATA_PIPELINE_JOB; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_8752F1_DATA_PIPELINE_JOB" (
    "CREATED" bigint NOT NULL,
    "ERRORS" text,
    "EXPORTED_ENTITIES" integer,
    "EXPORT_FORCED" boolean,
    "EXPORT_FROM" bigint NOT NULL,
    "EXPORT_PATH" text,
    "ID" integer NOT NULL,
    "METADATA" character varying(255),
    "OPTED_OUT_ENTITY_IDENTIFIERS" text,
    "ROOT_EXPORT_PATH" character varying(255),
    "SCHEMA_VERSION" integer DEFAULT 0 NOT NULL,
    "STATUS" character varying(255) NOT NULL,
    "UPDATED" bigint NOT NULL,
    "WARNINGS" text,
    "WRITTEN_ROWS" integer
);


ALTER TABLE public."AO_8752F1_DATA_PIPELINE_JOB" OWNER TO bitbucket;

--
-- Name: AO_8752F1_DATA_PIPELINE_JOB_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_8752F1_DATA_PIPELINE_JOB_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_8752F1_DATA_PIPELINE_JOB_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_8752F1_DATA_PIPELINE_JOB_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_8752F1_DATA_PIPELINE_JOB_ID_seq" OWNED BY public."AO_8752F1_DATA_PIPELINE_JOB"."ID";


--
-- Name: AO_8E6075_MIRRORING_REQUEST; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_8E6075_MIRRORING_REQUEST" (
    "BASE_URL" character varying(450) NOT NULL,
    "CREATED_DATE" timestamp without time zone NOT NULL,
    "DESCRIPTOR_URL" character varying(450) NOT NULL,
    "ID" integer NOT NULL,
    "MIRROR_ID" character varying(64) NOT NULL,
    "MIRROR_NAME" character varying(64) NOT NULL,
    "MIRROR_TYPE" character varying(255) NOT NULL,
    "PRODUCT_TYPE" character varying(64) NOT NULL,
    "PRODUCT_VERSION" character varying(64) NOT NULL,
    "RESOLVED_DATE" timestamp without time zone,
    "RESOLVER_USER_ID" integer,
    "STATE" character varying(255) NOT NULL,
    "ADDON_DESCRIPTOR_URI" character varying(450)
);


ALTER TABLE public."AO_8E6075_MIRRORING_REQUEST" OWNER TO bitbucket;

--
-- Name: AO_8E6075_MIRRORING_REQUEST_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_8E6075_MIRRORING_REQUEST_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_8E6075_MIRRORING_REQUEST_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_8E6075_MIRRORING_REQUEST_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_8E6075_MIRRORING_REQUEST_ID_seq" OWNED BY public."AO_8E6075_MIRRORING_REQUEST"."ID";


--
-- Name: AO_8E6075_MIRROR_SERVER; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_8E6075_MIRROR_SERVER" (
    "ADD_ON_KEY" character varying(64) NOT NULL,
    "BASE_URL" character varying(255) NOT NULL,
    "ID" character varying(64) NOT NULL,
    "LAST_SEEN" timestamp without time zone NOT NULL,
    "MIRROR_TYPE" character varying(255) NOT NULL,
    "NAME" character varying(64) NOT NULL,
    "PRODUCT_TYPE" character varying(64) NOT NULL,
    "PRODUCT_VERSION" character varying(64) NOT NULL,
    "STATE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_8E6075_MIRROR_SERVER" OWNER TO bitbucket;

--
-- Name: AO_92D5D5_REPO_NOTIFICATION; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_92D5D5_REPO_NOTIFICATION" (
    "ID" integer NOT NULL,
    "PR_NOTIFICATION_SCOPE" integer DEFAULT 0 NOT NULL,
    "PUSH_NOTIFICATION_SCOPE" integer DEFAULT 0 NOT NULL,
    "REPO_ID" integer DEFAULT 0 NOT NULL,
    "USER_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_92D5D5_REPO_NOTIFICATION" OWNER TO bitbucket;

--
-- Name: AO_92D5D5_REPO_NOTIFICATION_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_92D5D5_REPO_NOTIFICATION_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_92D5D5_REPO_NOTIFICATION_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_92D5D5_REPO_NOTIFICATION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_92D5D5_REPO_NOTIFICATION_ID_seq" OWNED BY public."AO_92D5D5_REPO_NOTIFICATION"."ID";


--
-- Name: AO_92D5D5_USER_NOTIFICATION; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_92D5D5_USER_NOTIFICATION" (
    "BATCH_ID" character varying(255),
    "BATCH_SENDER_ID" character varying(255) NOT NULL,
    "DATA" text NOT NULL,
    "DATE" timestamp without time zone NOT NULL,
    "ID" bigint NOT NULL,
    "USER_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_92D5D5_USER_NOTIFICATION" OWNER TO bitbucket;

--
-- Name: AO_92D5D5_USER_NOTIFICATION_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_92D5D5_USER_NOTIFICATION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_92D5D5_USER_NOTIFICATION_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_92D5D5_USER_NOTIFICATION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_92D5D5_USER_NOTIFICATION_ID_seq" OWNED BY public."AO_92D5D5_USER_NOTIFICATION"."ID";


--
-- Name: AO_9DEC2A_DEFAULT_REVIEWER; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_9DEC2A_DEFAULT_REVIEWER" (
    "ENTITY_ID" integer NOT NULL,
    "FK_RESTRICTED_ID" integer NOT NULL,
    "USER_ID" integer
);


ALTER TABLE public."AO_9DEC2A_DEFAULT_REVIEWER" OWNER TO bitbucket;

--
-- Name: AO_9DEC2A_DEFAULT_REVIEWER_ENTITY_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_9DEC2A_DEFAULT_REVIEWER_ENTITY_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_9DEC2A_DEFAULT_REVIEWER_ENTITY_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_9DEC2A_DEFAULT_REVIEWER_ENTITY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_9DEC2A_DEFAULT_REVIEWER_ENTITY_ID_seq" OWNED BY public."AO_9DEC2A_DEFAULT_REVIEWER"."ENTITY_ID";


--
-- Name: AO_9DEC2A_PR_CONDITION; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_9DEC2A_PR_CONDITION" (
    "PR_CONDITION_ID" integer NOT NULL,
    "REQUIRED_APPROVALS" integer DEFAULT 0,
    "RESOURCE_ID" integer NOT NULL,
    "SCOPE_TYPE" character varying(255) NOT NULL,
    "SOURCE_REF_TYPE" character varying(255) NOT NULL,
    "SOURCE_REF_VALUE" character varying(255) NOT NULL,
    "TARGET_REF_TYPE" character varying(255) NOT NULL,
    "TARGET_REF_VALUE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_9DEC2A_PR_CONDITION" OWNER TO bitbucket;

--
-- Name: AO_9DEC2A_PR_CONDITION_PR_CONDITION_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_9DEC2A_PR_CONDITION_PR_CONDITION_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_9DEC2A_PR_CONDITION_PR_CONDITION_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_9DEC2A_PR_CONDITION_PR_CONDITION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_9DEC2A_PR_CONDITION_PR_CONDITION_ID_seq" OWNED BY public."AO_9DEC2A_PR_CONDITION"."PR_CONDITION_ID";


--
-- Name: AO_A0B856_DAILY_COUNTS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_A0B856_DAILY_COUNTS" (
    "DAY_SINCE_EPOCH" bigint DEFAULT 0 NOT NULL,
    "ERRORS" integer DEFAULT 0 NOT NULL,
    "EVENT_ID" character varying(64) NOT NULL,
    "FAILURES" integer DEFAULT 0 NOT NULL,
    "ID" character varying(88) NOT NULL,
    "SUCCESSES" integer DEFAULT 0 NOT NULL,
    "WEBHOOK_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_A0B856_DAILY_COUNTS" OWNER TO bitbucket;

--
-- Name: AO_A0B856_HIST_INVOCATION; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_A0B856_HIST_INVOCATION" (
    "ERROR_CONTENT" text,
    "EVENT_ID" character varying(64) NOT NULL,
    "FINISH" bigint DEFAULT 0 NOT NULL,
    "ID" character varying(77) NOT NULL,
    "OUTCOME" character varying(255) NOT NULL,
    "REQUEST_BODY" text,
    "REQUEST_HEADERS" text,
    "REQUEST_ID" character varying(64) NOT NULL,
    "REQUEST_METHOD" character varying(16) NOT NULL,
    "REQUEST_URL" character varying(255) NOT NULL,
    "RESPONSE_BODY" text,
    "RESPONSE_HEADERS" text,
    "RESULT_DESCRIPTION" character varying(255) NOT NULL,
    "START" bigint DEFAULT 0 NOT NULL,
    "STATUS_CODE" integer,
    "WEBHOOK_ID" integer DEFAULT 0 NOT NULL,
    "EVENT_SCOPE_ID" character varying(255) NOT NULL,
    "EVENT_SCOPE_TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_A0B856_HIST_INVOCATION" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEBHOOK; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_A0B856_WEBHOOK" (
    "ACTIVE" boolean,
    "CREATED" timestamp without time zone NOT NULL,
    "ID" integer NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "SCOPE_ID" character varying(255),
    "SCOPE_TYPE" character varying(255) NOT NULL,
    "UPDATED" timestamp without time zone NOT NULL,
    "URL" text NOT NULL,
    "USERNAME" character varying(255),
    "SSL_VERIFICATION_REQUIRED" boolean DEFAULT true NOT NULL,
    "PASSWORD" character varying(255)
);


ALTER TABLE public."AO_A0B856_WEBHOOK" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEBHOOK_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_A0B856_WEBHOOK_CONFIG" (
    "ID" integer NOT NULL,
    "KEY" character varying(255) NOT NULL,
    "VALUE" character varying(255) NOT NULL,
    "WEBHOOKID" integer NOT NULL
);


ALTER TABLE public."AO_A0B856_WEBHOOK_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEBHOOK_CONFIG_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_A0B856_WEBHOOK_CONFIG_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_A0B856_WEBHOOK_CONFIG_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEBHOOK_CONFIG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_A0B856_WEBHOOK_CONFIG_ID_seq" OWNED BY public."AO_A0B856_WEBHOOK_CONFIG"."ID";


--
-- Name: AO_A0B856_WEBHOOK_EVENT; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_A0B856_WEBHOOK_EVENT" (
    "EVENT_ID" character varying(255) NOT NULL,
    "ID" integer NOT NULL,
    "WEBHOOKID" integer NOT NULL
);


ALTER TABLE public."AO_A0B856_WEBHOOK_EVENT" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEBHOOK_EVENT_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_A0B856_WEBHOOK_EVENT_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_A0B856_WEBHOOK_EVENT_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEBHOOK_EVENT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_A0B856_WEBHOOK_EVENT_ID_seq" OWNED BY public."AO_A0B856_WEBHOOK_EVENT"."ID";


--
-- Name: AO_A0B856_WEBHOOK_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_A0B856_WEBHOOK_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_A0B856_WEBHOOK_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEBHOOK_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_A0B856_WEBHOOK_ID_seq" OWNED BY public."AO_A0B856_WEBHOOK"."ID";


--
-- Name: AO_A0B856_WEB_HOOK_LISTENER_AO; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_A0B856_WEB_HOOK_LISTENER_AO" (
    "DESCRIPTION" text,
    "ENABLED" boolean,
    "EVENTS" text,
    "EXCLUDE_BODY" boolean,
    "FILTERS" text,
    "ID" integer NOT NULL,
    "LAST_UPDATED" timestamp without time zone NOT NULL,
    "LAST_UPDATED_USER" character varying(255),
    "NAME" text NOT NULL,
    "PARAMETERS" text,
    "REGISTRATION_METHOD" character varying(255) NOT NULL,
    "URL" text NOT NULL
);


ALTER TABLE public."AO_A0B856_WEB_HOOK_LISTENER_AO" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEB_HOOK_LISTENER_AO_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_A0B856_WEB_HOOK_LISTENER_AO_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_A0B856_WEB_HOOK_LISTENER_AO_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_A0B856_WEB_HOOK_LISTENER_AO_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_A0B856_WEB_HOOK_LISTENER_AO_ID_seq" OWNED BY public."AO_A0B856_WEB_HOOK_LISTENER_AO"."ID";


--
-- Name: AO_B586BC_GPG_KEY; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_B586BC_GPG_KEY" (
    "EMAIL" character varying(255),
    "EXPIRY_DATE" timestamp without time zone,
    "FINGERPRINT" character varying(255) NOT NULL,
    "KEY_ID" bigint DEFAULT 0 NOT NULL,
    "KEY_TEXT" text,
    "USER_ID" integer
);


ALTER TABLE public."AO_B586BC_GPG_KEY" OWNER TO bitbucket;

--
-- Name: AO_B586BC_GPG_SUB_KEY; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_B586BC_GPG_SUB_KEY" (
    "EXPIRY_DATE" timestamp without time zone,
    "FINGERPRINT" character varying(255) NOT NULL,
    "FK_GPG_KEY_ID" character varying(255) NOT NULL,
    "KEY_ID" bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_B586BC_GPG_SUB_KEY" OWNER TO bitbucket;

--
-- Name: AO_BD73C3_PROJECT_AUDIT; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_BD73C3_PROJECT_AUDIT" (
    "ACTION" character varying(255) NOT NULL,
    "AUDIT_ITEM_ID" integer NOT NULL,
    "DATE" timestamp without time zone NOT NULL,
    "DETAILS" text,
    "PROJECT_ID" integer NOT NULL,
    "USER" integer
);


ALTER TABLE public."AO_BD73C3_PROJECT_AUDIT" OWNER TO bitbucket;

--
-- Name: AO_BD73C3_PROJECT_AUDIT_AUDIT_ITEM_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_BD73C3_PROJECT_AUDIT_AUDIT_ITEM_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_BD73C3_PROJECT_AUDIT_AUDIT_ITEM_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_BD73C3_PROJECT_AUDIT_AUDIT_ITEM_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_BD73C3_PROJECT_AUDIT_AUDIT_ITEM_ID_seq" OWNED BY public."AO_BD73C3_PROJECT_AUDIT"."AUDIT_ITEM_ID";


--
-- Name: AO_BD73C3_REPOSITORY_AUDIT; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_BD73C3_REPOSITORY_AUDIT" (
    "ACTION" character varying(255) NOT NULL,
    "AUDIT_ITEM_ID" integer NOT NULL,
    "DATE" timestamp without time zone NOT NULL,
    "DETAILS" text,
    "REPOSITORY_ID" integer NOT NULL,
    "USER" integer
);


ALTER TABLE public."AO_BD73C3_REPOSITORY_AUDIT" OWNER TO bitbucket;

--
-- Name: AO_BD73C3_REPOSITORY_AUDIT_AUDIT_ITEM_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_BD73C3_REPOSITORY_AUDIT_AUDIT_ITEM_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_BD73C3_REPOSITORY_AUDIT_AUDIT_ITEM_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_BD73C3_REPOSITORY_AUDIT_AUDIT_ITEM_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_BD73C3_REPOSITORY_AUDIT_AUDIT_ITEM_ID_seq" OWNED BY public."AO_BD73C3_REPOSITORY_AUDIT"."AUDIT_ITEM_ID";


--
-- Name: AO_C77861_AUDIT_ACTION_CACHE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_C77861_AUDIT_ACTION_CACHE" (
    "ACTION" character varying(255) NOT NULL,
    "ACTION_T_KEY" character varying(255),
    "ID" integer NOT NULL
);


ALTER TABLE public."AO_C77861_AUDIT_ACTION_CACHE" OWNER TO bitbucket;

--
-- Name: AO_C77861_AUDIT_ACTION_CACHE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_C77861_AUDIT_ACTION_CACHE_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_C77861_AUDIT_ACTION_CACHE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_C77861_AUDIT_ACTION_CACHE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_C77861_AUDIT_ACTION_CACHE_ID_seq" OWNED BY public."AO_C77861_AUDIT_ACTION_CACHE"."ID";


--
-- Name: AO_C77861_AUDIT_CATEGORY_CACHE; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_C77861_AUDIT_CATEGORY_CACHE" (
    "CATEGORY" character varying(255) NOT NULL,
    "CATEGORY_T_KEY" character varying(255),
    "ID" integer NOT NULL
);


ALTER TABLE public."AO_C77861_AUDIT_CATEGORY_CACHE" OWNER TO bitbucket;

--
-- Name: AO_C77861_AUDIT_CATEGORY_CACHE_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_C77861_AUDIT_CATEGORY_CACHE_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_C77861_AUDIT_CATEGORY_CACHE_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_C77861_AUDIT_CATEGORY_CACHE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_C77861_AUDIT_CATEGORY_CACHE_ID_seq" OWNED BY public."AO_C77861_AUDIT_CATEGORY_CACHE"."ID";


--
-- Name: AO_C77861_AUDIT_DENY_LISTED; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_C77861_AUDIT_DENY_LISTED" (
    "ACTION" character varying(255),
    "ID" bigint NOT NULL
);


ALTER TABLE public."AO_C77861_AUDIT_DENY_LISTED" OWNER TO bitbucket;

--
-- Name: AO_C77861_AUDIT_DENY_LISTED_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_C77861_AUDIT_DENY_LISTED_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_C77861_AUDIT_DENY_LISTED_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_C77861_AUDIT_DENY_LISTED_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_C77861_AUDIT_DENY_LISTED_ID_seq" OWNED BY public."AO_C77861_AUDIT_DENY_LISTED"."ID";


--
-- Name: AO_C77861_AUDIT_ENTITY; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_C77861_AUDIT_ENTITY" (
    "ACTION" character varying(255) NOT NULL,
    "ACTION_T_KEY" character varying(255),
    "AREA" character varying(255) NOT NULL,
    "ATTRIBUTES" text,
    "CATEGORY" character varying(255),
    "CATEGORY_T_KEY" character varying(255),
    "CHANGE_VALUES" text,
    "ENTITY_TIMESTAMP" bigint NOT NULL,
    "ID" bigint NOT NULL,
    "LEVEL" character varying(255) NOT NULL,
    "METHOD" character varying(255),
    "NODE" character varying(255),
    "PRIMARY_RESOURCE_ID" character varying(255),
    "PRIMARY_RESOURCE_TYPE" character varying(255),
    "RESOURCES" text,
    "RESOURCE_ID_3" character varying(255),
    "RESOURCE_ID_4" character varying(255),
    "RESOURCE_ID_5" character varying(255),
    "RESOURCE_TYPE_3" character varying(255),
    "RESOURCE_TYPE_4" character varying(255),
    "RESOURCE_TYPE_5" character varying(255),
    "SEARCH_STRING" text,
    "SECONDARY_RESOURCE_ID" character varying(255),
    "SECONDARY_RESOURCE_TYPE" character varying(255),
    "SOURCE" character varying(255),
    "SYSTEM_INFO" character varying(255),
    "USER_ID" character varying(255),
    "USER_NAME" character varying(255),
    "USER_TYPE" character varying(255)
);


ALTER TABLE public."AO_C77861_AUDIT_ENTITY" OWNER TO bitbucket;

--
-- Name: AO_C77861_AUDIT_ENTITY_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_C77861_AUDIT_ENTITY_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_C77861_AUDIT_ENTITY_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_C77861_AUDIT_ENTITY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_C77861_AUDIT_ENTITY_ID_seq" OWNED BY public."AO_C77861_AUDIT_ENTITY"."ID";


--
-- Name: AO_CFE8FA_BUILD_PARENT_KEYS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_CFE8FA_BUILD_PARENT_KEYS" (
    "FK_REQUIRED_BUILD_ID" bigint NOT NULL,
    "ID" bigint NOT NULL,
    "PARENT_KEY" character varying(255) NOT NULL
);


ALTER TABLE public."AO_CFE8FA_BUILD_PARENT_KEYS" OWNER TO bitbucket;

--
-- Name: AO_CFE8FA_BUILD_PARENT_KEYS_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_CFE8FA_BUILD_PARENT_KEYS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_CFE8FA_BUILD_PARENT_KEYS_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_CFE8FA_BUILD_PARENT_KEYS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_CFE8FA_BUILD_PARENT_KEYS_ID_seq" OWNED BY public."AO_CFE8FA_BUILD_PARENT_KEYS"."ID";


--
-- Name: AO_CFE8FA_BUILD_STATUS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_CFE8FA_BUILD_STATUS" (
    "CSID" character varying(40) NOT NULL,
    "DATE_ADDED" timestamp without time zone NOT NULL,
    "DESCRIPTION" character varying(255),
    "ID" integer NOT NULL,
    "KEY" character varying(255) NOT NULL,
    "NAME" character varying(255),
    "STATE" character varying(255) NOT NULL,
    "URL" character varying(450) NOT NULL
);


ALTER TABLE public."AO_CFE8FA_BUILD_STATUS" OWNER TO bitbucket;

--
-- Name: AO_CFE8FA_BUILD_STATUS_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_CFE8FA_BUILD_STATUS_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_CFE8FA_BUILD_STATUS_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_CFE8FA_BUILD_STATUS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_CFE8FA_BUILD_STATUS_ID_seq" OWNED BY public."AO_CFE8FA_BUILD_STATUS"."ID";


--
-- Name: AO_CFE8FA_REQUIRED_BUILDS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_CFE8FA_REQUIRED_BUILDS" (
    "EXEMPT_MATCHER_TYPE" character varying(255),
    "EXEMPT_MATCHER_VALUE" character varying(255),
    "ID" bigint NOT NULL,
    "REF_MATCHER_TYPE" character varying(255) NOT NULL,
    "REF_MATCHER_VALUE" character varying(255) NOT NULL,
    "REPOSITORY_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_CFE8FA_REQUIRED_BUILDS" OWNER TO bitbucket;

--
-- Name: AO_CFE8FA_REQUIRED_BUILDS_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_CFE8FA_REQUIRED_BUILDS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_CFE8FA_REQUIRED_BUILDS_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_CFE8FA_REQUIRED_BUILDS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_CFE8FA_REQUIRED_BUILDS_ID_seq" OWNED BY public."AO_CFE8FA_REQUIRED_BUILDS"."ID";


--
-- Name: AO_D6A508_IMPORT_JOB; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_D6A508_IMPORT_JOB" (
    "CREATED_DATE" timestamp without time zone NOT NULL,
    "ID" bigint NOT NULL,
    "USER_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_D6A508_IMPORT_JOB" OWNER TO bitbucket;

--
-- Name: AO_D6A508_IMPORT_JOB_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_D6A508_IMPORT_JOB_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_D6A508_IMPORT_JOB_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_D6A508_IMPORT_JOB_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_D6A508_IMPORT_JOB_ID_seq" OWNED BY public."AO_D6A508_IMPORT_JOB"."ID";


--
-- Name: AO_D6A508_REPO_IMPORT_TASK; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_D6A508_REPO_IMPORT_TASK" (
    "CLONE_URL" character varying(450) NOT NULL,
    "CREATED_DATE" timestamp without time zone NOT NULL,
    "EXTERNAL_REPO_NAME" character varying(450) NOT NULL,
    "FAILURE_TYPE" integer DEFAULT 0 NOT NULL,
    "ID" bigint NOT NULL,
    "IMPORT_JOB_ID" bigint DEFAULT 0 NOT NULL,
    "LAST_UPDATED" timestamp without time zone NOT NULL,
    "REPOSITORY_ID" integer DEFAULT 0 NOT NULL,
    "STATE" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_D6A508_REPO_IMPORT_TASK" OWNER TO bitbucket;

--
-- Name: AO_D6A508_REPO_IMPORT_TASK_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_D6A508_REPO_IMPORT_TASK_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_D6A508_REPO_IMPORT_TASK_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_D6A508_REPO_IMPORT_TASK_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_D6A508_REPO_IMPORT_TASK_ID_seq" OWNED BY public."AO_D6A508_REPO_IMPORT_TASK"."ID";


--
-- Name: AO_E40A46_ZDU_CLUSTER_NODES; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_E40A46_ZDU_CLUSTER_NODES" (
    "ID" integer NOT NULL,
    "IP_ADDRESS" character varying(255) NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "NODE_ID" character varying(255) NOT NULL,
    "PORT_NUMBER" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_E40A46_ZDU_CLUSTER_NODES" OWNER TO bitbucket;

--
-- Name: AO_E40A46_ZDU_CLUSTER_NODES_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_E40A46_ZDU_CLUSTER_NODES_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_E40A46_ZDU_CLUSTER_NODES_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_E40A46_ZDU_CLUSTER_NODES_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_E40A46_ZDU_CLUSTER_NODES_ID_seq" OWNED BY public."AO_E40A46_ZDU_CLUSTER_NODES"."ID";


--
-- Name: AO_E433FA_DEFAULT_TASKS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_E433FA_DEFAULT_TASKS" (
    "DESCRIPTION" text NOT NULL,
    "ID" bigint NOT NULL,
    "RESOURCE_ID" integer DEFAULT 0 NOT NULL,
    "SCOPE_TYPE" character varying(255) NOT NULL,
    "SOURCE_REF_TYPE" character varying(255) NOT NULL,
    "SOURCE_REF_VALUE" character varying(255) NOT NULL,
    "TARGET_REF_TYPE" character varying(255) NOT NULL,
    "TARGET_REF_VALUE" character varying(255) NOT NULL
);


ALTER TABLE public."AO_E433FA_DEFAULT_TASKS" OWNER TO bitbucket;

--
-- Name: AO_E433FA_DEFAULT_TASKS_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_E433FA_DEFAULT_TASKS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_E433FA_DEFAULT_TASKS_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_E433FA_DEFAULT_TASKS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_E433FA_DEFAULT_TASKS_ID_seq" OWNED BY public."AO_E433FA_DEFAULT_TASKS"."ID";


--
-- Name: AO_E5A814_ACCESS_TOKEN; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_E5A814_ACCESS_TOKEN" (
    "CREATED_DATE" timestamp without time zone NOT NULL,
    "EXPIRY_DAYS" integer,
    "HASHED_TOKEN" character varying(255) NOT NULL,
    "LAST_AUTHENTICATED" timestamp without time zone,
    "NAME" character varying(255) NOT NULL,
    "TOKEN_ID" character varying(255) NOT NULL,
    "USER_ID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."AO_E5A814_ACCESS_TOKEN" OWNER TO bitbucket;

--
-- Name: AO_E5A814_ACCESS_TOKEN_PERM; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_E5A814_ACCESS_TOKEN_PERM" (
    "FK_ACCESS_TOKEN_ID" character varying(255) NOT NULL,
    "ID" integer NOT NULL,
    "PERMISSION" integer DEFAULT 0
);


ALTER TABLE public."AO_E5A814_ACCESS_TOKEN_PERM" OWNER TO bitbucket;

--
-- Name: AO_E5A814_ACCESS_TOKEN_PERM_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_E5A814_ACCESS_TOKEN_PERM_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_E5A814_ACCESS_TOKEN_PERM_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_E5A814_ACCESS_TOKEN_PERM_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_E5A814_ACCESS_TOKEN_PERM_ID_seq" OWNED BY public."AO_E5A814_ACCESS_TOKEN_PERM"."ID";


--
-- Name: AO_ED669C_IDP_CONFIG; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_ED669C_IDP_CONFIG" (
    "ADDITIONAL_JIT_SCOPES" text,
    "ADDITIONAL_SCOPES" text,
    "AUTHORIZATION_ENDPOINT" character varying(255),
    "BUTTON_TEXT" character varying(255) NOT NULL,
    "CLIENT_ID" character varying(255),
    "CLIENT_SECRET" character varying(255),
    "ENABLED" boolean NOT NULL,
    "ENABLE_REMEMBER_ME" boolean,
    "ID" bigint NOT NULL,
    "INCLUDE_CUSTOMER_LOGINS" boolean,
    "ISSUER" character varying(255) NOT NULL,
    "LAST_UPDATED" timestamp without time zone,
    "MAPPING_DISPLAYNAME" character varying(255),
    "MAPPING_EMAIL" character varying(255),
    "MAPPING_GROUPS" character varying(255),
    "NAME" character varying(255) NOT NULL,
    "SAML_IDP_TYPE" character varying(255),
    "SIGNING_CERT" text,
    "SSO_TYPE" character varying(255),
    "SSO_URL" character varying(255),
    "TOKEN_ENDPOINT" character varying(255),
    "USERNAME_ATTRIBUTE" character varying(255),
    "USERNAME_CLAIM" character varying(255),
    "USER_INFO_ENDPOINT" character varying(255),
    "USER_PROVISIONING_ENABLED" boolean,
    "USE_DISCOVERY" boolean
);


ALTER TABLE public."AO_ED669C_IDP_CONFIG" OWNER TO bitbucket;

--
-- Name: AO_ED669C_IDP_CONFIG_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_ED669C_IDP_CONFIG_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_ED669C_IDP_CONFIG_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_ED669C_IDP_CONFIG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_ED669C_IDP_CONFIG_ID_seq" OWNED BY public."AO_ED669C_IDP_CONFIG"."ID";


--
-- Name: AO_ED669C_SEEN_ASSERTIONS; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_ED669C_SEEN_ASSERTIONS" (
    "ASSERTION_ID" character varying(255) NOT NULL,
    "EXPIRY_TIMESTAMP" bigint DEFAULT 0 NOT NULL,
    "ID" integer NOT NULL
);


ALTER TABLE public."AO_ED669C_SEEN_ASSERTIONS" OWNER TO bitbucket;

--
-- Name: AO_ED669C_SEEN_ASSERTIONS_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_ED669C_SEEN_ASSERTIONS_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_ED669C_SEEN_ASSERTIONS_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_ED669C_SEEN_ASSERTIONS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_ED669C_SEEN_ASSERTIONS_ID_seq" OWNED BY public."AO_ED669C_SEEN_ASSERTIONS"."ID";


--
-- Name: AO_F4ED3A_ADD_ON_PROPERTY_AO; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_F4ED3A_ADD_ON_PROPERTY_AO" (
    "ID" integer NOT NULL,
    "PLUGIN_KEY" character varying(80) NOT NULL,
    "PRIMARY_KEY" character varying(208) NOT NULL,
    "PROPERTY_KEY" character varying(127) NOT NULL,
    "VALUE" text NOT NULL
);


ALTER TABLE public."AO_F4ED3A_ADD_ON_PROPERTY_AO" OWNER TO bitbucket;

--
-- Name: AO_F4ED3A_ADD_ON_PROPERTY_AO_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_F4ED3A_ADD_ON_PROPERTY_AO_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_F4ED3A_ADD_ON_PROPERTY_AO_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_F4ED3A_ADD_ON_PROPERTY_AO_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_F4ED3A_ADD_ON_PROPERTY_AO_ID_seq" OWNED BY public."AO_F4ED3A_ADD_ON_PROPERTY_AO"."ID";


--
-- Name: AO_FB71B4_SSH_KEY_RESTRICTION; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_FB71B4_SSH_KEY_RESTRICTION" (
    "ALGORITHM" character varying(255) NOT NULL,
    "ID" integer NOT NULL,
    "MIN_KEY_LENGTH" integer
);


ALTER TABLE public."AO_FB71B4_SSH_KEY_RESTRICTION" OWNER TO bitbucket;

--
-- Name: AO_FB71B4_SSH_KEY_RESTRICTION_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_FB71B4_SSH_KEY_RESTRICTION_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_FB71B4_SSH_KEY_RESTRICTION_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_FB71B4_SSH_KEY_RESTRICTION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_FB71B4_SSH_KEY_RESTRICTION_ID_seq" OWNED BY public."AO_FB71B4_SSH_KEY_RESTRICTION"."ID";


--
-- Name: AO_FB71B4_SSH_PUBLIC_KEY; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_FB71B4_SSH_PUBLIC_KEY" (
    "CREATED_DATE" timestamp without time zone,
    "ENTITY_ID" integer NOT NULL,
    "EXPIRY_DAYS" integer,
    "KEY_MD5" character varying(32) NOT NULL,
    "KEY_TEXT" text NOT NULL,
    "LABEL" character varying(255),
    "LAST_AUTHENTICATED" timestamp without time zone,
    "USER_ID" integer NOT NULL,
    "KEY_TYPE" character varying(255) NOT NULL,
    "LABEL_LOWER" character varying(255)
);


ALTER TABLE public."AO_FB71B4_SSH_PUBLIC_KEY" OWNER TO bitbucket;

--
-- Name: AO_FB71B4_SSH_PUBLIC_KEY_ENTITY_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_FB71B4_SSH_PUBLIC_KEY_ENTITY_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_FB71B4_SSH_PUBLIC_KEY_ENTITY_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_FB71B4_SSH_PUBLIC_KEY_ENTITY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_FB71B4_SSH_PUBLIC_KEY_ENTITY_ID_seq" OWNED BY public."AO_FB71B4_SSH_PUBLIC_KEY"."ENTITY_ID";


--
-- Name: AO_FE1BC5_ACCESS_TOKEN; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_FE1BC5_ACCESS_TOKEN" (
    "AUTHORIZATION_CODE" character varying(255) NOT NULL,
    "AUTHORIZATION_DATE" bigint NOT NULL,
    "CLIENT_ID" character varying(255) NOT NULL,
    "CREATED_AT" bigint NOT NULL,
    "ID" character varying(255) NOT NULL,
    "LAST_ACCESSED" bigint,
    "SCOPE" character varying(255) NOT NULL,
    "USER_KEY" character varying(255) NOT NULL
);


ALTER TABLE public."AO_FE1BC5_ACCESS_TOKEN" OWNER TO bitbucket;

--
-- Name: AO_FE1BC5_AUTHORIZATION; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_FE1BC5_AUTHORIZATION" (
    "AUTHORIZATION_CODE" character varying(255) NOT NULL,
    "CLIENT_ID" character varying(255) NOT NULL,
    "CODE_CHALLENGE" character varying(255),
    "CODE_CHALLENGE_METHOD" character varying(255),
    "CREATED_AT" bigint NOT NULL,
    "REDIRECT_URI" character varying(255) NOT NULL,
    "SCOPE" character varying(255) NOT NULL,
    "USER_KEY" character varying(255) NOT NULL
);


ALTER TABLE public."AO_FE1BC5_AUTHORIZATION" OWNER TO bitbucket;

--
-- Name: AO_FE1BC5_CLIENT; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_FE1BC5_CLIENT" (
    "CLIENT_ID" character varying(255) NOT NULL,
    "CLIENT_SECRET" character varying(255) NOT NULL,
    "ID" character varying(255) NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "SCOPE" character varying(255),
    "USER_KEY" character varying(255) NOT NULL
);


ALTER TABLE public."AO_FE1BC5_CLIENT" OWNER TO bitbucket;

--
-- Name: AO_FE1BC5_REDIRECT_URI; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_FE1BC5_REDIRECT_URI" (
    "CLIENT_ID" character varying(255) NOT NULL,
    "ID" integer NOT NULL,
    "URI" character varying(450) NOT NULL
);


ALTER TABLE public."AO_FE1BC5_REDIRECT_URI" OWNER TO bitbucket;

--
-- Name: AO_FE1BC5_REDIRECT_URI_ID_seq; Type: SEQUENCE; Schema: public; Owner: bitbucket
--

CREATE SEQUENCE public."AO_FE1BC5_REDIRECT_URI_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AO_FE1BC5_REDIRECT_URI_ID_seq" OWNER TO bitbucket;

--
-- Name: AO_FE1BC5_REDIRECT_URI_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bitbucket
--

ALTER SEQUENCE public."AO_FE1BC5_REDIRECT_URI_ID_seq" OWNED BY public."AO_FE1BC5_REDIRECT_URI"."ID";


--
-- Name: AO_FE1BC5_REFRESH_TOKEN; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public."AO_FE1BC5_REFRESH_TOKEN" (
    "ACCESS_TOKEN_ID" character varying(255),
    "AUTHORIZATION_CODE" character varying(255) NOT NULL,
    "AUTHORIZATION_DATE" bigint NOT NULL,
    "CLIENT_ID" character varying(255) NOT NULL,
    "CREATED_AT" bigint NOT NULL,
    "ID" character varying(255) NOT NULL,
    "REFRESH_COUNT" integer,
    "SCOPE" character varying(255) NOT NULL,
    "USER_KEY" character varying(255) NOT NULL
);


ALTER TABLE public."AO_FE1BC5_REFRESH_TOKEN" OWNER TO bitbucket;

--
-- Name: app_property; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.app_property (
    prop_key character varying(50) NOT NULL,
    prop_value character varying(2000) NOT NULL
);


ALTER TABLE public.app_property OWNER TO bitbucket;

--
-- Name: asyncdblock; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.asyncdblock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.asyncdblock OWNER TO bitbucket;

--
-- Name: bb_alert; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_alert (
    details_json text,
    id bigint NOT NULL,
    issue_component_id character varying(255) NOT NULL,
    issue_id character varying(255) NOT NULL,
    issue_severity integer NOT NULL,
    node_name character varying(255) NOT NULL,
    node_name_lower character varying(255) NOT NULL,
    "timestamp" bigint NOT NULL,
    trigger_module character varying(1024),
    trigger_plugin_key character varying(255),
    trigger_plugin_key_lower character varying(255),
    trigger_plugin_version character varying(255)
);


ALTER TABLE public.bb_alert OWNER TO bitbucket;

--
-- Name: COLUMN bb_alert.details_json; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_alert.details_json IS 'text';


--
-- Name: bb_announcement_banner; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_announcement_banner (
    id bigint NOT NULL,
    enabled boolean NOT NULL,
    audience integer NOT NULL,
    message character varying(4000) NOT NULL
);


ALTER TABLE public.bb_announcement_banner OWNER TO bitbucket;

--
-- Name: bb_attachment; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_attachment (
    id bigint NOT NULL,
    repository_id integer,
    filename character varying(255) NOT NULL
);


ALTER TABLE public.bb_attachment OWNER TO bitbucket;

--
-- Name: bb_attachment_metadata; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_attachment_metadata (
    attachment_id bigint NOT NULL,
    metadata text
);


ALTER TABLE public.bb_attachment_metadata OWNER TO bitbucket;

--
-- Name: bb_auto_decline_settings; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_auto_decline_settings (
    enabled boolean NOT NULL,
    id bigint NOT NULL,
    inactivity_weeks integer NOT NULL,
    scope_id integer NOT NULL,
    scope_type integer NOT NULL
);


ALTER TABLE public.bb_auto_decline_settings OWNER TO bitbucket;

--
-- Name: bb_build_status; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_build_status (
    id integer NOT NULL,
    commit_id character varying(40) NOT NULL,
    state character varying(255) NOT NULL,
    build_key character varying(255) NOT NULL,
    name character varying(255),
    url character varying(1024) NOT NULL,
    description character varying(255),
    build_number character varying(255),
    build_server_id character varying(1024),
    duration bigint,
    failed_tests integer,
    created_date timestamp without time zone NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    parent character varying(255),
    ref character varying(1024),
    repository_id integer,
    non_null_repository_id integer NOT NULL,
    skipped_tests integer,
    successful_tests integer
);


ALTER TABLE public.bb_build_status OWNER TO bitbucket;

--
-- Name: bb_clusteredjob; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_clusteredjob (
    job_id character varying(255) NOT NULL,
    job_runner_key character varying(255) NOT NULL,
    sched_type integer NOT NULL,
    interval_millis bigint,
    first_run timestamp without time zone,
    cron_expression character varying(255),
    time_zone character varying(64),
    next_run timestamp without time zone,
    version bigint,
    parameters bytea
);


ALTER TABLE public.bb_clusteredjob OWNER TO bitbucket;

--
-- Name: bb_cmt_disc_comment_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_cmt_disc_comment_activity (
    activity_id bigint NOT NULL,
    comment_id bigint NOT NULL,
    comment_action integer NOT NULL
);


ALTER TABLE public.bb_cmt_disc_comment_activity OWNER TO bitbucket;

--
-- Name: bb_comment; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_comment (
    id bigint NOT NULL,
    author_id integer NOT NULL,
    comment_text text NOT NULL,
    created_timestamp timestamp without time zone NOT NULL,
    entity_version integer NOT NULL,
    thread_id bigint,
    updated_timestamp timestamp without time zone NOT NULL,
    resolved_timestamp timestamp without time zone,
    resolver_id integer,
    severity integer NOT NULL,
    state integer NOT NULL
);


ALTER TABLE public.bb_comment OWNER TO bitbucket;

--
-- Name: bb_comment_parent; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_comment_parent (
    comment_id bigint NOT NULL,
    parent_id bigint NOT NULL
);


ALTER TABLE public.bb_comment_parent OWNER TO bitbucket;

--
-- Name: bb_comment_thread; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_comment_thread (
    id bigint NOT NULL,
    commentable_id bigint NOT NULL,
    commentable_type integer NOT NULL,
    created_timestamp timestamp without time zone NOT NULL,
    entity_version integer NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL,
    diff_type integer,
    file_type integer,
    from_hash character varying(40),
    from_path character varying(1024),
    is_orphaned boolean,
    line_number integer,
    line_type integer,
    to_hash character varying(40),
    to_path character varying(1024),
    resolved boolean
);


ALTER TABLE public.bb_comment_thread OWNER TO bitbucket;

--
-- Name: bb_data_store; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_data_store (
    id bigint NOT NULL,
    ds_path character varying(128) NOT NULL,
    ds_uuid character varying(40) NOT NULL
);


ALTER TABLE public.bb_data_store OWNER TO bitbucket;

--
-- Name: bb_dep_commit; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_dep_commit (
    id bigint NOT NULL,
    repository_id integer NOT NULL,
    commit_id character varying(40) NOT NULL,
    deployment_id bigint NOT NULL
);


ALTER TABLE public.bb_dep_commit OWNER TO bitbucket;

--
-- Name: bb_deployment; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_deployment (
    id bigint NOT NULL,
    deployment_key character varying(255) NOT NULL,
    deployment_sequence_number bigint NOT NULL,
    description character varying(255) NOT NULL,
    display_name character varying(255) NOT NULL,
    environment_display_name character varying(255) NOT NULL,
    environment_key character varying(255) NOT NULL,
    environment_type character varying(64),
    environment_url character varying(1024),
    from_commit_id character varying(40),
    last_updated timestamp without time zone NOT NULL,
    repository_id integer NOT NULL,
    state character varying(64) NOT NULL,
    to_commit_id character varying(40) NOT NULL,
    url character varying(1024) NOT NULL
);


ALTER TABLE public.bb_deployment OWNER TO bitbucket;

--
-- Name: bb_emoticon; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_emoticon (
    id character varying(32) NOT NULL,
    provider character varying(20) NOT NULL,
    url character varying(255),
    unicode character varying(32)
);


ALTER TABLE public.bb_emoticon OWNER TO bitbucket;

--
-- Name: bb_git_pr_cached_merge; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_git_pr_cached_merge (
    id bigint NOT NULL,
    from_hash character varying(40) NOT NULL,
    to_hash character varying(40) NOT NULL,
    merge_type integer NOT NULL
);


ALTER TABLE public.bb_git_pr_cached_merge OWNER TO bitbucket;

--
-- Name: bb_git_pr_common_ancestor; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_git_pr_common_ancestor (
    id bigint NOT NULL,
    from_hash character varying(40) NOT NULL,
    to_hash character varying(40) NOT NULL,
    ancestor_hash character varying(40) NOT NULL
);


ALTER TABLE public.bb_git_pr_common_ancestor OWNER TO bitbucket;

--
-- Name: bb_hook_script; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_hook_script (
    id bigint NOT NULL,
    hook_version integer NOT NULL,
    hook_size integer NOT NULL,
    hook_type integer NOT NULL,
    created_timestamp timestamp without time zone NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL,
    hook_hash character varying(64) NOT NULL,
    hook_name character varying(255) NOT NULL,
    plugin_key character varying(255) NOT NULL,
    hook_description character varying(255)
);


ALTER TABLE public.bb_hook_script OWNER TO bitbucket;

--
-- Name: bb_hook_script_config; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_hook_script_config (
    id bigint NOT NULL,
    script_id bigint NOT NULL,
    scope_id integer,
    scope_type integer
);


ALTER TABLE public.bb_hook_script_config OWNER TO bitbucket;

--
-- Name: bb_hook_script_trigger; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_hook_script_trigger (
    config_id bigint NOT NULL,
    trigger_id character varying(255) NOT NULL
);


ALTER TABLE public.bb_hook_script_trigger OWNER TO bitbucket;

--
-- Name: bb_integrity_event; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_integrity_event (
    event_key character varying(255) NOT NULL,
    event_timestamp timestamp without time zone NOT NULL,
    event_node character varying(255) DEFAULT '00000000-0000-0000-0000-000000000000'::character varying NOT NULL
);


ALTER TABLE public.bb_integrity_event OWNER TO bitbucket;

--
-- Name: bb_job; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_job (
    end_timestamp timestamp without time zone,
    id bigint NOT NULL,
    initiator_id integer,
    node_id character varying(64) NOT NULL,
    progress_percentage integer DEFAULT 0 NOT NULL,
    progress_message text,
    start_timestamp timestamp without time zone NOT NULL,
    state integer NOT NULL,
    type character varying(255) NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL,
    entity_version integer NOT NULL
);


ALTER TABLE public.bb_job OWNER TO bitbucket;

--
-- Name: COLUMN bb_job.end_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.end_timestamp IS 'endDate';


--
-- Name: COLUMN bb_job.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.id IS 'id';


--
-- Name: COLUMN bb_job.initiator_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.initiator_id IS 'owner';


--
-- Name: COLUMN bb_job.node_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.node_id IS 'nodeId';


--
-- Name: COLUMN bb_job.progress_percentage; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.progress_percentage IS 'progressPercentage';


--
-- Name: COLUMN bb_job.progress_message; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.progress_message IS 'progressMessage';


--
-- Name: COLUMN bb_job.start_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.start_timestamp IS 'startDate';


--
-- Name: COLUMN bb_job.state; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.state IS 'state';


--
-- Name: COLUMN bb_job.type; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.type IS 'type';


--
-- Name: COLUMN bb_job.updated_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.updated_timestamp IS 'updatedDate';


--
-- Name: COLUMN bb_job.entity_version; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job.entity_version IS 'version';


--
-- Name: bb_job_message; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_job_message (
    created_timestamp timestamp without time zone NOT NULL,
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    severity integer NOT NULL,
    subject character varying(1024),
    text text NOT NULL
);


ALTER TABLE public.bb_job_message OWNER TO bitbucket;

--
-- Name: COLUMN bb_job_message.created_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job_message.created_timestamp IS 'createdDate';


--
-- Name: COLUMN bb_job_message.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job_message.id IS 'id';


--
-- Name: COLUMN bb_job_message.job_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job_message.job_id IS 'job';


--
-- Name: COLUMN bb_job_message.severity; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job_message.severity IS 'severity';


--
-- Name: COLUMN bb_job_message.subject; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job_message.subject IS 'subject';


--
-- Name: COLUMN bb_job_message.text; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_job_message.text IS 'text';


--
-- Name: bb_label; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_label (
    id bigint NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.bb_label OWNER TO bitbucket;

--
-- Name: bb_label_mapping; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_label_mapping (
    id bigint NOT NULL,
    label_id bigint NOT NULL,
    labelable_id integer NOT NULL,
    labelable_type integer NOT NULL
);


ALTER TABLE public.bb_label_mapping OWNER TO bitbucket;

--
-- Name: bb_mesh_migration_job; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mesh_migration_job (
    id bigint NOT NULL,
    state integer NOT NULL,
    end_timestamp timestamp without time zone,
    internal_job_id bigint NOT NULL,
    max_bandwidth bigint NOT NULL,
    start_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.bb_mesh_migration_job OWNER TO bitbucket;

--
-- Name: bb_mesh_migration_queue; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mesh_migration_queue (
    id bigint NOT NULL,
    migration_job_id bigint NOT NULL,
    repository_id integer NOT NULL,
    state integer NOT NULL
);


ALTER TABLE public.bb_mesh_migration_queue OWNER TO bitbucket;

--
-- Name: bb_mesh_node; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mesh_node (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    rpc_url character varying(255) NOT NULL,
    state integer NOT NULL
);


ALTER TABLE public.bb_mesh_node OWNER TO bitbucket;

--
-- Name: bb_mesh_node_key; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mesh_node_key (
    node_id bigint NOT NULL,
    fingerprint character varying(50) NOT NULL,
    der bytea NOT NULL,
    expiration_timestamp timestamp without time zone
);


ALTER TABLE public.bb_mesh_node_key OWNER TO bitbucket;

--
-- Name: bb_mesh_partition_migration; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mesh_partition_migration (
    id bigint NOT NULL,
    partition_id integer NOT NULL,
    source_node_id bigint NOT NULL,
    target_node_id bigint NOT NULL,
    state integer NOT NULL,
    created_timestamp timestamp without time zone NOT NULL,
    updated_timestamp timestamp without time zone,
    entity_version bigint NOT NULL,
    unique_token character varying(255)
);


ALTER TABLE public.bb_mesh_partition_migration OWNER TO bitbucket;

--
-- Name: bb_mesh_partition_replica; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mesh_partition_replica (
    partition_id integer NOT NULL,
    node_id bigint NOT NULL,
    id bigint NOT NULL,
    state integer NOT NULL
);


ALTER TABLE public.bb_mesh_partition_replica OWNER TO bitbucket;

--
-- Name: COLUMN bb_mesh_partition_replica.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_mesh_partition_replica.id IS 'id';


--
-- Name: bb_mesh_repo_replica; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mesh_repo_replica (
    replica_id bigint NOT NULL,
    repository_id integer NOT NULL,
    entity_version bigint NOT NULL,
    state integer NOT NULL,
    reported_version bigint NOT NULL,
    reported_at timestamp without time zone NOT NULL
);


ALTER TABLE public.bb_mesh_repo_replica OWNER TO bitbucket;

--
-- Name: bb_mesh_signing_key; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mesh_signing_key (
    key_owner integer NOT NULL,
    fingerprint character varying(50) NOT NULL,
    public_der bytea NOT NULL,
    private_der bytea NOT NULL,
    expiration_timestamp timestamp without time zone
);


ALTER TABLE public.bb_mesh_signing_key OWNER TO bitbucket;

--
-- Name: bb_mirror_content_hash; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mirror_content_hash (
    repository_id integer NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL,
    hash character varying(64) NOT NULL
);


ALTER TABLE public.bb_mirror_content_hash OWNER TO bitbucket;

--
-- Name: bb_mirror_metadata_hash; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_mirror_metadata_hash (
    repository_id integer NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL,
    hash character varying(64) NOT NULL
);


ALTER TABLE public.bb_mirror_metadata_hash OWNER TO bitbucket;

--
-- Name: bb_pr_comment_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_pr_comment_activity (
    activity_id bigint NOT NULL,
    comment_id bigint NOT NULL,
    comment_action integer NOT NULL
);


ALTER TABLE public.bb_pr_comment_activity OWNER TO bitbucket;

--
-- Name: bb_pr_commit; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_pr_commit (
    pr_id bigint NOT NULL,
    commit_id character varying(40) NOT NULL
);


ALTER TABLE public.bb_pr_commit OWNER TO bitbucket;

--
-- Name: COLUMN bb_pr_commit.pr_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_pr_commit.pr_id IS 'pullRequest';


--
-- Name: bb_pr_part_status_weight; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_pr_part_status_weight (
    status_id integer NOT NULL,
    status_weight integer NOT NULL
);


ALTER TABLE public.bb_pr_part_status_weight OWNER TO bitbucket;

--
-- Name: bb_pr_reviewer_added; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_pr_reviewer_added (
    activity_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.bb_pr_reviewer_added OWNER TO bitbucket;

--
-- Name: COLUMN bb_pr_reviewer_added.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_pr_reviewer_added.activity_id IS 'joinActivityKey';


--
-- Name: COLUMN bb_pr_reviewer_added.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_pr_reviewer_added.user_id IS 'joinUserKey';


--
-- Name: bb_pr_reviewer_removed; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_pr_reviewer_removed (
    activity_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.bb_pr_reviewer_removed OWNER TO bitbucket;

--
-- Name: COLUMN bb_pr_reviewer_removed.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_pr_reviewer_removed.activity_id IS 'joinActivityKey';


--
-- Name: COLUMN bb_pr_reviewer_removed.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_pr_reviewer_removed.user_id IS 'joinuserKey';


--
-- Name: bb_pr_reviewer_upd_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_pr_reviewer_upd_activity (
    activity_id bigint NOT NULL
);


ALTER TABLE public.bb_pr_reviewer_upd_activity OWNER TO bitbucket;

--
-- Name: COLUMN bb_pr_reviewer_upd_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_pr_reviewer_upd_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: bb_proj_merge_config; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_proj_merge_config (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    scm_id character varying(255) NOT NULL,
    default_strategy_id character varying(255) NOT NULL,
    commit_summaries integer NOT NULL
);


ALTER TABLE public.bb_proj_merge_config OWNER TO bitbucket;

--
-- Name: COLUMN bb_proj_merge_config.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_proj_merge_config.id IS 'id';


--
-- Name: COLUMN bb_proj_merge_config.project_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_proj_merge_config.project_id IS 'project.id';


--
-- Name: COLUMN bb_proj_merge_config.scm_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_proj_merge_config.scm_id IS 'scmId';


--
-- Name: COLUMN bb_proj_merge_config.default_strategy_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_proj_merge_config.default_strategy_id IS 'defaultStrategyId';


--
-- Name: bb_proj_merge_strategy; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_proj_merge_strategy (
    config_id bigint NOT NULL,
    strategy_id character varying(255) NOT NULL
);


ALTER TABLE public.bb_proj_merge_strategy OWNER TO bitbucket;

--
-- Name: COLUMN bb_proj_merge_strategy.config_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_proj_merge_strategy.config_id IS 'InternalProjectMergeStrategy.id';


--
-- Name: COLUMN bb_proj_merge_strategy.strategy_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_proj_merge_strategy.strategy_id IS 'ScmMergeStrategy.id';


--
-- Name: bb_project_alias; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_project_alias (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    namespace character varying(128) NOT NULL,
    project_key character varying(128) NOT NULL,
    created_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.bb_project_alias OWNER TO bitbucket;

--
-- Name: bb_pull_request_template; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_pull_request_template (
    id bigint NOT NULL,
    scope_id integer NOT NULL,
    scope_type integer NOT NULL,
    description text,
    enabled boolean
);


ALTER TABLE public.bb_pull_request_template OWNER TO bitbucket;

--
-- Name: bb_repo_merge_config; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_repo_merge_config (
    id bigint NOT NULL,
    repository_id integer NOT NULL,
    default_strategy_id character varying(255) NOT NULL,
    commit_summaries integer NOT NULL
);


ALTER TABLE public.bb_repo_merge_config OWNER TO bitbucket;

--
-- Name: COLUMN bb_repo_merge_config.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_repo_merge_config.id IS 'id';


--
-- Name: COLUMN bb_repo_merge_config.repository_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_repo_merge_config.repository_id IS 'repository.id';


--
-- Name: COLUMN bb_repo_merge_config.default_strategy_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_repo_merge_config.default_strategy_id IS 'defaultStrategyId';


--
-- Name: bb_repo_merge_strategy; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_repo_merge_strategy (
    config_id bigint NOT NULL,
    strategy_id character varying(255) NOT NULL
);


ALTER TABLE public.bb_repo_merge_strategy OWNER TO bitbucket;

--
-- Name: COLUMN bb_repo_merge_strategy.config_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_repo_merge_strategy.config_id IS 'InternalRepositoryMergeStrategy.id';


--
-- Name: COLUMN bb_repo_merge_strategy.strategy_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_repo_merge_strategy.strategy_id IS 'ScmMergeStrategy.id';


--
-- Name: bb_repo_size; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_repo_size (
    repo_id integer NOT NULL,
    total bigint NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.bb_repo_size OWNER TO bitbucket;

--
-- Name: bb_repository_alias; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_repository_alias (
    id bigint NOT NULL,
    repository_id integer NOT NULL,
    project_namespace character varying(128) NOT NULL,
    project_key character varying(128) NOT NULL,
    slug character varying(128) NOT NULL,
    created_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.bb_repository_alias OWNER TO bitbucket;

--
-- Name: bb_reviewer_group; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_reviewer_group (
    id bigint NOT NULL,
    group_name character varying(50) NOT NULL,
    description character varying(255),
    scope_id integer NOT NULL,
    scope_type integer NOT NULL
);


ALTER TABLE public.bb_reviewer_group OWNER TO bitbucket;

--
-- Name: bb_reviewer_group_user; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_reviewer_group_user (
    group_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.bb_reviewer_group_user OWNER TO bitbucket;

--
-- Name: bb_rl_reject_counter; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_rl_reject_counter (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    interval_start timestamp without time zone NOT NULL,
    reject_count bigint NOT NULL
);


ALTER TABLE public.bb_rl_reject_counter OWNER TO bitbucket;

--
-- Name: bb_rl_user_settings; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_rl_user_settings (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    capacity integer NOT NULL,
    fill_rate integer NOT NULL,
    whitelisted boolean NOT NULL
);


ALTER TABLE public.bb_rl_user_settings OWNER TO bitbucket;

--
-- Name: bb_scm_merge_config; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_scm_merge_config (
    id bigint NOT NULL,
    scm_id character varying(255) NOT NULL,
    default_strategy_id character varying(255) NOT NULL,
    commit_summaries integer NOT NULL
);


ALTER TABLE public.bb_scm_merge_config OWNER TO bitbucket;

--
-- Name: COLUMN bb_scm_merge_config.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_scm_merge_config.id IS 'id';


--
-- Name: COLUMN bb_scm_merge_config.scm_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_scm_merge_config.scm_id IS 'scmId';


--
-- Name: COLUMN bb_scm_merge_config.default_strategy_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_scm_merge_config.default_strategy_id IS 'defaultStrategyId';


--
-- Name: bb_scm_merge_strategy; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_scm_merge_strategy (
    config_id bigint NOT NULL,
    strategy_id character varying(255) NOT NULL
);


ALTER TABLE public.bb_scm_merge_strategy OWNER TO bitbucket;

--
-- Name: COLUMN bb_scm_merge_strategy.config_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_scm_merge_strategy.config_id IS 'InternalScmMergeStrategy.id';


--
-- Name: COLUMN bb_scm_merge_strategy.strategy_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_scm_merge_strategy.strategy_id IS 'ScmMergeStrategy.id';


--
-- Name: bb_secret_allowlist_rule; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_secret_allowlist_rule (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    line_regex character varying(1024),
    path_regex character varying(1024),
    scope_id integer NOT NULL,
    scope_type integer NOT NULL
);


ALTER TABLE public.bb_secret_allowlist_rule OWNER TO bitbucket;

--
-- Name: bb_secret_scan_rule; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_secret_scan_rule (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    line_regex character varying(1024),
    path_regex character varying(1024),
    scope_id integer,
    scope_type integer
);


ALTER TABLE public.bb_secret_scan_rule OWNER TO bitbucket;

--
-- Name: bb_settings_restriction; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_settings_restriction (
    id bigint NOT NULL,
    feature_key character varying(255) NOT NULL,
    namespace character varying(255) NOT NULL,
    project_id integer NOT NULL,
    component_key character varying(255) NOT NULL,
    processed_state integer NOT NULL,
    processing_attempts integer NOT NULL,
    processing_started_timestamp timestamp without time zone
);


ALTER TABLE public.bb_settings_restriction OWNER TO bitbucket;

--
-- Name: bb_ss_exempt_repo; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_ss_exempt_repo (
    repo_id integer NOT NULL,
    scope_id integer,
    scope_type integer
);


ALTER TABLE public.bb_ss_exempt_repo OWNER TO bitbucket;

--
-- Name: bb_suggestion_group; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_suggestion_group (
    comment_id bigint NOT NULL,
    state integer NOT NULL,
    applied_index integer
);


ALTER TABLE public.bb_suggestion_group OWNER TO bitbucket;

--
-- Name: bb_thread_root_comment; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_thread_root_comment (
    thread_id bigint NOT NULL,
    comment_id bigint NOT NULL
);


ALTER TABLE public.bb_thread_root_comment OWNER TO bitbucket;

--
-- Name: bb_user_dark_feature; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.bb_user_dark_feature (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    is_enabled boolean,
    feature_key character varying(255) NOT NULL
);


ALTER TABLE public.bb_user_dark_feature OWNER TO bitbucket;

--
-- Name: COLUMN bb_user_dark_feature.is_enabled; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.bb_user_dark_feature.is_enabled IS 'enabled';


--
-- Name: changeset; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.changeset (
    id character varying(40) NOT NULL,
    author_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.changeset OWNER TO bitbucket;

--
-- Name: cs_attribute; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cs_attribute (
    cs_id character varying(40) NOT NULL,
    att_name character varying(64) NOT NULL,
    att_value character varying(1024) NOT NULL
);


ALTER TABLE public.cs_attribute OWNER TO bitbucket;

--
-- Name: cs_indexer_state; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cs_indexer_state (
    indexer_id character varying(128) NOT NULL,
    repository_id integer NOT NULL,
    last_run bigint
);


ALTER TABLE public.cs_indexer_state OWNER TO bitbucket;

--
-- Name: cs_repo_membership; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cs_repo_membership (
    cs_id character varying(40) NOT NULL,
    repository_id integer NOT NULL
);


ALTER TABLE public.cs_repo_membership OWNER TO bitbucket;

--
-- Name: current_app; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.current_app (
    id integer NOT NULL,
    application_id character varying(255) NOT NULL,
    public_key_base64 character varying(4000) NOT NULL,
    private_key_base64 character varying(4000) NOT NULL
);


ALTER TABLE public.current_app OWNER TO bitbucket;

--
-- Name: cwd_app_dir_default_groups; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_app_dir_default_groups (
    id bigint NOT NULL,
    application_mapping_id bigint NOT NULL,
    group_name character varying(255) NOT NULL
);


ALTER TABLE public.cwd_app_dir_default_groups OWNER TO bitbucket;

--
-- Name: cwd_app_dir_group_mapping; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_app_dir_group_mapping (
    id bigint NOT NULL,
    app_dir_mapping_id bigint NOT NULL,
    application_id bigint NOT NULL,
    directory_id bigint NOT NULL,
    group_name character varying(255) NOT NULL
);


ALTER TABLE public.cwd_app_dir_group_mapping OWNER TO bitbucket;

--
-- Name: cwd_app_dir_mapping; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_app_dir_mapping (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    directory_id bigint NOT NULL,
    list_index integer,
    is_allow_all character(1) NOT NULL
);


ALTER TABLE public.cwd_app_dir_mapping OWNER TO bitbucket;

--
-- Name: cwd_app_dir_operation; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_app_dir_operation (
    app_dir_mapping_id bigint NOT NULL,
    operation_type character varying(32) NOT NULL
);


ALTER TABLE public.cwd_app_dir_operation OWNER TO bitbucket;

--
-- Name: cwd_app_licensed_user; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_app_licensed_user (
    id bigint NOT NULL,
    username character varying(255) NOT NULL,
    full_name character varying(255),
    email character varying(255),
    last_active timestamp without time zone,
    directory_id bigint NOT NULL,
    lower_username character varying(255) NOT NULL,
    lower_full_name character varying(255),
    lower_email character varying(255)
);


ALTER TABLE public.cwd_app_licensed_user OWNER TO bitbucket;

--
-- Name: cwd_app_licensing; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_app_licensing (
    id bigint NOT NULL,
    generated_on timestamp without time zone NOT NULL,
    version bigint NOT NULL,
    application_id bigint NOT NULL,
    application_subtype character varying(32) NOT NULL,
    total_users integer NOT NULL,
    max_user_limit integer NOT NULL,
    total_crowd_users integer NOT NULL,
    active character(1) NOT NULL
);


ALTER TABLE public.cwd_app_licensing OWNER TO bitbucket;

--
-- Name: cwd_app_licensing_dir_info; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_app_licensing_dir_info (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    directory_id bigint,
    licensing_summary_id bigint NOT NULL
);


ALTER TABLE public.cwd_app_licensing_dir_info OWNER TO bitbucket;

--
-- Name: cwd_application; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_application (
    id bigint NOT NULL,
    application_name character varying(255) NOT NULL,
    lower_application_name character varying(255) NOT NULL,
    created_date timestamp without time zone NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    description character varying(255),
    application_type character varying(32) NOT NULL,
    credential character varying(255) NOT NULL,
    is_active character(1) NOT NULL
);


ALTER TABLE public.cwd_application OWNER TO bitbucket;

--
-- Name: cwd_application_address; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_application_address (
    application_id bigint NOT NULL,
    remote_address character varying(255) NOT NULL
);


ALTER TABLE public.cwd_application_address OWNER TO bitbucket;

--
-- Name: cwd_application_alias; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_application_alias (
    id bigint NOT NULL,
    application_id bigint NOT NULL,
    user_name character varying(255) NOT NULL,
    lower_user_name character varying(255) NOT NULL,
    alias_name character varying(255) NOT NULL,
    lower_alias_name character varying(255) NOT NULL
);


ALTER TABLE public.cwd_application_alias OWNER TO bitbucket;

--
-- Name: cwd_application_attribute; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_application_attribute (
    application_id bigint NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_value text
);


ALTER TABLE public.cwd_application_attribute OWNER TO bitbucket;

--
-- Name: cwd_application_saml_config; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_application_saml_config (
    application_id bigint NOT NULL,
    assertion_consumer_service character varying(255) NOT NULL,
    audience character varying(255) NOT NULL,
    enabled character(1) NOT NULL,
    name_id_format character varying(64) NOT NULL,
    add_user_attributes_enabled character(1) NOT NULL
);


ALTER TABLE public.cwd_application_saml_config OWNER TO bitbucket;

--
-- Name: cwd_directory; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_directory (
    id bigint NOT NULL,
    directory_name character varying(255) NOT NULL,
    lower_directory_name character varying(255) NOT NULL,
    created_date timestamp without time zone NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    description character varying(255),
    impl_class character varying(255) NOT NULL,
    lower_impl_class character varying(255) NOT NULL,
    directory_type character varying(32) NOT NULL,
    is_active character(1) NOT NULL
);


ALTER TABLE public.cwd_directory OWNER TO bitbucket;

--
-- Name: cwd_directory_attribute; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_directory_attribute (
    directory_id bigint NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_value text
);


ALTER TABLE public.cwd_directory_attribute OWNER TO bitbucket;

--
-- Name: cwd_directory_operation; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_directory_operation (
    directory_id bigint NOT NULL,
    operation_type character varying(32) NOT NULL
);


ALTER TABLE public.cwd_directory_operation OWNER TO bitbucket;

--
-- Name: cwd_granted_perm; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_granted_perm (
    id bigint NOT NULL,
    created_date timestamp without time zone NOT NULL,
    permission_id integer NOT NULL,
    group_name character varying(255) NOT NULL,
    app_dir_mapping_id bigint NOT NULL
);


ALTER TABLE public.cwd_granted_perm OWNER TO bitbucket;

--
-- Name: cwd_group; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_group (
    id bigint NOT NULL,
    group_name character varying(255) NOT NULL,
    lower_group_name character varying(255) NOT NULL,
    created_date timestamp without time zone NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    description character varying(255),
    group_type character varying(32) NOT NULL,
    directory_id bigint NOT NULL,
    is_active character(1) NOT NULL,
    is_local character(1) NOT NULL,
    external_id character varying(255)
);


ALTER TABLE public.cwd_group OWNER TO bitbucket;

--
-- Name: cwd_group_admin_group; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_group_admin_group (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    target_group_id bigint NOT NULL
);


ALTER TABLE public.cwd_group_admin_group OWNER TO bitbucket;

--
-- Name: cwd_group_admin_user; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_group_admin_user (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    target_group_id bigint NOT NULL
);


ALTER TABLE public.cwd_group_admin_user OWNER TO bitbucket;

--
-- Name: cwd_group_attribute; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_group_attribute (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    directory_id bigint NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_value character varying(255),
    attribute_lower_value character varying(255)
);


ALTER TABLE public.cwd_group_attribute OWNER TO bitbucket;

--
-- Name: cwd_membership; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_membership (
    id bigint NOT NULL,
    parent_id bigint,
    child_id bigint,
    membership_type character varying(32),
    group_type character varying(32) NOT NULL,
    parent_name character varying(255) NOT NULL,
    lower_parent_name character varying(255) NOT NULL,
    child_name character varying(255) NOT NULL,
    lower_child_name character varying(255) NOT NULL,
    directory_id bigint NOT NULL,
    created_date timestamp without time zone
);


ALTER TABLE public.cwd_membership OWNER TO bitbucket;

--
-- Name: cwd_property; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_property (
    property_key character varying(255) NOT NULL,
    property_name character varying(255) NOT NULL,
    property_value text
);


ALTER TABLE public.cwd_property OWNER TO bitbucket;

--
-- Name: cwd_tombstone; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_tombstone (
    id bigint NOT NULL,
    tombstone_type character varying(255) NOT NULL,
    tombstone_timestamp bigint NOT NULL,
    application_id bigint,
    directory_id bigint,
    entity_name character varying(255),
    parent character varying(255)
);


ALTER TABLE public.cwd_tombstone OWNER TO bitbucket;

--
-- Name: cwd_user; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_user (
    id bigint NOT NULL,
    user_name character varying(255) NOT NULL,
    lower_user_name character varying(255) NOT NULL,
    created_date timestamp without time zone NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    first_name character varying(255),
    lower_first_name character varying(255),
    last_name character varying(255),
    lower_last_name character varying(255),
    display_name character varying(255),
    lower_display_name character varying(255),
    email_address character varying(255),
    lower_email_address character varying(255),
    directory_id bigint NOT NULL,
    credential character varying(255),
    is_active character(1) NOT NULL,
    external_id character varying(255)
);


ALTER TABLE public.cwd_user OWNER TO bitbucket;

--
-- Name: COLUMN cwd_user.external_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.cwd_user.external_id IS 'external_id';


--
-- Name: cwd_user_attribute; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_user_attribute (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    directory_id bigint NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_value character varying(255),
    attribute_lower_value character varying(255),
    attribute_numeric_value bigint
);


ALTER TABLE public.cwd_user_attribute OWNER TO bitbucket;

--
-- Name: cwd_user_credential_record; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_user_credential_record (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    password_hash character varying(255) NOT NULL,
    list_index integer
);


ALTER TABLE public.cwd_user_credential_record OWNER TO bitbucket;

--
-- Name: cwd_webhook; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.cwd_webhook (
    id bigint NOT NULL,
    endpoint_url character varying(255) NOT NULL,
    application_id bigint NOT NULL,
    token character varying(255),
    oldest_failure_date timestamp without time zone,
    failures_since_last_success bigint NOT NULL
);


ALTER TABLE public.cwd_webhook OWNER TO bitbucket;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO bitbucket;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO bitbucket;

--
-- Name: hibernate_unique_key; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.hibernate_unique_key (
    next_hi bigint NOT NULL
);


ALTER TABLE public.hibernate_unique_key OWNER TO bitbucket;

--
-- Name: id_sequence; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.id_sequence (
    sequence_name character varying(255) NOT NULL,
    next_val bigint NOT NULL
);


ALTER TABLE public.id_sequence OWNER TO bitbucket;

--
-- Name: plugin_setting; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.plugin_setting (
    namespace character varying(255) NOT NULL,
    key_name character varying(255) NOT NULL,
    key_value text NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.plugin_setting OWNER TO bitbucket;

--
-- Name: COLUMN plugin_setting.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.plugin_setting.id IS 'id';


--
-- Name: plugin_state; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.plugin_state (
    name character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    updated_timestamp bigint NOT NULL
);


ALTER TABLE public.plugin_state OWNER TO bitbucket;

--
-- Name: project; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.project (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    project_key character varying(128) NOT NULL,
    description character varying(255),
    project_type integer NOT NULL,
    namespace character varying(128) NOT NULL
);


ALTER TABLE public.project OWNER TO bitbucket;

--
-- Name: COLUMN project.namespace; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.project.namespace IS 'project namespace';


--
-- Name: repository; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.repository (
    id integer NOT NULL,
    slug character varying(128) NOT NULL,
    name character varying(128) NOT NULL,
    state integer NOT NULL,
    project_id integer NOT NULL,
    scm_id character varying(255) NOT NULL,
    hierarchy_id character varying(20) NOT NULL,
    is_forkable boolean NOT NULL,
    is_public boolean NOT NULL,
    store_id bigint,
    description character varying(255),
    partition_id integer,
    is_read_only boolean NOT NULL,
    is_archived boolean NOT NULL
);


ALTER TABLE public.repository OWNER TO bitbucket;

--
-- Name: COLUMN repository.scm_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.repository.scm_id IS 'scmId';


--
-- Name: COLUMN repository.hierarchy_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.repository.hierarchy_id IS 'hierarchyId';


--
-- Name: COLUMN repository.is_forkable; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.repository.is_forkable IS 'forkable';


--
-- Name: COLUMN repository.is_public; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.repository.is_public IS 'publiclyAccessible';


--
-- Name: repository_access; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.repository_access (
    user_id integer NOT NULL,
    repository_id integer NOT NULL,
    last_accessed bigint NOT NULL
);


ALTER TABLE public.repository_access OWNER TO bitbucket;

--
-- Name: sta_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_activity (
    id bigint NOT NULL,
    activity_type integer NOT NULL,
    created_timestamp timestamp without time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.sta_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_activity.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_activity.id IS 'id';


--
-- Name: COLUMN sta_activity.activity_type; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_activity.activity_type IS 'discriminatorColumn';


--
-- Name: COLUMN sta_activity.created_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_activity.created_timestamp IS 'createdDate';


--
-- Name: COLUMN sta_activity.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_activity.user_id IS 'user';


--
-- Name: sta_cmt_disc_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_cmt_disc_activity (
    activity_id bigint NOT NULL,
    discussion_id bigint NOT NULL
);


ALTER TABLE public.sta_cmt_disc_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_cmt_disc_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_disc_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: COLUMN sta_cmt_disc_activity.discussion_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_disc_activity.discussion_id IS 'discussion';


--
-- Name: sta_cmt_disc_participant; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_cmt_disc_participant (
    id bigint NOT NULL,
    discussion_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.sta_cmt_disc_participant OWNER TO bitbucket;

--
-- Name: COLUMN sta_cmt_disc_participant.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_disc_participant.id IS 'id';


--
-- Name: COLUMN sta_cmt_disc_participant.discussion_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_disc_participant.discussion_id IS 'discussion';


--
-- Name: COLUMN sta_cmt_disc_participant.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_disc_participant.user_id IS 'user';


--
-- Name: sta_cmt_discussion; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_cmt_discussion (
    id bigint NOT NULL,
    repository_id integer NOT NULL,
    parent_count integer NOT NULL,
    commit_id character varying(40) NOT NULL,
    parent_id character varying(40)
);


ALTER TABLE public.sta_cmt_discussion OWNER TO bitbucket;

--
-- Name: COLUMN sta_cmt_discussion.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_discussion.id IS 'id';


--
-- Name: COLUMN sta_cmt_discussion.repository_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_discussion.repository_id IS 'repository';


--
-- Name: COLUMN sta_cmt_discussion.parent_count; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_discussion.parent_count IS 'parents';


--
-- Name: COLUMN sta_cmt_discussion.commit_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_discussion.commit_id IS 'commitId';


--
-- Name: COLUMN sta_cmt_discussion.parent_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_cmt_discussion.parent_id IS 'parentId';


--
-- Name: sta_deleted_group; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_deleted_group (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    deleted_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.sta_deleted_group OWNER TO bitbucket;

--
-- Name: COLUMN sta_deleted_group.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_deleted_group.id IS 'id';


--
-- Name: COLUMN sta_deleted_group.name; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_deleted_group.name IS 'group name';


--
-- Name: COLUMN sta_deleted_group.deleted_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_deleted_group.deleted_timestamp IS 'deleted date';


--
-- Name: sta_drift_request; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_drift_request (
    id bigint NOT NULL,
    pr_id bigint NOT NULL,
    old_from_hash character varying(40) NOT NULL,
    old_to_hash character varying(40) NOT NULL,
    new_from_hash character varying(40) NOT NULL,
    new_to_hash character varying(40) NOT NULL,
    attempts integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.sta_drift_request OWNER TO bitbucket;

--
-- Name: COLUMN sta_drift_request.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_drift_request.id IS 'id';


--
-- Name: COLUMN sta_drift_request.pr_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_drift_request.pr_id IS 'pullRequest';


--
-- Name: COLUMN sta_drift_request.old_from_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_drift_request.old_from_hash IS 'oldFromHash';


--
-- Name: COLUMN sta_drift_request.old_to_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_drift_request.old_to_hash IS 'oldToHash';


--
-- Name: COLUMN sta_drift_request.new_from_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_drift_request.new_from_hash IS 'newFromHash';


--
-- Name: COLUMN sta_drift_request.new_to_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_drift_request.new_to_hash IS 'newToHash';


--
-- Name: sta_global_permission; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_global_permission (
    id bigint NOT NULL,
    perm_id integer NOT NULL,
    group_name character varying(255),
    user_id integer
);


ALTER TABLE public.sta_global_permission OWNER TO bitbucket;

--
-- Name: sta_normal_project; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_normal_project (
    project_id integer NOT NULL,
    is_public boolean NOT NULL
);


ALTER TABLE public.sta_normal_project OWNER TO bitbucket;

--
-- Name: COLUMN sta_normal_project.project_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_normal_project.project_id IS 'id';


--
-- Name: COLUMN sta_normal_project.is_public; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_normal_project.is_public IS 'publiclyAccessible';


--
-- Name: sta_normal_user; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_normal_user (
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    locale character varying(32),
    deleted_timestamp timestamp without time zone,
    time_zone character varying(64)
);


ALTER TABLE public.sta_normal_user OWNER TO bitbucket;

--
-- Name: COLUMN sta_normal_user.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_normal_user.user_id IS 'joinPrimaryKey';


--
-- Name: COLUMN sta_normal_user.name; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_normal_user.name IS 'normal user name';


--
-- Name: COLUMN sta_normal_user.slug; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_normal_user.slug IS 'normal user slug';


--
-- Name: COLUMN sta_normal_user.locale; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_normal_user.locale IS 'user_locale';


--
-- Name: COLUMN sta_normal_user.deleted_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_normal_user.deleted_timestamp IS 'deletedDate';


--
-- Name: COLUMN sta_normal_user.time_zone; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_normal_user.time_zone IS 'timeZone';


--
-- Name: sta_permission_type; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_permission_type (
    perm_id integer NOT NULL,
    perm_weight integer NOT NULL
);


ALTER TABLE public.sta_permission_type OWNER TO bitbucket;

--
-- Name: sta_personal_project; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_personal_project (
    project_id integer NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.sta_personal_project OWNER TO bitbucket;

--
-- Name: COLUMN sta_personal_project.project_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_personal_project.project_id IS 'id';


--
-- Name: COLUMN sta_personal_project.owner_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_personal_project.owner_id IS 'owner';


--
-- Name: sta_pr_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_pr_activity (
    activity_id bigint NOT NULL,
    pr_id bigint NOT NULL,
    pr_action integer NOT NULL
);


ALTER TABLE public.sta_pr_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_pr_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: COLUMN sta_pr_activity.pr_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_activity.pr_id IS 'pullRequest';


--
-- Name: COLUMN sta_pr_activity.pr_action; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_activity.pr_action IS 'action';


--
-- Name: sta_pr_merge_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_pr_merge_activity (
    activity_id bigint NOT NULL,
    hash character varying(40)
);


ALTER TABLE public.sta_pr_merge_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_pr_merge_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_merge_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: COLUMN sta_pr_merge_activity.hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_merge_activity.hash IS 'hash';


--
-- Name: sta_pr_participant; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_pr_participant (
    id bigint NOT NULL,
    pr_id bigint NOT NULL,
    pr_role integer NOT NULL,
    user_id integer NOT NULL,
    participant_status integer NOT NULL,
    last_reviewed_commit character varying(40)
);


ALTER TABLE public.sta_pr_participant OWNER TO bitbucket;

--
-- Name: COLUMN sta_pr_participant.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_participant.id IS 'id';


--
-- Name: COLUMN sta_pr_participant.pr_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_participant.pr_id IS 'pullRequest';


--
-- Name: COLUMN sta_pr_participant.pr_role; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_participant.pr_role IS 'role';


--
-- Name: COLUMN sta_pr_participant.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_participant.user_id IS 'user';


--
-- Name: COLUMN sta_pr_participant.participant_status; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_participant.participant_status IS 'approved';


--
-- Name: COLUMN sta_pr_participant.last_reviewed_commit; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_participant.last_reviewed_commit IS 'lastReviewedCommit';


--
-- Name: sta_pr_rescope_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_pr_rescope_activity (
    activity_id bigint NOT NULL,
    from_hash character varying(40) NOT NULL,
    to_hash character varying(40) NOT NULL,
    prev_from_hash character varying(40) NOT NULL,
    prev_to_hash character varying(40) NOT NULL,
    commits_added integer,
    commits_removed integer
);


ALTER TABLE public.sta_pr_rescope_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_pr_rescope_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: COLUMN sta_pr_rescope_activity.from_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_activity.from_hash IS 'fromHash';


--
-- Name: COLUMN sta_pr_rescope_activity.to_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_activity.to_hash IS 'toHash';


--
-- Name: COLUMN sta_pr_rescope_activity.prev_from_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_activity.prev_from_hash IS 'previousFromHash';


--
-- Name: COLUMN sta_pr_rescope_activity.prev_to_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_activity.prev_to_hash IS 'previousToHash';


--
-- Name: COLUMN sta_pr_rescope_activity.commits_added; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_activity.commits_added IS 'addedCommits';


--
-- Name: COLUMN sta_pr_rescope_activity.commits_removed; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_activity.commits_removed IS 'removedCommits';


--
-- Name: sta_pr_rescope_commit; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_pr_rescope_commit (
    activity_id bigint NOT NULL,
    changeset_id character varying(40) NOT NULL,
    action integer NOT NULL
);


ALTER TABLE public.sta_pr_rescope_commit OWNER TO bitbucket;

--
-- Name: COLUMN sta_pr_rescope_commit.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_commit.activity_id IS 'activity';


--
-- Name: COLUMN sta_pr_rescope_commit.changeset_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_commit.changeset_id IS 'changsetId';


--
-- Name: COLUMN sta_pr_rescope_commit.action; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_commit.action IS 'action';


--
-- Name: sta_pr_rescope_request; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_pr_rescope_request (
    id bigint NOT NULL,
    repo_id integer NOT NULL,
    user_id integer NOT NULL,
    created_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.sta_pr_rescope_request OWNER TO bitbucket;

--
-- Name: COLUMN sta_pr_rescope_request.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request.id IS 'id';


--
-- Name: COLUMN sta_pr_rescope_request.repo_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request.repo_id IS 'repository';


--
-- Name: COLUMN sta_pr_rescope_request.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request.user_id IS 'user';


--
-- Name: COLUMN sta_pr_rescope_request.created_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request.created_timestamp IS 'createdDate';


--
-- Name: sta_pr_rescope_request_change; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_pr_rescope_request_change (
    request_id bigint NOT NULL,
    ref_id character varying(1024) NOT NULL,
    change_type integer NOT NULL,
    from_hash character varying(40),
    to_hash character varying(40)
);


ALTER TABLE public.sta_pr_rescope_request_change OWNER TO bitbucket;

--
-- Name: COLUMN sta_pr_rescope_request_change.request_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request_change.request_id IS 'rescopeRequest';


--
-- Name: COLUMN sta_pr_rescope_request_change.ref_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request_change.ref_id IS 'refId';


--
-- Name: COLUMN sta_pr_rescope_request_change.change_type; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request_change.change_type IS 'type';


--
-- Name: COLUMN sta_pr_rescope_request_change.from_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request_change.from_hash IS 'fromHash';


--
-- Name: COLUMN sta_pr_rescope_request_change.to_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pr_rescope_request_change.to_hash IS 'toHash';


--
-- Name: sta_project_permission; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_project_permission (
    id bigint NOT NULL,
    perm_id integer NOT NULL,
    project_id integer NOT NULL,
    group_name character varying(255),
    user_id integer
);


ALTER TABLE public.sta_project_permission OWNER TO bitbucket;

--
-- Name: sta_pull_request; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_pull_request (
    id bigint NOT NULL,
    entity_version integer NOT NULL,
    scoped_id bigint NOT NULL,
    pr_state integer NOT NULL,
    created_timestamp timestamp without time zone NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL,
    from_repository_id integer NOT NULL,
    to_repository_id integer NOT NULL,
    from_branch_fqn character varying(1024) NOT NULL,
    to_branch_fqn character varying(1024) NOT NULL,
    from_branch_name character varying(255) NOT NULL,
    to_branch_name character varying(255) NOT NULL,
    from_hash character varying(40) NOT NULL,
    to_hash character varying(40) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    locked_timestamp timestamp without time zone,
    rescoped_timestamp timestamp without time zone NOT NULL,
    closed_timestamp timestamp without time zone
);


ALTER TABLE public.sta_pull_request OWNER TO bitbucket;

--
-- Name: COLUMN sta_pull_request.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.id IS 'id, globalId';


--
-- Name: COLUMN sta_pull_request.entity_version; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.entity_version IS 'version';


--
-- Name: COLUMN sta_pull_request.scoped_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.scoped_id IS 'scopedId';


--
-- Name: COLUMN sta_pull_request.pr_state; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.pr_state IS 'state';


--
-- Name: COLUMN sta_pull_request.created_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.created_timestamp IS 'createdDate';


--
-- Name: COLUMN sta_pull_request.updated_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.updated_timestamp IS 'updatedDate';


--
-- Name: COLUMN sta_pull_request.from_repository_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.from_repository_id IS 'fromRef.repository';


--
-- Name: COLUMN sta_pull_request.to_repository_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.to_repository_id IS 'toRef.repository';


--
-- Name: COLUMN sta_pull_request.from_branch_fqn; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.from_branch_fqn IS 'fromRef.id';


--
-- Name: COLUMN sta_pull_request.to_branch_fqn; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.to_branch_fqn IS 'toRef.id';


--
-- Name: COLUMN sta_pull_request.from_branch_name; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.from_branch_name IS 'fromRef.displayId';


--
-- Name: COLUMN sta_pull_request.to_branch_name; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.to_branch_name IS 'toRef.displayId';


--
-- Name: COLUMN sta_pull_request.from_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.from_hash IS 'fromRef.hash';


--
-- Name: COLUMN sta_pull_request.to_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.to_hash IS 'toRef.hash';


--
-- Name: COLUMN sta_pull_request.title; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.title IS 'title';


--
-- Name: COLUMN sta_pull_request.description; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.description IS 'description';


--
-- Name: COLUMN sta_pull_request.locked_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.locked_timestamp IS 'lockedDate';


--
-- Name: COLUMN sta_pull_request.rescoped_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.rescoped_timestamp IS 'rescopeDate';


--
-- Name: COLUMN sta_pull_request.closed_timestamp; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_pull_request.closed_timestamp IS 'closedDate';


--
-- Name: sta_remember_me_token; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_remember_me_token (
    id bigint NOT NULL,
    series character varying(64) NOT NULL,
    token character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expiry_timestamp timestamp without time zone NOT NULL,
    claimed boolean NOT NULL,
    claimed_address character varying(255)
);


ALTER TABLE public.sta_remember_me_token OWNER TO bitbucket;

--
-- Name: COLUMN sta_remember_me_token.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_remember_me_token.user_id IS 'userId';


--
-- Name: sta_repo_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repo_activity (
    activity_id bigint NOT NULL,
    repository_id integer NOT NULL
);


ALTER TABLE public.sta_repo_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_repo_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: COLUMN sta_repo_activity.repository_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_activity.repository_id IS 'repository';


--
-- Name: sta_repo_created_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repo_created_activity (
    activity_id bigint NOT NULL
);


ALTER TABLE public.sta_repo_created_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_repo_created_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_created_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: sta_repo_hook; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repo_hook (
    id bigint NOT NULL,
    repository_id integer,
    hook_key character varying(255) NOT NULL,
    is_enabled boolean NOT NULL,
    lob_id bigint,
    project_id integer
);


ALTER TABLE public.sta_repo_hook OWNER TO bitbucket;

--
-- Name: COLUMN sta_repo_hook.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_hook.id IS 'id';


--
-- Name: COLUMN sta_repo_hook.repository_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_hook.repository_id IS 'repository';


--
-- Name: COLUMN sta_repo_hook.hook_key; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_hook.hook_key IS 'hookKey';


--
-- Name: COLUMN sta_repo_hook.is_enabled; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_hook.is_enabled IS 'enabled';


--
-- Name: COLUMN sta_repo_hook.lob_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_hook.lob_id IS 'settings';


--
-- Name: sta_repo_origin; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repo_origin (
    repository_id integer NOT NULL,
    origin_id integer NOT NULL
);


ALTER TABLE public.sta_repo_origin OWNER TO bitbucket;

--
-- Name: sta_repo_permission; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repo_permission (
    id bigint NOT NULL,
    perm_id integer NOT NULL,
    repo_id integer NOT NULL,
    group_name character varying(255),
    user_id integer
);


ALTER TABLE public.sta_repo_permission OWNER TO bitbucket;

--
-- Name: sta_repo_push_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repo_push_activity (
    activity_id bigint NOT NULL,
    trigger_id character varying(64) NOT NULL
);


ALTER TABLE public.sta_repo_push_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_repo_push_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_push_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: sta_repo_push_ref; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repo_push_ref (
    activity_id bigint NOT NULL,
    ref_id character varying(1024) NOT NULL,
    change_type integer NOT NULL,
    from_hash character varying(40) NOT NULL,
    to_hash character varying(40) NOT NULL,
    ref_update_type integer NOT NULL
);


ALTER TABLE public.sta_repo_push_ref OWNER TO bitbucket;

--
-- Name: COLUMN sta_repo_push_ref.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_push_ref.activity_id IS 'activity';


--
-- Name: COLUMN sta_repo_push_ref.ref_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_push_ref.ref_id IS 'refId';


--
-- Name: COLUMN sta_repo_push_ref.change_type; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_push_ref.change_type IS 'type';


--
-- Name: COLUMN sta_repo_push_ref.from_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_push_ref.from_hash IS 'fromHash';


--
-- Name: COLUMN sta_repo_push_ref.to_hash; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_push_ref.to_hash IS 'toHash';


--
-- Name: sta_repo_updated_activity; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repo_updated_activity (
    activity_id bigint NOT NULL
);


ALTER TABLE public.sta_repo_updated_activity OWNER TO bitbucket;

--
-- Name: COLUMN sta_repo_updated_activity.activity_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_repo_updated_activity.activity_id IS 'joinPrimaryKey';


--
-- Name: sta_repository_scoped_id; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_repository_scoped_id (
    repository_id integer NOT NULL,
    scope_type character varying(255) NOT NULL,
    next_id bigint NOT NULL
);


ALTER TABLE public.sta_repository_scoped_id OWNER TO bitbucket;

--
-- Name: sta_service_user; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_service_user (
    user_id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    active boolean NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    email_address character varying(255),
    label character varying(128) NOT NULL
);


ALTER TABLE public.sta_service_user OWNER TO bitbucket;

--
-- Name: COLUMN sta_service_user.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_service_user.user_id IS 'joinPrimaryKey';


--
-- Name: COLUMN sta_service_user.display_name; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_service_user.display_name IS 'service user display_name';


--
-- Name: COLUMN sta_service_user.active; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_service_user.active IS 'service user active';


--
-- Name: COLUMN sta_service_user.name; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_service_user.name IS 'service user name';


--
-- Name: COLUMN sta_service_user.slug; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_service_user.slug IS 'service user slug';


--
-- Name: COLUMN sta_service_user.email_address; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_service_user.email_address IS 'service user email';


--
-- Name: COLUMN sta_service_user.label; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_service_user.label IS 'service user label';


--
-- Name: sta_shared_lob; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_shared_lob (
    id bigint NOT NULL,
    lob_data text NOT NULL
);


ALTER TABLE public.sta_shared_lob OWNER TO bitbucket;

--
-- Name: COLUMN sta_shared_lob.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_shared_lob.id IS 'id';


--
-- Name: COLUMN sta_shared_lob.lob_data; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_shared_lob.lob_data IS 'data';


--
-- Name: sta_user_settings; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_user_settings (
    id integer NOT NULL,
    lob_id bigint NOT NULL
);


ALTER TABLE public.sta_user_settings OWNER TO bitbucket;

--
-- Name: COLUMN sta_user_settings.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_user_settings.id IS 'id';


--
-- Name: COLUMN sta_user_settings.lob_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_user_settings.lob_id IS 'settings';


--
-- Name: sta_watcher; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.sta_watcher (
    id bigint NOT NULL,
    watchable_id bigint NOT NULL,
    watchable_type integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.sta_watcher OWNER TO bitbucket;

--
-- Name: COLUMN sta_watcher.id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_watcher.id IS 'id';


--
-- Name: COLUMN sta_watcher.watchable_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_watcher.watchable_id IS 'watchable.id';


--
-- Name: COLUMN sta_watcher.watchable_type; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_watcher.watchable_type IS 'discriminatorColumn';


--
-- Name: COLUMN sta_watcher.user_id; Type: COMMENT; Schema: public; Owner: bitbucket
--

COMMENT ON COLUMN public.sta_watcher.user_id IS 'user.id';


--
-- Name: stash_user; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.stash_user (
    id integer NOT NULL
);


ALTER TABLE public.stash_user OWNER TO bitbucket;

--
-- Name: trusted_app; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.trusted_app (
    id integer NOT NULL,
    application_id character varying(255) NOT NULL,
    certificate_timeout bigint NOT NULL,
    public_key_base64 character varying(4000) NOT NULL
);


ALTER TABLE public.trusted_app OWNER TO bitbucket;

--
-- Name: trusted_app_restriction; Type: TABLE; Schema: public; Owner: bitbucket
--

CREATE TABLE public.trusted_app_restriction (
    id integer NOT NULL,
    trusted_app_id integer NOT NULL,
    restriction_type smallint NOT NULL,
    restriction_value character varying(255) NOT NULL
);


ALTER TABLE public.trusted_app_restriction OWNER TO bitbucket;

--
-- Name: AO_02A6C0_REJECTED_REF ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_02A6C0_REJECTED_REF" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_02A6C0_REJECTED_REF_ID_seq"'::regclass);


--
-- Name: AO_0E97B5_REPOSITORY_SHORTCUT ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_0E97B5_REPOSITORY_SHORTCUT" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_0E97B5_REPOSITORY_SHORTCUT_ID_seq"'::regclass);


--
-- Name: AO_2AD648_INSIGHT_ANNOTATION ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_2AD648_INSIGHT_ANNOTATION" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_2AD648_INSIGHT_ANNOTATION_ID_seq"'::regclass);


--
-- Name: AO_2AD648_INSIGHT_REPORT ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_2AD648_INSIGHT_REPORT" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_2AD648_INSIGHT_REPORT_ID_seq"'::regclass);


--
-- Name: AO_2AD648_MERGE_CHECK ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_2AD648_MERGE_CHECK" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_2AD648_MERGE_CHECK_ID_seq"'::regclass);


--
-- Name: AO_33D892_COMMENT_JIRA_ISSUE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_33D892_COMMENT_JIRA_ISSUE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_33D892_COMMENT_JIRA_ISSUE_ID_seq"'::regclass);


--
-- Name: AO_38321B_CUSTOM_CONTENT_LINK ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_38321B_CUSTOM_CONTENT_LINK" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_38321B_CUSTOM_CONTENT_LINK_ID_seq"'::regclass);


--
-- Name: AO_38F373_COMMENT_LIKE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_38F373_COMMENT_LIKE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_38F373_COMMENT_LIKE_ID_seq"'::regclass);


--
-- Name: AO_4789DD_DISABLED_CHECKS ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_DISABLED_CHECKS" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4789DD_DISABLED_CHECKS_ID_seq"'::regclass);


--
-- Name: AO_4789DD_HEALTH_CHECK_STATUS ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_HEALTH_CHECK_STATUS" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4789DD_HEALTH_CHECK_STATUS_ID_seq"'::regclass);


--
-- Name: AO_4789DD_HEALTH_CHECK_WATCHER ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_HEALTH_CHECK_WATCHER" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4789DD_HEALTH_CHECK_WATCHER_ID_seq"'::regclass);


--
-- Name: AO_4789DD_PROPERTIES ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_PROPERTIES" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4789DD_PROPERTIES_ID_seq"'::regclass);


--
-- Name: AO_4789DD_READ_NOTIFICATIONS ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_READ_NOTIFICATIONS" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4789DD_READ_NOTIFICATIONS_ID_seq"'::regclass);


--
-- Name: AO_4789DD_SHORTENED_KEY ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_SHORTENED_KEY" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4789DD_SHORTENED_KEY_ID_seq"'::regclass);


--
-- Name: AO_4789DD_TASK_MONITOR ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_TASK_MONITOR" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4789DD_TASK_MONITOR_ID_seq"'::regclass);


--
-- Name: AO_4C6A26_EXEMPT_MESSAGE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4C6A26_EXEMPT_MESSAGE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4C6A26_EXEMPT_MESSAGE_ID_seq"'::regclass);


--
-- Name: AO_4C6A26_EXEMPT_PUSHER ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4C6A26_EXEMPT_PUSHER" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4C6A26_EXEMPT_PUSHER_ID_seq"'::regclass);


--
-- Name: AO_4C6A26_JIRA_HOOK_CONFIG ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4C6A26_JIRA_HOOK_CONFIG" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_4C6A26_JIRA_HOOK_CONFIG_ID_seq"'::regclass);


--
-- Name: AO_616D7B_BRANCH_MODEL_CONFIG ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_BRANCH_MODEL_CONFIG" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_616D7B_BRANCH_MODEL_CONFIG_ID_seq"'::regclass);


--
-- Name: AO_616D7B_BRANCH_TYPE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_BRANCH_TYPE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_616D7B_BRANCH_TYPE_ID_seq"'::regclass);


--
-- Name: AO_616D7B_BRANCH_TYPE_CONFIG ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_BRANCH_TYPE_CONFIG" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_616D7B_BRANCH_TYPE_CONFIG_ID_seq"'::regclass);


--
-- Name: AO_616D7B_DELETE_AFTER_MERGE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_DELETE_AFTER_MERGE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_616D7B_DELETE_AFTER_MERGE_ID_seq"'::regclass);


--
-- Name: AO_616D7B_SCOPE_AUTO_MERGE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_SCOPE_AUTO_MERGE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_616D7B_SCOPE_AUTO_MERGE_ID_seq"'::regclass);


--
-- Name: AO_6978BB_PERMITTED_ENTITY ENTITY_ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_6978BB_PERMITTED_ENTITY" ALTER COLUMN "ENTITY_ID" SET DEFAULT nextval('public."AO_6978BB_PERMITTED_ENTITY_ENTITY_ID_seq"'::regclass);


--
-- Name: AO_6978BB_RESTRICTED_REF REF_ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_6978BB_RESTRICTED_REF" ALTER COLUMN "REF_ID" SET DEFAULT nextval('public."AO_6978BB_RESTRICTED_REF_REF_ID_seq"'::regclass);


--
-- Name: AO_777666_DEPLOYMENT_ISSUE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_777666_DEPLOYMENT_ISSUE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_777666_DEPLOYMENT_ISSUE_ID_seq"'::regclass);


--
-- Name: AO_777666_JIRA_INDEX ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_777666_JIRA_INDEX" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_777666_JIRA_INDEX_ID_seq"'::regclass);


--
-- Name: AO_777666_JIRA_SITE_CONFIG ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_777666_JIRA_SITE_CONFIG" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_777666_JIRA_SITE_CONFIG_ID_seq"'::regclass);


--
-- Name: AO_811463_GIT_LFS_LOCK ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_811463_GIT_LFS_LOCK" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_811463_GIT_LFS_LOCK_ID_seq"'::regclass);


--
-- Name: AO_8752F1_DATA_PIPELINE_CONFIG ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8752F1_DATA_PIPELINE_CONFIG" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_8752F1_DATA_PIPELINE_CONFIG_ID_seq"'::regclass);


--
-- Name: AO_8752F1_DATA_PIPELINE_EOO ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8752F1_DATA_PIPELINE_EOO" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_8752F1_DATA_PIPELINE_EOO_ID_seq"'::regclass);


--
-- Name: AO_8752F1_DATA_PIPELINE_JOB ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8752F1_DATA_PIPELINE_JOB" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_8752F1_DATA_PIPELINE_JOB_ID_seq"'::regclass);


--
-- Name: AO_8E6075_MIRRORING_REQUEST ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8E6075_MIRRORING_REQUEST" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_8E6075_MIRRORING_REQUEST_ID_seq"'::regclass);


--
-- Name: AO_92D5D5_REPO_NOTIFICATION ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_92D5D5_REPO_NOTIFICATION" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_92D5D5_REPO_NOTIFICATION_ID_seq"'::regclass);


--
-- Name: AO_92D5D5_USER_NOTIFICATION ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_92D5D5_USER_NOTIFICATION" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_92D5D5_USER_NOTIFICATION_ID_seq"'::regclass);


--
-- Name: AO_9DEC2A_DEFAULT_REVIEWER ENTITY_ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_9DEC2A_DEFAULT_REVIEWER" ALTER COLUMN "ENTITY_ID" SET DEFAULT nextval('public."AO_9DEC2A_DEFAULT_REVIEWER_ENTITY_ID_seq"'::regclass);


--
-- Name: AO_9DEC2A_PR_CONDITION PR_CONDITION_ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_9DEC2A_PR_CONDITION" ALTER COLUMN "PR_CONDITION_ID" SET DEFAULT nextval('public."AO_9DEC2A_PR_CONDITION_PR_CONDITION_ID_seq"'::regclass);


--
-- Name: AO_A0B856_WEBHOOK ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_WEBHOOK" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_A0B856_WEBHOOK_ID_seq"'::regclass);


--
-- Name: AO_A0B856_WEBHOOK_CONFIG ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_WEBHOOK_CONFIG" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_A0B856_WEBHOOK_CONFIG_ID_seq"'::regclass);


--
-- Name: AO_A0B856_WEBHOOK_EVENT ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_WEBHOOK_EVENT" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_A0B856_WEBHOOK_EVENT_ID_seq"'::regclass);


--
-- Name: AO_A0B856_WEB_HOOK_LISTENER_AO ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_WEB_HOOK_LISTENER_AO" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_A0B856_WEB_HOOK_LISTENER_AO_ID_seq"'::regclass);


--
-- Name: AO_BD73C3_PROJECT_AUDIT AUDIT_ITEM_ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_BD73C3_PROJECT_AUDIT" ALTER COLUMN "AUDIT_ITEM_ID" SET DEFAULT nextval('public."AO_BD73C3_PROJECT_AUDIT_AUDIT_ITEM_ID_seq"'::regclass);


--
-- Name: AO_BD73C3_REPOSITORY_AUDIT AUDIT_ITEM_ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_BD73C3_REPOSITORY_AUDIT" ALTER COLUMN "AUDIT_ITEM_ID" SET DEFAULT nextval('public."AO_BD73C3_REPOSITORY_AUDIT_AUDIT_ITEM_ID_seq"'::regclass);


--
-- Name: AO_C77861_AUDIT_ACTION_CACHE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_C77861_AUDIT_ACTION_CACHE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_C77861_AUDIT_ACTION_CACHE_ID_seq"'::regclass);


--
-- Name: AO_C77861_AUDIT_CATEGORY_CACHE ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_C77861_AUDIT_CATEGORY_CACHE" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_C77861_AUDIT_CATEGORY_CACHE_ID_seq"'::regclass);


--
-- Name: AO_C77861_AUDIT_DENY_LISTED ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_C77861_AUDIT_DENY_LISTED" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_C77861_AUDIT_DENY_LISTED_ID_seq"'::regclass);


--
-- Name: AO_C77861_AUDIT_ENTITY ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_C77861_AUDIT_ENTITY" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_C77861_AUDIT_ENTITY_ID_seq"'::regclass);


--
-- Name: AO_CFE8FA_BUILD_PARENT_KEYS ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_CFE8FA_BUILD_PARENT_KEYS" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_CFE8FA_BUILD_PARENT_KEYS_ID_seq"'::regclass);


--
-- Name: AO_CFE8FA_BUILD_STATUS ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_CFE8FA_BUILD_STATUS" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_CFE8FA_BUILD_STATUS_ID_seq"'::regclass);


--
-- Name: AO_CFE8FA_REQUIRED_BUILDS ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_CFE8FA_REQUIRED_BUILDS" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_CFE8FA_REQUIRED_BUILDS_ID_seq"'::regclass);


--
-- Name: AO_D6A508_IMPORT_JOB ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_D6A508_IMPORT_JOB" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_D6A508_IMPORT_JOB_ID_seq"'::regclass);


--
-- Name: AO_D6A508_REPO_IMPORT_TASK ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_D6A508_REPO_IMPORT_TASK" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_D6A508_REPO_IMPORT_TASK_ID_seq"'::regclass);


--
-- Name: AO_E40A46_ZDU_CLUSTER_NODES ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_E40A46_ZDU_CLUSTER_NODES" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_E40A46_ZDU_CLUSTER_NODES_ID_seq"'::regclass);


--
-- Name: AO_E433FA_DEFAULT_TASKS ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_E433FA_DEFAULT_TASKS" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_E433FA_DEFAULT_TASKS_ID_seq"'::regclass);


--
-- Name: AO_E5A814_ACCESS_TOKEN_PERM ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_E5A814_ACCESS_TOKEN_PERM" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_E5A814_ACCESS_TOKEN_PERM_ID_seq"'::regclass);


--
-- Name: AO_ED669C_IDP_CONFIG ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_ED669C_IDP_CONFIG" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_ED669C_IDP_CONFIG_ID_seq"'::regclass);


--
-- Name: AO_ED669C_SEEN_ASSERTIONS ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_ED669C_SEEN_ASSERTIONS" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_ED669C_SEEN_ASSERTIONS_ID_seq"'::regclass);


--
-- Name: AO_F4ED3A_ADD_ON_PROPERTY_AO ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_F4ED3A_ADD_ON_PROPERTY_AO" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_F4ED3A_ADD_ON_PROPERTY_AO_ID_seq"'::regclass);


--
-- Name: AO_FB71B4_SSH_KEY_RESTRICTION ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FB71B4_SSH_KEY_RESTRICTION" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_FB71B4_SSH_KEY_RESTRICTION_ID_seq"'::regclass);


--
-- Name: AO_FB71B4_SSH_PUBLIC_KEY ENTITY_ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FB71B4_SSH_PUBLIC_KEY" ALTER COLUMN "ENTITY_ID" SET DEFAULT nextval('public."AO_FB71B4_SSH_PUBLIC_KEY_ENTITY_ID_seq"'::regclass);


--
-- Name: AO_FE1BC5_REDIRECT_URI ID; Type: DEFAULT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_REDIRECT_URI" ALTER COLUMN "ID" SET DEFAULT nextval('public."AO_FE1BC5_REDIRECT_URI_ID_seq"'::regclass);


--
-- Name: AO_02A6C0_REJECTED_REF AO_02A6C0_REJECTED_REF_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_02A6C0_REJECTED_REF"
    ADD CONSTRAINT "AO_02A6C0_REJECTED_REF_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_02A6C0_SYNC_CONFIG AO_02A6C0_SYNC_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_02A6C0_SYNC_CONFIG"
    ADD CONSTRAINT "AO_02A6C0_SYNC_CONFIG_pkey" PRIMARY KEY ("REPOSITORY_ID");


--
-- Name: AO_0E97B5_REPOSITORY_SHORTCUT AO_0E97B5_REPOSITORY_SHORTCUT_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_0E97B5_REPOSITORY_SHORTCUT"
    ADD CONSTRAINT "AO_0E97B5_REPOSITORY_SHORTCUT_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_2AD648_INSIGHT_ANNOTATION AO_2AD648_INSIGHT_ANNOTATION_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_2AD648_INSIGHT_ANNOTATION"
    ADD CONSTRAINT "AO_2AD648_INSIGHT_ANNOTATION_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_2AD648_INSIGHT_REPORT AO_2AD648_INSIGHT_REPORT_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_2AD648_INSIGHT_REPORT"
    ADD CONSTRAINT "AO_2AD648_INSIGHT_REPORT_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_2AD648_MERGE_CHECK AO_2AD648_MERGE_CHECK_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_2AD648_MERGE_CHECK"
    ADD CONSTRAINT "AO_2AD648_MERGE_CHECK_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_33D892_COMMENT_JIRA_ISSUE AO_33D892_COMMENT_JIRA_ISSUE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_33D892_COMMENT_JIRA_ISSUE"
    ADD CONSTRAINT "AO_33D892_COMMENT_JIRA_ISSUE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_38321B_CUSTOM_CONTENT_LINK AO_38321B_CUSTOM_CONTENT_LINK_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_38321B_CUSTOM_CONTENT_LINK"
    ADD CONSTRAINT "AO_38321B_CUSTOM_CONTENT_LINK_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_38F373_COMMENT_LIKE AO_38F373_COMMENT_LIKE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_38F373_COMMENT_LIKE"
    ADD CONSTRAINT "AO_38F373_COMMENT_LIKE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4789DD_DISABLED_CHECKS AO_4789DD_DISABLED_CHECKS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_DISABLED_CHECKS"
    ADD CONSTRAINT "AO_4789DD_DISABLED_CHECKS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4789DD_HEALTH_CHECK_STATUS AO_4789DD_HEALTH_CHECK_STATUS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_HEALTH_CHECK_STATUS"
    ADD CONSTRAINT "AO_4789DD_HEALTH_CHECK_STATUS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4789DD_HEALTH_CHECK_WATCHER AO_4789DD_HEALTH_CHECK_WATCHER_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_HEALTH_CHECK_WATCHER"
    ADD CONSTRAINT "AO_4789DD_HEALTH_CHECK_WATCHER_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4789DD_PROPERTIES AO_4789DD_PROPERTIES_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_PROPERTIES"
    ADD CONSTRAINT "AO_4789DD_PROPERTIES_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4789DD_READ_NOTIFICATIONS AO_4789DD_READ_NOTIFICATIONS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_READ_NOTIFICATIONS"
    ADD CONSTRAINT "AO_4789DD_READ_NOTIFICATIONS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4789DD_SHORTENED_KEY AO_4789DD_SHORTENED_KEY_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_SHORTENED_KEY"
    ADD CONSTRAINT "AO_4789DD_SHORTENED_KEY_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4789DD_TASK_MONITOR AO_4789DD_TASK_MONITOR_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_TASK_MONITOR"
    ADD CONSTRAINT "AO_4789DD_TASK_MONITOR_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4C6A26_EXEMPT_MESSAGE AO_4C6A26_EXEMPT_MESSAGE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4C6A26_EXEMPT_MESSAGE"
    ADD CONSTRAINT "AO_4C6A26_EXEMPT_MESSAGE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4C6A26_EXEMPT_PUSHER AO_4C6A26_EXEMPT_PUSHER_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4C6A26_EXEMPT_PUSHER"
    ADD CONSTRAINT "AO_4C6A26_EXEMPT_PUSHER_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_4C6A26_JIRA_HOOK_CONFIG AO_4C6A26_JIRA_HOOK_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4C6A26_JIRA_HOOK_CONFIG"
    ADD CONSTRAINT "AO_4C6A26_JIRA_HOOK_CONFIG_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_616D7B_BRANCH_MODEL_CONFIG AO_616D7B_BRANCH_MODEL_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_BRANCH_MODEL_CONFIG"
    ADD CONSTRAINT "AO_616D7B_BRANCH_MODEL_CONFIG_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_616D7B_BRANCH_MODEL AO_616D7B_BRANCH_MODEL_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_BRANCH_MODEL"
    ADD CONSTRAINT "AO_616D7B_BRANCH_MODEL_pkey" PRIMARY KEY ("REPOSITORY_ID");


--
-- Name: AO_616D7B_BRANCH_TYPE_CONFIG AO_616D7B_BRANCH_TYPE_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_BRANCH_TYPE_CONFIG"
    ADD CONSTRAINT "AO_616D7B_BRANCH_TYPE_CONFIG_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_616D7B_BRANCH_TYPE AO_616D7B_BRANCH_TYPE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_BRANCH_TYPE"
    ADD CONSTRAINT "AO_616D7B_BRANCH_TYPE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_616D7B_DELETE_AFTER_MERGE AO_616D7B_DELETE_AFTER_MERGE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_DELETE_AFTER_MERGE"
    ADD CONSTRAINT "AO_616D7B_DELETE_AFTER_MERGE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_616D7B_SCOPE_AUTO_MERGE AO_616D7B_SCOPE_AUTO_MERGE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_SCOPE_AUTO_MERGE"
    ADD CONSTRAINT "AO_616D7B_SCOPE_AUTO_MERGE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_6978BB_PERMITTED_ENTITY AO_6978BB_PERMITTED_ENTITY_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_6978BB_PERMITTED_ENTITY"
    ADD CONSTRAINT "AO_6978BB_PERMITTED_ENTITY_pkey" PRIMARY KEY ("ENTITY_ID");


--
-- Name: AO_6978BB_RESTRICTED_REF AO_6978BB_RESTRICTED_REF_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_6978BB_RESTRICTED_REF"
    ADD CONSTRAINT "AO_6978BB_RESTRICTED_REF_pkey" PRIMARY KEY ("REF_ID");


--
-- Name: AO_723324_CLIENT_CONFIG AO_723324_CLIENT_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_723324_CLIENT_CONFIG"
    ADD CONSTRAINT "AO_723324_CLIENT_CONFIG_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_723324_CLIENT_TOKEN AO_723324_CLIENT_TOKEN_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_723324_CLIENT_TOKEN"
    ADD CONSTRAINT "AO_723324_CLIENT_TOKEN_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_777666_DEPLOYMENT_ISSUE AO_777666_DEPLOYMENT_ISSUE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_777666_DEPLOYMENT_ISSUE"
    ADD CONSTRAINT "AO_777666_DEPLOYMENT_ISSUE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_777666_JIRA_INDEX AO_777666_JIRA_INDEX_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_777666_JIRA_INDEX"
    ADD CONSTRAINT "AO_777666_JIRA_INDEX_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_777666_JIRA_SITE_CONFIG AO_777666_JIRA_SITE_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_777666_JIRA_SITE_CONFIG"
    ADD CONSTRAINT "AO_777666_JIRA_SITE_CONFIG_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_777666_UPDATED_ISSUES AO_777666_UPDATED_ISSUES_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_777666_UPDATED_ISSUES"
    ADD CONSTRAINT "AO_777666_UPDATED_ISSUES_pkey" PRIMARY KEY ("ISSUE");


--
-- Name: AO_811463_GIT_LFS_LOCK AO_811463_GIT_LFS_LOCK_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_811463_GIT_LFS_LOCK"
    ADD CONSTRAINT "AO_811463_GIT_LFS_LOCK_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_811463_GIT_LFS_REPO_CONFIG AO_811463_GIT_LFS_REPO_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_811463_GIT_LFS_REPO_CONFIG"
    ADD CONSTRAINT "AO_811463_GIT_LFS_REPO_CONFIG_pkey" PRIMARY KEY ("REPOSITORY_ID");


--
-- Name: AO_8752F1_DATA_PIPELINE_CONFIG AO_8752F1_DATA_PIPELINE_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8752F1_DATA_PIPELINE_CONFIG"
    ADD CONSTRAINT "AO_8752F1_DATA_PIPELINE_CONFIG_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_8752F1_DATA_PIPELINE_EOO AO_8752F1_DATA_PIPELINE_EOO_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8752F1_DATA_PIPELINE_EOO"
    ADD CONSTRAINT "AO_8752F1_DATA_PIPELINE_EOO_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_8752F1_DATA_PIPELINE_JOB AO_8752F1_DATA_PIPELINE_JOB_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8752F1_DATA_PIPELINE_JOB"
    ADD CONSTRAINT "AO_8752F1_DATA_PIPELINE_JOB_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_8E6075_MIRRORING_REQUEST AO_8E6075_MIRRORING_REQUEST_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8E6075_MIRRORING_REQUEST"
    ADD CONSTRAINT "AO_8E6075_MIRRORING_REQUEST_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_8E6075_MIRROR_SERVER AO_8E6075_MIRROR_SERVER_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8E6075_MIRROR_SERVER"
    ADD CONSTRAINT "AO_8E6075_MIRROR_SERVER_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_92D5D5_REPO_NOTIFICATION AO_92D5D5_REPO_NOTIFICATION_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_92D5D5_REPO_NOTIFICATION"
    ADD CONSTRAINT "AO_92D5D5_REPO_NOTIFICATION_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_92D5D5_USER_NOTIFICATION AO_92D5D5_USER_NOTIFICATION_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_92D5D5_USER_NOTIFICATION"
    ADD CONSTRAINT "AO_92D5D5_USER_NOTIFICATION_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_9DEC2A_DEFAULT_REVIEWER AO_9DEC2A_DEFAULT_REVIEWER_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_9DEC2A_DEFAULT_REVIEWER"
    ADD CONSTRAINT "AO_9DEC2A_DEFAULT_REVIEWER_pkey" PRIMARY KEY ("ENTITY_ID");


--
-- Name: AO_9DEC2A_PR_CONDITION AO_9DEC2A_PR_CONDITION_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_9DEC2A_PR_CONDITION"
    ADD CONSTRAINT "AO_9DEC2A_PR_CONDITION_pkey" PRIMARY KEY ("PR_CONDITION_ID");


--
-- Name: AO_A0B856_DAILY_COUNTS AO_A0B856_DAILY_COUNTS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_DAILY_COUNTS"
    ADD CONSTRAINT "AO_A0B856_DAILY_COUNTS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_A0B856_HIST_INVOCATION AO_A0B856_HIST_INVOCATION_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_HIST_INVOCATION"
    ADD CONSTRAINT "AO_A0B856_HIST_INVOCATION_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_A0B856_WEBHOOK_CONFIG AO_A0B856_WEBHOOK_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_WEBHOOK_CONFIG"
    ADD CONSTRAINT "AO_A0B856_WEBHOOK_CONFIG_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_A0B856_WEBHOOK_EVENT AO_A0B856_WEBHOOK_EVENT_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_WEBHOOK_EVENT"
    ADD CONSTRAINT "AO_A0B856_WEBHOOK_EVENT_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_A0B856_WEBHOOK AO_A0B856_WEBHOOK_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_WEBHOOK"
    ADD CONSTRAINT "AO_A0B856_WEBHOOK_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_A0B856_WEB_HOOK_LISTENER_AO AO_A0B856_WEB_HOOK_LISTENER_AO_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_A0B856_WEB_HOOK_LISTENER_AO"
    ADD CONSTRAINT "AO_A0B856_WEB_HOOK_LISTENER_AO_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_B586BC_GPG_KEY AO_B586BC_GPG_KEY_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_B586BC_GPG_KEY"
    ADD CONSTRAINT "AO_B586BC_GPG_KEY_pkey" PRIMARY KEY ("FINGERPRINT");


--
-- Name: AO_B586BC_GPG_SUB_KEY AO_B586BC_GPG_SUB_KEY_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_B586BC_GPG_SUB_KEY"
    ADD CONSTRAINT "AO_B586BC_GPG_SUB_KEY_pkey" PRIMARY KEY ("FINGERPRINT");


--
-- Name: AO_BD73C3_PROJECT_AUDIT AO_BD73C3_PROJECT_AUDIT_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_BD73C3_PROJECT_AUDIT"
    ADD CONSTRAINT "AO_BD73C3_PROJECT_AUDIT_pkey" PRIMARY KEY ("AUDIT_ITEM_ID");


--
-- Name: AO_BD73C3_REPOSITORY_AUDIT AO_BD73C3_REPOSITORY_AUDIT_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_BD73C3_REPOSITORY_AUDIT"
    ADD CONSTRAINT "AO_BD73C3_REPOSITORY_AUDIT_pkey" PRIMARY KEY ("AUDIT_ITEM_ID");


--
-- Name: AO_C77861_AUDIT_ACTION_CACHE AO_C77861_AUDIT_ACTION_CACHE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_C77861_AUDIT_ACTION_CACHE"
    ADD CONSTRAINT "AO_C77861_AUDIT_ACTION_CACHE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_C77861_AUDIT_CATEGORY_CACHE AO_C77861_AUDIT_CATEGORY_CACHE_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_C77861_AUDIT_CATEGORY_CACHE"
    ADD CONSTRAINT "AO_C77861_AUDIT_CATEGORY_CACHE_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_C77861_AUDIT_DENY_LISTED AO_C77861_AUDIT_DENY_LISTED_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_C77861_AUDIT_DENY_LISTED"
    ADD CONSTRAINT "AO_C77861_AUDIT_DENY_LISTED_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_C77861_AUDIT_ENTITY AO_C77861_AUDIT_ENTITY_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_C77861_AUDIT_ENTITY"
    ADD CONSTRAINT "AO_C77861_AUDIT_ENTITY_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_CFE8FA_BUILD_PARENT_KEYS AO_CFE8FA_BUILD_PARENT_KEYS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_CFE8FA_BUILD_PARENT_KEYS"
    ADD CONSTRAINT "AO_CFE8FA_BUILD_PARENT_KEYS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_CFE8FA_BUILD_STATUS AO_CFE8FA_BUILD_STATUS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_CFE8FA_BUILD_STATUS"
    ADD CONSTRAINT "AO_CFE8FA_BUILD_STATUS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_CFE8FA_REQUIRED_BUILDS AO_CFE8FA_REQUIRED_BUILDS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_CFE8FA_REQUIRED_BUILDS"
    ADD CONSTRAINT "AO_CFE8FA_REQUIRED_BUILDS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_D6A508_IMPORT_JOB AO_D6A508_IMPORT_JOB_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_D6A508_IMPORT_JOB"
    ADD CONSTRAINT "AO_D6A508_IMPORT_JOB_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_D6A508_REPO_IMPORT_TASK AO_D6A508_REPO_IMPORT_TASK_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_D6A508_REPO_IMPORT_TASK"
    ADD CONSTRAINT "AO_D6A508_REPO_IMPORT_TASK_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_E40A46_ZDU_CLUSTER_NODES AO_E40A46_ZDU_CLUSTER_NODES_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_E40A46_ZDU_CLUSTER_NODES"
    ADD CONSTRAINT "AO_E40A46_ZDU_CLUSTER_NODES_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_E433FA_DEFAULT_TASKS AO_E433FA_DEFAULT_TASKS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_E433FA_DEFAULT_TASKS"
    ADD CONSTRAINT "AO_E433FA_DEFAULT_TASKS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_E5A814_ACCESS_TOKEN_PERM AO_E5A814_ACCESS_TOKEN_PERM_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_E5A814_ACCESS_TOKEN_PERM"
    ADD CONSTRAINT "AO_E5A814_ACCESS_TOKEN_PERM_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_E5A814_ACCESS_TOKEN AO_E5A814_ACCESS_TOKEN_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_E5A814_ACCESS_TOKEN"
    ADD CONSTRAINT "AO_E5A814_ACCESS_TOKEN_pkey" PRIMARY KEY ("TOKEN_ID");


--
-- Name: AO_ED669C_IDP_CONFIG AO_ED669C_IDP_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_ED669C_IDP_CONFIG"
    ADD CONSTRAINT "AO_ED669C_IDP_CONFIG_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_ED669C_SEEN_ASSERTIONS AO_ED669C_SEEN_ASSERTIONS_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_ED669C_SEEN_ASSERTIONS"
    ADD CONSTRAINT "AO_ED669C_SEEN_ASSERTIONS_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_F4ED3A_ADD_ON_PROPERTY_AO AO_F4ED3A_ADD_ON_PROPERTY_AO_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_F4ED3A_ADD_ON_PROPERTY_AO"
    ADD CONSTRAINT "AO_F4ED3A_ADD_ON_PROPERTY_AO_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_FB71B4_SSH_KEY_RESTRICTION AO_FB71B4_SSH_KEY_RESTRICTION_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FB71B4_SSH_KEY_RESTRICTION"
    ADD CONSTRAINT "AO_FB71B4_SSH_KEY_RESTRICTION_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_FB71B4_SSH_PUBLIC_KEY AO_FB71B4_SSH_PUBLIC_KEY_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FB71B4_SSH_PUBLIC_KEY"
    ADD CONSTRAINT "AO_FB71B4_SSH_PUBLIC_KEY_pkey" PRIMARY KEY ("ENTITY_ID");


--
-- Name: AO_FE1BC5_ACCESS_TOKEN AO_FE1BC5_ACCESS_TOKEN_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_ACCESS_TOKEN"
    ADD CONSTRAINT "AO_FE1BC5_ACCESS_TOKEN_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_FE1BC5_AUTHORIZATION AO_FE1BC5_AUTHORIZATION_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_AUTHORIZATION"
    ADD CONSTRAINT "AO_FE1BC5_AUTHORIZATION_pkey" PRIMARY KEY ("AUTHORIZATION_CODE");


--
-- Name: AO_FE1BC5_CLIENT AO_FE1BC5_CLIENT_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_CLIENT"
    ADD CONSTRAINT "AO_FE1BC5_CLIENT_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_FE1BC5_REDIRECT_URI AO_FE1BC5_REDIRECT_URI_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_REDIRECT_URI"
    ADD CONSTRAINT "AO_FE1BC5_REDIRECT_URI_pkey" PRIMARY KEY ("ID");


--
-- Name: AO_FE1BC5_REFRESH_TOKEN AO_FE1BC5_REFRESH_TOKEN_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_REFRESH_TOKEN"
    ADD CONSTRAINT "AO_FE1BC5_REFRESH_TOKEN_pkey" PRIMARY KEY ("ID");


--
-- Name: app_property app_property_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.app_property
    ADD CONSTRAINT app_property_pkey PRIMARY KEY (prop_key);


--
-- Name: asyncdblock asyncdblock_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.asyncdblock
    ADD CONSTRAINT asyncdblock_pkey PRIMARY KEY (id);


--
-- Name: bb_alert bb_alert_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_alert
    ADD CONSTRAINT bb_alert_pkey PRIMARY KEY (id);


--
-- Name: bb_clusteredjob bb_clusteredjob_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_clusteredjob
    ADD CONSTRAINT bb_clusteredjob_pkey PRIMARY KEY (job_id);


--
-- Name: bb_comment_thread bb_comment_thread_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_comment_thread
    ADD CONSTRAINT bb_comment_thread_pkey PRIMARY KEY (id);


--
-- Name: bb_integrity_event bb_integrity_event_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_integrity_event
    ADD CONSTRAINT bb_integrity_event_pkey PRIMARY KEY (event_key);


--
-- Name: bb_label bb_label_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_label
    ADD CONSTRAINT bb_label_pkey PRIMARY KEY (id);


--
-- Name: bb_mesh_node bb_mesh_node_name_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_node
    ADD CONSTRAINT bb_mesh_node_name_key UNIQUE (name);


--
-- Name: bb_mesh_node bb_mesh_node_rpc_url_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_node
    ADD CONSTRAINT bb_mesh_node_rpc_url_key UNIQUE (rpc_url);


--
-- Name: bb_pr_part_status_weight bb_pr_part_status_weight_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_part_status_weight
    ADD CONSTRAINT bb_pr_part_status_weight_pkey PRIMARY KEY (status_id);


--
-- Name: bb_pr_part_status_weight bb_pr_part_status_weight_status_weight_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_part_status_weight
    ADD CONSTRAINT bb_pr_part_status_weight_status_weight_key UNIQUE (status_weight);


--
-- Name: bb_rl_user_settings bb_rl_user_settings_user_id_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_rl_user_settings
    ADD CONSTRAINT bb_rl_user_settings_user_id_key UNIQUE (user_id);


--
-- Name: changeset changeset_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.changeset
    ADD CONSTRAINT changeset_pkey PRIMARY KEY (id);


--
-- Name: current_app current_app_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.current_app
    ADD CONSTRAINT current_app_pkey PRIMARY KEY (id);


--
-- Name: cwd_app_dir_default_groups cwd_app_dir_default_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_default_groups
    ADD CONSTRAINT cwd_app_dir_default_groups_pkey PRIMARY KEY (id);


--
-- Name: cwd_app_licensed_user cwd_app_licensed_user_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_licensed_user
    ADD CONSTRAINT cwd_app_licensed_user_pkey PRIMARY KEY (id);


--
-- Name: cwd_app_licensing_dir_info cwd_app_licensing_dir_info_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_licensing_dir_info
    ADD CONSTRAINT cwd_app_licensing_dir_info_pkey PRIMARY KEY (id);


--
-- Name: cwd_app_licensing cwd_app_licensing_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_licensing
    ADD CONSTRAINT cwd_app_licensing_pkey PRIMARY KEY (id);


--
-- Name: cwd_application_saml_config cwd_application_saml_config_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application_saml_config
    ADD CONSTRAINT cwd_application_saml_config_pkey PRIMARY KEY (application_id);


--
-- Name: cwd_group_admin_group cwd_group_admin_group_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_admin_group
    ADD CONSTRAINT cwd_group_admin_group_pkey PRIMARY KEY (id);


--
-- Name: cwd_group_admin_user cwd_group_admin_user_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_admin_user
    ADD CONSTRAINT cwd_group_admin_user_pkey PRIMARY KEY (id);


--
-- Name: cwd_webhook cwd_webhook_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_webhook
    ADD CONSTRAINT cwd_webhook_pkey PRIMARY KEY (id);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: bb_attachment pk_attachment_id; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_attachment
    ADD CONSTRAINT pk_attachment_id PRIMARY KEY (id);


--
-- Name: bb_attachment_metadata pk_attachment_metadata; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_attachment_metadata
    ADD CONSTRAINT pk_attachment_metadata PRIMARY KEY (attachment_id);


--
-- Name: bb_announcement_banner pk_bb_announcement_banner; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_announcement_banner
    ADD CONSTRAINT pk_bb_announcement_banner PRIMARY KEY (id);


--
-- Name: bb_auto_decline_settings pk_bb_auto_decline_settings; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_auto_decline_settings
    ADD CONSTRAINT pk_bb_auto_decline_settings PRIMARY KEY (id);


--
-- Name: bb_build_status pk_bb_build_status; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_build_status
    ADD CONSTRAINT pk_bb_build_status PRIMARY KEY (id);


--
-- Name: bb_cmt_disc_comment_activity pk_bb_cmt_disc_com_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_cmt_disc_comment_activity
    ADD CONSTRAINT pk_bb_cmt_disc_com_activity PRIMARY KEY (activity_id);


--
-- Name: bb_comment_parent pk_bb_com_par_comment; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_comment_parent
    ADD CONSTRAINT pk_bb_com_par_comment PRIMARY KEY (comment_id);


--
-- Name: bb_comment pk_bb_comment; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_comment
    ADD CONSTRAINT pk_bb_comment PRIMARY KEY (id);


--
-- Name: bb_data_store pk_bb_data_store; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_data_store
    ADD CONSTRAINT pk_bb_data_store PRIMARY KEY (id);


--
-- Name: bb_dep_commit pk_bb_dep_commit; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_dep_commit
    ADD CONSTRAINT pk_bb_dep_commit PRIMARY KEY (id);


--
-- Name: bb_deployment pk_bb_deployment; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_deployment
    ADD CONSTRAINT pk_bb_deployment PRIMARY KEY (id);


--
-- Name: bb_emoticon pk_bb_emoticon; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_emoticon
    ADD CONSTRAINT pk_bb_emoticon PRIMARY KEY (id);


--
-- Name: bb_git_pr_cached_merge pk_bb_git_pr_cached_merge; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_git_pr_cached_merge
    ADD CONSTRAINT pk_bb_git_pr_cached_merge PRIMARY KEY (id);


--
-- Name: bb_git_pr_common_ancestor pk_bb_git_pr_common_ancestor; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_git_pr_common_ancestor
    ADD CONSTRAINT pk_bb_git_pr_common_ancestor PRIMARY KEY (id);


--
-- Name: bb_hook_script pk_bb_hook_script; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_hook_script
    ADD CONSTRAINT pk_bb_hook_script PRIMARY KEY (id);


--
-- Name: bb_hook_script_config pk_bb_hook_script_config; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_hook_script_config
    ADD CONSTRAINT pk_bb_hook_script_config PRIMARY KEY (id);


--
-- Name: bb_hook_script_trigger pk_bb_hook_script_trigger; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_hook_script_trigger
    ADD CONSTRAINT pk_bb_hook_script_trigger PRIMARY KEY (config_id, trigger_id);


--
-- Name: bb_job pk_bb_job; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_job
    ADD CONSTRAINT pk_bb_job PRIMARY KEY (id);


--
-- Name: bb_job_message pk_bb_job_message; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_job_message
    ADD CONSTRAINT pk_bb_job_message PRIMARY KEY (id);


--
-- Name: bb_label_mapping pk_bb_label_mapping; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_label_mapping
    ADD CONSTRAINT pk_bb_label_mapping PRIMARY KEY (id);


--
-- Name: bb_mesh_migration_job pk_bb_mesh_migration_job; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_migration_job
    ADD CONSTRAINT pk_bb_mesh_migration_job PRIMARY KEY (id);


--
-- Name: bb_mesh_migration_queue pk_bb_mesh_migration_queue; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_migration_queue
    ADD CONSTRAINT pk_bb_mesh_migration_queue PRIMARY KEY (id);


--
-- Name: bb_mesh_node pk_bb_mesh_node; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_node
    ADD CONSTRAINT pk_bb_mesh_node PRIMARY KEY (id);


--
-- Name: bb_mesh_node_key pk_bb_mesh_node_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_node_key
    ADD CONSTRAINT pk_bb_mesh_node_key PRIMARY KEY (node_id, fingerprint);


--
-- Name: bb_mesh_partition_migration pk_bb_mesh_partition_migration; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_partition_migration
    ADD CONSTRAINT pk_bb_mesh_partition_migration PRIMARY KEY (id);


--
-- Name: bb_mesh_partition_replica pk_bb_mesh_partition_replica; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_partition_replica
    ADD CONSTRAINT pk_bb_mesh_partition_replica PRIMARY KEY (id);


--
-- Name: bb_mesh_repo_replica pk_bb_mesh_repo_replica; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_repo_replica
    ADD CONSTRAINT pk_bb_mesh_repo_replica PRIMARY KEY (replica_id, repository_id);


--
-- Name: bb_mesh_signing_key pk_bb_mesh_signing_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_signing_key
    ADD CONSTRAINT pk_bb_mesh_signing_key PRIMARY KEY (key_owner, fingerprint);


--
-- Name: bb_mirror_content_hash pk_bb_mirror_content_hash; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mirror_content_hash
    ADD CONSTRAINT pk_bb_mirror_content_hash PRIMARY KEY (repository_id);


--
-- Name: bb_mirror_metadata_hash pk_bb_mirror_metadata_hash; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mirror_metadata_hash
    ADD CONSTRAINT pk_bb_mirror_metadata_hash PRIMARY KEY (repository_id);


--
-- Name: bb_pr_comment_activity pk_bb_pr_comment_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_comment_activity
    ADD CONSTRAINT pk_bb_pr_comment_activity PRIMARY KEY (activity_id);


--
-- Name: bb_pr_commit pk_bb_pr_commit; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_commit
    ADD CONSTRAINT pk_bb_pr_commit PRIMARY KEY (pr_id, commit_id);


--
-- Name: bb_pr_reviewer_added pk_bb_pr_reviewer_added; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_reviewer_added
    ADD CONSTRAINT pk_bb_pr_reviewer_added PRIMARY KEY (activity_id, user_id);


--
-- Name: bb_pr_reviewer_removed pk_bb_pr_reviewer_removed; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_reviewer_removed
    ADD CONSTRAINT pk_bb_pr_reviewer_removed PRIMARY KEY (activity_id, user_id);


--
-- Name: bb_pr_reviewer_upd_activity pk_bb_pr_reviewer_upd_act; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_reviewer_upd_activity
    ADD CONSTRAINT pk_bb_pr_reviewer_upd_act PRIMARY KEY (activity_id);


--
-- Name: bb_pull_request_template pk_bb_pr_template; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pull_request_template
    ADD CONSTRAINT pk_bb_pr_template PRIMARY KEY (id);


--
-- Name: bb_proj_merge_config pk_bb_proj_merge_config; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_proj_merge_config
    ADD CONSTRAINT pk_bb_proj_merge_config PRIMARY KEY (id);


--
-- Name: bb_proj_merge_strategy pk_bb_proj_merge_strategy; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_proj_merge_strategy
    ADD CONSTRAINT pk_bb_proj_merge_strategy PRIMARY KEY (config_id, strategy_id);


--
-- Name: bb_project_alias pk_bb_project_alias; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_project_alias
    ADD CONSTRAINT pk_bb_project_alias PRIMARY KEY (id);


--
-- Name: bb_repo_merge_config pk_bb_repo_merge_config; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repo_merge_config
    ADD CONSTRAINT pk_bb_repo_merge_config PRIMARY KEY (id);


--
-- Name: bb_repo_merge_strategy pk_bb_repo_merge_strategy; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repo_merge_strategy
    ADD CONSTRAINT pk_bb_repo_merge_strategy PRIMARY KEY (config_id, strategy_id);


--
-- Name: bb_repo_size pk_bb_repo_size; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repo_size
    ADD CONSTRAINT pk_bb_repo_size PRIMARY KEY (repo_id);


--
-- Name: bb_repository_alias pk_bb_repository_alias; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repository_alias
    ADD CONSTRAINT pk_bb_repository_alias PRIMARY KEY (id);


--
-- Name: bb_reviewer_group pk_bb_reviewer_group; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_reviewer_group
    ADD CONSTRAINT pk_bb_reviewer_group PRIMARY KEY (id);


--
-- Name: bb_reviewer_group_user pk_bb_reviewer_group_user; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_reviewer_group_user
    ADD CONSTRAINT pk_bb_reviewer_group_user PRIMARY KEY (group_id, user_id);


--
-- Name: bb_rl_reject_counter pk_bb_rl_reject_counter; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_rl_reject_counter
    ADD CONSTRAINT pk_bb_rl_reject_counter PRIMARY KEY (id);


--
-- Name: bb_rl_user_settings pk_bb_rl_user_settings; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_rl_user_settings
    ADD CONSTRAINT pk_bb_rl_user_settings PRIMARY KEY (id);


--
-- Name: bb_scm_merge_config pk_bb_scm_merge_config; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_scm_merge_config
    ADD CONSTRAINT pk_bb_scm_merge_config PRIMARY KEY (id);


--
-- Name: bb_scm_merge_strategy pk_bb_scm_merge_strategy; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_scm_merge_strategy
    ADD CONSTRAINT pk_bb_scm_merge_strategy PRIMARY KEY (config_id, strategy_id);


--
-- Name: bb_secret_allowlist_rule pk_bb_secret_allowlist_rule; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_secret_allowlist_rule
    ADD CONSTRAINT pk_bb_secret_allowlist_rule PRIMARY KEY (id);


--
-- Name: bb_secret_scan_rule pk_bb_secret_scan_rules; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_secret_scan_rule
    ADD CONSTRAINT pk_bb_secret_scan_rules PRIMARY KEY (id);


--
-- Name: bb_settings_restriction pk_bb_settings_restriction; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_settings_restriction
    ADD CONSTRAINT pk_bb_settings_restriction PRIMARY KEY (id);


--
-- Name: bb_ss_exempt_repo pk_bb_ss_exempt_repo; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_ss_exempt_repo
    ADD CONSTRAINT pk_bb_ss_exempt_repo PRIMARY KEY (repo_id);


--
-- Name: bb_suggestion_group pk_bb_suggestion_group; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_suggestion_group
    ADD CONSTRAINT pk_bb_suggestion_group PRIMARY KEY (comment_id);


--
-- Name: bb_thread_root_comment pk_bb_thr_root_com_comment; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_thread_root_comment
    ADD CONSTRAINT pk_bb_thr_root_com_comment PRIMARY KEY (thread_id);


--
-- Name: bb_user_dark_feature pk_bb_user_dark_feature; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_user_dark_feature
    ADD CONSTRAINT pk_bb_user_dark_feature PRIMARY KEY (id);


--
-- Name: cs_indexer_state pk_cs_indexer_state; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cs_indexer_state
    ADD CONSTRAINT pk_cs_indexer_state PRIMARY KEY (repository_id, indexer_id);


--
-- Name: cs_repo_membership pk_cs_repo_membership; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cs_repo_membership
    ADD CONSTRAINT pk_cs_repo_membership PRIMARY KEY (cs_id, repository_id);


--
-- Name: cwd_granted_perm pk_cwd_granted_perm; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_granted_perm
    ADD CONSTRAINT pk_cwd_granted_perm PRIMARY KEY (id);


--
-- Name: cwd_tombstone pk_cwd_tombstone; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_tombstone
    ADD CONSTRAINT pk_cwd_tombstone PRIMARY KEY (id);


--
-- Name: sta_global_permission pk_global_permission; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_global_permission
    ADD CONSTRAINT pk_global_permission PRIMARY KEY (id);


--
-- Name: id_sequence pk_id_sequence; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.id_sequence
    ADD CONSTRAINT pk_id_sequence PRIMARY KEY (sequence_name);


--
-- Name: plugin_setting pk_plugin_setting; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.plugin_setting
    ADD CONSTRAINT pk_plugin_setting PRIMARY KEY (id);


--
-- Name: sta_project_permission pk_project_permission; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_project_permission
    ADD CONSTRAINT pk_project_permission PRIMARY KEY (id);


--
-- Name: sta_remember_me_token pk_remember_me_id; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_remember_me_token
    ADD CONSTRAINT pk_remember_me_id PRIMARY KEY (id);


--
-- Name: sta_repo_permission pk_repo_permission; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_permission
    ADD CONSTRAINT pk_repo_permission PRIMARY KEY (id);


--
-- Name: repository_access pk_repository_access; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.repository_access
    ADD CONSTRAINT pk_repository_access PRIMARY KEY (user_id, repository_id);


--
-- Name: sta_activity pk_sta_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_activity
    ADD CONSTRAINT pk_sta_activity PRIMARY KEY (id);


--
-- Name: sta_cmt_disc_activity pk_sta_cmt_disc_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_disc_activity
    ADD CONSTRAINT pk_sta_cmt_disc_activity PRIMARY KEY (activity_id);


--
-- Name: sta_cmt_disc_participant pk_sta_cmt_disc_participant; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_disc_participant
    ADD CONSTRAINT pk_sta_cmt_disc_participant PRIMARY KEY (id);


--
-- Name: sta_cmt_discussion pk_sta_cmt_discussion; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_discussion
    ADD CONSTRAINT pk_sta_cmt_discussion PRIMARY KEY (id);


--
-- Name: sta_deleted_group pk_sta_deleted_group; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_deleted_group
    ADD CONSTRAINT pk_sta_deleted_group PRIMARY KEY (id);


--
-- Name: sta_drift_request pk_sta_drift_request; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_drift_request
    ADD CONSTRAINT pk_sta_drift_request PRIMARY KEY (id);


--
-- Name: sta_normal_project pk_sta_normal_project; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_normal_project
    ADD CONSTRAINT pk_sta_normal_project PRIMARY KEY (project_id);


--
-- Name: sta_normal_user pk_sta_normal_user; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_normal_user
    ADD CONSTRAINT pk_sta_normal_user PRIMARY KEY (user_id);


--
-- Name: sta_personal_project pk_sta_personal_project; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_personal_project
    ADD CONSTRAINT pk_sta_personal_project PRIMARY KEY (project_id);


--
-- Name: sta_pr_activity pk_sta_pr_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_activity
    ADD CONSTRAINT pk_sta_pr_activity PRIMARY KEY (activity_id);


--
-- Name: sta_pr_merge_activity pk_sta_pr_merge_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_merge_activity
    ADD CONSTRAINT pk_sta_pr_merge_activity PRIMARY KEY (activity_id);


--
-- Name: sta_pr_participant pk_sta_pr_participant; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_participant
    ADD CONSTRAINT pk_sta_pr_participant PRIMARY KEY (id);


--
-- Name: sta_pr_rescope_activity pk_sta_pr_rescope_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_activity
    ADD CONSTRAINT pk_sta_pr_rescope_activity PRIMARY KEY (activity_id);


--
-- Name: sta_pr_rescope_commit pk_sta_pr_rescope_commit; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_commit
    ADD CONSTRAINT pk_sta_pr_rescope_commit PRIMARY KEY (activity_id, changeset_id);


--
-- Name: sta_pr_rescope_request_change pk_sta_pr_rescope_req_change; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_request_change
    ADD CONSTRAINT pk_sta_pr_rescope_req_change PRIMARY KEY (request_id, ref_id);


--
-- Name: sta_pr_rescope_request pk_sta_pr_rescope_request; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_request
    ADD CONSTRAINT pk_sta_pr_rescope_request PRIMARY KEY (id);


--
-- Name: sta_pull_request pk_sta_pull_request; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pull_request
    ADD CONSTRAINT pk_sta_pull_request PRIMARY KEY (id);


--
-- Name: sta_repo_activity pk_sta_repo_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_activity
    ADD CONSTRAINT pk_sta_repo_activity PRIMARY KEY (activity_id);


--
-- Name: sta_repo_created_activity pk_sta_repo_created_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_created_activity
    ADD CONSTRAINT pk_sta_repo_created_activity PRIMARY KEY (activity_id);


--
-- Name: sta_repo_hook pk_sta_repo_hook; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_hook
    ADD CONSTRAINT pk_sta_repo_hook PRIMARY KEY (id);


--
-- Name: sta_repo_origin pk_sta_repo_origin; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_origin
    ADD CONSTRAINT pk_sta_repo_origin PRIMARY KEY (repository_id);


--
-- Name: sta_repo_push_activity pk_sta_repo_push_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_push_activity
    ADD CONSTRAINT pk_sta_repo_push_activity PRIMARY KEY (activity_id);


--
-- Name: sta_repo_push_ref pk_sta_repo_push_ref; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_push_ref
    ADD CONSTRAINT pk_sta_repo_push_ref PRIMARY KEY (activity_id, ref_id);


--
-- Name: sta_repo_updated_activity pk_sta_repo_updated_activity; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_updated_activity
    ADD CONSTRAINT pk_sta_repo_updated_activity PRIMARY KEY (activity_id);


--
-- Name: sta_repository_scoped_id pk_sta_repository_scoped_id; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repository_scoped_id
    ADD CONSTRAINT pk_sta_repository_scoped_id PRIMARY KEY (repository_id, scope_type);


--
-- Name: sta_service_user pk_sta_service_user; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_service_user
    ADD CONSTRAINT pk_sta_service_user PRIMARY KEY (user_id);


--
-- Name: sta_shared_lob pk_sta_shared_lob; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_shared_lob
    ADD CONSTRAINT pk_sta_shared_lob PRIMARY KEY (id);


--
-- Name: sta_user_settings pk_sta_user_settings; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_user_settings
    ADD CONSTRAINT pk_sta_user_settings PRIMARY KEY (id);


--
-- Name: sta_watcher pk_sta_watcher; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_watcher
    ADD CONSTRAINT pk_sta_watcher PRIMARY KEY (id);


--
-- Name: plugin_state plugin_state_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.plugin_state
    ADD CONSTRAINT plugin_state_pkey PRIMARY KEY (name);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: repository repository_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT repository_pkey PRIMARY KEY (id);


--
-- Name: stash_user stash_user_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.stash_user
    ADD CONSTRAINT stash_user_pkey PRIMARY KEY (id);


--
-- Name: cwd_app_dir_group_mapping sys_pk_10069; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_group_mapping
    ADD CONSTRAINT sys_pk_10069 PRIMARY KEY (id);


--
-- Name: cwd_app_dir_mapping sys_pk_10077; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_mapping
    ADD CONSTRAINT sys_pk_10077 PRIMARY KEY (id);


--
-- Name: cwd_app_dir_operation sys_pk_10083; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_operation
    ADD CONSTRAINT sys_pk_10083 PRIMARY KEY (app_dir_mapping_id, operation_type);


--
-- Name: cwd_application sys_pk_10093; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application
    ADD CONSTRAINT sys_pk_10093 PRIMARY KEY (id);


--
-- Name: cwd_application_address sys_pk_10100; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application_address
    ADD CONSTRAINT sys_pk_10100 PRIMARY KEY (remote_address);


--
-- Name: cwd_application_alias sys_pk_10108; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application_alias
    ADD CONSTRAINT sys_pk_10108 PRIMARY KEY (id);


--
-- Name: cwd_application_attribute sys_pk_10116; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application_attribute
    ADD CONSTRAINT sys_pk_10116 PRIMARY KEY (application_id, attribute_name);


--
-- Name: cwd_directory sys_pk_10127; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_directory
    ADD CONSTRAINT sys_pk_10127 PRIMARY KEY (id);


--
-- Name: cwd_directory_attribute sys_pk_10133; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_directory_attribute
    ADD CONSTRAINT sys_pk_10133 PRIMARY KEY (directory_id, attribute_name);


--
-- Name: cwd_directory_operation sys_pk_10137; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_directory_operation
    ADD CONSTRAINT sys_pk_10137 PRIMARY KEY (directory_id, operation_type);


--
-- Name: cwd_group sys_pk_10148; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group
    ADD CONSTRAINT sys_pk_10148 PRIMARY KEY (id);


--
-- Name: cwd_group_attribute sys_pk_10156; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_attribute
    ADD CONSTRAINT sys_pk_10156 PRIMARY KEY (id);


--
-- Name: cwd_membership sys_pk_10167; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_membership
    ADD CONSTRAINT sys_pk_10167 PRIMARY KEY (id);


--
-- Name: cwd_property sys_pk_10173; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_property
    ADD CONSTRAINT sys_pk_10173 PRIMARY KEY (property_key, property_name);


--
-- Name: cwd_user sys_pk_10194; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_user
    ADD CONSTRAINT sys_pk_10194 PRIMARY KEY (id);


--
-- Name: cwd_user_attribute sys_pk_10202; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_user_attribute
    ADD CONSTRAINT sys_pk_10202 PRIMARY KEY (id);


--
-- Name: cwd_user_credential_record sys_pk_10209; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_user_credential_record
    ADD CONSTRAINT sys_pk_10209 PRIMARY KEY (id);


--
-- Name: trusted_app trusted_app_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.trusted_app
    ADD CONSTRAINT trusted_app_pkey PRIMARY KEY (id);


--
-- Name: trusted_app_restriction trusted_app_restriction_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.trusted_app_restriction
    ADD CONSTRAINT trusted_app_restriction_pkey PRIMARY KEY (id);


--
-- Name: AO_4789DD_DISABLED_CHECKS u_ao_4789dd_disable1943052426; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_DISABLED_CHECKS"
    ADD CONSTRAINT u_ao_4789dd_disable1943052426 UNIQUE ("HEALTH_CHECK_KEY");


--
-- Name: AO_4789DD_HEALTH_CHECK_WATCHER u_ao_4789dd_health_432053140; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_HEALTH_CHECK_WATCHER"
    ADD CONSTRAINT u_ao_4789dd_health_432053140 UNIQUE ("USER_KEY");


--
-- Name: AO_4789DD_SHORTENED_KEY u_ao_4789dd_shortened_key_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_SHORTENED_KEY"
    ADD CONSTRAINT u_ao_4789dd_shortened_key_key UNIQUE ("KEY");


--
-- Name: AO_4789DD_TASK_MONITOR u_ao_4789dd_task_mo1827547914; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4789DD_TASK_MONITOR"
    ADD CONSTRAINT u_ao_4789dd_task_mo1827547914 UNIQUE ("TASK_ID");


--
-- Name: AO_723324_CLIENT_CONFIG u_ao_723324_client_config_name; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_723324_CLIENT_CONFIG"
    ADD CONSTRAINT u_ao_723324_client_config_name UNIQUE ("NAME");


--
-- Name: AO_777666_JIRA_SITE_CONFIG u_ao_777666_jira_si1507241262; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_777666_JIRA_SITE_CONFIG"
    ADD CONSTRAINT u_ao_777666_jira_si1507241262 UNIQUE ("CLIENT_ID");


--
-- Name: AO_811463_GIT_LFS_LOCK u_ao_811463_git_lfs121924061; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_811463_GIT_LFS_LOCK"
    ADD CONSTRAINT u_ao_811463_git_lfs121924061 UNIQUE ("REPO_PATH_HASH");


--
-- Name: AO_8752F1_DATA_PIPELINE_CONFIG u_ao_8752f1_data_pi710125765; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8752F1_DATA_PIPELINE_CONFIG"
    ADD CONSTRAINT u_ao_8752f1_data_pi710125765 UNIQUE ("KEY");


--
-- Name: AO_8E6075_MIRROR_SERVER u_ao_8e6075_mirror_881127116; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_8E6075_MIRROR_SERVER"
    ADD CONSTRAINT u_ao_8e6075_mirror_881127116 UNIQUE ("ADD_ON_KEY");


--
-- Name: AO_ED669C_IDP_CONFIG u_ao_ed669c_idp_con1454004950; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_ED669C_IDP_CONFIG"
    ADD CONSTRAINT u_ao_ed669c_idp_con1454004950 UNIQUE ("BUTTON_TEXT");


--
-- Name: AO_ED669C_IDP_CONFIG u_ao_ed669c_idp_config_issuer; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_ED669C_IDP_CONFIG"
    ADD CONSTRAINT u_ao_ed669c_idp_config_issuer UNIQUE ("ISSUER");


--
-- Name: AO_ED669C_IDP_CONFIG u_ao_ed669c_idp_config_name; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_ED669C_IDP_CONFIG"
    ADD CONSTRAINT u_ao_ed669c_idp_config_name UNIQUE ("NAME");


--
-- Name: AO_ED669C_SEEN_ASSERTIONS u_ao_ed669c_seen_as1055534769; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_ED669C_SEEN_ASSERTIONS"
    ADD CONSTRAINT u_ao_ed669c_seen_as1055534769 UNIQUE ("ASSERTION_ID");


--
-- Name: AO_F4ED3A_ADD_ON_PROPERTY_AO u_ao_f4ed3a_add_on_1238639798; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_F4ED3A_ADD_ON_PROPERTY_AO"
    ADD CONSTRAINT u_ao_f4ed3a_add_on_1238639798 UNIQUE ("PRIMARY_KEY");


--
-- Name: AO_FE1BC5_CLIENT u_ao_fe1bc5_client_1625323162; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_CLIENT"
    ADD CONSTRAINT u_ao_fe1bc5_client_1625323162 UNIQUE ("CLIENT_SECRET");


--
-- Name: AO_FE1BC5_CLIENT u_ao_fe1bc5_client_client_id; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_CLIENT"
    ADD CONSTRAINT u_ao_fe1bc5_client_client_id UNIQUE ("CLIENT_ID");


--
-- Name: AO_FE1BC5_CLIENT u_ao_fe1bc5_client_name; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_FE1BC5_CLIENT"
    ADD CONSTRAINT u_ao_fe1bc5_client_name UNIQUE ("NAME");


--
-- Name: cwd_app_dir_default_groups uk_appmapping_groupname; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_default_groups
    ADD CONSTRAINT uk_appmapping_groupname UNIQUE (application_mapping_id, group_name);


--
-- Name: cwd_group_admin_group uk_group_and_target_group; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_admin_group
    ADD CONSTRAINT uk_group_and_target_group UNIQUE (group_id, target_group_id);


--
-- Name: cwd_membership uk_mem_dir_parent_child; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_membership
    ADD CONSTRAINT uk_mem_dir_parent_child UNIQUE (directory_id, lower_child_name, lower_parent_name, membership_type);


--
-- Name: project uk_project_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT uk_project_key UNIQUE (namespace, project_key);


--
-- Name: project uk_project_name; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT uk_project_name UNIQUE (namespace, name);


--
-- Name: repository uk_slug_project_id; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT uk_slug_project_id UNIQUE (slug, project_id);


--
-- Name: trusted_app_restriction uk_trusted_app_restrict; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.trusted_app_restriction
    ADD CONSTRAINT uk_trusted_app_restrict UNIQUE (trusted_app_id, restriction_type, restriction_value);


--
-- Name: cwd_group_admin_user uk_user_and_target_group; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_admin_user
    ADD CONSTRAINT uk_user_and_target_group UNIQUE (user_id, target_group_id);


--
-- Name: bb_build_status uq_bb_build_status_rck; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_build_status
    ADD CONSTRAINT uq_bb_build_status_rck UNIQUE (non_null_repository_id, commit_id, build_key);


--
-- Name: bb_data_store uq_bb_data_store_path; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_data_store
    ADD CONSTRAINT uq_bb_data_store_path UNIQUE (ds_path);


--
-- Name: bb_data_store uq_bb_data_store_uuid; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_data_store
    ADD CONSTRAINT uq_bb_data_store_uuid UNIQUE (ds_uuid);


--
-- Name: bb_dep_commit uq_bb_dep_ri_ci_di; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_dep_commit
    ADD CONSTRAINT uq_bb_dep_ri_ci_di UNIQUE (repository_id, commit_id, deployment_id);


--
-- Name: bb_deployment uq_bb_dep_ri_ci_ek_dk_dn; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_deployment
    ADD CONSTRAINT uq_bb_dep_ri_ci_ek_dk_dn UNIQUE (repository_id, environment_key, deployment_key, deployment_sequence_number);


--
-- Name: bb_hook_script_config uq_bb_hook_script_config; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_hook_script_config
    ADD CONSTRAINT uq_bb_hook_script_config UNIQUE (script_id, scope_id, scope_type);


--
-- Name: bb_mesh_migration_queue uq_bb_mesh_mgrtn_q_repo_job; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_migration_queue
    ADD CONSTRAINT uq_bb_mesh_mgrtn_q_repo_job UNIQUE (migration_job_id, repository_id);


--
-- Name: bb_mesh_partition_migration uq_bb_mesh_partition_migration; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_partition_migration
    ADD CONSTRAINT uq_bb_mesh_partition_migration UNIQUE (unique_token);


--
-- Name: bb_proj_merge_config uq_bb_proj_merge_config; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_proj_merge_config
    ADD CONSTRAINT uq_bb_proj_merge_config UNIQUE (project_id, scm_id);


--
-- Name: bb_project_alias uq_bb_project_alias_ns_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_project_alias
    ADD CONSTRAINT uq_bb_project_alias_ns_key UNIQUE (namespace, project_key);


--
-- Name: bb_repository_alias uq_bb_repo_alias_key_slug; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repository_alias
    ADD CONSTRAINT uq_bb_repo_alias_key_slug UNIQUE (project_namespace, project_key, slug);


--
-- Name: bb_repo_merge_config uq_bb_repo_merge_config; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repo_merge_config
    ADD CONSTRAINT uq_bb_repo_merge_config UNIQUE (repository_id);


--
-- Name: bb_reviewer_group uq_bb_reviewer_group_name; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_reviewer_group
    ADD CONSTRAINT uq_bb_reviewer_group_name UNIQUE (scope_id, scope_type, group_name);


--
-- Name: bb_scm_merge_config uq_bb_scm_merge_config; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_scm_merge_config
    ADD CONSTRAINT uq_bb_scm_merge_config UNIQUE (scm_id);


--
-- Name: bb_settings_restriction uq_bb_settings_restriction_ks; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_settings_restriction
    ADD CONSTRAINT uq_bb_settings_restriction_ks UNIQUE (namespace, feature_key, component_key, project_id);


--
-- Name: bb_thread_root_comment uq_bb_thr_root_com_comment_id; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_thread_root_comment
    ADD CONSTRAINT uq_bb_thr_root_com_comment_id UNIQUE (comment_id);


--
-- Name: bb_user_dark_feature uq_bb_user_dark_feat_user_feat; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_user_dark_feature
    ADD CONSTRAINT uq_bb_user_dark_feat_user_feat UNIQUE (user_id, feature_key);


--
-- Name: cwd_user uq_cwd_user_dir_ext_id; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_user
    ADD CONSTRAINT uq_cwd_user_dir_ext_id UNIQUE (directory_id, external_id);


--
-- Name: bb_label_mapping uq_label_mapping_ilt; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_label_mapping
    ADD CONSTRAINT uq_label_mapping_ilt UNIQUE (label_id, labelable_id, labelable_type);


--
-- Name: bb_mesh_partition_replica uq_mesh_part_repl_part_node; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_partition_replica
    ADD CONSTRAINT uq_mesh_part_repl_part_node UNIQUE (partition_id, node_id);


--
-- Name: sta_normal_user uq_normal_user_name; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_normal_user
    ADD CONSTRAINT uq_normal_user_name UNIQUE (name);


--
-- Name: sta_normal_user uq_normal_user_slug; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_normal_user
    ADD CONSTRAINT uq_normal_user_slug UNIQUE (slug);


--
-- Name: plugin_setting uq_plug_setting_ns_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.plugin_setting
    ADD CONSTRAINT uq_plug_setting_ns_key UNIQUE (key_name, namespace);


--
-- Name: sta_remember_me_token uq_remember_me_series_token; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_remember_me_token
    ADD CONSTRAINT uq_remember_me_series_token UNIQUE (series, token);


--
-- Name: sta_cmt_disc_participant uq_sta_cmt_disc_part_disc_user; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_disc_participant
    ADD CONSTRAINT uq_sta_cmt_disc_part_disc_user UNIQUE (discussion_id, user_id);


--
-- Name: sta_cmt_discussion uq_sta_cmt_disc_repo_cmt; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_discussion
    ADD CONSTRAINT uq_sta_cmt_disc_repo_cmt UNIQUE (repository_id, commit_id);


--
-- Name: sta_deleted_group uq_sta_deleted_group_name; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_deleted_group
    ADD CONSTRAINT uq_sta_deleted_group_name UNIQUE (name);


--
-- Name: sta_personal_project uq_sta_personal_project_owner; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_personal_project
    ADD CONSTRAINT uq_sta_personal_project_owner UNIQUE (owner_id);


--
-- Name: sta_pr_participant uq_sta_pr_participant_pr_user; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_participant
    ADD CONSTRAINT uq_sta_pr_participant_pr_user UNIQUE (pr_id, user_id);


--
-- Name: sta_pull_request uq_sta_pull_request_scoped_id; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pull_request
    ADD CONSTRAINT uq_sta_pull_request_scoped_id UNIQUE (to_repository_id, scoped_id);


--
-- Name: sta_repo_hook uq_sta_repo_hook_scope_hook; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_hook
    ADD CONSTRAINT uq_sta_repo_hook_scope_hook UNIQUE (project_id, repository_id, hook_key);


--
-- Name: sta_service_user uq_sta_service_slug; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_service_user
    ADD CONSTRAINT uq_sta_service_slug UNIQUE (slug);


--
-- Name: sta_service_user uq_sta_service_user_name; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_service_user
    ADD CONSTRAINT uq_sta_service_user_name UNIQUE (name);


--
-- Name: sta_watcher uq_sta_watcher; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_watcher
    ADD CONSTRAINT uq_sta_watcher UNIQUE (watchable_id, watchable_type, user_id);


--
-- Name: sta_permission_type weighted_permission_perm_weight_key; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_permission_type
    ADD CONSTRAINT weighted_permission_perm_weight_key UNIQUE (perm_weight);


--
-- Name: sta_permission_type weighted_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_permission_type
    ADD CONSTRAINT weighted_permission_pkey PRIMARY KEY (perm_id);


--
-- Name: bb_alert_issue; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX bb_alert_issue ON public.bb_alert USING btree (issue_id);


--
-- Name: bb_alert_issue_component; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX bb_alert_issue_component ON public.bb_alert USING btree (issue_component_id);


--
-- Name: bb_alert_node_lower; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX bb_alert_node_lower ON public.bb_alert USING btree (node_name_lower);


--
-- Name: bb_alert_plugin_lower; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX bb_alert_plugin_lower ON public.bb_alert USING btree (trigger_plugin_key_lower);


--
-- Name: bb_alert_severity; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX bb_alert_severity ON public.bb_alert USING btree (issue_severity);


--
-- Name: bb_alert_timestamp; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX bb_alert_timestamp ON public.bb_alert USING btree ("timestamp");


--
-- Name: bb_rl_rej_cntr_intvl_start; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX bb_rl_rej_cntr_intvl_start ON public.bb_rl_reject_counter USING btree (interval_start);


--
-- Name: bb_rl_rej_cntr_usr_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX bb_rl_rej_cntr_usr_id ON public.bb_rl_reject_counter USING btree (user_id);


--
-- Name: idx_admin_group; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_admin_group ON public.cwd_group_admin_group USING btree (group_id);


--
-- Name: idx_admin_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_admin_user ON public.cwd_group_admin_user USING btree (user_id);


--
-- Name: idx_app_active; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_app_active ON public.cwd_application USING btree (is_active);


--
-- Name: idx_app_address_app_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_app_address_app_id ON public.cwd_application_address USING btree (application_id);


--
-- Name: idx_app_dir_group_group_dir; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_app_dir_group_group_dir ON public.cwd_app_dir_group_mapping USING btree (directory_id, group_name);


--
-- Name: idx_app_dir_grp_mapping_app_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_app_dir_grp_mapping_app_id ON public.cwd_app_dir_group_mapping USING btree (application_id);


--
-- Name: idx_app_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_app_id ON public.cwd_app_licensing USING btree (application_id);


--
-- Name: idx_app_id_subtype_version; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX idx_app_id_subtype_version ON public.cwd_app_licensing USING btree (application_id, application_subtype, version);


--
-- Name: idx_app_type; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_app_type ON public.cwd_application USING btree (application_type);


--
-- Name: idx_attachment_repo_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_attachment_repo_id ON public.bb_attachment USING btree (repository_id);


--
-- Name: idx_attribute_to_cs; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_attribute_to_cs ON public.cs_attribute USING btree (att_name, att_value);


--
-- Name: idx_bb_build_status_commit_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_build_status_commit_id ON public.bb_build_status USING btree (commit_id);


--
-- Name: idx_bb_build_status_rcp; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_build_status_rcp ON public.bb_build_status USING btree (repository_id, created_date, lower((parent)::text) text_pattern_ops);


--
-- Name: idx_bb_build_status_repo_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_build_status_repo_id ON public.bb_build_status USING btree (repository_id);


--
-- Name: idx_bb_build_status_repo_ref; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_build_status_repo_ref ON public.bb_build_status USING btree (repository_id, ref);


--
-- Name: idx_bb_clusteredjob_jrk; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_clusteredjob_jrk ON public.bb_clusteredjob USING btree (job_runner_key);


--
-- Name: idx_bb_clusteredjob_next_run; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_clusteredjob_next_run ON public.bb_clusteredjob USING btree (next_run);


--
-- Name: idx_bb_cmt_disc_com_act_com; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_cmt_disc_com_act_com ON public.bb_cmt_disc_comment_activity USING btree (comment_id);


--
-- Name: idx_bb_com_par_parent; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_com_par_parent ON public.bb_comment_parent USING btree (parent_id);


--
-- Name: idx_bb_com_thr_commentable; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_com_thr_commentable ON public.bb_comment_thread USING btree (commentable_type, commentable_id);


--
-- Name: idx_bb_com_thr_diff_type; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_com_thr_diff_type ON public.bb_comment_thread USING btree (diff_type);


--
-- Name: idx_bb_com_thr_from_hash; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_com_thr_from_hash ON public.bb_comment_thread USING btree (from_hash);


--
-- Name: idx_bb_com_thr_to_hash; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_com_thr_to_hash ON public.bb_comment_thread USING btree (to_hash);


--
-- Name: idx_bb_com_thr_to_path; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_com_thr_to_path ON public.bb_comment_thread USING btree (to_path);


--
-- Name: idx_bb_comment_author; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_comment_author ON public.bb_comment USING btree (author_id);


--
-- Name: idx_bb_comment_resolver; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_comment_resolver ON public.bb_comment USING btree (resolver_id);


--
-- Name: idx_bb_comment_severity; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_comment_severity ON public.bb_comment USING btree (severity);


--
-- Name: idx_bb_comment_state; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_comment_state ON public.bb_comment USING btree (state);


--
-- Name: idx_bb_comment_thread; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_comment_thread ON public.bb_comment USING btree (thread_id);


--
-- Name: idx_bb_dep_commit_dep_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_dep_commit_dep_id ON public.bb_dep_commit USING btree (deployment_id);


--
-- Name: idx_bb_dep_commit_repo_commit; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_dep_commit_repo_commit ON public.bb_dep_commit USING btree (repository_id, commit_id);


--
-- Name: idx_bb_dep_identifiers; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_dep_identifiers ON public.bb_deployment USING btree (repository_id, deployment_key, environment_key, deployment_sequence_number);


--
-- Name: idx_bb_dep_repo_commit; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_dep_repo_commit ON public.bb_deployment USING btree (repository_id, to_commit_id);


--
-- Name: idx_bb_emoticon_provider; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_emoticon_provider ON public.bb_emoticon USING btree (provider);


--
-- Name: idx_bb_hook_script_cfg_scope; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_hook_script_cfg_scope ON public.bb_hook_script_config USING btree (scope_id, scope_type);


--
-- Name: idx_bb_hook_script_cfg_script; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_hook_script_cfg_script ON public.bb_hook_script_config USING btree (script_id);


--
-- Name: idx_bb_hook_script_plugin; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_hook_script_plugin ON public.bb_hook_script USING btree (plugin_key);


--
-- Name: idx_bb_hook_script_trgr_config; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_hook_script_trgr_config ON public.bb_hook_script_trigger USING btree (config_id);


--
-- Name: idx_bb_hook_script_type; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_hook_script_type ON public.bb_hook_script USING btree (hook_type);


--
-- Name: idx_bb_job_msg_job_severity; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_job_msg_job_severity ON public.bb_job_message USING btree (job_id, severity);


--
-- Name: idx_bb_job_stash_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_job_stash_user ON public.bb_job USING btree (initiator_id);


--
-- Name: idx_bb_job_state_type; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_job_state_type ON public.bb_job USING btree (state, type);


--
-- Name: idx_bb_job_type; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_job_type ON public.bb_job USING btree (type);


--
-- Name: idx_bb_label_map_labelable_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_label_map_labelable_id ON public.bb_label_mapping USING btree (labelable_id);


--
-- Name: idx_bb_label_mapping_label_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_label_mapping_label_id ON public.bb_label_mapping USING btree (label_id);


--
-- Name: idx_bb_mesh_mgrtn_job_state; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_mesh_mgrtn_job_state ON public.bb_mesh_migration_job USING btree (state);


--
-- Name: idx_bb_mesh_mgrtn_job_stime; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_mesh_mgrtn_job_stime ON public.bb_mesh_migration_job USING btree (start_timestamp);


--
-- Name: idx_bb_mesh_mgrtn_q_repo; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_mesh_mgrtn_q_repo ON public.bb_mesh_migration_queue USING btree (repository_id);


--
-- Name: idx_bb_mesh_mgrtn_q_state; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_mesh_mgrtn_q_state ON public.bb_mesh_migration_queue USING btree (state);


--
-- Name: idx_bb_mesh_part_repl_node; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_mesh_part_repl_node ON public.bb_mesh_partition_replica USING btree (node_id);


--
-- Name: idx_bb_mesh_repo_replica_repo; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_mesh_repo_replica_repo ON public.bb_mesh_repo_replica USING btree (repository_id);


--
-- Name: idx_bb_mesh_repo_replica_state; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_mesh_repo_replica_state ON public.bb_mesh_repo_replica USING btree (state);


--
-- Name: idx_bb_pr_com_act_comment; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_pr_com_act_comment ON public.bb_pr_comment_activity USING btree (comment_id);


--
-- Name: idx_bb_pr_commit_commit_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_pr_commit_commit_id ON public.bb_pr_commit USING btree (commit_id);


--
-- Name: idx_bb_pr_template_scope; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_pr_template_scope ON public.bb_pull_request_template USING btree (scope_id, scope_type);


--
-- Name: idx_bb_proj_alias_proj_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_proj_alias_proj_id ON public.bb_project_alias USING btree (project_id);


--
-- Name: idx_bb_reviewer_group_name; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_reviewer_group_name ON public.bb_reviewer_group USING btree (group_name);


--
-- Name: idx_bb_reviewer_group_name_text; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_reviewer_group_name_text ON public.bb_reviewer_group USING btree (lower((group_name)::text) text_pattern_ops);


--
-- Name: idx_bb_reviewer_group_scope; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_reviewer_group_scope ON public.bb_reviewer_group USING btree (scope_id, scope_type);


--
-- Name: idx_bb_reviewer_group_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_reviewer_group_user ON public.bb_reviewer_group_user USING btree (user_id);


--
-- Name: idx_bb_secret_allow_sid_st; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_secret_allow_sid_st ON public.bb_secret_allowlist_rule USING btree (scope_type, scope_id);


--
-- Name: idx_bb_secret_scan_sid_st; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_secret_scan_sid_st ON public.bb_secret_scan_rule USING btree (scope_id, scope_type);


--
-- Name: idx_bb_set_res_pa_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_set_res_pa_id ON public.bb_settings_restriction USING btree (processing_attempts, id);


--
-- Name: idx_bb_set_res_pid; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_set_res_pid ON public.bb_settings_restriction USING btree (project_id);


--
-- Name: idx_bb_set_res_ps_pst; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_set_res_ps_pst ON public.bb_settings_restriction USING btree (processed_state, processing_started_timestamp);


--
-- Name: idx_bb_ss_exempt_repo_sid_st; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_bb_ss_exempt_repo_sid_st ON public.bb_ss_exempt_repo USING btree (scope_id, scope_type);


--
-- Name: idx_changeset_author_timestamp; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_changeset_author_timestamp ON public.changeset USING btree (author_timestamp);


--
-- Name: idx_changeset_id_text; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_changeset_id_text ON public.changeset USING btree (id text_pattern_ops);


--
-- Name: idx_cs_repo_membership_repo_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_cs_repo_membership_repo_id ON public.cs_repo_membership USING btree (repository_id);


--
-- Name: idx_cs_to_attribute; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_cs_to_attribute ON public.cs_attribute USING btree (cs_id, att_name);


--
-- Name: idx_cwd_app_dir_mapping_dir_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_cwd_app_dir_mapping_dir_id ON public.cwd_app_dir_mapping USING btree (directory_id);


--
-- Name: idx_cwd_group_directory_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_cwd_group_directory_id ON public.cwd_group USING btree (directory_id);


--
-- Name: idx_cwd_group_external_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_cwd_group_external_id ON public.cwd_group USING btree (external_id);


--
-- Name: idx_cwd_membership_dir_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_cwd_membership_dir_id ON public.cwd_membership USING btree (directory_id);


--
-- Name: idx_cwd_user_user_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_cwd_user_user_id ON public.cwd_user_credential_record USING btree (user_id);


--
-- Name: idx_cwd_webhook_application_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_cwd_webhook_application_id ON public.cwd_webhook USING btree (application_id);


--
-- Name: idx_dir_active; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_dir_active ON public.cwd_directory USING btree (is_active);


--
-- Name: idx_dir_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_dir_id ON public.cwd_app_licensing_dir_info USING btree (directory_id);


--
-- Name: idx_dir_l_impl_class; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_dir_l_impl_class ON public.cwd_directory USING btree (lower_impl_class);


--
-- Name: idx_dir_type; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_dir_type ON public.cwd_directory USING btree (directory_type);


--
-- Name: idx_directory_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_directory_id ON public.cwd_app_licensed_user USING btree (directory_id);


--
-- Name: idx_global_permission_group; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_global_permission_group ON public.sta_global_permission USING btree (group_name);


--
-- Name: idx_global_permission_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_global_permission_user ON public.sta_global_permission USING btree (user_id);


--
-- Name: idx_granted_perm_dir_map_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_granted_perm_dir_map_id ON public.cwd_granted_perm USING btree (app_dir_mapping_id);


--
-- Name: idx_group_active; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_group_active ON public.cwd_group USING btree (is_active, directory_id);


--
-- Name: idx_group_attr_dir_name_lval; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_group_attr_dir_name_lval ON public.cwd_group_attribute USING btree (directory_id, attribute_name, attribute_lower_value);


--
-- Name: idx_group_target_group; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_group_target_group ON public.cwd_group_admin_group USING btree (target_group_id);


--
-- Name: idx_label_name; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_label_name ON public.bb_label USING btree (name text_pattern_ops);


--
-- Name: idx_mem_dir_child; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_mem_dir_child ON public.cwd_membership USING btree (membership_type, lower_child_name, directory_id);


--
-- Name: idx_mem_dir_parent; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_mem_dir_parent ON public.cwd_membership USING btree (membership_type, lower_parent_name, directory_id);


--
-- Name: idx_mem_dir_parent_child; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_mem_dir_parent_child ON public.cwd_membership USING btree (membership_type, lower_parent_name, lower_child_name, directory_id);


--
-- Name: idx_part_state_target_node; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_part_state_target_node ON public.bb_mesh_partition_migration USING btree (partition_id, state, target_node_id);


--
-- Name: idx_pr_rescope_request_pr_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_pr_rescope_request_pr_id ON public.sta_pr_rescope_request USING btree (user_id);


--
-- Name: idx_pr_review_removed_user_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_pr_review_removed_user_id ON public.bb_pr_reviewer_removed USING btree (user_id);


--
-- Name: idx_pr_reviewer_added_user_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_pr_reviewer_added_user_id ON public.bb_pr_reviewer_added USING btree (user_id);


--
-- Name: idx_project_lower_name; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_project_lower_name ON public.project USING btree (lower((name)::text));


--
-- Name: idx_project_permission_group; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_project_permission_group ON public.sta_project_permission USING btree (group_name);


--
-- Name: idx_project_permission_perm_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_project_permission_perm_id ON public.sta_project_permission USING btree (perm_id);


--
-- Name: idx_project_permission_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_project_permission_user ON public.sta_project_permission USING btree (user_id);


--
-- Name: idx_project_type; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_project_type ON public.project USING btree (project_type);


--
-- Name: idx_remember_me_token_user_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_remember_me_token_user_id ON public.sta_remember_me_token USING btree (user_id);


--
-- Name: idx_rep_alias_repo_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_rep_alias_repo_id ON public.bb_repository_alias USING btree (repository_id);


--
-- Name: idx_repo_access_repo_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_repo_access_repo_id ON public.repository_access USING btree (repository_id);


--
-- Name: idx_repo_permission_group; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_repo_permission_group ON public.sta_repo_permission USING btree (group_name);


--
-- Name: idx_repo_permission_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_repo_permission_user ON public.sta_repo_permission USING btree (user_id);


--
-- Name: idx_repository_access_user_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_repository_access_user_id ON public.repository_access USING btree (user_id);


--
-- Name: idx_repository_hierarchy_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_repository_hierarchy_id ON public.repository USING btree (hierarchy_id);


--
-- Name: idx_repository_project_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_repository_project_id ON public.repository USING btree (project_id);


--
-- Name: idx_repository_state; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_repository_state ON public.repository USING btree (state);


--
-- Name: idx_repository_store_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_repository_store_id ON public.repository USING btree (store_id);


--
-- Name: idx_sta_activity_created_time; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_activity_created_time ON public.sta_activity USING btree (created_timestamp);


--
-- Name: idx_sta_activity_type; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_activity_type ON public.sta_activity USING btree (activity_type);


--
-- Name: idx_sta_activity_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_activity_user ON public.sta_activity USING btree (user_id);


--
-- Name: idx_sta_cmt_disc_act_disc; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_cmt_disc_act_disc ON public.sta_cmt_disc_activity USING btree (discussion_id);


--
-- Name: idx_sta_cmt_disc_cmt; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_cmt_disc_cmt ON public.sta_cmt_discussion USING btree (commit_id);


--
-- Name: idx_sta_cmt_disc_part_disc; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_cmt_disc_part_disc ON public.sta_cmt_disc_participant USING btree (discussion_id);


--
-- Name: idx_sta_cmt_disc_part_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_cmt_disc_part_user ON public.sta_cmt_disc_participant USING btree (user_id);


--
-- Name: idx_sta_cmt_disc_repo; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_cmt_disc_repo ON public.sta_cmt_discussion USING btree (repository_id);


--
-- Name: idx_sta_deleted_group_ts; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_deleted_group_ts ON public.sta_deleted_group USING btree (deleted_timestamp);


--
-- Name: idx_sta_drift_request_pr_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_drift_request_pr_id ON public.sta_drift_request USING btree (pr_id);


--
-- Name: idx_sta_global_perm_perm_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_global_perm_perm_id ON public.sta_global_permission USING btree (perm_id);


--
-- Name: idx_sta_pr_activity; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_activity ON public.sta_pr_activity USING btree (pr_id, pr_action);


--
-- Name: idx_sta_pr_closed_ts; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_closed_ts ON public.sta_pull_request USING btree (closed_timestamp);


--
-- Name: idx_sta_pr_from_repo_update; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_from_repo_update ON public.sta_pull_request USING btree (from_repository_id, updated_timestamp);


--
-- Name: idx_sta_pr_participant_pr; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_participant_pr ON public.sta_pr_participant USING btree (pr_id);


--
-- Name: idx_sta_pr_participant_user; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_participant_user ON public.sta_pr_participant USING btree (user_id);


--
-- Name: idx_sta_pr_rescope_cmmt_act; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_rescope_cmmt_act ON public.sta_pr_rescope_commit USING btree (activity_id);


--
-- Name: idx_sta_pr_rescope_req_repo; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_rescope_req_repo ON public.sta_pr_rescope_request USING btree (repo_id);


--
-- Name: idx_sta_pr_to_repo_update; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_to_repo_update ON public.sta_pull_request USING btree (to_repository_id, updated_timestamp);


--
-- Name: idx_sta_pr_update_ts; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pr_update_ts ON public.sta_pull_request USING btree (updated_timestamp);


--
-- Name: idx_sta_proj_perm_pro_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_proj_perm_pro_id ON public.sta_project_permission USING btree (project_id);


--
-- Name: idx_sta_pull_request_from; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pull_request_from ON public.sta_pull_request USING btree (from_repository_id, from_branch_fqn);


--
-- Name: idx_sta_pull_request_state; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pull_request_state ON public.sta_pull_request USING btree (pr_state);


--
-- Name: idx_sta_pull_request_to; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_pull_request_to ON public.sta_pull_request USING btree (to_repository_id, to_branch_fqn);


--
-- Name: idx_sta_repo_activity_repo; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_activity_repo ON public.sta_repo_activity USING btree (repository_id);


--
-- Name: idx_sta_repo_hook_hook_key; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_hook_hook_key ON public.sta_repo_hook USING btree (hook_key);


--
-- Name: idx_sta_repo_hook_lob_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_hook_lob_id ON public.sta_repo_hook USING btree (lob_id);


--
-- Name: idx_sta_repo_hook_proj_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_hook_proj_id ON public.sta_repo_hook USING btree (project_id);


--
-- Name: idx_sta_repo_hook_repo_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_hook_repo_id ON public.sta_repo_hook USING btree (repository_id);


--
-- Name: idx_sta_repo_origin_origin_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_origin_origin_id ON public.sta_repo_origin USING btree (origin_id);


--
-- Name: idx_sta_repo_perm_perm_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_perm_perm_id ON public.sta_repo_permission USING btree (perm_id);


--
-- Name: idx_sta_repo_perm_repo_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_perm_repo_id ON public.sta_repo_permission USING btree (repo_id);


--
-- Name: idx_sta_repo_push_ref_activity; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_push_ref_activity ON public.sta_repo_push_ref USING btree (activity_id);


--
-- Name: idx_sta_repo_push_ref_text; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_repo_push_ref_text ON public.sta_repo_push_ref USING btree (lower((ref_id)::text) text_pattern_ops);


--
-- Name: idx_sta_user_settings_lob_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_user_settings_lob_id ON public.sta_user_settings USING btree (lob_id);


--
-- Name: idx_sta_watcher_user_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_sta_watcher_user_id ON public.sta_watcher USING btree (user_id);


--
-- Name: idx_state; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_state ON public.bb_mesh_partition_replica USING btree (state);


--
-- Name: idx_state_target_node; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_state_target_node ON public.bb_mesh_partition_migration USING btree (state, target_node_id);


--
-- Name: idx_summary_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_summary_id ON public.cwd_app_licensing_dir_info USING btree (licensing_summary_id);


--
-- Name: idx_target_node_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_target_node_id ON public.bb_mesh_partition_migration USING btree (target_node_id);


--
-- Name: idx_tombstone_type_timestamp; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_tombstone_type_timestamp ON public.cwd_tombstone USING btree (tombstone_type, tombstone_timestamp);


--
-- Name: idx_user_active; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_user_active ON public.cwd_user USING btree (is_active, directory_id);


--
-- Name: idx_user_attr_dir_name_lval; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_user_attr_dir_name_lval ON public.cwd_user_attribute USING btree (directory_id, attribute_name, attribute_lower_value);


--
-- Name: idx_user_attr_nval; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_user_attr_nval ON public.cwd_user_attribute USING btree (attribute_name, attribute_numeric_value);


--
-- Name: idx_user_lower_display_name; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_user_lower_display_name ON public.cwd_user USING btree (lower_display_name, directory_id);


--
-- Name: idx_user_lower_email_address; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_user_lower_email_address ON public.cwd_user USING btree (lower_email_address, directory_id);


--
-- Name: idx_user_lower_first_name; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_user_lower_first_name ON public.cwd_user USING btree (lower_first_name, directory_id);


--
-- Name: idx_user_lower_last_name; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_user_lower_last_name ON public.cwd_user USING btree (lower_last_name, directory_id);


--
-- Name: idx_user_target_group; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX idx_user_target_group ON public.cwd_group_admin_user USING btree (target_group_id);


--
-- Name: index_ao_02a6c0_rej1887153917; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_02a6c0_rej1887153917 ON public."AO_02A6C0_REJECTED_REF" USING btree ("REF_ID");


--
-- Name: index_ao_02a6c0_rej2030165690; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_02a6c0_rej2030165690 ON public."AO_02A6C0_REJECTED_REF" USING btree ("REPOSITORY_ID");


--
-- Name: index_ao_0e97b5_rep1393549559; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_0e97b5_rep1393549559 ON public."AO_0E97B5_REPOSITORY_SHORTCUT" USING btree ("REPOSITORY_ID");


--
-- Name: index_ao_0e97b5_rep250640664; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_0e97b5_rep250640664 ON public."AO_0E97B5_REPOSITORY_SHORTCUT" USING btree ("APPLICATION_LINK_ID");


--
-- Name: index_ao_0e97b5_rep309643510; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_0e97b5_rep309643510 ON public."AO_0E97B5_REPOSITORY_SHORTCUT" USING btree ("URL");


--
-- Name: index_ao_2ad648_ins1731502975; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_2ad648_ins1731502975 ON public."AO_2AD648_INSIGHT_ANNOTATION" USING btree ("FK_REPORT_ID");


--
-- Name: index_ao_2ad648_ins1796380851; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_2ad648_ins1796380851 ON public."AO_2AD648_INSIGHT_REPORT" USING btree ("CREATED_DATE");


--
-- Name: index_ao_2ad648_ins282325602; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_2ad648_ins282325602 ON public."AO_2AD648_INSIGHT_REPORT" USING btree ("REPORT_KEY");


--
-- Name: index_ao_2ad648_ins395294165; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_2ad648_ins395294165 ON public."AO_2AD648_INSIGHT_REPORT" USING btree ("COMMIT_ID");


--
-- Name: index_ao_2ad648_ins940577476; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_2ad648_ins940577476 ON public."AO_2AD648_INSIGHT_ANNOTATION" USING btree ("EXTERNAL_ID");


--
-- Name: index_ao_2ad648_ins998130206; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_2ad648_ins998130206 ON public."AO_2AD648_INSIGHT_REPORT" USING btree ("REPOSITORY_ID");


--
-- Name: index_ao_2ad648_mer169660680; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_2ad648_mer169660680 ON public."AO_2AD648_MERGE_CHECK" USING btree ("RESOURCE_ID");


--
-- Name: index_ao_2ad648_mer693118112; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_2ad648_mer693118112 ON public."AO_2AD648_MERGE_CHECK" USING btree ("RESOURCE_ID", "SCOPE_TYPE");


--
-- Name: index_ao_33d892_com451567676; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_33d892_com451567676 ON public."AO_33D892_COMMENT_JIRA_ISSUE" USING btree ("COMMENT_ID");


--
-- Name: index_ao_38321b_cus1828044926; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_38321b_cus1828044926 ON public."AO_38321B_CUSTOM_CONTENT_LINK" USING btree ("CONTENT_KEY");


--
-- Name: index_ao_38f373_com1776971882; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_38f373_com1776971882 ON public."AO_38F373_COMMENT_LIKE" USING btree ("COMMENT_ID");


--
-- Name: index_ao_4789dd_tas42846517; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_4789dd_tas42846517 ON public."AO_4789DD_TASK_MONITOR" USING btree ("TASK_MONITOR_KIND");


--
-- Name: index_ao_4c6a26_exe1429428835; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_4c6a26_exe1429428835 ON public."AO_4C6A26_EXEMPT_MESSAGE" USING btree ("FK_CONFIGURATION_ID");


--
-- Name: index_ao_4c6a26_exe296820041; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_4c6a26_exe296820041 ON public."AO_4C6A26_EXEMPT_PUSHER" USING btree ("FK_CONFIGURATION_ID");


--
-- Name: index_ao_4c6a26_jir1599140826; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_4c6a26_jir1599140826 ON public."AO_4C6A26_JIRA_HOOK_CONFIG" USING btree ("SCOPE_TYPE");


--
-- Name: index_ao_4c6a26_jir897787895; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_4c6a26_jir897787895 ON public."AO_4C6A26_JIRA_HOOK_CONFIG" USING btree ("RESOURCE_ID");


--
-- Name: index_ao_616d7b_bra1650093697; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_616d7b_bra1650093697 ON public."AO_616D7B_BRANCH_TYPE_CONFIG" USING btree ("BM_ID");


--
-- Name: index_ao_616d7b_bra995100348; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_616d7b_bra995100348 ON public."AO_616D7B_BRANCH_TYPE" USING btree ("FK_BM_ID");


--
-- Name: index_ao_6978bb_per1013425949; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_6978bb_per1013425949 ON public."AO_6978BB_PERMITTED_ENTITY" USING btree ("FK_RESTRICTED_ID");


--
-- Name: index_ao_6978bb_res1734713733; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_6978bb_res1734713733 ON public."AO_6978BB_RESTRICTED_REF" USING btree ("RESOURCE_ID", "SCOPE_TYPE");


--
-- Name: index_ao_6978bb_res2050912801; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_6978bb_res2050912801 ON public."AO_6978BB_RESTRICTED_REF" USING btree ("REF_TYPE");


--
-- Name: index_ao_6978bb_res847341420; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_6978bb_res847341420 ON public."AO_6978BB_RESTRICTED_REF" USING btree ("REF_VALUE");


--
-- Name: index_ao_777666_dep258323343; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_777666_dep258323343 ON public."AO_777666_DEPLOYMENT_ISSUE" USING btree ("DEPLOYMENT_ID");


--
-- Name: index_ao_777666_dep792109516; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_777666_dep792109516 ON public."AO_777666_DEPLOYMENT_ISSUE" USING btree ("REPOSITORY_ID");


--
-- Name: index_ao_777666_jir1125550666; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_777666_jir1125550666 ON public."AO_777666_JIRA_INDEX" USING btree ("PR_ID");


--
-- Name: index_ao_777666_jir1131965929; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_777666_jir1131965929 ON public."AO_777666_JIRA_INDEX" USING btree ("ISSUE");


--
-- Name: index_ao_777666_jir1850935500; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_777666_jir1850935500 ON public."AO_777666_JIRA_INDEX" USING btree ("REPOSITORY");


--
-- Name: index_ao_777666_upd291711106; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_777666_upd291711106 ON public."AO_777666_UPDATED_ISSUES" USING btree ("UPDATE_TIME");


--
-- Name: index_ao_811463_git849077583; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_811463_git849077583 ON public."AO_811463_GIT_LFS_LOCK" USING btree ("REPOSITORY_ID");


--
-- Name: index_ao_811463_git865917084; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_811463_git865917084 ON public."AO_811463_GIT_LFS_LOCK" USING btree ("DIRECTORY_HASH");


--
-- Name: index_ao_8752f1_dat1803576496; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_8752f1_dat1803576496 ON public."AO_8752F1_DATA_PIPELINE_JOB" USING btree ("STATUS");


--
-- Name: index_ao_8e6075_mir347013871; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_8e6075_mir347013871 ON public."AO_8E6075_MIRRORING_REQUEST" USING btree ("STATE");


--
-- Name: index_ao_8e6075_mir555689735; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_8e6075_mir555689735 ON public."AO_8E6075_MIRRORING_REQUEST" USING btree ("MIRROR_ID");


--
-- Name: index_ao_92d5d5_rep1921630497; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_92d5d5_rep1921630497 ON public."AO_92D5D5_REPO_NOTIFICATION" USING btree ("REPO_ID");


--
-- Name: index_ao_92d5d5_rep679913000; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_92d5d5_rep679913000 ON public."AO_92D5D5_REPO_NOTIFICATION" USING btree ("USER_ID");


--
-- Name: index_ao_92d5d5_rep7900273; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_92d5d5_rep7900273 ON public."AO_92D5D5_REPO_NOTIFICATION" USING btree ("REPO_ID", "USER_ID");


--
-- Name: index_ao_92d5d5_use1759417856; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_92d5d5_use1759417856 ON public."AO_92D5D5_USER_NOTIFICATION" USING btree ("BATCH_SENDER_ID");


--
-- Name: index_ao_9dec2a_def2001216546; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_9dec2a_def2001216546 ON public."AO_9DEC2A_DEFAULT_REVIEWER" USING btree ("FK_RESTRICTED_ID");


--
-- Name: index_ao_9dec2a_pr_1505644799; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_9dec2a_pr_1505644799 ON public."AO_9DEC2A_PR_CONDITION" USING btree ("SOURCE_REF_VALUE");


--
-- Name: index_ao_9dec2a_pr_1891129876; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_9dec2a_pr_1891129876 ON public."AO_9DEC2A_PR_CONDITION" USING btree ("SOURCE_REF_TYPE");


--
-- Name: index_ao_9dec2a_pr_1950938186; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_9dec2a_pr_1950938186 ON public."AO_9DEC2A_PR_CONDITION" USING btree ("RESOURCE_ID", "SCOPE_TYPE");


--
-- Name: index_ao_9dec2a_pr_387063498; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_9dec2a_pr_387063498 ON public."AO_9DEC2A_PR_CONDITION" USING btree ("TARGET_REF_TYPE");


--
-- Name: index_ao_9dec2a_pr_887062261; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_9dec2a_pr_887062261 ON public."AO_9DEC2A_PR_CONDITION" USING btree ("TARGET_REF_VALUE");


--
-- Name: index_ao_a0b856_web1050270930; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_a0b856_web1050270930 ON public."AO_A0B856_WEBHOOK_CONFIG" USING btree ("WEBHOOKID");


--
-- Name: index_ao_a0b856_web110787824; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_a0b856_web110787824 ON public."AO_A0B856_WEBHOOK_EVENT" USING btree ("WEBHOOKID");


--
-- Name: index_ao_b586bc_gpg1041851355; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_b586bc_gpg1041851355 ON public."AO_B586BC_GPG_KEY" USING btree ("USER_ID");


--
-- Name: index_ao_b586bc_gpg1471083652; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_b586bc_gpg1471083652 ON public."AO_B586BC_GPG_SUB_KEY" USING btree ("KEY_ID");


--
-- Name: index_ao_b586bc_gpg594452429; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_b586bc_gpg594452429 ON public."AO_B586BC_GPG_SUB_KEY" USING btree ("FK_GPG_KEY_ID");


--
-- Name: index_ao_b586bc_gpg_key_key_id; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_b586bc_gpg_key_key_id ON public."AO_B586BC_GPG_KEY" USING btree ("KEY_ID");


--
-- Name: index_ao_bd73c3_pro578890136; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_bd73c3_pro578890136 ON public."AO_BD73C3_PROJECT_AUDIT" USING btree ("PROJECT_ID");


--
-- Name: index_ao_bd73c3_rep1781875940; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_bd73c3_rep1781875940 ON public."AO_BD73C3_REPOSITORY_AUDIT" USING btree ("REPOSITORY_ID");


--
-- Name: index_ao_c77861_aud1143993171; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud1143993171 ON public."AO_C77861_AUDIT_CATEGORY_CACHE" USING btree ("CATEGORY");


--
-- Name: index_ao_c77861_aud148201205; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud148201205 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("CATEGORY");


--
-- Name: index_ao_c77861_aud1486016429; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud1486016429 ON public."AO_C77861_AUDIT_ACTION_CACHE" USING btree ("ACTION");


--
-- Name: index_ao_c77861_aud1490488814; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud1490488814 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("USER_ID", "ENTITY_TIMESTAMP");


--
-- Name: index_ao_c77861_aud1896469708; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud1896469708 ON public."AO_C77861_AUDIT_ACTION_CACHE" USING btree ("ACTION_T_KEY");


--
-- Name: index_ao_c77861_aud2071685161; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud2071685161 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("ENTITY_TIMESTAMP", "ID");


--
-- Name: index_ao_c77861_aud237541374; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud237541374 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("PRIMARY_RESOURCE_ID", "PRIMARY_RESOURCE_TYPE", "ENTITY_TIMESTAMP");


--
-- Name: index_ao_c77861_aud265617021; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud265617021 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("ACTION");


--
-- Name: index_ao_c77861_aud470300084; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud470300084 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("SECONDARY_RESOURCE_ID", "SECONDARY_RESOURCE_TYPE", "ENTITY_TIMESTAMP");


--
-- Name: index_ao_c77861_aud477310041; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud477310041 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("RESOURCE_ID_3", "RESOURCE_TYPE_3", "ENTITY_TIMESTAMP");


--
-- Name: index_ao_c77861_aud617238068; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud617238068 ON public."AO_C77861_AUDIT_CATEGORY_CACHE" USING btree ("CATEGORY_T_KEY");


--
-- Name: index_ao_c77861_aud737336300; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud737336300 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("RESOURCE_ID_4", "RESOURCE_TYPE_4", "ENTITY_TIMESTAMP");


--
-- Name: index_ao_c77861_aud76822836; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud76822836 ON public."AO_C77861_AUDIT_DENY_LISTED" USING btree ("ACTION");


--
-- Name: index_ao_c77861_aud96775159; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_c77861_aud96775159 ON public."AO_C77861_AUDIT_ENTITY" USING btree ("RESOURCE_ID_5", "RESOURCE_TYPE_5", "ENTITY_TIMESTAMP");


--
-- Name: index_ao_cfe8fa_bui170778589; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_cfe8fa_bui170778589 ON public."AO_CFE8FA_BUILD_PARENT_KEYS" USING btree ("FK_REQUIRED_BUILD_ID");


--
-- Name: index_ao_cfe8fa_bui803074819; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_cfe8fa_bui803074819 ON public."AO_CFE8FA_BUILD_STATUS" USING btree ("CSID");


--
-- Name: index_ao_cfe8fa_req339538324; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_cfe8fa_req339538324 ON public."AO_CFE8FA_REQUIRED_BUILDS" USING btree ("REPOSITORY_ID");


--
-- Name: index_ao_d6a508_rep1236870352; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_d6a508_rep1236870352 ON public."AO_D6A508_REPO_IMPORT_TASK" USING btree ("REPOSITORY_ID");


--
-- Name: index_ao_d6a508_rep1615191599; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_d6a508_rep1615191599 ON public."AO_D6A508_REPO_IMPORT_TASK" USING btree ("FAILURE_TYPE");


--
-- Name: index_ao_e433fa_def2009705908; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_e433fa_def2009705908 ON public."AO_E433FA_DEFAULT_TASKS" USING btree ("RESOURCE_ID");


--
-- Name: index_ao_e433fa_def509276748; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_e433fa_def509276748 ON public."AO_E433FA_DEFAULT_TASKS" USING btree ("RESOURCE_ID", "SCOPE_TYPE");


--
-- Name: index_ao_e5a814_acc680162561; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_e5a814_acc680162561 ON public."AO_E5A814_ACCESS_TOKEN" USING btree ("USER_ID");


--
-- Name: index_ao_e5a814_acc834148545; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_e5a814_acc834148545 ON public."AO_E5A814_ACCESS_TOKEN_PERM" USING btree ("FK_ACCESS_TOKEN_ID");


--
-- Name: index_ao_ed669c_see20117222; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_ed669c_see20117222 ON public."AO_ED669C_SEEN_ASSERTIONS" USING btree ("EXPIRY_TIMESTAMP");


--
-- Name: index_ao_f4ed3a_add50909668; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_f4ed3a_add50909668 ON public."AO_F4ED3A_ADD_ON_PROPERTY_AO" USING btree ("PLUGIN_KEY");


--
-- Name: index_ao_fb71b4_ssh120529590; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_fb71b4_ssh120529590 ON public."AO_FB71B4_SSH_PUBLIC_KEY" USING btree ("LABEL_LOWER");


--
-- Name: index_ao_fb71b4_ssh1382560526; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_fb71b4_ssh1382560526 ON public."AO_FB71B4_SSH_PUBLIC_KEY" USING btree ("KEY_MD5");


--
-- Name: index_ao_fb71b4_ssh714567837; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE INDEX index_ao_fb71b4_ssh714567837 ON public."AO_FB71B4_SSH_PUBLIC_KEY" USING btree ("USER_ID");


--
-- Name: sys_idx_sys_ct_10070_10072; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10070_10072 ON public.cwd_app_dir_group_mapping USING btree (app_dir_mapping_id, group_name);


--
-- Name: sys_idx_sys_ct_10078_10080; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10078_10080 ON public.cwd_app_dir_mapping USING btree (application_id, directory_id);


--
-- Name: sys_idx_sys_ct_10094_10096; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10094_10096 ON public.cwd_application USING btree (lower_application_name);


--
-- Name: sys_idx_sys_ct_10109_10112; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10109_10112 ON public.cwd_application_alias USING btree (application_id, lower_user_name);


--
-- Name: sys_idx_sys_ct_10110_10113; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10110_10113 ON public.cwd_application_alias USING btree (application_id, lower_alias_name);


--
-- Name: sys_idx_sys_ct_10128_10130; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10128_10130 ON public.cwd_directory USING btree (lower_directory_name);


--
-- Name: sys_idx_sys_ct_10149_10151; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10149_10151 ON public.cwd_group USING btree (lower_group_name, directory_id);


--
-- Name: sys_idx_sys_ct_10157_10159; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10157_10159 ON public.cwd_group_attribute USING btree (group_id, attribute_name, attribute_lower_value);


--
-- Name: sys_idx_sys_ct_10168_10170; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10168_10170 ON public.cwd_membership USING btree (parent_id, child_id, membership_type);


--
-- Name: sys_idx_sys_ct_10195_10197; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10195_10197 ON public.cwd_user USING btree (lower_user_name, directory_id);


--
-- Name: sys_idx_sys_ct_10203_10205; Type: INDEX; Schema: public; Owner: bitbucket
--

CREATE UNIQUE INDEX sys_idx_sys_ct_10203_10205 ON public.cwd_user_attribute USING btree (user_id, attribute_name, attribute_lower_value);


--
-- Name: cwd_group_admin_group fk_admin_group; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_admin_group
    ADD CONSTRAINT fk_admin_group FOREIGN KEY (group_id) REFERENCES public.cwd_group(id);


--
-- Name: cwd_group_admin_user fk_admin_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_admin_user
    ADD CONSTRAINT fk_admin_user FOREIGN KEY (user_id) REFERENCES public.cwd_user(id) ON DELETE CASCADE;


--
-- Name: cwd_application_alias fk_alias_app_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application_alias
    ADD CONSTRAINT fk_alias_app_id FOREIGN KEY (application_id) REFERENCES public.cwd_application(id);


--
-- Name: AO_2AD648_INSIGHT_ANNOTATION fk_ao_2ad648_insight_annotation_fk_report_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_2AD648_INSIGHT_ANNOTATION"
    ADD CONSTRAINT fk_ao_2ad648_insight_annotation_fk_report_id FOREIGN KEY ("FK_REPORT_ID") REFERENCES public."AO_2AD648_INSIGHT_REPORT"("ID");


--
-- Name: AO_4C6A26_EXEMPT_MESSAGE fk_ao_4c6a26_exempt_message_fk_configuration_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4C6A26_EXEMPT_MESSAGE"
    ADD CONSTRAINT fk_ao_4c6a26_exempt_message_fk_configuration_id FOREIGN KEY ("FK_CONFIGURATION_ID") REFERENCES public."AO_4C6A26_JIRA_HOOK_CONFIG"("ID");


--
-- Name: AO_4C6A26_EXEMPT_PUSHER fk_ao_4c6a26_exempt_pusher_fk_configuration_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_4C6A26_EXEMPT_PUSHER"
    ADD CONSTRAINT fk_ao_4c6a26_exempt_pusher_fk_configuration_id FOREIGN KEY ("FK_CONFIGURATION_ID") REFERENCES public."AO_4C6A26_JIRA_HOOK_CONFIG"("ID");


--
-- Name: AO_616D7B_BRANCH_TYPE_CONFIG fk_ao_616d7b_branch_type_config_bm_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_616D7B_BRANCH_TYPE_CONFIG"
    ADD CONSTRAINT fk_ao_616d7b_branch_type_config_bm_id FOREIGN KEY ("BM_ID") REFERENCES public."AO_616D7B_BRANCH_MODEL_CONFIG"("ID");


--
-- Name: AO_9DEC2A_DEFAULT_REVIEWER fk_ao_9dec2a_default_reviewer_fk_restricted_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_9DEC2A_DEFAULT_REVIEWER"
    ADD CONSTRAINT fk_ao_9dec2a_default_reviewer_fk_restricted_id FOREIGN KEY ("FK_RESTRICTED_ID") REFERENCES public."AO_9DEC2A_PR_CONDITION"("PR_CONDITION_ID");


--
-- Name: AO_B586BC_GPG_SUB_KEY fk_ao_b586bc_gpg_sub_key_fk_gpg_key_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_B586BC_GPG_SUB_KEY"
    ADD CONSTRAINT fk_ao_b586bc_gpg_sub_key_fk_gpg_key_id FOREIGN KEY ("FK_GPG_KEY_ID") REFERENCES public."AO_B586BC_GPG_KEY"("FINGERPRINT");


--
-- Name: AO_CFE8FA_BUILD_PARENT_KEYS fk_ao_cfe8fa_build_parent_keys_fk_required_build_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_CFE8FA_BUILD_PARENT_KEYS"
    ADD CONSTRAINT fk_ao_cfe8fa_build_parent_keys_fk_required_build_id FOREIGN KEY ("FK_REQUIRED_BUILD_ID") REFERENCES public."AO_CFE8FA_REQUIRED_BUILDS"("ID");


--
-- Name: AO_E5A814_ACCESS_TOKEN_PERM fk_ao_e5a814_access_token_perm_fk_access_token_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public."AO_E5A814_ACCESS_TOKEN_PERM"
    ADD CONSTRAINT fk_ao_e5a814_access_token_perm_fk_access_token_id FOREIGN KEY ("FK_ACCESS_TOKEN_ID") REFERENCES public."AO_E5A814_ACCESS_TOKEN"("TOKEN_ID");


--
-- Name: cwd_app_dir_mapping fk_app_dir_app; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_mapping
    ADD CONSTRAINT fk_app_dir_app FOREIGN KEY (application_id) REFERENCES public.cwd_application(id);


--
-- Name: cwd_app_dir_mapping fk_app_dir_dir; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_mapping
    ADD CONSTRAINT fk_app_dir_dir FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: cwd_app_dir_group_mapping fk_app_dir_group_app; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_group_mapping
    ADD CONSTRAINT fk_app_dir_group_app FOREIGN KEY (application_id) REFERENCES public.cwd_application(id);


--
-- Name: cwd_app_dir_group_mapping fk_app_dir_group_dir; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_group_mapping
    ADD CONSTRAINT fk_app_dir_group_dir FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: cwd_app_dir_group_mapping fk_app_dir_group_mapping; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_group_mapping
    ADD CONSTRAINT fk_app_dir_group_mapping FOREIGN KEY (app_dir_mapping_id) REFERENCES public.cwd_app_dir_mapping(id);


--
-- Name: cwd_app_dir_operation fk_app_dir_mapping; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_operation
    ADD CONSTRAINT fk_app_dir_mapping FOREIGN KEY (app_dir_mapping_id) REFERENCES public.cwd_app_dir_mapping(id);


--
-- Name: cwd_app_licensing fk_app_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_licensing
    ADD CONSTRAINT fk_app_id FOREIGN KEY (application_id) REFERENCES public.cwd_application(id);


--
-- Name: cwd_app_dir_default_groups fk_app_mapping; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_dir_default_groups
    ADD CONSTRAINT fk_app_mapping FOREIGN KEY (application_mapping_id) REFERENCES public.cwd_app_dir_mapping(id);


--
-- Name: cwd_application_saml_config fk_app_sso_config; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application_saml_config
    ADD CONSTRAINT fk_app_sso_config FOREIGN KEY (application_id) REFERENCES public.cwd_application(id) ON DELETE CASCADE;


--
-- Name: cwd_application_address fk_application_address; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application_address
    ADD CONSTRAINT fk_application_address FOREIGN KEY (application_id) REFERENCES public.cwd_application(id);


--
-- Name: cwd_application_attribute fk_application_attribute; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_application_attribute
    ADD CONSTRAINT fk_application_attribute FOREIGN KEY (application_id) REFERENCES public.cwd_application(id);


--
-- Name: bb_attachment_metadata fk_attachment_metadata_attach; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_attachment_metadata
    ADD CONSTRAINT fk_attachment_metadata_attach FOREIGN KEY (attachment_id) REFERENCES public.bb_attachment(id) ON DELETE CASCADE;


--
-- Name: bb_attachment fk_attachment_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_attachment
    ADD CONSTRAINT fk_attachment_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_cmt_disc_comment_activity fk_bb_cmt_disc_com_act_com; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_cmt_disc_comment_activity
    ADD CONSTRAINT fk_bb_cmt_disc_com_act_com FOREIGN KEY (comment_id) REFERENCES public.bb_comment(id);


--
-- Name: bb_cmt_disc_comment_activity fk_bb_cmt_disc_com_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_cmt_disc_comment_activity
    ADD CONSTRAINT fk_bb_cmt_disc_com_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_cmt_disc_activity(activity_id) ON DELETE CASCADE;


--
-- Name: bb_comment_parent fk_bb_com_par_comment_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_comment_parent
    ADD CONSTRAINT fk_bb_com_par_comment_id FOREIGN KEY (comment_id) REFERENCES public.bb_comment(id) ON DELETE CASCADE;


--
-- Name: bb_comment_parent fk_bb_com_par_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_comment_parent
    ADD CONSTRAINT fk_bb_com_par_parent_id FOREIGN KEY (parent_id) REFERENCES public.bb_comment(id);


--
-- Name: bb_comment fk_bb_comment_author; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_comment
    ADD CONSTRAINT fk_bb_comment_author FOREIGN KEY (author_id) REFERENCES public.stash_user(id);


--
-- Name: bb_comment fk_bb_comment_resolver; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_comment
    ADD CONSTRAINT fk_bb_comment_resolver FOREIGN KEY (resolver_id) REFERENCES public.stash_user(id);


--
-- Name: bb_comment fk_bb_comment_thread; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_comment
    ADD CONSTRAINT fk_bb_comment_thread FOREIGN KEY (thread_id) REFERENCES public.bb_comment_thread(id) ON DELETE CASCADE;


--
-- Name: bb_dep_commit fk_bb_dep_commit_dep; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_dep_commit
    ADD CONSTRAINT fk_bb_dep_commit_dep FOREIGN KEY (deployment_id) REFERENCES public.bb_deployment(id) ON DELETE CASCADE;


--
-- Name: bb_dep_commit fk_bb_dep_commit_repository; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_dep_commit
    ADD CONSTRAINT fk_bb_dep_commit_repository FOREIGN KEY (repository_id) REFERENCES public.repository(id);


--
-- Name: bb_deployment fk_bb_deployment_repository; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_deployment
    ADD CONSTRAINT fk_bb_deployment_repository FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_git_pr_cached_merge fk_bb_git_pr_cached_merge_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_git_pr_cached_merge
    ADD CONSTRAINT fk_bb_git_pr_cached_merge_id FOREIGN KEY (id) REFERENCES public.sta_pull_request(id) ON DELETE CASCADE;


--
-- Name: bb_git_pr_common_ancestor fk_bb_git_pr_cmn_ancstr_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_git_pr_common_ancestor
    ADD CONSTRAINT fk_bb_git_pr_cmn_ancstr_id FOREIGN KEY (id) REFERENCES public.sta_pull_request(id) ON DELETE CASCADE;


--
-- Name: bb_hook_script_config fk_bb_hook_script_cfg_script; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_hook_script_config
    ADD CONSTRAINT fk_bb_hook_script_cfg_script FOREIGN KEY (script_id) REFERENCES public.bb_hook_script(id) ON DELETE CASCADE;


--
-- Name: bb_hook_script_trigger fk_bb_hook_script_trgr_config; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_hook_script_trigger
    ADD CONSTRAINT fk_bb_hook_script_trgr_config FOREIGN KEY (config_id) REFERENCES public.bb_hook_script_config(id) ON DELETE CASCADE;


--
-- Name: bb_job fk_bb_job_initiator; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_job
    ADD CONSTRAINT fk_bb_job_initiator FOREIGN KEY (initiator_id) REFERENCES public.stash_user(id) ON DELETE SET NULL;


--
-- Name: bb_job_message fk_bb_job_msg_job; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_job_message
    ADD CONSTRAINT fk_bb_job_msg_job FOREIGN KEY (job_id) REFERENCES public.bb_job(id) ON DELETE CASCADE;


--
-- Name: bb_label_mapping fk_bb_label; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_label_mapping
    ADD CONSTRAINT fk_bb_label FOREIGN KEY (label_id) REFERENCES public.bb_label(id);


--
-- Name: bb_mesh_migration_queue fk_bb_mesh_migration_job; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_migration_queue
    ADD CONSTRAINT fk_bb_mesh_migration_job FOREIGN KEY (migration_job_id) REFERENCES public.bb_mesh_migration_job(id) ON DELETE CASCADE;


--
-- Name: bb_mesh_migration_queue fk_bb_mesh_migration_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_migration_queue
    ADD CONSTRAINT fk_bb_mesh_migration_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_mesh_node_key fk_bb_mesh_node_key_node; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_node_key
    ADD CONSTRAINT fk_bb_mesh_node_key_node FOREIGN KEY (node_id) REFERENCES public.bb_mesh_node(id) ON DELETE CASCADE;


--
-- Name: bb_mesh_partition_replica fk_bb_mesh_part_replica_node; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_partition_replica
    ADD CONSTRAINT fk_bb_mesh_part_replica_node FOREIGN KEY (node_id) REFERENCES public.bb_mesh_node(id) ON DELETE CASCADE;


--
-- Name: bb_mesh_repo_replica fk_bb_mesh_repo_replica_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_repo_replica
    ADD CONSTRAINT fk_bb_mesh_repo_replica_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_mesh_repo_replica fk_bb_mesh_repo_replica_rpl; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mesh_repo_replica
    ADD CONSTRAINT fk_bb_mesh_repo_replica_rpl FOREIGN KEY (replica_id) REFERENCES public.bb_mesh_partition_replica(id) ON DELETE CASCADE;


--
-- Name: bb_mirror_content_hash fk_bb_mirror_content_hash_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mirror_content_hash
    ADD CONSTRAINT fk_bb_mirror_content_hash_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_mirror_metadata_hash fk_bb_mirror_mdata_hash_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_mirror_metadata_hash
    ADD CONSTRAINT fk_bb_mirror_mdata_hash_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_pr_comment_activity fk_bb_pr_com_act_comment; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_comment_activity
    ADD CONSTRAINT fk_bb_pr_com_act_comment FOREIGN KEY (comment_id) REFERENCES public.bb_comment(id);


--
-- Name: bb_pr_comment_activity fk_bb_pr_com_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_comment_activity
    ADD CONSTRAINT fk_bb_pr_com_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_pr_activity(activity_id) ON DELETE CASCADE;


--
-- Name: bb_pr_commit fk_bb_pr_commit_pr; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_commit
    ADD CONSTRAINT fk_bb_pr_commit_pr FOREIGN KEY (pr_id) REFERENCES public.sta_pull_request(id) ON DELETE CASCADE;


--
-- Name: bb_pr_reviewer_upd_activity fk_bb_pr_reviewer_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_reviewer_upd_activity
    ADD CONSTRAINT fk_bb_pr_reviewer_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_pr_activity(activity_id) ON DELETE CASCADE;


--
-- Name: bb_pr_reviewer_added fk_bb_pr_reviewer_added_act; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_reviewer_added
    ADD CONSTRAINT fk_bb_pr_reviewer_added_act FOREIGN KEY (activity_id) REFERENCES public.bb_pr_reviewer_upd_activity(activity_id) ON DELETE CASCADE;


--
-- Name: bb_pr_reviewer_added fk_bb_pr_reviewer_added_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_reviewer_added
    ADD CONSTRAINT fk_bb_pr_reviewer_added_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: bb_pr_reviewer_removed fk_bb_pr_reviewer_removed_act; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_reviewer_removed
    ADD CONSTRAINT fk_bb_pr_reviewer_removed_act FOREIGN KEY (activity_id) REFERENCES public.bb_pr_reviewer_upd_activity(activity_id) ON DELETE CASCADE;


--
-- Name: bb_pr_reviewer_removed fk_bb_pr_reviewer_removed_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_pr_reviewer_removed
    ADD CONSTRAINT fk_bb_pr_reviewer_removed_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: bb_proj_merge_config fk_bb_proj_merge_config; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_proj_merge_config
    ADD CONSTRAINT fk_bb_proj_merge_config FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: bb_proj_merge_strategy fk_bb_proj_merge_strategy; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_proj_merge_strategy
    ADD CONSTRAINT fk_bb_proj_merge_strategy FOREIGN KEY (config_id) REFERENCES public.bb_proj_merge_config(id) ON DELETE CASCADE;


--
-- Name: bb_repo_merge_config fk_bb_repo_merge_config; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repo_merge_config
    ADD CONSTRAINT fk_bb_repo_merge_config FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_repo_merge_strategy fk_bb_repo_merge_strategy; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repo_merge_strategy
    ADD CONSTRAINT fk_bb_repo_merge_strategy FOREIGN KEY (config_id) REFERENCES public.bb_repo_merge_config(id) ON DELETE CASCADE;


--
-- Name: bb_repo_size fk_bb_repo_size_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repo_size
    ADD CONSTRAINT fk_bb_repo_size_repo FOREIGN KEY (repo_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_reviewer_group_user fk_bb_reviewer_group; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_reviewer_group_user
    ADD CONSTRAINT fk_bb_reviewer_group FOREIGN KEY (group_id) REFERENCES public.bb_reviewer_group(id) ON DELETE CASCADE;


--
-- Name: bb_reviewer_group_user fk_bb_reviewer_group_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_reviewer_group_user
    ADD CONSTRAINT fk_bb_reviewer_group_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id) ON DELETE CASCADE;


--
-- Name: bb_rl_reject_counter fk_bb_rl_rejected_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_rl_reject_counter
    ADD CONSTRAINT fk_bb_rl_rejected_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id) ON DELETE CASCADE;


--
-- Name: bb_rl_user_settings fk_bb_rl_user_settings_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_rl_user_settings
    ADD CONSTRAINT fk_bb_rl_user_settings_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id) ON DELETE CASCADE;


--
-- Name: bb_scm_merge_strategy fk_bb_scm_merge_strategy; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_scm_merge_strategy
    ADD CONSTRAINT fk_bb_scm_merge_strategy FOREIGN KEY (config_id) REFERENCES public.bb_scm_merge_config(id) ON DELETE CASCADE;


--
-- Name: bb_settings_restriction fk_bb_settings_restriction_pid; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_settings_restriction
    ADD CONSTRAINT fk_bb_settings_restriction_pid FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: bb_ss_exempt_repo fk_bb_ss_exempt_repo_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_ss_exempt_repo
    ADD CONSTRAINT fk_bb_ss_exempt_repo_id FOREIGN KEY (repo_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: bb_suggestion_group fk_bb_sugg_grp_comment; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_suggestion_group
    ADD CONSTRAINT fk_bb_sugg_grp_comment FOREIGN KEY (comment_id) REFERENCES public.bb_comment(id) ON DELETE CASCADE;


--
-- Name: bb_thread_root_comment fk_bb_thr_root_com_comment_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_thread_root_comment
    ADD CONSTRAINT fk_bb_thr_root_com_comment_id FOREIGN KEY (comment_id) REFERENCES public.bb_comment(id);


--
-- Name: bb_thread_root_comment fk_bb_thr_root_com_thread_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_thread_root_comment
    ADD CONSTRAINT fk_bb_thr_root_com_thread_id FOREIGN KEY (thread_id) REFERENCES public.bb_comment_thread(id) ON DELETE CASCADE;


--
-- Name: bb_user_dark_feature fk_bb_user_dark_feature_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_user_dark_feature
    ADD CONSTRAINT fk_bb_user_dark_feature_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: bb_build_status fk_bbs_build_status_repository; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_build_status
    ADD CONSTRAINT fk_bbs_build_status_repository FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: cs_attribute fk_cs_attribute_changeset; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cs_attribute
    ADD CONSTRAINT fk_cs_attribute_changeset FOREIGN KEY (cs_id) REFERENCES public.changeset(id);


--
-- Name: cs_indexer_state fk_cs_indexer_state_repository; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cs_indexer_state
    ADD CONSTRAINT fk_cs_indexer_state_repository FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: cwd_directory_attribute fk_directory_attribute; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_directory_attribute
    ADD CONSTRAINT fk_directory_attribute FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: cwd_group fk_directory_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group
    ADD CONSTRAINT fk_directory_id FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: cwd_directory_operation fk_directory_operation; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_directory_operation
    ADD CONSTRAINT fk_directory_operation FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: sta_global_permission fk_global_permission_type; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_global_permission
    ADD CONSTRAINT fk_global_permission_type FOREIGN KEY (perm_id) REFERENCES public.sta_permission_type(perm_id);


--
-- Name: sta_global_permission fk_global_permission_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_global_permission
    ADD CONSTRAINT fk_global_permission_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: cwd_granted_perm fk_granted_perm_dir_mapping; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_granted_perm
    ADD CONSTRAINT fk_granted_perm_dir_mapping FOREIGN KEY (app_dir_mapping_id) REFERENCES public.cwd_app_dir_mapping(id);


--
-- Name: cwd_group_attribute fk_group_attr_dir_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_attribute
    ADD CONSTRAINT fk_group_attr_dir_id FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: cwd_group_attribute fk_group_attr_id_group_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_attribute
    ADD CONSTRAINT fk_group_attr_id_group_id FOREIGN KEY (group_id) REFERENCES public.cwd_group(id);


--
-- Name: cwd_group_admin_group fk_group_target_group; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_admin_group
    ADD CONSTRAINT fk_group_target_group FOREIGN KEY (target_group_id) REFERENCES public.cwd_group(id) ON DELETE CASCADE;


--
-- Name: cwd_app_licensed_user fk_licensed_user_dir_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_licensed_user
    ADD CONSTRAINT fk_licensed_user_dir_id FOREIGN KEY (directory_id) REFERENCES public.cwd_app_licensing_dir_info(id);


--
-- Name: cwd_app_licensing_dir_info fk_licensing_dir_dir_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_licensing_dir_info
    ADD CONSTRAINT fk_licensing_dir_dir_id FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: cwd_app_licensing_dir_info fk_licensing_dir_summary_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_app_licensing_dir_info
    ADD CONSTRAINT fk_licensing_dir_summary_id FOREIGN KEY (licensing_summary_id) REFERENCES public.cwd_app_licensing(id);


--
-- Name: cwd_membership fk_membership_dir; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_membership
    ADD CONSTRAINT fk_membership_dir FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: bb_project_alias fk_project_alias_project; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_project_alias
    ADD CONSTRAINT fk_project_alias_project FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: sta_project_permission fk_project_permission_project; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_project_permission
    ADD CONSTRAINT fk_project_permission_project FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: sta_project_permission fk_project_permission_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_project_permission
    ADD CONSTRAINT fk_project_permission_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: sta_project_permission fk_project_permission_weight; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_project_permission
    ADD CONSTRAINT fk_project_permission_weight FOREIGN KEY (perm_id) REFERENCES public.sta_permission_type(perm_id);


--
-- Name: sta_remember_me_token fk_remember_me_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_remember_me_token
    ADD CONSTRAINT fk_remember_me_user_id FOREIGN KEY (user_id) REFERENCES public.stash_user(id) ON DELETE CASCADE;


--
-- Name: cs_repo_membership fk_repo_membership_changeset; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cs_repo_membership
    ADD CONSTRAINT fk_repo_membership_changeset FOREIGN KEY (cs_id) REFERENCES public.changeset(id);


--
-- Name: cs_repo_membership fk_repo_membership_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cs_repo_membership
    ADD CONSTRAINT fk_repo_membership_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: sta_repo_permission fk_repo_permission_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_permission
    ADD CONSTRAINT fk_repo_permission_repo FOREIGN KEY (repo_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: sta_repo_permission fk_repo_permission_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_permission
    ADD CONSTRAINT fk_repo_permission_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: sta_repo_permission fk_repo_permission_weight; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_permission
    ADD CONSTRAINT fk_repo_permission_weight FOREIGN KEY (perm_id) REFERENCES public.sta_permission_type(perm_id);


--
-- Name: repository_access fk_repository_access_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.repository_access
    ADD CONSTRAINT fk_repository_access_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id);


--
-- Name: repository_access fk_repository_access_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.repository_access
    ADD CONSTRAINT fk_repository_access_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: bb_repository_alias fk_repository_alias_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.bb_repository_alias
    ADD CONSTRAINT fk_repository_alias_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: repository fk_repository_project; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT fk_repository_project FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- Name: repository fk_repository_store_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT fk_repository_store_id FOREIGN KEY (store_id) REFERENCES public.bb_data_store(id);


--
-- Name: sta_activity fk_sta_activity_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_activity
    ADD CONSTRAINT fk_sta_activity_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: sta_cmt_disc_activity fk_sta_cmt_disc_act_disc; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_disc_activity
    ADD CONSTRAINT fk_sta_cmt_disc_act_disc FOREIGN KEY (discussion_id) REFERENCES public.sta_cmt_discussion(id);


--
-- Name: sta_cmt_disc_activity fk_sta_cmt_disc_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_disc_activity
    ADD CONSTRAINT fk_sta_cmt_disc_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_repo_activity(activity_id) ON DELETE CASCADE;


--
-- Name: sta_cmt_disc_participant fk_sta_cmt_disc_part_disc; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_disc_participant
    ADD CONSTRAINT fk_sta_cmt_disc_part_disc FOREIGN KEY (discussion_id) REFERENCES public.sta_cmt_discussion(id) ON DELETE CASCADE;


--
-- Name: sta_cmt_disc_participant fk_sta_cmt_disc_part_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_disc_participant
    ADD CONSTRAINT fk_sta_cmt_disc_part_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: sta_cmt_discussion fk_sta_cmt_disc_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_cmt_discussion
    ADD CONSTRAINT fk_sta_cmt_disc_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: sta_drift_request fk_sta_drift_request_pr; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_drift_request
    ADD CONSTRAINT fk_sta_drift_request_pr FOREIGN KEY (pr_id) REFERENCES public.sta_pull_request(id) ON DELETE CASCADE;


--
-- Name: sta_normal_project fk_sta_normal_project_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_normal_project
    ADD CONSTRAINT fk_sta_normal_project_id FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: sta_normal_user fk_sta_normal_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_normal_user
    ADD CONSTRAINT fk_sta_normal_user_id FOREIGN KEY (user_id) REFERENCES public.stash_user(id) ON DELETE CASCADE;


--
-- Name: sta_personal_project fk_sta_personal_project_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_personal_project
    ADD CONSTRAINT fk_sta_personal_project_id FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: sta_personal_project fk_sta_personal_project_owner; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_personal_project
    ADD CONSTRAINT fk_sta_personal_project_owner FOREIGN KEY (owner_id) REFERENCES public.stash_user(id);


--
-- Name: sta_pr_activity fk_sta_pr_activity_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_activity
    ADD CONSTRAINT fk_sta_pr_activity_id FOREIGN KEY (activity_id) REFERENCES public.sta_activity(id) ON DELETE CASCADE;


--
-- Name: sta_pr_activity fk_sta_pr_activity_pr; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_activity
    ADD CONSTRAINT fk_sta_pr_activity_pr FOREIGN KEY (pr_id) REFERENCES public.sta_pull_request(id);


--
-- Name: sta_pr_merge_activity fk_sta_pr_mrg_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_merge_activity
    ADD CONSTRAINT fk_sta_pr_mrg_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_pr_activity(activity_id) ON DELETE CASCADE;


--
-- Name: sta_pr_participant fk_sta_pr_participant_pr; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_participant
    ADD CONSTRAINT fk_sta_pr_participant_pr FOREIGN KEY (pr_id) REFERENCES public.sta_pull_request(id) ON DELETE CASCADE;


--
-- Name: sta_pr_participant fk_sta_pr_participant_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_participant
    ADD CONSTRAINT fk_sta_pr_participant_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: sta_pr_rescope_activity fk_sta_pr_rescope_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_activity
    ADD CONSTRAINT fk_sta_pr_rescope_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_pr_activity(activity_id);


--
-- Name: sta_pr_rescope_request_change fk_sta_pr_rescope_ch_req_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_request_change
    ADD CONSTRAINT fk_sta_pr_rescope_ch_req_id FOREIGN KEY (request_id) REFERENCES public.sta_pr_rescope_request(id) ON DELETE CASCADE;


--
-- Name: sta_pr_rescope_commit fk_sta_pr_rescope_cmmt_act; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_commit
    ADD CONSTRAINT fk_sta_pr_rescope_cmmt_act FOREIGN KEY (activity_id) REFERENCES public.sta_pr_rescope_activity(activity_id) ON DELETE CASCADE;


--
-- Name: sta_pr_rescope_request fk_sta_pr_rescope_req_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_request
    ADD CONSTRAINT fk_sta_pr_rescope_req_repo FOREIGN KEY (repo_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: sta_pr_rescope_request fk_sta_pr_rescope_req_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pr_rescope_request
    ADD CONSTRAINT fk_sta_pr_rescope_req_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id) ON DELETE CASCADE;


--
-- Name: sta_pull_request fk_sta_pull_request_from_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pull_request
    ADD CONSTRAINT fk_sta_pull_request_from_repo FOREIGN KEY (from_repository_id) REFERENCES public.repository(id);


--
-- Name: sta_pull_request fk_sta_pull_request_to_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_pull_request
    ADD CONSTRAINT fk_sta_pull_request_to_repo FOREIGN KEY (to_repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: sta_repo_activity fk_sta_repo_activity_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_activity
    ADD CONSTRAINT fk_sta_repo_activity_id FOREIGN KEY (activity_id) REFERENCES public.sta_activity(id) ON DELETE CASCADE;


--
-- Name: sta_repo_activity fk_sta_repo_activity_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_activity
    ADD CONSTRAINT fk_sta_repo_activity_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id);


--
-- Name: sta_repo_created_activity fk_sta_repo_created_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_created_activity
    ADD CONSTRAINT fk_sta_repo_created_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_repo_activity(activity_id) ON DELETE CASCADE;


--
-- Name: sta_repo_hook fk_sta_repo_hook_lob; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_hook
    ADD CONSTRAINT fk_sta_repo_hook_lob FOREIGN KEY (lob_id) REFERENCES public.sta_shared_lob(id);


--
-- Name: sta_repo_hook fk_sta_repo_hook_proj; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_hook
    ADD CONSTRAINT fk_sta_repo_hook_proj FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: sta_repo_hook fk_sta_repo_hook_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_hook
    ADD CONSTRAINT fk_sta_repo_hook_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: sta_repo_origin fk_sta_repo_origin_origin_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_origin
    ADD CONSTRAINT fk_sta_repo_origin_origin_id FOREIGN KEY (origin_id) REFERENCES public.repository(id);


--
-- Name: sta_repo_origin fk_sta_repo_origin_repo_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_origin
    ADD CONSTRAINT fk_sta_repo_origin_repo_id FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: sta_repo_push_activity fk_sta_repo_push_activity_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_push_activity
    ADD CONSTRAINT fk_sta_repo_push_activity_id FOREIGN KEY (activity_id) REFERENCES public.sta_repo_activity(activity_id) ON DELETE CASCADE;


--
-- Name: sta_repo_push_ref fk_sta_repo_push_ref_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_push_ref
    ADD CONSTRAINT fk_sta_repo_push_ref_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_repo_push_activity(activity_id) ON DELETE CASCADE;


--
-- Name: sta_repository_scoped_id fk_sta_repo_scoped_id_repo; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repository_scoped_id
    ADD CONSTRAINT fk_sta_repo_scoped_id_repo FOREIGN KEY (repository_id) REFERENCES public.repository(id) ON DELETE CASCADE;


--
-- Name: sta_repo_updated_activity fk_sta_repo_updated_act_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_repo_updated_activity
    ADD CONSTRAINT fk_sta_repo_updated_act_id FOREIGN KEY (activity_id) REFERENCES public.sta_repo_activity(activity_id) ON DELETE CASCADE;


--
-- Name: sta_service_user fk_sta_service_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_service_user
    ADD CONSTRAINT fk_sta_service_user_id FOREIGN KEY (user_id) REFERENCES public.stash_user(id) ON DELETE CASCADE;


--
-- Name: sta_user_settings fk_sta_user_settings_lob; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_user_settings
    ADD CONSTRAINT fk_sta_user_settings_lob FOREIGN KEY (lob_id) REFERENCES public.sta_shared_lob(id);


--
-- Name: sta_user_settings fk_sta_user_settings_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_user_settings
    ADD CONSTRAINT fk_sta_user_settings_user FOREIGN KEY (id) REFERENCES public.stash_user(id);


--
-- Name: sta_watcher fk_sta_watcher_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.sta_watcher
    ADD CONSTRAINT fk_sta_watcher_user FOREIGN KEY (user_id) REFERENCES public.stash_user(id);


--
-- Name: trusted_app_restriction fk_trusted_app; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.trusted_app_restriction
    ADD CONSTRAINT fk_trusted_app FOREIGN KEY (trusted_app_id) REFERENCES public.trusted_app(id) ON DELETE CASCADE;


--
-- Name: cwd_user_attribute fk_user_attr_dir_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_user_attribute
    ADD CONSTRAINT fk_user_attr_dir_id FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: cwd_user_attribute fk_user_attribute_id_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_user_attribute
    ADD CONSTRAINT fk_user_attribute_id_user_id FOREIGN KEY (user_id) REFERENCES public.cwd_user(id);


--
-- Name: cwd_user_credential_record fk_user_cred_user; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_user_credential_record
    ADD CONSTRAINT fk_user_cred_user FOREIGN KEY (user_id) REFERENCES public.cwd_user(id);


--
-- Name: cwd_user fk_user_dir_id; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_user
    ADD CONSTRAINT fk_user_dir_id FOREIGN KEY (directory_id) REFERENCES public.cwd_directory(id);


--
-- Name: cwd_group_admin_user fk_user_target_group; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_group_admin_user
    ADD CONSTRAINT fk_user_target_group FOREIGN KEY (target_group_id) REFERENCES public.cwd_group(id) ON DELETE CASCADE;


--
-- Name: cwd_webhook fk_webhook_app; Type: FK CONSTRAINT; Schema: public; Owner: bitbucket
--

ALTER TABLE ONLY public.cwd_webhook
    ADD CONSTRAINT fk_webhook_app FOREIGN KEY (application_id) REFERENCES public.cwd_application(id);


--
-- PostgreSQL database dump complete
--

