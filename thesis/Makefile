TEXFILES := $(wildcard *.tex)
BIBFILES := $(wildcard *.bib)

.PHONY: all

all: thesis.pdf

thesis.pdf: $(TEXFILES) $(BIBFILES) gen/wordcount.tex
	latexmk -pdf thesis.tex

gen/wordcount.tex: $(TEXFILES) gen
	texcount -inc -template='{SUM}\n' -total thesis.tex > gen/wordcount.tex

gen:
	mkdir gen
