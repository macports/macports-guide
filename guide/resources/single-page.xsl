<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
    <xsl:import href="xsl/xhtml/profile-docbook.xsl"/>
    <xsl:include href="base.xsl"/>
    <!-- Include tab switching for chunk and single-page -->
    <xsl:include href="tabs.xsl"/>

    <!-- See http://docbook.sourceforge.net/release/xsl/current/doc/html/ for parameters -->

    <!-- Set param for tabs.xml -->
    <xsl:param name="chunkmode">0</xsl:param>
</xsl:stylesheet>
