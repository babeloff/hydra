#!/usr/bin/env nu
# Generate GraphSON output from the GenPG health (copilot) dataset.
#
# Runs the GenPG translingual demo using the health dataset, exercising
# the Haskell, Java, and Python drivers and comparing their outputs.
# Output is written to demos/genpg/output/health.jsonl.
#
# See demos/genpg/README.md for setup and prerequisite instructions.
#
# Usage (from repo root):
#   pixi run -e haskell run-copilot-graphson

def main [
    --hosts: string = "haskell,java,python"  # Comma-separated list of host languages to run
] {
    ^bash demos/genpg/bin/run.sh --hosts $hosts health
}
