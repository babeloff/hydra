# Hydra-Ext

This subproject contains domain-specific extensions to Hydra, currently
including the coders and models listed below.
Most of these artifacts are written in "raw" Haskell, rather than in the Hydra
DSL.
There are also a number of demos and tools also written in Haskell, as well as
a few artifacts in Java and Python.

JavaDocs for Hydra-Ext can be found [here](https://categoricaldata.github.io/hydra/hydra-ext/javadoc),
and releases can be found on Maven Central [here](https://central.sonatype.com/artifact/net.fortytwo.hydra/hydra-ext).

## Multi-Package Development Environment

Hydra-Ext is part of a multi-package Stack project:

- **`hydra-haskell`** - Core Hydra library (dependency)
- **`hydra-ext`** (this package) - Extensions, coders, and additional functionality

### Prerequisites and Setup

For the best development experience, use the conda-based environment setup from the project root:

```bash
# From the project root directory (hydra/)
# Install system dependencies
./install-haskell-deps.sh

# Set up ghcup-managed GHC and Stack with conda integration
pixi run -e haskell ./setup-ghcup-with-conda.sh
```

### Interactive Development

```bash
# From project root - start GHCi with both packages loaded
pixi run -e haskell ./run-stack-ghci.sh

# Or use specific pixi tasks
pixi run -e haskell ext-ghci          # Extensions package only
pixi run -e haskell ghci-all          # Both hydra and hydra-ext
```

### Building and Testing

```bash
# From project root
pixi run -e haskell ext-build         # Build hydra-ext
pixi run -e haskell ext-test          # Test hydra-ext  
pixi run -e haskell stack-build       # Build both packages
```

For detailed setup instructions, see [HASKELL_SETUP.md](../HASKELL_SETUP.md) in the project root.

## Coders

Hydra-Ext contains the following two-level coders:
* Avro
* Java
* Property graphs ("PG")
* Python
* Scala

The following are schema-only coders:
* C++
* C-sharp
* Graphql
* Pegagus (PDL)
* Protobuf
* SHACL

And the following are data-only coders:
* GraphSON
* GraphViz
* RDF

## Models

The following models are included:
* [Apache Atlas](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Models/Atlas.hs)
* [Azure DTLD](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Models/AzureDtld.hs)
* [Coq](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Models/Coq.hs)
* [Datalog](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Models/Datalog.hs)
* [GeoJSON](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Models/GeoJson.hs)
* [IANA Relations](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Models/IanaRelations.hs)
* [OSV](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Models/Osv.hs)
* [STAC Items](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Models/StacItems.hs)

These extensions are listed [here](https://github.com/CategoricalData/hydra/blob/main/hydra-ext/src/main/haskell/Hydra/Ext/Sources/All.hs),
and the generated Haskell APIs for all of these models can be found [here](https://github.com/CategoricalData/hydra/tree/main/hydra-ext/src/gen-main/haskell).
For the sake of space, only generated Haskell is checked in to the repository, but Java APIs can be generated from GHCi as follows:

```haskell
writeJava "src/gen-main/java" hydraExtModules
```

The generated Haskell can be updated using:

```haskell
writeHaskell "src/gen-main/haskell" hydraExtModules
```

## Development Environment with Pixi

This project uses [pixi](https://pixi.sh) for environment management and task automation. From the root hydra directory, you can:

### Start Interactive GHCi Session

**Note:** There is currently a known issue with the `Data.List.Split` dependency that may prevent direct GHCi loading of the Demo module. The GraphSON generation functions have already been executed and their output files are available (see below).

```bash
# Check if GraphSON files already exist (recommended first step)
pixi run -e haskell check-graphson

# Start GHCi with all necessary source paths (may encounter dependency issues)
pixi run -e haskell ghci-ext

# Or for a simpler GHCi session
pixi run -e haskell ghci-simple
```

### Run GraphSON Generation Functions

The project includes pre-built GraphSON generation functions that transform CSV data into property graph format:

```bash
# Check available data
pixi run -e haskell check-data

# View help for GraphSON functions
pixi run -e haskell graphson-help
```

**Available Generated Files (Already Generated):**
- `data/genpg/copilot.json` - Health/copilot data in GraphSON format (50KB)
- `data/genpg/sales.json` - Sales example data in GraphSON format (25KB)

**Check Generated Files:**
```bash
# List generated GraphSON files
pixi run -e haskell check-graphson

# Preview copilot data
pixi run -e haskell check-copilot-data

# Preview sales data
pixi run -e haskell check-sales-data
```

### Manual GHCi Workflow

**Current Issue:** Loading the Demo module may fail due to a missing `Data.List.Split` dependency in the GHCi environment. The functions have already been successfully executed, and the GraphSON files are available in `data/genpg/`.

If you need to run the functions manually in an interactive session:

```bash
pixi run -e haskell ghci-ext
```

Then in GHCi (may encounter dependency errors):
```haskell
:l Hydra.Ext.Demos.GenPG.Demo  -- May fail with Data.List.Split error
:t generateCopilotGraphSON      -- Check function type
generateCopilotGraphSON         -- Generate health data GraphSON
generateExampleGraphSON         -- Generate sales data GraphSON
```

**Alternative:** Since the GraphSON files are already generated, you can work with them directly:
```bash
# View the generated graph data
cat hydra-ext/data/genpg/copilot.json | head -20
cat hydra-ext/data/genpg/sales.json | head -20
```

### Other Available Tasks

```bash
# List available Haskell modules
pixi run -e haskell haskell-modules

# Clean build artifacts
pixi run -e haskell haskell-clean

# Interactive GHCi session focused on hydra-ext
pixi run -e haskell ghci-interactive
```

## Tools

Miscellaneous tools include:
* **Analysis**: utilities for analyzing the Hydra kernel or other Hydra graphs
  * **Dependencies**: creates a property graph out of the dependency structure of a Hydra graph
  * **Summaries**: creates textual summaries of a Hydra graph, e.g. for training an LLM
* **AvroWorkflows**: transform Avro schemas and matching JSON data to one of multiple targets (RDF with SHACL, property graphs with schemas)
* **Csv**: utilities for working with CSV data
* **OsvToRdf**: transform [OSV](https://osv.dev) dumps to RDF
* **PropertyGraphToRdf**: like the name
* **Tabular**: utilities for working with tabular data

## Demos

* **GenPG**: uses an LLM to generate Hydra schemas and mappings based on tabular data sources. There is a demo video [here](https://drive.google.com/file/d/10HCElcG7n0tprOTdtX4bSa5yWYs08nV-/view?usp=sharing).
* **AvroToPropertyGraphs**: transforms a specific Avro schema and matching sample JSON to a property graph representation
* **MeteredEvaluation**: demonstrates term reduction with logging, e.g. for tracking usage or estimating cost

### GenPG

This demo provides an example of a hands-off graph generation workflow using an LLM for schema and transform design.
See the demo video linked above to understand how the demo works.
To run it yourself, you will need a small tabular dataset which illustrates the structure of your data.
You can find example datasets in
[src/main/python/hydra/demos/genpg/sales](https://github.com/CategoricalData/hydra/tree/main/hydra-ext/data/genpg/sales)
and [src/main/python/hydra/demos/genpg/health](https://github.com/CategoricalData/hydra/tree/main/hydra-ext/data/genpg/health);
the former is a reference dataset which is built into the workflow,
and the latter is a stand-in for your own domain-specific dataset.
Feel free to start with the provided `health` dataset, or insert your own from the beginning.

While in the hydra-ext directory, start by generating a prompt based on these two datasets:

```bash
python3 src/main/python/hydra/demos/genpg/generate_prompt.py data/genpg/sources/health > data/genpg/prompt.txt
```

Now, take this prompt (`data/genpg/prompt.txt`; note that this is checked in to the repository for visibility, but your command will have overwritten it) and
1. Copy it into your favorite LLM chat interface
([ChatGPT](https://chatgpt.com), [Claude](https://claude.ai), etc.; Claude was used in the video). Then,
2. Copy the LLM-generated files to their expected locations under `src/gen-main/haskell/Hydra/Ext/Demos/GenPG/Generated`.
Just overwrite the files which are already checked in at that location.
Feel free to use any file system integration available in your tool, if you want to avoid the tedium of manual copy-and-paste.

Finally, enter GHCi. You can use either the traditional Stack approach or the modern pixi-based workflow:

**Important Note:** There is currently a `Data.List.Split` dependency issue that may prevent loading the Demo module. However, the GraphSON generation functions have already been executed successfully, and the output files are available.

**Option 1: Check existing files first (Recommended)**
```bash
# From the root hydra directory - check if files already exist
pixi run -e haskell check-graphson
ls -la hydra-ext/data/genpg/*.json
```

**Option 2: Using pixi with GHCi (may encounter dependency issues)**
```bash
# From the root hydra directory
pixi run -e haskell ghci-ext
```

**Option 3: Using Stack directly (may encounter dependency issues)**
```bash
stack ghci
```
You will need to have installed [Haskell Tool Stack](https://docs.haskellstack.org/en/stable) ("Stack") first,
as is also described in the Hydra-Haskell README.

Once in the REPL, there are two built-in demo routines you can use,
both of which run a Hydra transform to generate graph data in [GraphSON](https://github.com/apache/tinkerpop/blob/master/docs/src/dev/io/graphson.asciidoc),
a property graph serialization format.
You can then load these graphs into a TinkerPop-compatible graph database,
into [G.V()](https://gdotv.com) for visualization, etc.

**Check if graphs already exist (Recommended first step):**
The GraphSON files are already generated and available:
```bash
# From root hydra directory
ls -la hydra-ext/data/genpg/*.json
head -5 hydra-ext/data/genpg/copilot.json  # Preview copilot data
head -5 hydra-ext/data/genpg/sales.json    # Preview sales data

# Or use pixi tasks
pixi run -e haskell check-graphson
pixi run -e haskell check-copilot-data
pixi run -e haskell check-sales-data
```

**Load the Demo module (may encounter dependency issues):**
```haskell
:l Hydra.Ext.Demos.GenPG.Demo  -- May fail with Data.List.Split error
```

**Generate graphs (if module loads successfully):**
```haskell
-- Generate graph based on the built-in reference dataset (sales)
generateExampleGraphSON
-- Result: data/genpg/sales.json

-- Generate graph based on the health dataset (or your custom dataset)
generateCopilotGraphSON  
-- Result: data/genpg/copilot.json
```

And that's it! What you have just done is to:
1. Teach the LLM how to write schemas and transforms in Hydra, using a specific reference dataset as an example.
2. Show the LLM a new dataset, and ask it to generate a schema and transform.
This is out of Hydra's control, so hopefully the LLM did a good job!
3. Use your shiny new Hydra schema and transform to generate a property graph. This phase of the demo is completely deterministic, fast, and scalable.

If you want to visualize your generated graph(s) in G.V(),
simply open the desktop interface and load the GraphSON files when you create a new graph playground.
You can re-load them with Gremlin commands like:

```gremlin
g.io("/path/to/hydra/hydra-ext/data/genpg/sales.json").read().iterate()
g.io("/path/to/hydra/hydra-ext/data/genpg/copilot.json").read().iterate()
```

Run a Gremlin query like `g.E()`, and off you go.

The Haskell sources of this demo are available [here](https://github.com/CategoricalData/hydra/tree/main/hydra-ext/src/main/haskell/Hydra/Ext/Demos/GenPG).

### AvroToPropertyGraphs

To run the `AvroToPropertyGraphs` demo, first enter GHCi using `pixi run -e haskell ghci-ext` or `stack ghci`, then:

```haskell
import Hydra.Tools.AvroWorkflows
import Hydra.Demos.AvroToPropertyGraphs

-- Arguments
jsonLastMile = propertyGraphJsonLastMile examplePgSchema () ()
graphsonLastMile = propertyGraphGraphsonLastMile exampleGraphsonContext examplePgSchema () ()
aviationSchema = "src/test/avro/aviationdemo/AirplaneInfo.avsc"
aviationDataDir = "src/test/json/aviationdemo"
movieSchema = "src/test/avro/moviedemo/Review.avsc"
movieDataDir = "src/test/json/moviedemo"
outDir = "/tmp/avro-pg-demo/output"

-- Try a few combinations
transformAvroJsonToPg jsonLastMile aviationSchema aviationDataDir outDir
transformAvroJsonToPg graphsonLastMile aviationSchema aviationDataDir outDir
transformAvroJsonToPg jsonLastMile movieSchema movieDataDir outDir
transformAvroJsonToPg graphsonLastMile movieSchema movieDataDir outDir
```

## Code generation

Java generation is similar to Haskell generation (see the [Hydra-Haskell README](https://github.com/CategoricalData/hydra/blob/main/hydra-haskell/README.md)), e.g.

```haskell
writeJava "../hydra-java/src/gen-main/java" mainModules
```

For Java tests, use:

```haskell
writeJava "../hydra-java/src/gen-test/java" testModules
```

Scala generation has known bugs, but you can try it out with:

```haskell
writeScala "../hydra-scala/src/gen-main/scala" kernelModules
```

There is schema-only support for GraphQL:

```haskell
import Hydra.Sources.Langs.Graphql.Syntax
import Hydra.Sources.Langs.Json.Model
writeGraphql "/tmp/graphql" [graphqlSyntaxModule, jsonModelModule]
```

Because GraphQL does not support imports, the GraphQL coder will gather all of the dependencies of a given module together,
and map them to a single `.graphql` file.
Hydra has a similar level of schema-only support for [Protobuf](https://protobuf.dev/):

```haskell
writeProtobuf "/tmp/proto" [jsonModelModule]
```

...and similarly for [PDL](https://linkedin.github.io/rest.li/pdl_schema):

```haskell
writePdl "/tmp/pdl" [jsonModelModule]
```

Note that neither the Protobuf nor PDL coder currently supports polymorphic models.
