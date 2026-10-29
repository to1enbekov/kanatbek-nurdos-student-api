#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p evidence
{
  echo "Part 3 Docker — Kanatbek Nurdos — $(date -Is)"
  echo '$ docker compose ps'; docker compose ps
  echo '$ docker ps'; docker ps
  echo '$ docker image inspect'; docker image inspect kanatbek-nurdos-student-api:v1.0-kanatbek-nurdos --format 'Tags={{.RepoTags}} Size={{.Size}} Created={{.Created}}'
  echo '$ docker compose logs api'; docker compose logs --tail=60 api
  echo '$ docker inspect'; docker inspect "$(docker compose ps -q api)" --format 'Name={{.Name}} Image={{.Config.Image}} State={{.State.Status}}'
  echo '$ docker compose exec api'; docker compose exec -T api java -version
  echo '$ docker compose exec postgres'; docker compose exec -T postgres sh -c 'pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"'
} > evidence/part3-docker.txt 2>&1
echo 'Saved evidence/part3-docker.txt'
