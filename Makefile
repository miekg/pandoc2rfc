all:	draft.txt

draft.xml: front.xml back.xml draft.mkd transform.xsl
	(cat front.xml; pandoc draft.mkd -t docbook -s | xsltproc transform.xsl -; cat back.xml) > draft.xml 

draft.txt: draft.xml
	xml2rfc draft.xml draft.txt
