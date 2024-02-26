-- User Role
create type user_role as enum ('user', 'support', 'admin');

-- Users
create table users (
    id text not null primary key,
    email text not null unique,
    username text not null unique,
    password text not null,
    role user_role not null default 'user',
    stripe_customer_id text,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp
);

create index users_email_idx on users (email);
create index users_username_idx on users (username);
create index users_stripe_customer_id_idx on users (stripe_customer_id);

-- User Refresh Tokens
create table user_refresh_tokens (
    token text not null primary key,
    user_id text not null references users (id) on delete cascade,
    created_at timestamp not null default current_timestamp
);

create index user_refresh_tokens_user_id_idx on user_refresh_tokens (user_id);

-- User Experience
create table user_experience (
    user_id text primary key not null references users (id) on delete cascade,
    experience integer not null default 0
);

create index user_experience_user_id_idx on user_experience (user_id);

-- User Social
create table user_social (
    user_id text primary key not null references users (id) on delete cascade,
    discord text,
    steam text,
    ubisoft text,
    epic text,
    origin text,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp
);

create index user_social_user_id_idx on user_social (user_id);

-- Tags
create table tags (
    id text not null primary key,
    name text not null unique,
    created_at timestamp not null default current_timestamp
);

-- Games
create table games (
    id text not null primary key,
    slug text not null unique,
    name text not null,
    description text not null,
    is_active boolean not null default true,
    is_featured boolean not null default false,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp
);

create index games_slug_idx on games (slug);
create index games_name_idx on games (name);

-- Game Images
create table game_images (
    id text not null primary key,
    game_id text not null references games (id) on delete cascade,
    image_url text not null,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp
);

create index game_images_game_id_idx on game_images (game_id);

-- Game Tags
create table game_tags (
    id text not null primary key,
    game_id text not null references games (id) on delete cascade,
    tag_id text not null references tags (id) on delete cascade,
    created_at timestamp not null default current_timestamp
);

create index game_tags_game_id_idx on game_tags (game_id);
create index game_tags_tag_id_idx on game_tags (tag_id);

-- Seller
create table sellers (
    id text not null primary key,
    user_id text not null references users (id) on delete cascade,
    slug text not null unique,
    display_name text not null,
    image_url text not null,
    is_verified boolean not null default false,
    is_closed boolean not null default false,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp
);

create unique index sellers_user_id_idx on sellers (user_id);
create index sellers_slug_idx on sellers (slug);
create index sellers_display_name_idx on sellers (display_name);

-- Offer Type
create table offer_types (
    id text not null primary key,
    slug text not null unique,
    name text not null unique,
    description text not null,
    claim_instructions text not null,
    created_at timestamp not null default current_timestamp
);

create index offer_types_id_idx on offer_types (id);
create index offer_types_slug_idx on offer_types (slug);
create index offer_types_name_idx on offer_types (name);

-- Offers
create table offers (
    id text not null primary key,
    game_id text not null references games (id) on delete cascade,
    seller_id text not null references sellers (id) on delete cascade,
    price integer not null,
    is_active boolean not null default true,
    type text not null references offer_types (id) on delete cascade,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp
);

create index offers_game_id_idx on offers (game_id);
create index offers_seller_id_idx on offers (seller_id);
create index offers_price_idx on offers (price);

-- Order Status
create type order_status as enum ('validating', 'payment_pending', 'payment_failed', 'payment_succeeded', 'fulfilled', 'refunded', 'cancelled');

-- Orders
create table orders (
    id text not null primary key,
    user_id text not null references users (id) on delete cascade,
    game_id text not null references games (id) on delete cascade,
    offer_id text not null references offers (id) on delete cascade,
    stripe_payment_intent_id text not null,
    status order_status not null default 'validating',
    created_at timestamp not null default current_timestamp
);

create index orders_user_id_idx on orders (user_id);
create index orders_game_id_idx on orders (game_id);
create index orders_stripe_payment_intent_id_idx on orders (stripe_payment_intent_id);
create index orders_status_idx on orders (status);