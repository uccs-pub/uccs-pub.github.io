#!/usr/bin/env bash
set -e

MSG="${1:-Update site}"

echo "==> Commit and push source"
git add -A
if ! git diff --cached --quiet; then
  git commit -m "$MSG"
fi
git push github master
git push codeberg master

echo "==> Recreate public as pages worktree"
rm -rf public
git worktree prune
git worktree add -B pages public github/pages

echo "==> Build Hugo into public/"
hugo

echo "==> Commit and push only generated site"
git -C public add -A
if ! git -C public diff --cached --quiet; then
  git -C public commit -m "$MSG"
fi
git -C public push github pages
git -C public push codeberg pages
