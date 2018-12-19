# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'
text = <<~TEXT
type | Type | EP | writer | Writer | title2 | tracks | Tracks | recorded | Recorded | length | Length | prev_track | prev | next_track | next | prev_no | track_no | next_no | chronology | Chronology | name | Name | title | image | cover | Cover | cover_size | cover size | Cover size | cover_upright | alt | Alt | border | Border | caption | Caption | artist | Artist | original_artist | album | Album | from_album | from Album | language | Language | English_title | english_title | A-side | a-side | B-side | b-side | written | Written | published | Published | released | Released | format | Format | studio | Studio | venue | Venue | genre | Genre | label | Label | composer | Composer | lyricist | Lyricist | producer | Producer | prev_title | next_title | prev_single | next_single | __µ | prev_title2 | prev_year | next_year | year | next_title2 | misc | Misc | Last single | last_single | This single | this_single | Next single  
TEXT

text.strip!
text+='|' unless text.end_with?('|')
text.gsub!(/\s*([\s\w\-\/]*)\|/, "| \\1 = \\1\n")
puts text
Clipboard.copy(text)
