all:	draft.txt

draft.xml: front.xml back.xml draft.mkd xslt.
	(cat front.xml; pandoc ~/draft.mkd -t docbook -s | xsltproc xslt.xml -; cat back.xml) > /tmp/rfc.xml 

draft.txt: draft.xml
	xml2rfc draft.xml draft.txt
