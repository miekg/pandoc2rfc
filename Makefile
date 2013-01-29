all:	pandoc2rfc.1 draft.txt

pandoc2rfc.1: pandoc2rfc.1.mkd
	pandoc -s -w man pandoc2rfc.1.mkd -o pandoc2rfc.1

draft.txt: back.mkd README.mkd transform.xsl
	bash pandoc2rfc -t template.xml -x transform.xsl README.mkd back.mkd

install:
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/usr/share/man/man1
	mkdir -p $(DESTDIR)/usr/lib/pandoc2rfc
	cp pandoc2rfc $(DESTDIR)/usr/bin/pandoc2rfc
	chmod 755 $(DESTDIR)/usr/bin/pandoc2rfc
	cp pandoc2rfc.1 $(DESTDIR)/usr/share/man/man1
	cp transform.xsl $(DESTDIR)/usr/lib/pandoc2rfc
