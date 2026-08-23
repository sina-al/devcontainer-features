#!/bin/bash

set -e

source dev-container-features-test-lib

check "k3s on PATH" command -v k3s
check "k3s --version" k3s --version

reportResults
