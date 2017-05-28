TEXFILES := $(wildcard *.tex)
BIBFILES := $(wildcard *.bib)

.PHONY: all clean

all: main.pdf

clean:
	-@rm *.{aux,bbl,blg,fdb_latexmk,fls,log,out,pdf,toc}

main.pdf: $(TEXFILES) $(BIBFILES)
	latexmk -xelatex -pdf main.tex
