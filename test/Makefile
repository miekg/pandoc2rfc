SOURCES=abstract.md note.md middle.md back.md
all:	draft.txt

draft.txt: ../tr.xsl $(SOURCES)
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl $(SOURCES)

draft.html: ../tr.xsl $(SOURCES)
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl -M $(SOURCES)

draft.xml: ../tr.xsl $(SOURCES)
	bash ../pandoc2rfc -t template.xml -x ../tr.xsl -X $(SOURCES)

full.xml: ../tr.xsl $(SOURCES)
	xmllint --xinclude --noent template.xml > full.xml             

.PHONY: validate
validate: debug full.xml
	xmllint --xinclude --nonet --noout --relaxng ../xml2rfcv3-??.rng full.xml

.PHONY: debug
debug:
	for i in $(SOURCES); do pandoc -st docbook $$i | xsltproc ../tr.xsl -> $$(basename $$i md)xml; done

.PHONY: clean
clean:
	rm -f draft.txt


# trang rnc -> rng
