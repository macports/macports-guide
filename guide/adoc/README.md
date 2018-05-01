# AsciiDoc version of the guide

This is a work-in-progress attempt to convert the guide from DocBook to AsciiDoc.

The conversion has originally been done with [docbookrx](https://github.com/asciidoctor/docbookrx).
To handle all elements and special tweaks specific to the MacPorts guide, a [patched version of docbookrx](https://github.com/raimue/docbookrx/tree/macports-guide) is required for the conversion.

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

## TODO

### Incorrectly converted

List of things that are incorrectly converted by docbookrx. These should be
fixed in docbookrx as they either lose information or affect a lot of
locations in the sources.

* Missing distinction between `<programlisting><prompt></><userinput></></>`, `<screen>`, and `<programlisting>`
  They all result in similar [source] blocks at the moment. Based on how they
  are used in the guide, we should keep the semantics by adding style
  attributes to AsciiDoc.

      [cmd]
      ----
      $ Commands to be typed into a terminal window.
      ----

      [output]
      ----
      Command output to a terminal window.
      ----

      [source]
      ----
      File text.
      ----

* `<option>foo</option>` produces `[option]``foo`` `
  This also applies to `<replaceable>`, `<path>`, or `<var>` among others.
  It seems overly verbose and unnecessary in most places.
  Backticks alone should be enough, unless we want to apply a specific style to
  any of these.

### Postprocessing

List of things that need to be fixed manually after running the conversion
with docbookrx:

* Fix book title
  Suppress rendering of "MacPorts" in "MacPorts Guide".

* Fix authors
  Or just remove them, as this list is not exhaustive anyway.

* Fix nested tables in project.adoc
  docbookrx does not convert nested tables correctly (look for <tbody>).
  However, nested tables are in fact supported by AsciiDoc, so this can be
  rescued with manual work.

* Rewrite internals-hier.adoc
  None of the original hierarchy could be converted. Rewrite this section
  in AsciiDoc (and maybe also merge it with porthier.7 in base?).

* Rewrite glossary manually or remove it
  docbookrx does not know about `<glossdiv>`. The glossary only contains
  two entries, so the usefulness in its current form is doubtful.

* Fix leveloffsets in portfileref.adoc
  Sometimes our includes start a new section and sometimes they contain
  content for the same level. There is no way for docbookrx to guess
  that correctly, so it needs to be fixed manually.
