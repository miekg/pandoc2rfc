<?xml version="1.0"?>
<!-- vim:set sw=2 expandtab: -->
<!-- (c) Miek Gieben 2014. Hereby put in the public domain. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xi" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <xsl:comment>By Pandoc2rfc 3.0.0, https://github.com/miekg/pandoc2rfc.</xsl:comment>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="article">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="articleinfo"/>
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
      <xsl:when test="contains(@role,'strikethrough')">
        <xsl:message>
         pandoc2rfc: strikethrough is not supported.
       </xsl:message>
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
  <!-- Set of span elements that we need for name and other fluff. -->
  <xsl:template match="emphasis" mode="span">
    <xsl:choose>
      <xsl:when test="contains(@role,'strikethrough')"/>
      <!-- Discard -->
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
  <!-- We use this in the name to create references. -->
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
      <name>
        <xsl:apply-templates select="following-sibling::*[position()=1][name()='para']/footnote/para" mode="span"/>
      </name>
      <!-- If there is a language= tag we use source code, otherwise artwork -->
      <xsl:choose>
        <xsl:when test="@language">
          <sourcecode>
            <xsl:attribute name="type">
              <xsl:value-of select="@language"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
          </sourcecode>
        </xsl:when>
        <xsl:otherwise>
          <artwork>
            <xsl:value-of select="."/>
          </artwork>
        </xsl:otherwise>
      </xsl:choose>
    </figure>
  </xsl:template>
  <!-- Discard these links because we want them for <aside>. -->
  <xsl:template match="blockquote/blockquote">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- Strikethrough text signals the cite -->
  <xsl:template match="blockquote/para/emphasis">
    <xsl:choose>
      <xsl:when test="contains(@role,'strikethrough')"/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
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
          <xsl:if test="contains(para/emphasis/@role,'strikethrough')">
            <xsl:attribute name="cite">
              <xsl:value-of select="para/emphasis"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="following-sibling::*[position()=1][name()='para']/footnote/para/subscript">
            <xsl:attribute name="anchor">
              <xsl:value-of select="following-sibling::*[position()=1][name()='para']/footnote/para/subscript"/>
            </xsl:attribute>
          </xsl:if>
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
  <xsl:template match="sect1/title | sect2/title | sect3/title | sect4/title | sect5/title | simplesect/title"/>
  <xsl:template match="sect1 | sect2 | sect3 | sect4 | sect5 | simplesect">
    <xsl:choose>
      <xsl:when test="name() = 'sect1' and contains(title/emphasis/@role,'strikethrough') and title/emphasis/text() = 'abstract'">
        <abstract>
          <xsl:apply-templates/>
        </abstract>
      </xsl:when>
      <xsl:when test="name() = 'sect1' and contains(title/emphasis/@role, 'strikethrough') and title/emphasis/text() = 'note'">
        <note>
          <name>
            <xsl:apply-templates select="./title" mode="span"/>
          </name>
          <xsl:apply-templates/>
        </note>
      </xsl:when>
      <xsl:otherwise>
        <section>
          <xsl:attribute name="anchor">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
          <name>
            <xsl:apply-templates select="./title" mode="span"/>
          </name>
          <xsl:apply-templates/>
        </section>
      </xsl:otherwise>
    </xsl:choose>
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
  <!-- Discard because used for style='a format %d' -->
  <xsl:template match="orderedlist/listitem/para/emphasis">
    <xsl:choose>
      <xsl:when test="contains(@role,'strikethrough')"/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="orderedlist">
    <xsl:choose>
      <xsl:when test="ancestor::para">
        <xsl:call-template name="orderedlist"/>
      </xsl:when>
      <xsl:otherwise>
        <t>
          <xsl:call-template name="orderedlist"/>
        </t>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="orderedlist">
    <ol>
      <xsl:if test="contains(listitem/para/emphasis/@role,'strikethrough')">
        <xsl:attribute name="style">
          <xsl:value-of select="listitem/para/emphasis"/>
        </xsl:attribute>
      </xsl:if>
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
  <xsl:template match="variablelist">
    <xsl:choose>
      <xsl:when test="ancestor::para">
        <xsl:call-template name="variablelist"/>
      </xsl:when>
      <xsl:otherwise>
        <t>
          <xsl:call-template name="variablelist"/>
        </t>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="variablelist">
    <dl>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>
  <xsl:template match="varlistentry">
    <dt>
      <xsl:apply-templates select="term"/>
    </dt>
    <dd>
      <xsl:apply-templates select="listitem"/>
    </dd>
  </xsl:template>
  <xsl:template match="informaltable">
    <texttable>
      <xsl:if test="following-sibling::*[position()=1][name()='para']/footnote/para/subscript">
        <xsl:attribute name="anchor">
          <xsl:value-of select="following-sibling::*[position()=1][name()='para']/footnote/para/subscript"/>
        </xsl:attribute>
      </xsl:if>
      <name>
        <xsl:apply-templates select="following-sibling::*[position()=1][name()='para']/footnote/para" mode="span"/>
      </name>
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

  <xsl:template match="inlinemediaobject">
    <xsl:choose>
      <xsl:when test="following-sibling::*[position()=1][name()='footnote']">
        <figure>
          <xsl:if test="following-sibling::*[position()=1][name()='footnote']/para/subscript">
            <xsl:attribute name="anchor">
              <xsl:value-of select="following-sibling::*[position()=1][name()='footnote']/para/subscript"/>
            </xsl:attribute>
          </xsl:if>
          <name>
            <xsl:apply-templates select="following-sibling::*[position()=1][name()='footnote']/para" mode="span"/>
          </name>
          <artwork type="svg">
            <xi:include>
              <xsl:attribute name="href">
                <xsl:value-of select="imageobject/imagedata/@fileref"/>
              </xsl:attribute>
            </xi:include>
          </artwork>
        </figure>
      </xsl:when>
      <xsl:otherwise>
        <artwork type="svg">
          <xi:include>
            <xsl:attribute name="href">
              <xsl:value-of select="imageobject/imagedata/@fileref"/>
            </xsl:attribute>
          </xi:include>
        </artwork>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Warn about unused constructs. -->
  <xsl:template match="literallayout">
    <xsl:message>
         pandoc2rfc: literallayout is not supported.
       </xsl:message>
  </xsl:template>
  <xsl:template match="figure">
    <xsl:message>
         pandoc2rfc: figure as such is not supported.
       </xsl:message>
  </xsl:template>
</xsl:stylesheet>
