#!/bin/bash

set -e

source dev-container-features-test-lib

check "container-structure-test on PATH" command -v container-structure-test
check "container-structure-test version" container-structure-test version

reportResults
