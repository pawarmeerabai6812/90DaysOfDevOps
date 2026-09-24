#!/bin/bash
#
# strict_demo.sh
# Demonstrates bash "strict mode": set -euo pipefail
#
# WHAT EACH FLAG DOES
# --------------------
# set -e          -> Exit the script immediately if any command returns
#                     a non-zero exit status (fails). Without this, bash
#                     just moves on to the next line even after a failure.
#
# set -u          -> Treat unset (undefined) variables as an error and
#                     exit immediately, instead of silently substituting
#                     an empty string.
#
# set -o pipefail -> In a pipeline (cmd1 | cmd2 | cmd3), normally only the
#                     EXIT CODE OF THE LAST COMMAND is checked. pipefail
#                     makes the whole pipeline fail (non-zero) if ANY
#                     command in it fails, not just the last one.
#
set -euo pipefail

echo "=== strict_demo.sh: set -euo pipefail ==="
echo ""

# ---------------------------------------------------------------------
# DEMO 1: set -u — using an undefined variable
# ---------------------------------------------------------------------
# The line below is left commented out because it would immediately
# kill this script (that's the whole point of -u). Uncomment to test:
#
# echo "Undefined var: $UNDEFINED_VAR"
#
# Expected result when uncommented:
#   strict_demo.sh: line X: UNDEFINED_VAR: unbound variable
#   (script exits immediately, "Report complete" never prints)

echo "[Demo 1] set -u: would fail on \$UNDEFINED_VAR (see comments in script)"

# ---------------------------------------------------------------------
# DEMO 2: set -e — a command that fails
# ---------------------------------------------------------------------
# The line below is left commented out for the same reason. Uncomment
# to test:
#
# ls /path/does/not/exist
#
# Expected result when uncommented:
#   ls: cannot access '/path/does/not/exist': No such file or directory
#   (script exits immediately with ls's non-zero exit code)

echo "[Demo 2] set -e: would fail on 'ls /path/does/not/exist' (see comments)"

# ---------------------------------------------------------------------
# DEMO 3: set -o pipefail — a failing command inside a pipeline
# ---------------------------------------------------------------------
# The line below is left commented out too. Uncomment to test:
#
# ls /path/does/not/exist | wc -l
#
# Without pipefail: the pipeline's exit code is wc's (0, success),
#   because wc -l happily counted 0 lines of empty input — the ls
#   failure is HIDDEN.
# With pipefail: the pipeline's exit code is non-zero (ls's failure),
#   so the script correctly stops.

echo "[Demo 3] pipefail: would fail on 'ls /nowhere | wc -l' (see comments)"

echo ""
echo "Report complete."