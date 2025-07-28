# Simple Makefile wrapper around build and cleanup scripts

.PHONY: pdf html clean deps

# Default target
pdf:
	./build.sh

clean:
	./cleanup.sh

deps:
	./requirements-macos.sh 

# HTML target using make4ht with options documented in README
HTML_OUTDIR = output/html

html:
	mkdir -p $(HTML_OUTDIR)
	make4ht -x --shell-escape -l -s --loglevel warning -f html5+common_domfilters+staticsite+inlinecss+mjcli --output-dir $(HTML_OUTDIR) main.tex 

html-clean:
	./cleanup.sh $(HTML_OUTDIR) 