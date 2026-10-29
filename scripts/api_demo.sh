#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p evidence
BASE="${BASE_URL:-http://localhost:8080}"
LOG=evidence/part3-crud-api.txt
run() {
  printf '\n$ curl %s\n' "$*"
  curl -sS -i "$@"
  printf '\n'
}
{
  echo "Part 3 CRUD API — Kanatbek Nurdos — $(date -Is)"
  run "$BASE/api/info"
  run -X POST "$BASE/api/students" -H 'Content-Type: application/json' -d '{"fullName":"Kanatbek Nurdos","email":"nurdos@example.com","course":"DevOps"}'
  echo '$ GET all'; curl -sS "$BASE/api/students"; echo
} | tee "$LOG"
# Capture ID of the record just created, safely using Python JSON parsing.
RESPONSE=$(curl -sS -X POST "$BASE/api/students" -H 'Content-Type: application/json' -d '{"fullName":"Kanatbek Nurdos","email":"nurdos2@example.com","course":"Docker"}')
export RESPONSE
ID=$(python3 -c 'import os,json; print(json.loads(os.environ["RESPONSE"])["id"])')
{
  echo "Using created record ID: $ID"
  run "$BASE/api/students/$ID"
  run -X PUT "$BASE/api/students/$ID" -H 'Content-Type: application/json' -d '{"fullName":"Kanatbek Nurdos","email":"nurdos2@example.com","course":"Jenkins CI/CD"}'
  run -X DELETE "$BASE/api/students/$ID"
  run "$BASE/api/students/$ID"
  run "$BASE/api/students/99999999"
} | tee -a "$LOG"
echo "Saved $LOG"
