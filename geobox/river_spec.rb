require '../geobox/geobox'
require '../helper'

include Geobox

describe 'parse_mouth_elevation' do
  it 'works for meters' do
    params = {
        'mouth_elevation'=> '123',
        'mouth_elevation_note' => 'fooo'
    }
    params.default = ''
    expect(parse_mouth_elevation(params)).to eq('{{convert|123|m|abbr=on}}fooo')
  end
  it 'works for ft' do
    params = {
        'mouth_elevation_imperial'=> '4568',
        'mouth_elevation_note' => 'bar'
    }
    params.default = ''
    expect(parse_mouth_elevation(params)).to eq('{{convert|4568|ft|abbr=on}}bar')
  end
  it 'raises an error if there is a unit provided' do
    params = {
        'mouth_elevation_unit' => 'FOOO',
        'mouth_elevation_imperial'=> '4568',
        'mouth_elevation_note' => 'bar'
    }
    params.default = ''
    expect{parse_mouth_elevation(params)}.to raise_error(Geobox::UnresolvedCase)
  end
end

describe 'parse_watershed' do
  it 'works for km2' do
    params = {
        'watershed'=> '123',
        'watershed_note' => 'fooo'
    }
    params.default = ''
    expect(parse_watershed(params)).to eq('{{convert|123|km2|abbr=on}}fooo')
  end
  it 'works for sqmi' do
    params = {
        'watershed_imperial'=> '4568',
        'watershed_note' => 'bar'
    }
    params.default = ''
    expect(parse_watershed(params)).to eq('{{convert|4568|sqmi|abbr=on}}bar')
  end
  it 'raises an error if there is a unit provided' do
    params = {
        'watershed_unit' => 'FOOO',
        'watershed_imperial'=> '4568',
        'watershed_note' => 'bar'
    }
    params.default = ''
    expect{parse_watershed(params)}.to raise_error(Geobox::UnresolvedCase)
  end
end

describe 'parse_source_elevation' do
  it 'works for meters' do
    params = {
        'source1_elevation'=> '123',
        'source2_elevation'=> '456',
        'source2_elevation_note'=> 'foo',
        'source3_elevation'=> '789',
        'source3_elevation_unit'=> 'UNIT'
    }
    params.default = ''
    expect(parse_source_elevation(params, 'source2')).to eq('{{convert|456|m|abbr=on}}foo')
  end
  it 'works for ft' do
    params = {
        'source1_elevation'=> '123',
        'source2_elevation'=> '456',
        'source2_elevation_note'=> 'foo',
        'source3_elevation_imperial'=> '789',
        'source3_elevation_note'=> 'bar'
    }
    params.default = ''
    expect(parse_source_elevation(params, 'source3')).to eq('{{convert|789|ft|abbr=on}}bar')
  end
  it 'raises an error if there is a unit provided' do
    params = {
        'source1_elevation'=> '123',
        'source2_elevation'=> '456',
        'source2_elevation_note'=> 'foo',
        'source3_elevation_imperial'=> '789',
        'source3_elevation_note'=> 'bar',
        'source3_elevation_unit'=> 'UNIT'
    }
    params.default = ''
    expect{parse_source_elevation(params, 'source3')}.to raise_error(Geobox::UnresolvedCase)
  end
end

describe 'parse_river_location' do
  it 'works for source1' do
    params = {
        'source1_location'=> '[[my house]]',
        'source1_municipality'=> '[[LA]]',
        'source1_region'=> '[[SOCAL]]',
        'source1_country' => '[[USA]]',
        'source2_district'=> 'FOO',
        'source_state'=> 'Virginia'
    }
    params.default = ''
    expect(parse_river_location(params, 'source1')).to eq('[[my house]], [[LA]], [[SOCAL]], [[USA]]')
  end
  it 'works for mouth' do
    params = {
        'source1_location'=> 'my house',
        'source1_municipality'=> 'LA',
        'source1_region'=> 'SOCAL',
        'source1_country' => 'USA',
        'source2_district'=> 'FOO',
        'mouth_state'=> '[[Virginia]]',
        'mouth_country'=> '[[USA]]'
    }
    params.default = ''
    expect(parse_river_location(params, 'mouth')).to eq('[[Virginia]], [[USA]]')
  end
end

describe 'parse_discharge_rate' do
  it 'works for cbm' do
    params = {
        'discharge_min'=> '123',
        'discharge_min_note' => 'fooo'
    }
    params.default = ''
    expect(parse_discharge_rate(params, 'discharge', 'min')).to eq('{{convert|123|m3/s|cuft/s|abbr=on}}fooo')
  end
  it 'works for cbft' do
    params = {
        'discharge_min_imperial'=> '123',
        'discharge_min_note' => 'fooo'
    }
    params.default = ''
    expect(parse_discharge_rate(params, 'discharge', 'min')).to eq('{{convert|123|cuft/s|m3/s|abbr=on}}fooo')
  end
  
  it 'raises an error if there is a unit provided' do
    params = {
        'discharge_min_unit'=> '123',
        'discharge_min_imperial'=> '123',
        'discharge_min_note' => 'fooo'
    }
    params.default = ''
    expect{parse_discharge_rate(params, 'discharge', 'min')}.to raise_error(Geobox::UnresolvedCase)
  end
  it 'raises an error if there is a unit provided 2' do
    params = {
        'discharge_unit'=> '123',
        'discharge_min_imperial'=> '123',
        'discharge_min_note' => 'fooo'
    }
    params.default = ''
    expect{parse_discharge_rate(params, 'discharge', 'min')}.to raise_error(Geobox::UnresolvedCase)
  end
end

describe 'parse_multi_location' do
  it 'works for country' do
    params = {
        'country'=> 'USA',
        'country1' => '[[Canadia]]',
        'country1_note' => '<ref>Google</ref>',
        'country2_note' => 'Says john',
        'country3' => '[[France]]',
    }
    params.default = ''
    expect(parse_multi_location(params, 'country')).to eq('{{subst:#ifexist:USA|[[USA]]|USA}}, [[Canadia]]<ref>Google</ref>, [[France]]')
  end
  it 'works for country' do
    params = {
        'country'=> 'USA',
        'country1' => 'Canadia',
        'country1_note' => '<ref>Google</ref>',
        'country2_note' => 'Says john',
        'country3' => 'France',
        'region'=> '[[So Cal]]',
        'region1' => '[[LA Area]]',
        'region1_note' => '<ref>Google</ref>',
        'region4_note' => 'Says john',
        'region3' => '[[SBC]]',
    }
    params.default = ''
    expect(parse_multi_location(params, 'region')).to eq('[[So Cal]], [[LA Area]]<ref>Google</ref>, [[SBC]]')
  end

end

