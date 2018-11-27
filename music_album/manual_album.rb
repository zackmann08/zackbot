require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require './album'
# encoding: utf-8
include Album

text = <<~TEXT
{{Infobox single <!-- See Wikipedia:WikiProject_Songs -->
| Name           = 'Coz I'm Free
| Cover          = 'Coz_I'm_Free_by_Christine_Anu.jpg
| Caption        = CD single cover
| Artist         = [[Christine Anu]]
| from Album     = '''[[Come My Way (Christine Anu album)|Come My Way]]''' 
| A-side         = "'Coz I'm Free"
| B-side         = 
| Released       = April 2001
| Format         = [[CD Single]]
| Recorded       = Megaphon Studios, Sydney, 2000
| Genre          = [[Pop music|Pop]]
| Length         = 3:56
| Label          = [[Mushroom Records]]
| Writer         = [[Christine Anu]], [[Stuart Crichton]], [[Andy White (singer-songwriter)|Andy White]]
| Producer       = Stuart Crichton
| Certification  = 
| Chronology     = [[Christine Anu]] singles
| Last single    = "[[Jump to Love]]" <br>(2000)
| This single    = "''''Coz I'm Free'''" <br>(2001)
| Next single    = "[[Talk About Love]]" <br>(2003)
| Misc           = 
}}

TEXT
#  {{small|(Bootleg)}}

begin
  text = parse_album(text).strip
rescue Page::NoTemplatesFound => e
  puts text
  Helper.print_message('Template not found on page')
  exit(1)
# rescue Page::UnresolvedCase => e
#   puts text
#   Helper.print_message('Hit an unresolved case')
#   exit(1)
end

puts text
Clipboard.copy(text)