#!/usr/bin/env bash

set -e
case ${JLENV_DEBUG:-1} in
  0) # Enable tracing
    set -x
    ;;
  1) # Disable tracing
    set +x
    ;;
  *) # Disable tracing
    set +x
    ;;
esac

# Load the semver utility code
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/test_semver.bash

unset JLENV_VERSION
unset JLENV_DIR

JLENV_TEST_DIR="${BATS_TMPDIR}/jlenv"
PLUGIN="${JLENV_TEST_DIR}/root/plugins/jlenv-vars"

# guard against executing this block twice due to bats internals
if [ "${JLENV_ROOT:=/}" != "${JLENV_TEST_DIR}/root" ]; then
  echo "Setting up test environment...."
  export JLENV_ROOT="${JLENV_TEST_DIR}/root"
  export HOME="${JLENV_TEST_DIR}/home"
  
  # Install bats to the test location.  This is next added to path.
  # These files are in .gitignore
  pushd ${BATS_TEST_DIRNAME}/libs/bats
    ./install.sh ${BATS_TEST_DIRNAME}/libexec
  popd

  PATH=/usr/bin:/bin:/usr/sbin:/sbin
  PATH="${JLENV_TEST_DIR}/bin:$PATH"
  PATH="${BATS_TEST_DIRNAME}/libexec:$PATH"
  PATH="${BATS_TEST_DIRNAME}/../libexec:$PATH"
  PATH="${BATS_TEST_DIRNAME}/libs/jlenv/libexec:$PATH"
  #PATH="${BATS_TEST_DIRNAME}/libs/jlenv/test/libexec:$PATH"
  PATH="${JLENV_ROOT}/shims:$PATH"
  export PATH

fi

teardown() {
  rm -rf "$JLENV_TEST_DIR"
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed "s:${JLENV_TEST_DIR}:TEST_DIR:g" >&2
  return 1
}

# Creates fake julia version directories and version definition file.
# Version numbers is a semantic version convention: v1.0.0 and v1.0.0-rc1
create_versions() {
  local version
  local major
  local minor
  local patch
  local prerelease
  local released

  for v in $*
  do
    version="$(semver-get release $v)"
    major="$(semver-get major $version)"
    minor="$(semver-get minor $version)"
    patch="$(semver-get patch $version)"
    prerelease="$(semver-get prerel $version)"
    if [ -z "$prerelease" ]
    then
          # prerelease is empty
          released=1
    else
          # prerelease is NOT empty
          released=0
    fi
    d="$JLENV_TEST_DIR/root/versions/$v"
    mkdir -p "$d/bin"
    mkdir -p "$d/include/julia"
    tee "$d/include/julia/julia_version.h" > /dev/null <<EOF
// This is an autogenerated header file
#ifndef JL_VERSION_H
#define JL_VERSION_H
#define JULIA_VERSION_STRING "$version"
#define JULIA_VERSION_MAJOR $major
#define JULIA_VERSION_MINOR $minor
#define JULIA_VERSION_PATCH $patch
#define JULIA_VERSION_IS_RELEASE $released
#endif
EOF
    ln -nfs /bin/echo "$d/bin/julia"
    echo "Created version: $d"
  done
}

# Check a given version string vJ.K.L or J.K.L is installed.
# copares to JULIA_VERSION_STRING from the julia header file 
# include/julia/julia_version.h
# -1 if given is newer than installed, 
#  0 if equal, 
#  1 if given older than installed. 
check_version_installed() {
  local major
  local minor
  local patch
  local prerelease
  local released
  local v
  local version
  local vi

  # ignore the first character if v
  if [[ ${version:0:1} == "v" ]] ; then 
    v="${version:1}"; 
  else
    v="${version}";
  fi
  # Ensure we have the release version number.
  # That is, remove prerelease and build data.
  v="$(semver-get release $v)"
  # Compare it to the versions installed - uses fake.
  vi=read_version_installed $v
  semver-compare $vi $v
}

# Given J.K.L reads the JULIA_VERSION_STRING from the julia header file
# include/julia/julia_version.h
read_version_installed(){
  $1
}
