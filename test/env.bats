#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test 'check path is set' { 
  run echo ${PATH?"Need to set PATH"} 
  assert_success 
  refute_line "Need to set PATH"
}

@test 'check path ensure we use test copy of jlenv' { 
  run echo ${PATH?"Need to set PATH"} 
  assert_success 
  assert_output --regexp "/test/libs/jlenv/libexec:"
}
