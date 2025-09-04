#!/usr/bin/env nu

# Simple Haskell code generation from hydraExtModules
print "Generating Haskell code from hydraExtModules..."

# Set up environment
$env.PATH = $"($env.CONDA_PREFIX)/.ghcup/bin:/usr/bin:/bin:/usr/local/bin"
$env.LD_LIBRARY_PATH = $"/usr/lib64:/lib64:($env.LD_LIBRARY_PATH? | default '')"

# Create output directory
mkdir hydra-haskell/src/gen-main/haskell

# Generate Haskell code
let ghci_commands = "import Hydra.Kernel
import Hydra.Generation
import Hydra.Ext.Generation
import Hydra.Ext.Sources.All
writeHaskell \"hydra-haskell/src/gen-main/haskell\" hydraExtModules
:quit
"

$ghci_commands | ^stack ghci hydra-ext --system-ghc

print "Haskell generation completed."
