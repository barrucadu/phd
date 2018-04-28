TEXFILES := $(shell find . -type f -name '*.tex')
BIBFILES := $(shell find . -type f -name '*.bib')
GENFILES := $(shell find . -type f -name '*.gnuplot' | sed 's:scripts:gen:' | sed 's:gnuplot:tex:')

.PHONY: all clean lint wc

all: thesis.pdf seminar.pdf

clean:
	-@rm *.{aux,bbl,bcf,blg,fdb_latexmk,fls,lof,log,lol,lot,nav,out,pdf,snm,toc,vrb,xdv,xml}
	-@rm -r _minted-*
	-@rm -r gen

lint:
	vale *.tex
	@echo
	proselint *.tex

wc:
	texcount -inc thesis.tex | grep "Words in text" | tail -n1

%.pdf: %.tex $(TEXFILES) $(BIBFILES) $(GENFILES)
	latexmk -pdfxe -latexoption=--shell-escape $<

gen/%.tex: scripts/%.gnuplot data/counts.csv gen
	$<

gen:
	mkdir gen
