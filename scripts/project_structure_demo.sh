#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p scripts logs backups src
: >> logs/Kanatbek_Nurdos_system_report.log
printf 'Student: Kanatbek Nurdos\n'
printf '\nProject directory: '; pwd
printf '\nExpected folders:\n'
ls -ld scripts logs backups src
printf '\nRequired files:\n'
for file in Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md; do
  test -f "$file" && printf 'FOUND %s\n' "$file" || { echo "MISSING $file"; exit 1; }
done
printf '\nTree:\n'
if command -v tree >/dev/null; then tree -a -I '.git|.gradle|build'; else find . -maxdepth 2 -not -path './.git/*' | sort; fi
