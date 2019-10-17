#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

# These test pass but should fail.  
# This may be resolved when plugins are refactored
@test "jlenv-vars prints variables from .jlenv-vars." {
  # mkdir -p $BATS_TMPDIR
  mkdir -p ${JLENV_ROOT}
  echo "VAR_Z=1" >"$BATS_TMPDIR"/.jlenv-vars
  echo "VAR_A=2" >>"$BATS_TMPDIR"/.jlenv-vars
  echo "FIRST=1" >${JLENV_ROOT}/vars
 
  run jlenv-vars
  assert_success
  assert_output <<'STD_MSG'

  origin     https://github.com/jlenv/jlenv.git (fetch)
  origin     https://github.com/jlenv/jlenv.git (push)
  Updating jlenv

STD_MSG
}

@test "jlenv-vars with no arguments and no .jlen-vars file succeeds showing nothing." {
  run jlenv-vars 
  assert_success
  assert_output ''
}
