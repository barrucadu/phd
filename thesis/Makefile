TEXFILES := $(wildcard *.tex)
BIBFILES := $(wildcard *.bib)

.PHONY: all

all: thesis.pdf

thesis.pdf: $(TEXFILES) $(BIBFILES)
	latexmk -pdf main.tex
