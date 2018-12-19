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
{{Infobox single
| Name           = Flag Day
| Cover          = 
| Artist         = [[The Housemartins]]
| from Album     = [[London 0 Hull 4]]
| Released       = 1985
| Format         = 
| Recorded       = 1985
| Genre          = [[Indie rock]]
| Length         = 5:24
| Label          = Go Disc!
| Writer         = Paul Heaton, Stan Cullimore, Ted Key
| Producer       = 
| Certification  = 
| Last single    = 
| This single    = "'''Flag Day'''"
| Next single    = "[[Sheep (The Housemartins song)|Sheep]]"
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