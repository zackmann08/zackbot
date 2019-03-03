require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'reality'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{{Infobox television Amazing Race
| show_name = Amazing Race
| caption = 
| image = Amazing Race France logo.jpg
| first_aired = {{start date|2012|10|22|df=yes}}
| last_aired ={{start date|2012|12|24|df=yes}}
| num_episodes = 10
| presenter = [[Alexandre Delpérier]]
| filming_started = {{start date|2012|06|30|df=yes}}
| filming_ended = {{end date|2012|07|23|df=yes}}
| countries_visited = 7
| continents_visited = 5
| cities_visited = 18
| winning_team = Anthony Martinage & Sonja Sacha
| km_traveled = 50000
| number_legs = 10
| prev_season = 
| next_season = 
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