all:	draft.txt

middle.xml: middle.mkd transform.xsl
	pandoc middle.mkd -t docbook -s | xsltproc transform.xsl - > middle.xml

back.xml:  back.mkd transform.xsl
	pandoc back.mkd -t docbook -s | xsltproc transform.xsl - > back.xml

draft.txt:	middle.xml back.xml template.xml
	DISPLAY= xml2rfc template.xml draft.txt

draft.html: 	middle.xml back.xml template.xml
	DISPLAY= xml2rfc template.xml draft.html

clean:
	rm -f middle.xml back.xml

realclean:	clean
	rm -f draft.txt draft.html
