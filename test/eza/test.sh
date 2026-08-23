#!/bin/bash

set -e

source dev-container-features-test-lib

check "eza on PATH" command -v eza
check "eza --version" eza --version

reportResults
