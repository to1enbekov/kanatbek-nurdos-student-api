#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo 'Checking files...'
for path in Dockerfile docker-compose.yml Jenkinsfile build.gradle settings.gradle README.md \
  scripts/Kanatbek_Nurdos_system_report.sh logs/Kanatbek_Nurdos_system_report.log \
  logs/Kanatbek_Nurdos_log_analysis.txt backups/Kanatbek_Nurdos_README_backup.md \
  evidence/part1-linux.txt evidence/part2-git.txt evidence/part3-docker.txt \
  evidence/part3-crud-api.txt evidence/part3-persistence.txt; do
    if [ -e "$path" ]; then echo "OK      $path"; else echo "MISSING $path"; fi
done
if [ -s gradle/wrapper/gradle-wrapper.jar ]; then echo 'OK Gradle wrapper JAR'; else echo 'PENDING Gradle wrapper JAR (download occurs during first ./gradlew)'; fi
echo 'Jenkins SUCCESS/FAILURE screenshots and automatic trigger evidence must be captured from Jenkins UI.'
