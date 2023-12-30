#!/bin/bash
set -e

if [ ! -d "$VCPKG_ROOT" ]; then
    echo "VCPKG_ROOT not specified, Aborted."
    exit 1
fi

cd "$VCPKG_ROOT"
exec git pull