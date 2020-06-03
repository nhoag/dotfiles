#!/bin/bash
# file: test/installer_tests.sh

SOURCE_DIR="$HOME"
if "$TRAVIS"; then
  SOURCE_DIR="$TRAVIS_BUILD_DIR"
fi

testInstallerScript() {
  "${SOURCE_DIR}/installer.sh" --force
}
