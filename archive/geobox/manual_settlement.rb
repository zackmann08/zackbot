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
{{Geobox
| Settlement
<!-- *** Name section *** -->
| name                        = Woodmere, Louisiana
| native_name                 = 
| other_name                  = 
| other_name1                 = 
| category                    = [[Census-designated place]]
<!-- *** Image *** -->
| image                       = 
| image_size                  =    
| image_caption               = 
<!-- *** Symbols *** -->
| flag                        = 
| flag_size                   =    
| symbol                      = 
| symbol_size                 = 
| symbol_type                 = 
<!-- *** Country etc. *** -->
| country                     = United States
| state                       = Louisiana
| region                      = [[Jefferson Parish, Louisiana|Jefferson]]
| region_type                 = Parish
<!-- *** Geography *** -->
| area_imperial               = 3.84
| area_land_imperial          = 3.65
| area_water_imperial         = 0.19
| area_water_percentage       = auto
| area_percentage_round       = 2
| area_round                  = 1
| location                    =
| coordinates                 = {{coord|29|51|27|N|90|04|41|W|display=inline,title}}
| capital_coordinates         = 
| mouth_coordinates           = 
| elevation_imperial          =
<!-- *** Population *** -->
| population_as_of            = 2010
| population                  = 12080
| population_density_imperial = 3308.2
| population_density_round    = 1
<!-- *** Government *** -->
| established_type            = 
| established                 = 
| mayor                       = 
<!-- *** Various codes *** -->
| timezone                    = [[North American Central Time Zone|CST]]
| utc_offset                  = -6
| timezone_DST                = [[North American Central Time Zone|CDT]]
| utc_offset_DST              = -5
| postal_code                 = [[ZIP Code]]
| postal_code_type            = 70058
| area_code                   = [[Area code 504|504]]
| area_code_type              =  
| code2_type                  = [[FIPS code]]
| code2                       = 22-83002
<!-- *** Free fields *** -->
| free_type                   = [[GNIS]] feature ID
| free                        = 1852438
| free1_type                  =  
| free1                       = 
<!-- *** Map section *** -->
| map                         = Louisiana Locator Map.PNG
| map_size                    = 
| map_caption                 = Location of Woodmere in Louisiana
| map_locator                 = Louisiana
| map1                        = Map of USA LA.svg
| map1_caption                = Location of Louisiana in the United States
<!-- *** Website *** -->
| website                     = 
}}

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