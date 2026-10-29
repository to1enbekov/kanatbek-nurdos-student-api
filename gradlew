#!/usr/bin/env bash
set -euo pipefail
APP_HOME=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [ ! -s "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" ]; then
  "$APP_HOME/scripts/setup_gradle_wrapper.sh"
fi
JAVA_CMD=java
if [ -n "${JAVA_HOME:-}" ]; then JAVA_CMD="$JAVA_HOME/bin/java"; fi
exec "$JAVA_CMD" -Dorg.gradle.appname=gradlew -classpath "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain "$@"
