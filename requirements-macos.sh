#!/usr/bin/env bash

# Quick one-liner to install system dependencies required for local compilation
# of the dissertation on macOS via Homebrew.

set -euo pipefail

# Ensure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required but not found. Install from https://brew.sh first." >&2
  exit 1
fi

brew tap homebrew/cask-fonts || true

# TeX distribution (includes xindy)
if ! command -v xindy >/dev/null 2>&1; then
  brew install --cask mactex-no-gui
fi

# Inkscape CLI for SVG conversion
if ! command -v inkscape >/dev/null 2>&1; then
  brew install --cask inkscape
fi

# Devanagari font
if ! fc-list | grep -qi "NotoSerifDevanagari"; then
  brew install --cask font-noto-serif-devanagari
fi

echo "✅ All LaTeX build dependencies installed." 