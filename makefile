MAIN_TEX = moran.tex
CHAP_CITE_TEX =

OTHER_SRC_FILES = \
	references.bib \
	acknowledgements/acknowledgements.tex \
	abstract/abstract.tex \
	chapter1/contents.tex \
	chapter2/contents.tex \
	chapter3/contents.tex \
	chapter4/contents.tex \
	chapter5/contents.tex \
	chapter6/contents.tex \
	appendix/*.tex

LATEX = latex
PDFLATEX = pdflatex
DVIPS = dvips

.SUFFIXES: .tex .dvi .pdf .ps

CHAP_CITE = $(CHAP_CITE_TEX:.tex=)
MAIN_DVI  = $(MAIN_TEX:.tex=.dvi)
MAIN_PS   = $(MAIN_TEX:.tex=.ps)
MAIN_PDF	= $(MAIN_TEX:.tex=.pdf)

dvi: $(MAIN_DVI)
ps: $(MAIN_PS)
pdf: $(MAIN_PDF)

all: dvi ps pdf

$(MAIN_PS): $(MAIN_DVI)
$(MAIN_DVI): $(MAIN_TEX) $(CITE_TEX) $(OTHER_SRC_FILES)
$(MAIN_PDF): $(MAIN_TEX) $(CITE_TEX) $(OTHER_SRC_FILES)

#
# General rules
#

.tex.dvi:
	@$(LATEX) $*
	@if ( grep 'LaTeX Warning: Label(s) may' $*.log > /dev/null ); \
		then $(LATEX) $* ; \
	else :; fi
	@-if ( grep 'undefined citations' $*.log > /dev/null ); then \
		if test "$(CHAP_CITE)" ; then \
			for file in bogus $(CHAP_CITE) ; do \
				if test "$$file" != "bogus"; then \
					echo "RUNNING BIBTEX ON FILE: $$file"; \
					bibtex $$file ; \
				fi ; \
			done ; \
		else \
			echo "RUNNING BIBTEX ON FILE: $*"; \
			bibtex $* ; \
		fi ; \
		$(LATEX) $* ; \
	fi
	@if ( grep 'Warning: Label(s) may' $*.log > /dev/null || \
		grep 'Rerun' $*.log > /dev/null || \
		grep 'Warning: Citation' $*.log > /dev/null); \
	then $(LATEX) $* ; else :; fi
	@if ( grep 'Warning: Label(s) may' $*.log > /dev/null || \
		grep 'Rerun' $*.log > /dev/null || \
		grep 'Warning: Citation' $*.log > /dev/null); \
	then $(LATEX) $* ; else :; fi
	@if ( grep 'Warning: Label(s) may' $*.log > /dev/null || \
		grep 'Rerun' $*.log > /dev/null || \
		grep 'Warning: Citation' $*.log > /dev/null); \
	then $(LATEX) $* ; else :; fi

.tex.pdf:
	@$(PDFLATEX) $*
	@if ( grep 'LaTeX Warning: Label(s) may' $*.log > /dev/null ); \
		then $(PDFLATEX) $* ; \
	else :; fi
	@-if ( grep 'undefined citations' $*.log > /dev/null ); then \
		if test "$(CHAP_CITE)" ; then \
			for file in bogus $(CHAP_CITE) ; do \
				if test "$$file" != "bogus"; then \
					echo "RUNNING BIBTEX ON FILE: $$file"; \
					bibtex $$file ; \
				fi ; \
			done ; \
		else \
			echo "RUNNING BIBTEX ON FILE: $*"; \
			bibtex $* ; \
		fi ; \
		$(PDFLATEX) $* ; \
	fi
	@if ( grep 'Warning: Label(s) may' $*.log > /dev/null || \
		grep 'Rerun' $*.log > /dev/null || \
		grep 'Warning: Citation' $*.log > /dev/null); \
	then $(PDFLATEX) $* ; else :; fi
	@if ( grep 'Warning: Label(s) may' $*.log > /dev/null || \
		grep 'Rerun' $*.log > /dev/null || \
		grep 'Warning: Citation' $*.log > /dev/null); \
	then $(PDFLATEX) $* ; else :; fi
	@if ( grep 'Warning: Label(s) may' $*.log > /dev/null || \
		grep 'Rerun' $*.log > /dev/null || \
		grep 'Warning: Citation' $*.log > /dev/null); \
	then $(PDFLATEX) $* ; else :; fi

.dvi.ps:
	$(DVIPS) -Pps -Ptype1 -o $*.ps $*

#
# Standard targets
#

clean:
	/bin/rm -f *% $(MAIN_PDF) $(MAIN_PS) $(MAIN_DVI)

squeaky:
	/bin/rm -f *.log *.aux *.dvi *.blg *.toc *.bbl *.lof *.lot *.out \
		$(MAIN_PS) $(MAIN_DVI) $(MAIN_PDF)
