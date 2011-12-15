<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Convert DocBook XML as created by Pandoc to XML suitable for
     RFCs. Should be parseble with xml2rfc.

     Some "awkward" conversions:

     * blockquote -> <figure><artwork> ... 

     It emits warnings (and removes the content) when encountering:

     * articleinfo;
     * nested blockquotes;
     * footnotes.

    Not supported:

    * iref tag (index);
    * cref tag (comments). Use HTML comments.
-->

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="article">
    <xsl:apply-templates/>
</xsl:template>

<!-- Remove the article info section, this should be handled
     in the <front> matter of the draft -->
<xsl:template match="articleinfo">
    <xsl:message terminate="no">
        Warning: Author and article information is discarded.
    </xsl:message>
</xsl:template>

<!-- Remove footnotes -->
<xsl:template match="footnote">
    <xsl:message terminate="no">
        Warning: Footnote is not supported in RFC output.
    </xsl:message>
</xsl:template>

<!-- Merge section with the title tags into one section -->
<xsl:template match="section">
    <section>
        <xsl:attribute name="title">
            <xsl:value-of select="normalize-space(translate(./title, '&#xA;', ' '))" />
        </xsl:attribute>
        <xsl:attribute name="anchor">
            <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:apply-templates/>
    </section>
</xsl:template>

<!-- Transform a <para> to <t>, except in lists, then it is discarded -->
<xsl:template match="para">
    <xsl:choose>
        <xsl:when test="ancestor::orderedlist">
                <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="ancestor::itemizedlist">
                <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="ancestor::variablelist">
                <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
                <t><xsl:apply-templates/></t>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Transform a <listitem> to a <t> for lists, except in description lists -->
<xsl:template match="listitem">
    <xsl:choose>
        <xsl:when test="parent::varlistentry">
                <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
                <t><xsl:apply-templates/></t>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Transform lists, for lists in list we do not put it in a new <t></t>  -->
<xsl:template match="orderedlist">
    <xsl:choose>
       <xsl:when test="contains(@numeration,'arabic')">
        <xsl:choose>
            <xsl:when test="ancestor::orderedlist">
                <list style="numbers"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::itemizedlist">
                <list style="numbers"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::variablelist">
                <list style="numbers"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:otherwise>
                <t><list style="numbers"><xsl:apply-templates/></list></t>
            </xsl:otherwise>
        </xsl:choose>
       </xsl:when>
       <xsl:when test="contains(@numeration,'lowerroman')">
        <xsl:choose>
            <xsl:when test="ancestor::orderedlist">
                <list style="format %i."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::itemizedlist">
                <list style="format %i."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::variablelist">
                <list style="format %i."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:otherwise>
                <t><list style="format %i."><xsl:apply-templates/></list></t>
            </xsl:otherwise>
        </xsl:choose>
       </xsl:when>
       <xsl:when test="contains(@numeration,'upperroman')">
        <xsl:choose>
            <xsl:when test="ancestor::orderedlist">
                <list style="format %I."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::itemizedlist">
                <list style="format %I."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::variablelist">
                <list style="format %I."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:otherwise>
                <t><list style="format %I."><xsl:apply-templates/></list></t>
            </xsl:otherwise>
        </xsl:choose>
       </xsl:when>
       <xsl:when test="contains(@numeration,'upperalpha')">
        <xsl:choose>
            <xsl:when test="ancestor::orderedlist">
                <list style="format %C."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::itemizedlist">
                <list style="format %C."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::variablelist">
                <list style="format %C."><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:otherwise>
                <t><list style="format %C."><xsl:apply-templates/></list></t>
            </xsl:otherwise>
        </xsl:choose>
       </xsl:when>
       <xsl:otherwise> 
        <xsl:choose>
            <xsl:when test="ancestor::orderedlist">
                <list style="letters"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::itemizedlist">
                <list style="letters"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::variablelist">
                <list style="letters"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:otherwise>
                <t><list style="letters"><xsl:apply-templates/></list></t>
            </xsl:otherwise>
        </xsl:choose>
       </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="itemizedlist">
    <xsl:choose>
        <xsl:when test="ancestor::orderedlist">
            <list style="symbols"><xsl:apply-templates/></list>
        </xsl:when>
        <xsl:when test="ancestor::itemizedlist">
            <list style="symbols"><xsl:apply-templates/></list>
        </xsl:when>
        <xsl:when test="ancestor::variablelist">
            <list style="symbols"><xsl:apply-templates/></list>
        </xsl:when>
        <xsl:otherwise>
            <t><list style="symbols"><xsl:apply-templates/></list></t>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Hanging lists are specified as <variablelist> -->
