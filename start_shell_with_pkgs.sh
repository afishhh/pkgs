#!/usr/bin/env bash

set -euo pipefail
here=$(realpath "$(dirname "$0")")
nix repl --expr \
	'rec { outputs = (builtins.getFlake "path:'"$here"'"); pkgs = import (builtins.getFlake "nixpkgs") { overlays = [ outputs.overlays.default ]; }; }'
