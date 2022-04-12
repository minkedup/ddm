setup() {
    load 'test_helper/bats-support/load' # this is required by bats-assert!
    load 'test_helper/bats-assert/load'
    load 'test_helper/bats-file/load'

    # create mock file directories
    DDM_TEST_SRC="$(mktemp -d)"
    DDM_TEST_DEST="$(mktemp -d)"

    # source ddm
    export DDM_TEST=1
    source ddm 

    # move into test env for tests
    cd "$DDM_TEST_SRC"

    # setup test environment
    setup_fake_testenv
}

setup_fake_testenv() {
    create_fake_application "$DDM_TEST_SRC" 'foo' "$DDM_TEST_DEST"
    create_fake_application "$DDM_TEST_SRC" 'bar' "$DDM_TEST_DEST"
    create_fake_application "$DDM_TEST_SRC" 'foobar' "$DDM_TEST_DEST"
    create_fake_application "$DDM_TEST_SRC" 'recursive' "$DDM_TEST_DEST"

    echo 'foobar' >> .ddmignore
}

##
# creates a fake application in a directory with a name
#
# @1 - the source directory path 
# @2 - the application name
# @3 - the fake destination path (.config alternative)
##
create_fake_application() {
    appname="$2"
    source_dir="$1"
    dest_dir="$3"

    appdir="$source_dir"'/'"$appname"
    confdir="$appdir"'/conf'

    config_name="$appname"'-conf'
    inst_script="$appdir"'/inst.sh'
    meta_script="$appdir"'/meta'

    install_location="$dest_dir"'/config/'"$confname"

    mkdir "$appdir"

    echo 'return 0' >> "$inst_script" 
    chmod +x "$inst_script"

    echo 'install_dir='"$install_location" > "$meta_script"
    chmod +x "$meta_script"
    
    mkdir "$confdir"
    touch "$confdir"'/'"$config_name"
}

teardown() {
    # remove temporary directories
    rm -rf "$DDM_TEST_SRC" "$DDM_TEST_DEST"
}

@test 'to_lowercase' {
    input='AbCdEfG'
    expected_output='abcdefg'

    run to_lowercase "$input"

    assert_output "$expected_output"
}

@test 'starts_with' {
    # test with a valid sub-string
    to_search='this is an example string'
    starts_with='this'

    run starts_with "$starts_with" "$to_search"
    assert_success

    # test with an invalid substring
    starts_with='not in string'

    run starts_with "$starts_with" "$to_search"
    assert_failure
}

@test 'repeat_str' {
    to_repeat='n'
    amount=5
    expected_output='nnnnn'

    run repeat_str "$amount" "$to_repeat"
    assert_output "$expected_output"
}

@test 'file_to_array' {
    expected_output='el1 el2 el3 ' #extra space important
    array_file='to_array'

    # setup file
    echo 'el1' >> "$array_file"
    echo 'el2' >> "$array_file"
    echo 'el3' >> "$array_file"

    run file_to_array "$array_file"
    assert_output "$expected_output"
}

@test 'in_array' {
    mock_array='el1 el2 el3 el4 el5 el6'
    to_find='el2'

    run in_array "$mock_array" "$to_find"
    assert_success

    to_find='el7'

    run in_array "$mock_array" "$to_find"
    assert_failure
}

@test 'collect_file_glob' {
    # we use the test env created in setup 
    # to match for foo
    glob_dir='.'
    glob='foo*'

    # paths are absolute
    expected_output=' ./foo ./foobar'

    run collect_file_glob "$glob_dir" "$glob"
    assert_output "$expected_output"
}

@test 'submodule_path_correct' {
    # test when no recursion is enabled
    test_path='rootlevel'
    expected_output='rootlevel'

    run submodule_path_correct "$test_path"
    assert_output "$expected_output"

    # test when recursion enabled
    export DDM='2'
    expected_output='../../../../rootlevel'

    run submodule_path_correct "$test_path"
    assert_output "$expected_output"

    unset DDM
}

@test 'log_creation' {
    created_dir="$DDM_TEST_DEST"'/created_dir'
    created_file="$DDM_TEST_DEST"'created_file'

    dir_log_file='.created_dirs'
    file_log_file='.created_files'

    # create items to log
    mkdir "$created_dir"
    touch "$created_file"

    # test directory logging
    run log_creation "$created_dir"

    assert_exists "$dir_log_file"
    assert_file_contains "$dir_log_file" "$created_dir"

    # test file logging
    run log_creation "$created_file"
    
    assert_exists "$file_log_file"
    assert_file_contains "$file_log_file" "$created_file"
}

@test 'resolve_file_conflict' {
    conflict_file='conflicted'
    
    # run with no conflict
    run resolve_file_conflict
    assert_success

    touch "$conflict_file"

    # default Y case test
    run resolve_file_conflict
    assert_success

    # force case
    FORCE=1
    run resolve_file_conflict
    assert_success
}

@test 'logged_ln' {
    src="$DDM_TEST_SRC"'/test_logged_link'
    dest="$DDM_TEST_DEST"
    full_dest="$DDM_TEST_DEST"'/test_logged_link'

    log_file='.created_files'

    # create file to symlink
    touch "$src"

    run logged_ln "$src" "$dest"
    assert_success

    assert_exists "$log_file"
    assert_file_not_empty "$log_file"

    assert_link_exists "$full_dest"
}

@test 'logged_cp' {
    src="$DDM_TEST_SRC"'/test_logged_copy'
    dest="$DDM_TEST_DEST"
    full_dest="$DDM_TEST_DEST"'/test_logged_copy'

    log_file='.created_files'

    # create file to copy 
    touch "$src"

    run logged_cp "$src" "$dest"
    assert_success

    assert_exists "$log_file"
    assert_file_not_empty "$log_file"

    assert_exists "$full_dest"
}

@test 'create_dir_if_not_exists' {
    target_dir="$DDM_TEST_DEST"'/does_not_exist'

    run create_dir_if_not_exists "$target_dir"
    assert_success
    assert_exists "$target_dir"
}

@test 'can_install' {
    test_application='foo'

    run can_install "$test_application"
    assert_success
}

@test 'is_ignored' {
    # statically set ignore globs which would
    # normally be loaded from file
    IGNORED_GLOBS='foobar'

    run is_ignored 'foobar/'
    assert_success

    run is_ignored 'something_else'
    assert_failure
}

@test 'install_config' {
    # relies on test env setup
    install_application='foo'
    install_location="$DDM_TEST_DEST"'/config/foo-conf'

    run install_config "$install_application"
    assert_success

    assert_exists "$install_location"
    assert_link_exists "$install_location" # default install method
}
