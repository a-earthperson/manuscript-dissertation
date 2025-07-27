The easiest way to compile this document is to <a href="https://www.overleaf.com/learn/how-to/I_have_created_a_LaTeX_document_elsewhere—can_I_import_it_into_Overleaf%3F">import it in Overleaf</a>.

## PDF
```zsh
latexmk -r LatexMk -lualatex main.tex
```

## HTML
```zsh
make4ht --loglevel warning -f html5+common_domfilters+detect_engine+staticsite+inlinecss+mjcli --output-dir output/html main.tex
```