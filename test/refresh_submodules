#!/usr/bin/env bash

if [ -d test/libs ]; then
  ( 
    echo "Update jlenv, bats-core, support, assert, file and mock submodules."
    # Clear then initialize all the submoudules in .gitmodules.
    # Then force pull all of them.
    git config -f .gitmodules --list | 
      awk -F= '$1 ~ /.path$/ {print $2}' | 
        xargs rm -rf

    git submodule update --recursive --force
    
  )
fi
