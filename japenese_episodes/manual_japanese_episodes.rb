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

{{Japanese episode list
 |EpisodeNumber=2
 |EpisodeNumber2=
 |EnglishTitle=WIRED PRISONER
 |RomajiTitle=Wired Prisφner
 |KanjiTitle=
 |OriginalAirDate={{Start date|2011|2|25}} (sale date)
 |ShortSummary=
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