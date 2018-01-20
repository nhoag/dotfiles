#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/../.function"

@test "ssh-agent exists" {
  command -v ssh-agent
}

@test "fingerprint exists" {
  command -v fingerprint
}

@test "fingerprint with md5" {
  md5='4096 MD5:3b:86:84:5f:b8:13:05:a9:76:4f:42:21:5a:50:2d:71 Test key (RSA)'
  run fingerprint "${BATS_TEST_DIRNAME}/test.key.pub"
  echo "$output"
  [ "$output" = "$md5" ]
}

@test "fingerprint with sha256" {
  sha2='4096 SHA256:X7nbsdv9nkdhbrYJ22K1zRh3LpONqI4nAyiXrcEbMGU Test key (RSA)'
  run fingerprint "${BATS_TEST_DIRNAME}/test.key.pub" sha256
  echo "$output"
  [ "$output" = "$sha2" ]
}
