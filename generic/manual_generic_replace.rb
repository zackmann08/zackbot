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
{{Infobox themed area
| name         = Tomorrowland
| logo         = Tomorrowland logo.svg
| logo_width   = 
| image        = DL tomorrowland entrance at night.jpg
| image_width  = 250px
| caption      = Disneyland's Tomorrowland at Night 
| theme        = [[Future]] and [[outer space]]
| park         = [[Disneyland]]
| coordinates  = 
| status       = Operating
| opened       = July 17, 1955
|
| replaced     = 
| replacement  = 
| park2        = [[Magic Kingdom]]
| coordinates2 = 
| status2      = Operating
| opened2      = October 1, 1971
| closed2      = 
| replaced2    = 
| replacement2 = 
| park3        = [[Tokyo Disneyland]]
| coordinates3 = 
| status3      = Operating
| opened3      = April 15, 1983
| closed3      = 
| replaced3    = 
| replacement3 = 
| park4        = [[Disneyland Park (Paris)]]
| coordinates4 = 
| status4      = Operating (as Discoveryland)
| opened4      = April 12, 1992
| closed4      = 
| replaced4    = 
| replacement4 = 
| park5        = [[Hong Kong Disneyland]]
| coordinates5 = 
| status5      = Operating
| opened5      = September 12, 2005
| closed5      = 
| replaced5    = 
| replacement5 = 
| park6        = [[Shanghai Disneyland Park]]
| coordinates6 = 
| status6      = Operating
| opened6      = June 16, 2016
| closed6      = 
| replaced6    = 
| replacement6 = 
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