#!/bin/bash

set -e

source dev-container-features-test-lib

check "deno on PATH" command -v deno
check "deno --version" deno --version

reportResults
