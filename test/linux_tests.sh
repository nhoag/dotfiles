#!/usr/bin/env bash
# file: test/linux_tests.sh

SOURCE_DIR="$HOME"

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

