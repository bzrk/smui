#!/bin/bash
set -e

SRC_TMP_FILE=$1
GIT_REPOSITORY=$2;
GIT_PATH=${3:-/};
GIT_BRANCH=${4:-master};
GIT_COMMIT_MSG=${5:-"Updated from smui with smui2git.sh"}
GIT_CLONE_PATH=${6:-/tmp/smui-git-repo}

_log() {
  echo -e "\033[0;33m${1}\033[0m"
}

_info() {
  _log "In smui2git.sh - script performing rules.txt update on git repo"
  _log "^-- SRC_TMP_FILE:   ${SRC_TMP_FILE}"
  _log "^-- GIT_REPOSITORY: ${GIT_REPOSITORY}"
  _log "^-- GIT_PATH:       ${GIT_PATH}"
  _log "^-- GIT_BRANCH:     ${GIT_BRANCH}"
  _log "^-- GIT_COMMIT_MSG: ${GIT_COMMIT_MSG}"
  _log "^-- GIT_CLONE_PATH: ${GIT_CLONE_PATH}"
  _log ""
}

_initGit() {
  if [ ! -d "${GIT_CLONE_PATH}/.git" ]; then
    _log "Clone GitRepository ${GIT_REPOSITORY} to ${GIT_CLONE_PATH}"
    git clone "${GIT_REPOSITORY}" "${GIT_CLONE_PATH}"
  fi
}

_publishToGit() {
  if [ ! -d "${GIT_CLONE_PATH}/.git" ]; then
    _log "Git Directory not exists"
    exit 1
  fi;

  _log "git checkout -f ${GIT_BRANCH}"
  git -C "${GIT_CLONE_PATH}" checkout -f "${GIT_BRANCH}"

  _log "git pull --prune"
  git -C "${GIT_CLONE_PATH}" pull --prune

  _log "cp ${SRC_TMP_FILE} ${GIT_CLONE_PATH}${GIT_PATH}"
  cp "${SRC_TMP_FILE}" "${GIT_CLONE_PATH}${GIT_PATH}"

  _log "git add ${GIT_CLONE_PATH}${GIT_PATH}"
  git -C "${GIT_CLONE_PATH}" add "${GIT_CLONE_PATH}${GIT_PATH}"

  _log "git commit -m ${GIT_COMMIT_MSG}"
  git -C "${GIT_CLONE_PATH}" commit -m "${GIT_COMMIT_MSG}"

  _log "git push"
  git -C "${GIT_CLONE_PATH}" push
}


_info
_initGit
_publishToGit

exit 0;
