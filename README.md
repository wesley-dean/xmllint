# xmllint

This will find XML files and run `xmllint` (from libxml2-utils ) on them.

By default, the tool looks for `**/*.xml` (i.e., recursively search for
files with a `.xml` extension) although this may be overridden with the
`PATTERN` variable.

The `ENTRYPOINT` for this tool is a script that searches for files
and runs `xmllint` on them.  Any arguments (i.e., what would be the
`CMD` parameter) are passed to `xmllint`.

Consider:

* **--noout**: don't display working XML
* **--html**: consider the files as HTML; use with `PATTERN=**/*.{htm,html}`

If there are any files that fail the linting, an exit code of `1` is
returned; otherwise (i.e., if there are no files or no files that
have any errors), then an exit code of `0` is returned.

