#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test 'help for vars is available' {
  run jlenv-help vars
  assert_success
}

@test 'help for vars is correct' {
  run jlenv-help vars
  assert_output --stdin <<'HLP_MSG'
Usage: jlenv vars

Print all jlenv-vars environment variables from `.jlenv-vars` in the
current working directory, in the order they will be set. The output
format is a script that may be passed to `eval` in a Bourne-
compatible shell.

For more information on jlenv-vars, see:
https://github.com/jlenv/jlenv-vars#readme
HLP_MSG
}

@test 'help usage for vars is correct' {
  run jlenv-help --usage vars
  assert_output --stdin <<HLP_MSG
Usage: jlenv vars
HLP_MSG
}