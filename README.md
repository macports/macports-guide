# The MacPorts Guide

The MacPorts guide is the main documentation of MacPorts, providing information
on the use of the port(1) tool, the Portfile format, and the project's
policies.

## Branches

  * **master**:       Automatically published to https://guide.macports.org
  * **release-X.Y**:  Documentation for upcoming releases, not meant to be public yet

When a new MacPorts X.Y.0 is released, the release-X.Y branch will be merged to
master to make the documentation available.

## Building

To generate  the guide, clone the macports-guide repository:

```
$ git clone https://github.com/macports/macports-guide.git
$ cd macports-guide/
```

You will also need the following tools which are required to convert the
DocBook XML sources to the desired output format. You can install them from
MacPorts with this command:

```
$ sudo port install libxml2 libxslt docbook-xsl-ns docbook-xml-5.0
```

### HTML Output

To generate the guide just run `make` in this directory; the HTML version will
be placed in `guide/html/`.

```
$ make
$ open guide/html/index.html
```

### PDF Output

In addition to the dependencies listed above, the PDF output format also
requires the `dblatex` port.

```
$ sudo port install dblatex
```

To generate a PDF version of the guide, use `make guide-dblatex`.

```
$ make guide-dblatex
$ open guide/dblatex/macports-guide.pdf
```
