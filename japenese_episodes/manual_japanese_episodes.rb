require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'japanese_episodes'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{| class="wikitable" style="width:98%;"
|-
! style="width: 4%;" | No.
! Episode title
! style="width: 20%;" | Original air date
|-
{{Japanese episode list
| EpisodeNumber   = 1
| EnglishTitle    = Encounter
| OriginalAirDate = {{Start date|2001|10|4}}
}}
{{Japanese episode list
| EpisodeNumber   = 2
| EnglishTitle    = Farewell
| OriginalAirDate = {{Start date|2001|10|4}}
}}
{{Japanese episode list
| EpisodeNumber   = 3
| EnglishTitle    = Notice
| OriginalAirDate = {{Start date|2001|11|3}}
}}
{{Japanese episode list
| EpisodeNumber   = 4
| EnglishTitle    = Presence
| OriginalAirDate = {{Start date|2001|11|3}}
}}
|}

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