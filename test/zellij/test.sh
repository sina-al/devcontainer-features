#!/bin/bash

set -e

source dev-container-features-test-lib

check "zellij on PATH" command -v zellij
check "zellij --version" zellij --version

reportResults
