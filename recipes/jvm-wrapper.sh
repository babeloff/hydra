#!/bin/bash
# Unified JVM wrapper for Hydra main package
# This wrapper finds all JAR files in the main hydra lib directory

HYDRA_HOME="${CONDA_PREFIX}/lib/hydra"

# Check if the hydra lib directory exists
if [ ! -d "${HYDRA_HOME}" ]; then
    echo "Error: Hydra library directory not found at ${HYDRA_HOME}" >&2
    exit 1
fi

# Find all JAR files and create classpath
CLASSPATH=$(find "${HYDRA_HOME}" -name "*.jar" 2>/dev/null | tr '\n' ':')

# Remove trailing colon if present
CLASSPATH="${CLASSPATH%:}"

# Check if we found any JAR files
if [ -z "${CLASSPATH}" ]; then
    echo "Error: No JAR files found in ${HYDRA_HOME}" >&2
    exit 1
fi

# Execute Java with the constructed classpath
exec java -cp "${CLASSPATH}" "$@"
