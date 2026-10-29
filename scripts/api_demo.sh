#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p evidence
BASE="${BASE_URL:-http://localhost:8080}"
exec > >(tee evidence/part3-crud-api.txt) 2>&1
echo "CRUD HTTP assertions - Kanatbek Nurdos - $(date -Is)"
BODY_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE"' EXIT
request() {
  local expected=$1 method=$2 path=$3
  shift 3
  local code
  echo "$method $BASE$path (expected $expected)"
  code=$(curl -sS -X "$method" -o "$BODY_FILE" -w '%{http_code}' "$BASE$path" "$@")
  printf 'HTTP %s\n' "$code"
  cat "$BODY_FILE"; echo
  [ "$code" = "$expected" ] || { echo "FAIL: expected $expected got $code"; exit 1; }
}
request 200 GET /api/info
request 201 POST /api/students -H 'Content-Type: application/json' -d '{"fullName":"Kanatbek Nurdos","email":"nurdos@example.com","course":"DevOps"}'
ID=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["id"])' "$BODY_FILE")
request 200 GET /api/students
request 200 GET "/api/students/$ID"
request 200 PUT "/api/students/$ID" -H 'Content-Type: application/json' -d '{"fullName":"Kanatbek Nurdos","email":"nurdos@example.com","course":"Jenkins CI/CD"}'
python3 -c 'import json,sys; assert json.load(open(sys.argv[1]))["course"] == "Jenkins CI/CD"' "$BODY_FILE"
request 204 DELETE "/api/students/$ID"
request 404 GET "/api/students/$ID"
echo 'PASS: all six CRUD scenarios returned the expected HTTP status.'
