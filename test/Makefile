all:	draft.txt

draft.txt: back.md middle.md ../transform.xsl
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl middle.md back.md

draft.html: back.md middle.md ../transform.xsl
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl -M middle.md back.md

draft.xml: back.md middle.md ../transform.xsl
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl -X middle.md back.md

.PHONY: debug
debug:
	bash ../pandoc2rfc -dt template.xml -x ../tr.xsl middle.md back.md

.PHONY: validate
validate:
	xmllint --xinclude --noout --relaxng ../xml2rfcv3-08.rng template.xml

.PHONY: clean
clean:
	rm -f draft.txt
