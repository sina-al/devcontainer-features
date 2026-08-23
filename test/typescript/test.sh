#!/bin/bash

set -e

source dev-container-features-test-lib

check "tsc on PATH" command -v tsc
check "tsc --version" tsc --version

reportResults
