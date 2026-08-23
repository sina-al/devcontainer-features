#!/bin/bash

set -e

source dev-container-features-test-lib

check "kubebuilder on PATH" command -v kubebuilder
check "kubebuilder version" kubebuilder version

reportResults
