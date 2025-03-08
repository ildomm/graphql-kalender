#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
#until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -d $POSTGRES_DB -c '\q' 2>/dev/null; do
#  >&2 echo "Postgres is unavailable - sleeping"
#  sleep 1
#done

>&2 echo "Postgres is up - executing command"

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
