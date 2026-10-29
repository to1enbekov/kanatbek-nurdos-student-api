#!/usr/bin/env bash
set -euo pipefail
PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
LOG_FILE="$PROJECT_DIR/logs/Kanatbek_Nurdos_system_report.log"
mkdir -p "$(dirname "$LOG_FILE")"
{
    echo '========================================'
    echo 'Student: Kanatbek Nurdos'
    printf 'Date/time: '; date '+%Y-%m-%d %H:%M:%S %Z'
    printf 'Username: '; whoami
    printf 'Operating system: '; (grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"') || uname -s
    printf 'Kernel: '; uname -r
    echo 'CPU:'; lscpu | grep -E '^Architecture:|^CPU\(s\):|^Model name:' || true
    echo 'Memory:'; free -h
    echo 'Disk usage:'; df -h
    echo 'Available disk space:'; df -h "$PROJECT_DIR"
    echo '========================================'
} | tee -a "$LOG_FILE"
echo "Saved to $LOG_FILE"
