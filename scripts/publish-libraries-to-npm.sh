#!/usr/bin/env bash
set -o errexit -o noclobber -o nounset -o pipefail

# This script uses the parent version as the version to publish a library with

getBuildType() {
  local release_type="minor"
  if [[ "$1" == *"BREAKING CHANGE"* || "$1" == *"!:"* ]]; then
    release_type="major"
  elif [[ "$1" == *"feat"* ]]; then
    release_type="minor"
  elif [[ "$1" == *"fix"* || "$1" == *"docs"* || "$1" == *"chore"* ]]; then
    release_type="patch"
  fi
  echo "$release_type"
}

PARENT_DIR="$PWD"
ROOT_DIR="."
echo "Removing Dist"
rm -rf "${ROOT_DIR:?}/dist"
COMMIT_MESSAGE="$(git log -1 --pretty=format:"%s")"
RELEASE_TYPE=${1:-$(getBuildType "$COMMIT_MESSAGE")}
DRY_RUN=${DRY_RUN:-"False"}

AFFECTED=$(node node_modules/.bin/nx affected:libs --plain --base=origin/master~1)
if [ "$AFFECTED" != "" ]; then
  cd "$PARENT_DIR"
  echo "Copy Environment Files"

  while IFS= read -r -d $' ' lib; do
    echo "Setting version for $lib"
    npm run nx release "$lib"
  done <<<"$AFFECTED " # leave space on end to generate correct output

  # git push origin master
  echo "Push the new tags"
  git push origin master --tags

  while IFS= read -r -d $' ' lib; do
    echo "Building $lib"
    npm run build "$lib" -- --with-deps
    wait
    if [ "$DRY_RUN" == "False" ]; then
      echo "Publishing $lib"
      npm publish "$ROOT_DIR/dist/libs/${lib/-//}" # --access=public
    else
      echo "Dry Run, not publishing $lib"
    fi
    wait
  done <<<"$AFFECTED " # leave space on end to generate correct output
else
  echo "No Libraries to publish"
fi
