<?xml version="1.0"?>
<!-- (c) Miek Gieben 2014. Hereby put in the public domain. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
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
        <strong>
          <xsl:apply-templates/>
        </strong>
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
      <artwork>
        <xsl:value-of select="."/>
      </artwork>
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
    <t>
      <xsl:apply-templates/>
    </t>
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
</xsl:stylesheet>
