# The MacPorts Guide

The MacPorts guide is the main documentation of MacPorts, providing information
on the use of the port(1) tool, the Portfile format, and the project's
policies.

## Building

To generate it you have to checkout the entire "macports-guide" repository,
and you need the "docbook-xsl", "docbook-xml-5.0" and "libxslt" ports.
If your port installation isn't in /opt/local, edit or override the
PREFIX Makefile variable.

### HTML Output

To generate the guide just run "make" in this directory; the HTML version will
be placed in guide/html.

### PDF Output

To generate a PDF version of the guide, use "make guide-dblatex". This
requires the "dblatex" port.
