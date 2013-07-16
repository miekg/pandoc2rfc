<?xml version="1.0"?>
<!-- vim: set shiftwidth=1 tabstop=2: -->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- (c) Miek Gieben 2013. Hereby put in the public domain.  Version: @VERSION@ -->
    <xsl:output method="xml" omit-xml-declaration="yes" />
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
    <xsl:template match="list">
<xsl:text>
</xsl:text>
    <xsl:choose>
     <xsl:when test="contains(@style,'numbers')">
      <xsl:for-each select="t">
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 4 )"/>
<xsl:text>1.  </xsl:text>
<xsl:apply-templates/>
<!-- only when we exit then complete list -->
<xsl:text>
</xsl:text>
      </xsl:for-each>
     </xsl:when>
     <xsl:when test="contains(@style,'symbols')">
      <xsl:for-each select="t">
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 4 )"/>
<xsl:text>*  </xsl:text>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
      </xsl:for-each>
     </xsl:when>
    </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
