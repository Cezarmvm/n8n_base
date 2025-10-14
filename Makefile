up:
	docker compose up -d
down:
	docker compose down
logs:
	docker compose logs -f n8n
backup:
	bash scripts/backup.sh
restore:
	bash scripts/restore.sh FILE=
	# use: make restore FILE=backups/xxx.sql.gz
