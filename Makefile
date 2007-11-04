# $Id$
# Makefile to generate the macports html guide and the man pages.
# The ports 'docbook-xsl' and 'docbook-xml' have to be installed.

# If your macports isn't installed in /opt/local you have to change PREFIX
# here and update resources/macports.xsl to use your port installation!


# prefix of the macports installation:
PREFIX ?= /opt/local

# data directories:
GUIDE ?= guide
MAN   ?= man
# result directories:
GUIDE-RESULT ?= $(GUIDE)/html
MAN-RESULT   ?= $(MAN)/man/

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
	    $(GUIDE-XSL) $(GUIDE)/xml/guide.xml

man:
	mkdir -p $(MAN-RESULT)
	xsltproc --output $(MAN-RESULT) $(MAN-XSL) \
	    $(MAN)/xml/portfile.7.xml \
	    $(MAN)/xml/portfile-global.7.xml \
	    $(MAN)/xml/portfile-phase.7.xml \
	    $(MAN)/xml/portfile-startupitem.7.xml \
	    $(MAN)/xml/portfile-tcl.7.xml

clean:
	rm -rf $(GUIDE-RESULT)
	rm -rf $(MAN-RESULT)
