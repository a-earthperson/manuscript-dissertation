#!/usr/bin/env bash

set -euo pipefail

# -----------------------------------------------------------------------------
# Remove auxiliary files produced during compilation.
# This is essentially a convenience wrapper around `latexmk -C` and a
# removal of the build directory used by `build.sh`.
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR"

OUTDIR="build"
MAIN_TEX="main.tex"
CONFIG_FILE="LatexMk"

# Allow caller to override the output directory, if needed
if [[ $# -gt 0 ]]; then
  OUTDIR="$1"
fi

# Clean via latexmk
if command -v latexmk >/dev/null 2>&1; then
  latexmk -r "$CONFIG_FILE" -C -outdir="$OUTDIR" "$MAIN_TEX" || true
fi

# Remove additional LaTeX auxilliary files
rm -rf "$OUTDIR" \
       "${MAIN_TEX%.tex}.pdf" \
       *.acn *.acr *.alg *.aux *.bbl *.blg \
       *.fls *.fdb_latexmk *.glo *.gls *.ist *.log *.lof *.lot *.toc *.out \
       *.xdy

# Remove TeX4ht / make4ht intermediate artefacts
rm -f  *.html *.css *.idv *.lg *.dvi *.run.xml *.tmp *.xref *x.svg 20*-main* || true

# Remove HTML output dir created by make4ht
rm -rf output

# Remove folder created by svg package / inkscape CLI
rm -rf svg-inkscape

echo "Clean complete."
