#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST=src/test/java/kz/kanatbeknurdos/studentapi/TemporaryFailureDemoTest.java
case "${1:-}" in
  prepare)
    git diff --quiet && git diff --cached --quiet || { echo 'Working tree has uncommitted changes' >&2; exit 1; }
    git switch main
    git switch -c feature/kanatbek-nurdos-ci-failure
    cat > "$TEST" <<'JAVA'
package kz.kanatbeknurdos.studentapi;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
class TemporaryFailureDemoTest {
    @Test void intentionalFailure() { assertEquals(2, 1, "Deliberate CI failure demo"); }
}
JAVA
    git add "$TEST" && git commit -m 'test(Kanatbek Nurdos): demonstrate intentional CI failure'
    echo 'Push branch, run separate Jenkins demo job against this branch, capture FAILED.'
    ;;
  fix)
    [ "$(git branch --show-current)" = 'feature/kanatbek-nurdos-ci-failure' ] || { echo 'Must be on demo branch' >&2; exit 1; }
    [ -f "$TEST" ] || { echo 'Test file missing' >&2; exit 1; }
    sed -i 's/assertEquals(2, 1,/assertEquals(1, 1,/' "$TEST"
    git add "$TEST" && git commit -m 'fix(Kanatbek Nurdos): repair deliberately failing test'
    echo 'Push branch again and capture SUCCESS. Do not merge demo branch to main.'
    ;;
  *) echo 'Usage: ./scripts/ci_failure_demo.sh prepare|fix'; exit 2;;
esac
