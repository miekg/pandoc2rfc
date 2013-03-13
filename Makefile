all:	pandoc2rfc.1 draft.txt

pandoc2rfc.1: pandoc2rfc.1.pdc
	pandoc -s -w man pandoc2rfc.1.pdc -o pandoc2rfc.1

draft.txt: back.mkd README.mkd transform.xsl
	bash pandoc2rfc -t template.xml -x transform.xsl back.mkd README.mkd || exit 0

draft.html: back.mkd README.mkd transform.xsl
	bash pandoc2rfc -t template.xml -x transform.xsl -M back.mkd README.mkd || exit 0

install:
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/usr/share/man/man1
	mkdir -p $(DESTDIR)/usr/lib/pandoc2rfc
	cp pandoc2rfc $(DESTDIR)/usr/bin/pandoc2rfc
	cp rfcmarkup $(DESTDIR)/usr/bin/rfcmarkup
	chmod 755 $(DESTDIR)/usr/bin/pandoc2rfc
	chmod 755 $(DESTDIR)/usr/bin/rfcmarkup
	cp pandoc2rfc.1 $(DESTDIR)/usr/share/man/man1
	cp transform.xsl $(DESTDIR)/usr/lib/pandoc2rfc
