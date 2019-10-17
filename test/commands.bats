#!/usr/bin/env bats

load test_semver
load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "vars is listed by jlenv commands" {
  run jlenv-commands
  assert_success
  assert_line 'vars'
}

@test "commands --sh should NOT list vars" {
  run jlenv-commands --sh
  assert_success
  refute_line 'vars'
}

@test "commands --no-sh should list vars" {
  run jlenv-commands --no-sh
  assert_success
  assert_line 'vars'
}
