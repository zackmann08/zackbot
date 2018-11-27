require '../geobox/geobox'
require '../helper'

include Geobox


describe 'parse_government' do
  it 'works for default case' do
    input = <<~TEXT
drop this    
| part_type  = Civil Parishes
| part_count = 13
| part       = Angústias
| part1      = Capelo
| part2      = [[Castelo Branco (Horta)|Castelo Branco]]
| part3      = [[Cedros (Horta)|Cedros]]
| part4      = [[Conceição (Horta)|Conceição]]
| part5      = [[Feteira (Horta)|Feteira]]
| part6      = Flamengos
| part7      = [[Matriz (Horta)|Matriz]]}}
TEXT
    result = <<~TEXT

| parts_type              = Civil Parishes
| parts_style             = para
| p1                      = Angústias
| p2                      = Capelo
| p3                      = [[Castelo Branco (Horta)|Castelo Branco]]
| p4                      = [[Cedros (Horta)|Cedros]]
| p5                      = [[Conceição (Horta)|Conceição]]
| p6                      = [[Feteira (Horta)|Feteira]]
| p7                      = Flamengos
| p8                      = [[Matriz (Horta)|Matriz]]
TEXT

    expect(parse_parts(Helper.parse_template(input))).to eq(result.rstrip)
  end
  it 'defaults to parts' do
    input = <<~TEXT
drop this    
| part_count = 13
| part       = Angústias
| part1      = Capelo
| part2      = [[Castelo Branco (Horta)|Castelo Branco]]
| part3      = [[Cedros (Horta)|Cedros]]
| part4      = [[Conceição (Horta)|Conceição]]
| part5      = [[Feteira (Horta)|Feteira]]
| part6      = Flamengos
| part7      = [[Matriz (Horta)|Matriz]]}}
TEXT
    result = <<~TEXT

| parts_type              = Parts
| parts_style             = para
| p1                      = Angústias
| p2                      = Capelo
| p3                      = [[Castelo Branco (Horta)|Castelo Branco]]
| p4                      = [[Cedros (Horta)|Cedros]]
| p5                      = [[Conceição (Horta)|Conceição]]
| p6                      = [[Feteira (Horta)|Feteira]]
| p7                      = Flamengos
| p8                      = [[Matriz (Horta)|Matriz]]
TEXT

    expect(parse_parts(Helper.parse_template(input))).to eq(result.rstrip)
  end
end

describe 'get_codes' do
  it 'increments the blank number as needed' do
    params = {
        'code_type'=> 'a',
        'code' => 'b',
        'code_note' => 'NB',
        'code1_type'=> 'c',
        'code1' => 'd',
        'code1_note' => 'ND',
        'free_type'=> 'e',
        'free' => 'f',
        'free_note' => 'NF',
        'free1_type'=> 'g',
        'free1' => 'h',
        'free1_note' => 'NH'
    }
    params.default = ''
    result = <<~TEXT

| blank_name              = a
| blank_info              = bNB
| blank1_name             = c
| blank1_info             = dND
| blank2_name             = e
| blank2_info             = fNF
| blank3_name             = g
| blank3_info             = hNH
TEXT
    expect(get_codes(params)).to eq(result.rstrip)
  end
  
  it 'increments the blank number case 2' do
    params = {
        'code_type'=> 'a',
        'code' => 'b',
        'code_note' => 'NB',
        'free_type'=> 'e',
        'free' => 'f',
        'free_note' => 'NF',
        'free1_type'=> 'g',
        'free1' => 'h',
        'free1_note' => 'NH'
    }
    params.default = ''
    result = <<~TEXT

| blank_name              = a
| blank_info              = bNB
| blank1_name             = e
| blank1_info             = fNF
| blank2_name             = g
| blank2_info             = hNH
TEXT
    expect(get_codes(params)).to eq(result.rstrip)
  end
  
end

