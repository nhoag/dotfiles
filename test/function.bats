#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/../.function"

@test "ssh-keygen exists" {
  command -v ssh-keygen
}

@test "fingerprint exists" {
  command -v fingerprint
}

@test "fingerprint with md5" {
  skip "openssh-client version mismatch on Travis"
  md5='4096 MD5:3b:86:84:5f:b8:13:05:a9:76:4f:42:21:5a:50:2d:71 Test key (RSA)'
  run fingerprint "${BATS_TEST_DIRNAME}/test.key.pub"
  [ "$output" = "$md5" ]
}

@test "fingerprint with sha256" {
  skip "openssh-client version mismatch on Travis"
  sha2='4096 SHA256:X7nbsdv9nkdhbrYJ22K1zRh3LpONqI4nAyiXrcEbMGU Test key (RSA)'
  run fingerprint "${BATS_TEST_DIRNAME}/test.key.pub" sha256
  [ "$output" = "$sha2" ]
}

@test "hs exists" {
  command -v hs
}

@test "hs 301 result" {
  run hs 301
  [ "output" = "301 Moved Permanently" ]
}
