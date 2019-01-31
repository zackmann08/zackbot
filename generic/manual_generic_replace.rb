require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'generic'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{{Infobox CFL Draft
| year          = 2019 LFA –
| image         = File:2019 CFL-LFA Draft logo.png
| imagesize     = 200px
| caption       = 
| date          = January 14, 2019<ref name="Sun1">{{cite news|url=https://torontosun.com/sports/football/cfl/fun-element-cfl-set-for-inaugural-draft-of-mexican-talent|title='FUN ELEMENT': CFL set for inaugural draft of Mexican talent|author=Dan Barnes|date=January 11, 2019}}</ref>
| time          = 10:00 am [[Central Time Zone|CST]]
| location      = [[Mexico City]]
| network       = 
| first         = [[Diego Jair Viamontes Cotera]], WR<br>[[Edmonton Eskimos]]
| most          = All teams (3)
| fewest        = All teams (3)
| U Sports      = 
| NCAA          = 
| overall       = 27
}}

TEXT

begin
  text = parse_text(text).strip
rescue Page::NoTemplatesFound => e
  puts text
  Helper.print_message('Template not found on page')
  exit(1)
# rescue Page::UnresolvedCase => e
#   Helper.print_message(e)
#   Helper.print_message('Hit an unresolved case')
#   exit(1)
end

puts text
Clipboard.copy(text)