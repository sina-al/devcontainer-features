#!/bin/bash

set -e

source dev-container-features-test-lib

check "k9s on PATH" command -v k9s
check "k9s version" k9s version

reportResults
