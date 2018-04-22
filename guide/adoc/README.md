# AsciiDoc version of the guide

This is a preliminary attempt to convert the guide from DocBook to AsciiDoc.

The conversion has been done with [docbookrx](https://github.com/asciidoctor/docbookrx):

    docbookrx guide.xml

## Generating HTML

An easy way to create HTML pages is to run

    asciidoc guide.adoc

or

    asciidoctor guide.adoc

## Plan

For MacPorts transition to AsciiDoc we envision doing the following:

* With the highest priority fix issues with conversion
  (either manually or by patching `docbookrx`).
* First convert `.adoc` files back to docbook `.xml` format and use the
  existing toolchain to generate the html pages (to avoid further delays).
* Once that works, start working on improving the workflow and try to go
  directly from AsciiDoc to html (and pdf), trying to keep the option to
  generate multi-page html.

We would be grateful for help, in particular towards fixing the issues with
conversion.

## Known issues

During the initial conversion the following warnings are thrown:

    No visitor defined for <simplelist>! Skipping.
    No visitor defined for <email>! Skipping.
    No visitor defined for <optional>! Skipping.
    No visitor defined for <citerefentry>! Skipping.
    No visitor defined for <refentry>! Skipping.
    No visitor defined for <screenshot>! Skipping.
    No visitor defined for <tbody>! Skipping.
    No visitor defined for <glossdiv>! Skipping.

Quite some parts of the guide are not interpreted correctly and might end up being displayed as code rather than actual portion of text.
