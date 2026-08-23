#!/bin/bash

set -e

source dev-container-features-test-lib

check "opencode on PATH" command -v opencode
check "opencode --version" opencode --version

reportResults
