#!/bin/sh

# Set the config file. Everything else will be loaded from it
# It's recommended that you keep & use this path for better compatibility across versions
: ${CONFIG_FILE:=./.travis/config.sh}
export CONFIG_FILE

meta_versioninfo() {
  echo "travis-deploy Version 0.1 Alpha"
}

e_message() {
  echo "$*"  # Just go to stdout
}

e_info() {
  echo "\x1B[36;1mINFO]\x1B[0m ""$*" >&2
}

e_warning() {
  echo "\x1B[33;1mWARNING]\x1B[0m ""$*" >&2
}

e_error() {
  echo "\x1B[31;1mERROR]\x1B[0m ""$*" >&2
}

git_setup() {
  git config --global user.name "${GIT_UESR}"
  git config --global user.email "${GIT_EMAIL}"
}

git_init() {
  git init
}

git_checkout() {
  e_info "Checking out ${LOCAL_BRANCH} and committing"
  git checkout -b "${LOCAL_BRANCH}"
}

git_commit() {
  git add --all
  git commit --message "${COMMIT_MESSAGE}"
}

git_push() {
  e_info "Pushing ${BRANCH} to ${REPOSITORY}"
  git remote add travis-push "https://${GH_TOKEN}@github.com/${REPOSITORY}.git" >/dev/null 2>&1
  git push --quiet --set-upstream travis-push "${BRANCH}"
}


# A set of default settings
GIT_USER="Travis CI"
GIT_EMAIL="travis@travis-ci.org"
BRANCH=$(git symbolic-ref --quiet --short HEAD)
LOCAL_BRANCH=travis-build
COMMIT_MESSAGE="Travis CI build $TRAVIS_BUILD_NUMER"

# Store your configuration there so you can easily update this main script
[ -r "$CONFIG_FILE" ] && . "$CONFIG_FILE"

# Process special settings
[ -n "$NO_INFO" ] && e_info() { :; }
[ -n "$NO_WARNING" ] && e_warning() { :; }
[ -n "$NO_ERROR" ] && e_error() { :; }


# Go default procedure
if [ $# -eq 0 ]; then
  git_setup && git_checkout && git_commit && git_push
  exit $?
fi

# Custom procedure
while [ $# -ne 0 ]; do
  "$1"
  shift
done
