#!/usr/bin/env bash

set -euo pipefail
here=$(realpath "$(dirname "$0")")
nix repl --expr \
	'{ pkgs = import (builtins.getFlake "nixpkgs") { overlays = [ (builtins.getFlake "path:'"$here"'").overlays.default ]; }; }'
