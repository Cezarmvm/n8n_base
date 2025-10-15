#!/usr/bin/env bash
set -euo pipefail

# n8n Database Backup Script
# Compatible with Linux/macOS/Windows (Git Bash/WSL)

TS=$(date +"%Y%m%d-%H%M%S")
BACKUP_DIR="backups"
BACKUP_FILE="$BACKUP_DIR/n8n-$TS.sql.gz"

echo "💾 Creating database backup..."

# Create backups directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if PostgreSQL container is running
if ! docker compose ps postgres 2>/dev/null | grep -q "Up"; then
    echo "❌ PostgreSQL container is not running!"
    echo "Start services first with: docker compose up -d"
    exit 1
fi

# Create backup
echo "🔄 Creating backup: $BACKUP_FILE"
docker compose exec -T postgres sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB"' | gzip > "$BACKUP_FILE"

if [ -f "$BACKUP_FILE" ]; then
    FILE_SIZE=$(stat -f%z "$BACKUP_FILE" 2>/dev/null || stat -c%s "$BACKUP_FILE" 2>/dev/null || echo "unknown")
    echo "✅ Backup created successfully!"
    echo "📄 File: $BACKUP_FILE"
    echo "📊 Size: $FILE_SIZE bytes"
else
    echo "❌ Backup file was not created!"
    exit 1
fi
