# $Id$

# To build MacPorts FAQ files from the source docbook xml.
# michaelm@opendarwin.org, wbb4@opendarwin.org

## Targets
#
# html  : Makes unformated, chunked html from xml
# xhtml : Makes unformated, chunked xhtml from xml
# tidy  : Tidies (formats, indents) xhtml and html
# clean : Deletes html and xhtml
# all   : html, xhtml and tidy

## Details and Caveats
# 
# Requires docbook-xsl and docbook-xml ports to have been installed (or the 
# stylesheets and dtds to have been installed elswhere, and requires the
# libxslt port to be installed.

# This Makefile assumes things have been installed using prefix, you may want
# to override some of the variables below to match your local installation. 

# To use local dtd catalogs you must first create the catalog, I currently assume
# the catalogs are in ${prefix}/etc/xml, if yours are elswhere you should alter
# the $XML_CATALOG_FILES variable. 

# Set XML_DEBUG_CATALOG= to see catalog debugging info.

SOURCEDIR?=		xml
DOCBOOK_XSL?=	        ${prefix}/share/xsl/docbook-xsl/
HTMLDIR?=		html
XHTMLDIR?=		xhtml
STYLESHEET?=	        ${DOCBOOK_XSL}/html/chunk.xsl
XSTYLESHEET?=	        ${DOCBOOK_XSL}/xhtml/chunk.xsl
XML_CATALOG_FILES?=    ${prefix}/etc/xml/catalog
XML_DEBUG_CATALOG?=
CSS_STYLESHEET?=	docbook.css
RESOURCES?=		resources/
STRINGPARAMS?=		--stringparam html.stylesheet ${CSS_STYLESHEET} \
					--stringparam qanda.defaultlabel number \
					--stringparam qanda.inherit.numeration 1

.PHONY : all
.PHONY : clean
#.PHONY : install
.PHONY : html
.PHONY : xhtml
.PHONY : check
.PHONY : tidy

check:
	xmllint --xinclude --noout "${SOURCEDIR}/faq.xml"

html:
	mkdir -p ${HTMLDIR}
	xsltproc --xinclude -o "${HTMLDIR}/" "${STYLESHEET}" "${SOURCEDIR}/faq.xml"

xhtml: 
	mkdir -p ${XHTMLDIR}
	cp ${RESOURCES}${CSS_STYLESHEET} ${XHTMLDIR}
	xsltproc --xinclude ${STRINGPARAMS} -o "${XHTMLDIR}/" "${XSTYLESHEET}" "${SOURCEDIR}/faq.xml"

all: html xhtml tidy

tidy:
# This target will *only* work if you have installed the www/tidy port
# or if have tidy from http://tidy.sourceforge.net/ installed somewhere
# in your path.

	-tidy -quiet -modify -indent ${HTMLDIR}/*
	-tidy -quiet -modify -indent -xml ${XHTMLDIR}/*

clean:
	rm -fr ${HTMLDIR} ${XHTMLDIR}

include ../../base/Mk/macports.autoconf.mk