# describe 'parse_geobox_to_settlement' do  
#   it 'works for first example' do
#     text = <<~TEXT
# {{Geobox | Settlement
# <!-- *** Heading *** -->
# | name                = Bavorov
# | other_name          = 
# | category            = Town
# <!-- *** Image *** -->
# | image               = Bavorov-square1.jpg
# | image_caption       = 
# <!-- *** Symbols *** -->
# | flag                = 
# | symbol              = Coa_Czech_Town_Bavorov.svg
# <!-- *** Name *** -->
# | etymology           = 
# | official_name       = 
# | motto               = 
# | nickname            = 
# <!-- *** Country etc. *** -->
# | country             = Czech Republic
# | country_flag        = 1
# | state               = 
# | region              = [[South Bohemian Region|South Bohemian]]
# | region_type         = [[Regions of the Czech Republic|Region]]
# | district            = [[Strakonice District|Strakonice]]
# | district_type       = [[Districts of the Czech Republic|District]]
# | commune             = Vodňany
# | municipality        = 
# <!-- *** Family *** -->
# | part                = 
# | river               = 
# <!-- *** Locations *** -->
# | location            = 
# | elevation           = 446
# | coordinates         = {{coord|49|7|19|N|14|4|44|E|display=inline,title}}
# | capital_coordinates = 
# | mouth_coordinates   = 
# | highest             = 
# | highest_elevation   = 
# | lowest              = 
# | lowest_elevation    = 
# | area                = 35.39
# | area_round          = 2
# <!-- *** Population *** -->
# | population          = 1440
# | population_date     = 
# | population_density  = auto
# <!-- *** History & management *** -->
# | established         = 
# | established_type    = 
# | mayor               = Jan Michalec
# <!-- *** Codes *** -->
# | timezone            = [[Central European Time|CET]]
# | utc_offset          = +1
# | timezone_DST        = [[Central European Summer Time|CEST]]
# | utc_offset_DST      = +2
# | postal_code         = 387 73
# | area_code           = 
# | code                = 
# <!-- *** Maps *** -->
# | pushpin_map         = Czechia
# | pushpin_map_relief  = 1
# | pushpin_map_caption = Location in the Czech Republic
# <!-- *** Websites *** -->
# | commons             = Bavorov
# | statistics          = [http://www.statnisprava.cz/ebe/ciselniky.nsf/i/550809 statnisprava.cz]
# | website             = [http://www.bavorov.cz/ www.bavorov.cz]
# <!-- *** Footnotes *** -->
# | footnotes           = 
# }}
# TEXT
#     result = <<~TEXT
# {{Infobox settlement
# | name                    = Bavorov
# | native_name             = 
# | other_name              = 
# | settlement_type         = Town
# <!-- images, nickname, motto -->
# | image_skyline           = Bavorov-square1.jpg
# | image_caption           = 
# | image_flag              = 
# | image_shield            = Coa_Czech_Town_Bavorov.svg
# | motto                   = 
# | nickname                = 
# | etymology               = 
# <!-- location -->
# | subdivision_type        = Country
# | subdivision_name        = Czech Republic
# | subdivision_type1       = 
# | subdivision_name1       = 
# | subdivision_type2       = [[Regions of the Czech Republic|Region]]
# | subdivision_name2       = [[South Bohemian Region|South Bohemian]]
# | subdivision_type3       = [[Districts of the Czech Republic|District]]
# | subdivision_name3       = [[Strakonice District|Strakonice]]
# | subdivision_type4       = 
# | subdivision_name4       = 
# <!-- maps and coordinates -->
# | image_map               = 
# | map_caption             = 
# | pushpin_map             = Czechia
# | pushpin_relief          = 1
# | pushpin_map_caption     = Location in the Czech Republic 
# | coordinates             = {{coord|49|7|19|N|14|4|44|E|display=inline,title}}
# | coordinates_footnotes   = 
# <!-- government type, leaders -->
# | leader_title            = Mayor
# | leader_name             = Jan Michalec
# <!-- established -->
# | established_title       = 
# | established_date        = 
# <!-- area -->
# | area_footnotes          = 
# | area_total_km2          = 35.39
# | area_total_sq_mi        = 
# | area_land_sq_mi         = 
# | area_water_sq_mi        = 
# <!-- elevation -->
# | elevation_footnotes     = 
# | elevation_m             = 446
# | elevation_ft            = 
# <!-- population -->
# | population_as_of        = 
# | population_footnotes    = 
# | population_total        = 1440
# | population_density_km2  = auto
# | population_density_sq_mi=
# | population_demonym      = 
# <!-- time zone(s) -->
# | timezone1               = [[Central European Time|CET]]
# | utc_offset1             = +1
# | timezone1_DST           = [[Central European Summer Time|CEST]]
# | utc_offset1_DST         = +2
# <!-- postal codes, area code -->
# | postal_code_type        = Postal code
# | postal_code             = 387 73
# | area_code_type          =  
# | area_code               = 
# | geocode                 = 
# | iso_code                = 
# <!-- website, footnotes -->
# | website                 = [http://www.bavorov.cz/ www.bavorov.cz]
# | footnotes               = 
# }}
# TEXT
#     expect(parse_geobox_to_settlement(text)).to eq(result)
#   end
# 
#   it 'works for Adaven case' do
#     text = <<~TEXT
# {{Geobox | Settlement
# <!-- *** Geoboxes *** -->
# | geobox_width =
# <!-- *** Heading *** -->
# | name = Adaven
# | category = [[Ghost town]]
# <!-- *** Image *** -->
# | image              = 
# | image_caption      = 
# |image_alt = 
# | image_size   = 
# <!-- *** Name *** -->
# | etymology = [[Nevada]] spelled backwards
# | official_name = Adaven
# <!-- *** Country etc. *** -->
# | country = United States
# | country_flag = 1
# | state = Nevada
# | region = [[Nye County, Nevada|Nye]]
# | region_type = County
# | district =
# | district_type =
# <!-- *** Locations *** -->
# | location =
# | elevation_imperial = 6345
# | elevation_note = 
# | coordinates = {{coord|38.1321|N|115.6002|W|source:wikidata|display=title}}
# | coordinates_note = 
# | highest =
# | highest_elevation =
# | highest_coordinates =
# | lowest =
# | lowest_elevation =
# | lowest_coordinates =
# <!-- *** Dimensions *** -->
# | area =
# | area_round =
# <!-- *** Population *** -->
# | population = 0<ref>http://geonames.usgs.gov/apex/f?p=gnispq:3:0::NO::P3_FID:855945</ref>
# | population_date = 1954
# | population_note =
# | population_density =
# <!-- *** History & management *** -->
# | established = {{Start date|1890}}
# | established_type =
# | mayor =
# <!-- *** Codes *** -->
# | timezone = [[Pacific Time Zone|Pacific (PST)]]
# | utc_offset         = -8
# | timezone_DST = PDT ([[UTC-7]])
# | area_code =
# | code =
# <!-- *** Maps *** -->
# | pushpin_map = USA Nevada
# | map_caption =
# <!-- *** Websites *** -->
# | commons = 
# | statistics =
# | website =
# <!-- *** Footnotes *** -->
# | footnotes =
# }}
#     TEXT
#     result = <<~TEXT
# {{Infobox settlement
# | name                    = Adaven
# | native_name             = 
# | other_name              = 
# | settlement_type         = [[Ghost town]]
# <!-- images, nickname, motto -->
# | image_skyline           = 
# | image_caption           = 
# | image_flag              = 
# | image_shield            = 
# | motto                   = 
# | nickname                = 
# | etymology               = [[Nevada]] spelled backwards
# <!-- location -->
# | subdivision_type        = Country
# | subdivision_name        = United States
# | subdivision_type1       = State
# | subdivision_name1       = Nevada
# | subdivision_type2       = County
# | subdivision_name2       = [[Nye County, Nevada|Nye]]
# | subdivision_type3       = 
# | subdivision_name3       = 
# | subdivision_type4       = 
# | subdivision_name4       = 
# <!-- maps and coordinates -->
# | image_map               = 
# | map_caption             = 
# | pushpin_map             = USA Nevada
# | pushpin_relief          = 
# | pushpin_map_caption     =  
# | coordinates             = {{coord|38.1321|N|115.6002|W|source:wikidata|display=title}}
# | coordinates_footnotes   = 
# <!-- established -->
# | established_title       = Founded
# | established_date        = {{Start date|1890}}
# <!-- area -->
# | area_footnotes          = 
# | area_total_km2          = 
# | area_total_sq_mi        = 
# | area_land_sq_mi         = 
# | area_water_sq_mi        = 
# <!-- elevation -->
# | elevation_footnotes     = 
# | elevation_m             = 
# | elevation_ft            = 6345
# <!-- population -->
# | population_as_of        = 1954
# | population_footnotes    = 
# | population_total        = 0<ref>http://geonames.usgs.gov/apex/f?p=gnispq:3:0::NO::P3_FID:855945</ref>
# | population_density_km2  = auto
# | population_density_sq_mi=
# | population_demonym      = 
# <!-- time zone(s) -->
# | timezone1               = [[Pacific Time Zone|Pacific (PST)]]
# | utc_offset1             = -8
# | timezone1_DST           = PDT ([[UTC-7]])
# | utc_offset1_DST         = 
# <!-- postal codes, area code -->
# | postal_code_type        = 
# | postal_code             = 
# | area_code_type          =  
# | area_code               = 
# | geocode                 = 
# | iso_code                = 
# <!-- website, footnotes -->
# | website                 = 
# | footnotes               = 
# }}
# TEXT
#     expect(parse_geobox_to_settlement(text)).to eq(result)
#   end 
# 
#   it 'does not duplicate map' do
#     text = <<~TEXT
# {{Geobox
# | Settlement
# <!-- *** Name section *** -->
# | name                        = Bayou Gauche
# | native_name                 = 
# | other_name                  = 
# | other_name1                 = 
# | category                    = [[Census-designated place]]
# <!-- *** Image *** -->
# | image                       = FISHING IN BAYOU GAUCHE, IN THE LOUISIANA WETLANDS - NARA - 544195.jpg
# | image_size                  =  300px
# | image_caption               = Fishing in the Bayou Gauche [[wetland]]s.
# <!-- *** Symbols *** -->
# | flag                        = 
# | flag_size                   =    
# | symbol                      = 
# | symbol_size                 = 
# | symbol_type                 = 
# <!-- *** Country etc. *** -->
# | country                     = United States
# | state                       = Louisiana
# | region                      = [[St. Charles Parish, Louisiana|St. Charles]]
# | region_type                 = Parish
# <!-- *** Geography *** -->
# | area_imperial               = 20.2
# | area_land_imperial          = 17.6
# | area_water_imperial         = 2.6
# | area_water_percentage       = auto
# | area_percentage_round       = 2
# | area_round                  = 1
# | location                    = 
# | coordinates                 = {{coord|29|49|31|N|90|26|05|W|display=inline,title}}
# | capital_coordinates         = 
# | mouth_coordinates           = 
# | elevation_imperial          = 3
# | elevation_round             = 1
# <!-- *** Population *** -->
# | population_as_of            = 2000
# | population                  = 1770
# | population_density_imperial = 100.7
# | population_density_round    = 1
# <!-- *** Government *** -->
# | established_type            = 
# | established                 = 
# | mayor                       = 
# <!-- *** Various codes *** -->
# | timezone                    = [[North American Central Time Zone|CST]]
# | utc_offset                  = -6
# | timezone_DST                = [[North American Central Time Zone|CDT]]
# | utc_offset_DST              = -5
# | postal_code                 = 
# | postal_code_type            = 
# | area_code                   = [[Area code 985|985]]
# | area_code_type              =  
# | code2_type                  =
# | code2                       =
# <!-- *** Free fields *** -->
# | free_type                   =  
# | free                        =
# | free1_type                  =  
# | free1                       = 
# <!-- *** Map section *** -->
# | map                         = Louisiana Locator Map.PNG
# | map_size                    = 
# | map_caption                 = Location of Bayou Gauche in Louisiana
# | map_locator                 = Louisiana
# | map1                        = 
# | map1_caption                =
# <!-- *** Website *** -->
# | website                     = 
# }}
# TEXT
#     result = <<~TEXT
# {{Infobox settlement
# | name                    = Bayou Gauche
# | native_name             = 
# | other_name              = 
# | settlement_type         = [[Census-designated place]]
# <!-- images, nickname, motto -->
# | image_skyline           = FISHING IN BAYOU GAUCHE, IN THE LOUISIANA WETLANDS - NARA - 544195.jpg
# | image_caption           = Fishing in the Bayou Gauche [[wetland]]s.
# | image_flag              = 
# | image_shield            = 
# | motto                   = 
# | nickname                = 
# | etymology               = 
# <!-- location -->
# | subdivision_type        = Country
# | subdivision_name        = United States
# | subdivision_type1       = State
# | subdivision_name1       = Louisiana
# | subdivision_type2       = Parish
# | subdivision_name2       = [[St. Charles Parish, Louisiana|St. Charles]]
# | subdivision_type3       = 
# | subdivision_name3       = 
# | subdivision_type4       = 
# | subdivision_name4       = 
# <!-- maps and coordinates -->
# | image_map               = 
# | map_caption             = 
# | pushpin_map             = Louisiana
# | pushpin_relief          = 
# | pushpin_map_caption     = Location of Bayou Gauche in Louisiana 
# | coordinates             = {{coord|29|49|31|N|90|26|05|W|display=inline,title}}
# | coordinates_footnotes   = 
# <!-- established -->
# | established_title       = 
# | established_date        = 
# <!-- area -->
# | area_footnotes          = 
# | area_total_km2          = 
# | area_total_sq_mi        = 20.2
# | area_land_sq_mi         = 17.6
# | area_water_sq_mi        = 2.6
# <!-- elevation -->
# | elevation_footnotes     = 
# | elevation_m             = 
# | elevation_ft            = 3
# <!-- population -->
# | population_as_of        = 2000
# | population_footnotes    = 
# | population_total        = 1770
# | population_density_km2  = auto
# | population_density_sq_mi=
# | population_demonym      = 
# <!-- time zone(s) -->
# | timezone1               = [[North American Central Time Zone|CST]]
# | utc_offset1             = -6
# | timezone1_DST           = [[North American Central Time Zone|CDT]]
# | utc_offset1_DST         = -5
# <!-- postal codes, area code -->
# | postal_code_type        = 
# | postal_code             = 
# | area_code_type          =  
# | area_code               = [[Area code 985|985]]
# | geocode                 = 
# | iso_code                = 
# <!-- website, footnotes -->
# | website                 = 
# | footnotes               = 
# }}
# TEXT
#     expect(parse_geobox_to_settlement(text)).to eq(result)
#   end
#   
#   it 'works for GNIS codes' do
#     text = <<~TEXT
# {{Geobox|Settlement
# <!-- *** Heading *** -->
# | name                              = Clarence
# | native_name                       = 
# | other_name                        = 
# | category                          = [[List of unincorporated communities in Illinois|Unincorporated]]
# <!-- *** Names **** --> 
# | etymology                         = 
# | official_name                     = 
# | motto                             = 
# | nickname                          = 
# <!-- *** Image *** -->
# | image                             = 
# | image_caption                     = 
# <!-- *** Symbols *** -->
# | flag                              = 
# | symbol                            = 
# <!-- *** Country *** -->
# | country                           = United States
# | state                             = Illinois
# | region_type                       = County
# | region                            = [[Ford County, Illinois|Ford]]
# | district_type                     = Township
# | district                          = [[Button Township, Ford County, Illinois|Button]]
# | municipality                      = 
# <!-- *** Family *** -->
# | part                              = 
# | landmark                          = 
# | river                             = 
# <!-- *** Locations *** -->
# | location                          = 
# | elevation_imperial                = 761
# | elevation_note                    = <ref name="usgs">{{Cite GNIS|406143|Feature Detail Report for: Clarence (Ford County, Illinois)|accessdate=October 5, 2008}}</ref>
# | prominence_imperial               = 
# | coordinates                       = {{coord|40|27|50|N|87|58|15|W|display=inline,title}}
# | capital_coordinates               = 
# | mouth_coordinates                 = 
# | highest                           = 
# | highest_location                  = 
# | highest_region                    = 
# | highest_state                     = 
# | highest_elevation_imperial        = 
# | lowest                            = 
# | lowest_location                   = 
# | lowest_region                     = 
# | lowest_state                      = 
# | lowest_elevation_imperial         = 
# | length_imperial                   = 
# | length_orientation                = 
# | area_imperial                     = 
# | area_land_imperial                = 
# | area_water_imperial               = 
# | area_urban_imperial               = 
# | area_metro_imperial               = 
# <!-- *** Population *** -->
# | population                        = <100 
# | population_date                   = 2000
# | population_urban                  = 
# | population_metro                  = 
# | population_density_imperial       = 
# | population_density_urban_imperial = 
# | population_density_metro_imperial = 
# <!-- *** History & management *** -->
# | established                       = 
# | date                              = 
# | government                        = 
# | government_location               = 
# | government_region                 = 
# | government_state                  = 
# | government_elevation_imperial     = 
# | leader_type                       = 
# | leader                            = 
# <!-- *** Codes ***  -->
# | timezone                          = [[Central Time Zone (North America)|CST]]
# | utc_offset                        = -6
# | timezone_DST                      = [[Central Time Zone (North America)|CDT]]
# | utc_offset_DST                    = -5
# | postal_code                       = 
# | area_code_type                    = [[North American Numbering Plan|Area code]]
# | area_code                         = 
# | code_type                         = [[Geographic Names Information System|GNIS]] ID
# | code                              = {{GNIS4|406143}}
# | code_note                         = <ref name="usgs"/>
# <!-- *** UNESCO etc. *** -->
# | whs_name                          = 
# | whs_year                          = 
# | whs_number                        = 
# | whs_region                        = 
# | whs_criteria                      = 
# | iucn_category                     = 
# <!-- *** Free fields *** -->
# | free                              = 
# | free_type                         = 
# <!-- *** Maps *** -->
# | map                               = Illinois - outline map.svg
# <!-- Illinois Locator Map.PNG -->
# | map_caption                       = Location of Clarence within Illinois
# | map_background                    = Illinois - background map.png
# | map_locator                       = Illinois2
# <!-- *** Websites *** --> 
# | commons                           = Clarence, Illinois
# | statistics                        = 
# | website                           = 
# <!-- *** Footnotes *** -->
# | footnotes                         = 
# }}
#     TEXT
#     result = <<~TEXT
# {{Infobox settlement
# | name                    = Clarence
# | native_name             = 
# | other_name              = 
# | settlement_type         = [[List of unincorporated communities in Illinois|Unincorporated]]
# <!-- images, nickname, motto -->
# | image_skyline           = 
# | image_caption           = 
# | image_flag              = 
# | image_shield            = 
# | motto                   = 
# | nickname                = 
# | etymology               = 
# <!-- location -->
# | subdivision_type        = Country
# | subdivision_name        = United States
# | subdivision_type1       = State
# | subdivision_name1       = Illinois
# | subdivision_type2       = County
# | subdivision_name2       = [[Ford County, Illinois|Ford]]
# | subdivision_type3       = Township
# | subdivision_name3       = [[Button Township, Ford County, Illinois|Button]]
# | subdivision_type4       = 
# | subdivision_name4       = 
# <!-- maps and coordinates -->
# | image_map               = 
# | map_caption             = 
# | pushpin_map             = Illinois
# | pushpin_relief          = 
# | pushpin_map_caption     = Location of Clarence within Illinois 
# | coordinates             = {{coord|40|27|50|N|87|58|15|W|display=inline,title}}
# | coordinates_footnotes   = 
# <!-- established -->
# | established_title       = 
# | established_date        = 
# <!-- area -->
# | area_footnotes          = 
# | area_total_km2          = 
# | area_total_sq_mi        = 
# | area_land_sq_mi         = 
# | area_water_sq_mi        = 
# <!-- elevation -->
# | elevation_footnotes     = <ref name="usgs">{{Cite GNIS|406143|Feature Detail Report for: Clarence (Ford County, Illinois)|accessdate=October 5, 2008}}</ref>
# | elevation_m             = 
# | elevation_ft            = 761
# <!-- population -->
# | population_as_of        = 2000
# | population_footnotes    = 
# | population_total        = <100
# | population_density_km2  = auto
# | population_density_sq_mi=
# | population_demonym      = 
# <!-- time zone(s) -->
# | timezone1               = [[Central Time Zone (North America)|CST]]
# | utc_offset1             = -6
# | timezone1_DST           = [[Central Time Zone (North America)|CDT]]
# | utc_offset1_DST         = -5
# <!-- postal codes, area code -->
# | postal_code_type        = 
# | postal_code             = 
# | area_code_type          =  
# | area_code               = 
# | geocode                 = 
# | iso_code                = 
# | blank_name              = [[Geographic Names Information System|GNIS]] ID
# | blank_info              = {{GNIS4|406143}}<ref name="usgs"/>
# <!-- website, footnotes -->
# | website                 = 
# | footnotes               = 
# }}
# TEXT
#     expect(parse_geobox_to_settlement(text)).to eq(result)
#   end
#   
#   it 'works for unesco case' do
#     text = <<~TEXT
# {{Geobox | Settlement
# <!-- *** Heading *** -->
# | name               = Bardejov
# | other_name         =
# | category           = Town
# <!-- *** Image *** -->
# | image              = Bardejov namesti 3773.JPG
# | image_caption      = The Town Hall Square (''Radničné námestie'') in Bardejov
# <!-- *** Symbols *** -->
# | flag               =
# | symbol             = Coa_Slovakia_Town_Bártfa.svg
# <!-- *** Name *** -->
# | etymology          =
# | official_name      =
# | motto              =
# | nickname           =
# <!-- *** Country etc. *** -->
# | country            = Slovakia
# | country_flag       = 1
# | state              =
# | region             = [[Prešov Region|Prešov]]
# | district           = [[Bardejov District|Bardejov]]
# | commune            =
# | municipality       =
# <!-- *** Family *** -->
# | part               =
# | river              = Topľa
# <!-- *** Locations *** -->
# | location           =
# | elevation          = 283
# | coordinates        = {{coord|49|17|36|N|21|16|34|E|display=inline,title}}
# | capital_coordinates = 
# | mouth_coordinates  = 
# | highest            =
# | highest_elevation  =
# | lowest             =
# | lowest_elevation   =
# | area               = 72.78
# | area_round         = 2
# <!-- *** Population *** -->
# | population         = 33020
# | population_date    = 2010-12-31
# | population_density = auto
# <!-- *** History & management *** -->
# | established        = 1241
# | established_type   = First mentioned
# | mayor              =
# <!-- *** Codes *** -->
# | timezone           = [[Central European Time|CET]]
# | utc_offset         = +1
# | timezone_DST       = [[Central European Summer Time|CEST]]
# | utc_offset_DST     = +2
# | postal_code        = 08501
# | area_code          = +421-54
# | code               = BJ
# | code_type          = [[Vehicle registration plates of Slovakia|Car plate]]
# <!-- *** UNESCO etc. *** -->
# | whs_name           = Bardejov Town Conservation Reserve
# | whs_year           = 2000
# | whs_number         = 973
# | whs_region         = [[List of World Heritage Sites in Europe|Europe and North America]]
# | whs_criteria       = iii, iv
# | category_iucn      = Cultural
# <!-- *** Free fields *** -->
# | free               =
# <!-- *** Maps *** -->
# | map                = Slovakia - outline map.svg
# | map_background     = Slovakia - background map.png
# | map_caption        = Location in Slovakia
# | map_locator        = Slovakia
# | map1               = Prešov Region  - outline map.svg
# | map1_background    = Prešov Region - background map.png
# | map1_caption       = Location in the Prešov Region
# | map1_locator       = Prešov Region
# <!-- *** Websites *** -->
# | commons            = Bardejov
# | statistics         = [http://www.statistics.sk/mosmis/eng/prvav2.jsp?txtUroven&#61;440701&lstObec&#61;519006&Okruh&#61;zaklad MOŠ/MIS]
# | website            = [http://www.e-bardejov.sk www.e-bardejov.sk]
# <!-- *** Footnotes *** -->
# | footnotes          =
# <!-- Processed by Geoboxer 3.0 on 2007-10-30T00:39:00+01:00 --> }}
#     TEXT
#     result = <<~TEXT
# {{Infobox settlement
# | name                    = Bardejov
# | native_name             = 
# | other_name              = 
# | settlement_type         = Town
# <!-- images, nickname, motto -->
# | image_skyline           = Bardejov namesti 3773.JPG
# | image_caption           = The Town Hall Square (''Radničné námestie'') in Bardejov
# | image_flag              = 
# | image_shield            = Coa_Slovakia_Town_Bártfa.svg
# | motto                   = 
# | nickname                = 
# | etymology               = 
# <!-- location -->
# | subdivision_type        = Country
# | subdivision_name        = Slovakia
# | subdivision_type1       = 
# | subdivision_name1       = 
# | subdivision_type2       = Region
# | subdivision_name2       = [[Prešov Region|Prešov]]
# | subdivision_type3       = District
# | subdivision_name3       = [[Bardejov District|Bardejov]]
# | subdivision_type4       = 
# | subdivision_name4       = 
# <!-- maps and coordinates -->
# | image_map               = 
# | map_caption             = 
# | pushpin_map             = Slovakia
# | pushpin_relief          = 
# | pushpin_map_caption     = Location in Slovakia 
# | coordinates             = {{coord|49|17|36|N|21|16|34|E|display=inline,title}}
# | coordinates_footnotes   = 
# <!-- established -->
# | established_title       = First mentioned
# | established_date        = 1241
# <!-- area -->
# | area_footnotes          = 
# | area_total_km2          = 72.78
# | area_total_sq_mi        = 
# | area_land_sq_mi         = 
# | area_water_sq_mi        = 
# <!-- elevation -->
# | elevation_footnotes     = 
# | elevation_m             = 283
# | elevation_ft            = 
# <!-- population -->
# | population_as_of        = 2010-12-31
# | population_footnotes    = 
# | population_total        = 33020
# | population_density_km2  = auto
# | population_density_sq_mi=
# | population_demonym      = 
# <!-- time zone(s) -->
# | timezone1               = [[Central European Time|CET]]
# | utc_offset1             = +1
# | timezone1_DST           = [[Central European Summer Time|CEST]]
# | utc_offset1_DST         = +2
# <!-- postal codes, area code -->
# | postal_code_type        = Postal code
# | postal_code             = 08501
# | area_code_type          =  
# | area_code               = +421-54
# | geocode                 = 
# | iso_code                = 
# | blank_name              = [[Vehicle registration plates of Slovakia|Car plate]]
# | blank_info              = BJ
# <!-- website, footnotes -->
# | website                 = [http://www.e-bardejov.sk www.e-bardejov.sk]
# | footnotes               = {{Infobox UNESCO World Heritage Site
#   | Official_name = Bardejov Town Conservation Reserve
#   | Criteria      = iii, iv 
#   | ID            = 973
#   | Year          = 2000
#   | child         = yes
# }}
# }}
# TEXT
#     expect(parse_geobox_to_settlement(text)).to eq(result)
#   end
#   
#   
#   # it 'works for base case' do
#   #   text = <<~TEXT
#   # 
#   #   TEXT
#   #   result = <<~TEXT
#   # 
#   #TEXT
#   #   expect(parse_geobox_to_settlement(text)).to eq(result)
#   # end
#   
# end

