all:	draft.txt

draft.txt: back.mkd middle.mkd pandoc-readme.mkd
	bash ../pandoc2rfc -t template.xml -x ../transform.xsl back.mkd middle.mkd pandoc-readme.mkd

draft.html: back.mkd middle.mkd pandoc-readme.mkd
	bash ../pandoc2rfc -t template.xml -x ../transform.xsl -M back.mkd middle.mkd pandoc-readme.mkd

draft.xml: back.mkd middle.mkd pandoc-readme.mkd
	bash ../pandoc2rfc -t template.xml -x ../transform.xsl -X back.mkd middle.mkd pandoc-readme.mkd

.PHONY: clean
clean:
	rm -f draft.txt
