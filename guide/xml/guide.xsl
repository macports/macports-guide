<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                version="1.0">
<xsl:import href="/opt/local/share/xsl/docbook-xsl/1.55.0/html/docbook.xsl"/>

<xsl:template match="para">
  <span style="background-color: rgb(200,200,200);
	color: rgb(100,0,100);">
  <xsl:call-template name="inline.charseq"/>
  </span>
</xsl:template>
</xsl:stylesheet>
