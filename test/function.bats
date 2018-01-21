#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/../.function"

@test "dp exists" {
  command -v dp
}

@test "dp views status" {
  run dp views
  [ "$status" -eq 0 ]
}

@test "ssh-keygen exists" {
  command -v ssh-keygen
}

@test "hs exists" {
  command -v hs
}

@test "hs 200 status" {
  run hs 200
  [ "$status" -eq 0 ]
}

@test "hs 301 result" {
  run hs 301
  [ "$output" = "301 Moved Permanently" ]
}
