.PHONY: man html xml

all:	pandoc2rfc.1 install

pandoc2rfc.1:	pandoc2rfc.1.pdc
	pandoc -s -w man pandoc2rfc.1.pdc -o pandoc2rfc.1

install:

