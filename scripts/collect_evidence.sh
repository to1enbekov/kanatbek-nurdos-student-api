#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p evidence logs backups
: >> logs/Kanatbek_Nurdos_system_report.log
chmod 744 scripts/Kanatbek_Nurdos_system_report.sh
./scripts/Kanatbek_Nurdos_system_report.sh >/dev/null
grep -n 'Kanatbek Nurdos' logs/Kanatbek_Nurdos_system_report.log > logs/Kanatbek_Nurdos_log_analysis.txt
cp README.md backups/Kanatbek_Nurdos_README_backup.md
{
  echo 'PART 1 - LINUX - Kanatbek Nurdos'; date -Is
  echo '$ pwd'; pwd
  echo '$ tree (or find)'; if command -v tree >/dev/null; then tree -a -I '.git|.gradle|build|evidence'; else find . -maxdepth 3 -not -path './.git/*' -not -path './.gradle/*' -not -path './build/*' | sort; fi
  echo '$ ls -l scripts'; ls -l scripts/Kanatbek_Nurdos_system_report.sh
  echo '$ tail -n 5'; tail -n 5 logs/Kanatbek_Nurdos_system_report.log
  echo '$ grep Kanatbek'; grep -n 'Kanatbek' logs/Kanatbek_Nurdos_system_report.log | tail -5
  echo '$ ps -ef'; ps -ef | head -20
  echo '$ Java processes (may be empty if none)'; ps -ef | grep '[j]ava' || true
  echo '$ backup'; ls -l backups/Kanatbek_Nurdos_README_backup.md
  echo '$ diff backup'; diff README.md backups/Kanatbek_Nurdos_README_backup.md && echo 'Backup is identical'
} > evidence/part1-linux.txt 2>&1
{
  echo 'PART 2 - GIT'; date -Is
  echo '$ git remote -v'; git remote -v
  echo '$ git log graph'; git log --all --oneline --decorate --graph -25
  echo '$ git branch -a'; git branch -a
  echo '$ git tag -n'; git tag -n
  echo '$ git status'; git status -sb
} > evidence/part2-git.txt 2>&1
echo 'Created evidence/part1-linux.txt and evidence/part2-git.txt'
echo 'Part 3 and 4 evidence requires running Docker and Jenkins on your machine.'
