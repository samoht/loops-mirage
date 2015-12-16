SWITCH=loops-mirage

FUNCTORIA=functoria https://github.com/mirage/functoria.git
MIRAGE=mirage https://github.com/mirage/mirage.git

OPAM=OPAMYES=1 opam

.PHONY: depends all help

all: help
	@

help:
	@echo "Available commands are:"
	@echo " - make depends"
	@echo " - make help"
	@echo
	@echo "Check README.md for more information"

depends:
	$(OPAM) switch $(SWITCH) -A system
	$(OPAM) pin add $(FUNCTORIA) -n
	$(OPAM) pin add $(MIRAGE) -n
	$(OPAM) install mirage mirage-types-lwt
