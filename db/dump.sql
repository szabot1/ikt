--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.2 (Debian 16.2-1.pgdg120+2)

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
-- Name: order_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status AS ENUM (
    'validating',
    'payment_pending',
    'payment_failed',
    'payment_succeeded',
    'fulfilled',
    'refunded',
    'cancelled'
);


ALTER TYPE public.order_status OWNER TO postgres;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'user',
    'support',
    'admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: offer_stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offer_stock (
    id text NOT NULL,
    offer_id text NOT NULL,
    item text NOT NULL,
    is_locked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.offer_stock OWNER TO postgres;

--
-- Name: take_stock(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.take_stock(_offer_id text) RETURNS SETOF public.offer_stock
    LANGUAGE plpgsql
    AS $$
declare
  v_stock_record offer_stock%rowtype;
begin
    for v_stock_record in
        select * from offer_stock where offer_id = _offer_id and is_locked = false order by created_at asc limit 1
    loop
        update offer_stock set is_locked = true where id = v_stock_record.id;
        return next v_stock_record;
    end loop;
    return;
end;
$$;


ALTER FUNCTION public.take_stock(_offer_id text) OWNER TO postgres;

--
-- Name: email_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_tokens (
    email text NOT NULL,
    token text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.email_tokens OWNER TO postgres;

--
-- Name: game_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_images (
    id text NOT NULL,
    game_id text NOT NULL,
    image_url text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.game_images OWNER TO postgres;

--
-- Name: game_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_tags (
    id text NOT NULL,
    game_id text NOT NULL,
    tag_id text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.game_tags OWNER TO postgres;

--
-- Name: games; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games (
    id text NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_featured boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.games OWNER TO postgres;

--
-- Name: offer_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offer_types (
    id text NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    claim_instructions text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.offer_types OWNER TO postgres;

--
-- Name: offers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offers (
    id text NOT NULL,
    game_id text NOT NULL,
    seller_id text NOT NULL,
    price integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    type text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.offers OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id text NOT NULL,
    user_id text NOT NULL,
    game_id text NOT NULL,
    offer_id text NOT NULL,
    stripe_payment_intent_id text NOT NULL,
    status public.order_status DEFAULT 'validating'::public.order_status NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: sellers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sellers (
    id text NOT NULL,
    user_id text NOT NULL,
    slug text NOT NULL,
    display_name text NOT NULL,
    image_url text NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    is_closed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.sellers OWNER TO postgres;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id text NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: user_experience; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_experience (
    user_id text NOT NULL,
    experience integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_experience OWNER TO postgres;

--
-- Name: user_refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_refresh_tokens (
    token text NOT NULL,
    user_id text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.user_refresh_tokens OWNER TO postgres;

--
-- Name: user_social; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_social (
    user_id text NOT NULL,
    discord text,
    steam text,
    ubisoft text,
    epic text,
    origin text,
    battlenet text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.user_social OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id text NOT NULL,
    email text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    stripe_customer_id text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: email_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: game_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('e5dddqtqw1l2qf63ovcj6bng', 'fcfmf9p8szc7bvtirbv6mspn', 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg?t=1627994920', '2024-01-31 10:12:36.332956', '2024-01-31 10:12:36.332956');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('y7vualewakck8ckc9oz1t11s', 'fcfmf9p8szc7bvtirbv6mspn', 'https://cdn.akamai.steamstatic.com/steam/apps/730/ss_d830cfd0550fbb64d80e803e93c929c3abb02056.1920x1080.jpg?t=1698860631', '2024-02-05 12:35:33.252347', '2024-02-05 12:35:33.252347');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('kxmsjak976a6mlvqj7naw48u', 'fcfmf9p8szc7bvtirbv6mspn', 'https://cdn.akamai.steamstatic.com/steam/apps/730/ss_808cdd373d78c3cf3a78e7026ebb1a15895e0670.1920x1080.jpg?t=1698860631', '2024-02-05 12:35:52.370513', '2024-02-05 12:35:52.370513');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('f3tixvdgi7c3b2qu2iu734dd', 'ie4j51aeog2tsomlqftc214j', 'https://cdn.akamai.steamstatic.com/steam/apps/10/header.jpg?t=1666823513', '2024-02-29 09:51:56.341279', '2024-02-29 09:51:56.341279');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('h67r9kq2ham6yhzjl80caazy', 'ie4j51aeog2tsomlqftc214j', 'https://cdn.akamai.steamstatic.com/steam/apps/10/0000000132.1920x1080.jpg?t=1666823513', '2024-02-29 09:51:56.389442', '2024-02-29 09:51:56.389442');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('miepr5osg3lw9lj2w96lz8nl', 'ie4j51aeog2tsomlqftc214j', 'https://cdn.akamai.steamstatic.com/steam/apps/10/0000000133.1920x1080.jpg?t=1666823513', '2024-02-29 09:51:56.440213', '2024-02-29 09:51:56.440213');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('bom22ftelei2tfjccoqnvk9r', 'avumbyeptd3g6mldqmw1jo7d', 'https://cdn.akamai.steamstatic.com/steam/apps/1824450/header.jpg?t=1645472910', '2024-02-29 09:51:56.541877', '2024-02-29 09:51:56.541877');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('mg643o8q6p4l5kz8r49ik6oo', 'avumbyeptd3g6mldqmw1jo7d', 'https://cdn.akamai.steamstatic.com/steam/apps/1824450/ss_681efff751fa103d902b0bf9d17d5235d0aaf813.1920x1080.jpg?t=1645472910', '2024-02-29 09:51:56.59184', '2024-02-29 09:51:56.59184');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('h8c075142ckwl7p1o7wi3ffr', 'avumbyeptd3g6mldqmw1jo7d', 'https://cdn.akamai.steamstatic.com/steam/apps/1824450/ss_4fb0d1e225e686e5d06fcf758df14f9179dfd950.1920x1080.jpg?t=1645472910', '2024-02-29 09:51:56.641916', '2024-02-29 09:51:56.641916');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('svlhbsffy6be3k9z5s7h59px', 'cea9mnvg80esld1sa1r72zf9', 'https://cdn.akamai.steamstatic.com/steam/apps/70/header.jpg?t=1700269108', '2024-02-29 09:51:56.740395', '2024-02-29 09:51:56.740395');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('s32yfo5vurfs42h8uhoqqm70', 'cea9mnvg80esld1sa1r72zf9', 'https://cdn.akamai.steamstatic.com/steam/apps/70/0000002354.1920x1080.jpg?t=1700269108', '2024-02-29 09:51:56.788103', '2024-02-29 09:51:56.788103');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('v6dvg98wsi7izv7wcent3es4', 'cea9mnvg80esld1sa1r72zf9', 'https://cdn.akamai.steamstatic.com/steam/apps/70/0000002343.1920x1080.jpg?t=1700269108', '2024-02-29 09:51:56.838999', '2024-02-29 09:51:56.838999');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('wvmfkim748yqof9n0l2169ge', 'lma09e4m027ir3xn1spekrzy', 'https://cdn.akamai.steamstatic.com/steam/apps/400/header.jpg?t=1699003695', '2024-02-29 09:51:56.939121', '2024-02-29 09:51:56.939121');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('qcfbwztjl7z6fkvcnblvm05i', 'lma09e4m027ir3xn1spekrzy', 'https://cdn.akamai.steamstatic.com/steam/apps/400/0000002582.1920x1080.jpg?t=1699003695', '2024-02-29 09:51:56.990023', '2024-02-29 09:51:56.990023');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('l2gbmabj9xne4tcc4vlmat25', 'lma09e4m027ir3xn1spekrzy', 'https://cdn.akamai.steamstatic.com/steam/apps/400/0000002583.1920x1080.jpg?t=1699003695', '2024-02-29 09:51:57.039575', '2024-02-29 09:51:57.039575');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('j2z0zgcp9ozj4qaam8viu0g0', 'yj7vjizwjcwp2vye4x5bhyni', 'https://cdn.akamai.steamstatic.com/steam/apps/440/header.jpg?t=1695767057', '2024-02-29 09:51:57.136441', '2024-02-29 09:51:57.136441');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('pwmw13vtdonet1ne0yc1vhv6', 'yj7vjizwjcwp2vye4x5bhyni', 'https://cdn.akamai.steamstatic.com/steam/apps/440/ss_ea21f7bbf4f79bada4554df5108d04b6889d3453.1920x1080.jpg?t=1695767057', '2024-02-29 09:51:57.189269', '2024-02-29 09:51:57.189269');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('i40sjo0dstxqa1tzu3tik359', 'yj7vjizwjcwp2vye4x5bhyni', 'https://cdn.akamai.steamstatic.com/steam/apps/440/ss_e3aedb2ab36bba8cfe611b1e0eaa807e4bb2d742.1920x1080.jpg?t=1695767057', '2024-02-29 09:51:57.234979', '2024-02-29 09:51:57.234979');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('xnqw5kut0e1rixom44tmjdjr', 'eoqrc7fxi5csiyiwbe1qfkcd', 'https://cdn.akamai.steamstatic.com/steam/apps/550/header.jpg?t=1675801903', '2024-02-29 09:51:57.348299', '2024-02-29 09:51:57.348299');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('apnwzog7rnj078xn6iuruyr1', 'eoqrc7fxi5csiyiwbe1qfkcd', 'https://cdn.akamai.steamstatic.com/steam/apps/550/ss_2eae29fbdfe8e5e8999b96d8bb28c5db70507968.1920x1080.jpg?t=1675801903', '2024-02-29 09:51:57.398884', '2024-02-29 09:51:57.398884');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('cft8412vzvju8sn4dt1wnbmm', 'eoqrc7fxi5csiyiwbe1qfkcd', 'https://cdn.akamai.steamstatic.com/steam/apps/550/ss_29b3b4f2a3994c889f6fc12e0781d9d4726ef33f.1920x1080.jpg?t=1675801903', '2024-02-29 09:51:57.448183', '2024-02-29 09:51:57.448183');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('y0n85yv91r60azs9892i9ze7', 'smln9amlrmrfws6ih222fl96', 'https://cdn.akamai.steamstatic.com/steam/apps/570/header.jpg?t=1707435904', '2024-02-29 09:51:57.544748', '2024-02-29 09:51:57.544748');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('w5djgvzryy4b6wyq4lw3po21', 'smln9amlrmrfws6ih222fl96', 'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_ad8eee787704745ccdecdfde3a5cd2733704898d.1920x1080.jpg?t=1707435904', '2024-02-29 09:51:57.590081', '2024-02-29 09:51:57.590081');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ui2ly7pyuaecisd2kzwvra5k', 'smln9amlrmrfws6ih222fl96', 'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_7ab506679d42bfc0c0e40639887176494e0466d9.1920x1080.jpg?t=1707435904', '2024-02-29 09:51:57.638106', '2024-02-29 09:51:57.638106');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('iyn8z20z2i1w7vltecwu52lh', 'fd391rxpdxyqzmhefbb6fbe2', 'https://cdn.akamai.steamstatic.com/steam/apps/620/header.jpg?t=1698805825', '2024-02-29 09:51:57.737803', '2024-02-29 09:51:57.737803');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('gwop23evjlv30a6asjelfcn5', 'fd391rxpdxyqzmhefbb6fbe2', 'https://cdn.akamai.steamstatic.com/steam/apps/620/ss_f3f6787d74739d3b2ec8a484b5c994b3d31ef325.1920x1080.jpg?t=1698805825', '2024-02-29 09:51:57.787231', '2024-02-29 09:51:57.787231');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('l51jn5836hjcbk1w3k3121b4', 'fd391rxpdxyqzmhefbb6fbe2', 'https://cdn.akamai.steamstatic.com/steam/apps/620/ss_6a4f5afdaa98402de9cf0b59fed27bab3256a6f4.1920x1080.jpg?t=1698805825', '2024-02-29 09:51:57.837327', '2024-02-29 09:51:57.837327');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('nsyvpbvkf6bsyyhtjnb10t2o', 'tg0q3e6d7dxclqm7uv3bpucv', 'https://cdn.akamai.steamstatic.com/steam/apps/49520/header.jpg?t=1693524237', '2024-02-29 09:51:57.935433', '2024-02-29 09:51:57.935433');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('jgv9qttcpu59d7zhsjoxvz4y', 'tg0q3e6d7dxclqm7uv3bpucv', 'https://cdn.akamai.steamstatic.com/steam/apps/49520/ss_6734eaa79dcd0fe53971fbd50d20b5d0d45f4809.1920x1080.jpg?t=1693524237', '2024-02-29 09:51:57.989147', '2024-02-29 09:51:57.989147');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('v73mz7isuf2p0zu3pbcugjkh', 'tg0q3e6d7dxclqm7uv3bpucv', 'https://cdn.akamai.steamstatic.com/steam/apps/49520/ss_2f27a18562fbf4a91943c3968b35db5ac1caf5ad.1920x1080.jpg?t=1693524237', '2024-02-29 09:51:58.037726', '2024-02-29 09:51:58.037726');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('jgc01fq4w2nu581szsriwgcc', 'hsxmrupvht6c1d5r8wd3p02c', 'https://cdn.akamai.steamstatic.com/steam/apps/96000/header.jpg?t=1631292999', '2024-02-29 09:51:58.147298', '2024-02-29 09:51:58.147298');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('bygjhecw8hmoxgihe5nymxud', 'hsxmrupvht6c1d5r8wd3p02c', 'https://cdn.akamai.steamstatic.com/steam/apps/96000/ss_5b8111d63971d348891f3e7b7c8662951345a609.1920x1080.jpg?t=1631292999', '2024-02-29 09:51:58.195056', '2024-02-29 09:51:58.195056');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ej64u8ioz3gzi34cjwv9gttn', 'hsxmrupvht6c1d5r8wd3p02c', 'https://cdn.akamai.steamstatic.com/steam/apps/96000/ss_1188a6cf2912c14425b0a75678461f7952d2bc98.1920x1080.jpg?t=1631292999', '2024-02-29 09:51:58.244336', '2024-02-29 09:51:58.244336');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('wshaf7eqp0t537nkuqn605qc', 'j7yghgfukup7y3svl76jhw1w', 'https://cdn.akamai.steamstatic.com/steam/apps/105600/header.jpg?t=1666290860', '2024-02-29 09:51:58.340389', '2024-02-29 09:51:58.340389');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('txrwgid2elaa0pgp3oif5h7q', 'j7yghgfukup7y3svl76jhw1w', 'https://cdn.akamai.steamstatic.com/steam/apps/105600/ss_8c03886f214d2108cafca13845533eaa3d87d83f.1920x1080.jpg?t=1666290860', '2024-02-29 09:51:58.389944', '2024-02-29 09:51:58.389944');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('hlxmav49c0slvlbe00g4vpsb', 'j7yghgfukup7y3svl76jhw1w', 'https://cdn.akamai.steamstatic.com/steam/apps/105600/ss_ae168a00ab08104ba266dc30232654d4b3c919e5.1920x1080.jpg?t=1666290860', '2024-02-29 09:51:58.439001', '2024-02-29 09:51:58.439001');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('kul8esisjzm0z45dlzvwso9m', 'tg6zemcrpnhueeb22he4h2ge', 'https://cdn.akamai.steamstatic.com/steam/apps/107410/header.jpg?t=1703201086', '2024-02-29 09:51:58.53946', '2024-02-29 09:51:58.53946');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('hzyrdmldeooh9geh58axb173', 'tg6zemcrpnhueeb22he4h2ge', 'https://cdn.akamai.steamstatic.com/steam/apps/107410/ss_e9220742c6b786efc9145c58ce7b276af891e9d5.1920x1080.jpg?t=1703201086', '2024-02-29 09:51:58.585474', '2024-02-29 09:51:58.585474');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('tnu18s3v5gn4du631wg6vii3', 'tg6zemcrpnhueeb22he4h2ge', 'https://cdn.akamai.steamstatic.com/steam/apps/107410/ss_089dfd05121614ca3a887f49e89c14fa210847ac.1920x1080.jpg?t=1703201086', '2024-02-29 09:51:58.634573', '2024-02-29 09:51:58.634573');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('jm60xqju96zcaaxce5bk52eq', 'wsr5voep92cdcocq2b9ywaiv', 'https://cdn.akamai.steamstatic.com/steam/apps/108600/header.jpg?t=1691508011', '2024-02-29 09:51:58.732197', '2024-02-29 09:51:58.732197');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('sa665nl2das9ljesn69zv26r', 'wsr5voep92cdcocq2b9ywaiv', 'https://cdn.akamai.steamstatic.com/steam/apps/108600/ss_d4a0f78dc94273c7f0eedc186569efc091387066.1920x1080.jpg?t=1691508011', '2024-02-29 09:51:58.781859', '2024-02-29 09:51:58.781859');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('a14hzsr6w43mzvz2n00bxdeq', 'wsr5voep92cdcocq2b9ywaiv', 'https://cdn.akamai.steamstatic.com/steam/apps/108600/ss_eca8be032b3f5508bf5bea74cfbc823a4df047ce.1920x1080.jpg?t=1691508011', '2024-02-29 09:51:58.83113', '2024-02-29 09:51:58.83113');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('pvnritzvj9ou885x3tjf7fxo', 'qf8zykgjbjxw7flsuny2y50z', 'https://cdn.akamai.steamstatic.com/steam/apps/204360/header.jpg?t=1707857982', '2024-02-29 09:51:58.924202', '2024-02-29 09:51:58.924202');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('sgc07muh4ydaz5xvh2hggqji', 'qf8zykgjbjxw7flsuny2y50z', 'https://cdn.akamai.steamstatic.com/steam/apps/204360/ss_a800d5bc5b31d84fb940c7d0449f1aea05ac3e0e.1920x1080.jpg?t=1707857982', '2024-02-29 09:51:58.973764', '2024-02-29 09:51:58.973764');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('rena2ljl2v95by49arfwkxg8', 'qf8zykgjbjxw7flsuny2y50z', 'https://cdn.akamai.steamstatic.com/steam/apps/204360/ss_aa619ba113280fd78ddb6a6c36a435a1bd673773.1920x1080.jpg?t=1707857982', '2024-02-29 09:51:59.022533', '2024-02-29 09:51:59.022533');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('fz78g5d1f04yo1lo35v192s9', 'a57g10tvdtkfic8q3om2wdsm', 'https://cdn.akamai.steamstatic.com/steam/apps/218230/header.jpg?t=1700252005', '2024-02-29 09:51:59.12119', '2024-02-29 09:51:59.12119');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('av5snfvdkyp8w4mwjmiwrlek', 'a57g10tvdtkfic8q3om2wdsm', 'https://cdn.akamai.steamstatic.com/steam/apps/218230/ss_b271ef75a7f1d5f95285174a94fe7608dfebf55b.1920x1080.jpg?t=1700252005', '2024-02-29 09:51:59.177523', '2024-02-29 09:51:59.177523');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('cbk2k377w12x62l5baai8hhc', 'a57g10tvdtkfic8q3om2wdsm', 'https://cdn.akamai.steamstatic.com/steam/apps/218230/ss_1d8d54765411020d9ba5c265f54f5df8df14e7f5.1920x1080.jpg?t=1700252005', '2024-02-29 09:51:59.225571', '2024-02-29 09:51:59.225571');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('td7lepse4aa9vealnn0mpa0l', 'qlt3cctapjncy0ec9ytqbsap', 'https://cdn.akamai.steamstatic.com/steam/apps/218620/header.jpg?t=1706686603', '2024-02-29 09:51:59.31798', '2024-02-29 09:51:59.31798');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('h70r83kyhe46oqnq9prndyv3', 'qlt3cctapjncy0ec9ytqbsap', 'https://cdn.akamai.steamstatic.com/steam/apps/218620/ss_67979091e0441e3df7aa885eaa107e2032973869.1920x1080.jpg?t=1706686603', '2024-02-29 09:51:59.366375', '2024-02-29 09:51:59.366375');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('g66r3254wvg9zcnrt00ccy5x', 'qlt3cctapjncy0ec9ytqbsap', 'https://cdn.akamai.steamstatic.com/steam/apps/218620/ss_b26f1852b68ab0af7fdd4932b1c9f78dc87a0325.1920x1080.jpg?t=1706686603', '2024-02-29 09:51:59.412181', '2024-02-29 09:51:59.412181');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('u3oeqoe373t0okbl4i3ixzut', 'jrmn42bmhdbo4w57z6z9369k', 'https://cdn.akamai.steamstatic.com/steam/apps/221100/header.jpg?t=1703605389', '2024-02-29 09:51:59.506546', '2024-02-29 09:51:59.506546');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('cze029daihpq93hq7e7y90wg', 'jrmn42bmhdbo4w57z6z9369k', 'https://cdn.akamai.steamstatic.com/steam/apps/221100/ss_7f488d8e49682a8d1643a795fc9047cbbd2dcc9c.1920x1080.jpg?t=1703605389', '2024-02-29 09:51:59.557916', '2024-02-29 09:51:59.557916');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('pi1w3yq57kk7c3ni059b5til', 'jrmn42bmhdbo4w57z6z9369k', 'https://cdn.akamai.steamstatic.com/steam/apps/221100/ss_0de6d2e7f3b5348d69bb09d60624c78e13f0c8d7.1920x1080.jpg?t=1703605389', '2024-02-29 09:51:59.606185', '2024-02-29 09:51:59.606185');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('a9lha3kgyzrey4zt442sadg9', 'hu6egxla0rindn68ecevahde', 'https://cdn.akamai.steamstatic.com/steam/apps/224260/header.jpg?t=1696263772', '2024-02-29 09:51:59.708111', '2024-02-29 09:51:59.708111');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ajhii6dug4c34asnqinysvhx', 'hu6egxla0rindn68ecevahde', 'https://cdn.akamai.steamstatic.com/steam/apps/224260/ss_e5e8941961b51fba8fec5f333bdcdf760f2e9e23.1920x1080.jpg?t=1696263772', '2024-02-29 09:51:59.758627', '2024-02-29 09:51:59.758627');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('xe38vi31ichu938hrh662xld', 'hu6egxla0rindn68ecevahde', 'https://cdn.akamai.steamstatic.com/steam/apps/224260/ss_5c09edf3fe2b8f51536e08ce57658d52a496a2b1.1920x1080.jpg?t=1696263772', '2024-02-29 09:51:59.804542', '2024-02-29 09:51:59.804542');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('rgd6h0e9ns9kp6cbg8ws1rqp', 'pqwx4n0ycrwqytp71nn7zl1r', 'https://cdn.akamai.steamstatic.com/steam/apps/227300/header.jpg?t=1707210696', '2024-02-29 09:51:59.902078', '2024-02-29 09:51:59.902078');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('s2ous9iv8noxyregw5uh5o0q', 'pqwx4n0ycrwqytp71nn7zl1r', 'https://cdn.akamai.steamstatic.com/steam/apps/227300/ss_e040f74641ac21f15e3ec7c2415fc8b4de0b6bf9.1920x1080.jpg?t=1707210696', '2024-02-29 09:51:59.950451', '2024-02-29 09:51:59.950451');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('r5y770qh5vo8i5riia4wq021', 'pqwx4n0ycrwqytp71nn7zl1r', 'https://cdn.akamai.steamstatic.com/steam/apps/227300/ss_fd675feae669c7fb4ca6dcfb738d49fb7b7a238d.1920x1080.jpg?t=1707210696', '2024-02-29 09:51:59.99846', '2024-02-29 09:51:59.99846');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('d0g09fc5eat8a0mhrwsrkm0p', 'lz12nfvsedzqt69ne9hcaw06', 'https://cdn.akamai.steamstatic.com/steam/apps/230410/header.jpg?t=1708445781', '2024-02-29 09:52:00.093929', '2024-02-29 09:52:00.093929');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('qe6n18who3ja3kuangaezaxl', 'lz12nfvsedzqt69ne9hcaw06', 'https://cdn.akamai.steamstatic.com/steam/apps/230410/ss_2e4077f215eccde84171a4b8e0f2bc8a3264c776.1920x1080.jpg?t=1708445781', '2024-02-29 09:52:00.141757', '2024-02-29 09:52:00.141757');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('cotoqd1m6ub4k9dogyckupxs', 'lz12nfvsedzqt69ne9hcaw06', 'https://cdn.akamai.steamstatic.com/steam/apps/230410/ss_0a541a8bf59e212870ea8d82260ac1b3ae2d0354.1920x1080.jpg?t=1708445781', '2024-02-29 09:52:00.188226', '2024-02-29 09:52:00.188226');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('kfqxdc5eyqakp62k613brhcy', 'dup89vgd8bpfn21c29skcmj3', 'https://cdn.akamai.steamstatic.com/steam/apps/236390/header.jpg?t=1708930557', '2024-02-29 09:52:00.286706', '2024-02-29 09:52:00.286706');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('s4i5vw8mmphywijap3cuzqho', 'dup89vgd8bpfn21c29skcmj3', 'https://cdn.akamai.steamstatic.com/steam/apps/236390/ss_1652095848f0a75b251fc53a236f34380922a972.1920x1080.jpg?t=1708930557', '2024-02-29 09:52:00.336448', '2024-02-29 09:52:00.336448');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('r63xjgymqytqexi61avnetzb', 'dup89vgd8bpfn21c29skcmj3', 'https://cdn.akamai.steamstatic.com/steam/apps/236390/ss_d1ac46eb1cded344b9321df70e05977092e161a0.1920x1080.jpg?t=1708930557', '2024-02-29 09:52:00.386673', '2024-02-29 09:52:00.386673');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('d3ammczp8hz0pxi51rnihrow', 'tvq3w8mxjy1d5yq2uwjap272', 'https://cdn.akamai.steamstatic.com/steam/apps/238960/header.jpg?t=1707963590', '2024-02-29 09:52:00.485262', '2024-02-29 09:52:00.485262');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('wcwtzjxa9g79g2eb4nlhcvlm', 'tvq3w8mxjy1d5yq2uwjap272', 'https://cdn.akamai.steamstatic.com/steam/apps/238960/ss_584d5e30921df24b12f26853e406e0fc74dfd3d3.1920x1080.jpg?t=1707963590', '2024-02-29 09:52:00.533165', '2024-02-29 09:52:00.533165');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('nr80rnzqggagoko3ve2c62tt', 'tvq3w8mxjy1d5yq2uwjap272', 'https://cdn.akamai.steamstatic.com/steam/apps/238960/ss_20ad64b32e4a65c70a88d7dbe79200a4cc3c69bb.1920x1080.jpg?t=1707963590', '2024-02-29 09:52:00.580772', '2024-02-29 09:52:00.580772');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('boefutdmfcvnviihf9gxuh62', 'f38uitjtevt0c9slm7w5l1p8', 'https://cdn.akamai.steamstatic.com/steam/apps/239140/header.jpg?t=1708683078', '2024-02-29 09:52:00.673655', '2024-02-29 09:52:00.673655');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('h5nnsgmcxoqxxrk7sdq0xueu', 'f38uitjtevt0c9slm7w5l1p8', 'https://cdn.akamai.steamstatic.com/steam/apps/239140/ss_a3771358b8eb4ea4c8f99c5850711f55b87804de.1920x1080.jpg?t=1708683078', '2024-02-29 09:52:00.723241', '2024-02-29 09:52:00.723241');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('j5c5ciygxzt3pl3dgs7z8940', 'f38uitjtevt0c9slm7w5l1p8', 'https://cdn.akamai.steamstatic.com/steam/apps/239140/ss_1f0dc94f46fa1a953827188188887f6a12911ec2.1920x1080.jpg?t=1708683078', '2024-02-29 09:52:00.769136', '2024-02-29 09:52:00.769136');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ruzblfcsw1dkzodrcrtohh0q', 'qomcsfhl8kfxfdjbuk1dj4va', 'https://cdn.akamai.steamstatic.com/steam/apps/242760/header.jpg?t=1699381053', '2024-02-29 09:52:00.867494', '2024-02-29 09:52:00.867494');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('zv0ie76er66oxb88n9er43fe', 'qomcsfhl8kfxfdjbuk1dj4va', 'https://cdn.akamai.steamstatic.com/steam/apps/242760/ss_8ccb821c4df3fafdf4161d77f38635441a8157f2.1920x1080.jpg?t=1699381053', '2024-02-29 09:52:00.913566', '2024-02-29 09:52:00.913566');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('d5ykzppkg6mh18ftapsqdhms', 'qomcsfhl8kfxfdjbuk1dj4va', 'https://cdn.akamai.steamstatic.com/steam/apps/242760/ss_53c615d49c4777144ed7359e4bf7c9eb6838cc8e.1920x1080.jpg?t=1699381053', '2024-02-29 09:52:00.960693', '2024-02-29 09:52:00.960693');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('d7iunk1e6p136bxc0k52eac0', 'ywjp1asaghgobxbsqvgm49m4', 'https://cdn.akamai.steamstatic.com/steam/apps/251570/header.jpg?t=1702072288', '2024-02-29 09:52:01.05789', '2024-02-29 09:52:01.05789');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('vgreivaerq4uzzuxjxnuet9t', 'ywjp1asaghgobxbsqvgm49m4', 'https://cdn.akamai.steamstatic.com/steam/apps/251570/ss_66ab2c612cb28b4b61974bcb3380a69274c4c127.1920x1080.jpg?t=1702072288', '2024-02-29 09:52:01.105439', '2024-02-29 09:52:01.105439');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('zuu9xmakwyiamh7hl66mg4dr', 'ywjp1asaghgobxbsqvgm49m4', 'https://cdn.akamai.steamstatic.com/steam/apps/251570/ss_573fbb7a06c0b269de2c1e562b0129412f42792f.1920x1080.jpg?t=1702072288', '2024-02-29 09:52:01.160696', '2024-02-29 09:52:01.160696');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('jphb06h4x97zro8ndjxthu72', 'kmf9vqz6jhx81urb5p2qbn1d', 'https://cdn.akamai.steamstatic.com/steam/apps/252490/header.jpg?t=1701938429', '2024-02-29 09:52:01.258083', '2024-02-29 09:52:01.258083');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('t7h8k4smafqd1gmtm3noorwo', 'kmf9vqz6jhx81urb5p2qbn1d', 'https://cdn.akamai.steamstatic.com/steam/apps/252490/ss_271feae67943bdc141c1249aba116349397e9ba9.1920x1080.jpg?t=1701938429', '2024-02-29 09:52:01.304258', '2024-02-29 09:52:01.304258');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('zrhf5y3lqoqv8c3dcyfdm0im', 'kmf9vqz6jhx81urb5p2qbn1d', 'https://cdn.akamai.steamstatic.com/steam/apps/252490/ss_e825b087b95e51c3534383cfd75ad6e8038147c3.1920x1080.jpg?t=1701938429', '2024-02-29 09:52:01.353869', '2024-02-29 09:52:01.353869');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('evnk7jzvn23el4o45hwxsntr', 'hf8rigj4p8udweii1xv30ki1', 'https://cdn.akamai.steamstatic.com/steam/apps/252950/header.jpg?t=1701892365', '2024-02-29 09:52:01.450393', '2024-02-29 09:52:01.450393');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('i2ih9al4nby0b44nq37au8wu', 'hf8rigj4p8udweii1xv30ki1', 'https://cdn.akamai.steamstatic.com/steam/apps/252950/ss_55e66dec1b8521b1663b61de633e099c22b6091e.1920x1080.jpg?t=1701892365', '2024-02-29 09:52:01.499183', '2024-02-29 09:52:01.499183');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('eldisk21qlgxkevo8onqzl1y', 'hf8rigj4p8udweii1xv30ki1', 'https://cdn.akamai.steamstatic.com/steam/apps/252950/ss_046eb0674a1da699a245b4565f82cdda946e9e1f.1920x1080.jpg?t=1701892365', '2024-02-29 09:52:01.548276', '2024-02-29 09:52:01.548276');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('u2pmhkrsk0dw9xwexunwl4gg', 'npm75y8q9rnd5oj9b5diqb4g', 'https://cdn.akamai.steamstatic.com/steam/apps/272060/header.jpg?t=1447360032', '2024-02-29 09:52:01.642115', '2024-02-29 09:52:01.642115');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('kxtonu5ioykjqon11dne23sd', 'npm75y8q9rnd5oj9b5diqb4g', 'https://cdn.akamai.steamstatic.com/steam/apps/272060/ss_cc2138a520387bf44cd83d96368ccd09a871b267.1920x1080.jpg?t=1447360032', '2024-02-29 09:52:01.689378', '2024-02-29 09:52:01.689378');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('bxjdvk004l1mucfu26e5mzcr', 'npm75y8q9rnd5oj9b5diqb4g', 'https://cdn.akamai.steamstatic.com/steam/apps/272060/ss_b55a9440156a6c141a83d3c8e69eccb97d5ebf85.1920x1080.jpg?t=1447360032', '2024-02-29 09:52:01.736456', '2024-02-29 09:52:01.736456');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('mof46lhgr8hgzfdh4xb3q4ym', 'hbykc1ebs6693wlewuvxe7qy', 'https://cdn.akamai.steamstatic.com/steam/apps/291550/header.jpg?t=1708529211', '2024-02-29 09:52:01.835619', '2024-02-29 09:52:01.835619');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('pizl6gf6r5mnjyccggh97uq8', 'hbykc1ebs6693wlewuvxe7qy', 'https://cdn.akamai.steamstatic.com/steam/apps/291550/ss_9bde6fc7de7b2b715647d8914431a2e7381ac58d.1920x1080.jpg?t=1708529211', '2024-02-29 09:52:01.887531', '2024-02-29 09:52:01.887531');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('kc4frrke3k2qn8iwsllemc6h', 'hbykc1ebs6693wlewuvxe7qy', 'https://cdn.akamai.steamstatic.com/steam/apps/291550/ss_248c3a1d8583b11933f640af6d99639150a1219b.1920x1080.jpg?t=1708529211', '2024-02-29 09:52:01.935649', '2024-02-29 09:52:01.935649');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('z5ajis5h6p1g3hgxcxsx9qf6', 'ph744dcsaf4pbxx10ttlk777', 'https://cdn.akamai.steamstatic.com/steam/apps/301520/header.jpg?t=1706886871', '2024-02-29 09:52:02.030065', '2024-02-29 09:52:02.030065');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('q8tclol6gph6k15x110wkdgl', 'ph744dcsaf4pbxx10ttlk777', 'https://cdn.akamai.steamstatic.com/steam/apps/301520/ss_bb5b383f92f6f5f850bada4b5d93ad5b73b9bc36.1920x1080.jpg?t=1706886871', '2024-02-29 09:52:02.077544', '2024-02-29 09:52:02.077544');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('qqjnvlnedjwaiychfnp6fln0', 'ph744dcsaf4pbxx10ttlk777', 'https://cdn.akamai.steamstatic.com/steam/apps/301520/ss_ba7a072aaf537ff0fa6046e15ae9cf53e32efc3b.1920x1080.jpg?t=1706886871', '2024-02-29 09:52:02.127503', '2024-02-29 09:52:02.127503');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('rd9kjjecokc4z3p5upmmp9jx', 'vidt4z82r9by5jgeb0fbvrv2', 'https://cdn.akamai.steamstatic.com/steam/apps/304050/header.jpg?t=1702497569', '2024-02-29 09:52:02.22282', '2024-02-29 09:52:02.22282');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ue8n3lkmavx253evifmumf55', 'vidt4z82r9by5jgeb0fbvrv2', 'https://cdn.akamai.steamstatic.com/steam/apps/304050/ss_58c0f25b023d15d56b9782b1d374b6ac3b5cf5ee.1920x1080.jpg?t=1702497569', '2024-02-29 09:52:02.270725', '2024-02-29 09:52:02.270725');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('qet1xrtuwcf6um5iuwl8lnyq', 'vidt4z82r9by5jgeb0fbvrv2', 'https://cdn.akamai.steamstatic.com/steam/apps/304050/ss_518fb4ea0c748cf9b25537c8d686cfe874d79566.1920x1080.jpg?t=1702497569', '2024-02-29 09:52:02.317022', '2024-02-29 09:52:02.317022');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('je7xkm3lj46g974facpq44a9', 'bc1csi8bx7r75cgw2ydb5fhu', 'https://cdn.akamai.steamstatic.com/steam/apps/304930/header.jpg?t=1707174662', '2024-02-29 09:52:02.42764', '2024-02-29 09:52:02.42764');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('f5sxoafwt99mopphih1tjmtv', 'bc1csi8bx7r75cgw2ydb5fhu', 'https://cdn.akamai.steamstatic.com/steam/apps/304930/ss_a2d8ffa4eaff717539c1fd9d3cd0440691c6fc81.1920x1080.jpg?t=1707174662', '2024-02-29 09:52:02.481404', '2024-02-29 09:52:02.481404');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('g2dtkwo7ha3dh8xde6v6twxj', 'bc1csi8bx7r75cgw2ydb5fhu', 'https://cdn.akamai.steamstatic.com/steam/apps/304930/ss_b1cf12ba306180da433dcf199f6f4a2fa74e48bd.1920x1080.jpg?t=1707174662', '2024-02-29 09:52:02.529915', '2024-02-29 09:52:02.529915');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('l8mno8jfzriuapvypss1tzxa', 'iktfn8ul1rentnpd2jmxvlhf', 'https://cdn.akamai.steamstatic.com/steam/apps/367520/header.jpg?t=1695270428', '2024-02-29 09:52:02.631525', '2024-02-29 09:52:02.631525');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('rgxpcbo2c62joe6d4n20vvjs', 'iktfn8ul1rentnpd2jmxvlhf', 'https://cdn.akamai.steamstatic.com/steam/apps/367520/ss_5384f9f8b96a0b9934b2bc35a4058376211636d2.1920x1080.jpg?t=1695270428', '2024-02-29 09:52:02.681002', '2024-02-29 09:52:02.681002');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('e5rusiz77cet79bywkeb6xwl', 'iktfn8ul1rentnpd2jmxvlhf', 'https://cdn.akamai.steamstatic.com/steam/apps/367520/ss_d5b6edd94e77ba6db31c44d8a3c09d807ab27751.1920x1080.jpg?t=1695270428', '2024-02-29 09:52:02.730252', '2024-02-29 09:52:02.730252');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ua8dhv6bcro0ro41uo3m2l4l', 'z4wu29qahihgiziikj1jacqc', 'https://cdn.akamai.steamstatic.com/steam/apps/377160/header.jpg?t=1650909928', '2024-02-29 09:52:02.827865', '2024-02-29 09:52:02.827865');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('kmyo5vhe04azax77xgbg2e0n', 'z4wu29qahihgiziikj1jacqc', 'https://cdn.akamai.steamstatic.com/steam/apps/377160/ss_f7861bd71e6c0c218d8ff69fb1c626aec0d187cf.1920x1080.jpg?t=1650909928', '2024-02-29 09:52:02.877441', '2024-02-29 09:52:02.877441');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('lw6ryh1sblswadlfjlounvvu', 'z4wu29qahihgiziikj1jacqc', 'https://cdn.akamai.steamstatic.com/steam/apps/377160/ss_910437ac708aed7c028f6e43a6224c633d086b0a.1920x1080.jpg?t=1650909928', '2024-02-29 09:52:02.935324', '2024-02-29 09:52:02.935324');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('c74uqx6b7cbx883dpikxo6vr', 'qofmi4efiqi8ab0gm6jg7ag5', 'https://cdn.akamai.steamstatic.com/steam/apps/381210/header.jpg?t=1708984271', '2024-02-29 09:52:03.045796', '2024-02-29 09:52:03.045796');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('jm0lbhffiva5xtqwjsv1e41i', 'qofmi4efiqi8ab0gm6jg7ag5', 'https://cdn.akamai.steamstatic.com/steam/apps/381210/ss_659500624438a4aa77bfdf304cba3ecebcd92ed9.1920x1080.jpg?t=1708984271', '2024-02-29 09:52:03.090816', '2024-02-29 09:52:03.090816');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('aavsxgrn3ara74fxkk65czmg', 'qofmi4efiqi8ab0gm6jg7ag5', 'https://cdn.akamai.steamstatic.com/steam/apps/381210/ss_ca6b39f2fcac8feb75d23976b1be31290d58d159.1920x1080.jpg?t=1708984271', '2024-02-29 09:52:03.140419', '2024-02-29 09:52:03.140419');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ruto20w7ejdfe44ig17gq43x', 'eg9pggwe15uedi73j6y0td1f', 'https://cdn.akamai.steamstatic.com/steam/apps/386360/header.jpg?t=1708703088', '2024-02-29 09:52:03.237021', '2024-02-29 09:52:03.237021');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('a8rxjfjgodd61xqvh5gm4aks', 'eg9pggwe15uedi73j6y0td1f', 'https://cdn.akamai.steamstatic.com/steam/apps/386360/ss_9104a5770367ff37d3cd0e488b0866e8284874e5.1920x1080.jpg?t=1708703088', '2024-02-29 09:52:03.290958', '2024-02-29 09:52:03.290958');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('d1wbx1ckd72snp8z6d01boib', 'eg9pggwe15uedi73j6y0td1f', 'https://cdn.akamai.steamstatic.com/steam/apps/386360/ss_b49630110e5c4603dc4d5a46acda198a8b2a5dde.1920x1080.jpg?t=1708703088', '2024-02-29 09:52:03.339306', '2024-02-29 09:52:03.339306');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('o8orpqxkccvs9neys1bcu9lo', 'djyaar9hu50keq25wvd80rmj', 'https://cdn.akamai.steamstatic.com/steam/apps/413150/header.jpg?t=1666917466', '2024-02-29 09:52:03.432944', '2024-02-29 09:52:03.432944');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('mq10qlqfi7zg3567zdz6w510', 'djyaar9hu50keq25wvd80rmj', 'https://cdn.akamai.steamstatic.com/steam/apps/413150/ss_b887651a93b0525739049eb4194f633de2df75be.1920x1080.jpg?t=1666917466', '2024-02-29 09:52:03.479063', '2024-02-29 09:52:03.479063');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('oh937krzc8a82f4uzo5rgna8', 'djyaar9hu50keq25wvd80rmj', 'https://cdn.akamai.steamstatic.com/steam/apps/413150/ss_9ac899fe2cda15d48b0549bba77ef8c4a090a71c.1920x1080.jpg?t=1666917466', '2024-02-29 09:52:03.528517', '2024-02-29 09:52:03.528517');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('gfs48gm4443yaacr9w6doyjx', 'i3i5i748g288fmy2t31mkwt0', 'https://cdn.akamai.steamstatic.com/steam/apps/417910/header.jpg?t=1600256776', '2024-02-29 09:52:03.621969', '2024-02-29 09:52:03.621969');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('odo5lto4thrgmokvtxn732ro', 'i3i5i748g288fmy2t31mkwt0', 'https://cdn.akamai.steamstatic.com/steam/apps/417910/ss_cfff84247b42b5e887a8433444dc8d8717cf121e.1920x1080.jpg?t=1600256776', '2024-02-29 09:52:03.669408', '2024-02-29 09:52:03.669408');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('b60yxyv2oid7eikemx622jez', 'i3i5i748g288fmy2t31mkwt0', 'https://cdn.akamai.steamstatic.com/steam/apps/417910/ss_d526919f3ee41d414b8daa341f92851ba535f42b.1920x1080.jpg?t=1600256776', '2024-02-29 09:52:03.716144', '2024-02-29 09:52:03.716144');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('buru7m9e14aos2ccnamt4ie6', 'h5kqdx63x67zwr3gbrfiypdp', 'https://cdn.akamai.steamstatic.com/steam/apps/433850/header.jpg?t=1579626820', '2024-02-29 09:52:03.815673', '2024-02-29 09:52:03.815673');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('gf2p5ixsy6d04z4ejequuiv4', 'h5kqdx63x67zwr3gbrfiypdp', 'https://cdn.akamai.steamstatic.com/steam/apps/433850/ss_68cba3b0f7642531f828ed2accedca1db6f39f6f.1920x1080.jpg?t=1579626820', '2024-02-29 09:52:03.868226', '2024-02-29 09:52:03.868226');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ubu7y5i4ddnimuyphwr4r02l', 'h5kqdx63x67zwr3gbrfiypdp', 'https://cdn.akamai.steamstatic.com/steam/apps/433850/ss_5b69acafaad30d42d30cc60ae429156d05c63ce9.1920x1080.jpg?t=1579626820', '2024-02-29 09:52:03.917866', '2024-02-29 09:52:03.917866');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('nbirjwxjpfh6pufawu5bgq8x', 'k4hgnl7zd0lubjxzcjs7ex84', 'https://cdn.akamai.steamstatic.com/steam/apps/438100/header.jpg?t=1708983867', '2024-02-29 09:52:04.016684', '2024-02-29 09:52:04.016684');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('xiarxmp3nib4qlabyp0qqboj', 'k4hgnl7zd0lubjxzcjs7ex84', 'https://cdn.akamai.steamstatic.com/steam/apps/438100/ss_1577335ddadd96c338c16a747758290b4214eb85.1920x1080.jpg?t=1708983867', '2024-02-29 09:52:04.063084', '2024-02-29 09:52:04.063084');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('qpxtgsa2ttby9gro291d7sj8', 'k4hgnl7zd0lubjxzcjs7ex84', 'https://cdn.akamai.steamstatic.com/steam/apps/438100/ss_31f674ab2a2cdf3d72ff7e8155100f4539a65a72.1920x1080.jpg?t=1708983867', '2024-02-29 09:52:04.111135', '2024-02-29 09:52:04.111135');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('bvlorjyznwx5dm060gd185lh', 'a6w23eo7dqbh647q1mcdkqxa', 'https://cdn.akamai.steamstatic.com/steam/apps/444090/header.jpg?t=1708637625', '2024-02-29 09:52:04.211037', '2024-02-29 09:52:04.211037');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('nfjrslrp180866hcihp0cwrl', 'a6w23eo7dqbh647q1mcdkqxa', 'https://cdn.akamai.steamstatic.com/steam/apps/444090/ss_846b1464dc9242bc44c9b43547c7b5567cbbdf0c.1920x1080.jpg?t=1708637625', '2024-02-29 09:52:04.258398', '2024-02-29 09:52:04.258398');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('dxpn6rpyyonfyeeretu2xobc', 'a6w23eo7dqbh647q1mcdkqxa', 'https://cdn.akamai.steamstatic.com/steam/apps/444090/ss_ad869c6cb217556a844a2ca8558867c51dcc442e.1920x1080.jpg?t=1708637625', '2024-02-29 09:52:04.307543', '2024-02-29 09:52:04.307543');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('f3lvnf8tcydpfnetf17bezga', 'tuww2m38utl2sg23g71yucp2', 'https://cdn.akamai.steamstatic.com/steam/apps/444200/header.jpg?t=1708682622', '2024-02-29 09:52:04.404162', '2024-02-29 09:52:04.404162');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('calqxsmxm1onvg1235jlofki', 'tuww2m38utl2sg23g71yucp2', 'https://cdn.akamai.steamstatic.com/steam/apps/444200/ss_4824fe1555ec3ce0fc78c7ac825337cec04e30be.1920x1080.jpg?t=1708682622', '2024-02-29 09:52:04.453315', '2024-02-29 09:52:04.453315');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('g6n3zb0m119gs3px3cpox18f', 'tuww2m38utl2sg23g71yucp2', 'https://cdn.akamai.steamstatic.com/steam/apps/444200/ss_b78846ceaeb51d4aa210e317443e6354e2354741.1920x1080.jpg?t=1708682622', '2024-02-29 09:52:04.500615', '2024-02-29 09:52:04.500615');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('vfb784cqrzrowl8285wu3fys', 'agjzenc97b4yerbizahab1x0', 'https://cdn.akamai.steamstatic.com/steam/apps/477160/header.jpg?t=1705400786', '2024-02-29 09:52:04.601801', '2024-02-29 09:52:04.601801');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('bbb91ws1wbagbgncfeabmzfv', 'agjzenc97b4yerbizahab1x0', 'https://cdn.akamai.steamstatic.com/steam/apps/477160/ss_ffb63e922b64c32eadebdc59bb08e9007ebdf976.1920x1080.jpg?t=1705400786', '2024-02-29 09:52:04.651962', '2024-02-29 09:52:04.651962');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('e57pwfcv1bwz5kgc32j6cooz', 'agjzenc97b4yerbizahab1x0', 'https://cdn.akamai.steamstatic.com/steam/apps/477160/ss_f02669c421a6a99cd8df1cd9337ce80b306be998.1920x1080.jpg?t=1705400786', '2024-02-29 09:52:04.700811', '2024-02-29 09:52:04.700811');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('q9qlhpl3v6n1cb3yyzgf4b4h', 'gra8ck2o30xzhap68csccyyn', 'https://cdn.akamai.steamstatic.com/steam/apps/489520/header_alt_assets_15.jpg?t=1707292029', '2024-02-29 09:52:04.798428', '2024-02-29 09:52:04.798428');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('n1wgyo153fug7fhtvwd2hcn7', 'gra8ck2o30xzhap68csccyyn', 'https://cdn.akamai.steamstatic.com/steam/apps/489520/ss_ff25c94b1cc1a3731c0f51a2a31d9516d725048a.1920x1080.jpg?t=1707292029', '2024-02-29 09:52:04.846693', '2024-02-29 09:52:04.846693');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('d5y7bdrxg7ve0gygkj4a5c71', 'gra8ck2o30xzhap68csccyyn', 'https://cdn.akamai.steamstatic.com/steam/apps/489520/ss_e4ae57dca3a26ce13a01d4ac2871f711679e0934.1920x1080.jpg?t=1707292029', '2024-02-29 09:52:04.89703', '2024-02-29 09:52:04.89703');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('naxuh341cjxda4b9xv14wjcr', 'u53gb56zic3u0upk8vbusdc5', 'https://cdn.akamai.steamstatic.com/steam/apps/532210/header.jpg?t=1698854177', '2024-02-29 09:52:04.99461', '2024-02-29 09:52:04.99461');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('alzkxmgcsapl017tv8xnap4v', 'u53gb56zic3u0upk8vbusdc5', 'https://cdn.akamai.steamstatic.com/steam/apps/532210/ss_3907bb1ea3aac991b272ce9a7bd5b492fc7a768d.1920x1080.jpg?t=1698854177', '2024-02-29 09:52:05.042713', '2024-02-29 09:52:05.042713');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('zhynow9byu8d7af15dyxecpg', 'u53gb56zic3u0upk8vbusdc5', 'https://cdn.akamai.steamstatic.com/steam/apps/532210/ss_1fd2aad8a9192812c737b9c14205ac1b8c233e2b.1920x1080.jpg?t=1698854177', '2024-02-29 09:52:05.09956', '2024-02-29 09:52:05.09956');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('tazp0strxffkvbkqvu6t8mxc', 'yuc9c935ck6uxjlpwmts9zo0', 'https://cdn.akamai.steamstatic.com/steam/apps/550650/header.jpg?t=1654048842', '2024-02-29 09:52:05.204959', '2024-02-29 09:52:05.204959');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('efbxltnprcodaj1dhibvwnbd', 'yuc9c935ck6uxjlpwmts9zo0', 'https://cdn.akamai.steamstatic.com/steam/apps/550650/ss_ab8bb299401356bca496fd4c67510ca69c0c1320.1920x1080.jpg?t=1654048842', '2024-02-29 09:52:05.254253', '2024-02-29 09:52:05.254253');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ju2z5q4e57rkmwwl3r5he8cb', 'yuc9c935ck6uxjlpwmts9zo0', 'https://cdn.akamai.steamstatic.com/steam/apps/550650/ss_85c1e6738e7040ce4c4d789456f5db2258a81407.1920x1080.jpg?t=1654048842', '2024-02-29 09:52:05.303932', '2024-02-29 09:52:05.303932');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('p86nierlm4kk3ihle95hmorp', 'tasrtq9sfo3xhdw878fj4k51', 'https://cdn.akamai.steamstatic.com/steam/apps/552990/header_alt_assets_7.jpg?t=1708631476', '2024-02-29 09:52:05.400493', '2024-02-29 09:52:05.400493');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('e04aubsv93rh7m0cv5qscu79', 'tasrtq9sfo3xhdw878fj4k51', 'https://cdn.akamai.steamstatic.com/steam/apps/552990/ss_13192e349cc427dc2fb260528c0626c9b778cf8b.1920x1080.jpg?t=1708631476', '2024-02-29 09:52:05.450175', '2024-02-29 09:52:05.450175');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('nxmmgnniz536ythol0d4x2db', 'tasrtq9sfo3xhdw878fj4k51', 'https://cdn.akamai.steamstatic.com/steam/apps/552990/ss_80623f95fd3fa9e609ea6f7eb8e9bb11514be8af.1920x1080.jpg?t=1708631476', '2024-02-29 09:52:05.500889', '2024-02-29 09:52:05.500889');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('rbbhu2aueu7ceejis4clncaq', 'tss89qj0cyc4p659xd8k56ga', 'https://cdn.akamai.steamstatic.com/steam/apps/648800/header.jpg?t=1693638925', '2024-02-29 09:52:05.600066', '2024-02-29 09:52:05.600066');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('jq092j8w1hzgoijshxbbbgzg', 'tss89qj0cyc4p659xd8k56ga', 'https://cdn.akamai.steamstatic.com/steam/apps/648800/ss_c22b2ff5ba5609f74e61b5feaa5b7a1d7fd1dbd3.1920x1080.jpg?t=1693638925', '2024-02-29 09:52:05.649174', '2024-02-29 09:52:05.649174');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('kza1simn19idjqq3rcqsc35w', 'tss89qj0cyc4p659xd8k56ga', 'https://cdn.akamai.steamstatic.com/steam/apps/648800/ss_2adb248f4d501cf58344d9af1d8a9e56c74647ee.1920x1080.jpg?t=1693638925', '2024-02-29 09:52:05.696719', '2024-02-29 09:52:05.696719');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('cvozu4mhzewj8ja0wk8bghdg', 'du5g2k3itjqmm8aahuv3ny0w', 'https://cdn.akamai.steamstatic.com/steam/apps/739630/header.jpg?t=1702309974', '2024-02-29 09:52:05.795531', '2024-02-29 09:52:05.795531');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('yawl9viwf2uxd5btil0k3bxv', 'du5g2k3itjqmm8aahuv3ny0w', 'https://cdn.akamai.steamstatic.com/steam/apps/739630/ss_c88170bed9bf8690963323d20e3f9e836cb9aed9.1920x1080.jpg?t=1702309974', '2024-02-29 09:52:05.841759', '2024-02-29 09:52:05.841759');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('xe4n2cs0cn2pxqcn6ft0m8sz', 'du5g2k3itjqmm8aahuv3ny0w', 'https://cdn.akamai.steamstatic.com/steam/apps/739630/ss_f0377c02897de8831a5f032f13a6dc0f994516d5.1920x1080.jpg?t=1702309974', '2024-02-29 09:52:05.886713', '2024-02-29 09:52:05.886713');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('yb2o5djrh1628z6183h7j9pj', 'qkml6ma8di7ud1uv4gkgjwds', 'https://cdn.akamai.steamstatic.com/steam/apps/892970/header.jpg?t=1708348390', '2024-02-29 09:52:05.98149', '2024-02-29 09:52:05.98149');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('u2k0vpaizlkmzm6gylor7w6e', 'qkml6ma8di7ud1uv4gkgjwds', 'https://cdn.akamai.steamstatic.com/steam/apps/892970/ss_a600a7d4ca954543e22f571a9629521a13f82143.1920x1080.jpg?t=1708348390', '2024-02-29 09:52:06.0266', '2024-02-29 09:52:06.0266');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('qydd3anhxnei95w3ruwi1akf', 'qkml6ma8di7ud1uv4gkgjwds', 'https://cdn.akamai.steamstatic.com/steam/apps/892970/ss_cd0262c5abf8a90ee5e1059acafc5a92b6be0e73.1920x1080.jpg?t=1708348390', '2024-02-29 09:52:06.075143', '2024-02-29 09:52:06.075143');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('amsmqqzcdq719b92gomffaq6', 'l8ftsemea2k0if0dnbzmylqc', 'https://cdn.akamai.steamstatic.com/steam/apps/582010/header.jpg?t=1704795600', '2024-02-29 09:52:06.17225', '2024-02-29 09:52:06.17225');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('gpw2zlj4eqgubdmi6v3weftl', 'l8ftsemea2k0if0dnbzmylqc', 'https://cdn.akamai.steamstatic.com/steam/apps/582010/ss_a262c53b8629de7c6547933dc0b49d31f4e1b1f1.1920x1080.jpg?t=1704795600', '2024-02-29 09:52:06.221969', '2024-02-29 09:52:06.221969');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('a9rkdcb6ht87ulsvv0f8u3eu', 'l8ftsemea2k0if0dnbzmylqc', 'https://cdn.akamai.steamstatic.com/steam/apps/582010/ss_6b4986a37c7b5c185a796085c002febcdd5357b5.1920x1080.jpg?t=1704795600', '2024-02-29 09:52:06.267651', '2024-02-29 09:52:06.267651');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('zygijxc4p0v6mrhleouz4ou8', 'xjof0ehtx0l109c9hkertgjl', 'https://cdn.akamai.steamstatic.com/steam/apps/578080/header.jpg?t=1707123905', '2024-02-29 09:52:06.362492', '2024-02-29 09:52:06.362492');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('l3wqnhqb4w1c560phvcslt68', 'xjof0ehtx0l109c9hkertgjl', 'https://cdn.akamai.steamstatic.com/steam/apps/578080/ss_2da334ea597d9588aaa8c716d71b3c2e60a69853.1920x1080.jpg?t=1707123905', '2024-02-29 09:52:06.409626', '2024-02-29 09:52:06.409626');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('w5sqm7maygb10evmjsl1io2c', 'xjof0ehtx0l109c9hkertgjl', 'https://cdn.akamai.steamstatic.com/steam/apps/578080/ss_fe5340f8ea6e0d2f3899ef1e7d2ebdfc07e32f67.1920x1080.jpg?t=1707123905', '2024-02-29 09:52:06.456966', '2024-02-29 09:52:06.456966');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('tg9o3215tiydjgt9v0594u4m', 'uzviy2mg6oujoabtbgyt2fee', 'https://cdn.akamai.steamstatic.com/steam/apps/80/header.jpg?t=1602535977', '2024-02-29 09:52:06.560153', '2024-02-29 09:52:06.560153');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('rqg10bahsi0ovvlaa7bf70u5', 'uzviy2mg6oujoabtbgyt2fee', 'https://cdn.akamai.steamstatic.com/steam/apps/80/0000002528.1920x1080.jpg?t=1602535977', '2024-02-29 09:52:06.618561', '2024-02-29 09:52:06.618561');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('s0qrzxt5vv6w89i9rxz1geqb', 'uzviy2mg6oujoabtbgyt2fee', 'https://cdn.akamai.steamstatic.com/steam/apps/80/0000002529.1920x1080.jpg?t=1602535977', '2024-02-29 09:52:06.667418', '2024-02-29 09:52:06.667418');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('u1wg78ogzyzpkcibcmugwg7f', 'ndwcrgr335kbg7qgo2tnd9t6', 'https://cdn.akamai.steamstatic.com/steam/apps/240/header.jpg?t=1666823740', '2024-02-29 09:52:06.764561', '2024-02-29 09:52:06.764561');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('b1rsy282qso5mh49fv4x8nc4', 'ndwcrgr335kbg7qgo2tnd9t6', 'https://cdn.akamai.steamstatic.com/steam/apps/240/0000000027.1920x1080.jpg?t=1666823740', '2024-02-29 09:52:06.811922', '2024-02-29 09:52:06.811922');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('db265iwx1aihfv1vtyfw4ma9', 'ndwcrgr335kbg7qgo2tnd9t6', 'https://cdn.akamai.steamstatic.com/steam/apps/240/0000000028.1920x1080.jpg?t=1666823740', '2024-02-29 09:52:06.85972', '2024-02-29 09:52:06.85972');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('d2mpemd4fmwlscg3ms2bnf1q', 'mzuotpzfa6tigv7o83mye9fq', 'https://cdn.akamai.steamstatic.com/steam/apps/300/header.jpg?t=1694209029', '2024-02-29 09:52:06.954302', '2024-02-29 09:52:06.954302');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('p4fgb2j8ra3n8k3xxsxing6x', 'mzuotpzfa6tigv7o83mye9fq', 'https://cdn.akamai.steamstatic.com/steam/apps/300/0000000023.1920x1080.jpg?t=1694209029', '2024-02-29 09:52:07.00147', '2024-02-29 09:52:07.00147');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('p2hgssv2bj9ye0ikl3v25qoj', 'mzuotpzfa6tigv7o83mye9fq', 'https://cdn.akamai.steamstatic.com/steam/apps/300/0000000042.1920x1080.jpg?t=1694209029', '2024-02-29 09:52:07.052545', '2024-02-29 09:52:07.052545');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ytt3p5n3jk8u15af90yd6ct7', 'ys1v8kjnrop631jllcwa01jy', 'https://cdn.akamai.steamstatic.com/steam/apps/320/header.jpg?t=1602536087', '2024-02-29 09:52:07.151678', '2024-02-29 09:52:07.151678');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('mnjiotocqc9z2bqan6dv6ura', 'ys1v8kjnrop631jllcwa01jy', 'https://cdn.akamai.steamstatic.com/steam/apps/320/ss_09a55c755073d11c5c708da922abd9005546a5ee.1920x1080.jpg?t=1602536087', '2024-02-29 09:52:07.198961', '2024-02-29 09:52:07.198961');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ijwlzjk7bqjjnk6dodh8biuz', 'ys1v8kjnrop631jllcwa01jy', 'https://cdn.akamai.steamstatic.com/steam/apps/320/ss_7241594c2575bc1f822f1431490cea485b7aef8a.1920x1080.jpg?t=1602536087', '2024-02-29 09:52:07.249512', '2024-02-29 09:52:07.249512');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('njd1txrh5uc47noj3ya1hzom', 'qq7hhfflvczx88av8v4l6u5p', 'https://cdn.akamai.steamstatic.com/steam/apps/340/header.jpg?t=1571757270', '2024-02-29 09:52:07.34394', '2024-02-29 09:52:07.34394');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('vsoxmz8xv076xqsio4s4bouh', 'qq7hhfflvczx88av8v4l6u5p', 'https://cdn.akamai.steamstatic.com/steam/apps/340/0000000010.1920x1080.jpg?t=1571757270', '2024-02-29 09:52:07.393176', '2024-02-29 09:52:07.393176');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('idsilq0545anf084j1ac5y1g', 'qq7hhfflvczx88av8v4l6u5p', 'https://cdn.akamai.steamstatic.com/steam/apps/340/0000000011.1920x1080.jpg?t=1571757270', '2024-02-29 09:52:07.44032', '2024-02-29 09:52:07.44032');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('p7u2vfpkpjn7vk2ew8iglu2m', 'ex9xn5nkq5fe0kw7zztunys7', 'https://cdn.akamai.steamstatic.com/steam/apps/72850/header.jpg?t=1647357402', '2024-02-29 09:52:07.533119', '2024-02-29 09:52:07.533119');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ak19rlzfm27dpa04a1gaosky', 'ex9xn5nkq5fe0kw7zztunys7', 'https://cdn.akamai.steamstatic.com/steam/apps/72850/ss_4e95fbcf72ce2a9f86075738fa9930ef2bed1ac7.1920x1080.jpg?t=1647357402', '2024-02-29 09:52:07.599922', '2024-02-29 09:52:07.599922');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('w3k18mtn602byp405ii04llg', 'ex9xn5nkq5fe0kw7zztunys7', 'https://cdn.akamai.steamstatic.com/steam/apps/72850/ss_b16a3740e032afe1c4b0477174eae7af8444b85d.1920x1080.jpg?t=1647357402', '2024-02-29 09:52:07.647888', '2024-02-29 09:52:07.647888');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('rex37h9os8jfczwkud9mmo8n', 'it8zq2ix8yoltdaj2q6dyv9z', 'https://cdn.akamai.steamstatic.com/steam/apps/250900/header.jpg?t=1617174663', '2024-02-29 09:52:07.75625', '2024-02-29 09:52:07.75625');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('xf99awv4sthwzjel9f1biyca', 'it8zq2ix8yoltdaj2q6dyv9z', 'https://cdn.akamai.steamstatic.com/steam/apps/250900/ss_25a4a446a433218d41a7e87e35b60c297e68e7a4.1920x1080.jpg?t=1617174663', '2024-02-29 09:52:07.803165', '2024-02-29 09:52:07.803165');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('zofkpn02ip7pa5f702ma1icz', 'it8zq2ix8yoltdaj2q6dyv9z', 'https://cdn.akamai.steamstatic.com/steam/apps/250900/ss_19ef624e8d97136ba6f928d389b85f7b8130c37a.1920x1080.jpg?t=1617174663', '2024-02-29 09:52:07.850829', '2024-02-29 09:52:07.850829');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('vlwgyu7zhekp6pd7rkgfv61q', 'o15cg6udbsj6loxxuoux2q6a', 'https://cdn.akamai.steamstatic.com/steam/apps/261550/header.jpg?t=1707212548', '2024-02-29 09:52:07.945692', '2024-02-29 09:52:07.945692');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('bbrsoiu566b4xy8pfu16daoq', 'o15cg6udbsj6loxxuoux2q6a', 'https://cdn.akamai.steamstatic.com/steam/apps/261550/ss_569257e92fd31d58a6fe08053de637071b4518d3.1920x1080.jpg?t=1707212548', '2024-02-29 09:52:07.992173', '2024-02-29 09:52:07.992173');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('j970jrlymxd6y3tuhijg48j1', 'o15cg6udbsj6loxxuoux2q6a', 'https://cdn.akamai.steamstatic.com/steam/apps/261550/ss_9682cf43bf605e9c655c1dbb4b23d1aac73165dc.1920x1080.jpg?t=1707212548', '2024-02-29 09:52:08.04385', '2024-02-29 09:52:08.04385');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('a4q68qhjfapqk4rs6mipf99w', 'gayl0akbtnotpk4bm8ti0erq', 'https://cdn.akamai.steamstatic.com/steam/apps/292030/header.jpg?t=1693590732', '2024-02-29 09:52:08.141129', '2024-02-29 09:52:08.141129');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ba4zzuwtor76c8b4p35f8nm2', 'gayl0akbtnotpk4bm8ti0erq', 'https://cdn.akamai.steamstatic.com/steam/apps/292030/ss_5710298af2318afd9aa72449ef29ac4a2ef64d8e.1920x1080.jpg?t=1693590732', '2024-02-29 09:52:08.189791', '2024-02-29 09:52:08.189791');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('n0v1g7livy53caywdsg313wq', 'gayl0akbtnotpk4bm8ti0erq', 'https://cdn.akamai.steamstatic.com/steam/apps/292030/ss_0901e64e9d4b8ebaea8348c194e7a3644d2d832d.1920x1080.jpg?t=1693590732', '2024-02-29 09:52:08.237146', '2024-02-29 09:52:08.237146');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('vxxyjjgs3mr474g4bnw5mbex', 'gdbzg690avfj78j7jeqyuvzc', 'https://cdn.akamai.steamstatic.com/steam/apps/346110/header.jpg?t=1702590643', '2024-02-29 09:52:08.334716', '2024-02-29 09:52:08.334716');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('e4x6fiensatfttdt71rfsrl7', 'gdbzg690avfj78j7jeqyuvzc', 'https://cdn.akamai.steamstatic.com/steam/apps/346110/ss_2fd997a2f7151cb2187043a1f41589cc6a9ebf3a.1920x1080.jpg?t=1702590643', '2024-02-29 09:52:08.385724', '2024-02-29 09:52:08.385724');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('xhyij96mlc1otvv8o8eyjf94', 'gdbzg690avfj78j7jeqyuvzc', 'https://cdn.akamai.steamstatic.com/steam/apps/346110/ss_01cbef83fe28d64ee5a3d39a86043fb1e49abd31.1920x1080.jpg?t=1702590643', '2024-02-29 09:52:08.436623', '2024-02-29 09:52:08.436623');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('cv01x5g3n27gsg04iqtxt065', 'f3794r789whpzwzdd6gftdsp', 'https://cdn.akamai.steamstatic.com/steam/apps/255710/header.jpg?t=1707984372', '2024-02-29 09:52:08.531789', '2024-02-29 09:52:08.531789');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('u3ejjbw0a7wbshkpku37ebnj', 'f3794r789whpzwzdd6gftdsp', 'https://cdn.akamai.steamstatic.com/steam/apps/255710/ss_0754001c88ad4dbfff92faf9a97e8d87cf3f8840.1920x1080.jpg?t=1707984372', '2024-02-29 09:52:08.57917', '2024-02-29 09:52:08.57917');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('kipds0smo4np9km9ui1qu86r', 'f3794r789whpzwzdd6gftdsp', 'https://cdn.akamai.steamstatic.com/steam/apps/255710/ss_e0f842c9327df9defabf120b6c59e1ba42f54a75.1920x1080.jpg?t=1707984372', '2024-02-29 09:52:08.627097', '2024-02-29 09:52:08.627097');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('yqd83emfvpd8qxyv0qyd8gha', 't7il621eck7ufj7rk97abbfk', 'https://cdn.akamai.steamstatic.com/steam/apps/945360/header.jpg?t=1698177355', '2024-02-29 09:52:08.726745', '2024-02-29 09:52:08.726745');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('roxckxgj1svfgbd0rehvhajj', 't7il621eck7ufj7rk97abbfk', 'https://cdn.akamai.steamstatic.com/steam/apps/945360/ss_b7374128e5b786a302a716bca038d604b00ffe46.1920x1080.jpg?t=1698177355', '2024-02-29 09:52:08.774546', '2024-02-29 09:52:08.774546');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ahqx5nntm0fel490jf2bsf9i', 't7il621eck7ufj7rk97abbfk', 'https://cdn.akamai.steamstatic.com/steam/apps/945360/ss_719484b5e0314cc2ae43793786448e032056a31d.1920x1080.jpg?t=1698177355', '2024-02-29 09:52:08.823477', '2024-02-29 09:52:08.823477');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('m2hskwdojupk4eka03gz7nvd', 'lv4vn4y294jrokdmllbqt6bj', 'https://cdn.akamai.steamstatic.com/steam/apps/990080/header.jpg?t=1708720689', '2024-02-29 09:52:08.918824', '2024-02-29 09:52:08.918824');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('tdfmwua17t1357wmmidi87h9', 'lv4vn4y294jrokdmllbqt6bj', 'https://cdn.akamai.steamstatic.com/steam/apps/990080/ss_725bf58485beb4aa37a3a69c1e2baa69bf3e4653.1920x1080.jpg?t=1708720689', '2024-02-29 09:52:08.969471', '2024-02-29 09:52:08.969471');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('yalo6f9xphpjhpotmwuo5zix', 'lv4vn4y294jrokdmllbqt6bj', 'https://cdn.akamai.steamstatic.com/steam/apps/990080/ss_df93b5e8a183f7232d68be94ae78920a90de1443.1920x1080.jpg?t=1708720689', '2024-02-29 09:52:09.017622', '2024-02-29 09:52:09.017622');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('s78qby3y59ydm4dap29x8kml', 'p3oyg01ojynsqhusj1v7396c', 'https://cdn.akamai.steamstatic.com/steam/apps/1046930/header.jpg?t=1649700104', '2024-02-29 09:52:09.111711', '2024-02-29 09:52:09.111711');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('xkvuy8azmxn4mossifr7vv01', 'p3oyg01ojynsqhusj1v7396c', 'https://cdn.akamai.steamstatic.com/steam/apps/1046930/ss_25ad872bc9a8ecf634a76ce1d4bb22aea9b728c9.1920x1080.jpg?t=1649700104', '2024-02-29 09:52:09.158136', '2024-02-29 09:52:09.158136');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ptz2ex2fnuj1ojqfw657rzya', 'p3oyg01ojynsqhusj1v7396c', 'https://cdn.akamai.steamstatic.com/steam/apps/1046930/ss_1bc613845672667a6e1f957e269543de629ace39.1920x1080.jpg?t=1649700104', '2024-02-29 09:52:09.207071', '2024-02-29 09:52:09.207071');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('sed0bnbqrq80pnu5zi7nmpwg', 'ce5tuu4x7z75tuphn094jyqv', 'https://cdn.akamai.steamstatic.com/steam/apps/1063730/header.jpg?t=1702483749', '2024-02-29 09:52:09.301943', '2024-02-29 09:52:09.301943');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('qy1cwp847w9j5vjbekkog9i0', 'ce5tuu4x7z75tuphn094jyqv', 'https://cdn.akamai.steamstatic.com/steam/apps/1063730/ss_75c46de3e645b812b2750cf8f619fd9dfae2ba69.1920x1080.jpg?t=1702483749', '2024-02-29 09:52:09.34992', '2024-02-29 09:52:09.34992');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ogks5gl2r1isf58035e0qv7g', 'ce5tuu4x7z75tuphn094jyqv', 'https://cdn.akamai.steamstatic.com/steam/apps/1063730/ss_8765a66c81f098c6340547834b3207244482fe95.1920x1080.jpg?t=1702483749', '2024-02-29 09:52:09.397165', '2024-02-29 09:52:09.397165');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('t4zq7l86u8f33kgylvxhh4x2', 'nb05k7725nr4fxogbprnrh3u', 'https://cdn.akamai.steamstatic.com/steam/apps/1085660/header.jpg?t=1707950251', '2024-02-29 09:52:09.492689', '2024-02-29 09:52:09.492689');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('mk9g83rnzvawoxrhhjfv766z', 'nb05k7725nr4fxogbprnrh3u', 'https://cdn.akamai.steamstatic.com/steam/apps/1085660/ss_7fcc82f468fcf8278c7ffa95cebf949bfc6845fc.1920x1080.jpg?t=1707950251', '2024-02-29 09:52:09.539167', '2024-02-29 09:52:09.539167');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('mpwqab30d4vipri471bsalh3', 'nb05k7725nr4fxogbprnrh3u', 'https://cdn.akamai.steamstatic.com/steam/apps/1085660/ss_c142f5078ace9f5e2eb2c80aa3bf768e156b4ee9.1920x1080.jpg?t=1707950251', '2024-02-29 09:52:09.588864', '2024-02-29 09:52:09.588864');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('tdfj3s3i83zwjvuhris09j73', 'diwt05re1694jxe8d4qi4lk2', 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg?t=1706698946', '2024-02-29 09:52:09.683694', '2024-02-29 09:52:09.683694');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('y92zak6xoxfrfyerhheb6xi7', 'diwt05re1694jxe8d4qi4lk2', 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_7924f64b6e5d586a80418c9896a1c92881a7905b.1920x1080.jpg?t=1706698946', '2024-02-29 09:52:09.735798', '2024-02-29 09:52:09.735798');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('s5izk8uc7sg0u74r779dxrby', 'diwt05re1694jxe8d4qi4lk2', 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_4eb068b1cf52c91b57157b84bed18a186ed7714b.1920x1080.jpg?t=1706698946', '2024-02-29 09:52:09.78882', '2024-02-29 09:52:09.78882');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('khfzro68pu6be3nycb7dp6dm', 'q7j53ynadxupmytro2nkl2sl', 'https://cdn.akamai.steamstatic.com/steam/apps/1172470/header.jpg?t=1708706824', '2024-02-29 09:52:09.884144', '2024-02-29 09:52:09.884144');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('z2fkfb12e0r4oo2dkgpv7vxj', 'q7j53ynadxupmytro2nkl2sl', 'https://cdn.akamai.steamstatic.com/steam/apps/1172470/ss_b5051a24edf949582756c313eebf6f61582ce25f.1920x1080.jpg?t=1708706824', '2024-02-29 09:52:09.932828', '2024-02-29 09:52:09.932828');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('c7jzgcjtc92yikxh2f2ragjf', 'q7j53ynadxupmytro2nkl2sl', 'https://cdn.akamai.steamstatic.com/steam/apps/1172470/ss_ed4087e1f7e85905df637304ac4e511def7943e7.1920x1080.jpg?t=1708706824', '2024-02-29 09:52:09.979576', '2024-02-29 09:52:09.979576');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('mhw5s51fguh7sg7o99gav9b9', 'bakfe9d5efenge1s7n4ug8ad', 'https://cdn.akamai.steamstatic.com/steam/apps/1174180/header.jpg?t=1695140956', '2024-02-29 09:52:10.075471', '2024-02-29 09:52:10.075471');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('jn635f68k8wsdmpyheyf0mfc', 'bakfe9d5efenge1s7n4ug8ad', 'https://cdn.akamai.steamstatic.com/steam/apps/1174180/ss_66b553f4c209476d3e4ce25fa4714002cc914c4f.1920x1080.jpg?t=1695140956', '2024-02-29 09:52:10.12423', '2024-02-29 09:52:10.12423');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('t848r61jawe8iwl9j3c76aff', 'bakfe9d5efenge1s7n4ug8ad', 'https://cdn.akamai.steamstatic.com/steam/apps/1174180/ss_bac60bacbf5da8945103648c08d27d5e202444ca.1920x1080.jpg?t=1695140956', '2024-02-29 09:52:10.174203', '2024-02-29 09:52:10.174203');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('m3cykstlu2p5ny217tl9unvv', 'qz1jj93yuu7zt4k0eh14veop', 'https://cdn.akamai.steamstatic.com/steam/apps/1240440/header.jpg?t=1708019038', '2024-02-29 09:52:10.272711', '2024-02-29 09:52:10.272711');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('trsviendvp61mq1jgbyx3t8e', 'qz1jj93yuu7zt4k0eh14veop', 'https://cdn.akamai.steamstatic.com/steam/apps/1240440/ss_1eba7066e9c3a0d2bb576d49c33802e3fb2cfa1d.1920x1080.jpg?t=1708019038', '2024-02-29 09:52:10.323663', '2024-02-29 09:52:10.323663');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('yzdu1l0epk9ij0g6u1nc7ojz', 'qz1jj93yuu7zt4k0eh14veop', 'https://cdn.akamai.steamstatic.com/steam/apps/1240440/ss_0ed37c21d2c79484519da82a11aa1329c93f4e96.1920x1080.jpg?t=1708019038', '2024-02-29 09:52:10.370308', '2024-02-29 09:52:10.370308');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('lczgzjwu1qa2h8d1a8gvbjmv', 'f29cyh05ix9awc1t5lama8nx', 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/header.jpg?t=1709086268', '2024-02-29 09:52:10.487183', '2024-02-29 09:52:10.487183');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('g9a7ufa72qu876s5lx4asmzn', 'f29cyh05ix9awc1t5lama8nx', 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/ss_c97bcad291f4f45d4be4594f34bd78921d961099.1920x1080.jpg?t=1709086268', '2024-02-29 09:52:10.535782', '2024-02-29 09:52:10.535782');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('cbt8p1e46o1j18j7zp3hommn', 'f29cyh05ix9awc1t5lama8nx', 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/ss_7bef8e5fb78ee8bd396c5ff17af10731edf52c5f.1920x1080.jpg?t=1709086268', '2024-02-29 09:52:10.585022', '2024-02-29 09:52:10.585022');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('jkfpugn5smyrzi3nriqm8963', 'vpnofhz52busrdya33kzkbvx', 'https://cdn.akamai.steamstatic.com/steam/apps/1599340/header.jpg?t=1702454470', '2024-02-29 09:52:10.684107', '2024-02-29 09:52:10.684107');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('cqdmcsj0s62x295qz2c2lo0m', 'vpnofhz52busrdya33kzkbvx', 'https://cdn.akamai.steamstatic.com/steam/apps/1599340/ss_b9c562ad66414ec37cf448f2f9d19d70009129ef.1920x1080.jpg?t=1702454470', '2024-02-29 09:52:10.732306', '2024-02-29 09:52:10.732306');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('r474fte6gd03qzaluyljy7wu', 'vpnofhz52busrdya33kzkbvx', 'https://cdn.akamai.steamstatic.com/steam/apps/1599340/ss_489519a55f1fcef124413a36232598017429a8d2.1920x1080.jpg?t=1702454470', '2024-02-29 09:52:10.777751', '2024-02-29 09:52:10.777751');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('bx71vhumpi2fufpaoirqf9xm', 'mpq3lugo6y25dz0dlrgbu5uv', 'https://cdn.akamai.steamstatic.com/steam/apps/1623730/header.jpg?t=1707904340', '2024-02-29 09:52:10.872207', '2024-02-29 09:52:10.872207');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('ghjbolf3fp7vrxe92avmfmhg', 'mpq3lugo6y25dz0dlrgbu5uv', 'https://cdn.akamai.steamstatic.com/steam/apps/1623730/ss_f81b7c4f20be3b99f76a1415c4cdb9b444c99b97.1920x1080.jpg?t=1707904340', '2024-02-29 09:52:10.919095', '2024-02-29 09:52:10.919095');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('yncqmai80ck1odcdoxhae3ak', 'mpq3lugo6y25dz0dlrgbu5uv', 'https://cdn.akamai.steamstatic.com/steam/apps/1623730/ss_a9fa84f0c21bc536f00925ab4586e8c4f587c2b7.1920x1080.jpg?t=1707904340', '2024-02-29 09:52:10.968519', '2024-02-29 09:52:10.968519');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('zp6jhfd6cdr5n3ll1myvobux', 'yuigzdlroot3s60opx173vfl', 'https://cdn.akamai.steamstatic.com/steam/apps/1966720/header.jpg?t=1700231592', '2024-02-29 09:52:11.061206', '2024-02-29 09:52:11.061206');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('oc90tr1j14r4hbkxpwgs4ngf', 'yuigzdlroot3s60opx173vfl', 'https://cdn.akamai.steamstatic.com/steam/apps/1966720/ss_78075e9a94675823024f12fce9d69b243cca94f8.1920x1080.jpg?t=1700231592', '2024-02-29 09:52:11.110379', '2024-02-29 09:52:11.110379');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('bq9ksp0suzmn4mrmpiuq8tt9', 'yuigzdlroot3s60opx173vfl', 'https://cdn.akamai.steamstatic.com/steam/apps/1966720/ss_51860be59845771c01a3a4d9ab1ebf773f16fef5.1920x1080.jpg?t=1700231592', '2024-02-29 09:52:11.162019', '2024-02-29 09:52:11.162019');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('tznwmrm45a1geu83d82wby5h', 'zbvfaqo7m18cfpetalzaj2f2', 'https://cdn.akamai.steamstatic.com/steam/apps/1203220/header.jpg?t=1707711086', '2024-02-29 09:52:11.259374', '2024-02-29 09:52:11.259374');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('v5oertcgeqpk9ffwn8dl0f7c', 'zbvfaqo7m18cfpetalzaj2f2', 'https://cdn.akamai.steamstatic.com/steam/apps/1203220/ss_6a8707f7039ebd31bb58d86a6864730fc5ebd38f.1920x1080.jpg?t=1707711086', '2024-02-29 09:52:11.306482', '2024-02-29 09:52:11.306482');
INSERT INTO public.game_images (id, game_id, image_url, created_at, updated_at) VALUES ('s7eazu5p9l8tgawzzas67cd0', 'zbvfaqo7m18cfpetalzaj2f2', 'https://cdn.akamai.steamstatic.com/steam/apps/1203220/ss_9cb7ead0af0faaaf2bb8609822cb35b16d1a48f0.1920x1080.jpg?t=1707711086', '2024-02-29 09:52:11.353981', '2024-02-29 09:52:11.353981');


--
-- Data for Name: game_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('zn4ueid6oemsusomf1t6e8nf', 'fcfmf9p8szc7bvtirbv6mspn', 'bum6fjzo8fcsizjayshnv188', '2024-01-31 10:21:05.094819');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('gpam5bwg4fq6uxz8h4bnaw7c', 'fcfmf9p8szc7bvtirbv6mspn', 'aw1tvm2is76eu50885g6sgfk', '2024-01-31 10:21:33.999322');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('gci4upbh6a47bb1050ucmfu2', 'fcfmf9p8szc7bvtirbv6mspn', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-01-31 10:22:00.822161');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bgjlcavj6w29w99k4kfoayzv', 'ie4j51aeog2tsomlqftc214j', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:46.797545');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('r5j7fvngqfa6hryp9339u2zm', 'ie4j51aeog2tsomlqftc214j', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:46.842353');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ntrubo65v8knqliwaviamtc6', 'ie4j51aeog2tsomlqftc214j', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:46.886369');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('gpa7n361bhtjhqbgwb61x3fm', 'ie4j51aeog2tsomlqftc214j', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:46.928969');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('dowi3olld06kgx38xe059u87', 'ie4j51aeog2tsomlqftc214j', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:46.972563');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('m1yfm67ycr216k5ns6fzhcrd', 'avumbyeptd3g6mldqmw1jo7d', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:47.065529');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('keumog2jq418owm0f2miggke', 'avumbyeptd3g6mldqmw1jo7d', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:47.112449');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('nbx8h413m9nd3zpg0ty173l1', 'cea9mnvg80esld1sa1r72zf9', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:47.209401');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('tiib3d0mew5mmxt3675aggq4', 'cea9mnvg80esld1sa1r72zf9', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:47.257316');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('sxaqj4di56hyvtoysmulzsg0', 'cea9mnvg80esld1sa1r72zf9', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:47.305183');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('p9afrmckx5n4l4wgtkg551qo', 'cea9mnvg80esld1sa1r72zf9', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:47.353274');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('siaq0fa8pxkrzgdsyd94jj54', 'uzviy2mg6oujoabtbgyt2fee', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:47.447936');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('x35rlj79wgfmvmgnze2lrmpj', 'uzviy2mg6oujoabtbgyt2fee', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:47.493657');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('t7gwkukqunai35f9o96t0l9u', 'uzviy2mg6oujoabtbgyt2fee', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:47.540894');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('cnlky3h1r62787gp9uv8t9eh', 'uzviy2mg6oujoabtbgyt2fee', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:47.586697');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('wlszjfwm3350yzg8py7yeg9l', 'ndwcrgr335kbg7qgo2tnd9t6', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:47.685694');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('f6lop5h4b84qtep6ysghxscl', 'ndwcrgr335kbg7qgo2tnd9t6', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:47.734622');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('tj8ttmeixjrp0v1kalerhh6y', 'ndwcrgr335kbg7qgo2tnd9t6', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:47.78383');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('z0gbiuwaotlx17ie0nwwh5u6', 'ndwcrgr335kbg7qgo2tnd9t6', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:47.831929');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('kygmmba1peh2aga415rr3w3w', 'ndwcrgr335kbg7qgo2tnd9t6', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:47.881934');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('v4jn7zel6zwfoeiv34luv5ia', 'ndwcrgr335kbg7qgo2tnd9t6', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:47.930955');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('toz03gg5yo1c4enwmfcl6r9x', 'mzuotpzfa6tigv7o83mye9fq', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:48.032441');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bvqvkiafn6kycdjuplz6qn66', 'mzuotpzfa6tigv7o83mye9fq', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:48.082515');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ay6o0k7hstesf52mcwgs68nz', 'mzuotpzfa6tigv7o83mye9fq', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:48.131012');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ehrd8mfk5l1skc9nwg15n6x5', 'ys1v8kjnrop631jllcwa01jy', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:48.232581');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ufhlceyhek6ftyl0nqe8r2zn', 'ys1v8kjnrop631jllcwa01jy', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:48.282295');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('tvzwy8o1x2h9xxumon3z0hhi', 'ys1v8kjnrop631jllcwa01jy', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:48.330365');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bz0htxsuuyarlv77eds4pog3', 'ys1v8kjnrop631jllcwa01jy', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:48.37568');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('pt2byomxyo0rv8uravv5zfsp', 'qq7hhfflvczx88av8v4l6u5p', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:48.466961');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('krcbf86ponsf7eeawzrrvf3e', 'qq7hhfflvczx88av8v4l6u5p', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:48.519384');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('f0ao52wzr79jgwgvhgughvbo', 'lma09e4m027ir3xn1spekrzy', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:48.616051');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('mgvho4qsoql3pl1zlf1ba3s5', 'lma09e4m027ir3xn1spekrzy', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:48.666473');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('w3swcxwioovr8fccwk5df3fs', 'yj7vjizwjcwp2vye4x5bhyni', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:48.762809');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('rs2vubdh8uq1pu5hjbfmy2kz', 'yj7vjizwjcwp2vye4x5bhyni', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:48.810834');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('p6h0n38jkz0z2uwgad04ewem', 'eoqrc7fxi5csiyiwbe1qfkcd', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:48.903928');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('me4ktm4nc0uzwtknhmwxyx0r', 'eoqrc7fxi5csiyiwbe1qfkcd', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:48.953115');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('khttqmo0tgqqf5v690yl54kl', 'eoqrc7fxi5csiyiwbe1qfkcd', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:49.001277');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('pn3262wyban3poo631modmc3', 'eoqrc7fxi5csiyiwbe1qfkcd', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:49.048502');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('qn43oy7moo7aw9x1e0atl2q2', 'smln9amlrmrfws6ih222fl96', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:49.149505');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('hslt9bkvov74qsxqo0erjneh', 'smln9amlrmrfws6ih222fl96', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:49.199145');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('nkozyvdzux8c9cna5okdo6r4', 'smln9amlrmrfws6ih222fl96', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:49.246939');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('rrfjy18p2ll4v66qu3f7k6tt', 'fd391rxpdxyqzmhefbb6fbe2', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:49.34198');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('fwt4fwfitfk8g7fekbjyddeh', 'fd391rxpdxyqzmhefbb6fbe2', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:49.387854');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('g9147ww1k3ictzrttor2ws5k', 'tg0q3e6d7dxclqm7uv3bpucv', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:49.888262');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('xh03pwgl75i2gnlyaxto1y86', 'tg0q3e6d7dxclqm7uv3bpucv', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:49.938244');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('u8m4x1kz33kb1s4j2s6pa93e', 'ex9xn5nkq5fe0kw7zztunys7', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:50.033164');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('uy3iqgcemri6wief6s13ygeg', 'ex9xn5nkq5fe0kw7zztunys7', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:50.081616');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('qo50o09cmjdq6ocw2smj2xf0', 'j7yghgfukup7y3svl76jhw1w', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:50.222233');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('o4wvb1qbfxne0cy5hoyryvgo', 'j7yghgfukup7y3svl76jhw1w', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:50.269926');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('psp1czlfwh3motp9oexrvail', 'tg6zemcrpnhueeb22he4h2ge', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:50.368811');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('fu14ctz1j3k4hs84m46wvunc', 'tg6zemcrpnhueeb22he4h2ge', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:50.416845');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('m9vgps2sr2fglsmn9aouh08y', 'tg6zemcrpnhueeb22he4h2ge', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:50.464291');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('mdu0u77ekcgq9kj02k27jqoh', 'tg6zemcrpnhueeb22he4h2ge', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:50.510792');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('czk2ewffn5dlppkl8xioav37', 'wsr5voep92cdcocq2b9ywaiv', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:50.604663');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ualo25juust3qzfce0smxdef', 'qf8zykgjbjxw7flsuny2y50z', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:50.699593');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('o2pur0qr0s0z5o3t6w2yp0uh', 'a57g10tvdtkfic8q3om2wdsm', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:50.794366');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('cdw2wseeesool6i6qylh435w', 'a57g10tvdtkfic8q3om2wdsm', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:50.842859');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('wbmx68gy18npzd1ab5s7yls0', 'a57g10tvdtkfic8q3om2wdsm', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:50.890731');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('hv0sinu81c1tjbmgki1c1spv', 'a57g10tvdtkfic8q3om2wdsm', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:50.939353');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('kbty8koev8bqd6fpqj9tmu3l', 'qlt3cctapjncy0ec9ytqbsap', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:51.032583');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('pj6aef48sc2twe7n36jylntw', 'qlt3cctapjncy0ec9ytqbsap', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:51.081672');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('idl03jih9ljk4x4l7j2f7xen', 'qlt3cctapjncy0ec9ytqbsap', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:51.131562');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('gylbb6oh8khhzq0134mb6v19', 'jrmn42bmhdbo4w57z6z9369k', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:51.229633');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('kmy0oo0r0iv6eaqh62kxwbnp', 'jrmn42bmhdbo4w57z6z9369k', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:51.278518');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('zi614kk43qzjz4s6qul78usp', 'jrmn42bmhdbo4w57z6z9369k', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:51.3254');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('fc1lokqol427crs376qv9uw8', 'jrmn42bmhdbo4w57z6z9369k', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:51.371257');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('vp9ton1xl4cx7e1d8npxwa53', 'hu6egxla0rindn68ecevahde', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:51.462615');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('onuy37dyvzh4m5kh993tuds7', 'hu6egxla0rindn68ecevahde', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:51.50928');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('z9cu61z10chm0r4a367x7sw3', 'hu6egxla0rindn68ecevahde', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:51.555387');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('juof4iesctgbbs0q9fuk9z1l', 'pqwx4n0ycrwqytp71nn7zl1r', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:51.647283');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bpg69k63dn5j8qtnvdqdjsgi', 'lz12nfvsedzqt69ne9hcaw06', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:51.927407');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('iwr98q9o8xdm0p973c21co68', 'dup89vgd8bpfn21c29skcmj3', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:52.023869');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bkk06a3yqwv8m1h8rkchxusp', 'tvq3w8mxjy1d5yq2uwjap272', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:52.118064');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('cwjtnsuva7p2q86unb03bnip', 'tvq3w8mxjy1d5yq2uwjap272', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:52.163832');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('gxxdstc82o8x41a9wd7vvesz', 'f38uitjtevt0c9slm7w5l1p8', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:52.260739');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('dps3zl4g95edn96i2h7fia5v', 'f38uitjtevt0c9slm7w5l1p8', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:52.307722');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('c1e4l3ozrf490ncwrj917p93', 'f38uitjtevt0c9slm7w5l1p8', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:52.357365');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bdqy7foksok77nhbb65ygwp2', 'f38uitjtevt0c9slm7w5l1p8', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:52.404998');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('p5u15kob2m4lpiez7g5rkctb', 'qomcsfhl8kfxfdjbuk1dj4va', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:52.50356');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('o0tm5kvr57syq1r2r48bpofo', 'qomcsfhl8kfxfdjbuk1dj4va', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:52.55109');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('rxyb35f64rm6ah3zuq002ctx', 'it8zq2ix8yoltdaj2q6dyv9z', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:52.649024');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('zgy6cq1qhjixn9c8ji5vkfhv', 'ywjp1asaghgobxbsqvgm49m4', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:52.745653');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('i9quugtlw9bjxwoox0t6eoxr', 'ywjp1asaghgobxbsqvgm49m4', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:52.791697');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ovt1aafangf8cxq48g6eg0j3', 'ywjp1asaghgobxbsqvgm49m4', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:52.841329');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('n7k5mkxi4zkzp2ysfl2i3cur', 'ywjp1asaghgobxbsqvgm49m4', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:52.888456');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('w6yd12ro41bcdth5hftwj0i3', 'kmf9vqz6jhx81urb5p2qbn1d', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:52.986575');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ui5x1fcaaaxci3v0mkjzrped', 'kmf9vqz6jhx81urb5p2qbn1d', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:53.031657');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('wnrx2ir2o4otakyglrt0i3o2', 'kmf9vqz6jhx81urb5p2qbn1d', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:53.079193');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('awq7opbjb3z4kox2uub9fjsk', 'kmf9vqz6jhx81urb5p2qbn1d', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:53.128828');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('xpfndpagpu5h2lp87u8pf5r9', 'hf8rigj4p8udweii1xv30ki1', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:53.226197');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('yywyv9fpb9njs41qqycwzvjy', 'f3794r789whpzwzdd6gftdsp', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:53.3216');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ttgym99r6wjj50294hhb03yv', 'f3794r789whpzwzdd6gftdsp', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:53.372696');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('eo4jcopzwdfw5pi1a6gq9vii', 'f3794r789whpzwzdd6gftdsp', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:53.417263');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('aal7yqewzki6v8swno95ehs5', 'o15cg6udbsj6loxxuoux2q6a', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:53.511312');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ooksfvxdkxer0kjo7g8gah0h', 'o15cg6udbsj6loxxuoux2q6a', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:53.560333');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('xlz5oznptdgzhluir3ofmaqx', 'o15cg6udbsj6loxxuoux2q6a', 'vq8cs8l0k4nvyklg8g44z6sa', '2024-02-29 09:31:53.607704');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('j8t204cywbluvmwfpqm64g7n', 'hbykc1ebs6693wlewuvxe7qy', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:54.325089');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('paebmvdk06hph9w55ej4ephv', 'gayl0akbtnotpk4bm8ti0erq', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:54.413776');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('cv3zf4zwvtaa7oq0qnkr5xgo', 'ph744dcsaf4pbxx10ttlk777', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:54.510852');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('w867po2qd8vvj4u938x905bq', 'ph744dcsaf4pbxx10ttlk777', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:54.558706');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ue25sr408ujso4vecgpry6og', 'ph744dcsaf4pbxx10ttlk777', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:54.605088');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ozcyhhh57wd7f234mq94pjeb', 'vidt4z82r9by5jgeb0fbvrv2', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:54.698532');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('csbh881rxtwmf90iyuzjvubg', 'bc1csi8bx7r75cgw2ydb5fhu', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:54.800094');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('pyf9uqwici6m7yfmysx9h42q', 'bc1csi8bx7r75cgw2ydb5fhu', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:54.845787');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('uyv13xzotuq21bophpcsd4jq', 'bc1csi8bx7r75cgw2ydb5fhu', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:54.890631');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('d8jw2btnz2h7h0h370qrca6y', 'gdbzg690avfj78j7jeqyuvzc', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:55.184407');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('fn3i7nfddxkl23t7wnoif85w', 'gdbzg690avfj78j7jeqyuvzc', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:55.233072');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('b1ll9o7s4qonf96yi9uewapr', 'iktfn8ul1rentnpd2jmxvlhf', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:55.567573');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('c6w1v3pn0dgcrpjnfxu8f11u', 'z4wu29qahihgiziikj1jacqc', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:55.665036');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ei2pifxzgzlkow7jmptz9srq', 'z4wu29qahihgiziikj1jacqc', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:55.717247');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('wg5nyujo3qdxqu4roau5ybwm', 'z4wu29qahihgiziikj1jacqc', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:55.76632');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bic4kurte7kmx7sosdatr5hk', 'qofmi4efiqi8ab0gm6jg7ag5', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:55.862141');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('o93ut75clt8tm98ckz6oqz83', 'qofmi4efiqi8ab0gm6jg7ag5', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:55.909466');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('v62tc3wwozs1qm6xv9g6p7mm', 'qofmi4efiqi8ab0gm6jg7ag5', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:55.957315');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('avilsazv46lymb53203yqbtx', 'eg9pggwe15uedi73j6y0td1f', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:56.057021');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('j5h2drl4oqi1mydmz3ykzkj9', 'eg9pggwe15uedi73j6y0td1f', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:56.103497');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('xkcubn3og4o87wn4i1cnl6pv', 'eg9pggwe15uedi73j6y0td1f', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:56.151015');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('pnomzi5j6vgrmjupj2z4ilpn', 'i3i5i748g288fmy2t31mkwt0', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:56.296623');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ne2f3z4qxk91efdafch860ua', 'i3i5i748g288fmy2t31mkwt0', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:56.347372');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('aoxp4s6wo4qu9yhv4bfcgi4w', 'h5kqdx63x67zwr3gbrfiypdp', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:56.548563');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('iyxdy23xy03eh1g4sff5z5q4', 'h5kqdx63x67zwr3gbrfiypdp', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:56.598348');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('rg5lzti01j4dp03smq8s2b17', 'h5kqdx63x67zwr3gbrfiypdp', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:56.646721');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('w3tb19tdu1yksvmif8vc9ysx', 'h5kqdx63x67zwr3gbrfiypdp', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:56.695471');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('uh0or4fuzh8oy5dtaioq2mzr', 'k4hgnl7zd0lubjxzcjs7ex84', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:56.790159');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('u84pu8k5ndberivz63an4gjf', 'a6w23eo7dqbh647q1mcdkqxa', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:56.883893');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('tf0g5op9m7m8ccag8zqzm4g6', 'a6w23eo7dqbh647q1mcdkqxa', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:56.932937');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('gf4tidcr4wuxxw7yb0de6030', 'a6w23eo7dqbh647q1mcdkqxa', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:56.982145');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('z92pyo860ygk7hbsyh6ufjmj', 'a6w23eo7dqbh647q1mcdkqxa', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:57.033117');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('d3k249g6eqje2h8pmz6eq0rw', 'tuww2m38utl2sg23g71yucp2', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:57.132155');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('wrovoc5j1k5uwrsssm9r4w29', 'tuww2m38utl2sg23g71yucp2', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:57.182675');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('iji86xzv13lhb0wt18u3wlmb', 'tuww2m38utl2sg23g71yucp2', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:57.233712');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ihhsk3tp6eirio5aikfw5iz6', 'tuww2m38utl2sg23g71yucp2', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:57.281149');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('c41uouq2qen6ybde6v2c188x', 'agjzenc97b4yerbizahab1x0', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:57.37343');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('pozlvyrknhvamuccgxvvh3ns', 'gra8ck2o30xzhap68csccyyn', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:57.469291');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('hk2ctjz02dwnndfbni6ms6yq', 'gra8ck2o30xzhap68csccyyn', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:57.516752');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('o3i7igzdcxw3m81w4uy92jm2', 'yuc9c935ck6uxjlpwmts9zo0', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:57.660265');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('s1opjc2g2hyvqgzlyuj9c0re', 'yuc9c935ck6uxjlpwmts9zo0', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:57.708084');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('hho89qhvivc1bi6qzfn8mmo5', 'yuc9c935ck6uxjlpwmts9zo0', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:57.755103');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ein8qr6epqcw2kvc5g36hear', 'yuc9c935ck6uxjlpwmts9zo0', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:57.804655');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('hzc4s3nngkiplp1uv6y8h3r3', 'tasrtq9sfo3xhdw878fj4k51', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:57.901144');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('pcajuo15is3vnibqunwm42a7', 'tasrtq9sfo3xhdw878fj4k51', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:57.948252');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('tnlh486ov4yw2uwzrhdxtjzz', 'xjof0ehtx0l109c9hkertgjl', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:58.137788');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('dnuypf21g83gaj8xscf0etvd', 'xjof0ehtx0l109c9hkertgjl', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:31:58.184853');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('avd8mdlv6uwo7ke0oqlummqi', 'xjof0ehtx0l109c9hkertgjl', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:58.232855');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('nqv7lniyyd2qrjlqkg40lruq', 'xjof0ehtx0l109c9hkertgjl', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:58.281299');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('xswms7x0lrobxmy78uquk446', 'xjof0ehtx0l109c9hkertgjl', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:58.329989');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('wd0zd2zarwjjbf9uffiz2z9o', 'l8ftsemea2k0if0dnbzmylqc', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:58.434014');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('jwx2pg4299p8pghvdfjl1hlf', 'tss89qj0cyc4p659xd8k56ga', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:58.52922');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('r0kjuoqh3krj9sd4d4xdvhos', 'tss89qj0cyc4p659xd8k56ga', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:58.575888');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('l9a7e0o7c2z0unpmxmzv3qg2', 'tss89qj0cyc4p659xd8k56ga', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:58.62651');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('rlufj7dctizbzb56xko7nwcs', 'du5g2k3itjqmm8aahuv3ny0w', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:58.72057');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('r29cpgggcegw5ugg16lnr8jb', 'qkml6ma8di7ud1uv4gkgjwds', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:59.172387');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('eqzjhvjyfi3ieem87ggtl0vq', 'qkml6ma8di7ud1uv4gkgjwds', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:59.240747');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('sjor4wp8imdis54o85kzlv7u', 't7il621eck7ufj7rk97abbfk', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:31:59.474852');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('b5ik0mmdl3ynyhdm8ydsjewe', 't7il621eck7ufj7rk97abbfk', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:59.524409');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('yuvufihyxt7jed62a4usf3t4', 't7il621eck7ufj7rk97abbfk', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:59.569758');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('s0zgv4bgr1jxmw5b1s6xxq8o', 'lv4vn4y294jrokdmllbqt6bj', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:59.66352');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('v4ewbut6dcer4wqq8j9uljzu', 'p3oyg01ojynsqhusj1v7396c', 'vogylznj5gbrxmcwfdd9lu6c', '2024-02-29 09:31:59.756109');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('vts7qnkuzmuhwlajc2madwb1', 'p3oyg01ojynsqhusj1v7396c', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:59.805223');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('fkp7y8b0ul3cn23m0zu8ro8o', 'ce5tuu4x7z75tuphn094jyqv', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:31:59.904951');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bi2fm54fgi2thqzksawl9z3u', 'ce5tuu4x7z75tuphn094jyqv', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:31:59.951342');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('jce97a2r9lajco1gem8tvhoq', 'nb05k7725nr4fxogbprnrh3u', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:32:00.050236');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('v0azrlvm8fu1ix1lrlgskb07', 'nb05k7725nr4fxogbprnrh3u', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:32:00.09931');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('h9i69fuqlfz0copven9f0uqi', 'nb05k7725nr4fxogbprnrh3u', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:00.143169');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ar3nc9z0cmnbr7ynn9h6n2vb', 'diwt05re1694jxe8d4qi4lk2', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:32:00.375211');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bh1i1myvz5jt65x6evlagy8s', 'diwt05re1694jxe8d4qi4lk2', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:00.423481');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('dwaljzpbku2olw7ek6alfvq6', 'q7j53ynadxupmytro2nkl2sl', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:32:00.659666');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('of1frw88sd9003r3ry8tks8p', 'q7j53ynadxupmytro2nkl2sl', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:32:00.708779');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('asixh9ze3bgahwtpgjsevmzp', 'q7j53ynadxupmytro2nkl2sl', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:00.755695');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('lk5zeo1246ykp8jnn5xv3tgu', 'q7j53ynadxupmytro2nkl2sl', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:32:00.80414');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('h7proo73k737cn0ft5q2x4mz', 'bakfe9d5efenge1s7n4ug8ad', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:00.902696');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('f5puw99if995dwi9vsphsgdm', 'bakfe9d5efenge1s7n4ug8ad', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:32:00.948151');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('rg5yyqxaiw11ayxot9ow05jq', 'zbvfaqo7m18cfpetalzaj2f2', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:32:01.053432');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('pm76ycb13vsj33j6alpkgsv6', 'zbvfaqo7m18cfpetalzaj2f2', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:01.100812');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('jh24k9ck1vrbrjctqihwir3y', 'zbvfaqo7m18cfpetalzaj2f2', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:32:01.150826');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ea7x7zanuajq4qzxq031gzrm', 'qz1jj93yuu7zt4k0eh14veop', 'aw1tvm2is76eu50885g6sgfk', '2024-02-29 09:32:01.487657');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('xso1c3wibldcm9ik1wfjt6x3', 'qz1jj93yuu7zt4k0eh14veop', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:01.53422');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bnlj0lhmaoln0iys440fkcrs', 'qz1jj93yuu7zt4k0eh14veop', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:32:01.579838');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('bvm09369owk95kby8a4ohbau', 'f29cyh05ix9awc1t5lama8nx', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:01.67651');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('c0sc2ypz4a027s99ldy0h9qi', 'f29cyh05ix9awc1t5lama8nx', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:32:01.728671');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('mug2kuyqnpft2xo0p7z6ov5s', 'vpnofhz52busrdya33kzkbvx', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:02.110292');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('ep4irbsrji1q1rzjkmllfmee', 'vpnofhz52busrdya33kzkbvx', 'a8ba5t3ozcr4vc3j6t3mbk25', '2024-02-29 09:32:02.156396');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('tbq0aq43vani726qeoyjj9ie', 'mpq3lugo6y25dz0dlrgbu5uv', 'oy45mzsgpuubqc34bjbyxzva', '2024-02-29 09:32:02.244334');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('joz5ce7ej8yorctumg5tqfdo', 'mpq3lugo6y25dz0dlrgbu5uv', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:02.287961');
INSERT INTO public.game_tags (id, game_id, tag_id, created_at) VALUES ('jfk7dtkh3mojyb2i8uhh0m6k', 'yuigzdlroot3s60opx173vfl', 'bum6fjzo8fcsizjayshnv188', '2024-02-29 09:32:02.615898');


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('fcfmf9p8szc7bvtirbv6mspn', 'counter-strike-2', 'Counter-Strike 2', 'For over two decades, Counter-Strike has offered an elite competitive experience, one shaped by millions of players from across the globe. And now the next chapter in the CS story is about to begin. This is Counter-Strike 2. A free upgrade to CS:GO, Counter-Strike 2 marks the largest technical leap in Counter-Strike’s history. Built on the Source 2 engine, Counter-Strike 2 is modernized with realistic physically-based rendering, state of the art networking, and upgraded Community Workshop tools.', true, true, '2024-01-31 10:11:58.013724', '2024-01-31 10:11:58.013724');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('cea9mnvg80esld1sa1r72zf9', 'half-life', 'Half-Life', 'Named Game of the Year by over 50 publications, Valve''s debut title blends action and adventure with award-winning technology to create a frighteningly realistic world where players must think to survive. Also includes an exciting multiplayer mode that allows you to play against friends and enemies around the world.', true, false, '2024-02-29 09:31:47.162013', '2024-02-29 09:31:47.162013');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('fd391rxpdxyqzmhefbb6fbe2', 'portal-2', 'Portal 2', 'The &quot;Perpetual Testing Initiative&quot; has been expanded to allow you to design co-op puzzles for you and your friends!', true, false, '2024-02-29 09:31:49.296352', '2024-02-29 09:31:49.296352');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('tg0q3e6d7dxclqm7uv3bpucv', 'borderlands-2', 'Borderlands 2', 'The Ultimate Vault Hunter’s Upgrade lets you get the most out of the Borderlands 2 experience.', true, false, '2024-02-29 09:31:49.841528', '2024-02-29 09:31:49.841528');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('j7yghgfukup7y3svl76jhw1w', 'terraria', 'Terraria', 'Dig, fight, explore, build! Nothing is impossible in this action-packed adventure game. Four Pack also available!', true, false, '2024-02-29 09:31:50.175718', '2024-02-29 09:31:50.175718');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('qf8zykgjbjxw7flsuny2y50z', 'castle-crashers', 'Castle Crashers', 'Hack, slash, and smash your way to victory in this award winning 2D arcade adventure from The Behemoth!', true, false, '2024-02-29 09:31:50.653404', '2024-02-29 09:31:50.653404');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('qlt3cctapjncy0ec9ytqbsap', 'payday-2', 'PAYDAY 2', 'PAYDAY 2 is an action-packed, four-player co-op shooter that once again lets gamers don the masks of the original PAYDAY crew - Dallas, Hoxton, Wolf and Chains - as they descend on Washington DC for an epic crime spree.', true, false, '2024-02-29 09:31:50.987284', '2024-02-29 09:31:50.987284');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('pqwx4n0ycrwqytp71nn7zl1r', 'euro-truck-simulator-2', 'Euro Truck Simulator 2', 'Travel across Europe as king of the road, a trucker who delivers important cargo across impressive distances! With dozens of cities to explore, your endurance, skill and speed will all be pushed to their limits.', true, false, '2024-02-29 09:31:51.602497', '2024-02-29 09:31:51.602497');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('f38uitjtevt0c9slm7w5l1p8', 'dying-light', 'Dying Light', 'First-person action survival game set in a post-apocalyptic open world overrun by flesh-hungry zombies. Roam a city devastated by a mysterious virus epidemic. Scavenge for supplies, craft weapons, and face hordes of the infected.', true, false, '2024-02-29 09:31:52.211703', '2024-02-29 09:31:52.211703');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('kmf9vqz6jhx81urb5p2qbn1d', 'rust', 'Rust', 'The only aim in Rust is to survive. Everything wants you to die - the island’s wildlife and other inhabitants, the environment, other survivors. Do whatever it takes to last another night.', true, false, '2024-02-29 09:31:52.935827', '2024-02-29 09:31:52.935827');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('ph744dcsaf4pbxx10ttlk777', 'robocraft', 'Robocraft', 'Build insane, fully customisable robot battle vehicles that drive, hover, walk and fly in the free-to-play action game Robocraft. Add weapons from the future and jump in the driving seat as you take your creation into battle against other players online!', true, false, '2024-02-29 09:31:54.463513', '2024-02-29 09:31:54.463513');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('bc1csi8bx7r75cgw2ydb5fhu', 'unturned', 'Unturned', 'You''re a survivor in the zombie infested ruins of society, and must work with your friends and forge alliances to remain among the living.', true, false, '2024-02-29 09:31:54.750303', '2024-02-29 09:31:54.750303');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('qofmi4efiqi8ab0gm6jg7ag5', 'dead-by-daylight', 'Dead by Daylight', 'Dead by Daylight is a multiplayer (4vs1) horror game where one player takes on the role of the savage Killer, and the other four players play as Survivors, trying to escape the Killer and avoid being caught and killed.', true, false, '2024-02-29 09:31:55.814498', '2024-02-29 09:31:55.814498');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('k4hgnl7zd0lubjxzcjs7ex84', 'vrchat', 'VRChat', 'Join our growing community as you explore, play, and help craft the future of social VR. Create worlds and custom avatars. Welcome to VRChat.', true, false, '2024-02-29 09:31:56.742547', '2024-02-29 09:31:56.742547');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('a6w23eo7dqbh647q1mcdkqxa', 'paladins', 'Paladins', 'Paladins is the ultimate fantasy team shooter experience, with over 50 customizable Champions fighting in 5v5 action across a diverse Realm of modes and maps!', true, false, '2024-02-29 09:31:56.838865', '2024-02-29 09:31:56.838865');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('agjzenc97b4yerbizahab1x0', 'human-fall-flat', 'Human Fall Flat', 'Human Fall Flat is a hilarious, light-hearted platformer set in floating dreamscapes that can be played solo or with up to 8 players online. Free new levels keep its vibrant community rewarded.', true, false, '2024-02-29 09:31:57.327162', '2024-02-29 09:31:57.327162');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('tasrtq9sfo3xhdw878fj4k51', 'world-of-warships', 'World of Warships', 'Immerse yourself in thrilling naval battles and assemble an armada of over 600 ships from the first half of the 20th century — from stealthy destroyers to gigantic battleships. Change the look of your ship, choose upgrades to suit your play style, and go into battle with other players!', true, false, '2024-02-29 09:31:57.854702', '2024-02-29 09:31:57.854702');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('l8ftsemea2k0if0dnbzmylqc', 'monster-hunter-world', 'Monster Hunter: World', 'Welcome to a new world! In Monster Hunter: World, the latest installment in the series, you can enjoy the ultimate hunting experience, using everything at your disposal to hunt monsters in a new world teeming with surprises and excitement.', true, false, '2024-02-29 09:31:58.37939', '2024-02-29 09:31:58.37939');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('ndwcrgr335kbg7qgo2tnd9t6', 'counter-strike-source', 'Counter-Strike: Source', 'Counter-Strike: Source blends Counter-Strike''s award-winning teamplay action with the advanced technology of Source™ technology.', true, false, '2024-02-29 09:31:47.635325', '2024-02-29 09:31:47.635325');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('mzuotpzfa6tigv7o83mye9fq', 'day-of-defeat-source', 'Day of Defeat: Source', 'Valve''s WWII Multiplayer Classic - Now available for Mac.', true, false, '2024-02-29 09:31:47.981729', '2024-02-29 09:31:47.981729');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('it8zq2ix8yoltdaj2q6dyv9z', 'the-binding-of-isaac-rebirth', 'The Binding of Isaac: Rebirth', 'The Binding of Isaac: Rebirth is a randomly generated action RPG shooter with heavy Rogue-like elements. Following Isaac on his journey players will find bizarre treasures that change Isaac’s form giving him super human abilities and enabling him to fight off droves of mysterious creatures, discover secrets and fight his way to safety.', true, false, '2024-02-29 09:31:52.59904', '2024-02-29 09:31:52.59904');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('gdbzg690avfj78j7jeqyuvzc', 'ark-survival-evolved', 'ARK: Survival Evolved', 'Stranded on the shores of a mysterious island, you must learn to survive. Use your cunning to kill or tame the primeval creatures roaming the land, and encounter other players to survive, dominate... and escape!', true, false, '2024-02-29 09:31:55.134862', '2024-02-29 09:31:55.134862');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('ie4j51aeog2tsomlqftc214j', 'counter-strike', 'Counter-Strike', 'Play the world''s number 1 online action game. Engage in an incredibly realistic brand of terrorist warfare in this wildly popular team-based game. Ally with teammates to complete strategic missions. Take out enemy sites. Rescue hostages. Your role affects your team''s success. Your team''s success affects your role.', true, false, '2024-02-29 09:31:46.749949', '2024-02-29 09:31:46.749949');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('avumbyeptd3g6mldqmw1jo7d', 'ricochet', 'Ricochet', 'Battle your friends in exciting arenas with your epic arsenal. This is a 2D fighting game that utilizes platformer and shooter mechanics. The combat is ever-changing, and the art is simple but intriguing. Ricochet is fun, fast-paced, and it keeps you on your toes.', true, false, '2024-02-29 09:31:47.017731', '2024-02-29 09:31:47.017731');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('lma09e4m027ir3xn1spekrzy', 'portal', 'Portal', 'Portal&trade; is a new single player game from Valve. Set in the mysterious Aperture Science Laboratories, Portal has been called one of the most innovative new games on the horizon and will offer gamers hours of unique gameplay.', true, false, '2024-02-29 09:31:48.569256', '2024-02-29 09:31:48.569256');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('yj7vjizwjcwp2vye4x5bhyni', 'team-fortress-2', 'Team Fortress 2', 'Nine distinct classes provide a broad range of tactical abilities and personalities. Constantly updated with new game modes, maps, equipment and, most importantly, hats!', true, false, '2024-02-29 09:31:48.715467', '2024-02-29 09:31:48.715467');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('eoqrc7fxi5csiyiwbe1qfkcd', 'left-4-dead-2', 'Left 4 Dead 2', 'Set in the zombie apocalypse, Left 4 Dead 2 (L4D2) is the highly anticipated sequel to the award-winning Left 4 Dead, the #1 co-op game of 2008. This co-operative action horror FPS takes you and your friends through the cities, swamps and cemeteries of the Deep South, from Savannah to New Orleans across five expansive campaigns.', true, false, '2024-02-29 09:31:48.858593', '2024-02-29 09:31:48.858593');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('smln9amlrmrfws6ih222fl96', 'dota-2', 'Dota 2', 'Every day, millions of players worldwide enter battle as one of over a hundred Dota heroes. And no matter if it''s their 10th hour of play or 1,000th, there''s always something new to discover. With regular updates that ensure a constant evolution of gameplay, features, and heroes, Dota 2 has taken on a life of its own.', true, false, '2024-02-29 09:31:49.099182', '2024-02-29 09:31:49.099182');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('hsxmrupvht6c1d5r8wd3p02c', 'the-tiny-bang-story', 'The Tiny Bang Story', 'Life on Tiny Planet was calm and carefree until a great disaster occurred - Tiny Planet was hit by a meteor! The world fell apart and now its future depends only on you! Use your imagination and creativity: in order to restore Tiny Planet and help its inhabitants you will have to fix a variety of machines and mechanisms as well as solve...', true, false, '2024-02-29 09:31:50.128688', '2024-02-29 09:31:50.128688');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('tg6zemcrpnhueeb22he4h2ge', 'arma-3', 'Arma 3', 'Experience true combat gameplay in a massive military sandbox. Deploying a wide variety of single- and multiplayer content, over 20 vehicles and 40 weapons, and limitless opportunities for content creation, this is the PC’s premier military game. Authentic, diverse, open - Arma 3 sends you to war.', true, false, '2024-02-29 09:31:50.318376', '2024-02-29 09:31:50.318376');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('wsr5voep92cdcocq2b9ywaiv', 'project-zomboid', 'Project Zomboid', 'Project Zomboid is the ultimate in zombie survival. Alone or in MP: you loot, build, craft, fight, farm and fish in a struggle to survive. A hardcore RPG skillset, a vast map, massively customisable sandbox and a cute tutorial raccoon await the unwary. So how will you die? All it takes is a bite..', true, false, '2024-02-29 09:31:50.558556', '2024-02-29 09:31:50.558556');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('a57g10tvdtkfic8q3om2wdsm', 'planetside-2', 'PlanetSide 2', 'PlanetSide 2 is an all-out planetary war, where thousands of players battle as one across enormous continents. Utilize infantry, ground and air vehicles, and teamwork to destroy your enemies in this revolutionary first-person shooter on a massive scale.', true, false, '2024-02-29 09:31:50.746699', '2024-02-29 09:31:50.746699');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('jrmn42bmhdbo4w57z6z9369k', 'dayz', 'DayZ', 'How long can you survive a post-apocalyptic world? A land overrun with an infected &quot;zombie&quot; population, where you compete with other survivors for limited resources. Will you team up with strangers and stay strong together? Or play as a lone wolf to avoid betrayal? This is DayZ – this is your story.', true, false, '2024-02-29 09:31:51.18013', '2024-02-29 09:31:51.18013');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('hu6egxla0rindn68ecevahde', 'no-more-room-in-hell', 'No More Room in Hell', 'The chances of you surviving this all out war of society and the undead are slim to none. Already, there are millions of the walking dead shambling about, searching for food to eat. There''s no known cure. One bite can possibly end it all for you. However, you aren''t alone in this nightmare.', true, false, '2024-02-29 09:31:51.418256', '2024-02-29 09:31:51.418256');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('lz12nfvsedzqt69ne9hcaw06', 'warframe', 'Warframe', 'Awaken as an unstoppable warrior and battle alongside your friends in this story-driven free-to-play online action game', true, false, '2024-02-29 09:31:51.879938', '2024-02-29 09:31:51.879938');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('dup89vgd8bpfn21c29skcmj3', 'war-thunder', 'War Thunder', 'War Thunder is the most comprehensive free-to-play, cross-platform, MMO military game dedicated to aviation, armoured vehicles, and naval craft, from the early 20th century to the most advanced modern combat units. Join now and take part in major battles on land, in the air, and at sea.', true, false, '2024-02-29 09:31:51.975156', '2024-02-29 09:31:51.975156');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('t7il621eck7ufj7rk97abbfk', 'among-us', 'Among Us', 'An online and local party game of teamwork and betrayal for 4-15 players...in space!', true, false, '2024-02-29 09:31:59.427642', '2024-02-29 09:31:59.427642');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('ce5tuu4x7z75tuphn094jyqv', 'new-world', 'New World', 'Explore a thrilling, open-world MMO filled with danger and opportunity where you''ll forge a new destiny on the supernatural island of Aeternum.', true, false, '2024-02-29 09:31:59.857009', '2024-02-29 09:31:59.857009');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('nb05k7725nr4fxogbprnrh3u', 'destiny-2', 'Destiny 2', 'Destiny 2 is an action MMO with a single evolving world that you and your friends can join anytime, anywhere, absolutely free.', true, false, '2024-02-29 09:31:59.99899', '2024-02-29 09:31:59.99899');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('qz1jj93yuu7zt4k0eh14veop', 'halo-infinite', 'Halo Infinite', 'From one of gaming''s most iconic sagas, Halo is bigger than ever. Featuring an expansive open-world campaign and a dynamic free to play multiplayer experience. ', true, false, '2024-02-29 09:32:01.441023', '2024-02-29 09:32:01.441023');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('f29cyh05ix9awc1t5lama8nx', 'elden-ring', 'ELDEN RING', 'THE NEW FANTASY ACTION RPG. Rise, Tarnished, and be guided by grace to brandish the power of the Elden Ring and become an Elden Lord in the Lands Between.', true, false, '2024-02-29 09:32:01.627178', '2024-02-29 09:32:01.627178');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('yuigzdlroot3s60opx173vfl', 'lethal-company', 'Lethal Company', 'A co-op horror about scavenging at abandoned moons to sell scrap to the Company.', true, false, '2024-02-29 09:32:02.56688', '2024-02-29 09:32:02.56688');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('tvq3w8mxjy1d5yq2uwjap272', 'path-of-exile', 'Path of Exile', 'You are an Exile, struggling to survive on the dark continent of Wraeclast, as you fight to earn power that will allow you to exact your revenge against those who wronged you. Path of Exile is an online Action RPG set in a dark fantasy world. The game is completely free and will never be pay-to-win.', true, false, '2024-02-29 09:31:52.072702', '2024-02-29 09:31:52.072702');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('qomcsfhl8kfxfdjbuk1dj4va', 'the-forest', 'The Forest', 'As the lone survivor of a passenger jet crash, you find yourself in a mysterious forest battling to stay alive against a society of cannibalistic mutants. Build, explore, survive in this terrifying first person survival horror simulator.', true, false, '2024-02-29 09:31:52.457719', '2024-02-29 09:31:52.457719');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('ywjp1asaghgobxbsqvgm49m4', '7-days-to-die', '7 Days to Die', '7 Days to Die is an open-world game that is a unique combination of first-person shooter, survival horror, tower defense, and role-playing games. Play the definitive zombie survival sandbox RPG that came first. Navezgane awaits!', true, false, '2024-02-29 09:31:52.697635', '2024-02-29 09:31:52.697635');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('hf8rigj4p8udweii1xv30ki1', 'rocket-league', 'Rocket League', 'Rocket League is a high-powered hybrid of arcade-style soccer and vehicular mayhem with easy-to-understand controls and fluid, physics-driven competition. Rocket League includes casual and competitive Online Matches, a fully-featured offline Season Mode, special “Mutators” that let you change the rules entirely, hockey and...', true, false, '2024-02-29 09:31:53.177731', '2024-02-29 09:31:53.177731');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('npm75y8q9rnd5oj9b5diqb4g', 'serena', 'Serena', 'How long has it been? A man sits in a distant getaway cabin waiting for his wife Serena. Where is she? Things in the cabin evoke memories, and the husband comes to a disturbing realization... This short point-and-click adventure is the result of a massive collaborative effort between dozens of fans and designers of adventure games.', true, false, '2024-02-29 09:31:53.796126', '2024-02-29 09:31:53.796126');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('hbykc1ebs6693wlewuvxe7qy', 'brawlhalla', 'Brawlhalla', 'An epic platform fighter for up to 8 players online or local. Try casual free-for-alls, ranked matches, or invite friends to a private room. And it''s free! Play cross-platform with millions of players on PlayStation, Xbox, Nintendo Switch, iOS, Android &amp; Steam! Frequent updates. Over fifty Legends.', true, false, '2024-02-29 09:31:54.282005', '2024-02-29 09:31:54.282005');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('vidt4z82r9by5jgeb0fbvrv2', 'trove', 'Trove', 'Grab your friends, hone your blades, and set off for adventure in Trove, the ultimate action MMO! Battle the forces of Shadow in realms filled with dungeons and items created by your fellow players. Whether hunting treasure or building realms of your own, it’s never been this good to be square!', true, false, '2024-02-29 09:31:54.652796', '2024-02-29 09:31:54.652796');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('iktfn8ul1rentnpd2jmxvlhf', 'hollow-knight', 'Hollow Knight', 'Forge your own path in Hollow Knight! An epic action adventure through a vast ruined kingdom of insects and heroes. Explore twisting caverns, battle tainted creatures and befriend bizarre bugs, all in a classic, hand-drawn 2D style.', true, false, '2024-02-29 09:31:55.520229', '2024-02-29 09:31:55.520229');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('z4wu29qahihgiziikj1jacqc', 'fallout-4', 'Fallout 4', 'Bethesda Game Studios, the award-winning creators of Fallout 3 and The Elder Scrolls V: Skyrim, welcome you to the world of Fallout 4 – their most ambitious game ever, and the next generation of open-world gaming.', true, false, '2024-02-29 09:31:55.615272', '2024-02-29 09:31:55.615272');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('eg9pggwe15uedi73j6y0td1f', 'smite', 'SMITE', 'Join 40+ million players in SMITE, the Battleground of the Gods! Wield Thor’s hammer, turn your foes to stone as Medusa, or flex your divine power as one of 100+ other mythological icons. Become a God and play FREE today!', true, false, '2024-02-29 09:31:56.007286', '2024-02-29 09:31:56.007286');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('djyaar9hu50keq25wvd80rmj', 'stardew-valley', 'Stardew Valley', 'You''ve inherited your grandfather''s old farm plot in Stardew Valley. Armed with hand-me-down tools and a few coins, you set out to begin your new life. Can you learn to live off the land and turn these overgrown fields into a thriving home?', true, false, '2024-02-29 09:31:56.197653', '2024-02-29 09:31:56.197653');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('i3i5i748g288fmy2t31mkwt0', 'street-warriors-online', 'Street Warriors Online', 'First, realistic PvP brawling game for up to 8 vs 8 players with original, dynamic combat system and fast, round based battles. Create and develop Your character. Earn new skills and items that helps You beat Your opponents. Gather Your friends and fight together in a clan.', true, false, '2024-02-29 09:31:56.247342', '2024-02-29 09:31:56.247342');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('h5kqdx63x67zwr3gbrfiypdp', 'z1-battle-royale', 'Z1 Battle Royale', 'Z1 Battle Royale is a Free to Play, fast-paced, action arcade, competitive Battle Royale. Staying true to its &quot;King of the Kill&quot; roots, the game has been revamped and restored to the classic feel, look, and gameplay everyone fell in love with. Play solo, duos, or fives and be the last ones standing.', true, false, '2024-02-29 09:31:56.497366', '2024-02-29 09:31:56.497366');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('tuww2m38utl2sg23g71yucp2', 'world-of-tanks-blitz', 'World of Tanks Blitz', 'Harness the power, fight, and get rewards. Join the epic confrontation of Dune: Part Two in World of Tanks Blitz!', true, false, '2024-02-29 09:31:57.082841', '2024-02-29 09:31:57.082841');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('gra8ck2o30xzhap68csccyyn', 'minion-masters', 'Minion Masters', 'An addictive fast-paced hybrid of Card games &amp; Tower-Defense. Play 1v1 - or bring a friend for 2v2 - and engage in epic online multiplayer battles full of innovative strategy and awesome plays! Collect 200+ cards with unique mechanics, all free!', true, false, '2024-02-29 09:31:57.421153', '2024-02-29 09:31:57.421153');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('u53gb56zic3u0upk8vbusdc5', 'life-is-strange-2', 'Life is Strange 2', 'After a tragic incident, brothers Sean and Daniel Diaz run away from home. Fearing the police, and dealing with Daniel''s new telekinetic power, the boys head to Mexico. Each stop on their journey brings new friends and new challenges.', true, false, '2024-02-29 09:31:57.564078', '2024-02-29 09:31:57.564078');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('yuc9c935ck6uxjlpwmts9zo0', 'black-squad', 'Black Squad', 'Black Squad is a free-to-play military first-person-shooter. Players can master their skills and show off their strategies with a wide range of game maps, modes, and weapons to choose from. Join thousands of FPS players worldwide in one of the most played games on Steam!', true, false, '2024-02-29 09:31:57.611555', '2024-02-29 09:31:57.611555');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('tss89qj0cyc4p659xd8k56ga', 'raft', 'Raft', 'Raft™ throws you and your friends into an epic oceanic adventure! Alone or together, players battle to survive a perilous voyage across a vast sea! Gather debris, scavenge reefs and build your own floating home, but be wary of the man-eating sharks!', true, false, '2024-02-29 09:31:58.48185', '2024-02-29 09:31:58.48185');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('du5g2k3itjqmm8aahuv3ny0w', 'phasmophobia', 'Phasmophobia', 'Phasmophobia is a 4 player online co-op psychological horror. Paranormal activity is on the rise and it’s up to you and your team to use all the ghost-hunting equipment at your disposal in order to gather as much evidence as you can.', true, false, '2024-02-29 09:31:58.675181', '2024-02-29 09:31:58.675181');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('qkml6ma8di7ud1uv4gkgjwds', 'valheim', 'Valheim', 'A brutal exploration and survival game for 1-10 players, set in a procedurally-generated purgatory inspired by viking culture. Battle, build, and conquer your way to a saga worthy of Odin’s patronage!', true, false, '2024-02-29 09:31:59.118472', '2024-02-29 09:31:59.118472');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('xjof0ehtx0l109c9hkertgjl', 'pubg-battlegrounds', 'PUBG: BATTLEGROUNDS', 'Play PUBG: BATTLEGROUNDS for free. Land on strategic locations, loot weapons and supplies, and survive to become the last team standing across various, diverse Battlegrounds. Squad up and join the Battlegrounds for the original Battle Royale experience that only PUBG: BATTLEGROUNDS can offer.', true, false, '2024-02-29 09:31:58.091868', '2024-02-29 09:31:58.091868');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('uzviy2mg6oujoabtbgyt2fee', 'counter-strike-condition-zero', 'Counter-Strike: Condition Zero', 'With its extensive Tour of Duty campaign, a near-limitless number of skirmish modes, updates and new content for Counter-Strike''s award-winning multiplayer game play, plus over 12 bonus single player missions, Counter-Strike: Condition Zero is a tremendous offering of single and multiplayer content.', true, false, '2024-02-29 09:31:47.399459', '2024-02-29 09:31:47.399459');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('ys1v8kjnrop631jllcwa01jy', 'half-life-2-deathmatch', 'Half-Life 2: Deathmatch', 'Fast multiplayer action set in the Half-Life 2 universe! HL2''s physics adds a new dimension to deathmatch play. Play straight deathmatch or try Combine vs. Resistance teamplay. Toss a toilet at your friend today!', true, false, '2024-02-29 09:31:48.182273', '2024-02-29 09:31:48.182273');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('qq7hhfflvczx88av8v4l6u5p', 'half-life-2-lost-coast', 'Half-Life 2: Lost Coast', 'Originally planned as a section of the Highway 17 chapter of Half-Life 2, Lost Coast is a playable technology showcase that introduces High Dynamic Range lighting to the Source engine.', true, false, '2024-02-29 09:31:48.421383', '2024-02-29 09:31:48.421383');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('ex9xn5nkq5fe0kw7zztunys7', 'the-elder-scrolls-v-skyrim', 'The Elder Scrolls V: Skyrim', 'EPIC FANTASY REBORN The next chapter in the highly anticipated Elder Scrolls saga arrives from the makers of the 2006 and 2008 Games of the Year, Bethesda Game Studios. Skyrim reimagines and revolutionizes the open-world fantasy epic, bringing to life a complete virtual world open for you to explore any way you choose.', true, false, '2024-02-29 09:31:49.985504', '2024-02-29 09:31:49.985504');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('o15cg6udbsj6loxxuoux2q6a', 'mount-and-blade-ii-bannerlord', 'Mount & Blade II: Bannerlord', 'A strategy/action RPG. Create a character, engage in diplomacy, craft, trade and conquer new lands in a vast medieval sandbox. Raise armies to lead into battle and command and fight alongside your troops in massive real-time battles using a deep but intuitive skill-based combat system.', true, false, '2024-02-29 09:31:53.464449', '2024-02-29 09:31:53.464449');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('gayl0akbtnotpk4bm8ti0erq', 'the-witcher-3-wild-hunt', 'The Witcher 3: Wild Hunt', 'You are Geralt of Rivia, mercenary monster slayer. Before you stands a war-torn, monster-infested continent you can explore at will. Your current contract? Tracking down Ciri — the Child of Prophecy, a living weapon that can alter the shape of the world.', true, false, '2024-02-29 09:31:54.369307', '2024-02-29 09:31:54.369307');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('f3794r789whpzwzdd6gftdsp', 'cities-skylines', 'Cities: Skylines', 'Cities: Skylines is a modern take on the classic city simulation. The game introduces new game play elements to realize the thrill and hardships of creating and maintaining a real city whilst expanding on some well-established tropes of the city building experience.', true, false, '2024-02-29 09:31:53.271872', '2024-02-29 09:31:53.271872');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('lv4vn4y294jrokdmllbqt6bj', 'hogwarts-legacy', 'Hogwarts Legacy', 'Hogwarts Legacy is an immersive, open-world action RPG. Now you can take control of the action and be at the center of your own adventure in the wizarding world.', true, false, '2024-02-29 09:31:59.616073', '2024-02-29 09:31:59.616073');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('p3oyg01ojynsqhusj1v7396c', 'dota-underlords', 'Dota Underlords', 'Hire a crew and destroy your rivals in this new strategy battler set in the world of Dota. Introducing Season One: Explore White Spire and earn rewards on the Battle Pass. Pick from several different game modes, play on your own or with friends, and take advantage of crossplay on PC and mobile.', true, false, '2024-02-29 09:31:59.71084', '2024-02-29 09:31:59.71084');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('diwt05re1694jxe8d4qi4lk2', 'cyberpunk-2077', 'Cyberpunk 2077', 'Cyberpunk 2077 is an open-world, action-adventure RPG set in the dark future of Night City — a dangerous megalopolis obsessed with power, glamor, and ceaseless body modification.', true, false, '2024-02-29 09:32:00.325342', '2024-02-29 09:32:00.325342');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('q7j53ynadxupmytro2nkl2sl', 'apex-legends', 'Apex Legends', 'Apex Legends is the award-winning, free-to-play Hero Shooter from Respawn Entertainment. Master an ever-growing roster of legendary characters with powerful abilities, and experience strategic squad play and innovative gameplay in the next evolution of Hero Shooter and Battle Royale.', true, false, '2024-02-29 09:32:00.61053', '2024-02-29 09:32:00.61053');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('bakfe9d5efenge1s7n4ug8ad', 'red-dead-redemption-2', 'Red Dead Redemption 2', 'Winner of over 175 Game of the Year Awards and recipient of over 250 perfect scores, RDR2 is the epic tale of outlaw Arthur Morgan and the infamous Van der Linde gang, on the run across America at the dawn of the modern age. Also includes access to the shared living world of Red Dead Online.', true, false, '2024-02-29 09:32:00.853808', '2024-02-29 09:32:00.853808');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('vpnofhz52busrdya33kzkbvx', 'lost-ark', 'Lost Ark', 'Embark on an odyssey for the Lost Ark in a vast, vibrant world: explore new lands, seek out lost treasures, and test yourself in thrilling action combat in this action-packed free-to-play RPG.', true, false, '2024-02-29 09:32:02.065011', '2024-02-29 09:32:02.065011');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('mpq3lugo6y25dz0dlrgbu5uv', 'palworld', 'Palworld', 'Fight, farm, build and work alongside mysterious creatures called &quot;Pals&quot; in this completely new multiplayer, open world survival and crafting game!', true, false, '2024-02-29 09:32:02.199523', '2024-02-29 09:32:02.199523');
INSERT INTO public.games (id, slug, name, description, is_active, is_featured, created_at, updated_at) VALUES ('zbvfaqo7m18cfpetalzaj2f2', 'naraka-bladepoint', 'NARAKA: BLADEPOINT', 'Dive into the legends of the Far East in NARAKA: BLADEPOINT; team up with friends in fast-paced melee fights for a Battle Royale experience unlike any other. Find your playstyle with a varied cast of heroes with unique skills. More than 20 million players have already joined the fray, play free now!', true, false, '2024-02-29 09:32:00.997542', '2024-02-29 09:32:00.997542');


--
-- Data for Name: offer_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xm6f8000508l47bmj1ydv', 'clt40drew000208l1hxyq6w78', 'test6', true, '2024-03-21 07:50:41.337903');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('v8kioclqpwhflyapqtcnfnfm', 'clt40drew000208l1hxyq6w78', 'asdasdasd', false, '2024-04-03 09:29:36.123631');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('k8gjipbkyo55jf7i53ke5sjv', 'clt40drew000208l1hxyq6w78', 'dgagdjadha', false, '2024-04-03 09:35:27.751056');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xmho8000808l4aw5pe56s', 'clt40drew000208l1hxyq6w78', 'test9', true, '2024-03-21 07:50:41.417086');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xmkfj000908l4a540bu3j', 'clt40drew000208l1hxyq6w78', 'test10', true, '2024-03-21 07:50:41.443445');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('har7oy0u8mcl95c1njd34716', 'xpkbwmekn8ywssnm597ro2uu', 'dsaaaaaaaaaaaaa', false, '2024-04-05 07:05:20.557062');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('hmt4xrigh9eibj30t4uiz464', 'xpkbwmekn8ywssnm597ro2uu', 'asdddddddads', false, '2024-04-05 07:05:20.557062');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('oz8ifxr2yetxgciwkngx2n3l', 'xpkbwmekn8ywssnm597ro2uu', 'adsssssssss', false, '2024-04-05 07:05:20.557062');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('qsij5weul3s49z0xlfyksx9k', 'xpkbwmekn8ywssnm597ro2uu', 'adsssssssssssss', false, '2024-04-05 07:05:20.557062');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('uetxm2h5a2pgoazls1hz1x2j', 'xpkbwmekn8ywssnm597ro2uu', 'dsaaaaaaaaaaaaaaaaa', false, '2024-04-05 07:05:20.557062');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('bll1wwywtmotozpgr4qxg5ho', 'xpkbwmekn8ywssnm597ro2uu', 'asddddddddddddd', true, '2024-04-05 07:05:20.557062');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xmpah000b08l439uk5q5v', 'clt40drew000208l1hxyq6w78', 'test12', true, '2024-03-21 07:50:41.499278');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('mjimql6yu27o9xyifrw2rbew', 'k1vkn61akb8m74fjf8jf0a0e', 'HFDYSGKULUZTR4687654T4WEGRSHJZUI7Z5EF', false, '2024-04-09 07:23:46.407219');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('muwotbkb1thzc51iok3spcuh', 'k1vkn61akb8m74fjf8jf0a0e', 'AFGRHTJKLHFSDADHJKGJR346537854312', false, '2024-04-09 07:23:46.407219');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xmyn6000e08l4a0ne8w7c', 'clt40drew000208l1hxyq6w78', 'test15', false, '2024-03-21 07:50:41.57585');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xn167000f08l4573n791w', 'clt40drew000208l1hxyq6w78', 'test16', false, '2024-03-21 07:50:41.601652');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xn3yb000g08l46j6sbjci', 'clt40drew000208l1hxyq6w78', 'test17', false, '2024-03-21 07:50:41.625939');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xn6e1000h08l4h0asb6uv', 'clt40drew000208l1hxyq6w78', 'test18', false, '2024-03-21 07:50:41.652067');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xn8xb000i08l4gvytc0er', 'clt40drew000208l1hxyq6w78', 'test19', false, '2024-03-21 07:50:41.67914');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('clu0xnbbi000j08l424vl61pf', 'clt40drew000208l1hxyq6w78', 'test20', false, '2024-03-21 07:50:41.708924');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('zd30wo757pw4pavgbkjr3pmy', 'uonosfunkjuxy2ybjw9vbcx7', 'efgh', false, '2024-03-21 11:24:45.16384');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('a11prjs6cw5kbwj1l4pam68c', 'clt40drew000208l1hxyq6w78', 'cccc', false, '2024-03-25 08:27:00.753201');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('s89t72fuknq5axvkr5pu6h3e', 'clt40drew000208l1hxyq6w78', 'aaaa', false, '2024-03-25 08:27:00.753201');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('ucjkbygx11v86us7s2te5wvi', 'clt40drew000208l1hxyq6w78', 'dddd', false, '2024-03-25 08:27:00.753201');
INSERT INTO public.offer_stock (id, offer_id, item, is_locked, created_at) VALUES ('zm946tnas9ce1n0aknpc1z2x', 'clt40drew000208l1hxyq6w78', 'bbbb', false, '2024-03-25 08:27:00.753201');


--
-- Data for Name: offer_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.offer_types (id, slug, name, description, claim_instructions, created_at) VALUES ('clt40cbgd000108l1a3rb19tz', 'steam-key', 'Steam Key', 'Steam key that can be claimed in the Steam application.', 'Claim the game key in the Steam application.', '2024-02-27 06:50:28.412996');


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('clt40drew000208l1hxyq6w78', 'fcfmf9p8szc7bvtirbv6mspn', 'e3zd119x5deie6g94ywh7vwj', 1499, true, 'clt40cbgd000108l1a3rb19tz', '2024-02-27 06:51:00.238919', '2024-02-27 06:51:00.238919');
INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('uonosfunkjuxy2ybjw9vbcx7', 'fd391rxpdxyqzmhefbb6fbe2', 'e3zd119x5deie6g94ywh7vwj', 99999, true, 'clt40cbgd000108l1a3rb19tz', '2024-03-21 11:24:14.191118', '2024-03-21 11:24:14.196336');
INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('jqqudnrfvqfyl3d08svfed0j', 'tg0q3e6d7dxclqm7uv3bpucv', 'l4byk03lzwfxplosb7x0ifch', 6666, true, 'clt40cbgd000108l1a3rb19tz', '2024-03-25 08:44:44.268942', '2024-03-25 08:44:44.269022');
INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('s77phkhp1z25yheapd875itj', 'j7yghgfukup7y3svl76jhw1w', 'l4byk03lzwfxplosb7x0ifch', 777, true, 'clt40cbgd000108l1a3rb19tz', '2024-03-25 08:45:13.72527', '2024-03-25 08:45:13.72528');
INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('gb8mpm72h7tw1xwqq27lvlj4', 'j7yghgfukup7y3svl76jhw1w', 'e3zd119x5deie6g94ywh7vwj', 100, true, 'clt40cbgd000108l1a3rb19tz', '2024-03-25 09:45:25.334406', '2024-03-25 09:45:25.338434');
INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('xaqfahlq42sqb2qnctoklzru', 'cea9mnvg80esld1sa1r72zf9', 'l4byk03lzwfxplosb7x0ifch', 100, true, 'clt40cbgd000108l1a3rb19tz', '2024-04-04 08:20:38.263408', '2024-04-04 08:20:38.26861');
INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('y51ur3h4ntlswiutf6o4h2r0', 'fcfmf9p8szc7bvtirbv6mspn', 'l4byk03lzwfxplosb7x0ifch', 255, true, 'clt40cbgd000108l1a3rb19tz', '2024-04-05 06:35:47.827112', '2024-04-05 06:35:47.831733');
INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('xpkbwmekn8ywssnm597ro2uu', 'qlt3cctapjncy0ec9ytqbsap', 'l4byk03lzwfxplosb7x0ifch', 999, true, 'clt40cbgd000108l1a3rb19tz', '2024-04-05 07:01:12.548414', '2024-04-05 07:01:12.548448');
INSERT INTO public.offers (id, game_id, seller_id, price, is_active, type, created_at, updated_at) VALUES ('k1vkn61akb8m74fjf8jf0a0e', 'pqwx4n0ycrwqytp71nn7zl1r', 'l4byk03lzwfxplosb7x0ifch', 90000, true, 'clt40cbgd000108l1a3rb19tz', '2024-04-09 07:23:24.89807', '2024-04-09 07:23:24.898129');


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: sellers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sellers (id, user_id, slug, display_name, image_url, is_verified, is_closed, created_at, updated_at) VALUES ('l4byk03lzwfxplosb7x0ifch', 'rcw2e4bjnra2yxwilmhdhpxq', 'gyurkol', 'gyurkol', 'https://ui-avatars.com/api/?name=gyurkol&background=random', false, false, '2024-03-13 07:20:13.702884', '2024-03-13 07:20:13.702884');
INSERT INTO public.sellers (id, user_id, slug, display_name, image_url, is_verified, is_closed, created_at, updated_at) VALUES ('e3zd119x5deie6g94ywh7vwj', 'kg84fblv7f1uad9g1gw7xx85', 'szabotamas', 'Szabo Tamas', 'https://ssl.gstatic.com/ui/v1/icons/mail/rfr/logo_gmail_lockup_dark_1x_r5.png', true, false, '2024-02-26 12:09:15.255784', '2024-02-26 12:09:15.255784');


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tags (id, name, created_at) VALUES ('vogylznj5gbrxmcwfdd9lu6c', 'Strategy', '2023-11-22 09:34:30.854708');
INSERT INTO public.tags (id, name, created_at) VALUES ('bum6fjzo8fcsizjayshnv188', 'Action', '2024-01-31 10:18:27.806493');
INSERT INTO public.tags (id, name, created_at) VALUES ('oy45mzsgpuubqc34bjbyxzva', 'Survival', '2024-01-31 10:18:37.998995');
INSERT INTO public.tags (id, name, created_at) VALUES ('aw1tvm2is76eu50885g6sgfk', 'FPS', '2024-01-31 10:18:47.838232');
INSERT INTO public.tags (id, name, created_at) VALUES ('vq8cs8l0k4nvyklg8g44z6sa', 'Moddable', '2024-01-31 10:18:56.813027');
INSERT INTO public.tags (id, name, created_at) VALUES ('a8ba5t3ozcr4vc3j6t3mbk25', 'PvP', '2024-01-31 10:19:15.89655');


--
-- Data for Name: user_experience; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_experience (user_id, experience) VALUES ('vdrjtzab052vnhaq49mbjrg5', 0);
INSERT INTO public.user_experience (user_id, experience) VALUES ('se788avc6m6tspeprgndo20p', 0);
INSERT INTO public.user_experience (user_id, experience) VALUES ('rcw2e4bjnra2yxwilmhdhpxq', 2018);
INSERT INTO public.user_experience (user_id, experience) VALUES ('kg84fblv7f1uad9g1gw7xx85', 29886);


--
-- Data for Name: user_refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_social; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_social (user_id, discord, steam, ubisoft, epic, origin, battlenet, created_at, updated_at) VALUES ('kg84fblv7f1uad9g1gw7xx85', NULL, NULL, NULL, NULL, NULL, NULL, '2024-03-22 07:19:18.729219', '2024-03-22 07:19:18.729219');
INSERT INTO public.user_social (user_id, discord, steam, ubisoft, epic, origin, battlenet, created_at, updated_at) VALUES ('rcw2e4bjnra2yxwilmhdhpxq', 'Test0222', NULL, NULL, NULL, NULL, NULL, '2024-03-22 07:19:23.329592', '2024-03-22 07:19:23.329592');
INSERT INTO public.user_social (user_id, discord, steam, ubisoft, epic, origin, battlenet, created_at, updated_at) VALUES ('vdrjtzab052vnhaq49mbjrg5', NULL, NULL, NULL, NULL, NULL, NULL, '2024-04-03 07:33:04.780993', '2024-04-03 07:33:04.781024');
INSERT INTO public.user_social (user_id, discord, steam, ubisoft, epic, origin, battlenet, created_at, updated_at) VALUES ('se788avc6m6tspeprgndo20p', NULL, NULL, NULL, NULL, NULL, NULL, '2024-04-05 06:58:21.308423', '2024-04-05 06:58:21.308452');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, email, username, password, role, stripe_customer_id, created_at, updated_at) VALUES ('rcw2e4bjnra2yxwilmhdhpxq', 'gyurkol@kkszki.hu', 'Test2', '$argon2id$v=19$m=65536,t=3,p=1$a3V8PzsdpdtzFRiZBx5znw$MeR12xgxEQ0PGHNy1i3Nm+S0QLstLGlYP/jrXmzKk3s', 'admin', 'cus_PWWJINdWxOyWkB', '2024-02-08 08:48:04.047202', '2024-02-08 08:48:04.047268');
INSERT INTO public.users (id, email, username, password, role, stripe_customer_id, created_at, updated_at) VALUES ('kg84fblv7f1uad9g1gw7xx85', 'szabot@kkszki.hu', 'test', '$argon2id$v=19$m=65536,t=3,p=1$3Xnc+OMdFYQ4h67Y7sG/7g$nOmma8HYnOzjGGTZpBZYLaTsSNFi23D/uqwHX9Tbilw', 'admin', 'cus_PWWCyumCRBk47t', '2024-02-08 08:40:31.92261', '2024-02-08 08:40:31.922667');
INSERT INTO public.users (id, email, username, password, role, stripe_customer_id, created_at, updated_at) VALUES ('vdrjtzab052vnhaq49mbjrg5', 'szabot+cypress@kkszki.hu', 'cypress', '$argon2id$v=19$m=65536,t=3,p=1$AWnjqENzEpGrwk2AY9Yhzw$EQdvf2r+FfEDzvGKdeV9X2mxZJ7wuAI0B8w9aMfaU3I', 'user', 'cus_Pr6WRYpx50j5ld', '2024-04-03 07:33:04.776234', '2024-04-03 07:33:04.776321');
INSERT INTO public.users (id, email, username, password, role, stripe_customer_id, created_at, updated_at) VALUES ('se788avc6m6tspeprgndo20p', 'testerteszter@gmail.com', 'Teszter03', '$argon2id$v=19$m=65536,t=3,p=1$H6L3IKXH9hJYwuDpelxcUg$rpjryTEA77xh/aQ/pPNVL8GQ6qfYyhS7sMO+KWupprc', 'user', 'cus_PrqPxrHQWcRt6G', '2024-04-05 06:58:21.247386', '2024-04-05 06:58:21.247429');


