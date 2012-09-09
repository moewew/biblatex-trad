################################################################
## Makefile for biblatex-trad project folder
################################################################
## Definitions
################################################################
.SILENT:
SHELL     := /bin/bash
.PHONY: all clean ctan allwithoutclean
################################################################
## Name list
################################################################
PACKAGE   = biblatex-trad
S_PLAIN   = trad-plain
S_UNSRT   = trad-unsrt
S_ALPHA   = trad-alpha
S_ABBRV   = trad-abbrv
S_STAND   = trad-standard
S_LIST    = $(S_PLAIN) $(S_UNSRT) $(S_ALPHA) $(S_UNSRT) $(S_STAND)
FILELIST  = $(S_LIST) $(PACKAGE)
AUXFILES  = aux dtxe glo glolog gls hd ins idx idxlog ilg ind log lot out ps thm tmp toc xdv
################################################################
## Colordefinition
################################################################
NO_COLOR    = \x1b[0m
OK_COLOR    = \x1b[32;01m
WARN_COLOR  = \x1b[33;01m
ERROR_COLOR = \x1b[31;01m
################################################################
## make help
################################################################
help:
	@echo 
	@echo -e "$(WARN_COLOR)The following definitions provided by this Makefile"
	@echo -e "$(OK_COLOR)\tmake pdf\t\t--\ttypesets the documenation"
	@echo -e "$(OK_COLOR)\tmake all\t\t--\trun doc clean"
	@echo -e "\tmake clean\t\t--\tremove all helpfiles"
	@echo -e "\tmake localinstall\t--\tinstall the package in TEXMFHOME"
	@echo -e "\tmake ctan\t--\tcreating a CTAN package"
	@echo -e "$(WARN_COLOR)End help$(NO_COLOR)"

################################################################
## Compilation
################################################################
doc: $(PACKAGE).tex
	echo -e "" ;\
	echo -e "\t$(WARN_COLOR)Typesetting $(PACKAGE).tex$(NO_COLOR)" ;\
	pdflatex --draftmode --interaction=nonstopmode $(PACKAGE).tex > /dev/null ;\
	if [ $$? = 0 ] ; then \
	  echo -e "\t$(OK_COLOR)compilation in draftmode without errors$(NO_COLOR)" ;\
	  pdflatex $(PACKAGE).tex > /dev/null ;\
	else \
	  echo -e "\t$(ERROR_COLOR)compilation in draftmode with errors$(NO_COLOR)" ;\
	  exit 0;\
	fi ;\

clean:  
	echo  "" ;\
	echo -e "\t$(WARN_COLOR)Start removing help files$(NO_COLOR)" ;\
	for I in $(FILELIST) ;\
	do \
	  for J in $(AUXFILES) ;\
	  do \
	    rm -rf $$I.$$J ;\
	  done ;\
	done ;\
        rm -rf arara.log
	echo -e "\t$(OK_COLOR)Removing finished$(NO_COLOR)" ;\

all:	doc clean

################################################################
## personal setting
################################################################
localinstall:
	echo  "" ;\
	echo -e "\t$(ERROR_COLOR)Start local install$(NO_COLOR)" ;\
	PATHTEXHOME=`kpsewhich --var-value=TEXMFHOME` ;\
	echo -e "\t$(ERROR_COLOR)Creating folders if don't exist$(NO_COLOR)" ;\
	mkdir -p $$PATHTEXHOME/doc/latex/$(PACKAGE)/ ;\
	mkdir -p $$PATHTEXHOME/tex/latex/$(PACKAGE)/bbx/ ;\
	mkdir -p $$PATHTEXHOME/tex/latex/$(PACKAGE)/cbx/ ;\
	cp $(PACKAGE).pdf $$PATHTEXHOME/doc/latex/$(PACKAGE)/  ;\
	cp $(PACKAGE).tex $$PATHTEXHOME/doc/latex/$(PACKAGE)/  ;\
	for I in $(S_LIST) ;\
	do \
	  cp $$I.bbx $$PATHTEXHOME/tex/latex/$(PACKAGE)/bbx/  ;\
	  cp $$I.cbx $$PATHTEXHOME/tex/latex/$(PACKAGE)/cbx/  ;\
	done ;\
	echo -e "\t$(OK_COLOR)Installation done$(NO_COLOR)" ;\

################################################################
## maintainer tool
################################################################
usectanify:
	echo  "" ;\
	echo -e "\t$(ERROR_COLOR)Start ctanify$(NO_COLOR)" ;\
	ctanify --pkgname=$(PACKAGE) $(PACKAGE).pdf README.txt \
	        $(PACKAGE).tex=doc/latex/$(PACKAGE)/ \
	        $(S_PLAIN).bbx=tex/latex/$(PACKAGE)/bbx/ \
	        $(S_PLAIN).cbx=tex/latex/$(PACKAGE)/cbx/ \
	        $(S_ALPHA).bbx=tex/latex/$(PACKAGE)/bbx/ \
	        $(S_ALPHA).cbx=tex/latex/$(PACKAGE)/cbx/ \
	        $(S_UNSRT).bbx=tex/latex/$(PACKAGE)/bbx/ \
	        $(S_UNSRT).cbx=tex/latex/$(PACKAGE)/cbx/ \
	        $(S_ABBRV).bbx=tex/latex/$(PACKAGE)/bbx/ \
	        $(S_ABBRV).cbx=tex/latex/$(PACKAGE)/cbx/ \
	        $(S_STAND).bbx=tex/latex/$(PACKAGE)/bbx/ \
	        $(S_STAND).cbx=tex/latex/$(PACKAGE)/cbx/ ;\
	if [ $$? = 0 ] ; then \
	     echo -e "\t$(OK_COLOR)ctanify without errors$(NO_COLOR)" ;\
	     echo -e "" ;\
	else \
	  echo -e "\t$(ERROR_COLOR)ctanify with errors$(NO_COLOR)" ;\
	  exit 0;\
	fi ;\

ctan: doc usectanify clean
