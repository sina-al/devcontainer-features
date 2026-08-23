#!/bin/bash

set -e

source dev-container-features-test-lib

check "tofu on PATH" command -v tofu
check "tofu --version" tofu --version
check "terragrunt on PATH" command -v terragrunt
check "terragrunt --version" terragrunt --version
check "tflint on PATH" command -v tflint
check "tflint --version" tflint --version

reportResults
