#!/usr/bin/env bash

set -e

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bootstrap"
cd "$root"

godep restore

go install
go build main.go
