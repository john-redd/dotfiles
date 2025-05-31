#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title aws-login
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ☁️
# @raycast.argument1 { "type": "text", "placeholder": "prod" }

profile="covr-$1-admin"

aws sso login --profile $profile
