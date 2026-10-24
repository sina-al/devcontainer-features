#!/bin/bash

# Scenario script for the 'pinned' scenario in scenarios.json.
set -e

source dev-container-features-test-lib

check "container-structure-test on PATH" command -v container-structure-test
check "container-structure-test version" container-structure-test version
check "container-structure-test version matches 1.22.1" bash -c "container-structure-test version | grep -q '1.22.1'"

reportResults
