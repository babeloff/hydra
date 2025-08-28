#!/bin/bash
# Hydra multi-language wrapper script

show_help() {
    echo "Hydra - Type-safe transformations for data and programs"
    echo ""
    echo "Usage: hydra <variant> [args...]"
    echo ""
    echo "Available variants:"
    echo "  java     - Run Hydra Java implementation"
    echo "  python   - Run Hydra Python implementation"
    echo "  haskell  - Run Hydra Haskell implementation"
    echo "  scala    - Run Hydra Scala implementation"
    echo ""
    echo "Examples:"
    echo "  hydra java --help"
    echo "  hydra python -c 'import hydra; print(hydra.__version__)'"
    echo "  hydra haskell --version"
    echo ""
}

if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

variant="$1"
shift

case "$variant" in
    java)
        exec hydra-java "$@"
        ;;
    python)
        exec python "$@"
        ;;
    haskell)
        # Try to find a Haskell executable or fall back to ghci
        if command -v hydra-haskell >/dev/null 2>&1; then
            exec hydra-haskell "$@"
        else
            echo "Starting GHCi with Hydra library..."
            exec ghci "$@"
        fi
        ;;
    scala)
        exec hydra-scala "$@"
        ;;
    *)
        echo "Error: Unknown variant '$variant'"
        echo ""
        show_help
        exit 1
        ;;
esac
