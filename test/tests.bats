setup() {
    # load utility assert functions before test invocations
    load 'test_helper/bats-support/load' # required for bats-assert 
    load 'test_helper/bats-assert/load'  # easy rust-like assertions
    load 'test_helper/bats-file/load'    # file-specific  assertions

    # store overwritten path
    DDM_BASE_DIR="$(pwd)"

    # create mock file directories
    DDM_TEST_SRC="$(mktemp -d)"
    DDM_TEST_DEST="$(mktemp -d)"

    # source ddm
    export DDM_TEST=1
    source ddm 

    # move into test env for tests
    cd "$DDM_TEST_SRC"
}

teardown() {
    # remove temporary directories
    rm -rf "$DDM_TEST_SRC" "$DDM_TEST_DEST"
}

# tests that parsing the ddm script returns no errors or warnings
# - all warnings should be suppressed 
@test 'passes_shellcheck' {
    run shellcheck "$DDM_BASE_DIR"'/ddm'
    assert_success
}

@test 'to_lowercase' {
    in='AbCdEfG'
    out='abcdefg'

    run to_lowercase "$in"
    assert_output "$out"

    in='abcdefg'
    run to_lowercase "$in"
    assert_output "$out"
}

@test 'starts_with' {
    # test with a valid sub-string
    search='this is an example string'
    starts_with='this'

    run starts_with "$starts_with" "$search"
    assert_success

    # test with an invalid substring
    starts_with='is'
    run starts_with "$starts_with" "$search"
    assert_failure
}

@test 'repeat_str' {
    repeat='n'
    amount=5
    out='nnnnn'

    run repeat_str "$amount" "$repeat"
    assert_output "$out"
}

@test 'file_to_array' {
    out='el1 el2 el3 '
    test_file='test_array'

    # setup test file one
    echo 'el1' >> "$test_file"
    echo 'el2' >> "$test_file"
    echo 'el3' >> "$test_file"

    # assert success on valid file
    run file_to_array "$test_file"
    assert_output "$out"
    assert_success

    # assert correct handling of non-existent file
    run file_to_array 'does_not_exist'
    assert_output ''
    assert_failure
}

@test 'in_array' {
    arr='el1 el2 el3 el4 el5 el6'
    to_find='el2'

    # existent element
    run in_array "$to_find" "$arr"
    assert_success

    # non-existent element
    to_find='el7'
    run in_array "$to_find" "$arr"
    assert_failure

    # partial match rejection
    to_find='el'
    run in_array "$to_find" "$arr"
    assert_failure
}

@test 'collect_glob' {
    # setup test folder in env to match
    mkdir foobar barfoo foo fond
    glob='foo*'

    # ls globbing produces weird, but acceptable
    # spacing for arrays
    expected_output='foo  foobar'

    run collect_glob "$glob"
    assert_output "$expected_output"
}

@test 'submodule_path_correct' {
    # test when no recursion is enabled
    test_path='tld'
    out='tld'

    run submodule_path_correct "$test_path"
    assert_output "$out"

    # test when recursion enabled
    export DDM='2'
    out='../../../../tld'

    run submodule_path_correct "$test_path"
    assert_output "$out"

    unset DDM
}

@test 'log_node' {
    dir_log='.created_dirs'
    file_log='.created_files'

    # setup function with fake data to operate on
    created_dir="$DDM_TEST_DEST"'directory'
    created_file="$DDM_TEST_DEST"'file'
    created_link="$DDM_TEST_DEST"'symlink'

    # create target for fake symlink
    link_target="$DDM_TEST_SRC"'fake_target'
    touch "$link_target"

    # create fake nodes to log
    mkdir "$created_dir"
    touch "$created_file"
    ln -s "$link_target" "$created_link"

    # test directory logging
    run log_node "$created_dir"
    assert_success

    assert_exists "$dir_log"
    assert_file_contains "$dir_log" "$created_dir"

    # test file logging
    run log_node "$created_file"
    assert_success
    
    assert_exists "$file_log"
    assert_file_contains "$file_log" "$created_file"

    # test symlink logging
    run log_node "$created_link"
    assert_success

    assert_exists "$file_log"
    assert_file_contains "$file_log" "$created_link"

    # test non-existent/non-handleable file
    run log_node 'non_existent_node'
    assert_failure
}

@test 'resolve_file_conflict' {
    # file to test for conflict with
    test_file="$DDM_TEST_DEST"'conflicted'

    # run without a conflict (file doesn't exist) 
    run resolve_file_conflict "$test_file"
    assert_success

    # create test file to simulate conflict
    touch "$test_file"

    # test a conflict where the user answers [ENTER] to override
    resolve_default() {
        printf '%s\n' '' | resolve_file_conflict "$test_file"
    }

    run resolve_default
    assert_success

    # test a conflict where the user answers yes for an override
    resolve_yes() {
        printf '%s' 'Y' | resolve_file_conflict "$test_file"
    }

    run resolve_yes 
    assert_success

    # test a conflict where the user answers no for an override
    resolve_no() {
        printf '%s' 'N' | resolve_file_conflict "$test_file"
    }

    run resolve_no
    assert_failure

    # test that conflicts are overridden when FORCE is set
    export FORCE=1
    run resolve_file_conflict "$test_file"
    assert_success
}

@test 'logged_ln' {
    link_name='testlink'

    src_path="$DDM_TEST_SRC""$link_name"
    dest_path="$DDM_TEST_DEST""$link_name"

    # create target file
    touch "$src_path"

    # test with target file
    run logged_ln "$src_path" "$dest_path"
    assert_success

    assert_link_exists "$dest_path"
}

@test 'logged_cp' {
    file_name='testfile'

    src_path="$DDM_TEST_SRC""$file_name"
    dest_path="$DDM_TEST_DEST""$file_name"

    # create source file
    touch "$src_path"

    run logged_cp "$src_path" "$dest_path"
    assert_success

    assert_exists "$dest_path"
    assert_link_not_exists "$dest_path"
}

@test 'create_dir_if_not_exists' {
    target_dir="$DDM_TEST_DEST"'/does_not_exist'

    # assert that creation works as expected
    run create_dir_if_not_exists "$target_dir"
    assert_success
    assert_exists "$target_dir"

    # assert subsequent creations don't error
    run create_dir_if_not_exists "$target_dir"
    assert_success
}

@test 'can_install' {
    # setup an example configuration to verify
    mkdir -p "$DDM_TEST_SRC"'/foo/conf/' # create conf pack and conf dir 

    # create an always-install verification script
    verify_script="$DDM_TEST_SRC"'/foo/inst.sh'
    printf '%s' 'return 0' >> "$verify_script" 
    chmod +x "$verify_script"

    assert_file_executable "$verify_script"

    run can_install 'foo' 
    assert_success

    # non-existent application
    run can_install 'bar'
    assert_failure
}

@test 'is_ignored' {
    # statically set ignore globs which would
    # normally be loaded from file
    export IGNORED_GLOBS='foobar'

    # test starting match
    run is_ignored 'foobar/'
    assert_success

    # test partial match
    run is_ignored 'foo/'
    assert_failure

    # test non-match
    run is_ignored 'something_else'
    assert_failure
}
