#!/bin/bash

set -e

source dev-container-features-test-lib

check "skaffold on PATH" command -v skaffold
check "skaffold version" skaffold version

reportResults
