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
{{Use dmy dates|date=January 2014}}
{{Use Australian English|date=January 2014}}
{{Geobox|River
<!-- *** Heading *** -->
| name = Yeerung
| native_name = 
| other_name = Yerung<ref name=vicnames/>
| other_name1 = 
| other_name2 = 
| category = [[Perennial stream|River]]<ref name=vicnames>{{cite web|url=https://services.land.vic.gov.au/vicnames/place.html?method=edit&id=30256|title=Yeerung River: 30256|work=Vicnames|publisher=[[Government of Victoria (Australia)|Government of Victoria]] |date=2 May 1966|accessdate=11 January 2014}}</ref>
<!-- *** Names **** --> 
| etymology = 
| nickname =
<!-- *** Image *** -->
| image = 
| image_caption = 
| image_size =
<!-- *** Country *** -->
| country = Australia
| state_type = [[States and territories of Australia|State]]
| state = [[Victoria (Australia)|Victoria]] 
| state1 = 
| region = [[South East Corner]] ([[Interim Biogeographic Regionalisation for Australia|IBRA]])
| region1 = [[East Gippsland]]
| region2 = 
| district = 
| district1 = 
| district2 = 
| municipality_type = [[Local government in Australia|LGA]]
| municipality = [[Shire of East Gippsland]]
| municipality1 = 
| municipality2 =
<!-- *** Family *** -->
| parent = 
| tributary_left = 
| tributary_left1 = 
| tributary_left2 = 
| tributary_left3 = 
| tributary_right = 
| tributary_right1 = 
| tributary_right2 = 
| tributary_right3 = 
| tributary_right4 = 
| tributary_right5 = 
| city_type = [[Town]]
| city = 
| landmark =
<!-- *** River locations *** -->
| source = Confluence of West Branch and East Branch of the Yeerung River 
| source_location = [[Cape Conran Coastal Park]]
| source_region = 
| source_country = 
| source_elevation = 36
| source_coordinates = 
| source1 = 
| source1_location = 
| source1_region = 
| source1_country = 
| source1_elevation = 
| source1_coordinates = 
| source_confluence = 
| source_confluence_location 
| source_confluence_region = 
| source_confluence_country = 
| source_confluence_elevation = 
| source_confluence_coordinates = 
| mouth = [[Bass Strait]]
| mouth_location = [[Cape Conran Coastal Park]]
| mouth_region = 
| mouth_country = 
| mouth_elevation = 0
| mouth_coordinates = {{coord|37|47|28|S|148|46|37|E|display=inline,title}}
<!-- *** Dimensions *** -->
| length = 3
| width = 
| depth = 
| volume = 
| watershed = 
| area = 
| discharge = 
| discharge_location = 
| discharge_max = 
| discharge_min =
<!-- *** Free fields *** -->
| free = [[Cape Conran Coastal Park|Cape Conran CP]]
| free_type = [[National park]]
| free1 = 
| free1_type = [[Reservoir (water)|Reservoir]]
| free2 = 
| free2_type = [[Waterfall]]
| free3 = 
| free3_type = [[Nature reserve]]
<!-- *** Maps *** -->
| pushpin_map = Australia Victoria
| pushpin_map_relief = 1
| pushpin_map_caption = [[Mouth (river)|Mouth]] of the Yeerung River in [[Victoria (Australia)|Victoria]]
<!-- *** Website *** --> 
| website = 
| commons =
<!-- *** Footnotes *** -->
| footnotes = <ref name=vicnames/><ref name=bonzle>{{cite web|url=http://www.bonzle.com/c/a?a=p&p=195891&cmd=sp|title=Map of Yeerung River, VIC|work=Bonzle Digital Atlas of Australia|accessdate=11 January 2014}}</ref>
}}
The '''Yeerung River''' is a [[perennial stream|perennial river]] located in the [[East Gippsland]] region of the [[Australia]]n state of [[Victoria (Australia)|Victoria]].

==Course and features==
Formed by the [[confluence]] of the Yeerung River West Branch and the Yeerung River East Branch, the Yeerung River rises in the [[Cape Conran Coastal Park]], and flows generally south before reaching its [[Mouth (river)|mouth]] with [[Bass Strait]], east of [[Cape Conran]] in the [[Shire of East Gippsland]]. The river descends {{convert|36|m}} over its {{convert|3|km|adj=on}} [[watercourse|course]].<ref name=bonzle/>

The west branch of the river rises near the locality of Bellbird Creek at the junction of the [[Princes Highway#Victoria|Princes Highway]] and Sydneham Inlet Road, with a southerly course of {{convert|12|km}};<ref>{{cite web|url=http://www.bonzle.com/c/a?a=p&p=198766&cmd=sp|title=Map of Yeerung River West Branch, VIC|work=Bonzle Digital Atlas of Australia|accessdate=11 January 2014}}</ref> while the east branch of the river rises west of the Sydneham Inlet Road, with a south westerly course of {{convert|11|km}}.<ref>{{cite web|url=http://www.bonzle.com/c/a?a=p&p=197909&cmd=sp|title=Map of Yeerung River East Branch, VIC|work=Bonzle Digital Atlas of Australia|accessdate=11 January 2014}}</ref>

The Yeerung River sub-catchment area is managed by the [[East Gippsland Catchment Management Authority]].

==See also==
{{stack|{{portal|Victoria}}}}
* [[List of rivers of Australia]]

==References==
{{reflist}}

==External links==
* {{cite web |url=http://www.egcma.com.au/rivers/170/ |title=Bemm River sub-catchment |work=[[East Gippsland Catchment Management Authority]] |publisher=[[Government of Victoria (Australia)|Government of Victoria]]}}
* {{cite web |url=http://www.egcma.com.au/rivers/271/ |title=Bemm River - Catchment Map |work=[[East Gippsland Catchment Management Authority]] |publisher=[[Government of Victoria (Australia)|Government of Victoria]] |format=map}}
* {{cite book |url=http://www.egcma.com.au/file/file/East%20Gippsland%20Regional%20Catchment%20Strategy%202013-2019.pdf |format=PDF |title=East Gippsland regional catchment strategy 2013 -2019 |publisher=[[East Gippsland Catchment Management Authority]] |author=East Gippsland Catchment Management Authority |isbn=978-0-9758164-6-2 |location=Bairnsdale |year=2013 }}

{{Rivers of the East Gippsland catchment |state=autocollapse}}
{{Rivers of Victoria |state=autocollapse}}

[[Category:Rivers of Victoria (Australia)]]
[[Category:East Gippsland]]


{{Gippsland-geo-stub}}
{{VictoriaAU-river-stub}}

TEXT

begin
  text = parse_geobox_to_river(text).strip
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