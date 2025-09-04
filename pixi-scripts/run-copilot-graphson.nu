#!/usr/bin/env nu

# Run Copilot GraphSON Generation
# This script loads the Hydra extension demo module and generates GraphSON for copilot data

print "Generating GraphSON for Copilot data using Hydra extensions..."

# Prepare the GHCi commands
let ghci_commands = ":l Hydra.Ext.Demos.GenPG.Demo
generateCopilotGraphSON
:quit
"

print "Loading Hydra.Ext.Demos.GenPG.Demo module and running generateCopilotGraphSON..."
print ""

# Send commands to stack ghci
$ghci_commands | ^stack ghci hydra-ext --system-ghc

print ""
print "Copilot GraphSON generation completed."
print "Check the output directory for the generated GraphSON files."
