SRC = Presentacion.tex 
DEP = estructura.tex
PDF = Presentacion.pdf
AUX = Presentacion.aux
TEXC := xelatex
TEXC_OPTS += -shell-escape
TEXMFHOME = $(shell kpsewhich -var-value=TEXMFHOME)

.PHONY: clean install

all: $(PDF) evince

$(AUX):
	$(TEXC) $(TEXC_OPTS) $(SRC)

$(PDF): beamerthemem.sty $(AUX) $(SRC) $(DEP)
	$(TEXC) $(TEXC_OPTS) $(SRC) && $(TEXC) $(TEXC_OPTS) $(SRC)

show:
	impressive -Q -x $(PDF)

evince:
	evince $(PDF)

clean:
	@rm -f $(PDF)