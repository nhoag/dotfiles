#!/usr/bin/env bash
# file: test/linux_tests.sh

source "${HOME}/.linux"

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
  rml 2 "${HOME}/test/test.txt"
}
