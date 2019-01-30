require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'generic_character'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{{Infobox character
| color      = #C9A0DC
| name       = “A”
| series     = [[Pretty Little Liars (TV series)|Pretty Little Liars]]
| first      = '''Novel''':<br>''[[Pretty Little Liars (book)|Pretty Little Liars]]'' (2006)<br>'''''':<br>"[[Pilot (Pretty Little Liars)|Pilot]]" (episode 1.01)<ref name=Pilot>{{cite web|title=Pretty Little Liars - Pilot|url=http://abcfamily.go.com/shows/pretty-little-liars/episode-guide/season-01/01-pilot|publisher=ABC Family|accessdate=24 March 2014}}</ref><br>"[[The First Secret]]" (episode 2.13)<br>(chronologically)
| creator    = [[Sara Shepard]]
| alias      = Original A<br>Big A<br>Uber A<br>A-moji<br>A.D.
| lbl21      = Pathology
| data21     = [[Stalker]]<br>[[Spy]]<br>[[Blackmailer]]<br>[[Torturer]]<br>[[Psychological manipulation|Manipulator]]
| lbl22      = [[Modus operandi|M.O.]]
| data22     = Spying targets to discover secrets, [[taunting]] and [[threatening]] their victims via phone
| lbl23      = Location
| data23     = [[Rosewood, Pennsylvania]]
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