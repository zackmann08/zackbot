require 'Clipboard'
require '../helper'

def print_message(message)
  puts "\t#{message}"
end

string = <<~TEXT
{{Geobox|River
| name = Chesapeake Bay
| native_name =
| other_name =
| category = Estuary
| etymology = ''Chesepiooc'', [[Algonquian languages|Algonquian]] for village "at a big river"
| nickname =
| image = Chesapeakelandsat.jpeg
| image_caption = The Chesapeake Bay – [[Landsat]] photo
| image_size = 250
| country = United States
| state = Maryland
| state1 = Virginia
| region =
| district =
| municipality =
| parent =
| tributary_right = Patapsco River
| tributary_left = Chester River
| tributary_left1 = Choptank River
| tributary_right1 = Patuxent River
| tributary_left2 = Nanticoke River
| tributary_right2 = Potomac River
| tributary_left3 = Pocomoke River
| tributary_right3 = Rappahannock River
| tributary_right4 = [[York River (Virginia)|York River]]
| tributary_right5 = James River
| city = [[Baltimore, Maryland]]
| city1 = [[Annapolis, Maryland]]
| city2 = [[Washington, DC]]
| city3 = [[Norfolk, Virginia]]
| landmark =
| river =
| source = [[Susquehanna River]] mouth
| source_location = east of [[Havre de Grace, Maryland|Havre de Grace, MD]] | source_region = | source_country =
| source_elevation_imperial = 0
| source_coordinates = {{coord|39|32|35|N|76|04|32|W|display=inline}}
| source1 =
| source1_location = | source1_region = | source1_country =
| source1_elevation_imperial =
| source_confluence =
| source_confluence_location = | source_confluence_region = | source_confluence_country =
| source_confluence_elevation_imperial =
| mouth = Atlantic Ocean
| mouth_location = north of [[Virginia Beach, Virginia|Virginia Beach, VA]] | mouth_region = | mouth_country =
| mouth_elevation_imperial = 0
| capital_coordinates = 
| mouth_coordinates = {{coord|36|59|45|N|75|57|34|W|display=inline,title}}
| length_imperial = 200 | length_orientation =
| width_imperial = 30 | width_orientation =
| area_imperial = 4479
| depth_imperial = 21
| volume_imperial =
| watershed_imperial = 64299
| discharge_imperial = 78300
| discharge_note = <ref>{{cite web|url=http://md.water.usgs.gov/waterdata/chesinflow/|title=Estimated Streamflow Entering Chesapeake Bay|publisher=U.S. Geological Survey|work=ME-DE-DC Water Science Center|date=2011-05-05|accessdate=2011-05-06}}</ref>
| discharge_max_imperial = 389000
| discharge_min_imperial = 9800
| free = {{Designation list
| embed = yes
| designation1 = Ramsar
| designation1_offname = Chesapeake Bay Estuarine Complex
| designation1_date = 4 June 1987
| designation1_number = 375<ref>{{Cite web|title=Chesapeake Bay Estuarine Complex|website=[[Ramsar Convention|Ramsar]] Sites Information Service|url=https://rsis.ramsar.org/ris/375|accessdate=25 April 2018}}</ref>}}
| free_type = Protection status
| map = Chesapeakewatershedmap.png
| map_caption = Chesapeake Bay Watershed
| map_background =
| map_locator =
| map_locator_x =
| map_locator_y =
| website =
| commons =
| footnotes = 
}}

TEXT

# parent = string.match(/parent\s*=\s*(.*)/)[1]
name = string.match(/name\s*=\s*(.*)/)[1]
# elevation = string.match(/elevation\s*=\s*([\.\d]*)/)[1]
# length = string.match(/length\s*=\s*([\.\d]*)/)[1]
# width = string.match(/width\s*=\s*([\.\d]*)/)[1]
# coords = string.match(/\|\s*coordinates\s*=\s*(.*)/)[1]
map_caption = string.match(/map_caption\s*=\s*(.*)/)[1]
# puts parent

result ="{{Infobox body of water
| name               = #{name}
| native_name        = 
| native_name_lang   = 
| other_name         = 
<!--    Images     -->
| image              = 
| caption            = 
| image_bathymetry   = 
| caption_bathymetry = 
<!--    Stats      -->
| location           = [[Ontario]], [[Canada]]
| group              = 
| coordinates        = #{coords}
| type               = Lake
| etymology          = 
| part_of            = 
| inflow             = 
| rivers             = 
| outflow            = 
| oceans             = 
| catchment          = <!-- {{convert|VALUE|UNITS|abbr=on}} must be used -->
| basin_countries    = 
| agency             = 
| designation        = 
| date-built         = <!-- {{Start date|YYYY|MM|DD}} For man-made and other recent bodies of water -->
| engineer           = 
| date-flooded       = <!-- {{Start date|YYYY|MM|DD}} For man-made and other recent bodies of water -->
| length             = {{convert|#{length}|km|abbr=on}}
| width              = {{convert|#{width}|km|abbr=on}}
| area               = <!-- {{convert|VALUE|UNITS|abbr=on}} must be used -->
| depth              = <!-- {{convert|VALUE|UNITS|abbr=on}} must be used -->
| max-depth          = <!-- {{convert|VALUE|UNITS|abbr=on}} must be used -->
| volume             = <!-- {{convert|VALUE|UNITS|abbr=on}} must be used -->
| residence_time     = 
| salinity           = 
| shore              = <!-- {{convert|VALUE|UNITS|abbr=on}} must be used -->
| elevation          = 
| temperature_high   = <!-- {{convert|VALUE|UNITS|abbr=on}} must be used -->
| temperature_low    = <!-- {{convert|VALUE|UNITS|abbr=on}} must be used -->
| frozen             = 
| islands            = 
| islands_category   = 
| sections           = 
| trenches           = 
| benches            = 
| cities             = 
<!--      Map      -->
| pushpin_map             = Canada Ontario
| pushpin_label_position  = 
| pushpin_map_alt         = 
| pushpin_map_caption     = #{map_caption}
<!--   Below       -->  
| website            = 
| reference          = 
}}"

puts result
Clipboard.copy(result)