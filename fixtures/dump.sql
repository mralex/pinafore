PGDMP                         v            mastodon_development    10.2    10.2 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           1262    101541    mastodon_development    DATABASE     �   CREATE DATABASE mastodon_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
 $   DROP DATABASE mastodon_development;
             nolan    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             nolan    false                        0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  nolan    false    3                        3079    12544    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false                       0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    101542    timestamp_id(text)    FUNCTION     Y  CREATE FUNCTION timestamp_id(table_name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
  DECLARE
    time_part bigint;
    sequence_base bigint;
    tail bigint;
  BEGIN
    time_part := (
      -- Get the time in milliseconds
      ((date_part('epoch', now()) * 1000))::bigint
      -- And shift it over two bytes
      << 16);

    sequence_base := (
      'x' ||
      -- Take the first two bytes (four hex characters)
      substr(
        -- Of the MD5 hash of the data we documented
        md5(table_name ||
          '69283236cfae0066ef13109248240c43' ||
          time_part::text
        ),
        1, 4
      )
    -- And turn it into a bigint
    )::bit(16)::bigint;

    -- Finally, add our sequence number to our base, and chop
    -- it to the last two bytes
    tail := (
      (sequence_base + nextval(table_name || '_id_seq'))
      & 65535);

    -- Return the time part and the sequence part. OR appears
    -- faster here than addition, but they're equivalent:
    -- time_part has no trailing two bytes, and tail is only
    -- the last two bytes.
    RETURN time_part | tail;
  END
$$;
 4   DROP FUNCTION public.timestamp_id(table_name text);
       public       nolan    false    1    3            �            1259    101543    account_domain_blocks    TABLE     �   CREATE TABLE account_domain_blocks (
    id bigint NOT NULL,
    domain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
 )   DROP TABLE public.account_domain_blocks;
       public         nolan    false    3            �            1259    101549    account_domain_blocks_id_seq    SEQUENCE     ~   CREATE SEQUENCE account_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.account_domain_blocks_id_seq;
       public       nolan    false    3    196                       0    0    account_domain_blocks_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE account_domain_blocks_id_seq OWNED BY account_domain_blocks.id;
            public       nolan    false    197            �            1259    101551    account_moderation_notes    TABLE       CREATE TABLE account_moderation_notes (
    id bigint NOT NULL,
    content text NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 ,   DROP TABLE public.account_moderation_notes;
       public         nolan    false    3            �            1259    101557    account_moderation_notes_id_seq    SEQUENCE     �   CREATE SEQUENCE account_moderation_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.account_moderation_notes_id_seq;
       public       nolan    false    3    198                       0    0    account_moderation_notes_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE account_moderation_notes_id_seq OWNED BY account_moderation_notes.id;
            public       nolan    false    199            �            1259    101559    accounts    TABLE       CREATE TABLE accounts (
    id bigint NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    secret character varying DEFAULT ''::character varying NOT NULL,
    private_key text,
    public_key text DEFAULT ''::text NOT NULL,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    salmon_url character varying DEFAULT ''::character varying NOT NULL,
    hub_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    display_name character varying DEFAULT ''::character varying NOT NULL,
    uri character varying DEFAULT ''::character varying NOT NULL,
    url character varying,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    header_file_name character varying,
    header_content_type character varying,
    header_file_size integer,
    header_updated_at timestamp without time zone,
    avatar_remote_url character varying,
    subscription_expires_at timestamp without time zone,
    silenced boolean DEFAULT false NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    header_remote_url character varying DEFAULT ''::character varying NOT NULL,
    statuses_count integer DEFAULT 0 NOT NULL,
    followers_count integer DEFAULT 0 NOT NULL,
    following_count integer DEFAULT 0 NOT NULL,
    last_webfingered_at timestamp without time zone,
    inbox_url character varying DEFAULT ''::character varying NOT NULL,
    outbox_url character varying DEFAULT ''::character varying NOT NULL,
    shared_inbox_url character varying DEFAULT ''::character varying NOT NULL,
    followers_url character varying DEFAULT ''::character varying NOT NULL,
    protocol integer DEFAULT 0 NOT NULL,
    memorial boolean DEFAULT false NOT NULL,
    moved_to_account_id bigint
);
    DROP TABLE public.accounts;
       public         nolan    false    3            �            1259    101587    accounts_id_seq    SEQUENCE     q   CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.accounts_id_seq;
       public       nolan    false    200    3                       0    0    accounts_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;
            public       nolan    false    201            �            1259    101589    admin_action_logs    TABLE     o  CREATE TABLE admin_action_logs (
    id bigint NOT NULL,
    account_id bigint,
    action character varying DEFAULT ''::character varying NOT NULL,
    target_type character varying,
    target_id bigint,
    recorded_changes text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 %   DROP TABLE public.admin_action_logs;
       public         nolan    false    3            �            1259    101597    admin_action_logs_id_seq    SEQUENCE     z   CREATE SEQUENCE admin_action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.admin_action_logs_id_seq;
       public       nolan    false    202    3                       0    0    admin_action_logs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE admin_action_logs_id_seq OWNED BY admin_action_logs.id;
            public       nolan    false    203            �            1259    101599    ar_internal_metadata    TABLE     �   CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         nolan    false    3            �            1259    101605    blocks    TABLE     �   CREATE TABLE blocks (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.blocks;
       public         nolan    false    3            �            1259    101608    blocks_id_seq    SEQUENCE     o   CREATE SEQUENCE blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.blocks_id_seq;
       public       nolan    false    3    205                       0    0    blocks_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE blocks_id_seq OWNED BY blocks.id;
            public       nolan    false    206            �            1259    101610    conversation_mutes    TABLE     �   CREATE TABLE conversation_mutes (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL
);
 &   DROP TABLE public.conversation_mutes;
       public         nolan    false    3            �            1259    101613    conversation_mutes_id_seq    SEQUENCE     {   CREATE SEQUENCE conversation_mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.conversation_mutes_id_seq;
       public       nolan    false    207    3                       0    0    conversation_mutes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE conversation_mutes_id_seq OWNED BY conversation_mutes.id;
            public       nolan    false    208            �            1259    101615    conversations    TABLE     �   CREATE TABLE conversations (
    id bigint NOT NULL,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.conversations;
       public         nolan    false    3            �            1259    101621    conversations_id_seq    SEQUENCE     v   CREATE SEQUENCE conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.conversations_id_seq;
       public       nolan    false    3    209                       0    0    conversations_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE conversations_id_seq OWNED BY conversations.id;
            public       nolan    false    210            �            1259    101623    custom_emojis    TABLE     L  CREATE TABLE custom_emojis (
    id bigint NOT NULL,
    shortcode character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    uri character varying,
    image_remote_url character varying,
    visible_in_picker boolean DEFAULT true NOT NULL
);
 !   DROP TABLE public.custom_emojis;
       public         nolan    false    3            �            1259    101632    custom_emojis_id_seq    SEQUENCE     v   CREATE SEQUENCE custom_emojis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.custom_emojis_id_seq;
       public       nolan    false    3    211            	           0    0    custom_emojis_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE custom_emojis_id_seq OWNED BY custom_emojis.id;
            public       nolan    false    212            �            1259    101634    domain_blocks    TABLE     7  CREATE TABLE domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    severity integer DEFAULT 0,
    reject_media boolean DEFAULT false NOT NULL
);
 !   DROP TABLE public.domain_blocks;
       public         nolan    false    3            �            1259    101643    domain_blocks_id_seq    SEQUENCE     v   CREATE SEQUENCE domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.domain_blocks_id_seq;
       public       nolan    false    213    3            
           0    0    domain_blocks_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE domain_blocks_id_seq OWNED BY domain_blocks.id;
            public       nolan    false    214            �            1259    101645    email_domain_blocks    TABLE     �   CREATE TABLE email_domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 '   DROP TABLE public.email_domain_blocks;
       public         nolan    false    3            �            1259    101652    email_domain_blocks_id_seq    SEQUENCE     |   CREATE SEQUENCE email_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.email_domain_blocks_id_seq;
       public       nolan    false    215    3                       0    0    email_domain_blocks_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE email_domain_blocks_id_seq OWNED BY email_domain_blocks.id;
            public       nolan    false    216            �            1259    101654 
   favourites    TABLE     �   CREATE TABLE favourites (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL
);
    DROP TABLE public.favourites;
       public         nolan    false    3            �            1259    101657    favourites_id_seq    SEQUENCE     s   CREATE SEQUENCE favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.favourites_id_seq;
       public       nolan    false    3    217                       0    0    favourites_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE favourites_id_seq OWNED BY favourites.id;
            public       nolan    false    218            �            1259    101659    follow_requests    TABLE       CREATE TABLE follow_requests (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
 #   DROP TABLE public.follow_requests;
       public         nolan    false    3            �            1259    101663    follow_requests_id_seq    SEQUENCE     x   CREATE SEQUENCE follow_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.follow_requests_id_seq;
       public       nolan    false    219    3                       0    0    follow_requests_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE follow_requests_id_seq OWNED BY follow_requests.id;
            public       nolan    false    220            �            1259    101665    follows    TABLE       CREATE TABLE follows (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
    DROP TABLE public.follows;
       public         nolan    false    3            �            1259    101669    follows_id_seq    SEQUENCE     p   CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.follows_id_seq;
       public       nolan    false    3    221                       0    0    follows_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE follows_id_seq OWNED BY follows.id;
            public       nolan    false    222            �            1259    101671    imports    TABLE     �  CREATE TABLE imports (
    id bigint NOT NULL,
    type integer NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data_file_name character varying,
    data_content_type character varying,
    data_file_size integer,
    data_updated_at timestamp without time zone,
    account_id bigint NOT NULL
);
    DROP TABLE public.imports;
       public         nolan    false    3            �            1259    101678    imports_id_seq    SEQUENCE     p   CREATE SEQUENCE imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.imports_id_seq;
       public       nolan    false    3    223                       0    0    imports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE imports_id_seq OWNED BY imports.id;
            public       nolan    false    224            �            1259    101680    invites    TABLE     Y  CREATE TABLE invites (
    id bigint NOT NULL,
    user_id bigint,
    code character varying DEFAULT ''::character varying NOT NULL,
    expires_at timestamp without time zone,
    max_uses integer,
    uses integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.invites;
       public         nolan    false    3            �            1259    101688    invites_id_seq    SEQUENCE     p   CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.invites_id_seq;
       public       nolan    false    225    3                       0    0    invites_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE invites_id_seq OWNED BY invites.id;
            public       nolan    false    226            �            1259    101690    list_accounts    TABLE     �   CREATE TABLE list_accounts (
    id bigint NOT NULL,
    list_id bigint NOT NULL,
    account_id bigint NOT NULL,
    follow_id bigint NOT NULL
);
 !   DROP TABLE public.list_accounts;
       public         nolan    false    3            �            1259    101693    list_accounts_id_seq    SEQUENCE     v   CREATE SEQUENCE list_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.list_accounts_id_seq;
       public       nolan    false    3    227                       0    0    list_accounts_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE list_accounts_id_seq OWNED BY list_accounts.id;
            public       nolan    false    228            �            1259    101695    lists    TABLE     �   CREATE TABLE lists (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.lists;
       public         nolan    false    3            �            1259    101702    lists_id_seq    SEQUENCE     n   CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lists_id_seq;
       public       nolan    false    3    229                       0    0    lists_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE lists_id_seq OWNED BY lists.id;
            public       nolan    false    230            �            1259    101704    media_attachments    TABLE     '  CREATE TABLE media_attachments (
    id bigint NOT NULL,
    status_id bigint,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    shortcode character varying,
    type integer DEFAULT 0 NOT NULL,
    file_meta json,
    account_id bigint,
    description text
);
 %   DROP TABLE public.media_attachments;
       public         nolan    false    3            �            1259    101712    media_attachments_id_seq    SEQUENCE     z   CREATE SEQUENCE media_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.media_attachments_id_seq;
       public       nolan    false    3    231                       0    0    media_attachments_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE media_attachments_id_seq OWNED BY media_attachments.id;
            public       nolan    false    232            �            1259    101714    mentions    TABLE     �   CREATE TABLE mentions (
    id bigint NOT NULL,
    status_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
    DROP TABLE public.mentions;
       public         nolan    false    3            �            1259    101717    mentions_id_seq    SEQUENCE     q   CREATE SEQUENCE mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.mentions_id_seq;
       public       nolan    false    3    233                       0    0    mentions_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE mentions_id_seq OWNED BY mentions.id;
            public       nolan    false    234            �            1259    101719    mutes    TABLE       CREATE TABLE mutes (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    hide_notifications boolean DEFAULT true NOT NULL
);
    DROP TABLE public.mutes;
       public         nolan    false    3            �            1259    101723    mutes_id_seq    SEQUENCE     n   CREATE SEQUENCE mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.mutes_id_seq;
       public       nolan    false    3    235                       0    0    mutes_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE mutes_id_seq OWNED BY mutes.id;
            public       nolan    false    236            �            1259    101725    notifications    TABLE       CREATE TABLE notifications (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint,
    from_account_id bigint
);
 !   DROP TABLE public.notifications;
       public         nolan    false    3            �            1259    101731    notifications_id_seq    SEQUENCE     v   CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public       nolan    false    3    237                       0    0    notifications_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;
            public       nolan    false    238            �            1259    101733    oauth_access_grants    TABLE     n  CREATE TABLE oauth_access_grants (
    id bigint NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying,
    application_id bigint NOT NULL,
    resource_owner_id bigint NOT NULL
);
 '   DROP TABLE public.oauth_access_grants;
       public         nolan    false    3            �            1259    101739    oauth_access_grants_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_grants_id_seq;
       public       nolan    false    3    239                       0    0    oauth_access_grants_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;
            public       nolan    false    240            �            1259    101741    oauth_access_tokens    TABLE     X  CREATE TABLE oauth_access_tokens (
    id bigint NOT NULL,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying,
    application_id bigint,
    resource_owner_id bigint
);
 '   DROP TABLE public.oauth_access_tokens;
       public         nolan    false    3            �            1259    101747    oauth_access_tokens_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_tokens_id_seq;
       public       nolan    false    3    241                       0    0    oauth_access_tokens_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;
            public       nolan    false    242            �            1259    101749    oauth_applications    TABLE     �  CREATE TABLE oauth_applications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    superapp boolean DEFAULT false NOT NULL,
    website character varying,
    owner_type character varying,
    owner_id bigint
);
 &   DROP TABLE public.oauth_applications;
       public         nolan    false    3            �            1259    101757    oauth_applications_id_seq    SEQUENCE     {   CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.oauth_applications_id_seq;
       public       nolan    false    3    243                       0    0    oauth_applications_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;
            public       nolan    false    244            �            1259    101759    preview_cards    TABLE       CREATE TABLE preview_cards (
    id bigint NOT NULL,
    url character varying DEFAULT ''::character varying NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    type integer DEFAULT 0 NOT NULL,
    html text DEFAULT ''::text NOT NULL,
    author_name character varying DEFAULT ''::character varying NOT NULL,
    author_url character varying DEFAULT ''::character varying NOT NULL,
    provider_name character varying DEFAULT ''::character varying NOT NULL,
    provider_url character varying DEFAULT ''::character varying NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    embed_url character varying DEFAULT ''::character varying NOT NULL
);
 !   DROP TABLE public.preview_cards;
       public         nolan    false    3            �            1259    101777    preview_cards_id_seq    SEQUENCE     v   CREATE SEQUENCE preview_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.preview_cards_id_seq;
       public       nolan    false    3    245                       0    0    preview_cards_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE preview_cards_id_seq OWNED BY preview_cards.id;
            public       nolan    false    246            �            1259    101779    preview_cards_statuses    TABLE     l   CREATE TABLE preview_cards_statuses (
    preview_card_id bigint NOT NULL,
    status_id bigint NOT NULL
);
 *   DROP TABLE public.preview_cards_statuses;
       public         nolan    false    3            �            1259    101782    reports    TABLE     �  CREATE TABLE reports (
    id bigint NOT NULL,
    status_ids bigint[] DEFAULT '{}'::bigint[] NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    action_taken boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    action_taken_by_account_id bigint,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.reports;
       public         nolan    false    3            �            1259    101791    reports_id_seq    SEQUENCE     p   CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reports_id_seq;
       public       nolan    false    3    248                       0    0    reports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE reports_id_seq OWNED BY reports.id;
            public       nolan    false    249            �            1259    101793    schema_migrations    TABLE     K   CREATE TABLE schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         nolan    false    3            �            1259    101799    session_activations    TABLE     �  CREATE TABLE session_activations (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_agent character varying DEFAULT ''::character varying NOT NULL,
    ip inet,
    access_token_id bigint,
    user_id bigint NOT NULL,
    web_push_subscription_id bigint
);
 '   DROP TABLE public.session_activations;
       public         nolan    false    3            �            1259    101806    session_activations_id_seq    SEQUENCE     |   CREATE SEQUENCE session_activations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.session_activations_id_seq;
       public       nolan    false    251    3                       0    0    session_activations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE session_activations_id_seq OWNED BY session_activations.id;
            public       nolan    false    252            �            1259    101808    settings    TABLE     �   CREATE TABLE settings (
    id bigint NOT NULL,
    var character varying NOT NULL,
    value text,
    thing_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    thing_id bigint
);
    DROP TABLE public.settings;
       public         nolan    false    3            �            1259    101814    settings_id_seq    SEQUENCE     q   CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public       nolan    false    3    253                       0    0    settings_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE settings_id_seq OWNED BY settings.id;
            public       nolan    false    254            �            1259    101816    site_uploads    TABLE     �  CREATE TABLE site_uploads (
    id bigint NOT NULL,
    var character varying DEFAULT ''::character varying NOT NULL,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    meta json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
     DROP TABLE public.site_uploads;
       public         nolan    false    3                        1259    101823    site_uploads_id_seq    SEQUENCE     u   CREATE SEQUENCE site_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.site_uploads_id_seq;
       public       nolan    false    3    255                       0    0    site_uploads_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE site_uploads_id_seq OWNED BY site_uploads.id;
            public       nolan    false    256                       1259    101825    status_pins    TABLE     �   CREATE TABLE status_pins (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.status_pins;
       public         nolan    false    3                       1259    101830    status_pins_id_seq    SEQUENCE     t   CREATE SEQUENCE status_pins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.status_pins_id_seq;
       public       nolan    false    3    257                       0    0    status_pins_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE status_pins_id_seq OWNED BY status_pins.id;
            public       nolan    false    258                       1259    101832    statuses    TABLE       CREATE TABLE statuses (
    id bigint DEFAULT timestamp_id('statuses'::text) NOT NULL,
    uri character varying,
    text text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    in_reply_to_id bigint,
    reblog_of_id bigint,
    url character varying,
    sensitive boolean DEFAULT false NOT NULL,
    visibility integer DEFAULT 0 NOT NULL,
    spoiler_text text DEFAULT ''::text NOT NULL,
    reply boolean DEFAULT false NOT NULL,
    favourites_count integer DEFAULT 0 NOT NULL,
    reblogs_count integer DEFAULT 0 NOT NULL,
    language character varying,
    conversation_id bigint,
    local boolean,
    account_id bigint NOT NULL,
    application_id bigint,
    in_reply_to_account_id bigint
);
    DROP TABLE public.statuses;
       public         nolan    false    274    3                       1259    101846    statuses_id_seq    SEQUENCE     q   CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.statuses_id_seq;
       public       nolan    false    3                       1259    101848    statuses_tags    TABLE     Z   CREATE TABLE statuses_tags (
    status_id bigint NOT NULL,
    tag_id bigint NOT NULL
);
 !   DROP TABLE public.statuses_tags;
       public         nolan    false    3                       1259    101851    stream_entries    TABLE     !  CREATE TABLE stream_entries (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    account_id bigint
);
 "   DROP TABLE public.stream_entries;
       public         nolan    false    3                       1259    101858    stream_entries_id_seq    SEQUENCE     w   CREATE SEQUENCE stream_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.stream_entries_id_seq;
       public       nolan    false    3    262                        0    0    stream_entries_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE stream_entries_id_seq OWNED BY stream_entries.id;
            public       nolan    false    263                       1259    101860    subscriptions    TABLE     �  CREATE TABLE subscriptions (
    id bigint NOT NULL,
    callback_url character varying DEFAULT ''::character varying NOT NULL,
    secret character varying,
    expires_at timestamp without time zone,
    confirmed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_successful_delivery_at timestamp without time zone,
    domain character varying,
    account_id bigint NOT NULL
);
 !   DROP TABLE public.subscriptions;
       public         nolan    false    3            	           1259    101868    subscriptions_id_seq    SEQUENCE     v   CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.subscriptions_id_seq;
       public       nolan    false    3    264            !           0    0    subscriptions_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;
            public       nolan    false    265            
           1259    101870    tags    TABLE     �   CREATE TABLE tags (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.tags;
       public         nolan    false    3                       1259    101877    tags_id_seq    SEQUENCE     m   CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.tags_id_seq;
       public       nolan    false    3    266            "           0    0    tags_id_seq    SEQUENCE OWNED BY     -   ALTER SEQUENCE tags_id_seq OWNED BY tags.id;
            public       nolan    false    267                       1259    101879    users    TABLE     �  CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    admin boolean DEFAULT false NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    locale character varying,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    encrypted_otp_secret_salt character varying,
    consumed_timestep integer,
    otp_required_for_login boolean DEFAULT false NOT NULL,
    last_emailed_at timestamp without time zone,
    otp_backup_codes character varying[],
    filtered_languages character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    account_id bigint NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    moderator boolean DEFAULT false NOT NULL,
    invite_id bigint
);
    DROP TABLE public.users;
       public         nolan    false    3                       1259    101893    users_id_seq    SEQUENCE     n   CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       nolan    false    3    268            #           0    0    users_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE users_id_seq OWNED BY users.id;
            public       nolan    false    269                       1259    101895    web_push_subscriptions    TABLE     6  CREATE TABLE web_push_subscriptions (
    id bigint NOT NULL,
    endpoint character varying NOT NULL,
    key_p256dh character varying NOT NULL,
    key_auth character varying NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 *   DROP TABLE public.web_push_subscriptions;
       public         nolan    false    3                       1259    101901    web_push_subscriptions_id_seq    SEQUENCE        CREATE SEQUENCE web_push_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.web_push_subscriptions_id_seq;
       public       nolan    false    3    270            $           0    0    web_push_subscriptions_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE web_push_subscriptions_id_seq OWNED BY web_push_subscriptions.id;
            public       nolan    false    271                       1259    101903    web_settings    TABLE     �   CREATE TABLE web_settings (
    id bigint NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);
     DROP TABLE public.web_settings;
       public         nolan    false    3                       1259    101909    web_settings_id_seq    SEQUENCE     u   CREATE SEQUENCE web_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.web_settings_id_seq;
       public       nolan    false    272    3            %           0    0    web_settings_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE web_settings_id_seq OWNED BY web_settings.id;
            public       nolan    false    273            �	           2604    101911    account_domain_blocks id    DEFAULT     v   ALTER TABLE ONLY account_domain_blocks ALTER COLUMN id SET DEFAULT nextval('account_domain_blocks_id_seq'::regclass);
 G   ALTER TABLE public.account_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    197    196            �	           2604    101912    account_moderation_notes id    DEFAULT     |   ALTER TABLE ONLY account_moderation_notes ALTER COLUMN id SET DEFAULT nextval('account_moderation_notes_id_seq'::regclass);
 J   ALTER TABLE public.account_moderation_notes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    199    198            
           2604    101913    accounts id    DEFAULT     \   ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);
 :   ALTER TABLE public.accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    201    200            
           2604    101914    admin_action_logs id    DEFAULT     n   ALTER TABLE ONLY admin_action_logs ALTER COLUMN id SET DEFAULT nextval('admin_action_logs_id_seq'::regclass);
 C   ALTER TABLE public.admin_action_logs ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    203    202            
           2604    101915 	   blocks id    DEFAULT     X   ALTER TABLE ONLY blocks ALTER COLUMN id SET DEFAULT nextval('blocks_id_seq'::regclass);
 8   ALTER TABLE public.blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    206    205            
           2604    101916    conversation_mutes id    DEFAULT     p   ALTER TABLE ONLY conversation_mutes ALTER COLUMN id SET DEFAULT nextval('conversation_mutes_id_seq'::regclass);
 D   ALTER TABLE public.conversation_mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    208    207            
           2604    101917    conversations id    DEFAULT     f   ALTER TABLE ONLY conversations ALTER COLUMN id SET DEFAULT nextval('conversations_id_seq'::regclass);
 ?   ALTER TABLE public.conversations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    210    209            
           2604    101918    custom_emojis id    DEFAULT     f   ALTER TABLE ONLY custom_emojis ALTER COLUMN id SET DEFAULT nextval('custom_emojis_id_seq'::regclass);
 ?   ALTER TABLE public.custom_emojis ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    212    211            
           2604    101919    domain_blocks id    DEFAULT     f   ALTER TABLE ONLY domain_blocks ALTER COLUMN id SET DEFAULT nextval('domain_blocks_id_seq'::regclass);
 ?   ALTER TABLE public.domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    214    213             
           2604    101920    email_domain_blocks id    DEFAULT     r   ALTER TABLE ONLY email_domain_blocks ALTER COLUMN id SET DEFAULT nextval('email_domain_blocks_id_seq'::regclass);
 E   ALTER TABLE public.email_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    216    215            !
           2604    101921    favourites id    DEFAULT     `   ALTER TABLE ONLY favourites ALTER COLUMN id SET DEFAULT nextval('favourites_id_seq'::regclass);
 <   ALTER TABLE public.favourites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    218    217            #
           2604    101922    follow_requests id    DEFAULT     j   ALTER TABLE ONLY follow_requests ALTER COLUMN id SET DEFAULT nextval('follow_requests_id_seq'::regclass);
 A   ALTER TABLE public.follow_requests ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    220    219            %
           2604    101923 
   follows id    DEFAULT     Z   ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);
 9   ALTER TABLE public.follows ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    222    221            '
           2604    101924 
   imports id    DEFAULT     Z   ALTER TABLE ONLY imports ALTER COLUMN id SET DEFAULT nextval('imports_id_seq'::regclass);
 9   ALTER TABLE public.imports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    224    223            *
           2604    101925 
   invites id    DEFAULT     Z   ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);
 9   ALTER TABLE public.invites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    226    225            +
           2604    101926    list_accounts id    DEFAULT     f   ALTER TABLE ONLY list_accounts ALTER COLUMN id SET DEFAULT nextval('list_accounts_id_seq'::regclass);
 ?   ALTER TABLE public.list_accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    228    227            -
           2604    101927    lists id    DEFAULT     V   ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);
 7   ALTER TABLE public.lists ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    230    229            0
           2604    101928    media_attachments id    DEFAULT     n   ALTER TABLE ONLY media_attachments ALTER COLUMN id SET DEFAULT nextval('media_attachments_id_seq'::regclass);
 C   ALTER TABLE public.media_attachments ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    232    231            1
           2604    101929    mentions id    DEFAULT     \   ALTER TABLE ONLY mentions ALTER COLUMN id SET DEFAULT nextval('mentions_id_seq'::regclass);
 :   ALTER TABLE public.mentions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    234    233            3
           2604    101930    mutes id    DEFAULT     V   ALTER TABLE ONLY mutes ALTER COLUMN id SET DEFAULT nextval('mutes_id_seq'::regclass);
 7   ALTER TABLE public.mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    236    235            4
           2604    101931    notifications id    DEFAULT     f   ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    238    237            5
           2604    101932    oauth_access_grants id    DEFAULT     r   ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_grants ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    240    239            6
           2604    101933    oauth_access_tokens id    DEFAULT     r   ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_tokens ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    242    241            9
           2604    101934    oauth_applications id    DEFAULT     p   ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);
 D   ALTER TABLE public.oauth_applications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    244    243            F
           2604    101935    preview_cards id    DEFAULT     f   ALTER TABLE ONLY preview_cards ALTER COLUMN id SET DEFAULT nextval('preview_cards_id_seq'::regclass);
 ?   ALTER TABLE public.preview_cards ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    246    245            J
           2604    101936 
   reports id    DEFAULT     Z   ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);
 9   ALTER TABLE public.reports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    249    248            L
           2604    101937    session_activations id    DEFAULT     r   ALTER TABLE ONLY session_activations ALTER COLUMN id SET DEFAULT nextval('session_activations_id_seq'::regclass);
 E   ALTER TABLE public.session_activations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    252    251            M
           2604    101938    settings id    DEFAULT     \   ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    254    253            O
           2604    101939    site_uploads id    DEFAULT     d   ALTER TABLE ONLY site_uploads ALTER COLUMN id SET DEFAULT nextval('site_uploads_id_seq'::regclass);
 >   ALTER TABLE public.site_uploads ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    256    255            R
           2604    101940    status_pins id    DEFAULT     b   ALTER TABLE ONLY status_pins ALTER COLUMN id SET DEFAULT nextval('status_pins_id_seq'::regclass);
 =   ALTER TABLE public.status_pins ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    258    257            \
           2604    101941    stream_entries id    DEFAULT     h   ALTER TABLE ONLY stream_entries ALTER COLUMN id SET DEFAULT nextval('stream_entries_id_seq'::regclass);
 @   ALTER TABLE public.stream_entries ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    263    262            _
           2604    101942    subscriptions id    DEFAULT     f   ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);
 ?   ALTER TABLE public.subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    265    264            a
           2604    101943    tags id    DEFAULT     T   ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
 6   ALTER TABLE public.tags ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    267    266            j
           2604    101944    users id    DEFAULT     V   ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    269    268            k
           2604    101945    web_push_subscriptions id    DEFAULT     x   ALTER TABLE ONLY web_push_subscriptions ALTER COLUMN id SET DEFAULT nextval('web_push_subscriptions_id_seq'::regclass);
 H   ALTER TABLE public.web_push_subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    271    270            l
           2604    101946    web_settings id    DEFAULT     d   ALTER TABLE ONLY web_settings ALTER COLUMN id SET DEFAULT nextval('web_settings_id_seq'::regclass);
 >   ALTER TABLE public.web_settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    273    272            �          0    101543    account_domain_blocks 
   TABLE DATA               X   COPY account_domain_blocks (id, domain, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    196   "�      �          0    101551    account_moderation_notes 
   TABLE DATA               o   COPY account_moderation_notes (id, content, account_id, target_account_id, created_at, updated_at) FROM stdin;
    public       nolan    false    198   ?�      �          0    101559    accounts 
   TABLE DATA               E  COPY accounts (id, username, domain, secret, private_key, public_key, remote_url, salmon_url, hub_url, created_at, updated_at, note, display_name, uri, url, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at, header_file_name, header_content_type, header_file_size, header_updated_at, avatar_remote_url, subscription_expires_at, silenced, suspended, locked, header_remote_url, statuses_count, followers_count, following_count, last_webfingered_at, inbox_url, outbox_url, shared_inbox_url, followers_url, protocol, memorial, moved_to_account_id) FROM stdin;
    public       nolan    false    200   \�      �          0    101589    admin_action_logs 
   TABLE DATA               ~   COPY admin_action_logs (id, account_id, action, target_type, target_id, recorded_changes, created_at, updated_at) FROM stdin;
    public       nolan    false    202   �	      �          0    101599    ar_internal_metadata 
   TABLE DATA               K   COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public       nolan    false    204   8      �          0    101605    blocks 
   TABLE DATA               T   COPY blocks (id, created_at, updated_at, account_id, target_account_id) FROM stdin;
    public       nolan    false    205   �      �          0    101610    conversation_mutes 
   TABLE DATA               F   COPY conversation_mutes (id, conversation_id, account_id) FROM stdin;
    public       nolan    false    207   �      �          0    101615    conversations 
   TABLE DATA               A   COPY conversations (id, uri, created_at, updated_at) FROM stdin;
    public       nolan    false    209   �      �          0    101623    custom_emojis 
   TABLE DATA               �   COPY custom_emojis (id, shortcode, domain, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at, disabled, uri, image_remote_url, visible_in_picker) FROM stdin;
    public       nolan    false    211   E      �          0    101634    domain_blocks 
   TABLE DATA               \   COPY domain_blocks (id, domain, created_at, updated_at, severity, reject_media) FROM stdin;
    public       nolan    false    213   �      �          0    101645    email_domain_blocks 
   TABLE DATA               J   COPY email_domain_blocks (id, domain, created_at, updated_at) FROM stdin;
    public       nolan    false    215         �          0    101654 
   favourites 
   TABLE DATA               P   COPY favourites (id, created_at, updated_at, account_id, status_id) FROM stdin;
    public       nolan    false    217   *      �          0    101659    follow_requests 
   TABLE DATA               k   COPY follow_requests (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    219   �      �          0    101665    follows 
   TABLE DATA               c   COPY follows (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    221         �          0    101671    imports 
   TABLE DATA               �   COPY imports (id, type, approved, created_at, updated_at, data_file_name, data_content_type, data_file_size, data_updated_at, account_id) FROM stdin;
    public       nolan    false    223   �      �          0    101680    invites 
   TABLE DATA               a   COPY invites (id, user_id, code, expires_at, max_uses, uses, created_at, updated_at) FROM stdin;
    public       nolan    false    225   �      �          0    101690    list_accounts 
   TABLE DATA               D   COPY list_accounts (id, list_id, account_id, follow_id) FROM stdin;
    public       nolan    false    227   �      �          0    101695    lists 
   TABLE DATA               G   COPY lists (id, account_id, title, created_at, updated_at) FROM stdin;
    public       nolan    false    229   �      �          0    101704    media_attachments 
   TABLE DATA               �   COPY media_attachments (id, status_id, file_file_name, file_content_type, file_file_size, file_updated_at, remote_url, created_at, updated_at, shortcode, type, file_meta, account_id, description) FROM stdin;
    public       nolan    false    231   �      �          0    101714    mentions 
   TABLE DATA               N   COPY mentions (id, status_id, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    233   �      �          0    101719    mutes 
   TABLE DATA               g   COPY mutes (id, created_at, updated_at, account_id, target_account_id, hide_notifications) FROM stdin;
    public       nolan    false    235   L      �          0    101725    notifications 
   TABLE DATA               u   COPY notifications (id, activity_id, activity_type, created_at, updated_at, account_id, from_account_id) FROM stdin;
    public       nolan    false    237   i      �          0    101733    oauth_access_grants 
   TABLE DATA               �   COPY oauth_access_grants (id, token, expires_in, redirect_uri, created_at, revoked_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    239   �      �          0    101741    oauth_access_tokens 
   TABLE DATA               �   COPY oauth_access_tokens (id, token, refresh_token, expires_in, revoked_at, created_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    241   ]?      �          0    101749    oauth_applications 
   TABLE DATA               �   COPY oauth_applications (id, name, uid, secret, redirect_uri, scopes, created_at, updated_at, superapp, website, owner_type, owner_id) FROM stdin;
    public       nolan    false    243   e      �          0    101759    preview_cards 
   TABLE DATA               �   COPY preview_cards (id, url, title, description, image_file_name, image_content_type, image_file_size, image_updated_at, type, html, author_name, author_url, provider_name, provider_url, width, height, created_at, updated_at, embed_url) FROM stdin;
    public       nolan    false    245   r�      �          0    101779    preview_cards_statuses 
   TABLE DATA               E   COPY preview_cards_statuses (preview_card_id, status_id) FROM stdin;
    public       nolan    false    247   ��      �          0    101782    reports 
   TABLE DATA               �   COPY reports (id, status_ids, comment, action_taken, created_at, updated_at, account_id, action_taken_by_account_id, target_account_id) FROM stdin;
    public       nolan    false    248   ��      �          0    101793    schema_migrations 
   TABLE DATA               -   COPY schema_migrations (version) FROM stdin;
    public       nolan    false    250   ɳ      �          0    101799    session_activations 
   TABLE DATA               �   COPY session_activations (id, session_id, created_at, updated_at, user_agent, ip, access_token_id, user_id, web_push_subscription_id) FROM stdin;
    public       nolan    false    251   ׶      �          0    101808    settings 
   TABLE DATA               Y   COPY settings (id, var, value, thing_type, created_at, updated_at, thing_id) FROM stdin;
    public       nolan    false    253   ��      �          0    101816    site_uploads 
   TABLE DATA               �   COPY site_uploads (id, var, file_file_name, file_content_type, file_file_size, file_updated_at, meta, created_at, updated_at) FROM stdin;
    public       nolan    false    255   ��      �          0    101825    status_pins 
   TABLE DATA               Q   COPY status_pins (id, account_id, status_id, created_at, updated_at) FROM stdin;
    public       nolan    false    257   ��      �          0    101832    statuses 
   TABLE DATA                 COPY statuses (id, uri, text, created_at, updated_at, in_reply_to_id, reblog_of_id, url, sensitive, visibility, spoiler_text, reply, favourites_count, reblogs_count, language, conversation_id, local, account_id, application_id, in_reply_to_account_id) FROM stdin;
    public       nolan    false    259   3�      �          0    101848    statuses_tags 
   TABLE DATA               3   COPY statuses_tags (status_id, tag_id) FROM stdin;
    public       nolan    false    261   �      �          0    101851    stream_entries 
   TABLE DATA               m   COPY stream_entries (id, activity_id, activity_type, created_at, updated_at, hidden, account_id) FROM stdin;
    public       nolan    false    262   �      �          0    101860    subscriptions 
   TABLE DATA               �   COPY subscriptions (id, callback_url, secret, expires_at, confirmed, created_at, updated_at, last_successful_delivery_at, domain, account_id) FROM stdin;
    public       nolan    false    264   l�      �          0    101870    tags 
   TABLE DATA               9   COPY tags (id, name, created_at, updated_at) FROM stdin;
    public       nolan    false    266   ��      �          0    101879    users 
   TABLE DATA                 COPY users (id, email, created_at, updated_at, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, admin, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, locale, encrypted_otp_secret, encrypted_otp_secret_iv, encrypted_otp_secret_salt, consumed_timestep, otp_required_for_login, last_emailed_at, otp_backup_codes, filtered_languages, account_id, disabled, moderator, invite_id) FROM stdin;
    public       nolan    false    268   ��      �          0    101895    web_push_subscriptions 
   TABLE DATA               k   COPY web_push_subscriptions (id, endpoint, key_p256dh, key_auth, data, created_at, updated_at) FROM stdin;
    public       nolan    false    270   ��      �          0    101903    web_settings 
   TABLE DATA               J   COPY web_settings (id, data, created_at, updated_at, user_id) FROM stdin;
    public       nolan    false    272   ��      &           0    0    account_domain_blocks_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('account_domain_blocks_id_seq', 1, false);
            public       nolan    false    197            '           0    0    account_moderation_notes_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('account_moderation_notes_id_seq', 1, false);
            public       nolan    false    199            (           0    0    accounts_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('accounts_id_seq', 3, true);
            public       nolan    false    201            )           0    0    admin_action_logs_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('admin_action_logs_id_seq', 3, true);
            public       nolan    false    203            *           0    0    blocks_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('blocks_id_seq', 1, false);
            public       nolan    false    206            +           0    0    conversation_mutes_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('conversation_mutes_id_seq', 1, false);
            public       nolan    false    208            ,           0    0    conversations_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('conversations_id_seq', 51, true);
            public       nolan    false    210            -           0    0    custom_emojis_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('custom_emojis_id_seq', 3, true);
            public       nolan    false    212            .           0    0    domain_blocks_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('domain_blocks_id_seq', 1, false);
            public       nolan    false    214            /           0    0    email_domain_blocks_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('email_domain_blocks_id_seq', 1, false);
            public       nolan    false    216            0           0    0    favourites_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('favourites_id_seq', 7, true);
            public       nolan    false    218            1           0    0    follow_requests_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('follow_requests_id_seq', 1, false);
            public       nolan    false    220            2           0    0    follows_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('follows_id_seq', 5, true);
            public       nolan    false    222            3           0    0    imports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('imports_id_seq', 1, false);
            public       nolan    false    224            4           0    0    invites_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('invites_id_seq', 1, false);
            public       nolan    false    226            5           0    0    list_accounts_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('list_accounts_id_seq', 1, false);
            public       nolan    false    228            6           0    0    lists_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('lists_id_seq', 1, false);
            public       nolan    false    230            7           0    0    media_attachments_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('media_attachments_id_seq', 9, true);
            public       nolan    false    232            8           0    0    mentions_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('mentions_id_seq', 6, true);
            public       nolan    false    234            9           0    0    mutes_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('mutes_id_seq', 1, false);
            public       nolan    false    236            :           0    0    notifications_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('notifications_id_seq', 20, true);
            public       nolan    false    238            ;           0    0    oauth_access_grants_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('oauth_access_grants_id_seq', 165, true);
            public       nolan    false    240            <           0    0    oauth_access_tokens_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('oauth_access_tokens_id_seq', 353, true);
            public       nolan    false    242            =           0    0    oauth_applications_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('oauth_applications_id_seq', 206, true);
            public       nolan    false    244            >           0    0    preview_cards_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('preview_cards_id_seq', 1, false);
            public       nolan    false    246            ?           0    0    reports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('reports_id_seq', 1, false);
            public       nolan    false    249            @           0    0    session_activations_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('session_activations_id_seq', 192, true);
            public       nolan    false    252            A           0    0    settings_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('settings_id_seq', 1, false);
            public       nolan    false    254            B           0    0    site_uploads_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('site_uploads_id_seq', 1, false);
            public       nolan    false    256            C           0    0    status_pins_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('status_pins_id_seq', 3, true);
            public       nolan    false    258            D           0    0    statuses_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('statuses_id_seq', 77, true);
            public       nolan    false    260            E           0    0    stream_entries_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('stream_entries_id_seq', 77, true);
            public       nolan    false    263            F           0    0    subscriptions_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('subscriptions_id_seq', 1, false);
            public       nolan    false    265            G           0    0    tags_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('tags_id_seq', 1, false);
            public       nolan    false    267            H           0    0    users_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('users_id_seq', 3, true);
            public       nolan    false    269            I           0    0    web_push_subscriptions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('web_push_subscriptions_id_seq', 1, false);
            public       nolan    false    271            J           0    0    web_settings_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('web_settings_id_seq', 3, true);
            public       nolan    false    273            n
           2606    101951 0   account_domain_blocks account_domain_blocks_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT account_domain_blocks_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT account_domain_blocks_pkey;
       public         nolan    false    196            q
           2606    101953 6   account_moderation_notes account_moderation_notes_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT account_moderation_notes_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT account_moderation_notes_pkey;
       public         nolan    false    198            u
           2606    101955    accounts accounts_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
       public         nolan    false    200            |
           2606    101957 (   admin_action_logs admin_action_logs_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT admin_action_logs_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT admin_action_logs_pkey;
       public         nolan    false    202            �
           2606    101959 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public         nolan    false    204            �
           2606    101961    blocks blocks_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.blocks DROP CONSTRAINT blocks_pkey;
       public         nolan    false    205            �
           2606    101963 *   conversation_mutes conversation_mutes_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT conversation_mutes_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT conversation_mutes_pkey;
       public         nolan    false    207            �
           2606    101965     conversations conversations_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_pkey;
       public         nolan    false    209            �
           2606    101967     custom_emojis custom_emojis_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY custom_emojis
    ADD CONSTRAINT custom_emojis_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.custom_emojis DROP CONSTRAINT custom_emojis_pkey;
       public         nolan    false    211            �
           2606    101969     domain_blocks domain_blocks_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY domain_blocks
    ADD CONSTRAINT domain_blocks_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.domain_blocks DROP CONSTRAINT domain_blocks_pkey;
       public         nolan    false    213            �
           2606    101971 ,   email_domain_blocks email_domain_blocks_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY email_domain_blocks
    ADD CONSTRAINT email_domain_blocks_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.email_domain_blocks DROP CONSTRAINT email_domain_blocks_pkey;
       public         nolan    false    215            �
           2606    101973    favourites favourites_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.favourites DROP CONSTRAINT favourites_pkey;
       public         nolan    false    217            �
           2606    101975 $   follow_requests follow_requests_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT follow_requests_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT follow_requests_pkey;
       public         nolan    false    219            �
           2606    101977    follows follows_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.follows DROP CONSTRAINT follows_pkey;
       public         nolan    false    221            �
           2606    101979    imports imports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.imports DROP CONSTRAINT imports_pkey;
       public         nolan    false    223            �
           2606    101981    invites invites_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.invites DROP CONSTRAINT invites_pkey;
       public         nolan    false    225            �
           2606    101983     list_accounts list_accounts_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT list_accounts_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT list_accounts_pkey;
       public         nolan    false    227            �
           2606    101985    lists lists_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.lists DROP CONSTRAINT lists_pkey;
       public         nolan    false    229            �
           2606    101987 (   media_attachments media_attachments_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT media_attachments_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT media_attachments_pkey;
       public         nolan    false    231            �
           2606    101989    mentions mentions_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT mentions_pkey;
       public         nolan    false    233            �
           2606    101991    mutes mutes_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY mutes
    ADD CONSTRAINT mutes_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.mutes DROP CONSTRAINT mutes_pkey;
       public         nolan    false    235            �
           2606    101993     notifications notifications_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.notifications DROP CONSTRAINT notifications_pkey;
       public         nolan    false    237            �
           2606    101995 ,   oauth_access_grants oauth_access_grants_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT oauth_access_grants_pkey;
       public         nolan    false    239            �
           2606    101997 ,   oauth_access_tokens oauth_access_tokens_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT oauth_access_tokens_pkey;
       public         nolan    false    241            �
           2606    101999 *   oauth_applications oauth_applications_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT oauth_applications_pkey;
       public         nolan    false    243            �
           2606    102001     preview_cards preview_cards_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY preview_cards
    ADD CONSTRAINT preview_cards_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.preview_cards DROP CONSTRAINT preview_cards_pkey;
       public         nolan    false    245            �
           2606    102003    reports reports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
       public         nolan    false    248            �
           2606    102005 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public         nolan    false    250            �
           2606    102007 ,   session_activations session_activations_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT session_activations_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT session_activations_pkey;
       public         nolan    false    251            �
           2606    102009    settings settings_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pkey;
       public         nolan    false    253            �
           2606    102011    site_uploads site_uploads_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY site_uploads
    ADD CONSTRAINT site_uploads_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.site_uploads DROP CONSTRAINT site_uploads_pkey;
       public         nolan    false    255            �
           2606    102013    status_pins status_pins_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT status_pins_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT status_pins_pkey;
       public         nolan    false    257            �
           2606    102015    statuses statuses_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT statuses_pkey;
       public         nolan    false    259            �
           2606    102017 "   stream_entries stream_entries_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT stream_entries_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT stream_entries_pkey;
       public         nolan    false    262            �
           2606    102019     subscriptions subscriptions_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
       public         nolan    false    264            �
           2606    102021    tags tags_pkey 
   CONSTRAINT     E   ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_pkey;
       public         nolan    false    266            �
           2606    102023    users users_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         nolan    false    268            �
           2606    102025 2   web_push_subscriptions web_push_subscriptions_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY web_push_subscriptions
    ADD CONSTRAINT web_push_subscriptions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.web_push_subscriptions DROP CONSTRAINT web_push_subscriptions_pkey;
       public         nolan    false    270            �
           2606    102027    web_settings web_settings_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT web_settings_pkey;
       public         nolan    false    272            �
           1259    102028    account_activity    INDEX     l   CREATE UNIQUE INDEX account_activity ON notifications USING btree (account_id, activity_id, activity_type);
 $   DROP INDEX public.account_activity;
       public         nolan    false    237    237    237            �
           1259    102029    hashtag_search_index    INDEX     ^   CREATE INDEX hashtag_search_index ON tags USING btree (lower((name)::text) text_pattern_ops);
 (   DROP INDEX public.hashtag_search_index;
       public         nolan    false    266    266            o
           1259    102030 4   index_account_domain_blocks_on_account_id_and_domain    INDEX     �   CREATE UNIQUE INDEX index_account_domain_blocks_on_account_id_and_domain ON account_domain_blocks USING btree (account_id, domain);
 H   DROP INDEX public.index_account_domain_blocks_on_account_id_and_domain;
       public         nolan    false    196    196            r
           1259    102031 ,   index_account_moderation_notes_on_account_id    INDEX     p   CREATE INDEX index_account_moderation_notes_on_account_id ON account_moderation_notes USING btree (account_id);
 @   DROP INDEX public.index_account_moderation_notes_on_account_id;
       public         nolan    false    198            s
           1259    102032 3   index_account_moderation_notes_on_target_account_id    INDEX     ~   CREATE INDEX index_account_moderation_notes_on_target_account_id ON account_moderation_notes USING btree (target_account_id);
 G   DROP INDEX public.index_account_moderation_notes_on_target_account_id;
       public         nolan    false    198            v
           1259    102033    index_accounts_on_uri    INDEX     B   CREATE INDEX index_accounts_on_uri ON accounts USING btree (uri);
 )   DROP INDEX public.index_accounts_on_uri;
       public         nolan    false    200            w
           1259    102034    index_accounts_on_url    INDEX     B   CREATE INDEX index_accounts_on_url ON accounts USING btree (url);
 )   DROP INDEX public.index_accounts_on_url;
       public         nolan    false    200            x
           1259    102035 %   index_accounts_on_username_and_domain    INDEX     f   CREATE UNIQUE INDEX index_accounts_on_username_and_domain ON accounts USING btree (username, domain);
 9   DROP INDEX public.index_accounts_on_username_and_domain;
       public         nolan    false    200    200            y
           1259    102036 +   index_accounts_on_username_and_domain_lower    INDEX     �   CREATE INDEX index_accounts_on_username_and_domain_lower ON accounts USING btree (lower((username)::text), lower((domain)::text));
 ?   DROP INDEX public.index_accounts_on_username_and_domain_lower;
       public         nolan    false    200    200    200            }
           1259    102037 %   index_admin_action_logs_on_account_id    INDEX     b   CREATE INDEX index_admin_action_logs_on_account_id ON admin_action_logs USING btree (account_id);
 9   DROP INDEX public.index_admin_action_logs_on_account_id;
       public         nolan    false    202            ~
           1259    102038 4   index_admin_action_logs_on_target_type_and_target_id    INDEX     }   CREATE INDEX index_admin_action_logs_on_target_type_and_target_id ON admin_action_logs USING btree (target_type, target_id);
 H   DROP INDEX public.index_admin_action_logs_on_target_type_and_target_id;
       public         nolan    false    202    202            �
           1259    102039 0   index_blocks_on_account_id_and_target_account_id    INDEX     |   CREATE UNIQUE INDEX index_blocks_on_account_id_and_target_account_id ON blocks USING btree (account_id, target_account_id);
 D   DROP INDEX public.index_blocks_on_account_id_and_target_account_id;
       public         nolan    false    205    205            �
           1259    102040 :   index_conversation_mutes_on_account_id_and_conversation_id    INDEX     �   CREATE UNIQUE INDEX index_conversation_mutes_on_account_id_and_conversation_id ON conversation_mutes USING btree (account_id, conversation_id);
 N   DROP INDEX public.index_conversation_mutes_on_account_id_and_conversation_id;
       public         nolan    false    207    207            �
           1259    102041    index_conversations_on_uri    INDEX     S   CREATE UNIQUE INDEX index_conversations_on_uri ON conversations USING btree (uri);
 .   DROP INDEX public.index_conversations_on_uri;
       public         nolan    false    209            �
           1259    102042 +   index_custom_emojis_on_shortcode_and_domain    INDEX     r   CREATE UNIQUE INDEX index_custom_emojis_on_shortcode_and_domain ON custom_emojis USING btree (shortcode, domain);
 ?   DROP INDEX public.index_custom_emojis_on_shortcode_and_domain;
       public         nolan    false    211    211            �
           1259    102043    index_domain_blocks_on_domain    INDEX     Y   CREATE UNIQUE INDEX index_domain_blocks_on_domain ON domain_blocks USING btree (domain);
 1   DROP INDEX public.index_domain_blocks_on_domain;
       public         nolan    false    213            �
           1259    102044 #   index_email_domain_blocks_on_domain    INDEX     e   CREATE UNIQUE INDEX index_email_domain_blocks_on_domain ON email_domain_blocks USING btree (domain);
 7   DROP INDEX public.index_email_domain_blocks_on_domain;
       public         nolan    false    215            �
           1259    102045 %   index_favourites_on_account_id_and_id    INDEX     _   CREATE INDEX index_favourites_on_account_id_and_id ON favourites USING btree (account_id, id);
 9   DROP INDEX public.index_favourites_on_account_id_and_id;
       public         nolan    false    217    217            �
           1259    102046 ,   index_favourites_on_account_id_and_status_id    INDEX     t   CREATE UNIQUE INDEX index_favourites_on_account_id_and_status_id ON favourites USING btree (account_id, status_id);
 @   DROP INDEX public.index_favourites_on_account_id_and_status_id;
       public         nolan    false    217    217            �
           1259    102047    index_favourites_on_status_id    INDEX     R   CREATE INDEX index_favourites_on_status_id ON favourites USING btree (status_id);
 1   DROP INDEX public.index_favourites_on_status_id;
       public         nolan    false    217            �
           1259    102048 9   index_follow_requests_on_account_id_and_target_account_id    INDEX     �   CREATE UNIQUE INDEX index_follow_requests_on_account_id_and_target_account_id ON follow_requests USING btree (account_id, target_account_id);
 M   DROP INDEX public.index_follow_requests_on_account_id_and_target_account_id;
       public         nolan    false    219    219            �
           1259    102049 1   index_follows_on_account_id_and_target_account_id    INDEX     ~   CREATE UNIQUE INDEX index_follows_on_account_id_and_target_account_id ON follows USING btree (account_id, target_account_id);
 E   DROP INDEX public.index_follows_on_account_id_and_target_account_id;
       public         nolan    false    221    221            �
           1259    102050    index_invites_on_code    INDEX     I   CREATE UNIQUE INDEX index_invites_on_code ON invites USING btree (code);
 )   DROP INDEX public.index_invites_on_code;
       public         nolan    false    225            �
           1259    102051    index_invites_on_user_id    INDEX     H   CREATE INDEX index_invites_on_user_id ON invites USING btree (user_id);
 ,   DROP INDEX public.index_invites_on_user_id;
       public         nolan    false    225            �
           1259    102052 -   index_list_accounts_on_account_id_and_list_id    INDEX     v   CREATE UNIQUE INDEX index_list_accounts_on_account_id_and_list_id ON list_accounts USING btree (account_id, list_id);
 A   DROP INDEX public.index_list_accounts_on_account_id_and_list_id;
       public         nolan    false    227    227            �
           1259    102053     index_list_accounts_on_follow_id    INDEX     X   CREATE INDEX index_list_accounts_on_follow_id ON list_accounts USING btree (follow_id);
 4   DROP INDEX public.index_list_accounts_on_follow_id;
       public         nolan    false    227            �
           1259    102054 -   index_list_accounts_on_list_id_and_account_id    INDEX     o   CREATE INDEX index_list_accounts_on_list_id_and_account_id ON list_accounts USING btree (list_id, account_id);
 A   DROP INDEX public.index_list_accounts_on_list_id_and_account_id;
       public         nolan    false    227    227            �
           1259    102055    index_lists_on_account_id    INDEX     J   CREATE INDEX index_lists_on_account_id ON lists USING btree (account_id);
 -   DROP INDEX public.index_lists_on_account_id;
       public         nolan    false    229            �
           1259    102056 %   index_media_attachments_on_account_id    INDEX     b   CREATE INDEX index_media_attachments_on_account_id ON media_attachments USING btree (account_id);
 9   DROP INDEX public.index_media_attachments_on_account_id;
       public         nolan    false    231            �
           1259    102057 $   index_media_attachments_on_shortcode    INDEX     g   CREATE UNIQUE INDEX index_media_attachments_on_shortcode ON media_attachments USING btree (shortcode);
 8   DROP INDEX public.index_media_attachments_on_shortcode;
       public         nolan    false    231            �
           1259    102058 $   index_media_attachments_on_status_id    INDEX     `   CREATE INDEX index_media_attachments_on_status_id ON media_attachments USING btree (status_id);
 8   DROP INDEX public.index_media_attachments_on_status_id;
       public         nolan    false    231            �
           1259    102059 *   index_mentions_on_account_id_and_status_id    INDEX     p   CREATE UNIQUE INDEX index_mentions_on_account_id_and_status_id ON mentions USING btree (account_id, status_id);
 >   DROP INDEX public.index_mentions_on_account_id_and_status_id;
       public         nolan    false    233    233            �
           1259    102060    index_mentions_on_status_id    INDEX     N   CREATE INDEX index_mentions_on_status_id ON mentions USING btree (status_id);
 /   DROP INDEX public.index_mentions_on_status_id;
       public         nolan    false    233            �
           1259    102061 /   index_mutes_on_account_id_and_target_account_id    INDEX     z   CREATE UNIQUE INDEX index_mutes_on_account_id_and_target_account_id ON mutes USING btree (account_id, target_account_id);
 C   DROP INDEX public.index_mutes_on_account_id_and_target_account_id;
       public         nolan    false    235    235            �
           1259    102062 (   index_notifications_on_account_id_and_id    INDEX     j   CREATE INDEX index_notifications_on_account_id_and_id ON notifications USING btree (account_id, id DESC);
 <   DROP INDEX public.index_notifications_on_account_id_and_id;
       public         nolan    false    237    237            �
           1259    102063 4   index_notifications_on_activity_id_and_activity_type    INDEX     }   CREATE INDEX index_notifications_on_activity_id_and_activity_type ON notifications USING btree (activity_id, activity_type);
 H   DROP INDEX public.index_notifications_on_activity_id_and_activity_type;
       public         nolan    false    237    237            �
           1259    102064 "   index_oauth_access_grants_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);
 6   DROP INDEX public.index_oauth_access_grants_on_token;
       public         nolan    false    239            �
           1259    102065 *   index_oauth_access_tokens_on_refresh_token    INDEX     s   CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);
 >   DROP INDEX public.index_oauth_access_tokens_on_refresh_token;
       public         nolan    false    241            �
           1259    102066 .   index_oauth_access_tokens_on_resource_owner_id    INDEX     t   CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);
 B   DROP INDEX public.index_oauth_access_tokens_on_resource_owner_id;
       public         nolan    false    241            �
           1259    102067 "   index_oauth_access_tokens_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);
 6   DROP INDEX public.index_oauth_access_tokens_on_token;
       public         nolan    false    241            �
           1259    102068 3   index_oauth_applications_on_owner_id_and_owner_type    INDEX     {   CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON oauth_applications USING btree (owner_id, owner_type);
 G   DROP INDEX public.index_oauth_applications_on_owner_id_and_owner_type;
       public         nolan    false    243    243            �
           1259    102069    index_oauth_applications_on_uid    INDEX     ]   CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);
 3   DROP INDEX public.index_oauth_applications_on_uid;
       public         nolan    false    243            �
           1259    102070    index_preview_cards_on_url    INDEX     S   CREATE UNIQUE INDEX index_preview_cards_on_url ON preview_cards USING btree (url);
 .   DROP INDEX public.index_preview_cards_on_url;
       public         nolan    false    245            �
           1259    102071 =   index_preview_cards_statuses_on_status_id_and_preview_card_id    INDEX     �   CREATE INDEX index_preview_cards_statuses_on_status_id_and_preview_card_id ON preview_cards_statuses USING btree (status_id, preview_card_id);
 Q   DROP INDEX public.index_preview_cards_statuses_on_status_id_and_preview_card_id;
       public         nolan    false    247    247            �
           1259    102072    index_reports_on_account_id    INDEX     N   CREATE INDEX index_reports_on_account_id ON reports USING btree (account_id);
 /   DROP INDEX public.index_reports_on_account_id;
       public         nolan    false    248            �
           1259    102073 "   index_reports_on_target_account_id    INDEX     \   CREATE INDEX index_reports_on_target_account_id ON reports USING btree (target_account_id);
 6   DROP INDEX public.index_reports_on_target_account_id;
       public         nolan    false    248            �
           1259    102074 '   index_session_activations_on_session_id    INDEX     m   CREATE UNIQUE INDEX index_session_activations_on_session_id ON session_activations USING btree (session_id);
 ;   DROP INDEX public.index_session_activations_on_session_id;
       public         nolan    false    251            �
           1259    102075 $   index_session_activations_on_user_id    INDEX     `   CREATE INDEX index_session_activations_on_user_id ON session_activations USING btree (user_id);
 8   DROP INDEX public.index_session_activations_on_user_id;
       public         nolan    false    251            �
           1259    102076 1   index_settings_on_thing_type_and_thing_id_and_var    INDEX     {   CREATE UNIQUE INDEX index_settings_on_thing_type_and_thing_id_and_var ON settings USING btree (thing_type, thing_id, var);
 E   DROP INDEX public.index_settings_on_thing_type_and_thing_id_and_var;
       public         nolan    false    253    253    253            �
           1259    102077    index_site_uploads_on_var    INDEX     Q   CREATE UNIQUE INDEX index_site_uploads_on_var ON site_uploads USING btree (var);
 -   DROP INDEX public.index_site_uploads_on_var;
       public         nolan    false    255            �
           1259    102078 -   index_status_pins_on_account_id_and_status_id    INDEX     v   CREATE UNIQUE INDEX index_status_pins_on_account_id_and_status_id ON status_pins USING btree (account_id, status_id);
 A   DROP INDEX public.index_status_pins_on_account_id_and_status_id;
       public         nolan    false    257    257            �
           1259    102079    index_statuses_20180106    INDEX     l   CREATE INDEX index_statuses_20180106 ON statuses USING btree (account_id, id DESC, visibility, updated_at);
 +   DROP INDEX public.index_statuses_20180106;
       public         nolan    false    259    259    259    259            �
           1259    102080 !   index_statuses_on_conversation_id    INDEX     Z   CREATE INDEX index_statuses_on_conversation_id ON statuses USING btree (conversation_id);
 5   DROP INDEX public.index_statuses_on_conversation_id;
       public         nolan    false    259            �
           1259    102081     index_statuses_on_in_reply_to_id    INDEX     X   CREATE INDEX index_statuses_on_in_reply_to_id ON statuses USING btree (in_reply_to_id);
 4   DROP INDEX public.index_statuses_on_in_reply_to_id;
       public         nolan    false    259            �
           1259    102082 -   index_statuses_on_reblog_of_id_and_account_id    INDEX     o   CREATE INDEX index_statuses_on_reblog_of_id_and_account_id ON statuses USING btree (reblog_of_id, account_id);
 A   DROP INDEX public.index_statuses_on_reblog_of_id_and_account_id;
       public         nolan    false    259    259            �
           1259    102083    index_statuses_on_uri    INDEX     I   CREATE UNIQUE INDEX index_statuses_on_uri ON statuses USING btree (uri);
 )   DROP INDEX public.index_statuses_on_uri;
       public         nolan    false    259            �
           1259    102084     index_statuses_tags_on_status_id    INDEX     X   CREATE INDEX index_statuses_tags_on_status_id ON statuses_tags USING btree (status_id);
 4   DROP INDEX public.index_statuses_tags_on_status_id;
       public         nolan    false    261            �
           1259    102085 +   index_statuses_tags_on_tag_id_and_status_id    INDEX     r   CREATE UNIQUE INDEX index_statuses_tags_on_tag_id_and_status_id ON statuses_tags USING btree (tag_id, status_id);
 ?   DROP INDEX public.index_statuses_tags_on_tag_id_and_status_id;
       public         nolan    false    261    261            �
           1259    102086 ;   index_stream_entries_on_account_id_and_activity_type_and_id    INDEX     �   CREATE INDEX index_stream_entries_on_account_id_and_activity_type_and_id ON stream_entries USING btree (account_id, activity_type, id);
 O   DROP INDEX public.index_stream_entries_on_account_id_and_activity_type_and_id;
       public         nolan    false    262    262    262            �
           1259    102087 5   index_stream_entries_on_activity_id_and_activity_type    INDEX        CREATE INDEX index_stream_entries_on_activity_id_and_activity_type ON stream_entries USING btree (activity_id, activity_type);
 I   DROP INDEX public.index_stream_entries_on_activity_id_and_activity_type;
       public         nolan    false    262    262            �
           1259    102088 2   index_subscriptions_on_account_id_and_callback_url    INDEX     �   CREATE UNIQUE INDEX index_subscriptions_on_account_id_and_callback_url ON subscriptions USING btree (account_id, callback_url);
 F   DROP INDEX public.index_subscriptions_on_account_id_and_callback_url;
       public         nolan    false    264    264            �
           1259    102089    index_tags_on_name    INDEX     C   CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);
 &   DROP INDEX public.index_tags_on_name;
       public         nolan    false    266            �
           1259    102090    index_users_on_account_id    INDEX     J   CREATE INDEX index_users_on_account_id ON users USING btree (account_id);
 -   DROP INDEX public.index_users_on_account_id;
       public         nolan    false    268            �
           1259    102091 !   index_users_on_confirmation_token    INDEX     a   CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);
 5   DROP INDEX public.index_users_on_confirmation_token;
       public         nolan    false    268            �
           1259    102092    index_users_on_email    INDEX     G   CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public         nolan    false    268            �
           1259    102093 !   index_users_on_filtered_languages    INDEX     X   CREATE INDEX index_users_on_filtered_languages ON users USING gin (filtered_languages);
 5   DROP INDEX public.index_users_on_filtered_languages;
       public         nolan    false    268            �
           1259    102094 #   index_users_on_reset_password_token    INDEX     e   CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);
 7   DROP INDEX public.index_users_on_reset_password_token;
       public         nolan    false    268            �
           1259    102095    index_web_settings_on_user_id    INDEX     Y   CREATE UNIQUE INDEX index_web_settings_on_user_id ON web_settings USING btree (user_id);
 1   DROP INDEX public.index_web_settings_on_user_id;
       public         nolan    false    272            z
           1259    102096    search_index    INDEX     C  CREATE INDEX search_index ON accounts USING gin ((((setweight(to_tsvector('simple'::regconfig, (display_name)::text), 'A'::"char") || setweight(to_tsvector('simple'::regconfig, (username)::text), 'B'::"char")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(domain, ''::character varying))::text), 'C'::"char"))));
     DROP INDEX public.search_index;
       public         nolan    false    200    200    200    200            3           2606    102097    web_settings fk_11910667b2    FK CONSTRAINT     }   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT fk_11910667b2 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT fk_11910667b2;
       public       nolan    false    2810    272    268                        2606    102102 #   account_domain_blocks fk_206c6029bd    FK CONSTRAINT     �   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT fk_206c6029bd FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT fk_206c6029bd;
       public       nolan    false    2677    200    196                       2606    102107     conversation_mutes fk_225b4212bb    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_225b4212bb FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_225b4212bb;
       public       nolan    false    207    200    2677            -           2606    102112    statuses_tags fk_3081861e21    FK CONSTRAINT     |   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_3081861e21 FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_3081861e21;
       public       nolan    false    261    266    2803                       2606    102117    follows fk_32ed1b5560    FK CONSTRAINT     ~   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_32ed1b5560 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_32ed1b5560;
       public       nolan    false    221    200    2677                       2606    102122 !   oauth_access_grants fk_34d54b0a33    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_34d54b0a33 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_34d54b0a33;
       public       nolan    false    239    243    2760                       2606    102127    blocks fk_4269e03e65    FK CONSTRAINT     }   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_4269e03e65 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_4269e03e65;
       public       nolan    false    200    205    2677            "           2606    102132    reports fk_4b81f7522c    FK CONSTRAINT     ~   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_4b81f7522c FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_4b81f7522c;
       public       nolan    false    248    2677    200            1           2606    102137    users fk_50500f500d    FK CONSTRAINT     |   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_50500f500d FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_50500f500d;
       public       nolan    false    268    2677    200            /           2606    102142    stream_entries fk_5659b17554    FK CONSTRAINT     �   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT fk_5659b17554 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT fk_5659b17554;
       public       nolan    false    2677    200    262            	           2606    102147    favourites fk_5eb6c2b873    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_5eb6c2b873 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_5eb6c2b873;
       public       nolan    false    2677    217    200                       2606    102152 !   oauth_access_grants fk_63b044929b    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_63b044929b FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_63b044929b;
       public       nolan    false    268    239    2810                       2606    102157    imports fk_6db1b6e408    FK CONSTRAINT     ~   ALTER TABLE ONLY imports
    ADD CONSTRAINT fk_6db1b6e408 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.imports DROP CONSTRAINT fk_6db1b6e408;
       public       nolan    false    223    200    2677                       2606    102162    follows fk_745ca29eac    FK CONSTRAINT     �   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_745ca29eac FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_745ca29eac;
       public       nolan    false    200    221    2677                       2606    102167    follow_requests fk_76d644b0e7    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_76d644b0e7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_76d644b0e7;
       public       nolan    false    219    200    2677                       2606    102172    follow_requests fk_9291ec025d    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_9291ec025d FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_9291ec025d;
       public       nolan    false    219    200    2677                       2606    102177    blocks fk_9571bfabc1    FK CONSTRAINT     �   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_9571bfabc1 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_9571bfabc1;
       public       nolan    false    200    205    2677            %           2606    102182 !   session_activations fk_957e5bda89    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_957e5bda89 FOREIGN KEY (access_token_id) REFERENCES oauth_access_tokens(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_957e5bda89;
       public       nolan    false    251    241    2756                       2606    102187    media_attachments fk_96dd81e81b    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_96dd81e81b FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_96dd81e81b;
       public       nolan    false    231    2677    200                       2606    102192    mentions fk_970d43f9d1    FK CONSTRAINT        ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_970d43f9d1 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_970d43f9d1;
       public       nolan    false    200    233    2677            0           2606    102197    subscriptions fk_9847d1cbb5    FK CONSTRAINT     �   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_9847d1cbb5 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT fk_9847d1cbb5;
       public       nolan    false    2677    200    264            )           2606    102202    statuses fk_9bda1543f7    FK CONSTRAINT        ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_9bda1543f7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_9bda1543f7;
       public       nolan    false    259    2677    200            !           2606    102207     oauth_applications fk_b0988c7c0a    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT fk_b0988c7c0a FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT fk_b0988c7c0a;
       public       nolan    false    268    243    2810            
           2606    102212    favourites fk_b0e856845e    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_b0e856845e FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_b0e856845e;
       public       nolan    false    2790    217    259                       2606    102217    mutes fk_b8d8daf315    FK CONSTRAINT     |   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_b8d8daf315 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_b8d8daf315;
       public       nolan    false    200    235    2677            #           2606    102222    reports fk_bca45b75fd    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_bca45b75fd FOREIGN KEY (action_taken_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_bca45b75fd;
       public       nolan    false    200    248    2677                       2606    102227    notifications fk_c141c8ee55    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_c141c8ee55 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_c141c8ee55;
       public       nolan    false    2677    200    237            *           2606    102232    statuses fk_c7fa917661    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_c7fa917661 FOREIGN KEY (in_reply_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_c7fa917661;
       public       nolan    false    200    259    2677            '           2606    102237    status_pins fk_d4cb435b62    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_d4cb435b62 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_d4cb435b62;
       public       nolan    false    257    2677    200            &           2606    102242 !   session_activations fk_e5fda67334    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_e5fda67334 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_e5fda67334;
       public       nolan    false    268    2810    251                       2606    102247 !   oauth_access_tokens fk_e84df68546    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_e84df68546 FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_e84df68546;
       public       nolan    false    268    241    2810            $           2606    102252    reports fk_eb37af34f0    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_eb37af34f0 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_eb37af34f0;
       public       nolan    false    248    2677    200                       2606    102257    mutes fk_eecff219ea    FK CONSTRAINT     �   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_eecff219ea FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_eecff219ea;
       public       nolan    false    200    235    2677                        2606    102262 !   oauth_access_tokens fk_f5fc4c1ee3    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_f5fc4c1ee3 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_f5fc4c1ee3;
       public       nolan    false    241    2760    243                       2606    102267    notifications fk_fbd6b0bf9e    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_fbd6b0bf9e FOREIGN KEY (from_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_fbd6b0bf9e;
       public       nolan    false    200    2677    237                       2606    102272    accounts fk_rails_2320833084    FK CONSTRAINT     �   ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_2320833084 FOREIGN KEY (moved_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.accounts DROP CONSTRAINT fk_rails_2320833084;
       public       nolan    false    2677    200    200            +           2606    102277    statuses fk_rails_256483a9ab    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_256483a9ab FOREIGN KEY (reblog_of_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_256483a9ab;
       public       nolan    false    259    259    2790                       2606    102282    lists fk_rails_3853b78dac    FK CONSTRAINT     �   ALTER TABLE ONLY lists
    ADD CONSTRAINT fk_rails_3853b78dac FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.lists DROP CONSTRAINT fk_rails_3853b78dac;
       public       nolan    false    200    2677    229                       2606    102287 %   media_attachments fk_rails_3ec0cfdd70    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_rails_3ec0cfdd70 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_rails_3ec0cfdd70;
       public       nolan    false    259    2790    231                       2606    102292 ,   account_moderation_notes fk_rails_3f8b75089b    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_3f8b75089b FOREIGN KEY (account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_3f8b75089b;
       public       nolan    false    200    2677    198                       2606    102297 !   list_accounts fk_rails_40f9cc29f1    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_40f9cc29f1 FOREIGN KEY (follow_id) REFERENCES follows(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_40f9cc29f1;
       public       nolan    false    227    221    2716                       2606    102302    mentions fk_rails_59edbe2887    FK CONSTRAINT     �   ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_rails_59edbe2887 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_rails_59edbe2887;
       public       nolan    false    2790    259    233                       2606    102307 &   conversation_mutes fk_rails_5ab139311f    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_rails_5ab139311f FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_rails_5ab139311f;
       public       nolan    false    2696    209    207            (           2606    102312    status_pins fk_rails_65c05552f1    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_rails_65c05552f1 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_rails_65c05552f1;
       public       nolan    false    257    259    2790                       2606    102317 !   list_accounts fk_rails_85fee9d6ab    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_85fee9d6ab FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_85fee9d6ab;
       public       nolan    false    2677    227    200            2           2606    102322    users fk_rails_8fb2a43e88    FK CONSTRAINT     �   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_8fb2a43e88 FOREIGN KEY (invite_id) REFERENCES invites(id) ON DELETE SET NULL;
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_rails_8fb2a43e88;
       public       nolan    false    268    2723    225            ,           2606    102327    statuses fk_rails_94a6f70399    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_94a6f70399 FOREIGN KEY (in_reply_to_id) REFERENCES statuses(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_94a6f70399;
       public       nolan    false    259    259    2790                       2606    102332 %   admin_action_logs fk_rails_a7667297fa    FK CONSTRAINT     �   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT fk_rails_a7667297fa FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT fk_rails_a7667297fa;
       public       nolan    false    2677    200    202                       2606    102337 ,   account_moderation_notes fk_rails_dd62ed5ac3    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_dd62ed5ac3 FOREIGN KEY (target_account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_dd62ed5ac3;
       public       nolan    false    200    198    2677            .           2606    102342 !   statuses_tags fk_rails_df0fe11427    FK CONSTRAINT     �   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_rails_df0fe11427 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_rails_df0fe11427;
       public       nolan    false    2790    259    261                       2606    102347 !   list_accounts fk_rails_e54e356c88    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_e54e356c88 FOREIGN KEY (list_id) REFERENCES lists(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_e54e356c88;
       public       nolan    false    2731    229    227                       2606    102352    invites fk_rails_ff69dbb2ac    FK CONSTRAINT     ~   ALTER TABLE ONLY invites
    ADD CONSTRAINT fk_rails_ff69dbb2ac FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.invites DROP CONSTRAINT fk_rails_ff69dbb2ac;
       public       nolan    false    225    2810    268            �      x������ � �      �      x������ � �      �      x���GϫZ�@ǧŝ�n��+�9�`�	��������z��:|�GޒU�]Uk�F~d}��/�Ǐ��|^���,���a�O�������W��2��2C�w�6y��'�=kD^4�܉�@x��
H���"a"^	J������'~GPk��P;+"�>��Ϥ���q�v*���" `�>�Vn�q� 7�"��N�&��c"�����%#ܽ�Y�f6E= :�CF��U��hZ�*�?f 	ĭ�b�@�ȍ ��g?n���~�٨zOp�,��,(�/ ���s8�۞@uy�쵋<ӧn�	4�Po$d���*�/��PF!$�r�O���d�ѨM&�$j:��I��2Vp�x ��U�[�p�V$�P���0��m��_o�,� �F1����+���b�F�X��Y��|��d��`�F02dP-��^�⚝�	,ѧ{N�:�z8x�W]�27���5@�ĻܢD���`'�c4��6}p�QÑF�j���ChwW�ah5 M�ڥ!r��Ff�<G@>���9���m8_�2�5n��X��pg �̀ڳ[�q�D`��=��Y��q���[�7+�E2�0ɿmk��00_@�z���h8z��'�X���ܴ��;�,��ę�l�^�L�����^��y7�|u�v�>Ƴy���N��Fd��+�f�ڱ��"��M�a<����&*	�8�W7�s�)�4+��q�0��i9�l�9�G�\,O�Ns��8�SSy��Iı,b�3L�<��hsg��K�M����F����5D3���۬�ls>D��W̷t�^].����$2I�+����IR�n�G*��yľx)G��,oE����ܞ�w�i��A�G�Y�NE���p\��X���H�����OΡ��L���]��]A��I�E��
�t���'�)��T.�hІ�����W�t�{<�W"f�O�#�խ�в�:��>�=�w�L�-��T�7�Äyj#�}ԕ�f4������Bw.�����mP �u�[o�h���}�E8�&Z�q��_cfx7�$✝.�\�N�(ٳ�
a5�`�sgrנ��!7��Y}O�i]��މ5;�[�����j�Ć��5��8E���ߖ|�G{���C��H�\)����|��y.V�b�+��S�Dy��dE0Q���}֋盫�]��i�Xȁm����=J�j
����W�I�@�"��һ2F���7�e�s*��M� �ee�RdQ{_ظ=�{����+�yuܓ��$K���(�V,�[��^�Tz��ӛ���m�!2� ����������p�j�u:�O�EXU��3���w2�ee%�)5�V;���������W�6����S�Qe����+Zg�z,�R�>s�J�i�"I�\g��L������w�����w�����w�����w�����w�����_8�9�׃@0�W�+L�S�����7��0�j�z.g������������\t�������u����?��4���[�=:��,)fde؈�Ñ����IZ-��q0�n]��f���
�a$��Xg��""D-Y�j��a�g d�n.�)X{u��>���o!UAr	p
��������{����gǜ��'����0H��������x)+�!��V��(g�O�H�s!*�ѧf7ȹ�{�ܟN����W��.��*z{�Ni�m���s�Oh�L�8�a���85����HL��x�6�Q�E�=FP�g�Q@1�w���eJEI=����'��#�G1��R`�>?3�-}H��	Z�����]]�E�e1�j}�º�1�ybi�`�{'�<�+�ȿ��럲�����VN�E)�H"	T�i}�U'�J�Jl/��-qߊ�WGf�}�:ֻ�}��$M�^M���#7d��(P���`�:���9	��nx���^102p��8�N��<���U)Q���Z	j�|�?W0x��d�[�X���J^]��{	�͢�<r�{�j�?N�����-��nc"�Jq��&H�j��s���Fa���r�i���q��23�������צ�B�-K)�T�W��ޮ
��}�P�6�IƋ_��c;r$���4~K��� �r�a�@�W�a�rR`�#�.℔�޹�!�X絲�m�?���%�a�"Ϧ�IiE�q���L���C����{�xP�]��{��o�����1�s���p!-�M��S��A#�e-��*�1wU�jV̓t�`Z�K��A�aI^��7�3���t8�dѫ�{dϝi�ā��[dP� c������m]ǆ�ƿ���Cz�pq��U���|�f���N|�U��fJ�}Բ�8ԏ�h���r�8F�Ol{3��M�~��V��:�8�{��`$��豧F���ɤ=ڑI�O�O�	o�D�i����""� ��0� �m�N��F���}���G�@}��h�Ǔi�b��c��K4���w���W�8�b��c�i��uA
f�3�˘,V��&�m��o?�BW��&Ϭ�(��5Qt`�g�P ct�����jm3���9��W�ӷ���y+�|f9��p�����x��E}��m�V+�c�؛��''aX눫�3��E���[�oBS��5YM��)��?�7$dCڪ�l�++�6�<N5���{�+���0��d34�i�3��F�]"%f7�H$e"��F�6�L����m��fx��a�HI�����;�]���a�!�e�_0�;{u_1�;����}�`��+�}�`W��}�� �w���S�G��ץ?�>q��O��x'm���K��?�g��V��#��a��b6�V?�S��x"�ƞS)/���|J*��n[�g �*�̊��q��mme>�R����P�1(���Y��	~|u5:�Kc���b���(�r�J3u+ʹ�n(�֣�G��n�;������/�k��X��k0�F��]�Nv��f��{e�d���ҽ�)�N�C]�/��jI}�����k�iKh���D�������������P��Y-\rQ�E�a�_��ik�6#D���m;׽u�`zϷ6Ol ,Q�b�탣��G�:���7XIb����
@�0�WZ(��gi�ʉ�L*O5�l`)�����t�y�J�!��\��Ʃ� H�Co1MSBq�`��֗Y�띰ɺ@�[���<�����X(�L�>}��5\���Q���MYWN~	K <�g�6����[�|��sr�hP�90��(��[o��p2>Opx��=W[�1���h�x�hU�Ǹ��&�W����7Γ��Ƨ5�O�����G[͖?�≵�a�8xLc�,�p>����9HT%��>Ƚ�q��9�R�x���PtR�R:�!^�n{���b\�/�ro뫛Y�3>ZE�G�)�C'����}�I��U��ܓ�p��yc0�&h��W����ĝ��,.��O"���9�Y+�(�[8蒿9�u�r���������v�~�g;?�ٿdc���f�f;)C+0�@2ފK�L�$u�j�p&&��O9�lk7[#Zq�a�6]٪A!��%Q� q Q�e�Dl����H�R�\�w-d)q�xp:.�*����)?O�F��ʏ�Xz�A����#P���Kt��a9�L�a���,�}��;�����`x��ςP��?��#A/� �;qz���r}jA���w\F���xfѶ�}��p���n6�Kѷ�5�l9��t�͒�M��r�y�ú<&So���ӮRz��J�0�y:N{�vA���ڣ	 LvtxN7�x��B���kkMA�oJ�bb�pp}��������)���Bt?�45��j�(Ug�'Ѝ�KQ�U�Ǚ�hB���0���-�����M�Z�^dh�Cvv�z��6�R9���s�>����%qE�=DͿ'u'2��^��T����������Sc�"���B僡�ղ�1�%
���s��!#��\�]1�-U*!͏x2��Ci�� u}���XE���2_�|xc�i���G�k�_��;����~}�^�H���C�W���C�W���C��������ف��a�o?��!���?!>���    �������/���      �   �  x�ݔ�N�@���)ƍ��fv��	Ԙ��h�����>�M�Q�IM���^Ν���Ȭ�t���j�k��[�0L��"��W�󥫴BE�
��V�ɍULM���S�������q[-�����?�`x���oͽy�a8�[}h+HVe�W���+ֺ���f�����dJݘF���wV����
�D1IB�BL�
ǊɈ�t?Z_��t���l�޷\�r~{s5Jތ����Q�M�	�y�%���b��?��8������ �C^��3tfw�n��{��Qۘހ736kM��;�|7@�lj/!�`�/��N�Iwp�op�����9�ē�$>�\F��X�S��)��=�:��^��dϏR���d;<�w<�~ڏ'��sSv4:E���ⓡ!b������R�K)H� ^�p�r      �   ?   x�K�+�,���M�+�LI-K��/ ��-t�t--������M�LM�Hq��qqq ��h      �      x������ � �      �      x������ � �      �   t  x�}��q$!E��(��)�Bh����vU���.�Gw�|�������O��KG���"���"El)�Zo6���	r�`���㨶���F4p�jQ>C�GG�]e����h.D���Ą|�w�unZ����>��qVZD��3~1�ɭ�����>������&��RM�{�c�|�9dL��#�ƫ��%zlf,�YUܒE}��VU�uO�49 b�Ux�1�mg� �UD���h�7"A^UA66ׁ�|#��xqo>8�Y=�yU��T��	�
������GH�Uŭ~:�k� l��&�$p�"�FqT�f�o߂H�Q�נ�N�F$�(��\���%�9r��ބ��|ͧ������.�yLކ׊H�OU ��f�; R�����9|�.���bi]��m�"VUA-L�	*�>�XU��3�_��Xe���ٷy�"R`U�ӥ�[`��+"VUA5}�|�+"^�4��)�n�ȀWWAV3J�ۚD����@���[WD�۫���e~5�ը6D� כ��>9���ΎZؘ6�,޲u��.�h}��`Cdf�ڙΩ|@d	���ĕ��;̖<�%�9�l���U,�k��}7"���G�      �   �   x�}�M
�@F�3���&���x����������tl����Ń���5��Й���<��m�3��@� C>� ����(g94X9���<�n�����4̼�@������x�P��Ĭ���4�C�MC����D$$%"�'fM(���Z<\�      �      x������ � �      �      x������ � �      �   �   x�}���0�ai���Z���Èc�'`0���,��.�w��>Q#C��
ɭ^j���nң��2�4-�Ыպf�Y�K������B�V���B~`1`�*��dN�P���v��`l̜QR
:~�&�p�����[��}��(�d�����>�ZW),M�1��	
=eq      �      x������ � �      �   r   x�}���0�Rn��GD���������h�eGl�R��C<���]ފ')[Vh�[ɍ��J�8Sm��^��V��)�п�'�k۟
>��An�^�f��_�� #o:<      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�ՖOS�H���OA�'�=���7l�I�
�TQ�$���oR|�m� �Y��TmT>���߼�VT12���!D 5�[(�/�)2}9��4�.��HA`N���6؆��C��F�K�5hGb��H^#Y�:�[�����m��p���`������nƣ�u:I:_��q��H:��l&�xt�L:�a3Y��I')��$�I���Ƞ��B g�%w/?����#��!:��P��|��Y���@�!��W����eq݂��2�� ��1Y�b�3?��ڒ� �֑�Z����B�ѻ��?�|>��S{���_������#
-|DJޣ�8�@!M�s�E�֑�#�z���2�� *���mlu�$��U���E�ٞ������a/�R�)Rx����m������)R�~���[�)I�H��W��"/�2p�QYa��X���:�X:�тfo��4%r����W��lg9�v�mx�s�֝��=�0V����T���bŶr�/��m���ā����2�`�1��)�G;�b�����H�f/*��C\�����o��t�^�[�j�A4���d�	[�^�j+�%T������G���9��"�z:'u;΋٫��SD���e-4��F�J�=6%@켑y|�8�
�rv���]���3�1��]e�r�r�E���Q�5JL�diY���=���e����B��<��ԉ&L\4��H���6���t|m�/�γaN{���	ק�� �A��T\��S��&�Hk����I;i����ٻF7)��Q�~��K$�PK?S������n�x4�G;[;�w2����z�\ɑr��k���%©�F ��U"�Cg
 �c��	|���E0�qdKM�0���E�V�A��<_�>�uoz�^o������*	��[��?a�      �   �   x�}��	1�Q��=��Z�q`B|�f���v+����*��0�d9Qz�L��HAmɷU
��]�j;ҫ������`����ٻ��R%���a�i6%F���-"���Y�b�wAsd[Dq����eX����P��"z"zHyV�      �      x������ � �      �   ~  x�}�=n1Fk�)�&�+�:@�TiӸpa���ھ���xwVj�y�'�)*T~�_^Ο������Dل)�V_!*�qቄ&�xh]�B�t�ϧ���������g�Dݢ�;���d�9�X��A{�n�r�B�R��6�<!6�&,�,V��l^t"�����K�%�%�z�Du��HF�K�s�bs�8�k�s����ԹF*��.��P�4� ��,������v��ԫ����a�1���?ϗ�;��0��h���u����9X��q8�Q��0֘��k�
�"����~�1�ʚ {ҝ��G�u����Ā*F�'��v����I�
����B=��b���t�롴+4&����J`h��B�����"m���*�Ss���7l���'y      �      x���[re9n���FQ�)^@�� ���W�#:���������l��VvG�$(%b�Z�l��Rv.c�>c�իfI1�0r/m�*q/�b]b��"��=W�Kʜ���=���?���������������Oq.�����Ͽ��?���/�����������Ηs��|�-�O���<s
1惩>}�f����o����s����׿���?�Gx��K��սC�.���!DU�2�\Z�n��4皒/í�אB��@���Cr�́����rt�����˻:z�B_c�QZ��ɪ%̨3��Kqo7ݥ��w^ij�w��קj�.ME�_99q@�1#Yu�ҝ��4iкZQ)9-�i�w%��}Wז8[�m�O/.�p4��>����1$�Xvj���,��\CDF)����>�=���<��[jqn���?%�\�Ѥ�%��f�C+��3M�zۭ��X�1|����uH�C1���Dc.�}�v@>C~J���e"�|'���x�im	�Ej�1��y�aΕj��_XE��S�WBn�p 姫Dk=�B)�����(��J���2G/��)�ٹ.I�ԩ"y���vq'���d�W��rہD�|:����D=�RO���J{��C��Ig^<oqLOݽ�UB�#.B('�C�OVDWZ��Ϙ����M8�j<9��}x�H��*���r�d�[�39RçH���}�;���d
���֚Ԩ�@HU��=�.S�����Fg�Gj�D'_Sn�M�:8;Bw��C^���V�P���8c#xo{�?]y2��}������TH�a��gE�v�ݥ6��^{����8S����XD����� ��O�PH�[\�*��S!��>>�V�l)����Q\��ֆ2P�J*����jrԢ���+>�r�e�CD�o��2*��Cc�_�JY;	��ͭ[��6l�3@-2��%1ӒW��v?ʧ�O_Kyct/N�8y`p�Ӄ��n�\��;:Fك���t�qc�-�8��L
Ã�&jt*q��= �B��V�.K
�`��>Z �;����{8���!o��XR_~�D�6%�� ��I��p �'<%�7Ft�(�������g< kG��k/�o��u������)m�E�ظ���W�U7~��DU�^GS5f=y`�L�%^����G�#|A�ja+�3��ؚ��]�>W���X�Lf�'<�'^|4��?9`���ûj�M)�e���l:G}�䈔�C�ф�j�I���aP���������6��RkL��(�rp���ҳ�B`>X����KB�9R݆�3�A�x+R
A���cr�Ƀ�h˚Ny,���j�}���PUrv��@^	4���?��עV��^���GI�,�_��gP
�wRt���W��@.qeԊ���S}e�{�f� ȯ�"hT�	���'�qؗ�p���DOY�7AY���T�� ,�Y���RS5ѕ�Z�_��#Q��&�J�w`u��uy�v׃�>�{&�X�.�_��\,'8d$&�2�&�'D�,8n� �H#��HT�f���
�t 1��6��H��>�w�~����x��i�5��͎�ką!���qe��OQ�ƻ�u���)	ąz(m�.ES�3���L����Z��9�G���)���D����C#���9�
ͩ%qW�O� �&Ƹ��%j�D[9����z�7�7�����uϊ��Ց�}�et>��r�&�ˀY�e_h8R��Tn{�?C`R)߫�˔Ը��cE���胶�B������K��L� �`�*YIl{í{Κc @n#2�$T\��}��/S@y�S&'cE�L
��cӋ�L[l>$��Q׮Tk"�_j
��]��9ww{�Q���)���h�B�|'��3���.��Tg{� �i���Z�	y��35V�myJ��A�A����䗉j�z��hW4���ׁ�'S\:�f�����P��.�o�ɐb� ��)<���b�O���90^��D�;���@B�_dI%̽�ڧ��y�#h��g�e��ˍə�'���z�˔�f9��@g��yb>��#f�_�.d@��ڲt�>�zq�P'7S�!��'�n�"�I���#��唌�F����e��/�xؖ#'"�y5o���:j�+�D@�U �	�t�9���>/M�o~B-K�.�_&�|8�R50���{��x� ��eNtBi[�dk/���od�����+& �WZ���{S�VY��m
.S��1�̢	d�b�TL7��5 A�ۨ�Uj�>�h���4�u�Y��u�^�HFޞ�ZS�R3������P34f����P�mdD���[�7����֬�b������l��k����)��$�w0{���r�2S����P�RȤ�� �[��k�"[�*�f�av�����@����]�=�Y�/o��f"�5��dSgR��T�{��*�DuAQ�����pS(P��d����aK��f�p�O�l{/y4U[�:z`X�($FJS��m�9���ݵ�(7{L	e8	��5bHF�2&��<�t$�֣�,��T��ep��l+�@vƵ-�+!/��<rK�GY�	'�!�"/l��D$yBT����	�����z1������R�����,( ]14Q�	vxF'�`w[�m<l�EG��큀[�\ޔ��W"KN\Q����kV�7��r��%7�w��6�V?:��xsѝP�^��9 �h�>��o�LFd�Pe���R7��2S[$��<��R�f:���H |����w�7k�5L�8TY��\���1"Df%�[��:u+�I�פ ����&�������2�V�p��
�f�L6ex4	�Y�+�,t�ԁYz[�������6�vC@���,�W����2�߷y5E�ŧm��mݘI��hIGRa��ˁ��rH]6�	:�� ��7�L��Rhg�u/n��,�>��F�`\@�����s�`�I�_��MRA�[c�i�z.cf��b�x00w�1]�&X�~�I g����x��Q4+�������%��=S�r�"�Am���&-l�#Mn{P?]zVhc~�֘R����!@B]~D{�n@9�PRͶ���P`q�8�ڄ���$�k͓���<]��n.��0:yp��X����>�P���f�:#���G�]��fꄒ871���D$�yK�-�.,���R[3u�9<{
�my�3)a�u�1?m�`�S(V=#�~`
�gL�|�飉����UJ!E���Ћ�3=nm��������Q���"FP���|M�G�(�g�A�7Jq�P�r;��a+�i��D���C������Q�8{�^J���ݡ �����w=xa�����gҾLU!�'Zg�>Rzl���:\R(��%Ht�u�Il:ɭ�r����L�6�ާ�]Kf0yS���B���ό�:���l������đ�^���|���@�}��Z�"D���vo�v3��a�A�1��Datz��b�4A�F��&������F�ȍ�F�i5o�N�bm��v���|¸ɬf4%_� P8��<8)*W����v�*����
���$�깈� 4HN��֛t��-��z��ɧ�� ��r4����(E��A}��(�}5;w�
<ªiڢv�qd�$��^�a��F�q̺Csi��}���� ���1��$��9��cu�N����nMЪS�W��4 �
�,R�P��$ם�l+m�<�s�6�3��%��bv�RTM�(�̷����%7������2����Ma�\#����c�j�_\�?��{�Ty�E���(�x(�v�?�j��Q��rm5�R<;���CEMo�O�8A�k,����u��4���C?�S&W�d�Fm>��k��+UR�q��vv����]3�����a�QR:�)������m�Q�����j���H�i[�ԡ�����!�|�۳�D���ٲ霮��uSļZ�8�r4A}��vC>���Mz!&g`l1��T�.9�V �^A۵�̣C�*ž,��evہb�kxg��R��^g����ب���Ƞ.$'�X{Ҽl�"F�d���0;ڱ8X4�g    N5*���Y>���mv�"O�X�-9>4?(�<�>m�(��aI�ȶ#�b	��; �%������f�|��m.ٗ�[4������j���3"YY\-zpK=��S.S���� j������[E�7�Pm9�;*۱d���N���;��xIj:���P#K�,o-S�m鷸��v�1B�$�N��8�|�/�R��b�ov��y�:�KBe��'��v��Nvlx�X��2�-�Ks� xP:���m��NZ�7�]�q �)��3�H5���q��"+.rFV$�~/[H)RP�����_-���/~�[CQ�m��A~,���ɝ2�m��,h��	���6�H��n�9�C�(�S�f�;�F^���<Q׮�M�e�Ji?ςAo6���6D�P5��aCE��[X�au�P���)�wo���V|�HB�^�^&����,(�Ao��G�?bhSM>�"��
Op��������n��mH�Ŗ~ru�|�?fJpP����e��/�H�-�i-KZR2BdG� ����4�B���߻�j�:�(IS�.'_&�K��`���1�Vy�����ь2�.3�5pb�� ��!h�dG2�tӅ��d��|��I�8�م�S~d���PՔ{�v�Rۣ�R�ް'$�F�s�u.�tL��\�JM"߹��PjP�z��vi?ryؚ:�%�!�e��X�a�����c�\��4ӵҲ��%h�]O���]T�^e�K*�m��eR����uZ�#��Xd,H-��Tc������ �R�1�4��Ř��nz��5Nf��}��L�T�ӱ^�ڊ{t�@6Q9��p�h�z*8��A�3i ݋����ga���.�\�K���f����������͎^�$PxWt$��_Y	ޗ��B ���	n�G��۸`'��32���_&�����_vlZ�\����٬v��V�4/��w����Î������Y���ƃZ��������7d+v�K�/��_~R�}_�W������u�h�Ė^D[�vM��������2�q�#��{��C4Ϸ�K�"�JE�Ȃ�Tش����њ}Ex�/�zÃ��s6��Q��	��5A����D��)쏒�(� �R����
���g*�EB1�Y>��k����M[����5NJ�3������T��AJv���s��D]Ev�U�u�T�f�$oeg�N�m�˵I,��n��k��[v�dJ�_\������n�ɼ��!�vB�0��X�5�K�q�v�b ���"T�����;z�k��M���kI��l��R��*Ņ�@]z�nD��eK*��`G�!���
�����Z�\g��N	f8��@���k{�%L�*��
������l�7V��M6EY�ޥS�P��|[<�-�0����Jw��5�r	3�[ ]����#6��"�{lE��F2�lp�����m�W�
�VH�or]-�8�����׾*��K@�~��������$�u��\C̶����f�i[iv00�1"��I��fݐ?��Лw���@%��9��dx��c��t�]�tv��GT@$z^-��F�(躀��"�Q�K�*�˶�Y*���}�
� �*��L➔[ ���u��|�{Y��ይvr8��Z~v��3�H�Aa���n�����h�2Z]*�-�.S.��>\��s����ñe尽�2y��A�y�$���`ݺc�3!���"�m�}�^]H��d��Z�ɐ�f�0��t�O�V�;�׶H!�vD���lv!�low��޾�.Kv�=!�k��+�����V��^;M�:�ɫ��P?������Mdg�؅��m��\���;\�k�p�d�h*���IG/��AE�^&��1� �[c��rJ��C8v��3#�:K�#�������bV{�:��n�����Ӻ���=��e�(� Ȩ�0��7)#�r��h-Al��#�*do����鹵���|:P����f
OG ����R�k*�s��p��R��NW�5W2���U��w�a7�=R�l��B��N�T�Hf"��=ȣ�UC����V�d��[
mR���
E����m��m�M��H�p!�#��F3.SP���&]-s��F�8MJl��m�꺓 S�����v����r�������AX�}�5�����6�I�\��(7D�����eW�l�n1�C�S��X�#�v����)�0�~kW�k��$��r_&J�O��Wۜ�HՈ�ܛ����LR��sF��0F�A�Pg˰{�H	��SMk�uۅj�}��Z���d��7Y�����<V�~W3��U.*��$Y����)���Ɍz�V�|`����i��Y���|��e�7�c��jb���m�	�
{��rqK�:;�N�,�<�و��}T��7 y�v��ےuǽ!��N��e�깁8-dg�n-�\E3�)(��l����W��x�.�׎ ��J]wN�~4�������xv�y��n���"&@��N��nA!���u�����jh�	5+�.2]%�BC^�9��Ŭ�����;��J����o�t��깐�D&�iE�s���K�ԋ)��GXY���LI���������@���0��p�� ��,��9`�S~a[-m��;��y�"vy��5�M�ręǅ��{�l��<?@����_�ה^&�<�b�r����z�QGD�v��H�hpC<��nQ��ډ���NK�������(�7��K��6�l�؎)Z��\��LCG@�g���v2�饷" 'xP���.��	m�ԧ���ma�2����3,�����U[��RP �d6�9^�-��D���e͛�K�-�~]Č(A���$\&�nrG^-����R#�a��Q�nk{��K7�$��¸!9�d�V��O�v�j�W�GS�Z�w�2�L�6x���|^ګ�I�����U"�z����b���p�b{�0>4uAm������#�;�����=�<�N�UW}z�%�����iWw>;��f��j[l�O(V���P�,v�\���L_�����N�^�
l��jѧ�*��J��7b�̵��*(��
	Q�3��\�*З<�4l�}�Ni�"�$�|�d�2�j���u?aHj�C��?�]^�ʎ��m
q��M���
w��H}4�΄6���ˤ��>��<�5�Hv�BS��.@Y'��hHd����Yv��� G�%[��A�k�v���H~h3��5�:��I/����e;��9@��}�Q�����Y�N�[��1GVG�.lH��`"����`"��z�z�Z�؂�P��/<"PnwGf����N\Q�\������	��t?�������Okzޒ�2)�#I�Ք�V4:g'���m���d�bk�x툺���ZN�mN�K++����R�.SP(����R������F$��E���EX`q�ِ	���''��K���$���z�}�����a6���P�L�:Q��՗��F\�.�A�d̾r��Ne)\����,�`⎪;�wA+���Yv)~�����W�}����G��� �Wl^����F��?;[�J��xZ�gA��-����䐇K�w��>F�����0�2ٹ�KF��K�45Je$�G�Np�]�XP���vP*�|�����`�����p��.rll����`W���Z���n�M���25�7R�^U�rUH��Nv�0��S5�y+K���]:��j��s�r�۷뜌�B�l�'�>����j����]�|�f���@��?)�6����a����g���^���#O��p��[\��-k��H�	腚[�d8��7��m��������2M;oG_�v���i*T�	��m�uJ��Rt��r��)ͺ�n�.���`���0���|��p��5�je��(�=�a���g#~�oњ{�]Z`�T��i�����u�k�������L��돼�j�����=m;}êS��Z����QBC~��tN5�0kh?��}��׫\��7s�]�{�뱑��:��V�S���b�\�l � L  �Xўȣ�DB����_� �m�@N�-D���{]�L��y�7����� ��m_٭/z��v�o�a����C4�j7ƌ�Rnu�}��}e�ȡKv3X�7����V��*_�܀A)��RdS�=�jG
[7K����P'��\�Z&~�5A~|v�m��2A6���Տ�Î2dk 1]ر�imԣ]�v�H�-&!g����& w;o��hK�Z�߼-��������)=O���է�V�Kh�*�Ѷ;mIezAfǅŤ\�#���ݖA� �Z�hc�%��>X��J�I`���WS[ݶ�Q�L�^�R'�jR,k�=�b[�Ht��ȷ�	�Zc�`��{k¯�Ft?�ݗ�)[O�#�ȯ���sM�$�]�4�F 7�f��Xuj��1��N���쮶:iv��}ۇl7F�xW�b)[y��s��Z��
��	��{k����ֆ�i ��m����j�W_�`�Hv�s܏���c�Rs8���|���1b�b���`|0���C���!pr�i�����Z��P��˷�f�Z����?��5U	�yu!��S��d���b��p�ܓ���	���J��D���P�aP?��\�p��i���s]��z9w_�7g[j��,n���kh�mM�(riX�<J�թ����V�GS�C �|�0N�ղj�U�]�w��IW�.�.�~C\k��Gu��5pam�	�����zȥ�	���ǟ��Sv�
�l/4Y� 1uWw�QWAm���$�A=Re�X70h2ϵ1o]�z�_��L
~��/Sed�K��ҍ�@�o�Cs�6;k��%֝�(F��nm�)$pE��殓��˭K�_�6R�Kf�f�:��|�t����)-7���:(dt�u��ed[cB�b�6e�F୻��~ć��Pr��s�e20=s���1�<3�溳�RP��Oܲ��w��J�Ⱥ�G������2�qۇp��G)o�t��w���Xy���p����^�`�j��[�m-�𯋝�(��C���pvW�Ɖ�	��$_�b�o}ѣ)W�/>�𪭶�������"��f�*p�L����~�JBnȲJ����(aہ��>$kWnw4�&{��q��j�b>깬��jg��'��e$1�Y3�m�8��Ğ���ǃ[ZoS�����Cy+���;"p��(�����3��C�#J�z�2Dx����UU��`�C,�+��>P���e�)��l���W��/�6���9�2���dS>]��?Hq_w(�z��l0ek�s���� �h�͋)��⼚w��r%�AA����R�$7�z�L��s&�E	�N{_Kt�L��n�5��������)ۅ�c�:���;[�U�h6�,����b�OA�z ���u��iׅn���#����ʻ�Im��jW_/�"[������n�j�P�Xz��D�$c��mpפ����W�[ݙ���wR�
�V����1u�6$���=�&��|n�ɝ���R����n���u�Ў�h����?���%��[��Lbנ���j�a{
��J���7���yR��h��v���۶ʃ�d'oi֩����p_q�lu2��oӐ�ݨs^��T��C����B�#e�������֟�R��;b&�Z͈i(�u+ϱ�{)�k��A�Y�fJ��G�чW:�5�1����j�n��-�� a�W��Z�.���{�����,���)2�Hޑ�2	_��C����ao�Bz����T�+Unk�����b˨#��ᇽ�.�C�v��>
��i����%�n<���'.4V�P�(��@���NՉ���`o���T�n Y�楦�:�j�C�Y#�{�����V�ux���$�Nc�ZS����j,�����NJ^k;�b3/�"�J[����l��v����@J���˄T�㙶pu$��){{��)�G���պ"��v�m���L�`����l>B/���ҭn�_�k�s��M9��Z�>\TC�QS��ݻ��F����^b�9���gC<|σl�u��kJ����~sb�]!?�>i�Ձ�öp�pЉRV�Þm���W�4�'¢�,�5S�¹�t�:�-{�b n���X��C9�������3zT���~||�q��O      �      x�}�[�e9���O��@$��1�A��
ECM���=��nmόt"=<��%�u1��}����ۨ+�j��Nc�SN��Խ���>c[�}�c������?���_���o.�����폅?ξ)����w_�����_�{����������_�Sr�uN�-��˚!��{�b}o�[!��ψ�����Lя�R9������1�ǻo������Ӫ���sq6]�.F�+��Sn?�i&�_}�a����/�[��XS�/���?1�Ā}��v�-7[�3����5��R��m?���v�+�YbOu�t����'�׹����[���|r�{��DָZK=�9�v�Ė\����u��;{�i)�y���۟�1_�m��>��r�aZǕ��ٙ-����wL��tVr+sᘏĢ�gy�m����כcSo�W����j���sV�9%�C��nu3�c�[��]>'��٨SW���h9����>���[�n��w�@�hya�ͳW����.-L�T��'낋}:!Xg�	�>f}�@����ӗ��{g���cn�9˲Ȳ��6"|�N�Ts�.es�,5�s�P�`۾������슅�����rǝ�����D��N�=�5����R��՜�7��@�Y3�M �����t�~�5��ia�|;�J#�J��&�[d��)�=Gn<z�q�k1M�Y��>~P����[����oPǹ2W/)�$��lz���6i�L�t[a��7?���9��ux�?}S5_�W�1�Fν�aw�-���R�v�����CH��ٟ	��6�.��P^�/�}��
���/(��r���:Y����5���'$w��pw��g�n1M�08��<^6��M������?D�>F��sZ��d~;g\�f=���R�s��[����lru���� k)޲/(�C��y�o���]H#�Μy��$�@�3@��։�y����񱽀��?�|s���r/(�C�l o�:֯l�(0\�^�����n���!G��D ��\�Yy?~>���C���~��g¨���H�[�9�EMhgLj�Z�B�Xh%�x��I�����Y�ކ��}����f���|b���nY���u�1��	�Qz=(����+ v����'��s���v=l&C�g�@,�=FY�N=�3��"s�������
�����4<;@zW�Ȟ模5�@��[`��	:�,N[�����X��'^Az|Rn�gB=q��6��6�����n	<_+�g�Ue�2�!?���J�1�_�����+�P/2諞�G�Lz,��"�V�F�jD?������ko�����U��e�T�(�{�P/�G�f��k�;j���!��ւ�-T������ ���+��Ǖ/ڮ�oB= ���Ke����,J��'S�h�I�U4�U��U�u��ex`�����B�X>e�e�S®�� ]B����
g;�\ǁ����N�Xy��������6�P/�O���b�{Ur���j���u4WZ5��dГ��!ѧ���G7�t}z�^���1ʴ�VAWu�%�Cz���N�-�����]�$x�:�r>s���Pτz�>p
p��"�����{��Y?��o�d�tF��jt��CG������T�mt�^J�CC��)�
�Gt_�u�,��{>֭�'vx�*�ז8㿍^��R���(�KH��!�\�Dp��,���g�h������O@@�7�H�9���/��[�b� �/��Ab��{���*��:�.ڮ,G��OB��S�!9���P:����l=N���/�����ei�ry���qi��KA�!��TG�"�F��&�8ߜn�c�sߒ��/���)��n=�ݣ��� �k n?-:��6��5�@���k���}k(�݆O�ӧ�sNDm�����oA�;�#��ba�Ξ��������^���c��\��?=O_>;c��%�LdnD:�o��18���i�lCi�z��6������]�ȇ���|L�k{��D�⬐�.�,lG��,�]9�Kvd��^�>�����&A>eTp��!��n�g���ҩ��i�alq�B�i�^�ó�2��zI�d'��O3삅G]a��0�\mI�����.������k��̵׼��m�B��O�㐜>*Cw<S��KE�:Y���l��";�6-�8�q6 ���1�w��k�	�K����e�D]µ�>��Gn
�\�(�ah#���������n�{�A8��>כ�MB��>���VaU�豢'\Aۑ2 {���1�m��<�ߝ��Ky!�IN:�z ���Y�[�c��.Y7���	)bߋ�Շ�*�ʓ�!�._k���������-�@������]���,�>������RZ��Wl2��~�G7�F�����D��	w}��,�!#:$
��rpR����Fg�1Qy�0�쌼<�ōϵ��~�/�=���nV�n�@����A%	�g�����M��f�ఇ����?_Gn��Nh!��ˤ��&��Z����Z?�l�HW6|TGJa��CK����@k��V1�4b�gC�,�/Û��Z�:/�Z �a��*���>����^gݍ��Xa�(��VȈD�ز~�췵O�۠�t�����?#fV�e�l^Zu���F��5� �=�w��#��:��z�Ǜ�J#�M�L��w�0 zC96+:f�"�,��ar�ު�+0�ܿP�3n�)]K;�=�5b��ȸ-v'�g�,��q��M���jv�eR/�كz���u؜������SX�ؽ����6Bʑ,Zi���Td@ؓ3��b�w�ZGP�{����i�+
�������pH�G����o��v��&8o��4��:<��D��X���ʋ*�Z��]&�	T��8�{��/%�&A�"���<��v�}ǜ3��ϝMܸ��'��Mܫ���nWD�?<�@B��+������򟈾B���ᡈ*ޘ�E�#{3��h��H�v?Z�O��Zt�`�^0�\�LEo΁��Ȑ	�`j$[�P{���I� �	�9�	x� ᓮ�}���+���&��F�!-��
T.�A{���vG��-�8]9���0�uA�[)Z�k�'��$!�W��QV��B�ч��t�Q�M�&lX��?���e)}�'�+��4����r)��NLG�Yw<ڄ�-���Վ v�#<�����t��5�Ux�,�.�գ9[ҁ�jL�I�>����%ܽD1İz�|hHD9�v��3�� DӀ�	���A�%���k��P��
V�>�P�
GO���n)�r���ՙ&PU�ϙp�n�S�����vx�ʎ��n�)���N��A	������"K�g�Vu�g*v&��>�g����OHm�v�XPH��P�m����'�"�'$�I$%X)�O  
_	�v=�}
�Ap݂�U����V���O	U[^�$�O��Vc���[W-�L � aˮ���^�HP���s�k"�B���{�BB#�:k<����:�J	=dk���&����xb�� ������)!�i� mZ�B���5�?~ w_w�/���艂wW����Q�7�����
̋�,��9����Iy�A�	Dd*p���m���� AX�@J�+ğ�������zf�`Q��+z��f�k(Ǌ�F����U��L��qN�^�(>�]8�Xu�:�I��U���
�^+�Ȇ2�˘/<B
�B���pC�5��^��!�l��	��.�;���G���
��>�xX0�8�œ����g�!�a|���iC�=]���������§�������9��njR��z��3�3'O�5�D|��T�E�0T��6@�Y���d�h1�~�3�:2�_q�	�}U�/�-HO��@� ~'�U9�'��:�fqb�	H�E
v�	�@2��k��'�L  �v�0S��Ѫ�
G�Fy� B���'F8�Y�
�k����	�~���S��R?�#��T��n0[�m�:�1Fg%��:&��фG�6�2>l��    �;��3g�}����i�Aq��{�b�4`��I�a��
v�]�U��Tw��#�� c^u��|�M���W:MA�>X��^_�!�-i�+��/@��jr���S�#�?��N��~������ �{CӲ9���6�@3Ř����=kX�W_��s;�9�ڄ~a�]��U(l�K��^�<2~��k�E,+0.�2~�_�v��<��$�|Q�6I+�0m�vJ��l��L:�=:��s�tP�
�eԙ�a(>m(�kח�r!�PG:Az��'�>�����ߠ`P,C?�ny�k�j�e!ї�z
��+u>xV ���i9O|S���s���D!B\ ����1�[_��L A]�3����q���V?���Qd:�fa�ّBq%v�������}�����eQ�T�7CbO�>���l"�0u�C�4=�`};���"�4�5��-�x���3_��8w�COm0��1t?t�� UM�n�F���>��X1�`�؄)�:#4{;��g�����S�P��Yq�)0�G
��,R�:�Yg3�\D�aHU�#Eݩh�_&�1���a��Ѕ
N���;���pr�@�%���(��g�;��Hۅ��}Y���b��ݗ=�P	B$�C�%4y��Y�!tCjG��(����Z���=Ma`�h��@~L����������y��vU�֎�$���.y!F�����Ƣ�����H#���:�PĠ ��j˚��\:� ��������	���\$�k{�^�m�~$]�{�0�}U��Wǅ�̡�ţP�=�v��)���wq#���M}<��&k����Լ�������Vh��j��xlh��\k�B�z�4e�UT�g����HN�m��7��O"���Ҧ�[��yJ�]�6Cͮ����m��8�t 8�e>�@XM�_�|�P�G�^�Py���}�B�X��f��S�.u�G�����B0#<5 ��3�_Ə�W��<��m���9�����A��^m�EN�{�C��PTb���^�I��-?�=\��<����Ipuձl8�N�{cꝼ8���̦�C���7�D`闳�"�3R;�(�<�Q�?�#���G�C�4�pܶÌ~N�BH0��a!�Vw �F@���U1p�]�������͈�`[S��9FD�I��b4Ӎ�;<��5�x�y�Ӗ���]����_� ,� �'�]DO�tA�A6E����0E��N�UC;��^���
���Oa�E������i�G����"��� ��j�g�q���za�iJ_W_l��U��j >�;��\�ȑ���	F����?F0v�B������ ���V��k���𣗽���δ��8�D����� �F�>�_�$��@Ʒ�� �����@P�̠i��+J��O=�s����4���M s����25U�?c��� ���-���� :PX]��<���:k
ϙ��	v�'`�D��u�9p �P��8�<l E}F`* 9B���0�dC��
\D `��BC���f������i��ѩ�c J5N�`��iV���N�q'�v���om������U���� �gR�WT�G#��>�%�1��PS�36]h��M��% ��!��8���O�9�6fu`ص�}tݶR�(���3[.O�}�����j��L����=ǃ)�v?�x2�\}W���hS���tH�cC'��ԹXB3����P�w�:!�.~E��$@�$l�]-j;\��<`ed���웜o��E�024Ɏ0���9�_������0 }vᩯ6��k�,���6���jQ���O�U���ҽ�����Q@ ��Àh�u�����w��>C������1-�ٞ�g%0Y�\��~��O�F�������+��D���	T�?k��������u�,�2��1��M퐞E�[�>�8�1�H=��?q��+�����ތ�F�<9�g�*Ze�������SvW�S 4,��݈dļ3���q�l�2|���|HDu�+�{�bK�I�3^D?=mؕ(�>�����14H���� y������b�� Jt��Q#�/�/�ٮ � �G�=�l׍�F�/]���>��$i>}�,8J�솭����e���HK5]	�= ��!�c����ITv�ֲZ��	2�L�0�Y�D�2�~k�a��"6׮����ج���.���jq�/�D%�����0�*���4q�?-���)M�z����t"fN2��H�z�����-��+k$5OeݐR�Jio��j�������>�
X1�s,t8X��8\�;��F�hp��֙A
1$-�8 �dQ}��SW��ݷ�[Gm9�E���Tx��V���+��'�b`��N�jb��{?��x �������x��ou��?γٜ�d_�TT�Hf����p��� @��5��ۿ�~(�s�ͩ?$4��ws[f�W�j�����+��� ���9�O����[P��ii�k!���k�1�g�C�?l/+D����c+��B�LDD���#��oG�!a�����s+x�}^�C�e<���vм$����5��V��!����(�s���h��oͺ�z=�~J��(�B�c/؋��7�#yz�IE�)SE��TRQ�Xk�-��@t�5Q�U�=��
��(�	Ŧ�KX�|��$S���uIʓ�be�e.�IX0�/�}&{���}�@2�1�)/a�o�,T�<����M���0��,o�Q@/m�6��-�:��U8��uO%���������´��?���42Ϗ[(��� 5]�\J�t��3����Η��O���&'����,jt<^ �u�I�xCe��)>�k���x�5�>�
��s.��&ό.�y�*��m�"��-�7�0+,�;P�s8������Ԩ������	�g���xd��G#vB�tN�J�%��uԣ�u=^�������g�*`��3�-@(炿��<�F�px��8v�Aj�/w����?7H��J�gbAdē���v&�p���K	=���g�Th�!��>[r���oe��䧂�w��.����,(�a�{��S��>��~�-s	 �``+� R�Z�5�9��uP�RUR,��q���=�;~<���ng���8�I�C�cU�W���.���u���F� R���Q�_/W;蟊0O���щ�rB�!D�.�W)�������ii<|T��/����c�q?����E�)_��)	P/
�{]�Q����|�GVB{t4��b�	QBU�����$������ u=�}j¡�ORϟ�"��z%��CW�W6u�����u��{%���6�+�x/	hE�zw�^��OQXw�@�	���]�ޱ0Ա�	:�tV�
���sء=`s�!��Hi�e�`���⩊�5�5�"\$�<Zn��zA"����߽��l�l ��љ����e%��}�3���癣�����<{?�2E�=/�qV�A~�xu��]���\o��3q!wW�O]Ҡ��K�C���Og@�M��Tlݕ�Ó�- �
}C�]�B�d�L�-H��|_��^<e�ob!�1;ۅa��0d\�
��:�az��tG����N���6��.U�Wx�B�$�d["zQ�:}Lj���R�׉D_��Yݺ��GJ����t�C��������/z
C�\AE����
��8<�/8��tSm���@)V#I��<Zm��L@�!�ݖ<�!�����)����F$ �K_�Jr�D�CA������޲�3]Ve�*ȞҐ�����Z0^V�D��t"��b ��&�YFU�>��uy�o��3]w?���J#���x�9�u�G��p���R�}7|YP]4���e��n��E�u�ejUt�_ks�����}Nz�$�	#p��g�U)�*��EX�"���xЏ�n�����#��ݘ=�)��g&�t�q�m"J�CeL?-S��� �  %�E�+>7�}�����J�I:5��|�x�S�OC�>�-���I6!̚�6$4t�0�2��
�rr��u�9��G�L xP�{��S��v}��g�:�s���@�V���G�bum 
�OG��Qe<�ᕎ��~����>���S`R�{,�?zYé`�n�&�u�2u��#�=BћK�R�q7�@�	MN�|z�����t�]�ԅb&�z��`�����'��W`djN/��e �Y�;=�눜�F����V_�P�
 �룹Fҏ�ơ��T�f[{b�:H�;㿇7���?�C��u7_������.̠7qaú�d-�3!O��$/Kd��K���b�K����cn������7�E/��|TM2��#̀[E2�����Z�j��	B�]Q�y;�Ꮁ79��6�s�'Zw����<uw��	�X�q,/ۚ��#��{��3|����Z� o�۾�@gf��N��f
4�PX�%+"��l��^�}���P���5���+zʇ1�"��̕`��E���z�V#�ead}��-��i~����{	���Tw�?�_?=�%CC�z5X
{�p��K�Y���Ԝ�Z�
�zY!�Ҧ���IM���3�֋|�9�	�ա0��cفH�]T/��r�ʔ�G�p1���j�"1�^��'��hy���<��S�R\/�)������	g�����6��'��y�a +vm�R��CwӒ�Hz+��S�9��ç�n����6��udV�w��_&ڷ�*�u����GQ��I��M����(��f�q�E=�$)�M���G��_t�8�R���&`�
���=�]���ls��˩;��^�si� j�:��f���Z��v1����^�F_��j?҆4��[�d�2rHF���Os$ݝ����s�W5���w#�jRQ�~�;�,��#6ܿwn���4�*�4u���AWZg�!R�/M@�����r]���G�6U��ڂt7�d ���#��֙81�E@��w�n�Y+�}��F�������L�[�*�"�}�N;���pAMh�^ ���4p4�f��/�˟�=I����7�j��AG4S�I��ة��q�������U.��R _|�*F�e0���=���u�t}�G���q��;ާ �����t�uYG�ca��FB}���ƫ����B����E�>�v��x�?�O�d���r���Ա9�6[B���%�Ԩy,�o��yG�]�����Z0z�S��Km:7��Fq5�>b$]��z�D���JԸ!h��R��֍L�\r�g��4a���k���z)V֋q��o�kVS�}B3���x]]b��Î >������r����ݽ����qn�3>�w���V~9�v@6W`�'�7
��Bb<`ӹ��;�����r�9�.?D����������?�b�\      �      x���I�$ɑe׊S�e�y�C4��7���D d�Eu�~_������nd�!1���Ex���Y��{վ���uS��q�h�[��hSL&�2���l~�k~�]B�.��9�r��Yz��F٘�{5�aF�����ٮ[��Y�c�}w��������u��?���~�������p/���o���j�������������~���[�͸��϶~�a�˥dJ�������׏����׿���?֑�nuM�f�3cV���gj�N��s�f�J&��_��j���[$����c,>M���9��e��|K�L~r���1󴣙lC#��S^����~��/�m����o���#`���s���_��������������Ͽ�9�7���x�
�D���>������������_����>��}�L.���T��RJ|�xJ^;�������T��Z6�l���T��f}��������h.۸w���s�Vv���5����.�Wy���v9>n��^���wGw
?-d3��{/��S.�9���n��M�|���Y&!������l9�x����e���Ξ�aV��}�&��a��>�K.�ۼ���a�yY�z�|wtg���B�A��_ˌ=�|��m����X�h(�#χ���	����ʹ%ΆmS$2.���Z��@d��mӴFl�e�-��aŏ ����A?~ZǙ���5�2,�_��1��b3��0�.�����X�6��1g�=�Ke�e��:KО��:j\q�S���e�L��ێ�a�^�ؚ�wGw�?-�g��m�c�mFƛ�@�
��{uì`z����������D�a��N\�}��1�|���e��Yː���s褴����m��iJ������wGw*?-�	r�%��ji�5kLja��&���+h�����sx2���<?�ڊ(ޤ�h@�f[-xk%"�����K$Do7�!��	��-�?�y�L(|srg���>.#�فL�IiS	��_����ٺ�3xh���Wߑp��bܩ�RL�^?/�
*�*�T{jitcB��D��$��1:��J>��;����'��(���	�.㍩����vݭ>����i��q`ƛ�q��t6��5+\(��H���	���2Y2c���m���%�i�.�xڅʇ�+Ѽ�����D���:��o��R-̸�ﰺ#<��X�/������0�d� y%~�X�B�_&�P !������ܪ!����W�i	�z��O�����~X��!��ݚ�B��v�Y��;a/��(.@zk���4�ĽHW�+�r$ѵ`�Uc��f��ݒ����F�g~��#�	�n��][sDܬ>��X������wG�&�0ꍐ���\����"P�&l�X�u5c
����F�1�8R8S�cL��Ƃ��n]O+�����V_6>
g��g7
,J���������՟Ont!Ԯ�Ի���P��Fۮ�4{�:V�@~�=���1�ߡ���ݒ���U��מ�A��F��7�>��Am�������0��ä�)9���ѭ�.���u�Ԗ�k�}DI+������"�%>�#�@����H��Bui#ǁ��t#c�Q\9�5 =�e=E�nbո����h>����WR���ztk��8̖H%@3sZn��,�3�(h >�P��˻mR?������"0V+�hBs�V䮳����+![+���'�ϒ��1���i�rtk���6�a{$�R�|�a���7��'��f'�&���6�m�}Y ��2�E�C�{����j,3��#A�:�z��w���Yș޺���҇�<#)c����Db="��@�ï]�-J�raI�`��+��)�.dnB�%�S��=�F��c\�V������]39�I��D�׵T^�QV���UH0oqv9�5ЅY��'i���`{{���(d��JZ�D=�x��23�PZ޸
��Z��	o�����%� �c8�'���y戂k��s�9	����\x%���ݙ�]�u��/�_�O:�l�W�ctR]it*���~
c�p������hx~/��k�!;ē �h����d3@�pNPL宏���n_�[ƿݚ�¬q�ܘ�9p��r���+��z�oCE��}��!>�������%u�S!fs��M qX"����"\6� ;H�{>�b|���E��<�5хY��+W��:|�"e{(�#*�T~���Js��N:n Y����c�[��S7�Nwtu�_��= :x��"Z�H���ެ��(�
�%k�wG�&�0k�HҌ�+��U�
S�:8Z��,��I��9Xs.y�c����h�\dѻpr��4	�.��<�c���I2�(=̬��/� ��^����DWn��DP����ia�B�Fn � ϭ��Nn+6#�;������*�(�WT�J��h~"�C�b�^���R�Z�e
�<�܁��|��ݚ�­�	��A0$��k�:��šp���:�QC�G�MP�8�����%>~o�-xY�3,<������sf�����Pf�v?�ѰC(/]�����ѭ�.�ݝG����� �����LPv�e�7{x�s5n�����#�\��Pݤ��R0h�Ʃ�2A�.F�óPs�H�k%��l�6QPf/�yc�;�5х[�Q<
�;�[�s;�*���%<I�Lfu�Q뫭�m�+@k@e�8Ӧ��K�Qx�9�k"�Z�ۙ��Z��slX�k����+:���l�]�nMt��M1Q��V+D��:��2n�j��<�|.���Ye�F�.&��꫸ED݊��R�,��%ևY�2\t:�A��[}�Y;��_'d�wG�&��k;�\N�B��7���1��s���D�Y�������rD��C�"��6�IA��i7:>ۄ��zI]@�� K��N
���M�a�O4���-ЮG���v[���<�@8ATq�BZw0!��D���6��v+q�њ�D�ɖK!b�ζVغ����ܣ�ۮ4]�N��x$�D�ևٵ�P^5��e�?�nMt�k��0`Q��aC�q�b�,O���h�,	8�ؓ�j�9L��Ii�Ѱ,*�A�f�����e��I�Nɹ�S5����q�.��2	"�����D,ZF�i����=`�����V����-��"���/�'�|���w�b���;�;�p�n��g�޺%
����e&����	tz�D`r�h�oNn�.��1�������s�fg�[1�l�<�C��ht6y�R�&��v�H�ۍ�GW��m�|��5�<�G�ڥ*)���P)������#z�W�����Dnm�����[�|�R�L��/���( 8\ �Ɵ��E 6&Z��Sz���f����`&�5݄/t�T��vB�,���)�y�:-��_�\���ѭ��ܚ��Qym��v�%J�** �)ZP(�TC��9�N�A��G����42~*!��q���B��vD�>�b���U2�7eX�m�5��0��mM�+X:�5��窫��%lE��B�'��bS������v�˟�=s��v��6<Ç���D��f�^�㔸j�����=�8�����M�_!#ľ�}:�-'�^�,�i�Ng��4K�F-��:!:X��H�T<r]/�9*�m\Mu�X�|FbCO^K�Y~�p��+\2�6O�a�g_��P��9~:��gקꮢ(r0���P
|H�7�3�&3�
�
C��Iz�٤��!�HM�S�z��k�\r��c&@�j�Hd� M�K���$���؋\�0�h"��bѧ�[}z�pVg��|�5 (0�Y+�h�A0Ř��J�~���zeۘȒ� Sȁ�U��%��t��QAm�T�#�#��XHn�G?�E����3Τ7�=�5�EĖmjk��I�����g�S��a� �`C���NԸO�%wZ�ARZM�Ͽ-8�q�d]O,�[Wa�*_��춐T$l��in]t�Q�������-\_�fTQ6�� Bm��yl/�Ԗ��=�\t	 n!L�U    �Q��<罫n�Tp
�"�a^=���*5�[t5B��"�����W���E?�n��b�	r�+@�ٸ*��j�^/�?E���cI�֑�Y0
��|TߊI����Щ����7���q?s�ҁ�*�1+�o!L���� ����G�&��5l98}�5�^k�n4H�1/�YP����,s�4;Rҿ�S���a	�F�m(av:���fSMu��ȬRT�<z�oQ*>���;�q �W��x����Dײ�Z��.9���%��p��)��6���מ$!���q!;i��5�j�*v�+ݡB�c�W��$�'�lA�H����cC��
����C#�=�f0�k�}:��닉��;��z�%�Ϊ��F>$�Cf��z�����W	� ;�^8:��R��t�6��vul�X��������*�ɀ-(x���M�=����T�C�}wtk��F!Z��8Dr��Z:�ːk݅D�Ju�hQRz�s�0��ŊK"�����O1h�&�,��r��W�_��+51�H4����*�-y��Z�zt�ѮW!s�DШq�X�F�G�<Ʃ�,������c�!PY�Ĥ��cǜ�Te_�ze�d��� �e�'t�ʪ�*?c"�v;x,G~[Ok4V��o��ѭ�.ײq����tM~�Rr_��c��\����Ȝ�8l3U[��� ���n�Zr�i-����$��1�ѝF5(�U<��f*�Ƈo���/��$�Ջ>�ڵ�#��p���t���.�mY�>u�%@��n�|���E�>#[�[�#�6R
]<Ѝ���:�x,��*��j�hn�}����(=1wtk�kQ:a2vu�BCV**��m?I��P�ŏ[=� �0A��/ҫ�����
�^�DpJ�g=��w��:ORe=kr��wyZ�T�I�������6��U��F�%w޶O�zcK���H�4��L�!ugr6(�4,� ӳ����"n�SJ�^�C&Yr#��J��b���-�\��>\��y���W&�ytk�K���ד�Y�ѕ���q�2зս>:�Ȋ2�a���L�6>���������F�n�WX�P͕1qT�k�� ,ϫq~�3�y/��U ��M�^�nM��ODCw���R��qAP�Y-��4w^�����'*Iu��k�9��ȫ�46y�6���I1�BL6�$2�?����f�	�|ŢOG���Sc���I��|�E�>�����cF�
���S�&�#L��V!Mã���$;�k5����j�����d�[4�0d��J�^�h�>-@��j��ۭ����D��6*��صA�U�1��rk�ϴT�F��{'C��#��kT���Q�n#WA�S���Y1Rh��g͘�։�ԓ�$i�t)h�ꍖJ|���ѭ�.w���AӔ����L���A!UVǩR>4��j�T�*�U��������g���L�AŦAAH������.?�ڋ���������D,�Ԑ�3N�W��Mef�]3u�Z���=0�)�=Ņsų�	Io��|��./d��S�6T��~E@`�����ǚgkn��MˋP2�-ЮG�&������M.o8��&tM�J��ب��0jL7C8� $�h�ij�(�h�<�չO=����V�̮.���?�m(��g�O��/׽YH_o?ݚ�ZbIi"G��eu">�LP'˚vz�٣Hc=o:&�[fE��܎��q)��xt@�5����x��G�mY�|��W�nʟ��<����J�|�hףۮ�˭����E<Ic���2��F��u�#���ωf7n �]׃�\��rB�8�c�!a<���x��(%����!7P1���l�������ؗ��[ѧ�[]o䶙�7��L��>�MۘIQ0B���*9�������5Mo#��(����J'�G~T��»X��X�n$; ��	�p}��Hv�jZ�oI��ѭ�.�D|��goTбG���4
ȯ�)<�0Jr3F_<�7��*`�TwR�tb�nzEJ�"O��������ί5����^MF�=n"2��%�פ����D��&i�@����D���t�hA��KW7���(�2�Y��k��1kA�T�c@���Q���U��2�Bl�g��6�Um�n�_����[]�un4�b����P� �DW���&�X=ơ;��F��h�P6S�����;��]��w!����=�\��eW�?(��cT���fk����OG�&������a��ڜ�����)е�(��Ԝ6�C�[�&�2I�5�q�\���$��w��ث�)��.]b�G�t2[+(=m"W^P����OG�&JW^�4t_^c@�1��{�q��:kt�I��v�*�/a��U<?�>;(����ě����f����N�mZ)�O�]�!��4�
mjzâ�ѭ��5�Dr몠�L�Yc�p�DvV�k,e�XV��J^%��
�F3ڣ��D<�ίZ�#��SѮf��6�ݍ��3��[� u���qE�*���ѮG�&�v4�lP[]B3qQ:t�ȃ@[T�*،������wnC�hI%I[�4�g8�H�X�.��1Y�R'=��'f{Qa?����p�L(z(4$��]�nMta���O�8 ^�	���>�r��V�9�I�F��!�!��} �:R����Ξ4o���5�t�Z�Ԡ�bk!�&��7��Ʒ��OG�y.������m@l� [Rʡ#q�
D������r�F�V3�C�B��Z��UT��ή#RTq�G�U`k9_�а5��?���WQ��ːOG�&���}p�gC�筵��7��W�XȀ�@4	�)�R�n�0�Hu�x�9"~V�et�H�>��8��U�VTPE�3��<\��|}�-�s����@�,o�U,(R�V7�9��7�46L ��gc5����|�"�th��nc�w�'�+#G��_dvQ�3��oZ"!�V�+=l���틠(o5j��nMt��W��x>�ޢ�2Xq�9�tv����
�d�)���A���&ͼګ�m!���b�M�z��A�0.��3}6C%b��<�в�=k��;�5х[C�j���66��J�������Q�dz��.��QXI�	ӄ��t��&?��������ơ�X�x���|��Kq�6�qh}:埅h���D����Dnm�yl���O�0�?M5̾��2z�\�꽯m�@\�ND����O�o>X,�c.�����gu��$WLkt������c�0�UcqoE��nMt��^�6�y,]���r �/�/�����k�m�_eU���	CRۡ7G򡺄��9�U�:p��'���L�՗�7�z�]�O��P�Ϗ�șW�E�[ʿݚ�­E=�*}��D$'=���!�F$�m�]aG�h��v���:\+�sY4G���u�81 Ovl��	�A�a���ZO������[�uNᗣ�)sV�ɿ1�u�vQ�i�QcME:���9Oo�Z��y/[4�),�MZ�.��\,��Pk��cy��KW���|�Q��E��G�A����>&BQ�wG�&��us.aP:����VY�r3n���$"I��,�� ����EAl(8� 
�jX�FB�d��^W �V���-��qg��j�a%�
�>|��_�nMt���@�5�� 1��&c�ܩG�Ql2��
�D�؀�_���Β�4�N``����ua����*N�F���O�o��J�Ҟ�"Җi�ė�/G�&�(4Ռ�c�՘QT��%��X�ܛKG��#��_H~=�3���.�3�36�дP�5&%OrW5YtϾ5O ¾�d�G����V�0Kt����9^�5T��fW��Նs�0���sg~ ����g�|n�4t`"`�F58�ھ�*��N�z�����7Q�:�Գ���g{��9�(��K5���zto��e�'�,���3蒚t��~���[M�*oly���l"x���Nc�̱���]$k�3T��m���d1�lV�Y������}|�_�r����׹3_�n���D�c{���ݘ�5A���(��ց#����    ��*P�TZA�o�_ft��~��ԴWY�Hsl|^��f�oΪ��-���s��0���-�<5~9�5ѧ�X�.A�c{�P�U5�d��¹�z!W�6�;Bu��;�}�m��&�49�rmԨ���Y]݀���
������H1(l����8��N|}��6$�vέ�.�9)��A�Y���cCm��E�Mh|���ªG3�Q��D����u�i��wp�nwI�\V��@��^��l�>f��&M�_�|9�5хi�g�^$�l�N�R#3W�sQ��Z��sƌZ��J��g�В�
(����`=R�������N�[��Л�B"��r,#�q�`�{��ף[]Ȁ���ڬ�DL�:���T��;W�J8��	�v#CF��=6��F͈	�i�gܦ{M��Xc7dnH�������ə��x-�p��߂����+XE�pi�v��5"*���J���#.`��k4�lhT�
=���}8�u�kV�t�"U�Vh�:D-�y��s�G5��f�׹�_��s�%�f�Z��V4p?k5!>�C�0J�W�@���	�U|�z� n[U#�:~�ԁ.�x���n|��:��il���m5[S���V ������w��ѽ�.7F�b4��:7D�;b3I���*߃p04�aN�k%���a^]��̑���06��aE��u�TO����.֝��4���p�٪'W�P�_Uڧ�[4�\�5�:˦F�qkm�$��]t���n7-ge�S�CJ@}L��9�,@�gΥ^5���'��|��V9�E�l�Fu˺�s��/CD|����D��޳P^qC��;�]6ҹ(�N��v�[�(��NK)�6��Y��f�cRwv[ak���,3�^,4���d���>� �q%�7��ݚ�h}Ũy�X��v�H��l�{8��F�"S}�m!�4��R�zd�
z��u�Pb�	��FӉ� �4�ށI0k��Z����h>��c|��6�1���mN�>A�9 fu����e�L�?BJ9�s���|��wf>阄M?l�~W=p��t�Vu�J�z�TI�Z�������UP�� v��if��b/͚�o�!ף[]{cI�i����"�3��%���TC��ך��%Ė^|�s4�O#�lz�*��hf������۪:ݝC���+�Ǫı��ї�7gN��RzK�ף[]��,��\}�fV�N�A���I�iZL��������&�X\���4h��2�|���[�DP� �ٶ�U��j�d�������9�Q�ϟ��ѭ��#5٘\߈�{\Iѓ��1���Nt-��QQL
Z�@v��3���*�ΝpM�w=Upp���YV�H¿O0��1"��OcQ=Մ�f���=12���b�8���W�K$.�A�Vk�Ԑ��UBk��uWA'=�f�e��j�W�*4T]u�M�IY ��T�!;x-(
��s��*�׌g}{v�֪��mtmڛ�y���u`��;���%�ƕ�4d�kьxe��#�R���H{�g���ѻ4T��&x�5�h���h��2zD�j�����.�8���9�R����F�;�n�k��ai���P��L�
S5x�v����|��TD���[��>��k�d:_=���6�v���6�RZ-䀖��g�/-��"��5�>���r�v>|��� Ӗ�� �@K��]P�#�2��W��Z�E�qt�(�������G�娑+d�	 +¥ԋ�� �8Ω�*�yX�������q_�n��u�C���k���~k[esz&ԋ���H�����Y4������pL���>Zå�۹�zGo���k0��S�/���wZ��C����y޸����D���ޗ��?,��4ˇ��;Tל��D ����#1Tۯ�*}�ct�����z�o/na��]H�8S�#�TH��5v��ir���Qxiez�iף[]n�B�ff�M���-� J.e��B��fwr�����q�9�F��h9���L3��4򹗭b�*u�_m��i�Z���OD2�3�G_��CP�r��Q�;��FW�O��*�!h���Ӵ��e37lU`���s���F��ؒGhM��V�a�s��@�j�O/uĕJDq lϝb�\�s+�=���+G��}wt�����f\�H�=�UGUCy����=�+2J�4���j8'��E����a"��8[f\j*�8;�]��̲ȓ�l��f�d@��2#�!0j���kN�tto�kM��-?�kh��ݲ�/�͝z퍟U��=AK<�(w���5=���msZ����tF]���k�ό�w�W�[�Q�vy�5����+�8���ڧ�[4��}M�'!���[�Eޣo��ԕ�Jԡb�8�ٹ�����QU5iI�b�f��o��FkqO���I��*�<���"1���J-jʥ�q�*�~�/"��_4`��I�Bk�}(52����^܉ޤj@북�����ⲙAe���A(�B�������j�hS���e��k%����G���]ont=�����В咰��5q푵�m-���~vm�2�xS5�S-U�-#2�$�A���q+k��kv�� �����o����M�}v�?7��/��7]��m��FĪ�2���"b�l��R����Z�,4H�̭������ ���y(�������8�l+QYt�&�,�Ĉ�:J��.�������YGy��ף{]�<8HX� ��:�����#HD���8��g<�qG�|�>�蚟Zd���V�h�,����qm�[5�Kw*ps�82�4dWi6ԯr��ѽ�.oj;�	�PHIhu�TJc6�:���=MM��t�1����QA�J�{i���V��ZR�Da���yk�����!%��+j�!V�-<L���[���U�|:����RE?��i�Ե���95m�T�B hE�����������]�&�]�1jMc�1UgkZs�Z^# Wв45_i@x.��Ub4_�$|����Fץ�$g�����&��B�%m�NS���蒕��α�S�}S]0���]��k������v(�a�8��q�3f�������!H^xo�.�z?��ѵ��)��U�YѨ^{��ڠ�+��cGp]%~	��.�.E�4k�ء"�E~����i�M�5�u����C�2�ޑl�^�p���!+?��F���{]m���!ʒYGu�ZH(AV�X=펻e�Ү]��6d)���G���G�,MGײ��G���'�T)aK�`.��61v�rgM�Oǚ�=_Nsr�wG�6���>���(�l��wmD�G��I����&��3��a�6�>�j�<���t�b$� r�%��L�sSS�-�MmF$����CHݿb��Z��~t���:�Yc�ײs�s������x`sA�W��հ�Jp��~���y�@��5�t ��mԛ��#��_CЭ�WK(�^xG�R8��i<�
����wG�6�^�/B���N�]tx��B��ۄƭ}<Y&#�S�-q�+᲼*��+k�����%r#�� �pm�yd�P�%���Hq��Q��!b}+n��ѽ�.<��o�^�� ���>,���J�֒B�E��#ݷ�k�# !�5q���.h�󨚝
0e�Z٩���I��(��u��,�Y�i���)�����{]{5\�j���$>��5�7�v�5&��Q�y.H��n"�G�חZ��R��ڱ����!�@p����W��!&�o0�+��!�E�ky��ѽ���k$.�]�qx��h�eT�#�U�I��{PבV��+�[�������j���2z�\|����Z�H[è Y%�	gJ������^���������F�9}��
�ؑ�>�V�f�����x ~tid-��K����X�>o��ɻ���٧f4Z�Z�6�`ČM�ڬ&ȁ��@Ɵ�Q~����y?����Q� � /�F�ш$����F�[#�ꮜ��5�h&�״1�J=�������ɡ"���j�w��6I�������Y2��p�"ԗ�H    o�zto�Ϟ8�ӥ�G8�6CW�U�g��a}QCxq�"Z͏�	�Z[�7R�������枧]=��l��mu�] M�q��;�|��~���7��lt=��хg`8�YKd�Qk:��T��J*!B���{�aۺ0�\���:rJF�q����"�ǴM<mb����	{<���������G�6�N]*sh�z�$]U�Y{�B׺��Q�#i���*��-g�:�X^CLk2lJ�s/ �g-��;�\�ﵹ��%R���i�,��i-RT� խ�-�_�nmt]��4�* �&�o�k�vʵ�C���n�4�7�k�v�� 1LgA
��&�<��z� ��5�Y�:o���B�4��?W���U�>c��ݍ\��mt��Is�t�A�@fe�Ͱ佴bRc��k�ڮ���[ͫq^�� \Z��Ե��:�=>`5���:QK^Lx��n9��[���KE�y�zto����l崿c�dG�VS�iI[�Msr%�'�.���	pIU��vDw�YYۄݽ�r58TsM�~���e8�r���j�Uq?؉��!H^���+�qto���oۻZ�= k�&њ�gM5�$-͞ǹ4=ӕ�TT�J`x
h܃ ��e�]�6`C[��3�z���^ni�f��=�=O�+=9v�4D0������n��ѽ���X�d�h�'�R+-�l�d��Ћ�u���ۡAu�gmvT�'��C��f �^b���J�o�ٶ��pJX���8���~�F.��z���'���Ӫ��D܋����wZ�މmy" �̨X��rE����B���Kk���G�Eؗ�v�u4�#&���E���1����N#n�Ù?蟗צ��7����m����[�
�Z����^�|drYs��\ԃ���Zv�q4JZ�J��Fj{,���Zj,}lZ�(�^O��oѹ��ӐgVA��爄����J�g����ѽ��Þ��[7Um�^Dl��V��@l�K �[�=$mt3@-�T�U�qK)p F��86x��ʭ�k�����5�� ���+:�aw}���]�nmt],�B��� �[���ȝڴn .dO�, ��o��&nP��C9ʞKց�E��h2�0M�.����[�5U��RQ�QCߙQf6�������W4O�+��tto���P��0ઁ��@��Q�D�$��bc��������D�@Ӟ���Qk>�kbgC"�����
9�m�"3��V����\E�i�h4�'�X�W?�ttk�떹Z�T����g^�&�8�h]Gz�a)�Z�\}�*�/�mlqX�݉{kJ8S���Cȵ8�k��L�������t�E+
�w�WE����F���=���U�HG��bkS����g1����+�$i��^���Q�1eN��[rz��)g��ɺѐumC�C;�Um@P#[{8��x����]��mt]���8�Tj�瑳fj��:��&]����cP��5�kB%�
�pKբQ��4��ZNLzA ��Gs W1�gҀ��1�آ��*��0T:�w���{�\�Be$kE�Cf:?��V�Ո�:P��(.����w@W���Ϭj�e��=��oݹ��h�&�/h���I�o�vD�j<n%.M��������FיZ���	4��B^xE#�8�5mM��I#EWUs���̞�8��	�� |��n�Vx��D�Ȼ$?aXp$�1!�6��D2�2Z����� Ǥ�]���uoQ.b�Q��Aݿ��fh�;���j[�YY�i��ef�Q�����EEFj
X¦&�����Y���N�����K�떇�,�h��'z�!ף���i�.J�Fj_39U��� �e�`&�}Z��N�OO�L��MU!k����<���k�j����J|���O�Ƹ4ܦ�(�9��Bq�Z~wto�K޷P��ɟSo�sjV�t�JOd8>M%��J�i��K�,�/����V��Y_����Z�d�.���H��a�5g5J���C����P$6{�M�]��mt��&��$F�A�O�>"Y�E����<7�*�S 5Ic٬�s����8I��j��=��k���KW�!י`�[=�f���v��њ]T@�o�zto�k����G�D��j(p�8|�|�6����ևkï�N6Ϋ�m� ��zS���1M�nX��~:�����mvnК�FdZ"
�slo_���j����F�	,.�'����)i����"�)��E��R�>�I�A���c�ʜJ���=Wф	[*����E�uR��Q������Y��h�E�U)ợ{r�5�4�����O��B��m����r��݊փ���̭h��;`ڝ�m�c�ǌ�koPL�4�t��6Uk���d��+�_�i�y��E��ѽ�.���L[KC������QT�O	�z��Đ��]�ZJ8�w��{��Pp��of؉$^��/1���:GO�s��<oz��V��҃���0Dզ+o���|:���u���g+�v{g��im�YIa��_v'�����0��D�g�;��@��jZ�`ظK��B�w�z� t�5�y�����RQTL���j�#���|�o<�ztϳ//"T���U�^Q���Tϙ���(yϡ����h�:_�k+T9�l�q����{��-,����.�c������PN�o ���uS��Q��y��ף{]�iWw�ȳ�V�`�6�e��>jHm�;�3�>�%�JX���ǶΩ�tfh�5c�U�dI����WJ=�J���z�>������eE�~�E~����Bmդ��UP���N
�-�Ȕ���t�B���������tW��fk��w,Ѵ"������4��E����d��|<�'� �K0��k�뵫��E��]x�Z�z���� �Ψ��ˀY�t�>�%w����`c�t�C��=��X�V��	V�-��k������.b��ִ�\15��+}:�������������h���7Z���+ �ϨX=h�Ӫf�c�'¬�pC��H�6��w;��I8�J �����c���iM�q<B�k0�;�������d,!�Q�Az�܎fo;z��YU��t�F������heA2rBz�s��
����F��Ӎ�z%��	�RI7r�N�I�t����w#j��;6o��ztϳ��Cbׂ��JO^ì��`�جf�z�j����o�5��dm
���C� �;-���{8���C����@7��!��B��羾=\���(3�TѠ��k���G����z���L�Z���������~u�;"Ş���ߨ#�� �Ι�����t��N���f�4���6>��t�U��\�ڿ.���U�o��zt�!���ρ�٢Q#���4����="�w���J��t�������R��6���`�V=��z���4�qj��Q�6zO3X{���`���琾�������ɽ�.^4E�f��3�C�JmDg��{��jL��H�vX�>]GO���1�UZEC���?o�K��u��Vm�:H�GO��]ĝv�&�~}�r0__�?�G�u�3�;��&�:����G��
��C�ʀ.EЧ���^�UM�!���g�j�j�zӽ
)��� ~�6?�F\�������IfN�K�{y�f��J�[~������V5��z�����J�9����,%C����.��;XU��q�s���*��w�/�\�[J�&��a�pW�vu�VԎ��ӯ"V3z�5o��ד{]'n�2$���������*k�)�Z-�?�,�E�Y���d�A�nA䱡{�c��GiN��Ħ��Z�
��Ut*����i�*<�g��eb~�������6a4�Ê�د��nA��G|m�Tt���͝e�9Y�7�|�U�rxJ�z����X�ȋ�A��I�P��
���҃{��u�Ab�p�����ѽ�.Zv˚$�!�����B/́�YU��3��"vuo��Ɯ�B��cb�i*>�2e���ԮZ>9���v���%JW�׊�~9�EZs^��˿�[�ytϯ/Hd��{����9�6.��,�P�1xNX�Y�V�;������ 2  1�j����;`�B��*�B�A��5A���JP�ڰj�&N?��H[ν�fX���|:���u����T�7�֞�ثFch'�[���F�w�`R��5@�A;����=j/TP54i�� �K��F�-��b�55����YA�'��?[}T���0���ѽ�.Z��C>�z`\%���G����tzz����'HzC�A��Q��M�}m� !ji�Ŷ�.�2�$��	oj'�L�������/�6�rG�����ֿ���:a	b2�+��ʵ��|Ը�z�m�V��Ð�^$b�xxϪ�Xcd�Kc��O���0	G3(�
yOy��[N��������{�F��`�>���mt��6z��[E�o���4�g���p}LPp����a44�!�n;A+8`�xc]�0����+B"Z��FC�(��M�Z�Ė!~LǊP���ѽ���!�ˏIN��蠋D,h:Ak���b9�_Z\�X����&����I��W�5d?�q"��(Z��)�ު�W?��i����u�6*���{|wto���~x����ݷ��W�����Sݤ���y9�E-#|q�n�%��e���&�����]�b6�nW�u��k���
�D���5:7 �?���ˠY�oxt=��х��o��k^fR�PF��({���V�����5��/d"�9׎���j�°�$a�{�Z�4T�F���EA"0�3a�;>���_���f���Gף{]Ԭ�Cw���&��~�7��O�ډ-fg]_k��Pᙤ/Lk�/+j��T��S6	�ǆ:N��O[K��;�J	٢9-�A�jV�����������F�֨��G�5멨�(埵}��}j뷢Qs
�aFsD�ʃl��2Q��j��3ĥ���=4��ăឍ�j�Z^������C�J@��^��ѽ�.7G���&�V�V�)��:���`�[�U?�rI!$+ǚj.	� �f�4��+jcpŮ7�daTX���f(	j��wƨ��>k�h>Lz�$�gE����F��$?>�]�Jo�t�k	-�IM6�*?5l,�����/�ɲyd-;�k.�}�Y����3���	QD���{Z�3@�w ��x�!lxUUL}��OG�6���^�*�s�h��jӡ���l;��hcԤC-݉y ��k���mdp|ē�|���H��U���ګi�0J
,��F�Ox���>y/��N�9��x����F׻��ԜeU����B��#��nm���آ&�fc@�̬�X\�t��x�K��[~�n������D��(΢���S���-��Oލ�0��/�͗��G�6���.s2�������aF�J����8�9�	�j������>�#CՁT�D�4U־]K(|�
,`��dj��޳k�@Ӄ&����P���kף{]ש�bF����T�� rqڐY�V���]{D��<�&E�/֣������#���.�x�Y�.ZȖ&��Z�\Y@VB�Yx
?ִzҞ��<����³3�;����9<r��^E�&�>�'�F���J�ǎ�n! �N5��̞�V��eΕ�(6o��L�����7���6���
���mt���-������!Q�U��[�\���h���|B����ѽ��U̘�+Țh0�eh��n��Q�\}X�<�t��xZZ����Ӣ����ף{��}�@�A	����Y���JcÄ�h#��`t�4_]�آ-+���,�0��ϭfU eZw��$�#��H�����˗��̧m��KZ���F?��mt��M�
  �ECH��a;XUI;�0�=m��}M�IC���C��Ҭ��O���9�(���	�C�mX�Q�5��7>;	;���zZ��y?B�j�����tto�ώ��+�Ԙ@[�i׵j�a�UO��(X�a59�� ���B�3��C�� #p;FW5qM��C�juwЌ;=��s@�u�@��m����?��ڨ^xvܸ��0Q�{�3�ݪ:ێ�GQ��ީ}4H�6�I�L�2)�X��8�ԏ�	�˯�N=��e���S�% Qۣ����s��|�����l�ˍ@�����Չ|�D�C�B�):�Ѯ#�O���x�Ѷ�J�`���j�A"ٶ��-Q.[C�*���v���	%�G�f��S^I�������F-��<��y���JU�����{��}67-�~+AyDF�ʱ�<4��TU�ۚ#!�����0/�!τ�U�i�)@>WC�������Y�ֆ/������>֮zm��Ñ���̇ _���G&6,&-u�0D�lp:2�+Z��
�׀�>@֓�@�J��]�*Dixe��t�������*�K/-5o~t=���u�x�+��7Z�V5h&��̵
�Klh��Fh�-�e��:�����H������ZJ�Y��J��p�ԫ���7Z�0FX�YazZ��$Hej����� �`��J:M��fL�s��	��P��R�Y��s���B�z?,9�����c6�!h��u�y��z$M�D�Z�t��*��� :���-�_��mt��$�\Cwbw��g%���u�5,��̯A�zH�\L�q��(���9��O8H-~�B���6T[E�M��wMC/S`R*Ocv����w?�����Tq4�Q�Ů{���[�=ͭ�V�H��.�iW��i^���;
@�W3�*(4ŮS�k�?����p���@ 0�6�-o@/���I^9�_��ϣ����1���;�\���҆y�z�n�T�V[��t�LJ	����m5�~��9�rvEj>K�ĜH;�\���"����5�5V�d{�2�(���۝���{]�FPX#��Gl3r��2h6�u#!ú�5i@��0��z��?�Zћt�<��;(�ViDҒ��jPN8��$�58T8 F��܂��8G�Kx�kף�X�؈��'�L+Ҝ9�H��5�-M�1k�Χ�]t�ai����++m$�@�$={/�^>h��e�g����U4��!d���#�Zl����i�&ye�{�Gף{?�`�>��t�� ��;��:fm��j�"mi�!*E�h�f=��z�}e v�CQ0ch����RkZf���.!�I�a�� ��fKxKk��{/�ܰi@6�A��[�Ո����[��u�荺�&3yP��>2��=��v�8P�R,�5��F�2�'@N;[����ܬ^��
��Fm��q/r�e��U��G�6��i�
z
J�S�cU�h�PE����W�D{��ig]�j>�B�I�T4}Zs�C���u��~ӕ>Zǣ�LP�&+t�@>�cg�󑦡�Z�����ѽ�.�G��h��$)��ke����~��1���
ށMqj "B4Rt�{�Z ��PhA�� !HF{���i�6���i#������i�����6�zt�F�X�e[X�Ēf���Yj0�I͵��ZݮVՊj��9B=\�~��R�]$8c���ՔV
z9�%@Je��`��bk&��n!]��	*{��孅}wto��mvԄ;�����7H�0B����mM׼]�C����oM>Vm��J̓<Gdƪ���%Z��sdt����T��F��N�H�<�G?�=�h�Th����F���ӟ��� �5\�      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�U�[��0D��bF<m����:�p\N��n�t\@ALt��s������墩�N����|q�M����
'�[>?)����=�+��	�7r�?7�C
�]�T��E:��Oմ�,�O���\�s8<cS]*��eC3��P�{S<�E����#�e�� �l.'�SUd`̰A��!N,5Ym"��sX%t�)Nl�É�ųSX`���v��7���#..G��͒�ŕ�O���qӼ��͋�u�G�մ�|jmCa�C����߃�o�zJ�ZQ>/B	��~��EǓ�F����\���َ}Rh�n0#A�i9��+���з������#��;G���-������0��F����`�u#�(�#)'#Go�4a���A�>��oF�����A�cs�E���h��,읺�V�$�=�Ԍ�I� ���y�BnGS�"�/cd�-gSzn5RfoB�]3�� $�[�3\o��D>l��c�Ş�[�^�ױ=��� <��X��B]�'%�g�����G��83�������c�+qh�W/����ȵ'h���S����C�Z|�[�����P�2X@iĩ��b(8ǲh�^���{��q��-��#�"�'c��u�{ђD����nG����T9��`��A�@���l���xF�|���������{��LJ��l*�^׍�{�Ut�-�O�bHw�e�ڔ�;z�W}��0�Y���nw�Ze��/���8��ګ�v������*K��      �   �  x�՗]k[G���Ź��>��ٝ�9�*�_�i/R�^�~�2�)m}GXr��
%`�@�H�����wh(�S%��J�joYT�`�@��\^9�΄3��E#�%�����f�Va����T��w���/����f��Oo��F�����˛�M���W�U�8�/^}����7�m����������m�~��Ppr�7������a4&7����?^�A\�*�3N�S�@|Uj\r.�Afr��IX�˒��'�/��s�	.�QV��`/7~�޵��s�-��/>!����B�^���� u|��+$�س���l�������K�ݮ��+��tܙ�7х{:�S��X|.А�5c�b�Yk�H��������9.(���xOG�X>Y|(��(0ؚ< �1+Qs��@-��*�1�����0-I���]��]��ȼ/ω �ɹ0~�i�n���I&��	$3��7t�U��4WbהzT�X}�>�N#�:!9`^���:����܂S���}�w�={�.���?%�����30!M�zJ����Y81d����"�4�ł���30!M�K�NC̐��\ yș4{��I����扑qA9�hAb᢮����.� hu�J+���0�uR�K��7�?�E���c�$������*0����}����%�Lxh�q��P���2@��̠R�xמ��nR�+>R�����(���QKe��OB�A"V�YB�|
J���]�'%�X:��U�נ�^�X����[�p�r�>{#��ˌdA X<^���4⏝Oa�$6�؄ե��r���+Eǀ������$=� �������0ds�$R��vDl���� �M�-Iσ�9-ց�r��7�����Uk����lN� '�������y���N� �X0      �      x������ � �      �      x������ � �      �   g   x�}���0Dѳ�b�50�kI�u�����/�hc��Q�;8�4/إ�֘˵a�!�=VĬ}��gY����졟��c��z?h,�؃�$w�/�+�      �   �  x��[�rG}�Bo��V�.z2^�e�66�p�C�Fh�4�52���5uMg�hԄ�H��9YYy�j�$�w�	�&Wm�����zq~v}�X���;����.O�.nf�e{����I2`���x����S�S�'uKP,��o�7_�7Y���'������^?��(�g�H��+lb�_�D�q�&Z��18������dɰk8 ���l��%K)`�8�h�
hG��n��
є�8��=X*l�q�y_�(5�1K����S�1D;p%���FS1��� MoirF�Q� �
�8��\�&��,QI�o]r��فka�ࠒ����%"-��H�O8*B;p��I�H��5y�d1D4Y�Q�+��C���tF_͢�$.�`v����D�i�C�זX�	��Ԩ�&|�{��ʄ�)�=��Z�����֍S7���ꄺy�x��*�(�$�T�l�ǩ�<!�gП8&T0T꓄����J�ʦ��@�j1H�aLgR���G��\I�٤��A��B!EUJ0���O�k4?�h��ʤ!>���FiZc���cv�7eMM���ki�5X��V)�y�Ώ�RL�R>��5w��'����)�{n��:0�l�|D�Dm��&��`��RaL�8�q�ځ�T*�rτU�j��d���TJ':f��l�����`�
k��&�3�JE��F�3��`4�ʟ�kt4`��0ܤ��T�I'�q^��hʑ�F[���4�L�i�O|�T��~T(�X�CG���&���*�R����%3�`�$p��5��Ƈ[����J44�j��6�]����d�MA'����Z�>�k�qc�U��*�|6!��A{U�*���jE�D1W�T;0�\���L��&t����j��Ft�C�c�Z!����M�M��a��ZQҮ(:t��ځ�R�0g �ڶ�UpçhԫV�S(�c0�q���X�qv�˵��^_/����=f���P�~mҌ���N(�-�!�Y�9->����f-�h�}����JZB?�7&���:��Ү�|�^kY���K��ڹ7�?���@�R��������=B�˰2!F��ĺ�(��ݪ�F	��h��t����v�������Y�NUR�i7Ӌ����O���>��_���w|���C_���Tf�&�Ѡ}����}�Iu�gٟ��������v��7ɷ.������O���|��"
Y�R�H�|lL"�wz�N�|1!��e-���Y��Z/n�~�Z���^�?^�?o?=������������b������x����?◛�tu��?}'����"����$��6�Q?C�]/�۽���M8��kvs�N/���0�ܫ��Ͽ~z_O�Ż��}��_��K���K��TMd�l1�so������.ѽ]�X�_��fN��_~:����_Z��D�ҟF6��mJ�n�,��!3��8&����\5�Gwg����䮠����;�+S���7�����%_8�q��S�Ao����b�W�����w/��|�cv��������;Ei�~�hcm��mV��խD��8f�vн�|X�����_?�{�����ի��|���7.j�oƵ	ȥ��x�yB�/�;�����rwн�{7k��ӳ�{%�r�t������Z.o�����o�.	B
�rmcݝ~W�C��v`M%��~����.f�����f�\�}����� ���1�>f縈�He��z���cS>Jt{5[���B;�;�/��_+$S#����6y<dg.ǒ�J�M\� ����������]�������2g���vzvqT�t��)K>5@�(\5��*�CI<�m�%!p|�_��}�h١6�L�	sa��ŔuI��5:h+#��z�B�1R�Q`�2�r%���>�-�y���9P�6ŀ��k���WQ	vE�sy^��'��d����w��Ӫ2
l_F%pXr����5�D����:�@�}仝2:l_��\�5�9ae5�ɋ
�X(#�caj���}� Z��I*�&�(_�N����9�6#�?>Öؾ����O7���Y��)�x&�A������.���e$�\��g�jm"}O���Ή&hQ6J��w�BV_� f��M��`'�C��<��訐E�$�;�&�|�`]t���Ne�(���H �t�M!*�u�a:�|���?�UuX���tZ]k�W7���0�.:PG��L,h�utX�Ôr%�cq��M,��X��@A�t���/��::��Qq:C#�|-䲉��}^��0�5�����uX��R#��{�S�4#wy�pс:�!���}n�5:L5������q%��)�c=t�m��%����FF���4�H���	uk�o��C�H��R�V���<5�XuJ���H�X��u���?�c/�f
4�<�ʻHlv��D1���[��@S�-��{�kt��Q��2ϱ��+j��T�u$r�G4���0�5�C��T�	��	�����p�a:�a������kt�M��N����M��pс:�4-D��qq]G�5:*��؈���T��}�-t�
��1��������FE����A�6�+�6S���u��:����-k��Ǿ��>9;og_f��II��,�����ĺI\X�Lo$�w �f���wq覟d}۽��U���P~����F삇��4�G�=��7j?�
��iVePJnWA��G����6��yl��омA�1i����3�^��g�"w�>mV�1�bZ�}mb�hg���v��-.�س���dA\k�V� A���{�F�/s�w�&��~���yS/�=��7@t��P�I���s�cM����+�&�;S�L�*��M��i]}M�����m[��Bg��b8�(���릨���5!�k��NYf5���<�E�xH��]Җ�V�@�G����R;�J9��|�5O�<�?�.S      �      x������ � �      �   >  x�}�Kv7D��*����!m#�L2���?ED���ݤ'�q�Wl��G��G���ܺ��?����>������6~��j�%����}'��h�|B~�!�k�8����&T
�x8�x,�J��x��K�P-(7gocm��h�-iB���ݨ�*��>AK��^P	�˰5T�$�p�/iB��M�xs��jމw҄��Z  (h�S?L:�}'Mh�I,l�3��͈m'Mh���g�)-��U���*%���!���e�ƈpDwRR�R��+iﺦ��uO7���Z�b�>�F��%Վ����U�������kzs�~�P��NJj���f>|�T�û������XEF3Yz�0�ߩW)��+6Q���*����q�֫��2c�����XX*���i�*%���>z�0[E���ڽ\�� �,�a}w�~h|�NJjyK��vZ� �B���UJjyK���tl�jt ��=��KJ�����ʺ�kk(����ث���0*�p��@����i�%%��%��Y�A,�É=��ZRR�[��@b ɮ�W�OԒ�Z���W����H��c줤�����6�f�q�`>�k)�,g!���R�drC�������l��YHV���;�y��㖳�RR�wh2f���Xt�f_�̎fq'���O�ڑ�ޒ�]	�A�@��r�Rԁ��eQ��t~&:;���ޤܫ~SE�Ek(1��d�-Z���T;���v�E`)�T�m�W)����4�e*{�fs�h�[�}���'���0�En�j|����YoRR�I�$伈W,�g�g⸝�UJj�T��ah_�Ti�P�U�7iR���6��h�Xī��A�a�wꛔ��[�=�#`{�RR�f�����[���E�.�h��5�-�II=��4�ےn}EmY�+�{�~�~M�ò����8?|?׫���[��fw$�չ��������'�E�,v���/�Y�x&6�I??�S����5��\��}X줤��:`8��{�}.CmB�6vRR��HY�g���b�F�kP�d�LT�6� �;�Z��k�;)������f����}>El��rQ1(�h�ߣ�����HI�o*��$﫸B��1wy6�RR���T���r.E��ߍyb'%�N*b�d�X
�����UJj/*�fx�5�	�2��%%Ջ:0�f��~�����UJ��,L�C,��{%8�����B���E���s��31�'jI�ک�p�N��'�s���d�1�zzk�Z�9­�v ��EI&#<�$�U��Ӕ} Jn��*%��%HUL�cC�i����%%���`E3dD��7&�-�NJj9���	T�V�l�n�*%���:b���XX���s�JI-g!�nh��|��@7}������19ͱf�Ę����RR�W����з�K�1�ː[�J���+�y�-�ε��� ��.p��Z���-���a�:��=�NJj9�� c�9~Mu4<��'𒒚�2\�p��?�o�Ӥ��L�8�|'����zRc�st�{I���{����RR훊tE�m�~�Td%u���| �E���|}]�u>X���d�ɜO��*�O9`�DkF�|��I�������XfE�      �      x������ � �      �      x������ � �      �   �  x�}�Ms�0���Wp���՗%��`���@h�'�@q �8�`w��kZh�F;#�v�w�Gb�j��~X��`1��2� �������
`8/w	C*l<.)�5�BQV�5���|�6���߽�v��/�!�"�Yv�fD�%�>�#
Qg<���}i=u�q"�� �Q�k%�6�r���U$I}6��������.�6�{��R�]0�(���d���2����O���.�Pk�a�^$���C6��SKTT��RFh��Q��)���a�y�y����0z���Z��dt�v'Y?�7��q:��͝���@�R�l�Q��k�F(�v'Qv�5&����<|�?�lrG�Ωq��� /1��:kz`�V��-��fPU�q���U���6�Z�d���,�ܙ�Q�a�ʖ�<���n�8g||ӚG�|�h5z�(��<�yzu�z��DHť��i��Go � �8�g9g�R<JP�;j�����T*� ���/      �      x������ � �      �     x��KO�0���@9�Ռ_�s�P�r�������fc6�h���o*� NH�4��>'�σ[�*�.�b���0Ɲ��W��>V�T'yY�uuv��Ϧ`����7�C<�.��iu�LE.��[U����U�ZO�6���ⰺ�R�|~�J�;�C��w��G-c?!n�}��Q�؇�b
���r����U������?����S�������jw��mq��ک��r0�TG�<�I(�����7d�h�T�Oi���E�z���ؿ�I���2�&���\�!�:�vX��9���/{�����w@gQ!Ԓ�"ɤ5�9�5�H���@��s����l�m�n�Ϲ�B��R8�ʾey�I9FB�,e9X�-RT��%ʒʂ�̨
Gs.)V'@+%���R��!ai�A���+�3ܡ2^Ke����F���F��>L�ć��GY��+W���yf��(9W&��	І�ey  uML�"�ӱx�,��LܼN�D)�D,�2�%��J�F�(��=���h�l��+]��ϥ���|6��Ʌ��     