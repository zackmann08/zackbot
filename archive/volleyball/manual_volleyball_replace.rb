require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'volleyball'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{{volleyballbox
|bg         = {{{bgc}}}
|date       = {{dts|format={{{df|mdy}}}|2012|9|7}}
|time       = 21:00 <br /> {{navbar|mini=1|template=2012 Summer Paralympics women's volleyball game F2}}
|team1      = {{flagIPC-rt|USA|2012 Summer}}
|team2      = '''{{flagIPC|CHN|2012 Summer}}'''
|score      = 1 – '''3'''
|set1       = '''25'''<br />15<br />30<br />15<br />85
|set        = Set 1 <br /> Set 2 <br /> Set 3 <br /> Set 4 <br /> Total
|set2       = 22<br />'''25'''<br />'''32'''<br />'''25'''<br />'''104'''
|stadium    = [[ExCeL London]], [[London]]
|attendance = 
|referee    = Janko Plesnik (SLO), Ute Fischer (GER)
|report     = [http://www.london2012.com/paralympics/sitting-volleyball/event/women/match=vsw400101/index.html Report]
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