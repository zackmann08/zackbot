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
{{Geobox|River
<!-- *** Heading *** -->
| name = Shoal Creek
| native_name = 
| other_name = 
| category = Creek
<!-- *** Names **** --> 
| etymology = 
| nickname = 
<!-- *** Image *** -->
| image = Shoal Creek.jpg
| image_caption = Shoal Creek from Inspiration Point, near [[Joplin, Missouri]]
| image_size = 
<!-- *** Country *** -->
| country = United States
| state = Missouri
| region = Southwest Missouri - Southeast Kansas
| district = 
| municipality = 
<!-- *** Family *** -->
| parent = 
| tributary_left = 
| tributary_right = 
| city = 
| landmark = 
<!-- *** River locations *** -->
| source = 
| source_location =  Barry County, Missouri
| source_region = 
| source_country = 
| source_elevation = 
| source_coordinates = {{coord|36|38|51|N|93|57|45|W|display=inline}}
| source1 = 
| source1_location = 
| source1_region = 
| source1_country = 
| source1_elevation = 
| source1_coordinates = 
| source_confluence = 
| source_confluence_location = 
| source_confluence_region = 
| source_confluence_country = 
| source_confluence_elevation = 
| source_confluence_coordinates = 
| mouth = [[Spring River (Missouri)|Spring River]]
| mouth_location = Cherokee County, Kansas
| mouth_region = 
| mouth_country = 
| mouth_elevation = 246
| mouth_coordinates = {{Coord|37|03|17|N|94|42|03|W|format=dms|display=inline,title}}
<!-- *** Maps *** -->
| map = 
| map_caption = 
| pushpin_map = 
| pushpin_map_relief = 1
| pushpin_map_caption = 
<!-- *** Website *** --> 
| website = 
| commons = 
<!-- *** Footnotes *** -->
| footnotes = <ref name=gnis>[https://geonames.usgs.gov/apex/f?p=gnispq:3:::NO::P3_FID:729963 GNIS for Shoal Creek]</ref>
}}
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