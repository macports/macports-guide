<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'
  xmlns:exslt="http://exslt.org/common"
>
    <!-- See http://docbook.sourceforge.net/release/xsl/current/doc/html/ for parameters -->

    <xsl:param name="html.stylesheet">docbook.css</xsl:param>
    <xsl:param name="section.autolabel">1</xsl:param>
    <xsl:param name="toc.section.depth">1</xsl:param>
    <xsl:param name="generate.toc">book toc</xsl:param>
    <xsl:param name="section.label.includes.component.label">1</xsl:param>
    <xsl:param name="profile.condition">noman</xsl:param>
    <xsl:param name="css.decoration">0</xsl:param>

    <!-- custom templates for macros -->

    <xsl:template match="processing-instruction('macro-outdated')">
        <xsl:variable name="reason" select="substring-before(substring-after(., 'reason=&quot;'), '&quot;')" />
        <xsl:variable name="out">
            <xsl:apply-templates select="//warning[@role = 'macro-outdated']" />
            <macro-with-param name="reason">
              <xsl:value-of select="$reason" />
            </macro-with-param>
        </xsl:variable>
        <xsl:apply-templates select="exslt:node-set($out)" mode="macro-replace" />
    </xsl:template>

    <!-- copy macro-param verbatim in normal mode -->
    <xsl:template match="macro-param">
      <xsl:copy>
        <xsl:copy-of select="@*|node()" />
      </xsl:copy>
    </xsl:template>


    <!-- begin mode: macro-replace -->

    <!-- identity copy in macro-replace mode -->
    <xsl:template match="@*|node()" mode="macro-replace">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" mode="macro-replace"/>
        </xsl:copy>
    </xsl:template>

    <!-- replace macro-param with value -->
    <xsl:template match="processing-instruction('macro-param')" mode="macro-replace">
        <xsl:variable name="name" select="substring-before(substring-after(., 'name=&quot;'), '&quot;')" />
        <xsl:copy-of select="following::macro-with-param[@name = $name]/text()" />
    </xsl:template>

    <!-- skip macro-with-param -->
    <xsl:template match="macro-with-param" mode="macro-replace">
        <!-- no output -->
    </xsl:template>

    <!-- end mode: macro-replace -->


    <!-- all macro content is defined in guide/xml/macros.xml, but hidden from normal output -->
    <xsl:template match="section[@id = 'macros']">
        <!-- no output -->
    </xsl:template>

</xsl:stylesheet>
