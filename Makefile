ifeq ($(TAG), )
    TAG=$(shell git log -1 --pretty=format:%h)
endif

all:	pandoc2rfc.1

.PHONY: version
version:
	sed -i "s/\@VERSION\@/$(TAG)/" pandoc2rfc
	sed -i "s/\@VERSION\@/$(TAG)/" transform.xsl

pandoc2rfc.1: pandoc2rfc.1.pdc
	pandoc -s -w man pandoc2rfc.1.pdc -o pandoc2rfc.1

draft.txt: back.mkd middle.mkd transform.xsl pandoc-readme.mkd
	bash pandoc2rfc -t template.xml -x transform.xsl back.mkd middle.mkd pandoc-readme.mkd

draft.html: back.mkd middle.mkd transform.xsl pandoc-readme.mkd
	bash pandoc2rfc -t template.xml -x transform.xsl -M back.mkd middle.mkd pandoc-readme.mkd

install:
	@echo installing $(TAG)
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/usr/share/man/man1
	mkdir -p $(DESTDIR)/usr/lib/pandoc2rfc
	cp pandoc2rfc $(DESTDIR)/usr/bin/pandoc2rfc
	cp rfcmarkup $(DESTDIR)/usr/bin/rfcmarkup
	chmod 755 $(DESTDIR)/usr/bin/pandoc2rfc
	chmod 755 $(DESTDIR)/usr/bin/rfcmarkup
	cp pandoc2rfc.1 $(DESTDIR)/usr/share/man/man1
	cp transform.xsl $(DESTDIR)/usr/lib/pandoc2rfc

uninstall:
	rm -rf $(DESTDIR)/usr/lib/pandoc2rfc/
	rm -f $(DESTDIR)/usr/share/man/man1/pandoc2rfc.1
	rm -f $(DESTDIR)/usr/bin/pandoc2rfc

.PHONY: clean
clean:
	rm -f draft.txt
	rm -f pandoc2rfc.1

