XML=middle.xml back.xml
RFC=DISPLAY= sh xml-wrap template.xml
# Options
# vspaceAfterHang, see:
# http://xml.resource.org/xml2rfcFAQ.html#q_hanging_lists
vspaceAfterHang="0"	# "0" disable, "1" enable

all:	draft.txt draft.html

%.xml:	%.mkd transform.xsl
	pandoc -t docbook -s $< | xsltproc --nonet --stringparam vspaceAfterHang ${vspaceAfterHang} transform.xsl - > $@

draft.txt:	$(XML) template.xml
	$(RFC) $@

draft.html: 	$(XML) template.xml
	$(RFC) $@

draft.xml:	$(XML) template.xml
	perl xml-single template.xml > draft.xml

clean:
	rm -f $(XML)

realclean:	clean
	rm -f draft.txt draft.html draft.xml
