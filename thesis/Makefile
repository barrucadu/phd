TEXFILES := $(wildcard *.tex)
BIBFILES := $(wildcard *.bib)

.PHONY: all

all: main.pdf

main.pdf: $(TEXFILES) $(BIBFILES)
	latexmk -xelatex -pdf main.tex
