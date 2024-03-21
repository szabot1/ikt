create table if not exists offer_stock (
    id text not null primary key,
    offer_id text not null references offers (id) on delete cascade,
    item text not null,
    is_locked boolean not null default false,
    created_at timestamp not null default current_timestamp
);

create index offer_stock_offer_id_idx on offer_stock (offer_id);

create or replace function take_stock(_offer_id text)
returns setof offer_stock
language plpgsql
as $$
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