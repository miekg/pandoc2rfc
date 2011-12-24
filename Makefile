# Pandoc
all:	draft.txt

%.xml:	%.mkd transform.xsl
	pandoc $< -t docbook -s | xsltproc transform.xsl - > $@

draft.txt:	middle.xml back.xml template.xml
	DISPLAY= xml2rfc template.xml draft.txt

draft.html: 	middle.xml back.xml template.xml
	DISPLAY= xml2rfc template.xml draft.html

clean:
	rm -f middle.xml back.xml

realclean:	clean
	rm -f draft.txt draft.html
