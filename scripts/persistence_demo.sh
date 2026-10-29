#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p evidence
BASE="${BASE_URL:-http://localhost:8080}"
RESPONSE=$(curl --fail -sS -X POST "$BASE/api/students" -H 'Content-Type: application/json' -d '{"fullName":"Kanatbek Nurdos","email":"persistence@example.com","course":"PostgreSQL persistence"}')
export RESPONSE
ID=$(python3 -c 'import json,os; print(json.loads(os.environ["RESPONSE"])["id"])')
echo "Created student ID $ID; restarting services with volume preserved..."
docker compose stop
docker compose start
# Poll for readiness before requesting the record again.
ready=0
for attempt in $(seq 1 60); do
  if curl --fail --silent "$BASE/actuator/health" >/dev/null; then ready=1; break; fi
  sleep 2
done
[ "$ready" = 1 ] || { echo 'API did not become ready after restart' >&2; exit 1; }
RECORD=$(curl --fail -sS "$BASE/api/students/$ID")
echo "$RECORD" | grep -q 'PostgreSQL persistence'
{
  echo "Persistence test — $(date -Is)"
  echo "Created ID: $ID"
  echo "Created: $RESPONSE"
  echo 'Stopped and restarted Docker Compose services without deleting pgdata volume.'
  echo "After restart: $RECORD"
  echo 'SUCCESS: PostgreSQL record persisted.'
} | tee evidence/part3-persistence.txt