describe 'parse_location' do
  it 'works for default case' do
    input = <<~TEXT
drop this    
| country        = United States
| state          = Pennsylvania
| region_type    = County
| region         = [[Centre County, Pennsylvania|Centre]]
| district_type  = Township
| district       = [[Howard Township, Centre County, Pennsylvania|Howard]] 
| city           = [[Downtown]]
}}
TEXT
    result = "[[Downtown]], [[Howard Township, Centre County, Pennsylvania|Howard]], [[Centre County, Pennsylvania|Centre]], Pennsylvania, United States"

    expect(parse_location(Helper.parse_template(input))).to eq(result.rstrip)
  end
  it 'works for case missing some values' do
    input = <<~TEXT
drop this    
| country        = United States
| state          = Pennsylvania
| region_type    = County
| region         = 
| district_type  = Township
| district       = 
| city           = [[Downtown]]
}}
TEXT
    result = "[[Downtown]], Pennsylvania, United States"
    expect(parse_location(Helper.parse_template(input))).to eq(result.rstrip)
  end
  it 'strips the flag templates' do
    input = <<~TEXT
drop this    
| country = {{flag|United States}}
| state = {{flag|Montana}}
| region_type = County
| region = [[Judith Basin County, Montana|Judith Basin]]
}}
TEXT
    result = "[[Judith Basin County, Montana|Judith Basin]], [[Montana]], [[United States]]"
    expect(parse_location(Helper.parse_template(input))).to eq(result.rstrip)
  end
  
