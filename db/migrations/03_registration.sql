create table email_tokens (
    email text not null primary key,
    token text not null,
    created_at timestamp not null default current_timestamp
);

create index email_tokens_token_idx on email_tokens (token);