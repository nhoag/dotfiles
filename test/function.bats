#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/../.function"

@test "hs exists" {
  command -v hs
}

@test "hs 200 status" {
  run hs 200
  echo "$status"
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "hs 301 result" {
  run hs 301
  echo "$status"
  echo "$output"
  [ "$output" = "301 Moved Permanently" ]
}

@test "mcd exists" {
  command -v mcd
}

@test "mcd status" {
  run mcd /tmp/test01/test02
  [ "$status" -eq 0 ]
}

@test "rand exists" {
  command -v rand
}

@test "rand status" {
  run rand
  [ "$status" -eq 0 ]
}
