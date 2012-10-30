XML=middle.xml back.xml
RFC=/home/miekg/xml2rfc/xml2rfc
# This assumes double quotes in the docName!
TITLE=$(shell grep docName template.xml | sed -e 's/.*docName=\"//' -e 's/\">//')
.PHONY: txt html xml

all:	txt 

txt:	$(TITLE).txt

html:	$(TITLE).html

xml:	$(TITLE).xml

# mkd is OK
%.xml:	%.mkd transform.xsl
	pandoc -t docbook -s $< | xsltproc --nonet transform.xsl - > $@

# pdc is also OK
%.xml:	%.pdc transform.xsl
	pandoc -t docbook -s $< | xsltproc --nonet transform.xsl - > $@

draft.txt:	$(XML) template.xml
	$(RFC) template.xml -f $@ --text

draft.html: 	$(XML) template.xml
	$(RFC) template.xml -f $@ --html

draft.xml:	$(XML) template.xml
	xmllint --noent template.xml > draft.xml

$(TITLE).txt:	draft.txt
	ln -sf $< $@

$(TITLE).html:	draft.html
	ln -sf $< $@

$(TITLE).xml:	draft.xml
	ln -sf $< $@

nits:   $(TITLE).txt
	if idnits --help 2>/dev/null >&2; then idnits --year $(date +%Y) --verbose $<; fi

clean:
	rm -f $(XML) $(TITLE).txt $(TITLE).html  $(TITLE).xml

realclean:	clean
	rm -f draft.txt draft.html draft.xml $(TITLE).txt $(TITLE).html $(TITLE).xml
