all:	draft.txt

draft.txt: back.md middle.md ../transform.xsl
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl back.md middle.md

draft.html: back.md middle.md ../transform.xsl
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl -M back.md middle.md

draft.xml: back.md middle.md ../transform.xsl
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl -X back.md middle.md

.PHONY: debug
debug:
	@bash ../pandoc2rfc -Dt template.xml -x ../tr.xsl back.md middle.md

.PHONY: clean
clean:
	rm -f draft.txt