describe 'parse_city' do
  it 'raises an error if both municipality and city are provided' do
    params = {
        'city'=> 'USA',
        'municipality' => 'Canadia',
    }
    params.default = ''
    expect{parse_city(params)}.to raise_error(Geobox::UnresolvedCase)
  end
  it 'returns empty string if both are empty' do
    params = {
        'country'=> 'USA',
        'state' => 'Canadia',
    }
    params.default = ''
    expect(parse_city(params)).to eq('')
  end
  it 'works for city' do
    params = {
        'city'=> '[[SB]]',
        'city1' => '[[Chicago]]',
        'city1_note' => '<ref>Google</ref>',
        'city2_note' => 'Says john',
        'city4' => '[[Los Angeles]]',
        'region'=> 'So Cal',
        'region1' => 'LA Area',
        'region1_note' => '<ref>Google</ref>',
        'region4_note' => 'Says john',
        'region3' => 'SBC',
    }
    params.default = ''
    expect(parse_city(params)).to eq('[[SB]], [[Chicago]]<ref>Google</ref>, [[Los Angeles]]')
  end
  it 'works for municipality' do
    params = {
        'municipality'=> '[[SB]]',
        'municipality1' => '[[Chicago]]',
        'municipality1_note' => '<ref>Google</ref>',
        'municipality2_note' => 'Says john',
        'municipality4' => '[[Los Angeles]]',
        'region'=> 'So Cal',
        'region1' => 'LA Area',
        'region1_note' => '<ref>Google</ref>',
        'region4_note' => 'Says john',
        'region3' => 'SBC',
    }
    params.default = ''
    expect(parse_city(params)).to eq('[[SB]], [[Chicago]]<ref>Google</ref>, [[Los Angeles]]')
  end
end

describe 'parse_city_type' do
  it 'raises an error if both municipality and city are provided' do
    params = {
        'city'=> 'USA',
        'municipality' => 'Canadia',
    }
    params.default = ''
    expect{parse_city_type(params)}.to raise_error(Geobox::UnresolvedCase)
  end
  it 'returns empty string if both are empty' do
    params = {
        'country'=> 'USA',
        'state' => 'Canadia',
    }
    params.default = ''
    expect(parse_city_type(params)).to eq('')
  end
  it 'works for Cities' do
    params = {
        'city'=> 'SB',
        'city1' => 'Chicago'
    }
    params.default = ''
    expect(parse_city_type(params)).to eq('Cities')
  end
  it 'works for city' do
    params = {
        'city'=> 'SB'
    }
    params.default = ''
    expect(parse_city_type(params)).to eq('City')
  end
  it 'works for custom city type' do
    params = {
        'city'=> 'SB',
        'city_type'=> 'CITY TYPE',
    }
    params.default = ''
    expect(parse_city_type(params)).to eq('CITY TYPE')
  end
  it 'works for municipality' do
    params = {
        'municipality'=> 'SB',
        'municipality1' => 'Chicago'
    }
    params.default = ''
    expect(parse_city_type(params)).to eq('Municipalities')
  end
  it 'works for municipality' do
    params = {
        'municipality'=> 'SB'
    }
    params.default = ''
    expect(parse_city_type(params)).to eq('Municipality')
  end
  it 'works for custom municipality type' do
    params = {
        'municipality_type'=> 'MY TYPE',
        'municipality'=> 'SB',
    }
    params.default = ''
    expect(parse_city_type(params)).to eq('MY TYPE')
  end
end

describe 'parse_other_name' do
  it 'works for no other name' do
    params = {
        'other_name_note'=> 'SB',
        'city1' => 'Chicago'
    }
    params.default = ''
    expect(parse_other_name(params)).to eq('')
  end
  it 'works for 1 other name' do
    params = {
        'other_name_note'=> 'SB',
        'other_name' => 'Chicago'
    }
    params.default = ''
    expect(parse_other_name(params)).to eq('ChicagoSB')
  end
  it 'works for 3 other name' do
    params = {
        'other_name' => 'Chicago',
        'other_name1_note'=> 'DD',
        'other_name1' => 'France',
        'other_name3_note'=> '333',
        'other_name4' => 'GGG'
    }
    params.default = ''
    expect(parse_other_name(params)).to eq('Chicago, FranceDD, GGG')
  end
end

describe 'autolink' do
  it 'works for basic case' do 
    expect(autolink('FOO')).to eq('{{subst:#ifexist:FOO|[[FOO]]|FOO}}')
  end
  it 'returns nil for emtpy value' do
    expect(autolink('')).to eq('')
    expect(autolink(nil)).to eq('')
  end
  it 'returns original value for a link' do
    expect(autolink('[[United States]]')).to eq('[[United States]]')
  end
end

