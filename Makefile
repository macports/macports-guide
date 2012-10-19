# $Id$

# Makefile to generate the MacPorts HTML guide and the man pages.
# The ports 'docbook-xsl', 'docbook-xml' and 'libxslt' have to be installed.
# For the guide-dblatex target, the 'dblatex' port is also required.

# If your MacPorts isn't installed in /opt/local you have to change PREFIX
# here.

UNAME := $(shell uname)

# Prefix of the MacPorts installation.
PREFIX = /opt/local
ifeq ($(UNAME), Linux)
PREFIX = /usr
endif

# Command abstraction variables.
MKDIR    = /bin/mkdir
CP       = /bin/cp
RM       = /bin/rm
LN       = /bin/ln
SED      = /usr/bin/sed
ifeq ($(UNAME), Linux)
SED      = /bin/sed
endif
TCLSH    = /usr/bin/tclsh
XSLTPROC = $(PREFIX)/bin/xsltproc
XMLLINT  = $(PREFIX)/bin/xmllint
DBLATEX  = $(PREFIX)/bin/dblatex

# Data directories.
GUIDE = guide
MAN   = man
# Source directories.
GUIDE_SRC = $(GUIDE)/xml
MAN_SRC   = $(MAN)/xml
# Result directories.
GUIDE_RESULT         = $(GUIDE)/html
GUIDE_RESULT_CHUNK   = $(GUIDE_RESULT)/chunked
GUIDE_RESULT_DBLATEX = $(GUIDE)/dblatex
MAN_RESULT           = $(MAN)/man/
# Man temporary directory.
MAN_TMP = $(MAN)/tmp

# Path to the DocBook XSL files.
DOCBOOK         = $(PREFIX)/share/xsl/docbook-xsl
ifeq ($(UNAME), Linux)
DOCBOOK         = /usr/local/share/xsl/docbook-xsl
endif
GUIDE_XSL       = $(GUIDE)/resources/single-page.xsl
GUIDE_XSL_CHUNK = $(GUIDE)/resources/chunk.xsl
MAN_XSL         = $(MAN)/resources/macports.xsl

# DocBook HTML stylesheet for the guide.
STYLESHEET = docbook.css

.PHONY: all guide guide-chunked guide-dblatex man clean validate

all: guide guide-chunked man