end


describe 'parse_geobox_to_protected_area' do  
  it 'works for first example' do
    text = <<~TEXT
{{Geobox|Protected area
<!-- *** Name section *** -->
| name = A. W. Marion State Park 
| native_name = | other_name = | other_name1 =
<!-- *** Category *** -->
| category = [[List of Ohio state parks|Ohio State Park]]
| category_iucn = 
<!-- *** Image *** -->
| image = AWM1.JPG
| image_caption = 
| image_size = 280
<!-- *** Etymology *** --->
| etymology_type = Named for
| etymology = 
<!-- *** Country etc. *** -->
| country = United States
| state = Ohio
| region_type = County
| region = [[Pickaway County, Ohio|Pickaway]]
| district_type =
| district =
| city =
| city1 =
<!-- *** Geography *** -->
| coordinates = {{coord|39|37|50|N|82|52|47|W|display=inline,title}}
| coordinates_note = <ref name=gnis/>
| location =
| elevation_imperial = 869
| elevation_round = 0
| elevation_note = <ref name=gnis>{{cite gnis|1037298|A. W. Marion State Park}}</ref>
| area_unit = acre
| area_imperial = 309
| area_round = 0
| area_note = <ref name=odnr/>
| area1_imperial =
| area1_type =
| length_imperial = | length_orientation = | width_imperial = | width_orientation =
| highest = | highest location = | highest_elevation_imperial = 
| lowest = | lowest_location = | lowest_elevation_imperial =
<!-- *** Nature *** -->
| biome = | biome_share = | biome1 = | biome1_share = 
| geology = | geology1 = 
| plant = | plant1 = | animal = | animal1 =
<!-- *** People *** -->
| established_type = Established
| established = 1948
| established_note =
| established1_type =
| established1 =
| management_body = [[Ohio Department of Natural Resources]]
| management_location =
| management_elevation =
| visitation = | visitation_year =
| free_type = | free = | free1_type = | free1 =
<!-- *** Map section *** -->
| pushpin_map = Ohio
| pushpin_map_caption = Location in Ohio
| pushpin_map_size = 280
| website = [http://parks.ohiodnr.gov/awmarion A. W. Marion State Park]
}}
TEXT
    result = <<~TEXT
{{Infobox protected area
| name            = A. W. Marion State Park
| iucn_category   = 
<!-- images -->
| photo           = AWM1.JPG
| photo_caption   = 
<!-- map -->
| map             = Ohio
| map_image       = 
| map_size        = 280
| map_caption     = Location in Ohio
| relief          = 
<!-- location -->
| location        = [[Pickaway County, Ohio|Pickaway]], Ohio, United States
| nearest_city    = 
| nearest_town    = 
| coordinates     = {{coord|39|37|50|N|82|52|47|W|display=inline,title}}
| coords_ref      = <ref name=gnis/>
<!-- stats --> 
| length          = 
| length_mi       = 
| length_km       = 
| width           = 
| width_mi        = 
| width_km        = 
| area_acre       = 309
| area_ref        = <ref name=odnr/>
| elevation       = {{convert|869|ft|m|abbr=on}}<ref name=gnis>{{cite gnis|1037298|A. W. Marion State Park}}</ref>
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = 1948
| named_for       = 
| visitation_num  = 
| visitation_year = 
| visitation_ref  = 
| governing_body  = [[Ohio Department of Natural Resources]]
| administrator   = 
| operator        = 
| owner           =
<!-- website, embedded --> 
| website         = [http://parks.ohiodnr.gov/awmarion A. W. Marion State Park]
| embedded        = 
}}
TEXT
    expect(parse_geobox_to_protected_area(text)).to eq(result)
  end
  
  it 'works for case 2' do
    text = <<~TEXT
{{Geobox|Protected Area
<!-- *** Heading *** -->
| name = Aaron Provincial Park
| native_name = 
| other_name = 
| category = 
<!-- *** Names **** --> 
| etymology = Original homestead of John. T. Aaron
| official_name = 
| motto = 
| nickname = 
<!-- *** Image *** -->
| image = 
| image_caption =
| image_size =
<!-- *** Symbols *** -->
| flag = 
| symbol = 
<!-- *** Country *** -->
| country = Canada
| state = Ontario
| state_type = Province
| region = 
| district = [[Kenora District, Ontario|Kenora]]
| municipality = 
<!-- *** Family *** -->
| city = 
| landmark = 
| river =
| lake =
| mountain =
<!-- *** Locations *** -->
| location = 
| elevation = 382
| prominence =
<!-- Coordinates per Geographical Names Database of Geographical Names of Canada - see reference; elevation at these coordinates -->
| coordinates = {{coord|49|45|42.2|N|92|39|23.4|W|display=inline,title}}
| capital_coordinates = 
| mouth_coordinates = 
| highest = 
| highest_location = | highest_region = | highest_country =
| highest_elevation = 
| lowest = 
| lowest_location = | lowest_region = | lowest_country =
| lowest_elevation = 
| length = | length_orientation = 
| width = | width_orientation = 
| area = 116
| area_unit = ha
<!-- *** Features *** -->
| geology =
| biome =
| plant =
| animal =
<!-- *** History & management *** -->
| established =
| date = 
| management = 
| management_location = | management_region = | management_country =
| management_elevation = 
| owner = [[Ontario Parks]]
| leader =
<!-- *** Access *** -->
| public =
| visitation = | visitation_date =
| access =
<!-- *** UNESCO etc. *** -->
| whs_name =
| whs_year =
| whs_number =
| whs_region =
| whs_criteria =
| category_iucn = II
<!-- *** Free fields *** -->
| free = | free_type = 
<!-- *** Maps *** -->
| map = Canada Ontario location map 2.svg
| map_caption = Location of Aaron Provincial Park in Ontario.
| map_background =
| map_locator = Ontario
<!-- *** Website *** --> 
| website =
<!-- *** Footnotes *** -->
| footnotes =
}}
TEXT
    result = <<~TEXT
{{Infobox protected area
| name            = Aaron Provincial Park
| iucn_category   = II
<!-- images -->
| photo           = 
| photo_caption   = 
<!-- map -->
| map             = Ontario
| map_image       = 
| map_size        = 
| map_caption     = Location of Aaron Provincial Park in Ontario.
| relief          = 
<!-- location -->
| location        = [[Kenora District, Ontario|Kenora]], Ontario, Canada
| nearest_city    = 
| nearest_town    = 
| coordinates     = {{coord|49|45|42.2|N|92|39|23.4|W|display=inline,title}}
| coords_ref      = 
<!-- stats --> 
| length          = 
| length_mi       = 
| length_km       = 
| width           = 
| width_mi        = 
| width_km        = 
| area_ha         = 116
| area_ref        = 
| elevation       = {{convert|382|m|ft|abbr=on}}
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = 
| named_for       = Original homestead of John. T. Aaron
| visitation_num  = 
| visitation_year = 
| visitation_ref  = 
| governing_body  = 
| administrator   = 
| operator        = 
| owner           =
<!-- website, embedded --> 
| website         = 
| embedded        = 
}}
TEXT
    expect(parse_geobox_to_protected_area(text)).to eq(result)
  end
  
  it 'works for case 3' do
    text = <<~TEXT
{{Geobox|Protected area
| name = {{#property:name}}
| category = 
| category_iucn = III
| image = {{#property:image}}
| caption = 
| country = United States
| country_flag = 1
| state = New Jersey
| state_flag = 1
| state_type = State
| region = [[Ocean County, New Jersey]]
| region_type = County
| city_type = City
| city = [[Barnegat Light, New Jersey]]
| coordinates = {{WikidataCoord|display=title,inline}}
| capital_coordinates = 
| mouth_coordinates = 
| pushpin_map = USA New Jersey
| pushpin_map_size = 180
| pushpin_map_relief = 1
| pushpin_map_caption = 
| governing_body = 
| website = [{{#property:official website}} Barnegat Lighthouse State Park]
| area = 0.13
| established = {{#property:inception}}
}}
    TEXT
    result = <<~TEXT
{{Infobox protected area
| name            = {{#property:name}}
| iucn_category   = III
<!-- images -->
| photo           = {{#property:image}}
| photo_caption   = 
<!-- map -->
| map             = USA New Jersey
| map_image       = 
| map_size        = 180
| map_caption     = 
| relief          = 1
<!-- location -->
| location        = [[Barnegat Light, New Jersey]], [[Ocean County, New Jersey]], New Jersey, United States
| nearest_city    = 
| nearest_town    = 
| coordinates     = {{WikidataCoord|display=title,inline}}
| coords_ref      = 
<!-- stats --> 
| length          = 
| length_mi       = 
| length_km       = 
| width           = 
| width_mi        = 
| width_km        = 
| area_km2        = 0.13
| area_ref        = 
| elevation       = 
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = {{#property:inception}}
| named_for       = 
| visitation_num  = 
| visitation_year = 
| visitation_ref  = 
| governing_body  = 
| administrator   = 
| operator        = 
| owner           =
<!-- website, embedded --> 
| website         = [{{#property:official website}} Barnegat Lighthouse State Park]
| embedded        = 
}}
TEXT
    expect(parse_geobox_to_protected_area(text)).to eq(result)
  end
  
  it 'works for case 4' do
    text = <<~TEXT
{{Geobox|Protected Area
<!-- *** Heading *** -->
| name = Aiguilles Rouges National Nature Reserve
| native_name = Réserve naturelle nationale des Aiguilles Rouges
| other_name = 
| category = 
<!-- *** Names **** --> 
| etymology = 
| official_name = 
| motto = 
| nickname = 
<!-- *** Image *** -->
| image = Col des Montets - chalet.jpg
| image_caption = The information cabin at the Col des Montets
| image_size = 320px
<!-- *** Symbols *** -->
| flag = 
| symbol = 
<!-- *** Country *** -->
| country = France
| state = 
| region = Rhone-Alpes
| district = Haute-Savoie
| municipality = [[Chamonix]], [[Vallorcine]]
<!-- *** Family *** -->
| city = 
| landmark = 
| river =
| lake =
| mountain =
<!-- *** Locations *** -->
| location = [[Aiguilles Rouges]]
| elevation =
| prominence =
| coordinates = {{coord|45|58|45|N|6|52|15|E|display=inline,title}}
| capital_coordinates = 
| mouth_coordinates = 
| highest = 
| highest_location = | highest_region = | highest_country =
| highest_elevation = 
| lowest = 
| lowest_location = | lowest_region = | lowest_country =
| lowest_elevation = 
| length = | length_orientation = 
| width = | width_orientation = 
| area = 32.79
<!-- *** Features *** -->
| geology =
| biome =
| plant =
| animal =
<!-- *** History & management *** -->
| established =
| date = 1974
| management = ASTERS
| management_location = | management_region = | management_country =
| management_elevation = 
| owner =
| leader =
<!-- *** Access *** -->
| public =
| visitation = | visitation_date =
| access =
<!-- *** Free fields *** -->
| free = | free_type = 
<!-- *** Maps *** -->
| map =
| map_caption = 
| map_background = 
| map_locator =
| map_locator_x = 
| map_locator_y = 
<!-- *** Website *** --> 
| website =
<!-- *** Footnotes *** -->
| footnotes =
}}
    TEXT
    result = <<~TEXT
{{Infobox protected area
| name            = Aiguilles Rouges National Nature Reserve
| iucn_category   = 
<!-- images -->
| photo           = Col des Montets - chalet.jpg
| photo_caption   = The information cabin at the Col des Montets
<!-- map -->
| map             = 
| map_image       = 
| map_size        = 
| map_caption     = 
| relief          = 
<!-- location -->
| location        = Haute-Savoie, Rhone-Alpes, France
| nearest_city    = 
| nearest_town    = 
| coordinates     = {{coord|45|58|45|N|6|52|15|E|display=inline,title}}
| coords_ref      = 
<!-- stats --> 
| length          = 
| length_mi       = 
| length_km       = 
| width           = 
| width_mi        = 
| width_km        = 
| area_km2        = 32.79
| area_ref        = 
| elevation       = 
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = 
| named_for       = 
| visitation_num  = 
| visitation_year = 
| visitation_ref  = 
| governing_body  = 
| administrator   = 
| operator        = ASTERS
| owner           =
<!-- website, embedded --> 
| website         = 
| embedded        = 
}}
  TEXT
    expect(parse_geobox_to_protected_area(text)).to eq(result)
  end
  
  it 'works for case 5' do
    text = <<~TEXT
{{Geobox|Protected area
<!-- *** Name section *** -->
| name                        = The Kent Downs
| native_name                 = 
| other_name                  = 
| other_name1                 = 
<!-- *** Category *** -->
| category                    = [[Area of Outstanding Natural Beauty]]
| category_iucn               = 
<!-- *** Image *** -->
| image                       = DownsRanscombeFieldToMway0734c.JPG
| image_size                  = 200
| image_caption               = [[Ranscombe Farm]], Medway. In June, these 'unimproved' meadows are covered with [[calcareous grassland|chalk grassland flowers]]. 
<!-- *** Country etc. *** -->
| country                     = England
| region                      = [[Kent]] 
| region_type                 = County
| location                    = south-east England
| coordinates = 
| elevation          =  
<!-- *** Nature *** -->
| biome                       =
| biome_share                 = 
| biome1                      =
| biome1_share                = 
| geology                     = 
| geology1                    = 
| plant                       = 
| plant1                      = 
| animal                      =   
| animal1                     =
<!-- *** Geography *** -->
| area                        = 
| area1                       =
| area1_type                  =   
| length                      = 
| length_orientation          = 
| width                       = 
| width_orientation           = 
| highest                     = 
| highest_location            =  
| highest_coordinates = 
| highest_elevation           = 
| lowest                      = 
| lowest_location             = 
| lowest_coordinates = 
| lowest_elevation            = 
<!-- *** People *** -->
| established_type            = 
| established                 = 
| established1_type           = 
| established1                = 
| management_body             = 
| management_location         = 
| management_coordinates = 
| management_elevation        =
| visitation                  = 
| visitation_year             = 
<!-- *** Free fields *** -->
| free_type                   =  
| free                        =
| free1_type                  =  
| free1                       = 
<!-- *** Map *** -->
| map = Kent Downs AONB locator map.svg
| map_size = 243
| map_caption = Location of the Kent Downs AONB in the UK
| map_alt= Map of England and Wales with a green area representing the location of the Kent Downs AONB
<!-- *** Website *** -->
| website                     = 
}}
    TEXT
    result = <<~TEXT
{{Infobox protected area
| name            = The Kent Downs
| iucn_category   = 
<!-- images -->
| photo           = DownsRanscombeFieldToMway0734c.JPG
| photo_caption   = [[Ranscombe Farm]], Medway. In June, these 'unimproved' meadows are covered with [[calcareous grassland|chalk grassland flowers]].
<!-- map -->
| map             = 
| map_image       = Kent Downs AONB locator map.svg
| map_size        = 243
| map_caption     = Location of the Kent Downs AONB in the UK
| relief          = 
<!-- location -->
| location        = [[Kent]], England
| nearest_city    = 
| nearest_town    = 
| coordinates     = 
| coords_ref      = 
<!-- stats --> 
| length          = 
| length_mi       = 
| length_km       = 
| width           = 
| width_mi        = 
| width_km        = 
| area_ref        = 
| elevation       = 
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = 
| named_for       = 
| visitation_num  = 
| visitation_year = 
| visitation_ref  = 
| governing_body  = 
| administrator   = 
| operator        = 
| owner           =
<!-- website, embedded --> 
| website         = 
| embedded        = 
}}
  TEXT
    expect(parse_geobox_to_protected_area(text)).to eq(result)
  end
  
  it 'works for case 6' do
    text = <<~TEXT
{{Geobox|Protected Area
| name = Antelope Island
| category =
| image = Antelope Island Cove 2005.jpg
| image_caption = View from Buffalo Point, Antelope Island
| image_size = 300
| country = United States
| state = [[Utah]]
| region =  [[Davis County, Utah]]
| region_type = County
| capital_coordinates = 
| highest_coordinates = 
| lowest_coordinates = 
| source_coordinates = 
| source1_coordinates = 
| source2_coordinates = 
| source_confluence_coordinates = 
| mouth_coordinates = 
| management_coordinates = 
| government_coordinates = 
| coordinates = {{coord|40|57|00|N|112|12|36|W|scale:250000|display=inline,title}}
| highest =
| highest_location = Frary Peak
| highest_elevation = 2010
| lowest =
| lowest_location = [[Great Salt Lake]]
| lowest_elevation = 1279
| length = 24
| width = 7.8
| area = 109
| geology =
| biome =
| plant =
| animal =
| established = 1969
| date =
| management = [[Utah State Parks]]
| owner =
| public =
| visitation = 273618
| visitation_date = 2009
| visitation_note = <ref name="record">{{cite web | url = http://www.deseretnews.com/article/705356606/Antelope-Island-State-Park-raises-record-amount.html | title = Antelope Island State Park raises record amount | author = Doughery, Jospen M. | publisher = Deseret News | date = 2010-01-01 | accessdate = 2010-01-11| archiveurl= https://web.archive.org/web/20100115172245/http://www.deseretnews.com/article/705356606/Antelope-Island-State-Park-raises-record-amount.html| archivedate= 15 January 2010 <!--DASHBot-->| deadurl= no}}</ref>
| access =
| map = Antelope Island State Park Map.jpg
| map_caption = Map of Antelope Island State Park
| website = [http://stateparks.utah.gov/parks/antelope-island Utah State Parks: Antelope Island]
}}
    TEXT
    result = <<~TEXT
{{Infobox protected area
| name            = Antelope Island
| iucn_category   = 
<!-- images -->
| photo           = Antelope Island Cove 2005.jpg
| photo_caption   = View from Buffalo Point, Antelope Island
<!-- map -->
| map             = 
| map_image       = Antelope Island State Park Map.jpg
| map_size        = 
| map_caption     = Map of Antelope Island State Park
| relief          = 
<!-- location -->
| location        = [[Davis County, Utah]], [[Utah]], United States
| nearest_city    = 
| nearest_town    = 
| coordinates     = {{coord|40|57|00|N|112|12|36|W|scale:250000|display=inline,title}}
| coords_ref      = 
<!-- stats --> 
| length          = 
| length_mi       = 
| length_km       = 24
| width           = 
| width_mi        = 
| width_km        = 7.8
| area_km2        = 109
| area_ref        = 
| elevation       = 
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = 1969
| named_for       = 
| visitation_num  = 273618
| visitation_year = 2009
| visitation_ref  = <ref name="record">{{cite web | url = http://www.deseretnews.com/article/705356606/Antelope-Island-State-Park-raises-record-amount.html | title = Antelope Island State Park raises record amount | author = Doughery, Jospen M. | publisher = Deseret News | date = 2010-01-01 | accessdate = 2010-01-11| archiveurl= https://web.archive.org/web/20100115172245/http://www.deseretnews.com/article/705356606/Antelope-Island-State-Park-raises-record-amount.html| archivedate= 15 January 2010 | deadurl= no}}</ref>
| governing_body  = 
| administrator   = 
| operator        = [[Utah State Parks]]
| owner           =
<!-- website, embedded --> 
| website         = [http://stateparks.utah.gov/parks/antelope-island Utah State Parks: Antelope Island]
| embedded        = 
}}
  TEXT
    expect(parse_geobox_to_protected_area(text)).to eq(result)
  end
  
  it 'works for case 7' do
    text = <<~TEXT
{{About|the protected area|the volcanic phenomenon|Volcanic ash}}
{{Geobox|Protected Area
<!-- *** Name section *** -->
| name = Ashfall Fossil Beds <br>State Historical Park
| native_name =
| other_name =
| other_name1 =
<!-- *** Category *** -->
| category = [[List of Nebraska state parks#State historical parks|Nebraska State Park]]
| category_iucn = 
<!-- *** Image *** -->
| image = USA_ne_creighton_ashfallshp2.jpg
| image_caption = Hills surrounding the fossil beds
| image_size = 280
<!-- *** Etymology *** --->
| etymology_type =
| etymology =
<!-- *** Country etc. *** -->
| country = {{flag|United States}}
| state = {{flag|Nebraska}}
| region_type = County
| region = [[Antelope County, Nebraska|Antelope]]
| region1 =
| district_type = Nearest town
| district = [[Royal, Nebraska|Royal]]
| city =
| city1 =
<!-- *** Geography *** -->
| location = 
| coordinates = {{coord|42|25|30|N|98|09|31|W|display=inline,title}}
| coordinates_note = <ref name=gnis>{{cite gnis|1874448|Ashfall Fossil Beds State Historical Park}}</ref>
| elevation_imperial = 1722
| elevation_round =
| elevation_note = <ref name=gnis/>
| area_unit = acre
| area_imperial = 360
| area_round = 0
| area_note = 
| area1_imperial = | area1_type = 
| length_imperial = | length_orientation = 
| width_imperial = | width_orientation = 
| highest = | highest location =
| highest_elevation_imperial = 
| lowest = | lowest_location =
| lowest_elevation_imperial =
<!-- *** Nature *** -->
| biome = | biome_share = | biome1 =| biome1_share = 
| geology = | geology1 = | plant = | plant1 = | animal = | animal1 =
<!-- *** People *** -->
| established_type = Purchased
| established = 1986
| established_note =  
| established1_type = Opened
| established1 = 1991
| established1_note = 
| management_body = [[Nebraska Game and Parks Commission]]
| management_location = | management_elevation =
| visitation = | visitation_year =
<!-- *** Free fields *** -->
| free_type =  | free_label = | free =
| free1_type = | free1 = 
<!-- *** Map section *** -->
| map = Nebraska Locator Map.PNG
| map_caption = Location in Nebraska
| map_locator = Nebraska
| map_size = 280
| map_first =
<!-- *** Website *** -->
| website = [http://outdoornebraska.gov/ashfall/ Ashfall Fossil Beds <br>State Historical Park]
| footnotes = {{designation list |embed=yes |designation1=NNL |designation1_date=2006}}
}}
    TEXT
    result = <<~TEXT
{{About|the protected area|the volcanic phenomenon|Volcanic ash}}
{{Infobox protected area
| name            = Ashfall Fossil Beds <br>State Historical Park
| iucn_category   = 
<!-- images -->
| photo           = USA_ne_creighton_ashfallshp2.jpg
| photo_caption   = Hills surrounding the fossil beds
<!-- map -->
| map             = Nebraska
| map_image       = 
| map_size        = 280
| map_caption     = Location in Nebraska
| relief          = 
<!-- location -->
| location        = [[Royal, Nebraska|Royal]], [[Antelope County, Nebraska|Antelope]], [[Nebraska]], [[United States]]
| nearest_city    = 
| nearest_town    = 
| coordinates     = {{coord|42|25|30|N|98|09|31|W|display=inline,title}}
| coords_ref      = <ref name=gnis>{{cite gnis|1874448|Ashfall Fossil Beds State Historical Park}}</ref>
<!-- stats --> 
| length          = 
| length_mi       = 
| length_km       = 
| width           = 
| width_mi        = 
| width_km        = 
| area_acre       = 360
| area_ref        = 
| elevation       = {{convert|1722|ft|m|abbr=on}}<ref name=gnis/>
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = 1986
| named_for       = 
| visitation_num  = 
| visitation_year = 
| visitation_ref  = 
| governing_body  = [[Nebraska Game and Parks Commission]]
| administrator   = 
| operator        = 
| owner           =
<!-- website, embedded --> 
| website         = [http://outdoornebraska.gov/ashfall/ Ashfall Fossil Beds <br>State Historical Park]
| embedded        = {{designation list |embed=yes |designation1=NNL |designation1_date=2006}}
}}
  TEXT
    expect(parse_geobox_to_protected_area(text)).to eq(result)
  end
    
  it 'works for case 8' do
    text = <<~TEXT
{{Geobox|Protected Area
| name = Yuba State Park
| category =  [[Utah State Parks|Utah State Park]]
| image = Yuba State Park.jpg
| image_caption = Sunrise at Yuba State Park, July 2008
| country = {{flag|United States}}
| state = {{flag|Utah}}
| region_type = Counties
| location = [[Levan, Utah|Levan]]
| coordinates = {{coord|39|22|44|N|112|1|39|W|display=inline,title}}
| capital_coordinates = 
| mouth_coordinates = 
| elevation_imperial = 5100
| elevation_note = <ref name="About">{{deadlink|{{Cite web | title = Yuba State Park: About the Park | url = http://stateparks.utah.gov/parks/yuba/about | publisher = Utah State Parks | accessdate = 2011-02-12}}|date=February 2018}}</ref>
| area_unit = acre
| area_imperial = 15940
| area_note = <ref name="Plan">{{Cite web | title = Yuba State Park Resource Management Plan | url = http://static.stateparks.utah.gov/plans/YubaRMP09.pdf | publisher = Utah State Parks | date = May 2009 | accessdate = 2011-02-12}}</ref>
| established = February 15, 1964
| established_note = <ref name="Plan" />
| management = Utah State Parks
| visitation = 140965
| visitation_date = 2011
| visitation_note = <ref>{{cite web |title=Utah State Park 2011 Visitation |publisher=Utah State Parks Planning |url=http://static.stateparks.utah.gov/docs/SPVisitation2011.pdf |accessdate=28 May 2012}}</ref>
| map = Utah Locator Map with US.PNG 
| map_caption = Location of Yuba State Park in Utah
| map_locator = Utah
| category_iucn = V
}}
    TEXT
    result = <<~TEXT
{{Infobox protected area
| name            = Yuba State Park
| iucn_category   = V
<!-- images -->
| photo           = Yuba State Park.jpg
| photo_caption   = Sunrise at Yuba State Park, July 2008
<!-- map -->
| map             = Utah
| map_image       = 
| map_size        = 
| map_caption     = Location of Yuba State Park in Utah
| relief          = 
<!-- location -->
| location        = [[Utah]], [[United States]]
| nearest_city    = 
| nearest_town    = 
| coordinates     = {{coord|39|22|44|N|112|1|39|W|display=inline,title}}
| coords_ref      = 
<!-- stats --> 
| length          = 
| length_mi       = 
| length_km       = 
| width           = 
| width_mi        = 
| width_km        = 
| area_acre       = 15940
| area_ref        = <ref name="Plan">{{Cite web | title = Yuba State Park Resource Management Plan | url = http://static.stateparks.utah.gov/plans/YubaRMP09.pdf | publisher = Utah State Parks | date = May 2009 | accessdate = 2011-02-12}}</ref>
| elevation       = {{convert|5100|ft|m|abbr=on}}<ref name="About">{{deadlink|{{Cite web | title = Yuba State Park: About the Park | url = http://stateparks.utah.gov/parks/yuba/about | publisher = Utah State Parks | accessdate = 2011-02-12}}|date=February 2018}}</ref>
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = February 15, 1964<ref name="Plan" />
| named_for       = 
| visitation_num  = 140965
| visitation_year = 2011
| visitation_ref  = <ref>{{cite web |title=Utah State Park 2011 Visitation |publisher=Utah State Parks Planning |url=http://static.stateparks.utah.gov/docs/SPVisitation2011.pdf |accessdate=28 May 2012}}</ref>
| governing_body  = 
| administrator   = 
| operator        = Utah State Parks
| owner           =
<!-- website, embedded --> 
| website         = 
| embedded        = 
}}
  TEXT
    expect(parse_geobox_to_protected_area(text)).to eq(result)
  end
  
  # it 'works for case 8' do
  #   text = <<~TEXT
  # 
  #   TEXT
  #   result = <<~TEXT
  # 
  #TEXT
  #   expect(parse_geobox_to_protected_area(text)).to eq(result)
  # end
  
end

describe 'parse_geobox_to_castle' do  
  it 'works for first example' do
    text = <<~TEXT
{{Geobox|Building
<!-- *** Heading *** -->
| name                 = Castle of Alcácer do Sal
| native_name          = Castelo de Alcácer do Sal
| other_name           = 
| category             = [[Castle]]
| native_category      = Castelo
<!-- *** Image *** -->
| image                = Pousada do sado.jpg
| image_caption        = The impetuous view of the Castle on the hilltop overlooking the town and River Sado
| image_size           = 235
<!-- *** Names **** --> 
| official_name        = Castelo de Alcácer do Sal/Castelo e cerca urbana de Alcácer do Sal
| etymology            = [[Alcácer do Sal]]
| etymology_type       = Named for
| nickname             = 
<!-- *** Symbols *** -->
| flag                 = 
| symbol               = 
<!-- *** Country *** -->
| country              = {{flag|Portugal}}
| state_type           = Region
| state                = [[Lisboa Region|Lisboa]]
| region_type          = Subregion
| region               = [[Península de Setúbal]]
| district             = [[Setúbal (district)|Setúbal]]
| municipality         = [[Alcácer do Sal]]
<!-- *** Locations *** -->
| location             = [[Alcácer do Sal (Santa Maria do Castelo e Santiago) e Santa Susana]]
| elevation            = 
| prominence           =

| coordinates          = {{coord|38|22|21|N|8|30|50|W|display=inline,title}}
| capital_coordinates  = 
| mouth_coordinates    = 
| length               = 
| length_orientation   = Northwest to Southeast
| width                = 
| width_orientation    = Southwest to Northeast
| height               = 
| depth                = 
| volume               = 
| area                 = 
<!-- *** Features *** -->
| author_type          = Architects
| author               = 
| style                = [[Gothic architecture|Gothic]]
| material             = Taipa
| material1            = Masonry
| material2            = Stone
| material3            = Reinforced concrete
<!-- *** History & management *** -->
| established          = 12th century
| established_type     = Origin
| established1         = 
| established1_type    = Initiated
| established2         = 
| established2_type    = Completion
| date                 = 
| date_type            = 
| owner                = Portuguese Republic
<!-- *** Access *** -->
| public               = Private
| visitation           = 
| visitation_date      = 
| access               = Along the hill of the castle, on the ''Estrada do Bom Jesus dos Mártires'' to the north, along various paved areas starting from the centre of the town, along the south
<!-- *** UNESCO etc. *** -->
| whs_name             = 
| whs_year             = 
| whs_number           = 
| whs_region           = 
| whs_criteria         = 
| iucn_category        = 
<!-- *** Free fields *** -->
| free                 = [[IGESPAR|Instituto Gestão do Patrimonio Arquitectónico e Arqueológico]]
| free_type            = Management
| free1                = DRCAlentejo (Dispatch 829/2009, Diário da República, Série 2, 163 (24 August 2009)
| free1_type           = Operator
| free2                = 
| free2_type           = 
| free3                = 
| free3_type           = 
| free4                = '''National Monument'''<br>''Monumento Nacional''
| free4_type           = Status
| free5                = Decree 16 June 1910, Diário do Governo 136 (23 June 1910)
| free5_type           = Listing
<!-- *** Maps *** -->
| map                  = 
| map_caption          = Location of the castle within the municipality of [[Alcácer do Sal]]
| map_background       = 
| map_locator          = 
| map_locator_x        = 34
| map_locator_y        = 85
<!-- *** Website *** --> 
| commons              = Castelo de Alcácer do Sal
| website              =
<!-- *** Footnotes *** -->
| footnotes            =
}}
TEXT
    result = <<~TEXT
{{Infobox military installation
| name            = Castle of Alcácer do Sal
| ensign          = 
| ensign_size     =
| native_name     = Castelo de Alcácer do Sal
| type            = Castle
<!-- images -->
| image           = Pousada do sado.jpg
| caption         = The impetuous view of the Castle on the hilltop overlooking the town and River Sado
<!-- maps and coordinates -->
| image_map             = 
| map_caption           = Location of the castle within the municipality of [[Alcácer do Sal]]
| pushpin_map           = 
| pushpin_relief        = 
| pushpin_map_caption   =  
| coordinates           = {{coord|38|22|21|N|8|30|50|W|display=inline,title}}
| coordinates_footnotes = 
<!-- location -->
| partof           = 
| location         = [[Setúbal (district)|Setúbal]], [[Península de Setúbal]], [[Lisboa Region|Lisboa]]
| nearest_town     = 
| country          = {{flag|Portugal}}
<!-- stats -->
| ownership        = Portuguese Republic
| operator         = 
| open_to_public   = Private
| site_area        = 
| built            = 12th century
| used             = 
| builder          = 
| materials        = 
| height           = 
| length           = 
| fate             = 
| condition        = 
| battles          = 
| events           = 
| garrison         = 
| occupants        = 
| website          = 
| footnotes        = 
}}
TEXT
    expect(parse_geobox_to_castle(text)).to eq(result)
  end
  
  # it 'works for case 2' do
  #   text = <<~TEXT
  # 
  #   TEXT
  #   result = <<~TEXT
  # 
  #TEXT
  #   expect(parse_geobox_to_protected_area(text)).to eq(result)
  # end
  
end