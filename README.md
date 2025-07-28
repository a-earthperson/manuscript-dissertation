# 📚 Dissertation Build Guide

This folder contains the LaTeX source for my PhD dissertation.

---

## About

The project is designed so that you can compile the thesis **either online via Overleaf** or **locally on macOS/Linux** with a single command.  A lightweight build helper script keeps the local workflow in sync with Overleaf’s tool-chain (namely `latexmk` with a custom `LatexMk` configuration).

Directory layout (excerpt):

```
manuscript-dissertation/
├─ LateXmk            # overleaf-compatible latexmkrc file (named just `LatexMk`)
├─ build.sh           # one-stop local build helper (PDF & aux files → ./build/)
├─ cleanup.sh         # remove auxiliary artefacts produced by LaTeX/HTML builds
├─ requirements-macos.sh  # installs TeX & ancillary CLIs via Homebrew
├─ Makefile           # thin wrapper around the helper scripts
└─ main.tex           # top-level entry point
```

---

## Quick-start (local)

```zsh
# clone repo then …
cd manuscript-dissertation
./build.sh            # ⇢ build/main.pdf (also copies PDF next to script)
```

> The script auto-detects **`latexmk`**, **Inkscape** (for SVG conversion) and **xindy** (used by glossaries).  It aborts early with actionable guidance if a dependency is missing.

### Script options

```
./build.sh [options]
  -c, --clean            # clean aux files instead of compiling
  -o, --outdir DIR       # change output directory (default: build)
  -e, --engine ENGINE    # TeX engine (lualatex|xelatex|pdflatex…)
  -f, --file  FILE       # compile a different main .tex file
  -h, --help             # show full help text
```

## Makefile conveniences

The accompanying `Makefile` simply delegates to the helper scripts so you don’t need to memorise the flags:

```zsh
make pdf    # same as ./build.sh
make html   # HTML via make4ht (outputs to ./output/html)
make clean  # same as ./cleanup.sh
make deps   # run requirements-macos.sh (macOS only)
```

---

## Cleaning up

```zsh
./build.sh --clean   # or: make clean
# …removes ./build/, the copied PDF, glossaries, aux files, and HTML artefacts
```

---

## Dependency installation (macOS)

A helper script installs MacTeX, Inkscape and the required fonts via Homebrew:

```zsh
./requirements-macos.sh
```

If you are on Linux just ensure TeX Live (full), Inkscape, and `xindy` are present.

---

## Building on Overleaf

The project works out-of-the-box on Overleaf because they honour the custom `LatexMk` configuration.  Simply upload the `manuscript-dissertation` folder or use Overleaf’s Git integration.

---

## HTML output

HTML generation uses `make4ht` with MathJax and inlined CSS:

```zsh
make html  # artefacts in output/html/
```

---

## Plain latexmk usage (expert mode)

If you prefer calling `latexmk` directly the equivalent command is:

```zsh
latexmk -r LatexMk -lualatex -shell-escape -interaction=nonstopmode -file-line-error -outdir=build main.tex
```

Adjust the engine/flags/outdir to taste.

---

Happy TeX-ing!