# Generate the HTML guide using DocBook from the XML sources in $(GUIDE_SRC).
guide:
	$(MKDIR) -p $(GUIDE_RESULT)
	$(CP) $(GUIDE)/resources/$(STYLESHEET) $(GUIDE_RESULT)/$(STYLESHEET)
	$(CP) $(GUIDE)/resources/images/* $(GUIDE_RESULT)/
ifeq ($(UNAME), Linux)
	$(LN) -sfn $(DOCBOOK) $(GUIDE)/resources/xsl
else
	$(LN) -sfh $(DOCBOOK) $(GUIDE)/resources/xsl
endif
	$(XSLTPROC) --xinclude \
	    --output $(GUIDE_RESULT)/index.html \
	    $(GUIDE_XSL) $(GUIDE_SRC)/guide.xml
	# Convert all sections (h1-h9) to a link so it's easy to link to them.
	# If someone knows a better way to do this please change it.
ifeq ($(UNAME), Linux)
	$(SED) -i -r -e \
	    's|(<h[0-9] [^>]*><a id="([^"]*)"></a>)([^<]*)(</h[0-9]>)|\1<a href="#\2">\3</a>\4|g' \
	    $(GUIDE_RESULT)/index.html
else
	$(SED) -i "" -E \
	    's|(<h[0-9] [^>]*><a id="([^"]*)"></a>)([^<]*)(</h[0-9]>)|\1<a href="#\2">\3</a>\4|g' \
	    $(GUIDE_RESULT)/index.html
endif

# Generate the chunked HTML guide with one section per file.
guide-chunked:
	$(MKDIR) -p $(GUIDE_RESULT_CHUNK)
	$(CP) $(GUIDE)/resources/$(STYLESHEET) $(GUIDE_RESULT_CHUNK)/$(STYLESHEET)
	$(CP) $(GUIDE)/resources/images/* $(GUIDE_RESULT_CHUNK)/
ifeq ($(UNAME), Linux)
	$(LN) -sfn $(DOCBOOK) $(GUIDE)/resources/xsl
else
	$(LN) -sfh $(DOCBOOK) $(GUIDE)/resources/xsl
endif
	$(XSLTPROC) --xinclude \
	    --output $(GUIDE_RESULT_CHUNK)/index.html \
	    $(GUIDE_XSL_CHUNK) $(GUIDE_SRC)/guide.xml
	# Convert all sections (h1-h9) to a link so it's easy to link to them.
	# If someone knows a better way to do this please change it.
ifeq ($(UNAME), Linux)
	$(SED) -i -r -e \
	    's|(<h[0-9] [^>]*><a id="([^"]*)"></a>)([^<]*)(</h[0-9]>)|\1<a href="#\2">\3</a>\4|g' \
	    $(GUIDE_RESULT_CHUNK)/*.html
else
	$(SED) -i "" -E \
	    's|(<h[0-9] [^>]*><a id="([^"]*)"></a>)([^<]*)(</h[0-9]>)|\1<a href="#\2">\3</a>\4|g' \
	    $(GUIDE_RESULT_CHUNK)/*.html
endif
	# Add the table of contents to every junked HTML file.
	# If someone knows a better way to do this please change it.
	$(TCLSH) toc-for-chunked.tcl $(GUIDE_RESULT_CHUNK)

# Generate the guide as a PDF.
guide-dblatex: SUFFIX = pdf
guide-dblatex:
	$(MKDIR) -p $(GUIDE_RESULT_DBLATEX)
	$(DBLATEX) \
		--fig-path="$(GUIDE)/resources/images" \
		--type="$(SUFFIX)" \
		--param='toc.section.depth=2' \
		--param='doc.section.depth=3' \
		--output="$(GUIDE_RESULT_DBLATEX)/macports-guide.$(SUFFIX)" \
	$(GUIDE_SRC)/guide.xml

# Generate the man pages using DocBook from the XML source in $(MAN_SRC).
# The portfile-*.xml and portgroup-*.xml files in $(GUIDE_SRC) are copied to
# $(MAN_TMP) and modified (section -> refsection) so they can be used as man
# XML source files and then xincluded in the real man XML files in $(MAN_SRC).
man: $(MAN_XSL)
	$(MKDIR) -p $(MAN_RESULT)
	$(MKDIR) -p $(MAN_TMP)
	$(CP) $(GUIDE_SRC)/portfile-*.xml $(MAN_TMP)
	$(CP) $(GUIDE_SRC)/portgroup-*.xml $(MAN_TMP)
ifeq ($(UNAME), Linux)
	$(SED) -i -r -e 's|<section|<refsection|g' $(MAN_TMP)/*
	$(SED) -i -r -e 's|</section>|</refsection>|g' $(MAN_TMP)/*
else
	$(SED) -i "" 's|<section|<refsection|g' $(MAN_TMP)/*
	$(SED) -i "" 's|</section>|</refsection>|g' $(MAN_TMP)/*
endif
	$(XSLTPROC) --xinclude --output $(MAN_RESULT) $(MAN_XSL) \
	    $(MAN_SRC)/port.1.xml \
	    $(MAN_SRC)/portfile.7.xml \
	    $(MAN_SRC)/portgroup.7.xml \
	    $(MAN_SRC)/porthier.7.xml
	$(RM) -r $(MAN_TMP)

# Create XSL from template for man pages.
$(MAN_XSL):
ifeq ($(UNAME), Linux)
	$(SED) -r -e 's:@PREFIX@:$(PREFIX):' $@.in > $@
else
	$(SED) 's:@PREFIX@:$(PREFIX):' $@.in > $@
endif

# Remove all temporary files generated by guide: and man:.
clean:
	$(RM) -rf $(GUIDE)/resources/xsl
	$(RM) -rf $(GUIDE_RESULT)
	$(RM) -rf $(GUIDE_RESULT_DBLATEX)
	$(RM) -rf $(MAN_RESULT)
	$(RM) -rf $(MAN_TMP)
	$(RM) -rf $(MAN_XSL)
	$(RM) -f  guide.tmp.xml

# Validate the XML files for the guide.
validate:
	$(XMLLINT) --xinclude --loaddtd --postvalid --noout $(GUIDE_SRC)/guide.xml
