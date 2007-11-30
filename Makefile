# $Id$
# Makefile to generate the macports html guide and the man pages.
# The ports 'docbook-xsl' and 'docbook-xml' have to be installed.

# If your macports isn't installed in /opt/local you have to change PREFIX
# here and update man/resources/macports.xsl to use your port installation!


# prefix of the macports installation:
PREFIX ?= /opt/local

# data directories:
GUIDE ?= guide
MAN   ?= man
# source directories:
GUIDE-SRC ?= $(GUIDE)/xml
MAN-SRC   ?= $(MAN)/xml
# result directories:
GUIDE-RESULT ?= $(GUIDE)/html
MAN-RESULT   ?= $(MAN)/man/
# man temporary directory:
MAN-TMP ?= $(MAN)/tmp

# path to the docbook xsl files:
DOCBOOK   ?= $(PREFIX)/share/xsl/docbook-xsl
GUIDE-XSL ?= $(DOCBOOK)/xhtml/profile-docbook.xsl
MAN-XSL   ?= $(MAN)/resources/macports.xsl

# docbook html stylesheet for the guide:
STYLESHEET ?= docbook.css
# additional parameters for the guide:
STRINGPARAMS ?= --stringparam html.stylesheet $(STYLESHEET) \
	              --stringparam section.autolabel 1 \
	              --stringparam toc.section.depth 1 \
	              --stringparam generate.toc "book toc" \
	              --stringparam section.label.includes.component.label 1 \
	              --stringparam profile.condition "noman"


.PHONY: all guide man clean

all: guide man

guide:
	mkdir -p $(GUIDE-RESULT)
	cp $(GUIDE)/resources/$(STYLESHEET) $(GUIDE-RESULT)/$(STYLESHEET)
	cp $(GUIDE)/resources/images/* $(GUIDE-RESULT)/
	xsltproc --xinclude $(STRINGPARAMS) --output $(GUIDE-RESULT)/guide.html \
	    $(GUIDE-XSL) $(GUIDE-SRC)/guide.xml

man:
	mkdir -p $(MAN-RESULT)
	mkdir -p $(MAN-TMP)
	cp $(GUIDE-SRC)/portfile-*.xml $(MAN-TMP)
	sed -i "" 's|<section|<refsection|g' $(MAN-TMP)/*
	sed -i "" 's|</section>|</refsection>|g' $(MAN-TMP)/*
	xsltproc --xinclude --output $(MAN-RESULT) $(MAN-XSL) \
	    $(MAN-SRC)/port.1.xml \
	    $(MAN-SRC)/portfile.7.xml \
	    $(MAN-SRC)/portgroup.7.xml \
	    $(MAN-SRC)/porthier.7.xml
	rm -r $(MAN-TMP)

clean:
	rm -rf $(GUIDE-RESULT)
	rm -rf $(MAN-RESULT)
