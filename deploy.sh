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

echo "==> Committing pages branch in public/"
cd public
git add -A
if ! git diff --cached --quiet; then
  git commit -m "$MSG"
else
  echo "No changes to commit on pages"
fi

echo "==> Pushing pages to GitHub and Codeberg"
git push github pages
git push codeberg pages

echo "==> Done"
