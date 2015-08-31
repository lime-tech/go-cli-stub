#!/usr/bin/env bash

if [ "$1" = "version" ]; then
    perl -p -i -e "s|<<version>>|$(git describe --abbrev=0 --tags)|" version/version.go
    perl -p -i -e "s|<<rev>>|$(git rev-parse HEAD)|" version/version.go
fi
