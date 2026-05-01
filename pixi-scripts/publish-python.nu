#!/usr/bin/env nu
# Publish Python wheels to PyPI or TestPyPI using credentials from ~/.pypirc.
#
# Prerequisites:
#   - wheels/ must already be populated (run `pixi run build-python` first).
#   - ~/.pypirc must contain a [pypi] or [testpypi] section with a password (API token).
#
# Usage (from repo root):
#   nu pixi-scripts/publish-python.nu          # publish to PyPI
#   nu pixi-scripts/publish-python.nu testpypi # publish to TestPyPI

def main [
    registry: string = "pypi"  # ~/.pypirc section to use: "pypi" or "testpypi"
] {
    let pypirc = ($env.HOME | path join ".pypirc")
    if not ($pypirc | path exists) {
        error make {msg: $"~/.pypirc not found at ($pypirc)"}
    }

    let config = (open --raw $pypirc | from toml)
    if not ($registry in $config) {
        error make {msg: $"~/.pypirc has no [($registry)] section"}
    }

    let token = $config | get $registry | get password

    let files = (ls wheels/ | where name =~ '\.(whl|tar\.gz)$' | get name)
    if ($files | is-empty) {
        error make {msg: "No .whl or .tar.gz files found in wheels/; run `pixi run build-python` first"}
    }

    let url_flag = if $registry == "testpypi" {
        ["--publish-url", "https://test.pypi.org/legacy/"]
    } else {
        []
    }

    with-env {UV_PUBLISH_TOKEN: $token} {
        ^uv publish ...$url_flag ...$files
    }
}
