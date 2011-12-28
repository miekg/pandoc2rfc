# Pandoc
XML=middle.xml back.xml

all:	draft.txt

%.xml:	%.mkd transform.xsl
	pandoc -t docbook -s $< | xsltproc transform.xsl - > $@

draft.txt:	$(XML) template.xml
	DISPLAY= xml2rfc template.xml draft.txt

draft.html: 	$(XML) template.xml
	DISPLAY= xml2rfc template.xml draft.html

clean:
	rm -f $(XML)

realclean:	clean
	rm -f draft.txt draft.html
