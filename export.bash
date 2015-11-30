#!/usr/bin/env bash

set -e
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/bootstrap

ask() {
    local defn="default_$2"
    local def="${!defn}"
    local defmarker=""
    if [ ! -z "$def" ]; then
        defmarker="[$def]"
    fi

    echo -n "${1}${defmarker}: "
    read -r $2

    if [ -z "${!2}" ]; then
        eval "$2='$def'"
    fi
}

default_module_name='go-cli-stub'
default_license='GPLv2+'

ask 'Module name' module_name
ask 'Author' author
ask 'Author Email' author_email
ask 'Description' description
ask 'License' license

target="$GOPATH"/src/"$module_name"
if [ -d "$target" ]; then
    echo "Module already exists at $target" 1>&2
    exit 1
fi

root="$(git rev-parse --show-toplevel)"
mkdir -p "$target"
rsync \
    --exclude="/export.bash" \
    --exclude="/.git" \
    --exclude="/${default_module_name}*" \
    --exclude="*~" \
    -avz "$root/" "$target"

cd "$target"

git init
git config user.name "$author"
git config user.email "$author_email"

module_base_name="$(basename "$module_name")"

replace() {
    echo "Templating $1"
    perl -p -i -e "s|$default_module_name|$module_name|g"       "$1"
    perl -p -i -e "s|<<author>>|$author|g"                      "$1"
    perl -p -i -e "s|<<author-email>>|${author_email/@/\\@}|g"  "$1"
    perl -p -i -e "s|<<description>>|$description|g"            "$1"
    perl -p -i -e "s|<<module_base_name>>|$module_base_name|g"  "$1"
    perl -p -i -e "s|<<license>>|$license|g"                    "$1"
}

for x in "$target"/{README.md,main.go,GNUmakefile,.gitignore,startup/systemd/go-cli-stub.{service,tmpfiles.d.conf},packaging/rpm/go-cli-stub.spec} `ls -d "$target"/*/ | grep -vF /Godeps`; do
    echo "Processing $x"
    if [ -d "$x" ]; then
        for xx in `find "$x" -type f -name '*.go'`; do
            replace "$xx"
        done
    else
        replace "$x"
    fi
    if [[ "$x" = *"/$default_module_name"* ]]; then
        newx="$(echo -n "$x" | perl -p -e "s|$default_module_name|$module_name|g")"
        echo "Moving $x $newx"
        mv "$x" "$newx"
        x="$newx"
    fi
done | column -t
