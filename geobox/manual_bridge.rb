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
{{Geobox|Building
<!-- *** Heading *** -->
| name = Kapellbrücke
| other_name = Chapel Bridge
| category = Covered Wooden Footbridge
<!-- *** Image *** -->
| image = Kapellbruecke.JPG
| image_size = 265px
| image_caption = The Kapellbrücke in [[Lucerne]] with its Wasserturm (water tower) seen in the middle.
<!-- *** Names **** -->
| etymology = Named after St. Peter's Chapel.<ref name=luzern>{{cite web |title=Chapel Bridge |url=http://www.luzern.com/en/navpage-CityExperienceLU-SightseeingLU-71745.html |work=Official Website of Lucerne Tourism |publisher=Luzern Tourismus AG |accessdate=8 July 2011}}</ref> 
<!-- *** Country *** -->
| country = Switzerland
| region = Lucerne
| region_type = Canton
| municipality = [[Lucerne]]
<!-- *** Family *** -->
| river = [[Reuss (river)|Reuss]]
<!-- *** Locations *** -->
| elevation = 436
| coordinates = {{coord|47|03|06|N|8|18|27|E|display=inline,title}}
| capital_coordinates = 
| mouth_coordinates = 
| length = 204.7 | length_orientation = north-south
| width = | width_orientation = east-west
<!-- *** History & management *** -->
| established_type = Built
| established = 1333
| established1_type = Partially destroyed by fire
| established1 = August 18, 1993
| established2_type = Rebuilt
| established2 = April 14, 1994
}}
TEXT

begin
  text = parse_geobox_to_bridge(text).strip
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