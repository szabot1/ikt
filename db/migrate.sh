#!/bin/bash

read -p "Enter Postgresql URI: " uri

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
        psql $uri -f $file
        echo $id > .migration
    fi
done

echo "All migrations completed successfully."