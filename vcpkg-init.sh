#!/bin/bash

etc_path="$(dirname $0)/../etc"

if [ ! -f "$etc_path/vcpkg.json" ]; then
    echo "default vcpkg.json not found at $etc_path"
fi

if [ -f "vcpkg.json" ]; then
    echo "vcpkg has been created at $PWD"
fi

cp "$etc_path/vcpkg.json" "$PWD/vcpkg.json"