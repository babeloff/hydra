#!/usr/bin/env nu

# Simple Java code generation from hydraExtModules
print "Generating Java code from hydraExtModules..."

# Set up environment
$env.PATH = $"($env.CONDA_PREFIX)/.ghcup/bin:/usr/bin:/bin:/usr/local/bin"
$env.LD_LIBRARY_PATH = $"/usr/lib64:/lib64:($env.LD_LIBRARY_PATH? | default '')"

# Create output directory
mkdir hydra-java/src/gen-main/java

# Generate Java code
let ghci_commands = "import Hydra.Kernel
import Hydra.Generation
import Hydra.Ext.Generation
import Hydra.Ext.Sources.All
writeJava \"hydra-java/src/gen-main/java\" hydraExtModules
:quit
"

$ghci_commands | ^stack ghci hydra-ext --system-ghc

print "Java generation completed."
