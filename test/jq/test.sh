#!/bin/bash

set -e

source dev-container-features-test-lib

check "jq on PATH" command -v jq
check "jq --version" jq --version

reportResults
