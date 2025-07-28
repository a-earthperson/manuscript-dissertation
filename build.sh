#!/usr/bin/env bash

set -euo pipefail

# -----------------------------------------------------------------------------
# Build helper for compiling the dissertation locally.
# Mimics the behaviour of Overleaf's build process as specified in `LatexMk`.
# -----------------------------------------------------------------------------
# Usage examples:
#   ./build.sh                  # compile using defaults (lualatex, output to build/)
#   ./build.sh -c               # clean auxiliary files (latexmk -C)
#   ./build.sh -o out/pdf       # change output directory
#   ./build.sh -e xelatex       # change engine
#   ./build.sh -f alt.tex       # compile a different main tex file
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR"

# -------------------------- Default configuration --------------------------- #
ENGINE="lualatex"          # TeX engine to use (matches Overleaf default)
OUTDIR="build"             # where to place auxiliary + final PDF files
MAIN_TEX="main.tex"        # entry point
CONFIG_FILE="LatexMk"      # latexmkrc replacement
EXTRA_OPTS="-shell-escape -interaction=nonstopmode -file-line-error" # minted, better logs
CLEAN=0

# --------------------------- Helper functions ------------------------------ #
check_cmd() {
  local cmd="$1" msg="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: Required command '$cmd' not found. $msg" >&2
    exit 1
  fi
}

# Font check (non-fatal): warn if fallback will be used
check_font() {
  local font="$1"
  if command -v fc-list >/dev/null 2>&1; then
    if ! fc-list | grep -qi "$font"; then
      echo "Warning: Font '$font' not found – the document will fall back to a bundled alternative." >&2
    fi
  fi
}

# ------------------------------- CLI parsing -------------------------------- #
print_help() {
  cat <<EOF
Usage: ./build.sh [options]

Options:
  -c, --clean            Clean auxiliary files instead of compiling.
  -o, --outdir DIR       Output directory (default: $OUTDIR).
  -e, --engine ENGINE    TeX engine (lualatex, xelatex, pdflatex...). Default: $ENGINE.
  -f, --file  FILE       Main .tex file to compile (default: $MAIN_TEX).
  -h, --help             Show this message and exit.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--clean) CLEAN=1; shift;;
    -o|--outdir) OUTDIR="$2"; shift 2;;
    -e|--engine) ENGINE="$2"; shift 2;;
    -f|--file)   MAIN_TEX="$2"; shift 2;;
    -h|--help)   print_help; exit 0;;
    *) echo "Unknown option: $1"; print_help; exit 1;;
  esac
done

# ----------------------------- Pre-flight checks ---------------------------- #
# Ensure inkscape (for svg conversion) and xindy (used by makeglossaries) are
# present.  These are available from MacTeX or via Homebrew.  Abort early with
# actionable guidance if missing.

check_cmd inkscape "Install via: brew install --cask inkscape"
check_cmd xindy    "Install via: brew install --cask mactex or mactex-no-gui"

# Non-fatal font advice
check_font "Noto Serif Devanagari"

# Glossaries: create a default style file if it doesn’t exist so xindy is happy
STEM="${MAIN_TEX%.tex}"
[[ -f "${STEM}.xdy" ]] || touch "${STEM}.xdy"

# Default to using the built-in xindy style if none provided
export XINDYOPTS="${XINDYOPTS:--M default}"

# Ensure output directory exists
mkdir -p "$OUTDIR"

# ------------------------------ Build / Clean ------------------------------ #
if [[ $CLEAN -eq 1 ]]; then
  echo "Cleaning auxiliary files (output dir: $OUTDIR) …"
  latexmk -r "$CONFIG_FILE" -${ENGINE} -outdir="$OUTDIR" -C
  exit 0
fi

echo "Building $MAIN_TEX → $OUTDIR/ using $ENGINE …"
latexmk -r "$CONFIG_FILE" -${ENGINE} $EXTRA_OPTS -outdir="$OUTDIR" "$MAIN_TEX"

# Copy final PDF next to build script for quick access
PDF_NAME="${MAIN_TEX%.tex}.pdf"
if [[ -f "$OUTDIR/$PDF_NAME" ]]; then
  cp "$OUTDIR/$PDF_NAME" "./$PDF_NAME"
  echo "PDF available at ./$PDF_NAME (original in $OUTDIR/)"
fi

