#!/usr/bin/env bash
set -euo pipefail
FILE="${FILE:-${1:-}}"
if [ -z "${FILE}" ]; then
  echo "Uso: make restore FILE=backups/xxx.sql.gz"
  exit 1
fi
gunzip -c "$FILE" | docker compose exec -T postgres sh -lc 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"'
