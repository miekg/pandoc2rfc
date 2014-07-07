# Introduction

<?rfc toc="yes"?>
<?rfc symrefs="yes"?>
<?rfc sortrefs="yes"?>
<?rfc subcompact="no"?>
<?rfc compact="yes"?>
<?rfc comments="yes"?>

This document presents a technique for using Pandoc syntax as a source format for
documents in the Internet-Drafts (I-Ds) and Request for Comments (RFC) series.

This version is adapted to work with `xml2rfc` version 3.x.

Pandoc is an "almost plain text" format and therefor particularly well suited
for editing RFC-like documents.

> Note: this document is typeset in Pandoc and does not render completely correct when
> reading it on github.

> NB: this is mostly text to test Pandoc2rfc, the canonical documentation
> is [draft-gieben-pandoc2rfc](http://tools.ietf.org/html/draft-gieben-pandoc2rfc-01).

# Pandoc to RFC

> Pandoc2rfc -- designed to do the right thing, until it doesn't.

When writing [](#RFC4641) we directly wrote the
XML. Needless to say it was tedious even thought the XML of
[xml2rfc](http://xml.resource.org/experimental) is very "light". The [latest version
of xml2rfc version 2 can be found here](http://pypi.python.org/pypi/xml2rfc/).

During the last few years people have been developing markup languages that are very easy to remember
and type. These languages have become known as `almost plain text`-markup languages.
One of the first was the [Markdown](http://daringfireball.net/projects/markdown/) 
syntax. One that was developed later and incorporates Markdown and a number of extensions 
is [Pandoc](http://johnmacfarlane.net/pandoc/). The power of Pandoc also comes from the
fact that it can be translated to numerous output formats, including, but not limited to:
HTML, (plain) Markdown and `docbook` XML.

So using Pandoc for writing RFCs seems like a sane choice. As `xml2rfc` uses XML,
the easiest way would be to create `docbook` XML and transform that using
XSLT. Pandoc2rfc does just that. The conversions are, in some way amusing, as we start
off with (almost) plain text, use elaborate XML and end up with plain text again.


    +-------------------+   pandoc   +---------+  
    | ALMOST PLAIN TEXT |   ------>  | DOCBOOK |  
    +-------------------+            +---------+  
                  |                       |
    non-existent  |                       | xsltproc
      faster way  |                       |
                  v                       v
          +------------+    xml2rfc  +---------+ 
          | PLAIN TEXT |  <--------  | XML2RFC | 
          +------------+             +---------+ 
^[ ~fig-flow~ This is an *inline* note for the above figure.]

The XML generated (the output after the `xsltproc` step in [](#fig-flow)) 
is suitable for inclusion in either the `middle` or `back` section
of an RFC. The simplest way is to create a template XML file and include the appropriate
XML:

    <?xml version='1.0' ?>
    <!DOCTYPE rfc SYSTEM 'rfc2629.dtd' [
    <!ENTITY pandocMiddle PUBLIC '' 'middle.xml'>
    <!ENTITY pandocBack   PUBLIC '' 'back.xml'>
    ]>

    <rfc ipr='trust200902' docName='draft-gieben-pandoc-rfcs-02'>
     <front>
        <title>Writing I-Ds and RFCs using Pandoc v2</title>
    </front>

    <middle>
        &pandocMiddle;
    </middle>

    <back>
        &pandocBack;
    </back>

    </rfc>
^[ ~fig-template~ A minimal template.xml.]

See the Makefile for an example of this. In this case you need to edit
3 documents:

1. middle.pdc - contains the main body of text;
1. back.pdc - holds appendices and references;
1. template.xml (probably a fairly static file);
1. Reference the above template, see [](#fig-template).

The draft (`draft.txt`) you are reading now, is automatically created when you call `make`. 
The homepage of Pandoc2rfc is [this github repository](https://github.com/miekg/pandoc2rfc).

## Dependencies

It needs `xsltproc` and `pandoc` to be installed. See the [Pandoc user manual for
the details](http://johnmacfarlane.net/pandoc/README.html) on how to type in Pandoc
style. And ofcourse `xml2rfc` version two.

When using Pandoc2rfc consider adding the following sentence to an Acknowledgements
section:

     This document was produced using the Pandoc2rfc tool.

# Starting a new project
When starting a new project with `pandoc2rfc` you'll need to copy the following files:

* `Makefile`
* `tr.xslt`
* And the above mentioned files:
    * `middle.md`
    * `back.md`
    * `template.xml`

After that you can start editing.

# Acknowledgements

The following people have helped to make Pandoc2rfc what it is today:
Benno Overeinder, Erlend Hamnaberg, Matthijs Mekking, Trygve Laugstøl.

This document was prepared using Pandoc2rfc.

# Pandoc Constructs

The best introduction to the Pandoc style is given
in this [README from Pandoc itself](http://johnmacfarlane.net/pandoc/README.html).

What follows here is a list of slight changes, where the syntax of Pandoc is used but
in a non standard way.

## List Styles

A good number of styles are supported.

### Symbol

    A symbol list.

    * Item one;
    * Item two.

Converts to `<list style="symbol">`:

* Item one;
* Item two.

### Number

    A numbered list.

    1. Item one;
    1. Item two.

Converts to `<list style="numbers">`:

1. Item one;
1. Item two.

### Empty
Using the default list markers from Pandoc:

    A list using the default list markers.

    #. Item one;
    #. Item two.

Converts to `<list style="empty">`:

#. Item one;
#. Item two.

### Roman
Use the supported Pandoc syntax:

    ii. Item one;
    ii. Item two.

Converts to `<list style="format %i.">`:

ii. Item one;
ii. Item two.

If you use uppercase Roman
numerals, they convert to a different style:

    II. Item one;
    II. Item two.

Yields `<list style="format (%d) ">`:

II. Item one;
II. Item two.

### Letter

A numbered list.

    a.  Item one;
    b.  Item two.

Converts to `<list style="letters">`: 

a.  Item one;
b.  Item two.

Uppercasing the letters works too (note two spaces after the letter.

    A.  Item one;
    B.  Item two.

Becomes:

A.  Item one;
B.  Item two.

## Figure/Artwork
Indent the paragraph with 4 spaces.

    Like this

Converts to: `<figure><artwork> ...`

Indented paragraph will be an artwork, unless it has a caption then it will
become a `<figure><artwork>`

## Block Quote
Any paragraph like:

    > quoted text

Converts to: `<t><list style="empty"> ...` paragraph, making it indented.

### Internal References
Any reference like:

    [Click here](#localid)

Converts to: `<link target="localid">Click here ...`

For referring to RFCs (for which you manually need add the reference source in the template,
with an external XML entity), you can just use:

    [](#RFC2119)

And it does the right thing. Referencing sections is done with:

    See [](#pandoc-constructs)

The word 'Section' is inserted automatically: ... see [](#pandoc-constructs) ...
For referencing figures/artworks see [](#figureartwork).
For referencing tables see [](#tables).

## Tables Test
A table can be entered as:

      Right     Left     Center   Default
      -------  ------ ----------   -------
       12     12        12           12 
      123     123       123         123
        1     1         1         1       

      ^[ ~tab~ A caption describing the table.]
^[ ~fig-table~ A caption describing the figure describing the table.]
