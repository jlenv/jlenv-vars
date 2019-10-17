#!/usr/bin/env bats

load test_semver
load libs/bats-support/load
load libs/bats-assert/load
# load libs/bats-mock/stub
load test_helper

# Mock git to return the appropriate remote
# We would do this because we are running with test jlenv and not the 
# installed jlenv whcich would have all shims etc setup.
# https://stackoverflow.com/a/52546483/152860

# Currently these options are not implemented.

# @test "jlenv-vars --quiet" {
#   run jlenv-vars --quiet
#   assert_success
#   assert_output ''
# }

# @test "jlenv-vars --noop" {
#   run jlenv-vars --noop
#   assert_failure
#   assert_output <<'STD_MSG'

#   Usage: jlenv vars
# STD_MSG
# }

# @test "jlenv-vars --verbose with no .jlenv-vars shows nothing." {
  
#   run jlenv-vars --verbose
#   assert_success
#   assert_output ''

# }

# @test "update --quiet --noop with no .jlenv-vars shows nothing" {
#   run jlenv-vars --quiet --noop
#   assert_success
#   assert_output ''
# }
