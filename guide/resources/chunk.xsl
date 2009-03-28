<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
    <xsl:import href="xsl/xhtml/chunk.xsl"/>
    <xsl:include href="base.xsl"/>
    <!-- Include tab switching for chunk and single-page -->
    <xsl:include href="tabs.xsl"/>

    <!-- See http://docbook.sourceforge.net/release/xsl/current/doc/html/ for parameters -->

    <!-- Additional parameters for the chunked guide. -->
    <xsl:param name="chunk.first.sections">0</xsl:param>
    <xsl:param name="chunk.section.depth">1</xsl:param>
    <xsl:param name="use.id.as.filename">1</xsl:param>

    <!-- Set param for tabs.xml -->
    <xsl:param name="chunkmode">1</xsl:param>
</xsl:stylesheet>
