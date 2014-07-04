<?xml version="1.0"?>
<!-- (c) Miek Gieben 2014. Hereby put in the public domain. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <xsl:comment> This document was prepared using Pandoc2rfc 3.0.0, https://github.com/miekg/pandoc2rfc </xsl:comment>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="article">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="articleinfo"/>
  <xsl:template match="emphesis">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xsl:template match="emphasis">
    <xsl:choose>
      <xsl:when test="contains(@role,'strong')">
        <xsl:choose>
          <!-- RFC 2119 keywords -->
          <xsl:when test="text() = 'MUST' or text() = 'MUST NOT' or text() = 'REQUIRED' or text() = 'SHALL' or text() = 'SHALL NOT' or text() = 'SHOULD' or text() = 'SHOULD NOT' or text() = 'RECOMMENDED' or text() = 'MAY' or text = 'OPTIONAL'">
            <bcp14>
              <xsl:value-of select="text()"/>
            </bcp14>
          </xsl:when>
          <xsl:otherwise>
            <strong>
              <xsl:apply-templates/>
            </strong>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="literal">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>
  <xsl:template match="subscript">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>
  <xsl:template match="superscript">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>
  <xsl:template match="link">
    <xref>
      <xsl:attribute name="target">
        <xsl:value-of select="@linkend"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xref>
  </xsl:template>
  <xsl:template match="ulink">
    <eref>
      <xsl:attribute name="target">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </eref>
  </xsl:template>
  <!-- Set of span elements that we need for titleelement and other fluff. -->
  <xsl:template match="emphesis" mode="span">
    <xsl:choose>
      <xsl:when test="contains(@role,'strong')">
        <strong>
          <xsl:apply-templates mode="span"/>
        </strong>
      </xsl:when>
      <xsl:otherwise>
        <em>
          <xsl:apply-templates mode="span"/>
        </em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="literal" mode="span">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>
  <!-- The sup and sub tags script are not allowed, so kill the content.-->
  <!-- We use this in the titleelement to create references. -->
  <xsl:template match="subscript" mode="span"/>
  <xsl:template match="superscript" mode="span"/>
  <xsl:template match="link" mode="span">
    <xref>
      <xsl:attribute name="target">
        <xsl:value-of select="@linkend"/>
      </xsl:attribute>
      <xsl:apply-templates mode="span"/>
    </xref>
  </xsl:template>
  <xsl:template match="ulink" mode="span">
    <eref>
      <xsl:attribute name="target">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
      <xsl:apply-templates mode="span"/>
    </eref>
  </xsl:template>
  <!-- Eat these links, so we can search for them when actually seeing a programlisting. -->
  <xsl:template match="programlisting">
    <figure>
      <xsl:if test="following-sibling::*[position()=1][name()='para']/footnote/para/subscript">
        <xsl:attribute name="anchor">
          <xsl:value-of select="following-sibling::*[position()=1][name()='para']/footnote/para/subscript"/>
        </xsl:attribute>
      </xsl:if>
      <titleelement>
        <xsl:apply-templates select="following-sibling::*[position()=1][name()='para']/footnote/para" mode="span"/>
      </titleelement>
      <sourcecode>
        <xsl:value-of select="."/>
      </sourcecode>
    </figure>
  </xsl:template>
  <!-- Discard these links because we want them for <aside>. -->
  <xsl:template match="blockquote/blockquote">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="blockquote">
    <xsl:choose>
      <xsl:when test="child::blockquote">
        <aside>
          <xsl:apply-templates/>
        </aside>
      </xsl:when>
      <xsl:otherwise>
        <blockquote>
          <xsl:apply-templates/>
        </blockquote>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="footnote/para">
    <xsl:choose>
      <xsl:when test="child::superscript">
        <iref>
          <xsl:attribute name="item">
            <xsl:value-of select="superscript"/>
          </xsl:attribute>
          <xsl:attribute name="subitem">
            <xsl:for-each select="./text()[not(ancestor::superscript)]">
              <xsl:value-of select="normalize-space(translate(., '&#10;', ' '))"/>
            </xsl:for-each>
          </xsl:attribute>
        </iref>
      </xsl:when>
      <xsl:otherwise>
        <!-- discard -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Discard these as we echo them when we parse <section> -->
  <xsl:template match="sect1/title | sect2/title | sect3/title | sect4/title | sect5/title"/>
  <xsl:template match="sect1 | sect2 | sect3 | sect4 | sect5">
    <section>
      <xsl:attribute name="anchor">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <titleelement>
        <xsl:apply-templates select="./title" mode="span"/>
      </titleelement>
      <xsl:apply-templates/>
    </section>
  </xsl:template>
  <xsl:template match="para">
    <xsl:choose>
      <xsl:when test="ancestor::tbody">
        <!-- <t> is not allowed in tables' <c> -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <t>
          <xsl:apply-templates/>
        </t>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="orderedlist">
    <ol>
      <xsl:if test="listitem/@override">
        <xsl:attribute name="start">
          <xsl:value-of select="listitem/@override"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:for-each select="listitem">
        <li>
          <xsl:apply-templates/>
        </li>
      </xsl:for-each>
    </ol>
  </xsl:template>
  <xsl:template match="informaltable">
    <texttable>
      <xsl:apply-templates/>
    </texttable>
  </xsl:template>
  <xsl:template match="informaltable/tgroup/thead/row">
    <xsl:for-each select="entry">
      <ttcol>
        <xsl:call-template name="colspec">
          <xsl:with-param name="column" select="round(position() div 2)+1"/>
        </xsl:call-template>
        <xsl:apply-templates/>
      </ttcol>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="colspec">
    <xsl:param name="column"/>
    <xsl:if test="../../../../tgroup/colspec[$column]">
      <xsl:attribute name="align">
        <xsl:value-of select="../../../../tgroup/colspec[$column]/@align"/>
      </xsl:attribute>
      <!-- Optionally colwidth, translate * to % . -->
      <xsl:if test="../../../../tgroup/colspec[$column]/@colwidth">
        <xsl:attribute name="width">
          <xsl:value-of select="translate(../../../../tgroup/colspec[$column]/@colwidth,'*', '%')"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template match="informaltable/tgroup/tbody/row/entry">
    <c>
      <xsl:apply-templates/>
    </c>
  </xsl:template>
  <xsl:template match="figure">
    <figure>
      <xsl:if test="title">
        <titleelement>
          <xsl:apply-templates select="title" mode="span"/>
        </titleelement>
      </xsl:if>
      <artwork type="svg">
        <xi:include>
          <xsl:attribute name="href">
            <xsl:value-of select="mediaobject/imageobject/imagedata/@fileref"/>
          </xsl:attribute>
        </xi:include>
      </artwork>
      <!-- caption? <textobject><phrase>... -->
    </figure>
  </xsl:template>
</xsl:stylesheet>
