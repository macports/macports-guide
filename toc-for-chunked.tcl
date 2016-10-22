# Adds the table of contents to every file of the chunked documentation.


# Get the table of contents from the index.html file and create the
# replacement string.
set file [open "[lindex $argv 0]/index.html"]
regexp {<div class="toc">.+?</div>} [read $file] replacement
close $file
set replacement "<body\\1><div class=\"book\">$replacement"

# Add the table of contents to all other html files.
foreach path [glob -directory [lindex $argv 0] {*.html}] {
    if {[file tail $path] == "index.html"} {
        continue
    }

    set file [open $path r+]
    set data [read $file]
    regsub {<body([^>]+)>} $data [regsub -all {\W} $replacement {\\&}] data
    regsub {</body>} $data {</div></body>} data
    seek $file 0
    puts $file $data
    close $file
}
