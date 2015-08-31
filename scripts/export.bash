#!/usr/bin/env bash

set -e
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/bootstrap

ask() {
    printf "$1: "; read $2
}

ask 'Module name' module_name
ask 'Author' author
ask 'Author Email' author_email
ask 'Description' description

target="$GOPATH"/src/"$module_name"
if [ -d "$target" ]; then
    echo "Module already exists at $target" 1>&2
    exit 1
fi

mkdir -p "$target"
rsync -az "$root/" "$target"

cd "$target"
rm -rf "$target/.git"

module_base_name="$(basename "$module_name")"

default_module_name='golang-cli-stub'

replace() {
    echo "Templating strings in $1"
    perl -p -i -e "s|$default_module_name|$module_name|g"       "$1"
    perl -p -i -e "s|<<author>>|$author|g"                      "$1"
    perl -p -i -e "s|<<author-email>>|$author_email|g"          "$1"
    perl -p -i -e "s|<<description>>|$description|g"            "$1"
    perl -p -i -e "s|<<module_base_name>>|$module_base_name|g"  "$1"
}

for x in "$target"/{README.md,main.go,scripts/{build,test}.bash,cli/cli.go} `ls -d "$target"/*/ | grep -vF /Godeps/`; do
    echo "Processing '$x'"
    if [ -d "$x" ]; then
        for xx in `find "$x" -type f -name '*.go'`; do
            replace "$xx"
        done
    else
        replace "$x"
    fi
done
