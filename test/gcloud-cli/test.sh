#!/bin/bash

set -e

source dev-container-features-test-lib

check "gcloud on PATH" command -v gcloud
check "gcloud --version" gcloud --version
check "gke auth plugin" command -v gke-gcloud-auth-plugin

reportResults
