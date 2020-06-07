#!/usr/bin/env bash
# file: test/linux_tests.sh

SOURCE_DIR="$HOME"
if [[ -n "$TRAVIS" ]]; then
  SOURCE_DIR="$TRAVIS_BUILD_DIR"
fi

. "${SOURCE_DIR}/.linux"

testDpExists() {
  command -v dp
}

testDpViewsStatus() {
  dp views >/dev/null
}

testRmlExists() {
  command -v rml
}

testRmlStatus() {
  rml 2 "${SOURCE_DIR}/test/test.txt"
}

. $(which shunit2)

