<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:template name="user.header.content">
      <div id="tabswitch">
          <a href="/index.html">
              <xsl:if test="$chunkmode = 0">
                  <xsl:attribute name="class">selected</xsl:attribute>
              </xsl:if>
              Single Page
          </a>
          <a href="/chunked/index.html">
              <xsl:if test="$chunkmode = 1">
                  <xsl:attribute name="class">selected</xsl:attribute>
              </xsl:if>
              Chunked
          </a>
      </div>
  </xsl:template>

</xsl:stylesheet>
