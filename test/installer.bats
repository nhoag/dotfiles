#!/usr/bin/env bats

@test "installer script" {
  run "${BATS_TEST_DIRNAME}/../installer.sh" --force
  [ "$status" -eq 0 ]
}
