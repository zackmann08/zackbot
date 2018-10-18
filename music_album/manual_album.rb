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
{{Infobox album <!-- See Wikipedia:WikiProject_Albums -->
| Name        = Gamma 1
| Last album  = ''[[LAST]]''<br />(1995)
| This album  = '''''Gamma 1'''''<br />(1996)
| Next album  = ''[[Gamma 2]]''<br />(1997)
| Misc        =
{{Extra chronology
   | Artist      = [[Ronnie Montrose]]
   | Type        = studio
   | Last album  = ''[[Open Fire (album)|Open Fire]]''<br />(1978)
   | This album  = '''''Gamma 1'''''<br />(1979)
   | Next album  = ''[[Gamma 2]]''<br />(1980)
  }}
}}
TEXT
#  {{small|(Bootleg)}}

begin
  text = parse_album(text).strip
rescue Page::NoTemplatesFound => e
  puts text
  Helper.print_message('Template not found on page')
  exit(1)
rescue Page::UnresolvedCase => e
  puts text
  Helper.print_message('Hit an unresolved case')
  exit(1)
end

puts text
Clipboard.copy(text)