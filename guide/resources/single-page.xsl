<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
    <xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml/profile-docbook.xsl"/>
    <xsl:include href="base.xsl"/>
    <!-- Include tab switching for chunk and single-page -->
    <xsl:include href="tabs.xsl"/>
    <xsl:template name="body.attributes">
        <xsl:attribute name="class">singlepage</xsl:attribute>
    </xsl:template>
    <xsl:include href="sticky-sidebar.xsl"/>

    <!-- See http://docbook.sourceforge.net/release/xsl/current/doc/html/ for parameters -->

    <!-- Set param for tabs.xml -->
    <xsl:param name="chunkmode">0</xsl:param>
</xsl:stylesheet>
