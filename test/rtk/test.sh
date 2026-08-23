#!/bin/bash

set -e

source dev-container-features-test-lib

check "rtk on PATH" command -v rtk
check "rtk --version" rtk --version

reportResults
