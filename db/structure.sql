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

--
-- Name: room_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.room_type AS ENUM (
    'open',
    'closed',
    'direct'
);


--
-- Name: update_rooms_last_message_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_rooms_last_message_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          UPDATE rooms SET last_message_at = new.created_at WHERE id = new.room_id;
          RETURN new;
        END
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id bigint NOT NULL,
    room_message_id bigint,
    user_id bigint NOT NULL,
    file character varying NOT NULL,
    content_type character varying NOT NULL,
    file_size bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;


--
-- Name: room_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_messages (
    id bigint NOT NULL,
    room_id bigint,
    user_id bigint,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    discarded_at timestamp without time zone
);


--
-- Name: room_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.room_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: room_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.room_messages_id_seq OWNED BY public.room_messages.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint NOT NULL,
    discarded_at timestamp without time zone,
    last_message_at timestamp without time zone,
    description text,
    type public.room_type NOT NULL
);


--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: rooms_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms_users (
    id bigint NOT NULL,
    room_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rooms_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rooms_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rooms_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rooms_users_id_seq OWNED BY public.rooms_users.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    authentication_token character varying,
    refresh_token character varying,
    rooms_activity jsonb DEFAULT '{}'::jsonb NOT NULL,
    avatar character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: room_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_messages ALTER COLUMN id SET DEFAULT nextval('public.room_messages_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: rooms_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms_users ALTER COLUMN id SET DEFAULT nextval('public.rooms_users_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: room_messages room_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_messages
    ADD CONSTRAINT room_messages_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: rooms_users rooms_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms_users
    ADD CONSTRAINT rooms_users_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_attachments_on_room_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_room_message_id ON public.attachments USING btree (room_message_id);


--
-- Name: index_attachments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_user_id ON public.attachments USING btree (user_id);


--
-- Name: index_room_messages_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_room_messages_on_discarded_at ON public.room_messages USING btree (discarded_at);


--
-- Name: index_room_messages_on_room_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_room_messages_on_room_id ON public.room_messages USING btree (room_id);


--
-- Name: index_room_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_room_messages_on_user_id ON public.room_messages USING btree (user_id);


--
-- Name: index_rooms_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rooms_on_discarded_at ON public.rooms USING btree (discarded_at);


--
-- Name: index_rooms_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_rooms_on_name ON public.rooms USING btree (name);


--
-- Name: index_rooms_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rooms_on_user_id ON public.rooms USING btree (user_id);


--
-- Name: index_rooms_users_on_room_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rooms_users_on_room_id ON public.rooms_users USING btree (room_id);


--
-- Name: index_rooms_users_on_room_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_rooms_users_on_room_id_and_user_id ON public.rooms_users USING btree (room_id, user_id);


--
-- Name: index_rooms_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rooms_users_on_user_id ON public.rooms_users USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: room_messages update_rooms_last_message_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_rooms_last_message_at_trigger AFTER INSERT ON public.room_messages FOR EACH ROW EXECUTE PROCEDURE public.update_rooms_last_message_at();


--
-- Name: attachments fk_rails_5650a5e7db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT fk_rails_5650a5e7db FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: attachments fk_rails_582448a1e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT fk_rails_582448a1e3 FOREIGN KEY (room_message_id) REFERENCES public.room_messages(id);


--
-- Name: room_messages fk_rails_76bc7b974e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_messages
    ADD CONSTRAINT fk_rails_76bc7b974e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: room_messages fk_rails_8ed44f6e34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_messages
    ADD CONSTRAINT fk_rails_8ed44f6e34 FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: rooms fk_rails_a63cab0c67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT fk_rails_a63cab0c67 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190409083420'),
('20190409090530'),
('20190409114125'),
('20190409114133'),
('20190528060135'),
('20190617132548'),
('20190619071150'),
('20190619084919'),
('20190619092829'),
('20190628104921'),
('20190628154929'),
('20190705070039'),
('20190705085446'),
('20190711085013'),
('20190722151153'),
('20190722160221');


