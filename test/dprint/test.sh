#!/bin/bash

set -e

source dev-container-features-test-lib

check "dprint on PATH" command -v dprint
check "dprint --version" dprint --version

reportResults
