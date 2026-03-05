#!/bin/sh
echo "$POSTGRES_HOST:5432:*:$POSTGRES_USER:$POSTGRES_PASSWORD" > /tmp/pgpass
chmod 0600 /tmp/pgpass
exec /entrypoint.sh "$@"
