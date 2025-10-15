#!/usr/bin/env bash
set -euo pipefail

# n8n Database Restore Script
# Compatible with Linux/macOS/Windows (Git Bash/WSL)

FILE="${FILE:-${1:-}}"

if [ -z "${FILE}" ]; then
    echo "❌ Usage: make restore FILE=backups/xxx.sql.gz"
    echo "   Or: bash scripts/restore.sh backups/xxx.sql.gz"
    exit 1
fi

echo "🔄 Restoring database from: $FILE"

# Check if backup file exists
if [ ! -f "$FILE" ]; then
    echo "❌ Backup file not found: $FILE"
    echo "Available backups:"
    if [ -d "backups" ]; then
        ls -la backups/*.sql.gz 2>/dev/null || echo "  No backup files found"
    else
        echo "  No backups directory found"
    fi
    exit 1
fi

# Check if PostgreSQL container is running
if ! docker compose ps postgres 2>/dev/null | grep -q "Up"; then
    echo "❌ PostgreSQL container is not running!"
    echo "Start services first with: docker compose up -d"
    exit 1
fi

# Confirm restore
echo "⚠️  WARNING: This will replace ALL data in the database!"
read -p "Are you sure you want to continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "❌ Restore cancelled"
    exit 0
fi

# Restore database
echo "🔄 Starting restore process..."
gunzip -c "$FILE" | docker compose exec -T postgres sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"'

if [ $? -eq 0 ]; then
    echo "✅ Database restored successfully!"
    echo "🔄 You may need to restart n8n service:"
    echo "   make down && make up (Linux/macOS)"
    echo "   .\down.ps1 && .\up.ps1 (Windows)"
else
    echo "❌ Restore failed!"
    exit 1
fi
