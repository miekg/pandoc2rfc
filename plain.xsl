<?xml version="1.0"?>
<!-- vim: set shiftwidth=1 tabstop=2: -->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exsl="http://exslt.org/strings" version="1.0" extension-element-prefixes="exsl">
<!-- (c) Miek Gieben 2013. Hereby put in the public domain.  Version: @VERSION@ -->
    <xsl:output method="text" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
    <xsl:variable name="spaces" select="'                                                                                     '"/>
    <xsl:variable name="hashes" select="'#####################################################################################'"/>
    <xsl:variable name="dashes" select="'-------------------------------------------------------------------------------------'"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
<xsl:template match="front"/>
<xsl:template match="references"/>
<xsl:template match="t"><xsl:apply-templates/>
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
      <xsl:when test="contains(@style,'emph')">
<xsl:text>_</xsl:text><xsl:value-of select="."/><xsl:text>_</xsl:text>
      </xsl:when>
      <xsl:when test="contains(@style,'strong')">
<xsl:text>*</xsl:text><xsl:value-of select="."/><xsl:text>*</xsl:text> 
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
     <xsl:when test="contains(@style,'hanging')">
      <xsl:for-each select="t">
<xsl:value-of select="@hangText"/>
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>:   </xsl:text>
<xsl:apply-templates/>
<xsl:text>

</xsl:text>
      </xsl:for-each>
     </xsl:when>
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
    <xsl:if test="count(t) = 1">
<xsl:text>> </xsl:text>
<xsl:apply-templates/>
    </xsl:if>
    <xsl:if test="count(t) &gt; 1">
      <xsl:for-each select="t">
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>#.  </xsl:text>
<xsl:apply-templates/>
      </xsl:for-each>
    </xsl:if>
     </xsl:when>
     <xsl:when test="contains(@style,'letters')">
      <xsl:for-each select="t">
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>a.  </xsl:text>
<xsl:apply-templates/>
      </xsl:for-each>
     </xsl:when>
     <xsl:when test="contains(@style,'format %C.')">
      <xsl:for-each select="t">
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>A.  </xsl:text>
<xsl:apply-templates/>
      </xsl:for-each>
     </xsl:when>
     <xsl:when test="contains(@style,'format %i.')">
      <xsl:for-each select="t">
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>ii. </xsl:text>
<xsl:apply-templates/>
      </xsl:for-each>
     </xsl:when>
     <xsl:when test="contains(@style,'format (%d)')">
      <xsl:for-each select="t">
<xsl:text>
</xsl:text>
<xsl:value-of select="substring($spaces, 0, (count(ancestor::list) - 1) * 5 )"/>
<xsl:text>II. </xsl:text>
<xsl:apply-templates/>
      </xsl:for-each>
     </xsl:when>
    </xsl:choose>
    </xsl:template>
    <xsl:template match="artwork">
      <xsl:for-each select="exsl:tokenize(., '&#xA;')">
<xsl:text>    </xsl:text><xsl:value-of select="." /><xsl:text>
</xsl:text>
       </xsl:for-each>
     </xsl:template>
     <xsl:template match="figure">
<xsl:text>

</xsl:text>
<xsl:apply-templates/>
<xsl:if test="@anchor != '' or @title != ''">
<xsl:text>^[</xsl:text><xsl:value-of select="@anchor"/>::<xsl:value-of select="@title"/><xsl:text>]</xsl:text>
</xsl:if>
<xsl:text>
</xsl:text>
     </xsl:template>
    <xsl:template match="texttable">
     <xsl:for-each select="ttcol">
<xsl:value-of select="exsl:align(
string(.),
substring($spaces, 0, 80 div count(../ttcol) ),
'left')"/>
</xsl:for-each>
<xsl:text>
</xsl:text>
     <xsl:for-each select="ttcol">
<xsl:value-of select="exsl:align(
substring($dashes, 0, string-length(.)),     
substring($spaces, 0, 80 div count(../ttcol)),
'left')"/>
</xsl:for-each>
<xsl:text>
</xsl:text>
   <xsl:for-each select="c">
<xsl:value-of select="exsl:align(
string(.),
substring($spaces, 0, 80 div count(../ttcol)),
'left')"/>
<!-- TODO: <xsl:variable name="index" select="((position()-1) mod count(../ttcol)) + 1"/>-->
<!-- <xsl:value-of select="../ttcol[$index]"/> -->
<xsl:if test="position() mod count(../ttcol) = 0">
<xsl:text>
</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:if test="@anchor != '' or @title != ''">
<xsl:text>
</xsl:text>
<xsl:text>^[</xsl:text><xsl:value-of select="@anchor"/>::<xsl:value-of select="@title"/><xsl:text>]</xsl:text>
</xsl:if>
<xsl:text>
</xsl:text>
    </xsl:template>
    <xsl:template match="vspace">
<xsl:text>&lt;vspace</xsl:text>
<xsl:if test="@blankLines">
<xsl:text> blankLines="</xsl:text><xsl:value-of select="@blankLines"/><xsl:text>"</xsl:text>
</xsl:if>
<xsl:text>/&gt;</xsl:text>
</xsl:template>
</xsl:stylesheet>