describe 'parse_geobox_to_river' do
  it 'works for case 1' do
    text = <<~TEXT
{{Geobox|River|category_hide=yes
<!-- *** Name section *** -->  
| name                        = 
| other_name                  = 
| other_name1                 = 
| other_name2                 = 
| etymology                   = [[Algonquin language]]
<!-- *** Map section *** -->
| pushpin_map = Canada Ontario
| pushpin_map_relief = 1
| pushpin_map_caption = Location of the mouth of the Abitibi River in Ontario
<!-- General section *** -->
| country                     = Canada
| country_flag                = true
| state                       = Ontario
| state_flag                  = true
| state_type                  = Province
| region                      = [[Cochrane District, Ontario|Cochrane District]]
| length                      = 540
| length_round                = 0
| length_note                 = to head of Lac Loïs <ref name="AtCa">[http://atlas.nrcan.gc.ca/site/english/learningresources/facts/rivers.html Atlas of Canada] {{webarchive|url=https://web.archive.org/web/20070404000000/http://atlas.nrcan.gc.ca/site/english/learningresources/facts/rivers.html |date=2007-04-04 }}</ref>
| watershed                   = 29500
| watershed_round             = -2
| watershed_note              = <ref name="AtCa"/>
| discharge_location          = 
| discharge                   = 
| discharge_round             = 
| discharge_note              = 
| discharge_max_month         = 
| discharge_max               = 
| discharge_min_month         = 
| discharge_min               = 
| discharge1_location         =
| discharge1                  =
<!-- *** Source *** -->
| source                      = Lake Abitibi
| source_location             = 38 km east of [[Iroquois Falls, Ontario|Iroquois Falls]]
| source_district             = 
| source_state                = 
| source_country              = 
| source_elevation            = 
| source_coordinates          = {{coord|48|47|06|N|80|10|23|W}}
<!-- *** Mouth *** -->
| mouth_name                  = [[Moose River (Ontario)|Moose River]]
| mouth_location              = 30 km SSW from [[Moosonee, Ontario|Moosonee]]
| mouth_region                = 
| mouth_state                 = 
| mouth_country               = 
| mouth_elevation             = 
| mouth_coordinates          = {{coord|51|04|17|N|80|55|32|W|display=inline,title}}
<!-- *** Tributaries *** -->
| tributary_left              = [[Black River (Abitibi River)|Black River]]
| tributary_left1             = Frederick House River
| tributary_right             = Sucker River
| tributary_right1            = Little Abitibi River
<!-- *** Image *** --->
| image                       = Abitibi River.JPG
| image_size                  = 
| image_caption               = Abitibi River at Iroquois Falls
}}
    TEXT
    result = <<~TEXT
{{Infobox river
| name               = {{subst:PAGENAME}}
| name_native        = 
| name_native_lang   = 
| name_other         = 
| name_etymology     = [[Algonquin language]]
<!---------------------- IMAGE & MAP -->
| image              = Abitibi River.JPG
| image_caption      = Abitibi River at Iroquois Falls
| map                = 
| map_size           = 
| map_caption        = 
| pushpin_map        = Canada Ontario
| pushpin_map_size   = 
| pushpin_map_caption= Location of the mouth of the Abitibi River in Ontario
<!---------------------- LOCATION -->
| subdivision_type1  = Country
| subdivision_name1  = {{subst:#ifexist:Canada|[[Canada]]|Canada}}
| subdivision_type2  = Province
| subdivision_name2  = {{subst:#ifexist:Ontario|[[Ontario]]|Ontario}}
| subdivision_type3  = Region
| subdivision_name3  = [[Cochrane District, Ontario|Cochrane District]]
| subdivision_type4  = 
| subdivision_name4  = 
| subdivision_type5  = 
| subdivision_name5  = 
<!---------------------- PHYSICAL CHARACTERISTICS -->
| length             = {{convert|540|km|mi|abbr=on}}to head of Lac Loïs <ref name="AtCa">[http://atlas.nrcan.gc.ca/site/english/learningresources/facts/rivers.html Atlas of Canada] {{webarchive|url=https://web.archive.org/web/20070404000000/http://atlas.nrcan.gc.ca/site/english/learningresources/facts/rivers.html |date=2007-04-04 }}</ref> 
| width_min          = 
| width_avg          = 
| width_max          = 
| depth_min          = 
| depth_avg          = 
| depth_max          = 
| discharge1_location= 
| discharge1_min     = 
| discharge1_avg     = 
| discharge1_max     = 
<!---------------------- BASIN FEATURES -->
| source1            = {{subst:#ifexist:Lake Abitibi|[[Lake Abitibi]]|Lake Abitibi}}
| source1_location   = 38 km east of [[Iroquois Falls, Ontario|Iroquois Falls]]
| source1_coordinates= {{coord|48|47|06|N|80|10|23|W}}
| source1_elevation  = 
| mouth              = [[Moose River (Ontario)|Moose River]]
| mouth_location     = 30 km SSW from [[Moosonee, Ontario|Moosonee]]
| mouth_coordinates  = {{coord|51|04|17|N|80|55|32|W|display=inline,title}}
| mouth_elevation    = 
| progression        = 
| river_system       = 
| basin_size         = {{convert|29500|km2|abbr=on}}<ref name="AtCa"/>
| tributaries_left   = [[Black River (Abitibi River)|Black River]], {{subst:#ifexist:Frederick House River|[[Frederick House River]]|Frederick House River}}
| tributaries_right  = {{subst:#ifexist:Sucker River|[[Sucker River]]|Sucker River}}, {{subst:#ifexist:Little Abitibi River|[[Little Abitibi River]]|Little Abitibi River}}
| custom_label       = 
| custom_data        = 
| extra              = 
}}
  TEXT
    expect(parse_geobox_to_river(text)).to eq(result)
  end

  it 'works for case 2' do
    text = <<~TEXT
{{Geobox | River
<!-- *** Name section *** --> 
| name = Abiqua Creek
| category = Creek
| category_hide = 1
<!-- *** Image *** --->
| image = Lower abiqua creek.jpg
| image_size = 300px
| image_caption = Abiqua Creek from Oregon Route 214
<!-- *** Etymology *** --->
| etymology = Possibly from a [[Kalapuyan languages|Kalapuyan]] word for "hazelnut"<ref name="Bright">{{cite book
  | last = Bright
  | first = William
  | title = Native American Placenames of the United States
  | publisher = University of Oklahoma Press
  | year = 2004
  | location = Norman, Oklahoma
  | url = https://books.google.com/books?id=5XfxzCm1qa4C&pg=PA34&lpg=PA34&dq=alsea+etymology&source=web&ots=ZRcBq5nnxq&sig=7Z-GLVpNRDf9U9_ZTVMuW0zNMAo&hl=en&sa=X&oi=book_result&resnum=8&ct=result#PPA20,M1
  | isbn = 978-0-8061-3598-4
  | accessdate = 2008-08-03
  | page = 20}}</ref>
<!-- *** Country etc. *** -->
| country = United States
| country_flag = 1
| state = Oregon
| district_type = County
| district = [[Marion County, Oregon|Marion]]
<!-- *** Source *** -->
| source = 
| source_location = [[Cascade Range]] foothills
| source_region = [[Marion County, Oregon|Marion County]]
| source_state = [[Oregon]]
| source_elevation_imperial = 3331
| source_elevation_note = <ref name="source">Source elevation derived from [[Google Earth]] search using GNIS source coordinates.</ref> 
| source_length_imperial = 
| source_coordinates = {{coord|44|52|32|N|122|24|29|W|display=inline}}
| source_coordinates_note = <ref name="gnis"/>
<!-- *** Mouth *** -->
| mouth_name = [[Pudding River]] 
| mouth_location = near [[Silverton, Oregon|Silverton]]
| mouth_district = 
| mouth_region = [[Marion County, Oregon|Marion County]]
| mouth_state = [[Oregon]]
| mouth_country = 
| mouth_note = 
| capital_coordinates = 
| mouth_coordinates = {{coord|45|02|10|N|122|49|56|W|display=inline,title}}
| mouth_coordinates_note = <ref name="gnis"/>
| mouth_elevation_imperial = 154
| mouth_elevation_note = <ref name="gnis">{{cite web | work = [[Geographic Names Information System]] (GNIS)| publisher = [[United States Geological Survey]] (USGS) | date = 1980-11-28 | url = {{gnis3|1116756}} | title = Abiqua Creek | accessdate = 2008-07-28}}.</ref>
<!-- *** Geography *** -->
| length_imperial = 29
| length_round = 0
| length_note = <ref name="nationalmap"/>
| watershed_imperial = 78
| watershed_round = 1
| watershed_note = <ref>{{cite web|author1 =Pudding River Watershed Council|author2= Adolfson Associates|author3= Alsea Geospatial|title = Pudding River Watershed Assessment, 2006 |publisher = Oregon Department of Fish and Wildlife |url = https://nrimp.dfw.state.or.us/DataClearinghouse/default.aspx?pn=viewrecord&XMLname=669.xml|accessdate = October 14, 2011}}</ref>
| discharge_location = 
| discharge_round = 2
| discharge_imperial = 
| discharge_note = 
| discharge_min_imperial = 0
| discharge_max_imperial = 
| discharge1_location = 
| discharge1_imperial = 
| discharge1_note = 
<!-- *** Map section *** -->
| map = 
| map_size = 
| map_caption = 
| pushpin_map = USA Oregon
| pushpin_map_relief = 1
| pushpin_map_size = 300
| pushpin_map_caption = Location of the mouth of Abiqua Creek in Oregon
<!-- *** Websites *** -->
| commons = 
}}
    TEXT
    result = <<~TEXT
{{Infobox river
| name               = Abiqua Creek
| name_native        = 
| name_native_lang   = 
| name_other         = 
| name_etymology     = Possibly from a [[Kalapuyan languages|Kalapuyan]] word for "hazelnut"<ref name="Bright">{{cite book
  | last = Bright
  | first = William
  | title = Native American Placenames of the United States
  | publisher = University of Oklahoma Press
  | year = 2004
  | location = Norman, Oklahoma
  | url = https://books.google.com/books?id=5XfxzCm1qa4C&pg=PA34&lpg=PA34&dq=alsea+etymology&source=web&ots=ZRcBq5nnxq&sig=7Z-GLVpNRDf9U9_ZTVMuW0zNMAo&hl=en&sa=X&oi=book_result&resnum=8&ct=result#PPA20,M1
  | isbn = 978-0-8061-3598-4
  | accessdate = 2008-08-03
  | page = 20}}</ref>
<!---------------------- IMAGE & MAP -->
| image              = Lower abiqua creek.jpg
| image_caption      = Abiqua Creek from Oregon Route 214
| map                = 
| map_size           = 300
| map_caption        = 
| pushpin_map        = USA Oregon
| pushpin_map_size   = 300
| pushpin_map_caption= Location of the mouth of Abiqua Creek in Oregon
<!---------------------- LOCATION -->
| subdivision_type1  = Country
| subdivision_name1  = {{subst:#ifexist:United States|[[United States]]|United States}}
| subdivision_type2  = State
| subdivision_name2  = {{subst:#ifexist:Oregon|[[Oregon]]|Oregon}}
| subdivision_type3  = 
| subdivision_name3  = 
| subdivision_type4  = County
| subdivision_name4  = [[Marion County, Oregon|Marion]]
| subdivision_type5  = 
| subdivision_name5  = 
<!---------------------- PHYSICAL CHARACTERISTICS -->
| length             = {{convert|29|mi|km|abbr=on}}<ref name="nationalmap"/> 
| width_min          = 
| width_avg          = 
| width_max          = 
| depth_min          = 
| depth_avg          = 
| depth_max          = 
| discharge1_location= 
| discharge1_min     = {{convert|0|cuft/s|m3/s|abbr=on}}
| discharge1_avg     = 
| discharge1_max     = 
<!---------------------- BASIN FEATURES -->
| source1            = 
| source1_location   = [[Cascade Range]] foothills, [[Marion County, Oregon|Marion County]], [[Oregon]]
| source1_coordinates= {{coord|44|52|32|N|122|24|29|W|display=inline}}<ref name="gnis"/>
| source1_elevation  = {{convert|3331|ft|abbr=on}}<ref name="source">Source elevation derived from [[Google Earth]] search using GNIS source coordinates.</ref>
| mouth              = [[Pudding River]]
| mouth_location     = near [[Silverton, Oregon|Silverton]], [[Marion County, Oregon|Marion County]], [[Oregon]]
| mouth_coordinates  = {{coord|45|02|10|N|122|49|56|W|display=inline,title}}<ref name="gnis"/>
| mouth_elevation    = {{convert|154|ft|abbr=on}}<ref name="gnis">{{cite web | work = [[Geographic Names Information System]] (GNIS)| publisher = [[United States Geological Survey]] (USGS) | date = 1980-11-28 | url = {{gnis3|1116756}} | title = Abiqua Creek | accessdate = 2008-07-28}}.</ref>
| progression        = 
| river_system       = 
| basin_size         = {{convert|78|sqmi|abbr=on}}<ref>{{cite web|author1 =Pudding River Watershed Council|author2= Adolfson Associates|author3= Alsea Geospatial|title = Pudding River Watershed Assessment, 2006 |publisher = Oregon Department of Fish and Wildlife |url = https://nrimp.dfw.state.or.us/DataClearinghouse/default.aspx?pn=viewrecord&XMLname=669.xml|accessdate = October 14, 2011}}</ref>
| tributaries_left   = 
| tributaries_right  = 
| custom_label       = 
| custom_data        = 
| extra              = 
}}
  TEXT
    expect(parse_geobox_to_river(text)).to eq(result)
  end

  it 'works for case 3' do
    text = <<~TEXT
{{Geobox | River
<!-- *** Name section *** -->  
| name                        = Allagash River
| native_name                 = 
| category                    = River
| category_hide               = Yes
<!-- *** Image *** --->
| image                       = Allagash_River_2003.jpg
| image_size                  = 250
| image_caption               = 
<!-- *** Etymology *** --->
| etymology                   = 
<!-- *** Country etc. *** -->
| country                     = {{USA}}
| state                       = [[Maine]]
| region                      = [[New England]]
| district                    = 
| district1                   = 
<!-- *** Geography *** -->
| length_imperial             = 65
| watershed_imperial          = 1479 
| discharge_location          = [[river mile]] 3, near Allagash, ME
| discharge_imperial          = 1967
| discharge_max_imperial      = 40900 
| discharge_min_imperial      = 87
| discharge1_location         = 
| discharge1_imperial         = 
<!-- *** Source *** -->
| source_name                 = [[Churchill Lake (Maine)|Churchill Lake]]
| source_location             = 
| source_district             = 
| source_coordinates          = {{coord|46|29|33|N|69|17|17|W|display=inline}}
| source_elevation_imperial   = 930
| source_length_imperial      = 
<!-- *** Mouth *** -->
| mouth_name                  = [[Saint John River (Bay of Fundy)|Saint John River]]
| mouth_location              =
| mouth_district              =
| capital_coordinates         = 
| mouth_coordinates           = {{coord|47|05|8|N|69|02|38|W|display=inline,title}}
| mouth_elevation_imperial    = 591 
<!-- *** Tributaries *** -->
| tributary_left              = 
| tributary_left1             = 
| tributary_right             = 
| tributary_right1            = 
<!-- *** Free fields *** -->
| free_name                   =  
| free_value                  = 
<!-- *** Map section *** -->
| map                         = 
| map_size                    =   
| map_caption                 =
| footnotes = {{Designation list
| embed                   = yes
| designation1            = nwsr
| designation1_partof     = [[Allagash Wilderness Waterway]]
| designation1_type       = Wild
| designation1_date       = July 19, 1970
| designation1_number     =
}}
}}
    TEXT
    result = <<~TEXT
{{Infobox river
| name               = Allagash River
| name_native        = 
| name_native_lang   = 
| name_other         = 
| name_etymology     = 
<!---------------------- IMAGE & MAP -->
| image              = Allagash_River_2003.jpg
| image_caption      = 
| map                = 
| map_size           = 
| map_caption        = 
| pushpin_map        = 
| pushpin_map_size   = 
| pushpin_map_caption= 
<!---------------------- LOCATION -->
| subdivision_type1  = Country
| subdivision_name1  = [[United States]]
| subdivision_type2  = State
| subdivision_name2  = [[Maine]]
| subdivision_type3  = Region
| subdivision_name3  = [[New England]]
| subdivision_type4  = 
| subdivision_name4  = 
| subdivision_type5  = 
| subdivision_name5  = 
<!---------------------- PHYSICAL CHARACTERISTICS -->
| length             = {{convert|65|mi|km|abbr=on}} 
| width_min          = 
| width_avg          = 
| width_max          = 
| depth_min          = 
| depth_avg          = 
| depth_max          = 
| discharge1_location= [[river mile]] 3, near Allagash, ME
| discharge1_min     = {{convert|87|cuft/s|m3/s|abbr=on}}
| discharge1_avg     = {{convert|1967|cuft/s|m3/s|abbr=on}}
| discharge1_max     = {{convert|40900|cuft/s|m3/s|abbr=on}}
<!---------------------- BASIN FEATURES -->
| source1            = [[Churchill Lake (Maine)|Churchill Lake]]
| source1_location   = 
| source1_coordinates= {{coord|46|29|33|N|69|17|17|W|display=inline}}
| source1_elevation  = {{convert|930|ft|abbr=on}}
| mouth              = [[Saint John River (Bay of Fundy)|Saint John River]]
| mouth_location     = 
| mouth_coordinates  = {{coord|47|05|8|N|69|02|38|W|display=inline,title}}
| mouth_elevation    = {{convert|591|ft|abbr=on}}
| progression        = 
| river_system       = 
| basin_size         = {{convert|1479|sqmi|abbr=on}}
| tributaries_left   = 
| tributaries_right  = 
| custom_label       = 
| custom_data        = 
| extra              = {{Designation list
| embed                   = yes
| designation1            = nwsr
| designation1_partof     = [[Allagash Wilderness Waterway]]
| designation1_type       = Wild
| designation1_date       = July 19, 1970
| designation1_number     =
}}
}}
  TEXT
    expect(parse_geobox_to_river(text)).to eq(result)
  end

  it 'works for case 4' do
    text = <<~TEXT
{{Geobox|River
<!-- *** Heading *** -->
| name = Back River
| native_name = 
| other_name = 
| category = River
| category_hide = yes
<!-- *** Names **** --> 
| etymology = Named after [[George Back]]
| nickname = 
<!-- *** Image *** -->
| image = Back River (July 2006).jpg
| image_caption = Rock garden on the Back River in July 2006
| image_size =
<!-- *** Country *** -->
| country = Canada
| state = Nunavut & Northwest Territories
| state_type = Territories
| region = 
| district = 
| municipality = 
<!-- *** Family *** -->
| parent =
| tributary_left =
| tributary_right = 
| city = 
| landmark = 
<!-- *** River locations *** -->
| source = Unnamed lake
| source_location = [[North Slave Region]]| source_region = Northwest Territories| source_country =
| source_elevation = 382
| source_coordinates = {{coord|64|29|11|N|108|13|54|W|display=inline}}
| source1 = 
| source1_location =| source1_region =| source1_country =
| source1_elevation = 
| source_confluence = 
| source_confluence_location =| source_confluence_region =| source_confluence_country =
| source_confluence_elevation = 
| mouth = [[Chantrey Inlet]], [[Arctic Ocean]]
| mouth_location = [[Kitikmeot Region]]| mouth_region = Nunavut| mouth_country =
| mouth_elevation = 0
<!-- Coordinates per Geographical Names Database of Geographical Names of Canada - see reference; elevation at these coordinates -->
| capital_coordinates = 
| mouth_coordinates = {{coord|67|16|00|N|95|15|00|W|display=inline,title}}
| length = 974
| width = 
| depth = 
| volume =
| watershed = 106500
| discharge = 612
| discharge_max =
| discharge_min =
<!-- *** Maps *** -->
| pushpin_map = Canada
| pushpin_map_size = 300
| pushpin_map_relief = 1
| pushpin_map_caption = Back River mouth location in Canada
<!-- *** Website *** --> 
| website =
| commons =
<!-- *** Footnotes *** -->
| footnotes = <ref>{{cite web
| title = Natural Resources Canada-Canadian Geographical Names (Back River)
| url = http://www4.rncan.gc.ca/search-place-names/unique/LABWP
| date = 
| accessdate =2014-08-29}}</ref><ref name= "Atlas of Canada">{{cite web
| title =Atlas of Canada Toporama
| url =http://atlas.nrcan.gc.ca/site/english/toporama/index.html
| date = 
| accessdate =2014-08-29}}</ref>
}}
    TEXT
    result = <<~TEXT
{{Infobox river
| name               = Back River
| name_native        = 
| name_native_lang   = 
| name_other         = 
| name_etymology     = Named after [[George Back]]
<!---------------------- IMAGE & MAP -->
| image              = Back River (July 2006).jpg
| image_caption      = Rock garden on the Back River in July 2006
| map                = 
| map_size           = 300
| map_caption        = 
| pushpin_map        = Canada
| pushpin_map_size   = 300
| pushpin_map_caption= Back River mouth location in Canada
<!---------------------- LOCATION -->
| subdivision_type1  = Country
| subdivision_name1  = {{subst:#ifexist:Canada|[[Canada]]|Canada}}
| subdivision_type2  = Territories
| subdivision_name2  = {{subst:#ifexist:Nunavut & Northwest Territories|[[Nunavut & Northwest Territories]]|Nunavut & Northwest Territories}}
| subdivision_type3  = 
| subdivision_name3  = 
| subdivision_type4  = 
| subdivision_name4  = 
| subdivision_type5  = 
| subdivision_name5  = 
<!---------------------- PHYSICAL CHARACTERISTICS -->
| length             = {{convert|974|km|mi|abbr=on}} 
| width_min          = 
| width_avg          = 
| width_max          = 
| depth_min          = 
| depth_avg          = 
| depth_max          = 
| discharge1_location= 
| discharge1_min     = 
| discharge1_avg     = {{convert|612|m3/s|cuft/s|abbr=on}}
| discharge1_max     = 
<!---------------------- BASIN FEATURES -->
| source1            = {{subst:#ifexist:Unnamed lake|[[Unnamed lake]]|Unnamed lake}}
| source1_location   = [[North Slave Region]], {{subst:#ifexist:Northwest Territories|[[Northwest Territories]]|Northwest Territories}}
| source1_coordinates= {{coord|64|29|11|N|108|13|54|W|display=inline}}
| source1_elevation  = {{convert|382|m|abbr=on}}
| mouth              = [[Chantrey Inlet]], [[Arctic Ocean]]
| mouth_location     = [[Kitikmeot Region]], {{subst:#ifexist:Nunavut|[[Nunavut]]|Nunavut}}
| mouth_coordinates  = {{coord|67|16|00|N|95|15|00|W|display=inline,title}}
| mouth_elevation    = {{convert|0|m|abbr=on}}
| progression        = 
| river_system       = 
| basin_size         = {{convert|106500|km2|abbr=on}}
| tributaries_left   = 
| tributaries_right  = 
| custom_label       = 
| custom_data        = 
| extra              = <ref>{{cite web
| title = Natural Resources Canada-Canadian Geographical Names (Back River)
| url = http://www4.rncan.gc.ca/search-place-names/unique/LABWP
| date = 
| accessdate =2014-08-29}}</ref><ref name= "Atlas of Canada">{{cite web
| title =Atlas of Canada Toporama
| url =http://atlas.nrcan.gc.ca/site/english/toporama/index.html
| date = 
| accessdate =2014-08-29}}</ref>
}}
  TEXT
    expect(parse_geobox_to_river(text)).to eq(result)
  end

  it 'works for case 5' do
    text = <<~TEXT
{{Geobox|River
<!-- *** Heading *** -->
| name = Big Tujunga Creek
| native_name = 
| other_name = Tujunga Creek
| other_name1 = Tujunga River
| other_name2 = Tujunga Wash
| category = 
<!-- *** Names **** --> 
| etymology = 
| nickname = 
<!-- *** Image *** -->
| image =Big_Tujunga_Canyon_View_of_River_and_Tujunga.JPG
| image_caption =The wash in lower Big Tujunga Canyon
| image_size =
<!-- *** Country *** -->
| country = United States
| state = California
| region = 
| district = 
| municipality = 
<!-- *** Family *** -->
| parent =
| tributary_left = Lucas Creek
| tributary_left1 = [[Clear Creek (Big Tujunga Creek)|Clear Creek]]
| tributary_right = [[Alder Creek (Los Angeles County, California)|Alder Creek]]
| tributary_right1 = [[Mill Creek (Los Angeles County, California)|Mill Creek]]
| tributary_right2 = [[Fox Creek (Big Tujunga Creek)|Fox Creek]]
| tributary_right3 = Trail Canyon Creek
| city = [[Sunland-Tujunga, Los Angeles|Sunland]]
| city1 = [[Shadow Hills, Los Angeles|Shadow Hills]]
| landmark = 
| river =
<!-- *** River locations *** -->
| source = About {{convert|1.6|mi|km}} south-southeast of Mount Mooney
| source_location = [[San Gabriel Mountains]]| source_region = | source_country =
| source_elevation_imperial = 5768
| source_coordinates = {{coord|34|17|52|N|118|00|11|W|display=inline}}
| source_coordinates_note = <ref>{{cite gnis|id=252292|name=Big Tujunga Creek|entrydate=1991-01-04|accessdate=2011-02-05}}</ref>
| mouth = [[Tujunga Wash]]
| mouth_location = Upstream of [[Hansen Dam]]| mouth_region = | mouth_country =
| mouth_elevation_imperial = 1070
| capital_coordinates = 
| mouth_coordinates = {{coord|34|16|05|N|118|21|50|W|display=inline,title}}
| length_imperial =22 | length_orientation = 
| width_imperial = | width_orientation = 
| depth_imperial = 
| volume_imperial =
| watershed_imperial = 130
| discharge_imperial = 28.1
| discharge_location = near [[Sunland, Los Angeles, California|Sunland]] 
| discharge_max_imperial = 50000
| discharge_min_imperial = 0.29
| discharge_note = <ref>{{cite web|url=http://nwis.waterdata.usgs.gov/nwis/monthly/?referred_module=sw&amp;site_no=11095500&amp;por_11095500_1=2207844,00060,1,1916-11,1977-09&amp;format=html_table&amp;date_format=YYYY-MM-DD&amp;rdb_compression=file&amp;submitted_form=parameter_selection_list|title=USGS Gage #11095500 on Big Tujunga Creek near Sunland, CA|publisher=U.S. Geological Survey|work=National Water Information System|date=1916–1977|accessdate=2011-02-05}}</ref>
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
| commons =
<!-- *** Footnotes *** -->
| footnotes =
}}
    TEXT
    result = <<~TEXT
{{Infobox river
| name               = Big Tujunga Creek
| name_native        = 
| name_native_lang   = 
| name_other         = Tujunga Creek, Tujunga River, Tujunga Wash
| name_etymology     = 
<!---------------------- IMAGE & MAP -->
| image              = Big_Tujunga_Canyon_View_of_River_and_Tujunga.JPG
| image_caption      = The wash in lower Big Tujunga Canyon
| map                = 
| map_size           = 
| map_caption        = 
| pushpin_map        = 
| pushpin_map_size   = 
| pushpin_map_caption= 
<!---------------------- LOCATION -->
| subdivision_type1  = Country
| subdivision_name1  = {{subst:#ifexist:United States|[[United States]]|United States}}
| subdivision_type2  = State
| subdivision_name2  = {{subst:#ifexist:California|[[California]]|California}}
| subdivision_type3  = 
| subdivision_name3  = 
| subdivision_type4  = 
| subdivision_name4  = 
| subdivision_type5  = Cities
| subdivision_name5  = [[Sunland-Tujunga, Los Angeles|Sunland]], [[Shadow Hills, Los Angeles|Shadow Hills]]
<!---------------------- PHYSICAL CHARACTERISTICS -->
| length             = {{convert|22|mi|km|abbr=on}} 
| width_min          = 
| width_avg          = 
| width_max          = 
| depth_min          = 
| depth_avg          = 
| depth_max          = 
| discharge1_location= near [[Sunland, Los Angeles, California|Sunland]]<ref>{{cite web|url=http://nwis.waterdata.usgs.gov/nwis/monthly/?referred_module=sw&amp;site_no=11095500&amp;por_11095500_1=2207844,00060,1,1916-11,1977-09&amp;format=html_table&amp;date_format=YYYY-MM-DD&amp;rdb_compression=file&amp;submitted_form=parameter_selection_list|title=USGS Gage #11095500 on Big Tujunga Creek near Sunland, CA|publisher=U.S. Geological Survey|work=National Water Information System|date=1916–1977|accessdate=2011-02-05}}</ref>
| discharge1_min     = {{convert|0.29|cuft/s|m3/s|abbr=on}}
| discharge1_avg     = {{convert|28.1|cuft/s|m3/s|abbr=on}}<ref>{{cite web|url=http://nwis.waterdata.usgs.gov/nwis/monthly/?referred_module=sw&amp;site_no=11095500&amp;por_11095500_1=2207844,00060,1,1916-11,1977-09&amp;format=html_table&amp;date_format=YYYY-MM-DD&amp;rdb_compression=file&amp;submitted_form=parameter_selection_list|title=USGS Gage #11095500 on Big Tujunga Creek near Sunland, CA|publisher=U.S. Geological Survey|work=National Water Information System|date=1916–1977|accessdate=2011-02-05}}</ref>
| discharge1_max     = {{convert|50000|cuft/s|m3/s|abbr=on}}
<!---------------------- BASIN FEATURES -->
| source1            = About {{convert|1.6|mi|km}} south-southeast of Mount Mooney
| source1_location   = [[San Gabriel Mountains]]
| source1_coordinates= {{coord|34|17|52|N|118|00|11|W|display=inline}}<ref>{{cite gnis|id=252292|name=Big Tujunga Creek|entrydate=1991-01-04|accessdate=2011-02-05}}</ref>
| source1_elevation  = {{convert|5768|ft|abbr=on}}
| mouth              = [[Tujunga Wash]]
| mouth_location     = Upstream of [[Hansen Dam]]
| mouth_coordinates  = {{coord|34|16|05|N|118|21|50|W|display=inline,title}}
| mouth_elevation    = {{convert|1070|ft|abbr=on}}
| progression        = 
| river_system       = 
| basin_size         = {{convert|130|sqmi|abbr=on}}
| tributaries_left   = {{subst:#ifexist:Lucas Creek|[[Lucas Creek]]|Lucas Creek}}, [[Clear Creek (Big Tujunga Creek)|Clear Creek]]
| tributaries_right  = [[Alder Creek (Los Angeles County, California)|Alder Creek]], [[Mill Creek (Los Angeles County, California)|Mill Creek]], [[Fox Creek (Big Tujunga Creek)|Fox Creek]], {{subst:#ifexist:Trail Canyon Creek|[[Trail Canyon Creek]]|Trail Canyon Creek}}
| custom_label       = 
| custom_data        = 
| extra              = 
}}
  TEXT
    expect(parse_geobox_to_river(text)).to eq(result)
  end

  it 'works for case 6' do
    text = <<~TEXT
{{Geobox|River
<!-- *** Name section *** -->
| name                        = Aliso Creek
| native_name                 =
| other_name                 = Alisos Creek<ref>Durham, [https://books.google.com/books?id=IYAuXvk2sIYC&lpg=PP1&pg=PA7-IA1 p. 4]</ref>
| category_hide = 1
<!-- *** Image *** --->
| image                       = Alisocreek Bridge.JPG
| image_size                  =
| image_alt = A channed stream between rocky banks runs towards a canyon in the distance as it flows under a concrete bridge
| image_caption               = Aliso Creek flows underneath the Aliso Creek Road bridge before it enters [[Aliso and Wood Canyons Wilderness Park]].
<!-- *** Etymology *** --->
| etymology                   = Spanish language "Aliso" meaning [[alder]], thus "Aliso Creek" means "Alder Creek"
<!-- *** Country etc. *** -->
| country                     = United States
| country1                    =
| state                       = California
| state1                      =
|region_type                  = Counties
| region                      = [[Orange County, California|Orange County]]
| region1                     =
| district                    =
| district1                   =
| city                        = [[Laguna Beach]]
| city1                       = [[Laguna Niguel]]
| city2    = [[Aliso Viejo]]
| city3                         = [[Laguna Woods]]
| city4                         = [[Laguna Hills]]
| city5    = [[Lake Forest, California|Lake Forest]]
| city6    = [[Mission Viejo]]
<!-- *** Geography *** -->
| length_imperial             = 19
| length_round                = 0
| length_note                 =
| watershed_imperial          = 35.5
| watershed_round             = 0
| watershed_note              =
| discharge_location          = [[Laguna Beach]], California
| discharge_round             = -1
| discharge_imperial          = 7.7
| discharge_note              =<ref name="South Laguna 2012"/>
| discharge_max_imperial      = 5400
| discharge_max_round = 0
| discharge_min_imperial      = 0
| discharge1_location         =
| discharge1_imperial         =
| discharge1_note             =
<!-- *** Source *** -->
| source_name                 =
| source_location             = [[Portola Hills, California|Portola Hills]], [[Cleveland National Forest]], [[Santa Ana Mountains]]
| source_district             = [[Orange County, California]]
| source_region               =
| source_state                =
| source_country              =
| source_coordinates          = {{coord|33|42|10|N|117|37|20|W|display=inline}}
| source_coordinates_note     =<ref name=gnis/>
| source_elevation_imperial   = 1704
| source_elevation_note       =<ref name=damproposal/>
| source_length_imperial      =
<!-- *** Mouth *** -->
| mouth_name                  = Pacific Ocean
| mouth_location              = [[Laguna Beach]], California
| mouth_district              =
| mouth_region                =
| mouth_state                 =
| mouth_country               =
| capital_coordinates         = 
| mouth_coordinates           = {{coord|33|30|38|N|117|45|9|W|display=inline,title}}
| mouth_coordinates_note      =<ref name=gnis/>
| mouth_elevation_imperial    = 0
| mouth_elevation_note        =<ref name=gnis/>
<!-- *** Tributaries *** -->
| tributary_left              = [[Sulphur Creek (California)|Sulphur Creek]]
| tributary_left1             = English Canyon Creek
| tributary_right             = Wood Canyon Creek
| tributary_right1            = Dairy Fork
<!-- *** Free fields *** -->
| free_name                   =
| free_value                  =
<!-- *** Map section *** -->
| map                         = Alisocreekocmap.png
|map_alt = Aliso Creek drains a roughly spoon-shaped area (light brown). It is bordered by the cities of Laguna Beach, Aliso Viejo, Laguna Hills, Lake Forest, Foothill Ranch, Portola Hills, Mission Viejo, and Laguna Niguel, clockwise from bottom left. There are several forks of the creek including English Canyon Creek, the Dairy Fork, the Aliso Hills Channel, Sulphur Creek, and Wood Canyon Creek.
| map_caption                 = Map of the Aliso Creek watershed showing major tributaries and cities
| pushpin_map = USA California
| pushpin_map_size = 260
| pushpin_map_relief = 1
| pushpin_map_caption = Location of the mouth of Aliso Creek in California
| pushpin_map_alt=Aliso Creek (marked by a red dot) is located on the south coast of the state of California.
}}
    TEXT
    result = <<~TEXT
{{Infobox river
| name               = Aliso Creek
| name_native        = 
| name_native_lang   = 
| name_other         = Alisos Creek<ref>Durham, [https://books.google.com/books?id=IYAuXvk2sIYC&lpg=PP1&pg=PA7-IA1 p. 4]</ref>
| name_etymology     = Spanish language "Aliso" meaning [[alder]], thus "Aliso Creek" means "Alder Creek"
<!---------------------- IMAGE & MAP -->
| image              = Alisocreek Bridge.JPG
| image_caption      = Aliso Creek flows underneath the Aliso Creek Road bridge before it enters [[Aliso and Wood Canyons Wilderness Park]].
| map                = Alisocreekocmap.png
| map_size           = 260
| map_caption        = Map of the Aliso Creek watershed showing major tributaries and cities
| pushpin_map        = USA California
| pushpin_map_size   = 260
| pushpin_map_caption= Location of the mouth of Aliso Creek in California
<!---------------------- LOCATION -->
| subdivision_type1  = Country
| subdivision_name1  = {{subst:#ifexist:United States|[[United States]]|United States}}
| subdivision_type2  = State
| subdivision_name2  = {{subst:#ifexist:California|[[California]]|California}}
| subdivision_type3  = Counties
| subdivision_name3  = [[Orange County, California|Orange County]]
| subdivision_type4  = 
| subdivision_name4  = 
| subdivision_type5  = Cities
| subdivision_name5  = [[Laguna Beach]], [[Laguna Niguel]], [[Aliso Viejo]], [[Laguna Woods]], [[Laguna Hills]], [[Lake Forest, California|Lake Forest]], [[Mission Viejo]]
<!---------------------- PHYSICAL CHARACTERISTICS -->
| length             = {{convert|19|mi|km|abbr=on}} 
| width_min          = 
| width_avg          = 
| width_max          = 
| depth_min          = 
| depth_avg          = 
| depth_max          = 
| discharge1_location= [[Laguna Beach]], California<ref name="South Laguna 2012"/>
| discharge1_min     = {{convert|0|cuft/s|m3/s|abbr=on}}
| discharge1_avg     = {{convert|7.7|cuft/s|m3/s|abbr=on}}<ref name="South Laguna 2012"/>
| discharge1_max     = {{convert|5400|cuft/s|m3/s|abbr=on}}
<!---------------------- BASIN FEATURES -->
| source1            = 
| source1_location   = [[Portola Hills, California|Portola Hills]], [[Cleveland National Forest]], [[Santa Ana Mountains]], [[Orange County, California]]
| source1_coordinates= {{coord|33|42|10|N|117|37|20|W|display=inline}}<ref name=gnis/>
| source1_elevation  = {{convert|1704|ft|abbr=on}}<ref name=damproposal/>
| mouth              = {{subst:#ifexist:Pacific Ocean|[[Pacific Ocean]]|Pacific Ocean}}
| mouth_location     = [[Laguna Beach]], California
| mouth_coordinates  = {{coord|33|30|38|N|117|45|9|W|display=inline,title}}<ref name=gnis/>
| mouth_elevation    = {{convert|0|ft|abbr=on}}<ref name=gnis/>
| progression        = 
| river_system       = 
| basin_size         = {{convert|35.5|sqmi|abbr=on}}
| tributaries_left   = [[Sulphur Creek (California)|Sulphur Creek]], {{subst:#ifexist:English Canyon Creek|[[English Canyon Creek]]|English Canyon Creek}}
| tributaries_right  = {{subst:#ifexist:Wood Canyon Creek|[[Wood Canyon Creek]]|Wood Canyon Creek}}, {{subst:#ifexist:Dairy Fork|[[Dairy Fork]]|Dairy Fork}}
| custom_label       = 
| custom_data        = 
| extra              = 
}}
  TEXT
    expect(parse_geobox_to_river(text)).to eq(result)
  end

  it 'works for case 7' do
    text = <<~TEXT
{{Geobox|River
<!-- *** Heading *** -->
| name = Pembina River
| native_name = 
| other_name = {{lang|fr|Rivière Pembina}}
| other_name1 = 
| other_name2 = 
| category_hide = 1
<!-- *** Image *** -->
| image = Pembina River ND.jpg
| image_caption = The Pembina River at [[Pembina, North Dakota]], as viewed upstream from its mouth
| image_size = 291px
<!-- *** Country *** -->
| country = {{flag|Canada}}
| country1 = {{flag|United States}}
| country_flag = 
| country_flag1 =
| state_type = States/Provinces
| state = {{flag|Manitoba}}
| state1 = {{flag|North Dakota}}
| state2 = 
| state_flag =
| region = 
| district = 
| municipality = 
<!-- *** Family *** -->
| parent = [[Red River of the North|Red River]] [[drainage basin]]
| tributary_left =
| tributary_right =
| city = 
| city1 = 
| city2 = 
| city3 = 
| landmark = 
| river =
<!-- *** River locations *** -->
| source = [[Turtle Mountain (plateau)]]
| source_location = Manitoba
| source_country = Canada
| source_elevation_imperial =
| source_coordinates = {{coord|49|05|06|N|100|03|05|W|display=inline}}
| source_coordinates_note =<br />(near Turtle Mountain)
| source1 = 
| source1_location = 
| source1_elevation_imperial = 
| source1_coordinates_note= 
| source_confluence = 
| source_confluence_location =
| source_confluence_country =
| source_confluence_elevation_imperial = 
| source_confluence_coordinates_note = 
| mouth = [[Red River of the North]]
| mouth_location = [[Pembina, North Dakota|Pembina]]
| mouth_region = North Dakota
| mouth_country = United States
| mouth_elevation_imperial = 
| mouth_elevation_note = 
| capital_coordinates = 
| mouth_coordinates = {{coord|48|57|59|N|97|14|21|W|display=inline,title}}
| mouth_coordinates_note = 
<!-- *** Dimensions *** -->
| length_imperial = 319 | length_orientation = 
| width_imperial = | width_orientation = 
| depth_imperial = 
| volume_imperial =
| watershed_imperial = 3282
| watershed_note =
| discharge_imperial = 
| discharge_note =
| discharge_location = 
| discharge_max_imperial = 
| discharge_max_note = 
| discharge_min_imperial = 
<!-- *** Free fields *** -->
| free = | free_type = 
<!-- *** Maps *** -->
| map = Pembinarivermap.png
| map_caption = The Red River drainage basin, with the Pembina River highlighted
| map_size = 291px
| map_background = 
| map_locator =
| map_locator_x =
| map_locator_y = 
<!-- *** Website *** -->
| website =
| commons =
<!-- *** Footnotes *** -->
| footnotes = <ref>{{cite web
| title = Natural Resources Canada-Canadian Geographical Names (Pembina River)
| url = http://www4.rncan.gc.ca/search-place-names/unique/GAVHJ 
| date = 
| accessdate =2014-10-14}}</ref><ref name= "Atlas of Canada">{{cite web
| title =Atlas of Canada Toporama
| url =http://atlas.nrcan.gc.ca/site/english/toporama/index.html
| date = 
| accessdate =2014-10-14}}</ref> 
}}
    TEXT
    result = <<~TEXT
{{Infobox river
| name               = Pembina River
| name_native        = 
| name_native_lang   = 
| name_other         = {{lang|fr|Rivière Pembina}}
| name_etymology     = 
<!---------------------- IMAGE & MAP -->
| image              = Pembina River ND.jpg
| image_caption      = The Pembina River at [[Pembina, North Dakota]], as viewed upstream from its mouth
| map                = Pembinarivermap.png
| map_size           = 291px
| map_caption        = The Red River drainage basin, with the Pembina River highlighted
| pushpin_map        = 
| pushpin_map_size   = 291px
| pushpin_map_caption= 
<!---------------------- LOCATION -->
| subdivision_type1  = Country
| subdivision_name1  = [[Canada]], [[United States]]
| subdivision_type2  = States/Provinces
| subdivision_name2  = [[Manitoba]], [[North Dakota]]
| subdivision_type3  = 
| subdivision_name3  = 
| subdivision_type4  = 
| subdivision_name4  = 
| subdivision_type5  = 
| subdivision_name5  = 
<!---------------------- PHYSICAL CHARACTERISTICS -->
| length             = {{convert|319|mi|km|abbr=on}} 
| width_min          = 
| width_avg          = 
| width_max          = 
| depth_min          = 
| depth_avg          = 
| depth_max          = 
| discharge1_location= 
| discharge1_min     = 
| discharge1_avg     = 
| discharge1_max     = 
<!---------------------- BASIN FEATURES -->
| source1            = [[Turtle Mountain (plateau)]]
| source1_location   = {{subst:#ifexist:Manitoba|[[Manitoba]]|Manitoba}}, {{subst:#ifexist:Canada|[[Canada]]|Canada}}
| source1_coordinates= {{coord|49|05|06|N|100|03|05|W|display=inline}}<br />(near Turtle Mountain)
| source1_elevation  = 
| mouth              = [[Red River of the North]]
| mouth_location     = [[Pembina, North Dakota|Pembina]], {{subst:#ifexist:North Dakota|[[North Dakota]]|North Dakota}}, {{subst:#ifexist:United States|[[United States]]|United States}}
| mouth_coordinates  = {{coord|48|57|59|N|97|14|21|W|display=inline,title}}
| mouth_elevation    = 
| progression        = 
| river_system       = [[Red River of the North|Red River]] [[drainage basin]]
| basin_size         = {{convert|3282|sqmi|abbr=on}}
| tributaries_left   = 
| tributaries_right  = 
| custom_label       = 
| custom_data        = 
| extra              = <ref>{{cite web
| title = Natural Resources Canada-Canadian Geographical Names (Pembina River)
| url = http://www4.rncan.gc.ca/search-place-names/unique/GAVHJ 
| date = 
| accessdate =2014-10-14}}</ref><ref name= "Atlas of Canada">{{cite web
| title =Atlas of Canada Toporama
| url =http://atlas.nrcan.gc.ca/site/english/toporama/index.html
| date = 
| accessdate =2014-10-14}}</ref>
}}
    TEXT
    expect(parse_geobox_to_river(text)).to eq(result)
  end
  # 
  # it 'works for case 8' do
  #   text = <<~TEXT
  # 
  #   TEXT
  #   result = <<~TEXT
  # 
  #TEXT
  #   expect(parse_geobox_to_river(text)).to eq(result)
  # end
  # 
  # it 'works for case 9' do
  #   text = <<~TEXT
  # 
  #   TEXT
  #   result = <<~TEXT
  # 
  #TEXT
  #   expect(parse_geobox_to_river(text)).to eq(result)
  # end
end
