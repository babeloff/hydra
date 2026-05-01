#!/usr/bin/env nu
# Generate GraphSON output from the GenPG example (sales) dataset.
#
# Runs the GenPG translingual demo using the sales example dataset,
# exercising the Haskell, Java, and Python drivers and comparing their
# outputs. Output is written to demos/genpg/output/sales.jsonl.
#
# See demos/genpg/README.md for setup and prerequisite instructions.
#
# Usage (from repo root):
#   pixi run -e haskell run-example-graphson

def main [
    --hosts: string = "haskell,java,python"  # Comma-separated list of host languages to run
] {
    ^bash demos/genpg/bin/run.sh --hosts $hosts sales
}
