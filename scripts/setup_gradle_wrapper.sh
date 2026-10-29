#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
JAR="gradle/wrapper/gradle-wrapper.jar"
if [ -s "$JAR" ]; then
  echo "Gradle wrapper JAR already present"
  exit 0
fi
echo 'Downloading the official Gradle 8.14 wrapper JAR from services.gradle.org...'
command -v curl >/dev/null || { echo 'Please install curl first.' >&2; exit 1; }
tempdir=$(mktemp -d)
trap 'rm -rf "$tempdir"' EXIT
curl --fail --location --silent --show-error --retry 3 --output "$tempdir/wrapper.jar" https://services.gradle.org/distributions/gradle-8.14-wrapper.jar
curl --fail --location --silent --show-error --retry 3 --output "$tempdir/wrapper.sha256" https://services.gradle.org/distributions/gradle-8.14-wrapper.jar.sha256
expected=$(tr -d '\r\n\t ' < "$tempdir/wrapper.sha256" | cut -c1-64)
actual=$(sha256sum "$tempdir/wrapper.jar" | awk '{print $1}')
if [ "$expected" != "$actual" ]; then
  echo "Wrapper checksum mismatch: expected=$expected actual=$actual" >&2
  exit 1
fi
mv "$tempdir/wrapper.jar" "$JAR"
echo "Gradle wrapper SHA-256 OK: $actual"
