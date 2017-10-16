TEXFILES := $(shell find . -type f -name '*.tex')
BIBFILES := $(shell find . -type f -name '*.bib')
GENFILES := $(shell find . -type f -name '*.gnuplot' | sed 's:scripts:gen:' | sed 's:gnuplot:tex:')

.PHONY: all clean

all: main.pdf

clean:
	-@rm *.{aux,bbl,blg,fdb_latexmk,fls,log,out,pdf,toc}
	-@rm -r gen

main.pdf: $(TEXFILES) $(BIBFILES) $(GENFILES)
	latexmk -xelatex -pdf main.tex

gen/%.tex: scripts/%.gnuplot data/counts.csv gen
	$<

gen:
	mkdir gen
