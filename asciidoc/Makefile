# Asciidoc
XML=middle.xml back.xml
RFC=DISPLAY= xml2rfc template.xml

all:	draft.txt draft.html

%.xml:	%.asciidoc transform.xsl
	asciidoc -a 'toc!' -a 'numbered!' -b docbook -o - $< | xsltproc transform.xsl - > $@

draft.txt:	$(XML) template.xml
	$(RFC) $@

draft.html: 	$(XML) template.xml
	$(RFC) $@

clean:
	rm -f $(XML)

realclean:	clean
	rm -f draft.txt draft.html
