<?xml version="1.0"?>
<!-- vim: set shiftwidth=1 tabstop=2: -->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- (c) Miek Gieben 2013. Hereby put in the public domain.  Version: @VERSION@ -->
    <xsl:output method="text" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="artwork"/>
    <xsl:variable name="spaces" select="'                                                             '"/>
    <xsl:variable name="hashes" select="'#############################################################'"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="t">
    <xsl:apply-templates/>
<xsl:text>
</xsl:text>
<xsl:text>
</xsl:text>
    </xsl:template>
    <xsl:template match="spanx">
     <xsl:choose>
      <xsl:when test="contains(@style,'verb')">
<xsl:text>`</xsl:text><xsl:value-of select="."/><xsl:text>`</xsl:text> 
      </xsl:when>
     </xsl:choose>
    </xsl:template>
    <xsl:template match="section">
<xsl:text>#</xsl:text>
<xsl:value-of select="substring($hashes, 0 , count(ancestor::section)  )"/>
<xsl:text> </xsl:text>
<xsl:value-of select="@title"/>
<xsl:text>
</xsl:text>
    <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="xref">
<xsl:text>[](#</xsl:text><xsl:value-of select="@target"/><xsl:text>)</xsl:text>
    </xsl:template>
    <xsl:template match="eref">
<xsl:text>[</xsl:text><xsl:value-of select="."/><xsl:text>](</xsl:text><xsl:value-of select="@target"/><xsl:text>)</xsl:text>
    </xsl:template>
    <xsl:template match="list">
<xsl:if test="not(ancestor::list)">
<xsl:text>
</xsl:text>
</xsl:if>
    <xsl:choose>
     <xsl:when test="contains(@style,'numbers')">
      <xsl:for-each select="t">
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>1.  </xsl:text>
<xsl:apply-templates/>
      </xsl:for-each>
     </xsl:when>
     <xsl:when test="contains(@style,'symbols')">
      <xsl:for-each select="t">
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>*  </xsl:text>
<xsl:apply-templates/>
      </xsl:for-each>
     </xsl:when>
     <xsl:when test="contains(@style,'empty')">
      <xsl:for-each select="t">
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>#.  </xsl:text>
<xsl:apply-templates/>
      </xsl:for-each>
     </xsl:when>
    </xsl:choose>
    </xsl:template>
    <xsl:template match="artwork">
<xsl:value-of select='translate(".", &#10;, "    ")'/>
    </xsl:template>
</xsl:stylesheet>