--
-- Name: email_tokens email_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_tokens
    ADD CONSTRAINT email_tokens_pkey PRIMARY KEY (email);


--
-- Name: game_images game_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_images
    ADD CONSTRAINT game_images_pkey PRIMARY KEY (id);


--
-- Name: game_tags game_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_tags
    ADD CONSTRAINT game_tags_pkey PRIMARY KEY (id);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: games games_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_slug_key UNIQUE (slug);


--
-- Name: offer_stock offer_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offer_stock
    ADD CONSTRAINT offer_stock_pkey PRIMARY KEY (id);


--
-- Name: offer_types offer_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offer_types
    ADD CONSTRAINT offer_types_name_key UNIQUE (name);


--
-- Name: offer_types offer_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offer_types
    ADD CONSTRAINT offer_types_pkey PRIMARY KEY (id);


--
-- Name: offer_types offer_types_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offer_types
    ADD CONSTRAINT offer_types_slug_key UNIQUE (slug);


--
-- Name: offers offers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: sellers sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_pkey PRIMARY KEY (id);


--
-- Name: sellers sellers_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_slug_key UNIQUE (slug);


--
-- Name: tags tags_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_name_key UNIQUE (name);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_experience user_experience_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_experience
    ADD CONSTRAINT user_experience_pkey PRIMARY KEY (user_id);


