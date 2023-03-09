#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo "Please provide a tag."
	echo "Usage: ./release.sh v[X.Y.Z]"
	exit
fi

echo "Preparing $1..."
# update the version
msg="# managed by release.sh"
sed -E -i "s/^version = .* $msg$/version = \"${1#v}\" $msg/" Cargo.toml

# update the changelog
sed -E -i "s/\s+\#\s(.*)\s\#\sreplace issue numbers/\\t\1/g" cliff.toml
git cliff --tag "$1" >CHANGELOG.md
git restore config/cliff.toml
git add -A && git commit -m "chore(release): prepare for $1"
git show

changelog=$(git cliff --unreleased --strip all)
git tag -a "$1" -m "Release $1" -m "$changelog"
echo "Done!"