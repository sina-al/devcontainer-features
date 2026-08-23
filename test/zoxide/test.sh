#!/bin/bash

set -e

source dev-container-features-test-lib

check "zoxide on PATH" command -v zoxide
check "zoxide --version" zoxide --version

reportResults
