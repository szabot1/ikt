#!/bin/bash

db_user="postgres"
db_password="2X3xKmt50FPnROL4mlz9nb"
db_host="localhost"
db_port="5432"
db_name="gamestore"

initial_id="00"

if [[ -f ".migration" ]]; then
    initial_id=$(cat ".migration")
fi

echo "Initial ID: $initial_id"

if [[ ! -d "migrations" ]]; then
    mkdir migrations
fi

files=$(ls migrations/*.sql | sort)

for file in $files; do
    id=$(echo $file | sed -n 's|migrations/\([0-9]*\)_[a-zA-Z]*.sql|\1|p')
    if [[ $id > $initial_id ]]; then
        echo "Running migration: $file"
        
        if [[ $id == "00" ]]; then
            uri="postgresql://$db_user:$db_password@$db_host:$db_port/postgres"
        else
            uri="postgresql://$db_user:$db_password@$db_host:$db_port/$db_name"
        fi

        psql $uri -f $file

        echo $id > .migration
    fi
done

echo "All migrations completed successfully."