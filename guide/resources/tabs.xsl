<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
	<xsl:template name="user.header.content">
		<div style="max-width: 1000px; margin: 0 auto;">
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
		</div>
		<xsl:if test="$chunkmode = 1">
			<!-- Only clear in chunk mode, otherwise the header moves down on
				 the single-page version -->
			<div style="clear: right;"></div>
		</xsl:if>
		<div id="vh-test"></div> <!-- needed for the sticky sidebar -->
	</xsl:template>
</xsl:stylesheet>
