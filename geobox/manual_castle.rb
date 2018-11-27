require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require '../geobox/geobox'
# encoding: utf-8
include Geobox
# \n\| city\d*\s*=\s
# \n\| p\d*\s*=\s
# 
text = <<~TEXT
{{Geobox |building
| name = PAVE Phased Array Warning System
| category = military structures{{r|Hoffacker}}
| image = [[File:PAVE PAWS Cape Cod AFS 1986.jpg|border|400px]]
| image_caption = The [[Cape Cod AFS]] AN/FPS-115 (white structure with circular array) on 1 October 1986 was 1 of 2 while two more FPS-115s were being built.  At the beginning of the [[Cold War]], the [[Cape Cod]] landform had a [[Permanent System radar stations|Permanent System radar station]] (1951 [[North Truro AFS]]), and the offshore [[Texas Tower 2]] was at [[George's Bank]] (closed 1963).
| country_type =
| country = United States
| country_flag = 1
| state_flag = 1
| state_type = Radar stations
| state = Massachusetts
| state1 = California
| state2 = Florida
| state3 = Texas
| location_type = System<br />Sites<br /><br /><br />Scanner<br />Buildings
| location = [[Electronic Systems Division]] System Program Office: {{Coord|42.4626|-71.2753}}  ([[Hanscom Air Force Base|in MA]])
[[Raytheon]] Equipment Division: {{Coord|39.2566|-84.4333}} ([[Wayland, Massachusetts|MA]])<ref>{{cite web |url= http://www.whshistoryproject.org/1950s/missiles.html |title= Cold War Wayland: Raytheon |website= whshistoryproject.org}}</ref>
<br />East Coast: {{Coord|41|45|08|N|70|32|17|W|region:US}} [[Cape Cod Air Force Station|Cape Cod]] ([[6th Space Warning Squadron|6SWS]])
<br />West Coast: {{Coord|39|08|10|N|121|21|03|W|region:US}} [[Beale Air Force Base|CA]] ([[7th Space Warning Squadron|7SWS]])
<br />Southeast: {{Coord|32|34|52|N|83|34|09|W|region:US}} [[Robins Air Force Base|GA]] ([[9th Space Warning Squadron|9SWS]])
<br />Southwest: {{Coord|30.979|N|100.554|W|region:US}} [[Eldorado Air Force Station|TX]] ([[8th Space Warning Squadron|8MWS]])
| author_type = Prime Contractor{{r|HAER}}<br />Software{{r|MiS}}<br />Construction<br />subcontractors
| author = [[Raytheon]] Equipment Division (named April 1977){{r|ADA088323}}<br />[[IBM Federal Systems]]<br />Gilbane Construction Company (MA){{r|HAER}}<br />tbd (CA)<br />tbd (GA)<br />tbd (TX)
| established_type = Ground-breaking<br />Operational<br />Expanded<br />Reduced<br />Replaced
| established = 1976 October 27<br />1980 August 15<br />1984{{r|Hoffacker}}<!--Eldorado ground-breaking April 1984-->-7<br />1995 (GA, TX closed)<br />{{circa|lk=no|1990–2001}}
| footnotes =
}}
TEXT

begin
  text = parse_geobox_to_castle(text).strip
rescue Page::NoTemplatesFound => e
  puts text
  Helper.print_message('Template not found on page')
  exit(1)
# rescue Page::UnresolvedCase => e
#   Helper.print_message('Hit an unresolved case')
#   exit(1)
end

puts text
Clipboard.copy(text)