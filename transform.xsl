<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Convert docbook XML as created by pandoc for XML suitable for
     RFCs. Should be parseble with xml2rfc 

     Some "awkward" conversions:

     * blockquote -> <t<figure><artwork> ... 

     It emits warnings (and removes the content) when encountering:

     * articleinfo
     * tables, should be done as figures texttable
     * nested blockquotes (TODO)
     * footnotes

    Not supported:

    * iref tag (index), use CDATA
-->

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="article">
    <!--    <middle> -->
    <xsl:apply-templates/>
    <!-- </middle> -->
</xsl:template>

<!-- Remove the article info section, this should be handled
     in the <front> matter of the RFC -->
<xsl:template match="articleinfo">
    <xsl:message terminate="no">
        Warning: Author and article information is discarded.
    </xsl:message>
</xsl:template>

<!-- Remove tables -->
<xsl:template match="table">
    <xsl:message terminate="no">
        Warning: Table is not supported in RFC ouput, use verbatim text.
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
            <xsl:value-of select="./title" />
        </xsl:attribute>
        <xsl:attribute name="anchor">
            <xsl:value-of select="@id"/>
            <!--            <xsl:value-of select="ancestor::title/@id"/> -->
        </xsl:attribute>
        <xsl:apply-templates/>
    </section>
</xsl:template>

<!-- Transform a <para> to <t> -->
<xsl:template match="para">
    <t><xsl:apply-templates/></t>
</xsl:template>

<!-- Transform lists, kill <listitem> in the process -->
<xsl:template match="orderedlist">
    <xsl:choose>
       <xsl:when test="contains(@numeration,'arabic')">
            <t>
                <list style="numbers">
                    <xsl:apply-templates/>
                </list>
            </t>
       </xsl:when>
       <xsl:otherwise> 
            <t>
                <list style="letters">
                    <xsl:apply-templates/>
                </list>
            </t>
       </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="itemizedlist">
    <t>
        <list style="symbols">
            <xsl:apply-templates/>
        </list>
    </t>
</xsl:template>
<!-- Hanging lists are specified as <variablelist> -->
<xsl:template match="variablelist">
    <t>
        <list style="hanging">
            <xsl:apply-templates/>
        </list>
    </t>
</xsl:template>
<xsl:template match="varlistentry">
    <t>
        <xsl:attribute name="hangText">
            <!-- <xsl:value-of select="./term"/>  -->
            <xsl:value-of select="normalize-space(translate(./term, '&#x20;&#x9;&#xD;&#xA;', ' '))"/>
        </xsl:attribute>
        <xsl:value-of select="./listitem"/>
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
    <t>
    <figure>
        <artwork>
            <xsl:value-of select="./para"/>
        </artwork>
    </figure>
    </t>
</xsl:template>

<!-- Transform <screen> to <figure><artwork> -->
<xsl:template match="screen">
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

</xsl:stylesheet>
