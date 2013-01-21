.PHONY: man html xml

all:	pandoc2rfc.1 install

pandoc2rfc.1:	pandoc2rfc.1.pdc
	pandoc -s -w man pandoc2rfc.1.pdc -o pandoc2rfc.1

install:
	cp pandoc2rfc $(DESTDIR)/usr/bin/pandoc2rfc
	chmod 755 $(DESTDIR)/usr/bin/pandoc2rfc
	cp pandoc2rfc.1: $(DESTDIR)/usr/share/man/man1
	mkdir -p $(DESTDIR)/usr/lib/pandoc2rfc
	cp transform.xsl $(DESTDIR)/usr/lib/pandoc2rfc
