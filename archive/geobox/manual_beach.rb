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
{{Geobox|Beach
| name = Narragansett Town Beach
| category =  [[List of Rhode Island state parks|Rhode Island State Park]]
| image = North Pavilion - Narragansett Beach.jpg
| image_caption = A view of the North Pavilion of the Narragansett, RI beach in winter.
| country = {{flag|United States}}
| state = {{flag|Rhode Island}}
| region_type = County
| region = [[Washington County, Rhode Island|Washington]]
| district_type = Town
| district = [[Narragansett, Rhode Island|Narragansett]]
| location = 
| elevation_imperial = 
| elevation_round = 
| elevation_note = 
| coordinates = {{coord|41|26|13|N|71|27|11.39|W|display=inline,title}}
| coordinates_note = 
| area_unit = acre
| area_imperial = 19 
| area_round = 0
| area_note = <ref name=rigov/>
| established_type = Established
| established = March 24, 1939
| management_body = Narragansett Parks and Recreation Department
| map_locator = Rhode Island
| map = Rhode Island Locator Map.PNG
| map_caption = Location in Rhode Island
| website = [https://www.narragansettri.gov/323/Narragansett-Town-Beach Narragansett Town Beach]
}}

'''Narragansett Town Beach''' is a public recreation area encompassing {{convert|19|acre}} on the eastern edge of the [[New England town|town]] of [[Narragansett, Rhode Island|Narragansett]], [[Rhode Island]], and south of the western passage that connects the Narragansett Bay to the open waters of Rhode Island Sound.<ref name=rigov/><ref name=replenproj/> The southern shoreline is rocky with a concrete sea wall constructed upland, while the northeast end of the beach is characterized by the entrance to Narrow River and Cormorant Point.<ref name=replenproj/>

The [[state park|state beach]] offers picnicking, ocean swimming, changing rooms, surfing, and beach activities for approximately the first half mile of the beach, while the northeast end remains privately owned.<ref name=rigov/><ref name=replenproj/> The beach and dunes provide an important wildlife habitat for certain species of shorebirds, including [[piping plover]]s.<ref name=replenproj/><ref name=independent/>

==History==
[[File:Narragansett Beach, with some bathers, by L. H. Clarke.jpg|thumb|Narragansett Beach, with some bathers, by L. H. Clarke]]
The town of Narragansett acquired the privately owned beach area, with the exception of the Dunes Club at the north end of the beach, in the aftermath of the Great Hurricane of 1938 - with the town recommending ownership of the beach on Jan 13, 1939. This was followed by a unanimous vote by 250 participants to acquire and operate the beach on March 24, 1939.<ref name=histsoc/><ref name=briefhistory/> Advertisement of the beach to the public began on June 2, 1939, and generated revenues of approximately $14,000 in 1940.<ref name=histsoc/> By the 1960s, the beach drew approximately 130,000 annual visitors, creating a hub for the local economy.<ref name=pubworks/> By 2011, the beach has become the destination for as many as 10,000 visitors per day, with an average annual net income of approximately $270,000.<ref name=rigov/><ref name=replenproj/>

On July 23, 1947, the Chamber of Commerce endorsed the construction of breakwaters at each end of the beachfront, with the Narragansett Planning board recommending the construction of a 750-foot jetty to be constructed on the southern end of the beach, on March 11, 1949, to address erosion issues - an ongoing and historic issue for the beach.<ref name=histsoc/><ref name=replenproj/>

==References==
{{reflist|refs=

<ref name=histsoc>{{cite web |url=http://www.narragansetthistoricalsociety.com/wp-content/uploads/Combined-Documents_Rev-3_27_17.pdf |title=History of Narragansett, RI from 1800-1999: A Chronology of Major Events |publisher=Narragansett Historical Society |accessdate=July 24, 2018}}</ref>

<ref name=rigov>{{cite web |url=https://www.narragansettri.gov/323/Narragansett-Town-Beach |title=Narragansett Town Beach |publisher=Town of Narragansett, RI |accessdate=July 24, 2018}}</ref>

<ref name=briefhistory>{{cite web |url=http://www.narragansetthistoricalsociety.com/a-brief-history/ |title=Early History of Narragansett |publisher=Narragansett Historical Society |accessdate=July 24, 2018}}</ref>

<ref name=pubworks>{{cite web |url=https://books.google.com/books?id=0Xw0AAAAIAAJ&q= |title=Public Works Appropriations for 1966, Volume 2; Volume 12 |publisher=U.S. Government Printing Office (1965) |accessdate=July 24, 2018}}</ref>

<ref name=replenproj>{{cite web |url=https://www.narragansettri.gov/DocumentCenter/View/782/Narragansett_Report_v2?bidId= |title=Narragansett Town Beach Replenishment Feasibility Project |publisher=Woods Hole Group, Inc. (September 2011) |accessdate=July 24, 2018}}</ref>

<ref name=independent>{{cite web |url=http://www.independentri.com/independents/south_county/narragansett/article_028afee8-f89e-5637-81ce-3ee0bf89f29c.html |title=Narragansett needs piping plover plan |publisher=The Independent (March 2013) |accessdate=July 24, 2018}}</ref>

}}

[[Category:Narragansett, Rhode Island| ]]
[[Category:Narragansett Bay]]
[[Category:Beaches of Rhode Island]]
[[Category:1939 establishments in Rhode Island]]
[[Category:Beaches of Washington County, Rhode Island]]

TEXT

begin
  text = parse_geobox_to_beach(text).strip
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