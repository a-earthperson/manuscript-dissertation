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
html:
	make4ht --loglevel warning -f html5+common_domfilters+detect_engine+staticsite+inlinecss+mjcli --output-dir output/html main.tex 