--
-- Name: user_refresh_tokens user_refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_refresh_tokens
    ADD CONSTRAINT user_refresh_tokens_pkey PRIMARY KEY (token);


--
-- Name: user_social user_social_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_social
    ADD CONSTRAINT user_social_pkey PRIMARY KEY (user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: email_tokens_token_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX email_tokens_token_idx ON public.email_tokens USING btree (token);


--
-- Name: game_images_game_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX game_images_game_id_idx ON public.game_images USING btree (game_id);


--
-- Name: game_tags_game_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX game_tags_game_id_idx ON public.game_tags USING btree (game_id);


--
-- Name: game_tags_tag_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX game_tags_tag_id_idx ON public.game_tags USING btree (tag_id);


--
-- Name: games_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_name_idx ON public.games USING btree (name);


--
-- Name: games_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX games_slug_idx ON public.games USING btree (slug);


--
-- Name: offer_stock_offer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX offer_stock_offer_id_idx ON public.offer_stock USING btree (offer_id);


--
-- Name: offer_types_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX offer_types_id_idx ON public.offer_types USING btree (id);


--
-- Name: offer_types_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX offer_types_name_idx ON public.offer_types USING btree (name);


--
-- Name: offer_types_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX offer_types_slug_idx ON public.offer_types USING btree (slug);


--
-- Name: offers_game_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX offers_game_id_idx ON public.offers USING btree (game_id);


--
-- Name: offers_price_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX offers_price_idx ON public.offers USING btree (price);


--
-- Name: offers_seller_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX offers_seller_id_idx ON public.offers USING btree (seller_id);


--
-- Name: orders_game_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_game_id_idx ON public.orders USING btree (game_id);


--
-- Name: orders_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_status_idx ON public.orders USING btree (status);


--
-- Name: orders_stripe_payment_intent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_stripe_payment_intent_id_idx ON public.orders USING btree (stripe_payment_intent_id);


--
-- Name: orders_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_user_id_idx ON public.orders USING btree (user_id);


--
-- Name: sellers_display_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sellers_display_name_idx ON public.sellers USING btree (display_name);


--
-- Name: sellers_slug_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sellers_slug_idx ON public.sellers USING btree (slug);


--
-- Name: sellers_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sellers_user_id_idx ON public.sellers USING btree (user_id);


--
-- Name: user_experience_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_experience_user_id_idx ON public.user_experience USING btree (user_id);


--
-- Name: user_refresh_tokens_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_refresh_tokens_user_id_idx ON public.user_refresh_tokens USING btree (user_id);


--
-- Name: user_social_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_social_user_id_idx ON public.user_social USING btree (user_id);


--
-- Name: users_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_email_idx ON public.users USING btree (email);


--
-- Name: users_stripe_customer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_stripe_customer_id_idx ON public.users USING btree (stripe_customer_id);


--
-- Name: users_username_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_username_idx ON public.users USING btree (username);


--
-- Name: game_images game_images_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_images
    ADD CONSTRAINT game_images_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id) ON DELETE CASCADE;


--
-- Name: game_tags game_tags_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_tags
    ADD CONSTRAINT game_tags_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id) ON DELETE CASCADE;


--
-- Name: game_tags game_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_tags
    ADD CONSTRAINT game_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: offer_stock offer_stock_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offer_stock
    ADD CONSTRAINT offer_stock_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: offers offers_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id) ON DELETE CASCADE;


--
-- Name: offers offers_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.sellers(id) ON DELETE CASCADE;


--
-- Name: offers offers_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_type_fkey FOREIGN KEY (type) REFERENCES public.offer_types(id) ON DELETE CASCADE;


--
-- Name: orders orders_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id) ON DELETE CASCADE;


--
-- Name: orders orders_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offers(id) ON DELETE CASCADE;


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sellers sellers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_experience user_experience_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_experience
    ADD CONSTRAINT user_experience_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_refresh_tokens user_refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_refresh_tokens
    ADD CONSTRAINT user_refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_social user_social_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_social
    ADD CONSTRAINT user_social_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

