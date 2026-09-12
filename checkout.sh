#!/bin/bash
# Clones every repo that's part of the QAT1.5 / kernel-6.12 port, each
# already on the branch relevant to this work, into
# $BASE_DIR/<owner>/<repo> (default: ~/git/github, matching the layout
# this was originally developed in).
#
# Usage: ./checkout.sh [BASE_DIR]

set -e

BASE_DIR="${1:-$HOME/git/github}"

clone_at() {
	local owner="$1" repo="$2" branch="$3"
	local dir="$BASE_DIR/$owner/$repo"
	if [ -d "$dir/.git" ]; then
		echo "already present, skipping: $dir"
		return
	fi
	echo "cloning $owner/$repo @ $branch -> $dir"
	git clone -b "$branch" "https://github.com/$owner/$repo.git" "$dir"
}

# This repo: patch-set archive / OpenWrt package build ingredient.
clone_at mab-wien   qat-c2xxx-patches               master

# Vendor driver source, forked from lecoq/qat_c2xxx, with the kernel-6.12
# compatibility fixes as individual commits on top. PR:
# https://github.com/lecoq/qat_c2xxx/pull/2
clone_at mab-wien   qat_c2xxx                       kernel-6.12-compat

# OpenWrt package feed, forked from dl12345/quickassist-openwrt-denverton,
# with the same fixes added as patches + a Makefile update. PR:
# https://github.com/dl12345/quickassist-openwrt-denverton/pull/1
clone_at mab-wien   quickassist-openwrt-denverton   kernel-6.12-c2xxx

echo "done."
