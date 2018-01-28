#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/../.linux"

@test "dp exists" {
  command -v dp
}

@test "dp views status" {
  run dp views
  [ "$status" -eq 0 ]
}

@test "rml exists" {
  command -v rml
}

@test "rml status" {
  run rml 2 "${BATS_TEST_DIRNAME}/test.txt"
  [ "$status" -eq 0 ]
}
