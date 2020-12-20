#!/usr/bin/env bash

RED=31
GREEN=32
YELLOW=33
VERSION=1.0.0

COLOR_ENABLED=1

function help() {
  echo "Check that a directory contains only git repositories."
  echo
  echo "Usage:"
  echo "  ensure-git-repos [OPTION]... [DIR]"
  echo
  echo "Options:"
  echo "  -d, --depth     maximum depth (defaults to 2)"
  echo "  -h, --help      show this help, then exit"
  echo "  --no-color      disable colors"
  echo "  -v, --version   print the version"
  exit 0
}

function color() {
  if [ -z "$COLOR_ENABLED" ]; then
    shift
    echo -n "$@"
  else
    COLOR="$1"
    shift
    echo -en "\033[${COLOR}m$@\033[0m"
  fi
}

function check_dir() {

  local DIR="$1"
  local MAX_DEPTH="$2"
  local DEPTH="$3"
  local IS_DIR=1
  local IS_REPO=1
  local CHILD_COUNT=0
  local CHILD_REPOS_COUNT=0
  local FILE_COUNT=0

  if [ -z "$DEPTH" ]; then
    DEPTH=0
  fi

  if test -d "$DIR"; then
    pushd "$DIR" &>/dev/null

    if ! git rev-parse &>/dev/null; then
      IS_REPO=

      if [ "$DEPTH" -lt "$MAX_DEPTH" ]; then
        shopt -s dotglob
        for FILE in *; do
          [ "$FILE" == ".DS_Store" ] && continue
          ((CHILD_COUNT++))
          if check_dir "$PWD/$FILE" "$MAX_DEPTH" $((DEPTH+1)); then
            ((CHILD_REPOS_COUNT++))
          fi
        done
        shopt -u dotglob
      fi
    fi

    popd &>/dev/null
  else
    IS_DIR=
  fi

  echo -n "$DIR "
  if [ -z "$IS_DIR" ]; then
    echo "$( color $RED "file not in a repo" )"
    return 4
  elif [ -n "$IS_REPO" ]; then
    echo "$( color $GREEN "git repo" )"
  elif [ "$CHILD_COUNT" -gt 0 ] && [ "$CHILD_COUNT" -eq "$CHILD_REPOS_COUNT" ]; then
    echo "$( color $GREEN "git repos" )"
  elif [ "$CHILD_COUNT" -eq 0 ]; then
    echo "$( color $RED "not a git repo" )"
    return 1
  elif [ "$CHILD_REPOS_COUNT" -gt 0 ]; then
    echo "$( color $YELLOW "not only git repos" )"
    return 2
  else
    echo "$( color $RED "no git repos" )"
    return 3
  fi
}

MAX_DEPTH=2

while [[ $# -gt 0 ]]; do
  ARG="$1"

  case $ARG in
    -d|--depth)
      shift
      MAX_DEPTH="$1"
      ;;
    -h|--help)
      help
      exit
      ;;
    --no-color)
      COLOR_ENABLED=
      ;;
    -v|--version)
      echo "$VERSION"
      exit
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac

  shift
done

START_DIR="$1"
if [ -z "$START_DIR" ]; then
  START_DIR="$(pwd)"
fi

check_dir "$START_DIR" "$MAX_DEPTH"
