#!/usr/bin/env bash
# file: test/installer_tests.sh

SOURCE_DIR="$HOME"

testInstallerScript() {
  "${SOURCE_DIR}/installer.sh" --force
}

. $(which shunit2)

