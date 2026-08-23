#!/bin/bash

set -e

source dev-container-features-test-lib

check "fzf on PATH" command -v fzf
check "fzf --version" fzf --version

reportResults
