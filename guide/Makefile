# $Id: Makefile,v 1.1 2003/03/25 07:19:34 michaelm Exp $

# To build DarwinPorts  guide files from the source docbook xml.
# michaelm@opendarwin.org

# set XML_DEBUG_CATALOG= to see catalog debugging info

.PHONY : all
.PHONY : clean
.PHONY : install
.PHONY : html
.PHONY : xhtml


SOURCEDIR?=		xml
DOCBOOK_XSL?=	${PREFIX}/share/xsl/docbook-xsl/1.55.0
HTMLDIR?=		html
STYLESHEET?=	${DOCBOOK_XSL}/html/chunk.xsl


html:

	mkdir -p html
	xsltproc --xinclude -o "${HTMLDIR}/" "${STYLESHEET}" "${SOURCEDIR}/guide.xml"
	
xhtml:

	mkdir -p xhtml
	xsltproc --xinclude -o "${XHTMLDIR}/" "${STYLESHEET}" "${SOURCEDIR}/guide.xml"
	
all: html xhtml

include ../../base/Mk/dports.mk
