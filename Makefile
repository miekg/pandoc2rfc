PDC=middle.pdc back.pdc
RFC=bash pandoc2rfc
# This assumes double quotes in the docName!
TITLE=$(shell grep docName template.xml | sed -e 's/.*docName=\"//' -e 's/\">//')

all:	draft.txt 

draft.txt:	template.xml
	$(RFC) $(PDC)

draft.html: 	template.xml
	$(RFC) -H $(PDC)

draft.xml:	template.xml
	$(RFC) -X $(PDC)

$(TITLE).txt:	draft.txt
	ln -sf $< $@

$(TITLE).html:	draft.html
	ln -sf $< $@

$(TITLE).xml:	draft.xml
	ln -sf $< $@

nits:   $(TITLE).txt
	if idnits --help 2>/dev/null >&2; then idnits --year $(date +%Y) --verbose $<; fi
