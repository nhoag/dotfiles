#!/usr/bin/env bats

@test "installer script" {
  run "${BATS_TEST_DIRNAME}/../installer.sh"
  [ "$status" -eq 0 ]
}
