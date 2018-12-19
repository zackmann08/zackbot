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
{{Infobox college sports rivalry
| name = Big Game
| team1_image = California Golden Bears logo.svg
| team2_image = Stanford Cardinal logo.svg
| team1 = [[California Golden Bears football|California Golden Bears]]
| team2 = [[Stanford Cardinal football|Stanford Cardinal]]
| total_meetings = 121
| series_record = {{Plainlist|class=nowrap|
* Stanford leads, 64–46–11 ({{winning percentage|64|46|11}})
* At Berkeley: Stanford leads, 28–21–6
* At Stanford: Stanford leads, 31–21–1
* At San Francisco: Stanford leads, 5–4–4
* Home vs. visitor: 56–54–11
}} <!--updated through 2018 season-->
| first_meeting_date = March 19, 1892
| first_meeting_result = Stanford 14, California 10 
| last_meeting_date = December 1, 2018
| last_meeting_result = Stanford 23, California 13
| next_meeting_date = November 23, 2019
| largest_win_margin = Stanford, 63–13 (2013)
| longest_win_streak = Stanford, 9 (2010–present)
| current_win_streak = Stanford, 9 (2010–present)
| trophy = [[Stanford Axe]]
| map_location = San Francisco Bay Area
| map_label1 = '''[[Stanford University|Stanford]]'''
| map_label1_position = bottom
| map_mark1 =
| coordinates1 = {{coord|37.434444|-122.161111|display=inline}}
| map_label2 = '''[[University of California, Berkeley|Cal]]'''
| map_label2_position = top
| map_mark2 = Blue pog.svg   
| coordinates2 = {{coord|37.871111|-122.250833|display=inline}}
| map_caption = Locations of the two universities in the [[San Francisco Bay Area|Bay Area]]
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