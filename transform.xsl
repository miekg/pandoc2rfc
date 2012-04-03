<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- 
    Version: 0.8.8
    (c) Miek Gieben
    Licensed under the GPL version 2.

    Convert DocBook XML as created by Pandoc to XML suitable for RFCs and thus
    parseble with xml2rfc. 
-->

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="article">
    <xsl:apply-templates/>
</xsl:template>

<!-- Remove the article info section, this should be handled
     in the <front> matter of the draft -->
<xsl:template match="articleinfo">
</xsl:template>

<!-- Use footnotes for indexes (iref) -->
<xsl:template match="footnote">
    <xsl:element name="iref">
        <xsl:choose>
        <xsl:when test="contains(./para, '!')">
            <xsl:attribute name="item">
                <xsl:value-of select="substring-before (normalize-space(translate(./para, '&#xA;', ' ')), '!')" />               
            </xsl:attribute>
            <xsl:attribute name="subitem">
                <xsl:value-of select="substring-after (normalize-space(translate(./para, '&#xA;', ' ')), '!')" />               
            </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
            <xsl:attribute name="item">
                <xsl:value-of select="normalize-space(translate(./para, '&#xA;', ' '))" />               
            </xsl:attribute>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:element>
</xsl:template>

<!-- Merge section with the title tags into one section -->
<xsl:template match="section | simplesect | sect1 | sect2 | sect3 | sect4 | sect5">
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
<!-- If somebody tries to use multiple paragraphs, we insert a <vspace> *yech* -->
<xsl:template match="para | simpara">
    <xsl:choose>
        <xsl:when test="ancestor::orderedlist">
                <xsl:if test="position() > 2">
                    <vspace blankLines='1' />
                </xsl:if>
                <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="ancestor::itemizedlist">
                <xsl:if test="position() > 2">
                    <vspace blankLines='1' />
                </xsl:if>
                <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="ancestor::variablelist">
                <xsl:if test="position() > 2">
                    <vspace blankLines='1' />
                </xsl:if>
                <xsl:apply-templates/>
        </xsl:when>
        <!-- AsciiDoc puts simpara in each table element, remove it -->
        <xsl:when test="ancestor::tbody">
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

<!-- Transform lists, for lists in list we do not put it in a new <t></t> -->
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
                <list style="empty"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::itemizedlist">
                <list style="empty"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:when test="ancestor::variablelist">
                <list style="empty"><xsl:apply-templates/></list>
            </xsl:when>
            <xsl:otherwise>
                <t><list style="empty"><xsl:apply-templates/></list></t>
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
        <!-- OPTION: enable this to get a newline after the hangText -->
        <!-- <xsl:element name="vspace"/> -->
        <xsl:apply-templates select="./listitem"/>
    </t>
</xsl:template>

