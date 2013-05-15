################################################################################
# Copyright 2011
# Andrew Redd
# 11/23/2011
#
# Description of File:
# Makefile for knitr compiling
# 
################################################################################
all:pdf  # default rule DO NOT EDIT
################################################################################
MAINFILE  := distributed.computing
RNWFILES  := 
RFILES    := 
TEXFILES  := 
CACHEDIR  := cache
FIGUREDIR := figure
LATEXMK_FLAGS := 
##### Explicit Dependencies #####
################################################################################
RNWTEX = $(RNWFILES:.Rnw=.tex)
ROUTFILES = $(RFILES:.R=.Rout)
RDATAFILES= $(RFILES:.R=.Rdata)
MAINTEX = $(MAINFILE:=.tex)
MAINPDF = $(MAINFILE:=.pdf)
ALLTEX = $(MAINTEX) $(RNWTEX) $(TEXFILES)

# Dependencies
$(RNWTEX): $(RDATAFILES)
$(MAINTEX): $(RNWTEX) $(TEXFILES)
$(MAINPDF): $(MAINTEX) $(ALLTEX) 

.PHONY:pdf tex clean clearcache cleanall
pdf: $(MAINPDF)
tex: $(RDATAFILES) $(ALLTEX) 

$(CACHEDIR):
	mkdir $(CACHEDIR)

$(FIGUREDIR):
	mkdir $(FIGUREDIR)

%.tex:%.Rnw
	Rscript \
	  -e "library(knitr)" \
	  -e "knitr::opts_chunk[['set']](fig.path='$(FIGUREDIR)/$*-')" \
	  -e "knitr::opts_chunk[['set']](cache.path='$(CACHEDIR)/$*-')" \
	  -e "knitr::knit('$<','$@')"


%.R:%.Rnw
	Rscript \
	  -e "library(knitr)" \
	  -e "knitr::opts_chunk[['set']](fig.path='$(FIGUREDIR)/$*-')" \
	  -e "knitr::opts_chunk[['set']](cache.path='$(CACHEDIR)/$*-')" \
	  -e "knitr::purl('$<','$@')"

%.Rout:%.R
	R CMD BATCH "$^" "$@"

%.pdf: %.tex 
	pdflatex $<

clean:
	rm -f $(MAINTEX) $(RNWTEX)
	rm -rf $(FIGUREDIR)
	rm $(MAINPDF)

clearcache:
	rm -rf cache

cleanall: clean clearcache
