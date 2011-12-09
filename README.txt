= GrokItunes

* http://rubyforge.org/projects/uwruby
* http://uwruby.rubyforge.org/grok-itunes/

== DESCRIPTION:

* A regex based parser that processes the ITunes Music Library.xml file and generates a sqlite3 database for additional data mining. Also generates treemaps from data parsed.

== FEATURES/PROBLEMS:

* NOTE: I don't use the RMagick dependencies in Treemap
* TODO: Adding GnuPlot support in on the radar
* TODO: Autocolorize treemap html files
* TODO: Add md5sum signatures to parser ( smart updating of sqlite3 db )
* TODO: Smart duplicate track detection
* TODO: Genre out of sync analysis ( album has multuple genres )
* TODO: Missing file analysis
* TODO: Disk usage per top-level library directories
* TODO: Become a better meta-programmer and consolidate SQL queries proper

== SYNOPSIS:

#!/usr/bin/env ruby -w

require 'rubygems'
require 'grok-itunes'
require 'pp'

grok = GrokITunes.new("~/Music/iTunes/iTunes Music Library.xml")

grok.parse_xml
grok.init_db
grok.populate_db

tracks_never_played = grok.never_played
pp tracks_never_played

grok.bitrate_histogram
# if Mac OS X
`open /tmp/bitrate_treemap.html`

== REQUIREMENTS:

* ftools
* time
* rubygems >= 1.3.1
* sqlite3-ruby >= 1.2.4
* scrobbler >= 0.2.1
* ruby-treemap >= 0.0.3

== INSTALL:

* sudo gem install grok-itunes

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
