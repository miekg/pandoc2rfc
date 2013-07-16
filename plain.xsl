<?xml version="1.0"?>
<!-- vim: set shiftwidth=1 tabstop=2: -->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exsl="http://exslt.org/common" version="1.0" extension-element-prefixes="exsl">
<!-- (c) Miek Gieben 2013. Hereby put in the public domain.  Version: @VERSION@ -->
    <xsl:output method="xml" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="artwork"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="t">
<xsl:value-of select="."/>
<xsl:text>
</xsl:text>
<xsl:text>
</xsl:text>
    </xsl:template>

    <xsl:template match="section">
<xsl:value-of select="substring('###############', 0 , count(ancestor::*)  )"/>
<xsl:text> </xsl:text>
<xsl:value-of select="@title"/>
<xsl:text>
</xsl:text>
    <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="xref">
<xsl:text>[](#</xsl:text><xsl:value-of select="@target"/><xsl:text>)</xsl:text>
    </xsl:template>
</xsl:stylesheet>
