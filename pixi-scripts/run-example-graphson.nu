#!/usr/bin/env nu

# Run Example GraphSON Generation
# This script loads the Hydra extension demo module and generates GraphSON for example/sales data

print "Generating GraphSON for Example/Sales data using Hydra extensions..."

# Prepare the GHCi commands
let ghci_commands = ":l Hydra.Ext.Demos.GenPG.Demo
generateExampleGraphSON
:quit
"

print "Loading Hydra.Ext.Demos.GenPG.Demo module and running generateExampleGraphSON..."
print ""

# Send commands to stack ghci
$ghci_commands | ^stack ghci hydra-ext --system-ghc

print ""
print "Example GraphSON generation completed."
print "Check the output directory for the generated GraphSON files."
