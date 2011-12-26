# Asciidoc
all:	draft.txt

%.xml:	%.asciidoc transform.xsl
	asciidoc -a 'toc!' -a 'numbered!' -b docbook -o - $< | xsltproc transform.xsl - > $@

draft.txt:	middle.xml back.xml template.xml
	DISPLAY= xml2rfc template.xml draft.txt

draft.html: 	middle.xml back.xml template.xml
	DISPLAY= xml2rfc template.xml draft.html

clean:
	rm -f middle.xml back.xml

realclean:	clean
	rm -f draft.txt draft.html
