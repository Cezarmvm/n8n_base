#!/usr/bin/env bash
set -euo pipefail
TS=$(date +"%Y%m%d-%H%M%S")
mkdir -p backups
docker compose exec -T postgres sh -lc 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB"' | gzip > "backups/n8n-${TS}.sql.gz"
echo "Backup salvo em backups/n8n-${TS}.sql.gz"
