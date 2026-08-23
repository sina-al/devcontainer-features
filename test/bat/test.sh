#!/bin/bash

set -e

source dev-container-features-test-lib

check "bat on PATH" command -v bat
check "bat --version" bat --version

reportResults
