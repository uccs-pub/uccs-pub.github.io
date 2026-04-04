#!/usr/bin/env bash
set -e

MSG="${1:-Update site}"

echo "==> Building Hugo site"
hugo

echo "==> Committing master branch"
git add -A
if ! git diff --cached --quiet; then
  git commit -m "$MSG"
else
  echo "No changes to commit on master"
fi

echo "==> Pushing master to GitHub and Codeberg"
git push github master
git push codeberg master

echo "==> Committing generated site in public/"
git -C public add -A
if ! git -C public diff --cached --quiet; then
  git -C public commit -m "$MSG"
else
  echo "No changes to commit in public repo"
fi

echo "==> Pushing public HEAD to pages on both remotes"
git -C public push github HEAD:pages
git -C public push codeberg HEAD:pages

echo "==> Done"
