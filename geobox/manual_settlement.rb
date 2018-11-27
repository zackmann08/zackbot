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
{{Geobox | Building
<!-- *** Heading *** -->
| name = Spišská Kapitula
| other_name = 
| category = Ecclesiastical Town
<!-- *** Image *** -->
| image = Szepesváralja - Castle.jpg
| image_caption = View of Spišská Kapitula from above
<!-- *** Name *** -->
| etymology = 
| official_name = 
| nickname = 
<!-- *** Country etc. *** -->
| country = Slovakia
| country_flag = 1
| state = 
| region = [[Prešov Region|Prešov]]
| district = [[Levoča District|Levoča]]
| commune = 
| municipality = Spišské Podhradie
<!-- *** Family *** -->
| parent = 
| city = 
| landmark = 
| river = 
<!-- *** Locations *** -->
| location = 
| elevation = 
| coordinates = {{coord|49|00|N|20|45|E|display=inline,title}}
| mouth_coordinates = 
| length = 
| width = 
| height = 
| number = 
| area = 
<!-- *** Features *** -->
| author = 
| style = 
| material = 
<!-- *** History & management *** -->
| established = 
| management = 
| owner = 
<!-- *** Acess *** -->
| public = 
| access = 
<!-- *** Codes *** -->
| code = 
<!-- *** UNESCO etc. *** -->
| whs_name = Levoča, Spiš Castle and the associated cultural  monuments
| whs_year = 1993
| whs_number = 620
| whs_region = [[List of World Heritage Sites in Europe|Europe and North America]]
| whs_criteria = iv
<!-- *** Maps *** -->
| pushpin_map = Slovakia Prešov Region (West)#Slovakia
| pushpin_map_relief = 1
| pushpin_map_caption = Location of Spišská Kapitula in the Western part of the Prešov Region
<!-- *** Websites *** -->
| commons = 
| statistics = 
| website = 
<!-- *** Footnotes *** -->
| footnotes = 
<!-- Processed by Geoboxer 3.0 on 2007-11-05T22:04:00+01:00 --> }}
TEXT

begin
  text = parse_geobox_to_settlement(text).strip
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