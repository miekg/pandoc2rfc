# README

Pandoc2rfc translates text written in the Markdown variant Pandoc to documents
in xml2rfc format. It's an easy way to write RFCs.

The documentation for Pandoc2rfc can be found at:
<http://tools.ietf.org/html/draft-gieben-pandoc2rfc-03>

## Differences with Pandoc

Although you can type Pandoc just fine, there are two things that differ

* Using Pandoc citations is not supported, you must use internal references
  for this;
* Referencing figures and tables is done by abusing inline footnotes, which are
  typeset directly after the figure or table. Like so:

        ^[tab:simple::Demonstration of **simple** table syntax.]

  Where `tab:simple` will be the anchor and the text after `::` as used for the title.

* List with `style=format REG%d` are typeset with strikethrough text in the
  first element, as such:
    
        1. ~~REQ%d~~ First REQ1 item;
        2. Second REQ2 item.

* An index is done by (yet again) by using a foonote, but the first item is a subscript:

        ^[ ^list^ format styles]

  The rest of the content is the "subitem"

As said, more extensive docs are here:
<http://tools.ietf.org/html/draft-gieben-pandoc2rfc-03>. But after some setup, it
is *just* typing Pandoc syntax in $EDITOR.

## Bare install

Just copy `transform.xsl` and `template.xml` to your I-D directory. Modify
`template.xml` according to your needs and run:

    pandoc -t docbook -s <yourfile>.mkd | \ 
    xsltproc --nonet transform.xsl - > <yourfile>.xml

And to create a draft.txt

    xml2rfc template.xml -f draft.txt --text

And/or create a Makefile.

## Packages

Or you can install `Pandoc2rfc` on your system. Then copy `template.xml`
to your I-D directory. Modify according to your needs and run:

    pandoc2rfc *.mkd

Packages can be found for Debian/Ubuntu at:

<https://launchpad.net/~miek/+archive/pandoc2rfc>, they should also install
in previous Ubuntu versions.

Or see <http://pandoc2rfc.implementers.org/> for proper Debian packages.

## XSLT 1.0

Note that you don't even need `xsltproc` per se, just an XSLT transformer
program. Also note that only `xsltproc` is tested.

Pandoc2rfc v2 works with `xml2rfc` version 2.x.

Miek Gieben - 2012
