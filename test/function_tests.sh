#!/usr/bin/env bash
# file: test/function_tests.sh

source "${HOME}/.function"

testHsExists() {
  command -v hs
}

testHs200Status() {
  local result=$(hs 200)
  assertEquals "200 OK" "${result}"
}

testHs301Result() {
  local result=$(hs 301)
  assertEquals "301 Moved Permanently" "${result}"
}

testRandExists() {
  command -v rand
}

testRandStatus() {
  local result=$(rand)
  assertTrue '[[ -n "${result}" ]]'
}

testMcdExists() {
  command -v mcd
}

testMcdStatus() {
  local nested_dir=/tmp/test01/test02
  mcd "${nested_dir}"
  assertTrue '[[ -d "${nested_dir}" ]]'
}

testMcdRand() {
  local nested_dir=/tmp/$(rand)/$(rand)
  mcd "${nested_dir}"
  assertTrue '[[ -d "${nested_dir}" ]]'
}

