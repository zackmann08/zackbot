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
{{IACGMOOH contestants
| hmpage =
| seriesname = 71 Degrees North
| image =
| series = Series Two (2011)
| previous =
| next =
| hm3 = Amy
| hm3-exit = Episode 8
| hm3-enter = Episode 1
| hm3-stat = evic
| hm2 = Angelica
| hm2-exit = Episode 8
| hm2-enter = Episode 1
| hm2-stat = runner
| hm1 = Rav
| hm1-exit = Episode 8
| hm1-enter = Episode 1
| hm1-stat = winner
| hm4 = Brooke
| hm4-exit = Episode 7
| hm4-enter = Episode 1
| hm4-stat = evic
| hm5 = Richard
| hm5-exit = Episode 6
| hm5-enter = Episode 3
| hm5-stat =evic
| hm6 = John
| hm6-exit = Episode 4<br />Episode 5
| hm6-enter = Episode 3<br />Episode 5
| hm6-stat = evic
| hm7 = Charlie
| hm7-exit = Episode 5
| hm7-enter = Episode 1
| hm7-stat = five
| hm8 = Lisa
| hm8-exit = Episode 3
| hm8-enter = Episode 1
| hm8-stat = evic
| hm9 = Martin
| hm9-exit = Episode 3
| hm9-enter = Episode 1
| hm9-stat = five
| hm10 = John
| hm10-exit = Episode 2
| hm10-enter = Episode 1
| hm10-stat = evic
| hm11 = Sean
| hm11-exit = Episode 2
| hm11-enter = Episode 1
| hm11-stat = five
| hm12 = Nicky
| hm12-exit = Episode 1
| hm12-enter = Episode 1
| hm12-stat =  evic
| legend5 = Withdrew
| legend6 = Third
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