#!/usr/bin/env bash

set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/build.bash

cd "$root"

# go test golang-cli-stub
