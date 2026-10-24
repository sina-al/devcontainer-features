#!/bin/bash

# Scenario script for the 'latest' scenario in scenarios.json. The assertions
# are identical to the auto-generated (no-options) case, so delegate to test.sh.
exec "$(dirname "$0")/test.sh" "$@"
