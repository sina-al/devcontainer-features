#!/bin/bash

set -e

source dev-container-features-test-lib

check "zizmor on PATH" command -v zizmor
check "zizmor --version" zizmor --version

reportResults
