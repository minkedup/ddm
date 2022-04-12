#!/usr/bin/env sh

# path to the script being run
script_path="$(realpath "$0")"
# directory of script being run
script_dir="$(dirname "$script_path")"
# directory of bat modules
test_helper_dir="$script_dir"'/test_helper'

# create bat modules if they don't exist
if ! [ -d "$test_helper_dir" ]; then
    mkdir -p "$test_helper_dir"
fi

# cd into dir to clone into
cd "$test_helper_dir"

# clone bat modules
git clone "https://github.com/ztombol/bats-assert.git"
git clone "https://github.com/bats-core/bats-support.git"
git clone "https://github.com/bats-core/bats-file.git"

# go back
cd '../'
