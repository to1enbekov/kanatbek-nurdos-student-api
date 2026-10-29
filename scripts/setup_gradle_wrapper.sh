#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# Official SHA-256: https://services.gradle.org/distributions/gradle-8.14-wrapper.jar.sha256
expected=7d3a4ac4de1c32b59bc6a4eb8ecb8e612ccd0cf1ae1e99f66902da64df296172
test -s gradle/wrapper/gradle-wrapper.jar || {
  echo 'Missing committed Gradle wrapper JAR. Restore it from Git before building.' >&2
  exit 1
}
echo "$expected  gradle/wrapper/gradle-wrapper.jar" | sha256sum -c -
