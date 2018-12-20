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
{{Geobox|Protected Area
<!-- *** Name section *** -->
| name                       = Delaware and Lehigh National Heritage Corridor
| native_name                = 
| other_name                 = 
| other_name1                =
<!-- *** Category *** -->
| category                   = [[National Heritage Area]]
| iucn_category              =
<!-- *** Image *** -->
| image                      = d&l_logo.jpg
| image_caption              = 
| image_alt                  = D & L Trail Logo
| image_size                 = 300
<!-- *** Etymology *** --->
| etymology_type             = 
| etymology                  =
<!-- *** Country etc. *** -->
| country                    = United States
| country_flag               = 1
| state                      = Pennsylvania
| state_flag                 = 1
| region_type                = County
| region                     = [[Luzerne County, Pennsylvania|Luzerne]]
| region1                    = [[Lehigh County, Pennsylvania|Lehigh]]
| region2                    = [[Carbon County, Pennsylvania|Carbon]]
| region3                    = [[Bucks County, Pennsylvania|Bucks]]
| region4                    = [[Northampton County, Pennsylvania|Northampton]]
| district_type              = 
| district                   = 
| district1                  = 
| district2                  = 
| city                       = 
| city1                      =
<!-- *** Geography *** -->  
| location                   = 
| coordinates                = 
| elevation_imperial         = 
| elevation_round            = 1
| area_unit                  = 
| area_imperial              = 
| area_round                 = 1
| area1_imperial             = 
| area1_type                 = 
| length_imperial            = 165
| length_orientation         = North–South
| width_imperial             = 
| width_orientation          = 
| highest_type               = Northern terminus
| highest                    = 
| highest_location           = [[Mountain Top, Pennsylvania|Mountain Top]]
| highest_coordinates        = {{coord|41|10|29|N|75|52|43|W}}
| highest_elevation_imperial = 
| lowest_type                = Southern terminus
| lowest                     = 
| lowest_location            = [[Bristol, Pennsylvania|Bristol]]
| lowest_coordinates         = {{coord|40|06|20|N|74|51|09|W}}
| lowest_elevation_imperial  =
<!-- *** Nature *** -->
| biome                      = 
| biome_share                = 
| biome1                     = 
| biome1_share               = 
| geology                    = 
| geology1                   = 
| plant                      = 
| plant1                     = 
| animal                     = 
| animal1                    =
<!-- *** People *** -->
| established_type           = 
| established                = 1988
| established1_type          = 
| established1               = 
| management_body            = Delaware and Lehigh National Heritage Corridor Commission
| management_location        = [[Easton, Pennsylvania]]
| management_coordinates     = {{coord|40|40.178|N|75|14.1823|W}}
| management_elevation       = 
| visitation                 = 282,796
| visitation_year            = 2012
| visitation_note            = {{sfn|User Survey and Economic Impact Analysis|p=2|ps=}}
<!-- *** Map section *** -->
| map                        = Location of Delaware and Lehigh National Heritage Corridor in Pennsylvania.svg
| map_caption                = Location of Delaware and Lehigh National Heritage Corridor in Pennsylvania
| map_size                   = 300
| pushpin_map                = Pennsylvania
| pushpin_map_caption        = Location of Delaware and Lehigh National Heritage Corridor Commission in Pennsylvania
| pushpin_map_size           = 300
<!-- *** Website *** -->
| website                    = {{URL|http://www.delawareandlehigh.org}}
}}
TEXT

begin
  text = parse_geobox_to_protected_area(text).strip
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