#!/bin/bash

set -e

source dev-container-features-test-lib

check "bun on PATH" command -v bun
check "bun --version" bun --version

reportResults
