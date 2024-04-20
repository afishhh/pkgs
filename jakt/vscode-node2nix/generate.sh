#!/usr/bin/env bash

IFS=$'\t\n'
set -euo pipefail

root="$(dirname "$0")"
cd "$root"
root=$(pwd)

# TODO: Move this code into this repository
# source ../../../scripts/scripts/lib/logging.sh
# source ../../../scripts/scripts/lib/utils.sh

# require nix sed

function log() {
	echo "$@"
}

function abort() {
	echo "error: $*" >&2
	exit 1
}


log "Building node2nix"
node2nix_path=$(nix build --no-link --print-out-paths nixpkgs#nodePackages.node2nix || abort "Failed to build node2nix")/bin/node2nix

log "Building nixpkgs-fmt"
nixpkgs_fmt_path=$(nix build --no-link --print-out-paths nixpkgs#nixpkgs-fmt || abort "Failed to build nixpkgs-fmt")/bin/nixpkgs-fmt

function node2nix() {
	"$node2nix_path" "$@"
}

function nixpkgs_fmt() {
	"$nixpkgs_fmt_path" "$@"
}

log "Fetching jakt source"
jakt_src_path=$(nix build \
	--file ./patched-src.nix outPath \
	--arg stdenv '(import (builtins.getFlake "nixpkgs") {}).stdenv' --no-link --print-out-paths
) ||
	abort "Failed to fetch jakt source"

function generate_one() {
	local out="${root:?}/$2"
	rm -r "$out"
	mkdir "$out"

	input_flags=(-i "$1/package.json")
	[[ -n "${3:-}" ]] && input_flags+=(-l "$1/package-lock.json")

	log "Running node2nix on <jakt>${1#"$jakt_src_path"}"
	node2nix -18 \
	         -o "$out"/node-packages.nix \
			 -e "$out"/node-env.nix \
			 -c "$out"/default.nix \
			 "${input_flags[@]}"

	# Replace relative references to the provided jakt source with a jakt-src.nix import
	python3 "$root"/fixup.py "$out"
	# This has to be done otherwise git pre-commit will complain
	nixpkgs_fmt "$out"/*.nix
}

generate_one "$jakt_src_path" root
generate_one "$jakt_src_path/server" server true
