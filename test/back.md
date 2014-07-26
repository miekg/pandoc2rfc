# Tests

This appendix consists out of a few tests that should all render to proper
`xml2rfc` XML.

## A Very Long Title Considerations With Regards to the Already Deployed Routing Policy

Test a very long title.

## RFC 2119

**MUST** becomes tagged, MUST does not.


## *Markup* in heading

This works now in `xml2rfc`.

## Unnumered section

Does not work.

## Blockquote

> This is a blockquote, how does it look?


> This is another with an anchor 

^[ ~quote-simple~ Creates an anchor. ]

> > Quote in Quote which will become an `<aside>`.

A list in quotes

> 1. First item
> 1. Second item

Each blockquote needs a citation, it's a mandatory element, we signal this with .. strikethrough text as
the first work.

> ~~http://miek.nl/~~ Put this in the cite, and further blockquotes.

## Lines

And a line, which does not show up, because there is no docbook equivalent.

-------

## Line blocks

| this is a line block, empty line after this one
|
| Should be followed by a new line
|    starts with 3 spaces.
| And another line

In between text

| hel
| lo! and a [RFC2119](#RFC2119) reference.

## Reference

Refer to [RFC 2119](#RFC2119) if you will.
Or maybe you want to inspect [](#fig-flow) in [](#pandoc-to-rfc)
again. Or you might want to [Click here](http://miek.nl).

## Spanx

#. underscores: _underscores_
#. asterisks: *asterisks*
#. double asterisks: **double asterisks**
#. backticks: `backticks`
#. *_underscores&andstars_*

## Images

![la lune](lalune.jpg "Voyage to the moon")

^[ ~fig-reference1~ Caption text `ffd`.]

"Empty" artwork without a figure: ![](/url/of/image/svg)

Figure with artwork, anchor and a caption.
![](/url/of/image/svg)
^[ ~fig:reference~ Caption text `ffd`.]

And nothing:

![This is the caption](/url/of/image.png)

## List 

### List with Custom Labels

1. ~~[REQ%d].~~ This is the first item;
2. This is the second itema;
3. This should be all typeset with REQ%d.

### List Start Numbers

4. four
5. five

### More

1. First we do
2. And then
    * item 1
    * item 2

And the other around.

* First we do
* Then
    1. Something
    2. Another thing

And more                                                                   

* Item 1

        artwork
        artwork
 
* Item 2
    * SubItem 1
    * SubItem 2

            artwork
            artwork

    * SubItem 3 

### Description Lists

Item to explain:

:   It works because of herbs.

Another item to explain:

:    More explaining.

     Multiple paragraphs in such a list.

### Description Lists with Lists

Item to explain:
:   It works because of

    1. One
    2. Two

Another item to explain:
:   More explaining

Item to explain:
:   It works because of

    1. One1
    2. Two1
        
        * Itemize list
        * Another item

Another item to explain again:
:   More explaining

### List with Description Lists

1. More

    Item to explain:
    :   Explanation ...

    Item to explain:
    :   Another explanation ...

2. Go'bye

Multiple paragraphs in a list.

1. This is the first bullet point and it needs multiple paragraphs...

    ... to be explained properly.

1. This is the next bullet. New paragraphs should be indented with 4 four spaces.

1. Another item with some artwork, indented by 8 spaces.

        Artwork

1. Final item.

xml2rfc does not allow this, so the second paragraph is faked with a

Ordered lists.

1. First item
2. Second item

A lowercase roman list:

i. Item 1
ii. Item 2

An uppercase roman list.

I.  Item1
II.  Item2
II.  Item 3

And default list markers ^[ ^list^ default markers ].

Some surrounding text, to make it look better.

#. First item. Use lot of text to get a real paragraphs sense.
    First item. Use lot of text to get a real paragraphs sense.
    First item. Use lot of text to get a real paragraphs sense.
    First item. Use lot of text to get a real paragraphs sense.
#. Second item. So this is the second para in your list. Enjoy;
#. Another item.

Text at the end.

Lowercase letters list.

a.  First item
b.  Second item

Uppercase letters list.

A.  First item
B.  Second item

### Artwork In Description List

Item1:

:    Tell something about it. Tell something about it. Tell something about it.
    Tell something about it. Tell something about it. Tell something about it.

        miek.nl.    IN  NS  a.miek.nl.                             
        a.miek.nl.  IN  A   192.0.2.1    ; <- this is glue            

    Tell some more about it.
    Tell some more about it.
    Tell some more about it.

Item2:

:   Another description


List with a sublist with a paragraph above the sublist

1.  First Item
1.  Second item
1.  Third item

    A paragraph that comes first

    a. But what do you know
    a. This is another list

## Table

  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     **123**  123           123
      1     1          1             1

^[ ~tab-simple~ Demonstration of **simple** table syntax.]

-------------------------------------------------------------
 Centered   Default           Right Left
  Header    Aligned         Aligned Aligned
----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here's another one. Note
                                    the blank line between
                                    rows.
-------------------------------------------------------------

^[ ~tab-multiline~ Here's the caption. It, too, may span multiple lines. This is a multiline table. This is `verbatim` text.]

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | built-in wrapper   |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | cures scurvy       |
+---------------+---------------+--------------------+

^[ ~tab-grid~ Sample grid table. ~~This is a postamble ~~]

Grid tables without a caption

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | *built-in wrapper* |
+---------------+---------------+--------------------+
| Apples        | $0.10         | cures\ \ \ scurvy  |
+---------------+---------------+--------------------+
| Bananas       | $0.73         | \ \ \ scurvy       |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | cures scurvy       |
+---------------+---------------+--------------------+

This table has no caption, and therefor no reference. But you can refer to 
some of the other tables, with for instance:

    See [](#tab-grid)

Which will become "See [](#tab-grid)".

## Numbered examples

This is another example:

(@good) Another bla bla..

as (@good) shows...

## Figure tests

    This is a figure
    This is a figure
    This is a figure
    This is a figure
^[This is the caption, with text in `typewriter`.]

And how a figure that is not centered, do to using `figure` and not `Figure`.

    This is a figure
    This is a figure
^[ ~noref~ A non centered figure, and some *markup*, and more `ls`.]

Figure:

1. With anchor -> inside an figure;
2. Without anchor -> standaline.

## Code

~~~~ {.haskell}
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
qsort (filter (>= x) xs)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This will translate to `<sourcecode>`, without the code type it will
become an artwork. Further more same rules applies as to Figures.

### Verbatim Code Blocks

~~~~~
A verbatim code block
~~~~~

## Heading {#foo}

Heading with anchor.
Just works, because the outputted docbook XML is the same.

## Verse

| This is a    verse text
|     This is another line

## Strikout

~~is deleted text.~~

## Citation

Won't work.

Blah blah [@smith04; @doe99].

## This section needs to be removed in the final RFC

~~removeInRFC~~ This section should be removed in the final RFC.

bla bla bla