<xsl:template match="variablelist">
    <xsl:choose>
        <xsl:when test="ancestor::orderedlist">
            <list style="hanging"><xsl:apply-templates/></list>
        </xsl:when>
        <xsl:when test="ancestor::itemizedlist">
            <list style="hanging"><xsl:apply-templates/></list>
        </xsl:when>
        <xsl:when test="ancestor::variablelist">
            <list style="hanging"><xsl:apply-templates/></list>
        </xsl:when>
        <xsl:otherwise>
        <t><list style="hanging"><xsl:apply-templates/></list></t>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="varlistentry">
    <t>
        <xsl:attribute name="hangText">
            <xsl:value-of select="normalize-space(translate(./term, '&#x20;&#x9;&#xD;&#xA;', ' '))"/>
        </xsl:attribute>
        <xsl:apply-templates select="./listitem"/>
    </t>
</xsl:template>

<!-- Transform <link> to <xref> crosslinks -->
<!-- Use [see](#mysection) in pandoc -->
<xsl:template match="link">
    <xref>
        <xsl:attribute name="target">
            <xsl:value-of select="@linkend"/>
        </xsl:attribute>
    <xsl:apply-templates/>
    </xref>
</xsl:template>

<!-- Transform <ulink> to <eref> links -->
<!-- Use [see](uri) in pandoc -->
<xsl:template match="ulink">
    <eref>
        <xsl:attribute name="target">
            <xsl:value-of select="@url"/>
        </xsl:attribute>
    <xsl:apply-templates/>
    </eref>
</xsl:template>

<!-- Transform <blockquote> to <figure><artwork> -->
<xsl:template match="blockquote">
    <figure>
        <artwork>
            <xsl:value-of select="./para"/>
        </artwork>
    </figure>
</xsl:template>

<!-- Transform <screen> and <programlisting> to <figure><artwork> -->
<xsl:template match="screen | programlisting">
    <figure>
        <artwork>
            <xsl:apply-templates/>
        </artwork>
    </figure>
</xsl:template>

<!-- Kill title tags + content -->
<xsl:template match="title"> </xsl:template>

<xsl:template match="literal"> 
    <spanx style="verb">
        <xsl:apply-templates/> 
    </spanx>
</xsl:template>
<xsl:template match="emphasis"> 
    <xsl:choose>
        <xsl:when test="contains(@role,'strong')">
            <spanx style="strong">
            <xsl:apply-templates/> 
            </spanx>
        </xsl:when>
        <xsl:otherwise>
            <spanx style="emph">
            <xsl:apply-templates/> 
            </spanx>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Tables -->
<xsl:template match="table | informaltable">
    <texttable>
        <xsl:apply-templates/>
    </texttable>
</xsl:template>

<xsl:template match="table/caption | table/title">
    <preamble>
        <xsl:apply-templates/>
    </preamble>
</xsl:template>

<!-- Table headers -->
<xsl:template match="table/thead/tr/th | informaltable/thead/tr/th">
    <ttcol>
        <xsl:attribute name="align">
            <xsl:value-of select="@align"/>
        </xsl:attribute>
        <!-- for some stupid reason position() div 2, does not work, so the loop is unrolled and we do it by hand -->
        <!-- first column -->
        <xsl:if test="position()=2">
            <xsl:if test="../../../../table/col[1]">
                <xsl:attribute name="width">
                    <xsl:value-of select="../../../../table/col[1]/@width"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- second column -->
        <xsl:if test="position()=4">
            <xsl:if test="../../../../table/col[2]">
                <xsl:attribute name="width">
                    <xsl:value-of select="../../../../table/col[2]/@width"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- third column -->
        <xsl:if test="position()=6">
            <xsl:if test="../../../../table/col[3]">
                <xsl:attribute name="width">
                    <xsl:value-of select="../../../../table/col[3]/@width"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- fourth column -->
        <xsl:if test="position()=8">
            <xsl:if test="../../../../table/col[4]">
                <xsl:attribute name="width">
                    <xsl:value-of select="../../../../table/col[4]/@width"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- fifth column -->
        <xsl:if test="position()=10">
            <xsl:if test="../../../../table/col[5]">
                <xsl:attribute name="width">
                    <xsl:value-of select="../../../../table/col[5]/@width"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- sixth column -->
        <xsl:if test="position()=12">
            <xsl:if test="../../../../table/col[6]">
                <xsl:attribute name="width">
                    <xsl:value-of select="../../../../table/col[6]/@width"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- seventh column -->
        <xsl:if test="position()=14">
            <xsl:if test="../../../../table/col[7]">
                <xsl:attribute name="width">
                    <xsl:value-of select="../../../../table/col[7]/@width"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- eighth column -->
        <xsl:if test="position()=16">
            <xsl:if test="../../../../table/col[8]">
                <xsl:attribute name="width">
                    <xsl:value-of select="../../../../table/col[8]/@width"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates/>
    </ttcol>
</xsl:template>

<!-- Table headers for CALS tables, Pandoc 1.8.2.x+ emit these -->
<xsl:template match="table/tgroup/thead/row/entry">
    <ttcol>
        <xsl:if test="position()=2">
            <xsl:if test="../../../../../table/tgroup/colspec[1]">
                <xsl:attribute name="align">
                    <xsl:value-of select="../../../../../table/tgroup/colspec[1]/@align"/>
                </xsl:attribute>
                <!-- Optionally colwidth, translate * to % -->
                <xsl:if test="../../../../../table/tgroup/colspec[1]/@colwidth">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(../../../../../table/tgroup/colspec[1]/@colwidth, '*', '%')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="position()=4">
            <xsl:if test="../../../../../table/tgroup/colspec[2]">
                <xsl:attribute name="align">
                    <xsl:value-of select="../../../../../table/tgroup/colspec[2]/@align"/>
                </xsl:attribute>
                <xsl:if test="../../../../../table/tgroup/colspec[2]/@colwidth">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(../../../../../table/tgroup/colspec[2]/@colwidth, '*', '%')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="position()=6">
            <xsl:if test="../../../../../table/tgroup/colspec[3]">
                <xsl:attribute name="align">
                    <xsl:value-of select="../../../../../table/tgroup/colspec[3]/@align"/>
                </xsl:attribute>
                <xsl:if test="../../../../../table/tgroup/colspec[3]/@colwidth">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(../../../../../table/tgroup/colspec[3]/@colwidth, '*', '%')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="position()=8">
            <xsl:if test="../../../../../table/tgroup/colspec[4]">
                <xsl:attribute name="align">
                    <xsl:value-of select="../../../../../table/tgroup/colspec[4]/@align"/>
                </xsl:attribute>
                <xsl:if test="../../../../../table/tgroup/colspec[4]/@colwidth">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(../../../../../table/tgroup/colspec[4]/@colwidth, '*', '%')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="position()=10">
            <xsl:if test="../../../../../table/tgroup/colspec[5]">
                <xsl:attribute name="align">
                    <xsl:value-of select="../../../../../table/tgroup/colspec[5]/@align"/>
                </xsl:attribute>
                <xsl:if test="../../../../../table/tgroup/colspec[5]/@colwidth">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(../../../../../table/tgroup/colspec[5]/@colwidth, '*', '%')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="position()=12">
            <xsl:if test="../../../../../table/tgroup/colspec[6]">
                <xsl:attribute name="align">
                    <xsl:value-of select="../../../../../table/tgroup/colspec[6]/@align"/>
                </xsl:attribute>
                <xsl:if test="../../../../../table/tgroup/colspec[6]/@colwidth">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(../../../../../table/tgroup/colspec[6]/@colwidth, '*', '%')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="position()=14">
            <xsl:if test="../../../../../table/tgroup/colspec[7]">
                <xsl:attribute name="align">
                    <xsl:value-of select="../../../../../table/tgroup/colspec[7]/@align"/>
                </xsl:attribute>
                <xsl:if test="../../../../../table/tgroup/colspec[7]/@colwidth">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(../../../../../table/tgroup/colspec[7]/@colwidth, '*', '%')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="position()=16">
            <xsl:if test="../../../../../table/tgroup/colspec[8]">
                <xsl:attribute name="align">
                    <xsl:value-of select="../../../../../table/tgroup/colspec[8]/@align"/>
                </xsl:attribute>
                <xsl:if test="../../../../../table/tgroup/colspec[8]/@colwidth">
                    <xsl:attribute name="width">
                        <xsl:value-of select="translate(../../../../../table/tgroup/colspec[8]/@colwidth, '*', '%')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates/>
    </ttcol>
</xsl:template>

<xsl:template match="table/tbody/tr/td | informaltable/tbody/tr/td | table/tgroup/tbody/row/entry | informaltable/tgroup/tbody/row/entry">
    <c><xsl:apply-templates/></c>
</xsl:template>

<!-- CALS table -->
<xsl:template match="table/tbody/row/entry">
    <c><xsl:apply-templates/></c>
</xsl:template>

</xsl:stylesheet>