<!-- Transform <link> to <xref> crosslinks -->
<!-- Use [see](#mysection) in Pandoc -->
<xsl:template match="link">
    <xref>
        <xsl:attribute name="target">
            <xsl:value-of select="@linkend"/>
        </xsl:attribute>
    <xsl:apply-templates/>
    </xref>
</xsl:template>

<!-- Transform <ulink> to <eref> links -->
<!-- Use [see](uri) in Pandoc -->
<xsl:template match="ulink">
    <eref>
        <xsl:attribute name="target">
            <xsl:value-of select="@url"/>
        </xsl:attribute>
    <xsl:apply-templates/>
    </eref>
</xsl:template>

<!-- Transform <blockquote> to <list style="hanging"> -->
<xsl:template match="blockquote">
    <t><list style="hanging" hangIndent="3">
        <xsl:apply-templates/>   
    </list></t>
</xsl:template>

<!-- Transform <screen> and <programlisting> to <figure><artwork> -->
<xsl:template match="screen | programlisting">
    <figure>
        <xsl:choose>
            <xsl:when test="contains(., 'Figure: ')">
                <xsl:attribute name="anchor">
                    <xsl:text>fig:</xsl:text>
                    <xsl:value-of select="translate( translate(substring(normalize-space(translate( substring-after(., 'Figure: ') , '&#xA;', ' ')), 1, 10), ' ', '-'), $uppercase, $smallcase)"/>
                </xsl:attribute>
                <!-- If there is an caption, center the figure -->
                <xsl:attribute name="align">
                    <xsl:text>center</xsl:text>
                </xsl:attribute>
                <preamble>
                    <xsl:value-of select="substring-after(., 'Figure: ')"/>
                </preamble>
                <artwork>
                    <xsl:value-of select="substring-before(., 'Figure: ')"/>
                </artwork>
            </xsl:when>
            <xsl:otherwise>
                <artwork>
                    <xsl:value-of select="."/>
                </artwork>
            </xsl:otherwise>
        </xsl:choose>
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
        <!-- If there is a caption, fake an anchor attribute -->
        <xsl:if test="./caption">
            <xsl:attribute name="anchor">
                <xsl:text>tab:</xsl:text>
                <xsl:value-of select="translate( translate(substring(normalize-space(translate(./caption, '&#xA;', ' ')), 1, 10), ' ', '-'), $uppercase, $smallcase)" />
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="./title">
            <xsl:attribute name="anchor">
                <xsl:text>tab:</xsl:text>
                <xsl:value-of select="translate( translate(substring(normalize-space(translate(./title, '&#xA;', ' ')), 1, 10), ' ', '-'), $uppercase, $smallcase)" />
            </xsl:attribute>
        </xsl:if>
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
        <!-- Every even position() need to be dealt with: 2 look back to 1, 4 look back to 2, etc. -->
        <xsl:if test="position() = 2">
            <xsl:call-template name="get_col"><xsl:with-param name="column" select="1"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 4">
            <xsl:call-template name="get_col"><xsl:with-param name="column" select="2"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 6">
            <xsl:call-template name="get_col"><xsl:with-param name="column" select="3"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 8">
            <xsl:call-template name="get_col"><xsl:with-param name="column" select="4"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 10">
            <xsl:call-template name="get_col"><xsl:with-param name="column" select="5"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 12">
            <xsl:call-template name="get_col"><xsl:with-param name="column" select="6"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 14">
            <xsl:call-template name="get_col"><xsl:with-param name="column" select="7"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 16">
            <xsl:call-template name="get_col"><xsl:with-param name="column" select="8"/></xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </ttcol>
</xsl:template>

<xsl:template name="get_col">
    <xsl:param name="column"/>
    <xsl:if test="../../../col[$column]">
        <xsl:attribute name="width">
            <xsl:value-of select="../../../col[$column]/@width"/>
        </xsl:attribute>
    </xsl:if>
</xsl:template>

<!-- Table headers for CALS tables, Pandoc 1.8.2.x+ emits these -->
<xsl:template match="table/tgroup/thead/row/entry">
    <ttcol>
        <xsl:if test="position() = 2">
            <xsl:call-template name="get_colspec"><xsl:with-param name="column" select="1"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 4">
            <xsl:call-template name="get_colspec"><xsl:with-param name="column" select="2"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 6">
            <xsl:call-template name="get_colspec"><xsl:with-param name="column" select="3"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 8">
            <xsl:call-template name="get_colspec"><xsl:with-param name="column" select="4"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 10">
            <xsl:call-template name="get_colspec"><xsl:with-param name="column" select="5"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 12">
            <xsl:call-template name="get_colspec"><xsl:with-param name="column" select="6"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 14">
            <xsl:call-template name="get_colspec"><xsl:with-param name="column" select="7"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 16">
            <xsl:call-template name="get_colspec"><xsl:with-param name="column" select="8"/></xsl:call-template>
        </xsl:if>
        <!-- If the entry itself has align, we always use that -->
        <xsl:if test="@align">
            <xsl:attribute name="align">
                <xsl:value-of select="@align"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </ttcol>
</xsl:template>

<xsl:template name="get_colspec">
    <xsl:param name="column"/>
    <xsl:if test="../../../../tgroup/colspec[$column]">
        <xsl:attribute name="align">
            <xsl:value-of select="../../../../tgroup/colspec[$column]/@align"/>
        </xsl:attribute>
        <!-- Optionally colwidth, translate * to % -->
        <xsl:if test="../../../../tgroup/colspec[$column]/@colwidth">
            <xsl:attribute name="width">
                <xsl:value-of select="translate(../../../../tgroup/colspec[$column]/@colwidth, '*', '%')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:if>
</xsl:template>

<!-- Table headers for CALS tables, Pandoc 1.9.x+ emits these -->
<xsl:template match="informaltable/tgroup/thead/row/entry">
    <ttcol>
        <xsl:if test="position() = 2">
            <xsl:call-template name="get_colspec_informal"><xsl:with-param name="column" select="1"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 4">
            <xsl:call-template name="get_colspec_informal"><xsl:with-param name="column" select="2"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 6">
            <xsl:call-template name="get_colspec_informal"><xsl:with-param name="column" select="3"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 8">
            <xsl:call-template name="get_colspec_informal"><xsl:with-param name="column" select="4"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 10">
            <xsl:call-template name="get_colspec_informal"><xsl:with-param name="column" select="5"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 12">
            <xsl:call-template name="get_colspec_informal"><xsl:with-param name="column" select="6"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 14">
            <xsl:call-template name="get_colspec_informal"><xsl:with-param name="column" select="7"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="position() = 16">
            <xsl:call-template name="get_colspec_informal"><xsl:with-param name="column" select="8"/></xsl:call-template>
        </xsl:if>
        <!-- If the entry itself has align, we always use that -->
        <xsl:if test="@align">
            <xsl:attribute name="align">
                <xsl:value-of select="@align"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </ttcol>
</xsl:template>

<xsl:template name="get_colspec_informal">
    <xsl:param name="column"/>
    <xsl:if test="../../../../tgroup/colspec[$column]">
        <xsl:attribute name="align">
            <xsl:value-of select="../../../../tgroup/colspec[$column]/@align"/>
        </xsl:attribute>
        <!-- Optionally colwidth, translate * to % -->
        <xsl:if test="../../../../tgroup/colspec[$column]/@colwidth">
            <xsl:attribute name="width">
                <xsl:value-of select="translate(../../../../tgroup/colspec[$column]/@colwidth, '*', '%')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template match="table/tbody/tr/td | informaltable/tbody/tr/td | table/tgroup/tbody/row/entry | informaltable/tgroup/tbody/row/entry">
    <c><xsl:apply-templates/></c>
</xsl:template>

<!-- CALS table -->
<xsl:template match="table/tbody/row/entry">
    <c><xsl:apply-templates/></c>
</xsl:template>

</xsl:stylesheet>
