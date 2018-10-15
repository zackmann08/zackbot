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
| Name       = FabricLive.68
| Type       = Compilation
| Misc        = 
{{Extra chronology
  | Artist = [[Fabric discography|FabricLive]] 
  | Type = Compilation
  | Last album = ''[[FabricLive.67]]''<br/>(2013)
  | This album = '''FabricLive.68'''<br/>(2013)
  | Next album = ''[[FabricLive.69]]''<br/>(2013)}}
}}
TEXT


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