# Asciidoc
all:	draft.txt

%.xml:	%.asciidoc transform.xsl
	asciidoc -a 'toc!' -a 'numbered!' -b docbook $< && \
	    xsltproc transform.xsl $@ > $(basename $<).tmp && \
	    mv $(basename $<).tmp $@

draft.txt:	middle.xml back.xml template.xml
	DISPLAY= xml2rfc template.xml draft.txt

draft.html: 	middle.xml back.xml template.xml
	DISPLAY= xml2rfc template.xml draft.html

clean:
	rm -f middle.xml back.xml

realclean:	clean
	rm -f draft.txt draft.html
