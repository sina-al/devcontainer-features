#!/bin/bash

set -e

source dev-container-features-test-lib

check "kustomize on PATH" command -v kustomize
check "kustomize version" kustomize version

reportResults
