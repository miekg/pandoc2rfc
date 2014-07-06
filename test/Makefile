SOURCES=abstract.md note.md middle.md back.md
all:	draft.txt

draft.txt: ../transform.xsl $(SOURCES)
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl $(SOURCES)

draft.html: ../transform.xsl $(SOURCES)
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl -M $(SOURCES)

draft.xml: ../transform.xsl $(SOURCES)
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl -X $(SOURCES)

.PHONY: debug
debug:
	bash ../pandoc2rfc -dt template.xml -x ../tr.xsl $(SOURCES)

.PHONY: validate
validate:
	xmllint --xinclude --noout --relaxng ../xml2rfcv3-08.rng template.xml

.PHONY: clean
clean:
	rm -f draft.txt
