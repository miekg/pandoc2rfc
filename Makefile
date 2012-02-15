XML=middle.xml back.xml
RFC=DISPLAY= sh xml-wrap template.xml

all:	draft.txt draft.html

%.xml:	%.mkd transform.xsl
	pandoc -t docbook -s $< | xsltproc transform.xsl - > $@

draft.txt:	$(XML) template.xml
	$(RFC) $@

draft.html: 	$(XML) template.xml
	$(RFC) $@

draft.xml:	$(XML) template.xml
	perl xml-single template.xml > draft.xml

clean:
	rm -f $(XML)

realclean:	clean
	rm -f draft.txt draft.html draft.xml
