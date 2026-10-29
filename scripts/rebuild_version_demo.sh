#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
case "${1:-}" in
  prepare)
    git diff --quiet && git diff --cached --quiet || { echo 'Uncommitted changes exist' >&2; exit 1; }
    git switch main
    git switch -c feature/kanatbek-nurdos-v1-0-1
    python3 - <<'PYTHON'
from pathlib import Path
p=Path('build.gradle')
s=p.read_text().replace("version = '1.0.0'", "version = '1.0.1'")
assert "version = '1.0.1'" in s
p.write_text(s)
p=Path('src/main/java/kz/kanatbeknurdos/studentapi/StudentController.java')
s=p.read_text().replace('"version", "1.0.0"', '"version", "1.0.1"')
assert '"version", "1.0.1"' in s
p.write_text(s)
PYTHON
    git add build.gradle src/main/java/kz/kanatbeknurdos/studentapi/StudentController.java
    git commit -m 'build(Kanatbek Nurdos): bump application to version 1.0.1'
    echo 'Application version changed in demonstration branch.'
    ;;
  build)
    [ "$(git branch --show-current)" = feature/kanatbek-nurdos-v1-0-1 ] || { echo 'Switch to demo version branch first' >&2; exit 1; }
    mkdir -p evidence
    docker build --no-cache -t kanatbek-nurdos-student-api:v1.0.1-kanatbek-nurdos .
    docker image inspect kanatbek-nurdos-student-api:v1.0.1-kanatbek-nurdos --format 'Tag={{.RepoTags}} Created={{.Created}} Size={{.Size}}' | tee evidence/part3-rebuild-version.txt
    echo 'After the demo, git switch main. Do not merge this branch unless needed.'
    ;;
  *) echo 'Usage: ./scripts/rebuild_version_demo.sh prepare|build' >&2; exit 2;;
esac
