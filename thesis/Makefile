TEXFILES := $(shell find . -type f -name '*.tex')
BIBFILES := $(shell find . -type f -name '*.bib')
GENFILES := $(shell find . -type f -name '*.gnuplot' | sed 's:scripts:gen:' | sed 's:gnuplot:tex:')

.PHONY: all clean lint wc

all: main.pdf

clean:
	-@rm *.{aux,bbl,blg,fdb_latexmk,fls,log,out,pdf,toc}
	-@rm -r gen

lint:
	vale *.tex
	@echo
	proselint *.tex

wc:
	texcount -inc main.tex | grep "Words in text" | tail -n1

main.pdf: $(TEXFILES) $(BIBFILES) $(GENFILES)
	latexmk -xelatex -pdf -latexoption=--shell-escape main.tex

gen/%.tex: scripts/%.gnuplot data/counts.csv gen
	$<

gen:
	mkdir gen
