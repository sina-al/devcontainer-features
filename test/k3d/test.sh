#!/bin/bash

set -e

source dev-container-features-test-lib

check "k3d on PATH" command -v k3d
check "k3d version" k3d version

reportResults
