# Asciidoc
XML=middle.xml back.xml

all:	draft.txt

%.xml:	%.asciidoc transform.xsl
	asciidoc -a 'toc!' -a 'numbered!' -b docbook -o - $< | xsltproc transform.xsl - > $@

draft.txt:	$(XML) template.xml
	DISPLAY= xml2rfc template.xml draft.txt

draft.html: 	$(XML) template.xml
	DISPLAY= xml2rfc template.xml draft.html

clean:
	rm -f $(XML)

realclean:	clean
	rm -f draft.txt draft.html
