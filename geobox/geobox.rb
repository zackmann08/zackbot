# encoding: utf-8
require '../helper'

module Geobox
  # class UnresolvedCase < StandardError; end
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end
  # IDEA: Consider just building a new template and subst: it in so it will be properly formatted?

  def parse_unesco(params)
    "{{Infobox UNESCO World Heritage Site
  | Official_name = #{params['whs_name']}
  | Criteria      = #{params['whs_criteria']} 
  | ID            = #{params['whs_number']}
  | Year          = #{params['whs_year']}
  | child         = yes
}}"
  end
  
  def parse_iucn(params)
    cat = ''
    ref = ''
    cat = params['category_iucn'].gsub(/<ref.*<\/ref>/,'')
    ref = params['category_iucn'].match(/(<ref.*<\/ref>)/)
    return [cat, ref]
  end

  def parse_seat(params)
    result = ""
    unless params['capital'].empty?
      result += "
<!-- seat -->
| seat                    = #{params['capital']}
| seat_type               = #{params['capital_type'].empty? ? 'Capital' : params['capital_type']}"
    end
    result
  end

  def parse_government(params)
    result = ""
    unless params['mayor'].empty?
      result += "
| leader_title            = Mayor
| leader_name             = #{params['mayor']}"
    end

    unless params['leader'].empty? || params['leader_type'].empty?
      result += "
| leader_title1           = #{params['leader_type']}
| leader_name1            = #{params['leader']}"
    end

    unless params['government_type'].empty? || params['government'].empty?
      result += "
| government_type         = #{params['government_type']}
| governing_body          = #{params['government']}"
    end

    result = "\n<!-- government type, leaders -->" + result unless result.empty?
    result
  end

  def parse_parts(params)
    result = ""
    result += "\n| parts_type              = #{params['part_type']}" unless params["part_type"].empty?
    result += "\n| parts_type              = Parts" if (params["part_type"].empty? && (!params['part'].empty? || !params['part1'].empty?))
    result += "\n| parts_style             = para" unless params["part"].empty?
    result += "\n| p1                      = #{params['part']}" unless params["part"].empty?
    (1..8).each do |i|
      result += "\n| p#{i+1}                      = #{params["part#{i}"]}" unless params["part#{i}"].empty?
    end
    (9..41).each do |i|
      result += "\n| p#{i+1}                     = #{params["part#{i}"]}" unless params["part#{i}"].empty?
    end
    result
  end

  def index(count)
    return count if count>0
    return ''
  end

  def get_codes(params)
    num = 0
    result = ""
    unless params['code_type'].empty? || params['code'].empty?
      result += "
| blank#{index(num)}_name              = #{params['code_type']}
| blank#{index(num)}_info              = #{params['code']}#{params['code_note']}"
      num+=1
    end
    unless params['code1_type'].empty? || params['code1'].empty?
      result += "
| blank#{index(num)}_name             = #{params['code1_type']}
| blank#{index(num)}_info             = #{params['code1']}#{params['code1_note']}"
      num+=1
    end
    unless params['code2_type'].empty? || params['code2'].empty?
      result += "
| blank#{index(num)}_name             = #{params['code2_type']}
| blank#{index(num)}_info             = #{params['code2']}#{params['code2_note']}"
      num+=1
    end
    unless params['free_type'].empty? || params['free'].empty?
      result += "
| blank#{index(num)}_name             = #{params['free_type']}
| blank#{index(num)}_info             = #{params['free']}#{params['free_note']}"
      num+=1
    end
    unless params['free1_type'].empty? || params['free1'].empty?
      result += "
| blank#{index(num)}_name             = #{params['free1_type']}
| blank#{index(num)}_info             = #{params['free1']}#{params['free1_note']}"
      num+=1
    end
    unless params['free2_type'].empty? || params['free2'].empty?
      result += "
| blank#{index(num)}_name             = #{params['free2_type']}
| blank#{index(num)}_info             = #{params['free2']}#{params['free2_note']}"
      num+=1
    end
    unless params['free3_type'].empty? || params['free3'].empty?
      result += "
| blank#{index(num)}_name             = #{params['free3_type']}
| blank#{index(num)}_info             = #{params['free3']}#{params['free3_note']}"
      num+=1
    end
    unless params['free4_type'].empty? || params['free4'].empty?
      result += "
| blank#{index(num)}_name             = #{params['free4_type']}
| blank#{index(num)}_info             = #{params['free4']}#{params['free4_note']}"
      num+=1
    end
    unless params['free5_type'].empty? || params['free5'].empty?
      result += "
| blank#{index(num)}_name             = #{params['free5_type']}
| blank#{index(num)}_info             = #{params['free5']}#{params['free5_note']}"
      num+=1
    end
    unless params['free6_type'].empty? || params['free6'].empty?
      result += "
| blank#{index(num)}_name             = #{params['free6_type']}
| blank#{index(num)}_info             = #{params['free6']}#{params['free6_note']}"
      num+=1
    end
    result
  end

  def get_established(params)
    result = ""
    unless params['established1_type'].empty? || params['established1'].empty?
      result += "
| established_title1      = #{params['established1_type']}
| established_date1       = #{params['established1']}"
    end
    unless params['established2_type'].empty? || params['established2'].empty?
      result += "
| established_title2      = #{params['established2_type']}
| established_date2       = #{params['established2']}"
    end
    unless params['established3_type'].empty? || params['established3'].empty?
      result += "
| established_title3      = #{params['established3_type']}
| established_date3       = #{params['established3']}"
    end
    unless params['established4_type'].empty? || params['established4'].empty?
      result += "
| established_title4      = #{params['established4_type']}
| established_date4       = #{params['established4']}"
    end
    result
  end

  def get_map(params)
    return params["map_locator"] if params["pushpin_map"].empty?
    params["pushpin_map"]
  end

  def get_map_caption(params)
    # return '' if (params['map_locator'].empty? && params["pushpin_map"].empty?)
    # return params["map_caption"] if params["pushpin_map_caption"].empty? && params['image_map'].empty?
    params["pushpin_map_caption"]
  end

  def parse_geobox_to_settlement(page)
    page.force_encoding('UTF-8')
    templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise NoTemplatesFound if templates.empty?
    raise UnresolvedCase if templates.size > 1

    template = templates.first
    old_template = template.dup
    template.gsub!(/<!--[\w\W]*?-->/,'')
    template.gsub!(/\s*(\|\s*utc_offset)/, "\n\\1")
    template.gsub!(/\s*(\|\s*population_date)/, "\n\\1")
    params = Helper.parse_template(template)

    # raise UnresolvedCase unless params["part_type"].empty?
    raise UnresolvedCase unless params["parts"].empty?
    # raise UnresolvedCase unless params["capital"].empty?

    # puts params["established_type"].inspect
    result = "{{Infobox settlement
| name                    = #{params["name"]}
| native_name             = #{params["native_name"]}
| other_name              = #{params["other_name"]}
| settlement_type         = #{params["category"]}
<!-- images, nickname, motto -->
| image_skyline           = #{params["image"]}
| image_caption           = #{params["image_caption"]}
| image_flag              = #{params['flag']}
| image_shield            = #{params['symbol']}
| motto                   = #{params["motto"]}
| nickname                = #{params["nickname"]}
| etymology               = #{params["etymology"]}
<!-- location -->
| subdivision_type        = Country
| subdivision_name        = #{params["country"]}
| subdivision_type1       = #{('State' unless(params["state"].empty? || !params['state_type'].empty?))||params["state_type"]}
| subdivision_name1       = #{params["state"]}
| subdivision_type2       = #{('Region' unless (params["region"].empty? || !params['region_type'].empty?))||params["region_type"]}
| subdivision_name2       = #{params["region"]}
| subdivision_type3       = #{('District' unless (params["district"].empty? || !params['district_type'].empty?))||params["district_type"]}
| subdivision_name3       = #{params["district"]}
| subdivision_type4       = #{('Municipality' unless (params["municipality"].empty? || !params['municipality_type'].empty?))||params["municipality_type"]}
| subdivision_name4       = #{params["municipality"]}#{parse_parts(params)}
<!-- maps and coordinates -->
| image_map               = #{params['map'] if get_map(params).empty?}
| map_caption             = #{params['map_caption'] if get_map_caption(params).empty?}
| pushpin_map             = #{get_map(params)}
| pushpin_relief          = #{params["pushpin_map_relief"]}
| pushpin_map_caption     = #{get_map_caption(params)} 
| coordinates             = #{params['coordinates']}
| coordinates_footnotes   = #{params['coordinates_note']}#{parse_government(params)}#{parse_seat(params)}
<!-- established -->
| established_title       = #{params['established_type'].empty? ? ('Founded' unless params['established'].empty?) : params['established_type']}
| established_date        = #{params['established']}#{get_established(params)}
<!-- area -->
| area_footnotes          = 
| area_total_km2          = #{params['area']}
| area_total_sq_mi        = #{params['area_imperial']}
| area_land_sq_mi         = #{params['area_land_imperial']}
| area_water_sq_mi        = #{params['area_water_imperial']}
<!-- elevation -->
| elevation_footnotes     = #{params['elevation_note']}#{params['elevation_imperial_note']}
| elevation_m             = #{params['elevation']}
| elevation_ft            = #{params['elevation_imperial']}
<!-- population -->
| population_as_of        = #{params['population_date']}#{params['population_as_of']}
| population_footnotes    = 
| population_total        = #{params['population']}
| population_density_km2  = auto
| population_density_sq_mi=
| population_demonym      = 
<!-- time zone(s) -->
| timezone1               = #{params['timezone']}
| utc_offset1             = #{params['utc_offset']}
| timezone1_DST           = #{params['timezone_DST']}
| utc_offset1_DST         = #{params['utc_offset_DST']}
<!-- postal codes, area code -->
| postal_code_type        = #{params['postal_code_type'].empty? ? ('Postal code' unless params['postal_code'].empty?) : params['postal_code_type']}
| postal_code             = #{params['postal_code']}
| area_code_type          =  
| area_code               = #{params['area_code']}
| geocode                 = 
| iso_code                = #{get_codes(params)}
<!-- website, footnotes -->
| website                 = #{params['website']}
| footnotes               = #{params['footnotes']}#{parse_unesco(params) unless (params["whs_name"].empty? && params["whs_criteria"].empty?)}
}}"

    result.gsub!('Illinois2', 'Illinois')
    result.gsub!('<nowiki>', '')
    result.gsub!('</nowiki>', '')
    # result

    page.sub!(old_template, result)
    page
  end

  def parse_area(params)
    # | area            =
    # | area_ha         =
    # | area_acre       =
    # | area_km2        =
    # | area_sqmi       =
    return "\n| area_acre       = #{params['area_imperial']}" if (params['area_unit'].downcase.start_with?('ac') && !params['area_imperial'].empty?)
    return "\n| area_acre       = #{params['area']}" if (params['area_unit'].downcase.start_with?('ac') && !params['area'].empty?)
    return "\n| area_sqmi       = #{params['area_imperial']}" unless params['area_imperial'].empty?
    return "\n| area_ha         = #{params['area']}" if params['area_unit'].downcase == 'ha'
    return "\n| area_km2        = #{params['area']}" unless params['area'].empty?
  end

  def parse_location(params)
    values = [params['city'],params['district'],params['region'],params['state'],params['country']].reject{|val| val.empty?}
    values = values.map!{|val| (val.sub!(/\{\{flag\|(.*)\}\}/,'[[\1]]') || val )}
    return "#{values.join(', ')}"
  end

  def parse_location_no_country(params)
    values = [params['city'],params['district'],params['region'],params['state']].reject{|val| val.empty?}
    values = values.map!{|val| (val.sub!(/\{\{flag\|(.*)\}\}/,'[[\1]]') || val )}
    return "#{values.join(', ')}"
  end

  def parse_style(params)
    values = [params['style'],params['style1'],params['style2'],params['style3'],params['style4'],params['style5']].reject{|val| val.empty?}
    return "#{values.join(', ')}"
  end

  def parse_materials(params)
    values = [params['material'],params['material1'],params['material2'],params['material3'],params['material4'],params['material5'],params['material6']].reject{|val| val.empty?}
    return "#{values.join(', ')}"
  end

  def parse_elevation(params)
    return "{{convert|#{params['elevation']}|m|ft|abbr=on}}#{params['elevation_note']}" unless params['elevation'].empty?
    return "{{convert|#{params['elevation_imperial']}|ft|m|abbr=on}}#{params['elevation_note']}" unless params['elevation_imperial'].empty?
  end

  def parse_bridge_id(params)
    return [params['code_type'], "#{params['code']}#{params['code_note']}"] unless params['code'].empty?
    return [params['code1_type'], "#{params['code1']}#{params['code1_note']}"] unless params['code1'].empty?
    [nil,nil]
  end
  
  def parse_height(params)
    return "{{convert|#{params['height']}|m|ft|abbr=on}}#{params['height_note']}" unless params['height'].empty?
    return "{{convert|#{params['height_imperial']}|ft|m|abbr=on}}#{params['height_note']}" unless params['height_imperial'].empty?
  end

  def parse_width(params)
    return "{{convert|#{params['width']}|m|ft|abbr=on}}#{params['width_note']}" unless params['width'].empty?
    return "{{convert|#{params['width_imperial']}|ft|m|abbr=on}}#{params['width_note']}" unless params['width_imperial'].empty?
  end

  def parse_destruction(params)
    dest = ['destruction', 'destroyed']
    return params['free'] if dest.include?(params['free_type'].downcase)
    return params['free1'] if dest.include?(params['free1_type'].downcase)
    return params['free2'] if dest.include?(params['free2_type'].downcase)
  end
  def parse_load(params)
    return params['free'] if params['free_type'].downcase.include?('load')
    return params['free1'] if params['free1_type'].downcase.include?('load')
    return params['free2'] if params['free2_type'].downcase.include?('load')
  end
  def parse_nrhp_added(params)
    return params['free'] if params['free_type'].downcase.include?('added')
    return params['free1'] if params['free1_type'].downcase.include?('added')
    return params['free2'] if params['free2_type'].downcase.include?('added')
  end
  def parse_mps(params)
    return params['free'] if params['free_type'].downcase.include?('multiple property submission')
    return params['free1'] if params['free1_type'].downcase.include?('multiple property submission')
    return params['free2'] if params['free2_type'].downcase.include?('multiple property submission')
  end
  def parse_refnum(params)
    return params['code']+params['code_note']   if params['code_type'].downcase.include?('ref number')
    return params['code1']+params['code1_note'] if params['code1_type'].downcase.include?('ref number')
    return params['code2']+params['code2_note'] if params['code2_type'].downcase.include?('ref number')
    return params['code']+params['code_note']   if   params['code_label'].downcase.include?('reference number')
    return params['code1']+params['code1_note'] if params['code1_label'].downcase.include?('reference number')
    return params['code2']+params['code2_note'] if params['code2_label'].downcase.include?('reference number')
  end


  def parse_length(params)
    raise UnresolvedCase.new('has length unit') unless params['length_unit'].empty?
    return "{{convert|#{params['length']}|km|mi|abbr=on}}#{", #{params['length_orientation']}" unless params['length_orientation'].empty?}#{params['length_note']}" unless params['length'].empty?
    return "{{convert|#{params['length_imperial']}|mi|km|abbr=on}}#{", #{params['length_orientation']}" unless params['length_orientation'].empty?}#{params['length_note']}" unless params['length_imperial'].empty?
  end
  
  def parse_watershed(params)
    raise UnresolvedCase.new('has watershed unit') unless params['watershed_unit'].empty?
    return "{{convert|#{params['watershed']}|km2|abbr=on}}#{params['watershed_note']}" unless params['watershed'].empty?
    return "{{convert|#{params['watershed_imperial']}|sqmi|abbr=on}}#{params['watershed_note']}" unless params['watershed_imperial'].empty?
  end
  
  def parse_mouth_elevation(params)
    raise UnresolvedCase.new('has mouth elevation unit') unless params['mouth_elevation_unit'].empty?
    return "{{convert|#{params['mouth_elevation']}|m|abbr=on}}#{params['mouth_elevation_note']}" unless params['mouth_elevation'].empty?
    return "{{convert|#{params['mouth_elevation_imperial']}|ft|abbr=on}}#{params['mouth_elevation_note']}" unless params['mouth_elevation_imperial'].empty?
  end
  
  def parse_tributaries_l(params)
    values = [
        autolink(params['tributary_left']),
        autolink(params['tributary_left1']),
        autolink(params['tributary_left2']),
        autolink(params['tributary_left3']),
        autolink(params['tributary_left4']),
        autolink(params['tributary_left5']),
        autolink(params['tributary_left6']),
        autolink(params['tributary_left7']),
        autolink(params['tributary_left8']),
        autolink(params['tributary_left9']),
        autolink(params['tributary_left10']),
        autolink(params['tributary_left11']),
        autolink(params['tributary_left12']),
        autolink(params['tributary_left13']),
        autolink(params['tributary_left14']),
        autolink(params['tributary_left15'])
    ].reject{|val| val.empty?}
    return "#{values.join(', ')}"
  end
  
  def parse_tributaries_r(params)
    values = [
        autolink(params['tributary_right']),
        autolink(params['tributary_right1']),
        autolink(params['tributary_right2']),
        autolink(params['tributary_right3']),
        autolink(params['tributary_right4']),
        autolink(params['tributary_right5']),
        autolink(params['tributary_right6']),
        autolink(params['tributary_right7']),
        autolink(params['tributary_right8']),
        autolink(params['tributary_right9']),
        autolink(params['tributary_right10']),
        autolink(params['tributary_right11']),
        autolink(params['tributary_right12']),
        autolink(params['tributary_right13']),
        autolink(params['tributary_right14']),
        autolink(params['tributary_right15'])
    ].reject{|val| val.empty?}
    return "#{values.join(', ')}"
  end

  def parse_source_elevation(params, value)
    raise UnresolvedCase.new('has elevation unit') unless params["#{value}_elevation_unit"].empty?
    return "{{convert|#{params["#{value}_elevation"]}|m|abbr=on}}#{params["#{value}_elevation_note"]}" unless params["#{value}_elevation"].empty?
    return "{{convert|#{params["#{value}_elevation_imperial"]}|ft|abbr=on}}#{params["#{value}_elevation_note"]}" unless params["#{value}_elevation_imperial"].empty?
  end
  
  def parse_river_location(params, value)
    [
        params["#{value}_location"], 
        autolink(params["#{value}_municipality"]), 
        autolink(params["#{value}_district"]), 
        autolink(params["#{value}_region"]), 
        autolink(params["#{value}_state"]), 
        autolink(params["#{value}_country"]), 
    ].reject{|val| val.empty?}.join(', ')
  end
  
  def parse_sources(params)
    result = "
| source1            = #{autolink params['source']}#{autolink params['source_name']}
| source1_location   = #{parse_river_location(params, 'source')}
| source1_coordinates= #{params['source_coordinates']}#{params['source_coordinates_note']}
| source1_elevation  = #{parse_source_elevation(params, 'source')}"
    unless params['source1'].empty? && params['source1_location'].empty? && parse_river_location(params, 'source1').empty?
      result += "
| source2            = #{autolink params['source1']}#{autolink params['source1_name']} 
| source2_location   = #{parse_river_location(params, 'source1')}
| source2_coordinates= #{params['source1_coordinates']}#{params['source1_coordinates_note']}
| source2_elevation  = #{parse_source_elevation(params, 'source1')}"
    end
    unless params['source2'].empty? && params['source2_location'].empty? && parse_river_location(params, 'source2').empty?
      result += "
| source3            = #{autolink params['source2']}#{autolink params['source2_name']}
| source3_location   = #{parse_river_location(params, 'source2')}
| source3_coordinates= #{params['source2_coordinates']}#{params['source2_coordinates_note']}
| source3_elevation  = #{parse_source_elevation(params, 'source2')}"
    end
    unless params['source3'].empty? && params['source3_location'].empty? && parse_river_location(params, 'source3').empty?
      result += "
| source4            = #{params['source3']}#{params['source3_name']}
| source4_location   = #{parse_river_location(params, 'source3')}
| source4_coordinates= #{params['source3_coordinates']}#{params['source3_coordinates_note']}
| source4_elevation  = #{parse_source_elevation(params, 'source3')}"
    end
    unless params['source4'].empty? && params['source4_location'].empty? && parse_river_location(params, 'source4').empty?
      result += "
| source5            = #{params['source4']}#{params['source4_name']}
| source5_location   = #{parse_river_location(params, 'source4')}
| source5_coordinates= #{params['source4_coordinates']}#{params['source4_coordinates_note']}
| source5_elevation  = #{parse_source_elevation(params, 'source4')}"
    end
    unless params['source_confluence'].empty? && params['source_confluence_location'].empty? && parse_river_location(params, 'source_confluence').empty?
      result += "
| source_confluence            = #{params['source_confluence']}#{params['source_confluence_name']}
| source_confluence_location   = #{parse_river_location(params, 'source_confluence')}
| source_confluence_coordinates= #{params['source_confluence_coordinates']}#{params['source_confluence_coordinates_note']}
| source_confluence_elevation  = #{parse_source_elevation(params, 'source_confluence')}"
    end
    result
  end

  def parse_discharge_rate2(params, pre)
    raise UnresolvedCase.new('parse_discharge_rate2') unless params["#{pre}_unit"].empty?
    #NOTE: If either of the next two lines are ever raised, perhaps they should just return nil string instead of raising error
    return '' unless (params["#{pre}_average"].empty? && params["#{pre}_average_imperial"].empty?)
    return "{{convert|#{params["#{pre}"]}|m3/s|cuft/s|abbr=on}}#{params["#{pre}_note"]}" unless params["#{pre}"].empty?
    return "{{convert|#{params["#{pre}_imperial"]}|cuft/s|m3/s|abbr=on}}#{params["#{pre}_note"]}" unless params["#{pre}_imperial"].empty?
  end


  def parse_discharge_rate(params, pre, val)
    raise UnresolvedCase.new('parse_discharge_rate') unless params["#{pre}_unit"].empty?
    raise UnresolvedCase.new('parse_discharge_rate #2') unless params["#{pre}_#{val}_unit"].empty?
    return "{{convert|#{params["#{pre}_#{val}"]}|m3/s|cuft/s|abbr=on}}#{params["#{pre}_#{val}_note"]}" unless params["#{pre}_#{val}"].empty?
    return "{{convert|#{params["#{pre}_#{val}_imperial"]}|cuft/s|m3/s|abbr=on}}#{params["#{pre}_#{val}_note"]}" unless params["#{pre}_#{val}_imperial"].empty?
  end

  def parse_discharge(params)
    result = "
| discharge1_location= #{autolink(params['discharge_location'])}#{params['discharge_note'] unless params['discharge_location'].empty? }
| discharge1_min     = #{parse_discharge_rate(params, 'discharge', 'min')}
| discharge1_avg     = #{parse_discharge_rate(params, 'discharge', 'average')}#{parse_discharge_rate2(params, 'discharge')}
| discharge1_max     = #{parse_discharge_rate(params, 'discharge', 'max')}"
    unless params['discharge1_location'].empty?
      result += "
| discharge2_location= #{autolink(params['discharge1_location'])}#{params['discharge1_note'] unless params['discharge1_location'].empty?}
| discharge2_min     = #{parse_discharge_rate(params, 'discharge1', 'min')}
| discharge2_avg     = #{parse_discharge_rate(params, 'discharge1', 'average')}#{parse_discharge_rate2(params, 'discharge1')}
| discharge2_max     = #{parse_discharge_rate(params, 'discharge1', 'max')}"
    end
    unless params['discharge2_location'].empty?
      result += "
| discharge3_location= #{autolink(params['discharge2_location'])}#{params['discharge2_note'] unless params['discharge2_location'].empty?}
| discharge3_min     = #{parse_discharge_rate(params, 'discharge2', 'min')} 
| discharge3_avg     = #{parse_discharge_rate(params, 'discharge2', 'average')}#{parse_discharge_rate2(params, 'discharge2')}
| discharge3_max     = #{parse_discharge_rate(params, 'discharge2', 'max')}"
    end
    unless params['discharge3_location'].empty?
      result += "
| discharge4_location= #{autolink(params['discharge3_location'])}#{params['discharge3_note'] unless params['discharge3_location'].empty?}
| discharge4_min     = #{parse_discharge_rate(params, 'discharge3', 'min')} 
| discharge4_avg     = #{parse_discharge_rate(params, 'discharge3', 'average')}#{parse_discharge_rate2(params, 'discharge3')}
| discharge4_max     = #{parse_discharge_rate(params, 'discharge3', 'max')}"
    end
    unless params['discharge4_location'].empty?
      result += "
| discharge5_location= #{autolink(params['discharge4_location'])}#{params['discharge4_note'] unless params['discharge4_location'].empty?}
| discharge5_min     = #{parse_discharge_rate(params, 'discharge4', 'min')} 
| discharge5_avg     = #{parse_discharge_rate(params, 'discharge4', 'average')}#{parse_discharge_rate2(params, 'discharge4')} 
| discharge5_max     = #{parse_discharge_rate(params, 'discharge4', 'max')}"
    end
    result
  end
  
  def parse_multi_location(params, val)
    # val = 'country', 'district', 'town', 'city', etc...
    result = ["#{autolink(params[val])}#{params["#{val}_note"] unless params[val].empty? }"]
    (1..15).each do |i|
      param = val+i.to_s
      result << "#{autolink(params[param])}#{params["#{param}_note"]}" unless params[param].empty?
    end
    result.join(', ')
  end
  
  def parse_city_type(params)
    # raise UnresolvedCase.new('Both municipality & city') unless (params["municipality"].empty? || params["city"].empty?)
    return '' if (params["municipality"].empty? && params["city"].empty?)
    if params["municipality"].empty?
      return params['city_type'] unless params['city_type'].empty?
      return params["city1"].empty? ? 'City' : 'Cities'
    else
      return params['municipality_type'] unless params['municipality_type'].empty?
      return params["municipality1"].empty? ? 'Municipality' : 'Municipalities'
    end
  end
  
  def parse_city(params)
    # raise UnresolvedCase.new('Both municipality & city') unless (params["municipality"].empty? || params["city"].empty?)
    return '' if (params["municipality"].empty? && params["city"].empty?)
    result = []
    if params["municipality"].empty?
      result = ["#{autolink(params['city'])}#{params["city_note"] unless params['city'].empty? }"]
      (1..15).each do |i|
        param = 'city'+i.to_s
        result << "#{autolink(params[param])}#{params["#{param}_note"]}" unless params[param].empty?
      end
    else
      result = ["#{autolink(params['municipality'])}#{params["municipality_note"] unless params['municipality'].empty? }"]
      (1..15).each do |i|
        param = 'municipality'+i.to_s
        result << "#{autolink(params[param])}#{params["#{param}_note"]}" unless params[param].empty?
      end
    end
    result.join(', ')
  end
  
  def parse_other_name(params)
    result = ["#{params['other_name']}#{params["other_name_note"] unless params['other_name'].empty? }"]
    (1..7).each do |i|
      param = 'other_name'+i.to_s
      result << "#{params[param]}#{params["#{param}_note"]}" unless params[param].empty?
    end
    result.reject{|val| val.empty?}.join(', ')
  end
  
  def autolink(value)
    return '' if value.nil? || value.empty?  
    return value if (value.include?('[[') || value.include?('{{'))
    "{{subst:#ifexist:#{value}|[[#{value}]]|#{value}}}"
  end
  
  def parse_geobox_to_river(page)
    page.force_encoding('UTF-8')
    templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise NoTemplatesFound if templates.empty?
    raise UnresolvedCase.new('More than 1 template') if templates.size > 1
    
    template = templates.first
    old_template = template.dup
    
    # raise UnresolvedCase.new('Contains invalid ref') if template.match?(/<ref\s*name=".*\|.*\"/i)
    
    template.gsub!(/<!--[\w\W]*?-->/,'')
    template.gsub!('{{USA}}', '[[United States]]')
    template.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
    params = Helper.parse_template(template)


    unless (params["municipality"].empty? || params["city"].empty?)
      if params["district"].empty?
        params['district_type'] = params.delete('municipality_type') || ''
        params['district'] = params.delete('municipality') || ''
        params['district1'] = params.delete('municipality1')|| ''
        params['district2'] = params.delete('municipality2')|| ''
        params['district3'] = params.delete('municipality3')|| ''
        params['district4'] = params.delete('municipality4')|| ''
        params['district5'] = params.delete('municipality5')|| ''
      end
    end
    
    # raise UnresolvedCase.new('contains unsupported param - width')          unless params["width"].empty?
    # raise UnresolvedCase.new('contains unsupported param - width-imperial') unless params["width_imperial"].empty?
    # raise UnresolvedCase.new('contains unsupported param - depth')          unless params["depth"].empty?
    # raise UnresolvedCase.new('contains unsupported param - depth-imperial') unless params["depth_imperial"].empty?
    # raise UnresolvedCase.new('contains unsupported param - depth1')           unless params["depth1"].empty?
    # raise UnresolvedCase.new('contains unsupported param - depth1_imperial')  unless params["depth1_imperial"].empty?
    # raise UnresolvedCase.new('contains unsupported param - free2')            unless params["free2"].empty?
    # raise UnresolvedCase.new('contains unsupported param - source_confluence')              unless params["source_confluence"].empty?
    # raise UnresolvedCase.new('contains unsupported param - source_confluence_location')     unless params["source_confluence_location"].empty?
    # raise UnresolvedCase.new('contains unsupported param - source_confluence_coordinates')  unless params["source_confluence_coordinates"].empty?
    
    # puts params["region"].inspect
    result = "{{Infobox river
| name               = #{params["name"]}#{"{{subst:PAGENAME}}" if params['name'].empty?}
| name_native        = #{params['native_name']}
| name_native_lang   = 
| name_other         = #{parse_other_name(params)}
| name_etymology     = #{params['etymology']}#{params['etymology_note']}
<!---------------------- IMAGE & MAP -->
| image              = #{params["image"]}
| image_size         = #{params['image_size']}
| image_caption      = #{params["image_caption"]}
| map                = #{params['map']}
| map_size           = #{params['map_size']}#{params['pushpin_map_size'] if params['map_size'].empty?}
| map_caption        = #{params['map_caption']}
| pushpin_map        = #{get_map(params)}
| pushpin_map_size   = #{params['map_size']}#{params['pushpin_map_size'] if params['map_size'].empty?}
| pushpin_map_caption= #{params['pushpin_map_caption']}
<!---------------------- LOCATION -->
| subdivision_type1  = Country
| subdivision_name1  = #{parse_multi_location(params, 'country')}
| subdivision_type2  = #{('State' unless(params["state"].empty? || !params['state_type'].empty?))||params["state_type"]}
| subdivision_name2  = #{parse_multi_location(params, 'state')}
| subdivision_type3  = #{('Region' unless (params["region"].empty? || !params['region_type'].empty?))||params["region_type"]}
| subdivision_name3  = #{parse_multi_location(params, 'region')}
| subdivision_type4  = #{('District' unless (params["district"].empty? || !params['district_type'].empty?))||params["district_type"]}
| subdivision_name4  = #{parse_multi_location(params, 'district')}
| subdivision_type5  = #{parse_city_type(params)}
| subdivision_name5  = #{parse_city(params)}
<!---------------------- PHYSICAL CHARACTERISTICS -->
| length             = #{parse_length(params)} 
| width_min          = 
| width_avg          = 
| width_max          = 
| depth_min          = 
| depth_avg          = 
| depth_max          = #{parse_discharge(params)}
<!---------------------- BASIN FEATURES -->#{parse_sources(params)}
| mouth              = #{autolink(params['mouth_name'])}#{autolink(params['mouth'])}#{params['mouth_note'] unless (params['mouth'].empty? && params['mouth_name'].empty?)}
| mouth_location     = #{parse_river_location(params, 'mouth')}
| mouth_coordinates  = #{params['mouth_coordinates']}#{params['mouth_coordinates_country']}#{params['mouth_coordinates_note']}
| mouth_elevation    = #{parse_mouth_elevation(params)}
| progression        = 
| waterfalls         = #{params['waterfalls']}
| river_system       = #{autolink(params['parent'])}
| basin_size         = #{parse_watershed(params)}
| tributaries_left   = #{parse_tributaries_l(params)}
| tributaries_right  = #{parse_tributaries_r(params)}
| custom_label       = #{params['free_type']}
| custom_data        = #{params['free']}
| extra              = #{params['footnotes']}
}}"

    # | basin_landmarks    =
    # | basin_population   =
    # | waterbodies        =
    # | waterfalls         =
    # | bridges            =
    # | ports              =

    result.gsub!('<nowiki>', '')
    result.gsub!('</nowiki>', '')

    # result

    page.sub!(old_template, result)
    page
  end
  def parse_geobox_to_protected_area(page)
    page.force_encoding('UTF-8')
    templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise NoTemplatesFound if templates.empty?
    raise UnresolvedCase if templates.size > 1

    template = templates.first
    old_template = template.dup
    template.gsub!(/<!--[\w\W]*?-->/,'')
    params = Helper.parse_template(template)

    params['district'] = '' unless params["district1"].empty?
    params['city']     = '' unless params["city1"].empty?
    params['region']   = '' unless params["region1"].empty?
    params['state']    = '' unless params["state1"].empty?

    # raise UnresolvedCase unless params["district1"].empty?
    # raise UnresolvedCase unless params["city1"].empty?
    # raise UnresolvedCase unless params["region1"].empty?
    # raise UnresolvedCase unless params["state1"].empty?

    # puts params["established_type"].inspect
    result = "{{Infobox protected area
| name            = #{params["name"]}
| iucn_category   = #{parse_iucn(params)[0]}
| iucn_ref        = #{parse_iucn(params)[1]}
<!-- images -->
| photo           = #{params["image"]}
| photo_caption   = #{params["image_caption"]}
<!-- map -->
| map             = #{get_map(params)}
| map_image       = #{params['map'] if get_map(params).empty?}
| map_size        = #{params['map_size']}#{params['pushpin_map_size'] if params['map_size'].empty?}
| map_caption     = #{params['pushpin_map_caption']}#{params['map_caption']}
| relief          = #{params["pushpin_map_relief"]}
<!-- location -->
| location        = #{parse_location(params)}
| nearest_city    = 
| nearest_town    = 
| coordinates     = #{params['coordinates']}
| coords_ref      = #{params['coordinates_note']}
<!-- stats --> 
| length          = #{parse_length(params)}
| length_mi       =
| length_km       = #{params['length']}
| width           = 
| width_mi        = 
| width_km        = #{params['width']}#{parse_area(params)}
| area_ref        = #{params['area_note']}
| elevation       = #{parse_elevation(params)}
| elevation_avg   = 
| elevation_min   = 
| elevation_max   = 
| dimensions      = 
| designation     = 
<!-- dates & info -->
| authorized      = 
| created         = 
| designated      = 
| established     = #{params['established']}#{params['established_note']}
| named_for       = #{params['etymology']}
| visitation_num  = #{params['visitation']}
| visitation_year = #{params['visitation_date']}
| visitation_ref  = #{params['visitation_note']}
| governing_body  = #{params['management_body']}
| administrator   = 
| operator        = #{params['management']}
| owner           =
<!-- website, embedded --> 
| website         = #{params['website']}
| embedded        = #{params['footnotes']}
}}"
    # | world_heritage_site =
    result.gsub!('<nowiki>', '')
    result.gsub!('</nowiki>', '')
    # result

    page.sub!(old_template, result)
    page
  end
  def parse_operator(params)
    return params['free'] if params['free_type'].downcase.strip == 'operator'
    return params['free1'] if params['free1_type'].downcase.strip == 'operator'
    return params['free2'] if params['free2_type'].downcase.strip == 'operator'
    return params['free3'] if params['free3_type'].downcase.strip == 'operator'
  end
# 
#   def parse_geobox_to_beach(page)
#     page.force_encoding('UTF-8')
#     templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
#     raise NoTemplatesFound if templates.empty?
#     raise UnresolvedCase if templates.size > 1
# 
#     template = templates.first
#     old_template = template.dup
#     template.gsub!(/<!--[\w\W]*?-->/,'')
#     params = Helper.parse_template(template)
# 
#     raise UnresolvedCase unless params["district1"].empty?
#     raise UnresolvedCase unless params["city1"].empty?
#     raise UnresolvedCase unless params["region1"].empty?
#     raise UnresolvedCase unless params["state1"].empty?
# 
#     # puts params["established_type"].inspect
#     result = "{{Infobox beach
# | patrolled              = 
# | name                   = #{params['name']}
# | image                  = #{params['image']}
# | caption                = #{params['image_caption']}
# | pushpin_map            = #{params['pushpin_map']}
# | pushpin_map_size       = #{'200px' if params['pushpin_map']=='Portugal'}
# | pushpin_map_caption    = #{params['pushpin_map_caption']}
# | location               = #{params['municipality']}, #{params['region']}, #{params['country']}
# | coordinates            = #{params['coordinates']}
# | access                 = 
# | beach_length           = 
# | beach_number           = 
# | hazard_rating          = 
# | patrolled_by           = 
# | activities             = 
# | last                   = 
# | next                   = 
# }}"
#     # | world_heritage_site =
#     result.gsub!('<nowiki>', '')
#     result.gsub!('</nowiki>', '')
#     # result
# 
#     page.sub!(old_template, result)
#     page
#   end
# 
  def parse_geobox_to_castle(page)
    page.force_encoding('UTF-8')
    templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise NoTemplatesFound if templates.empty?
    raise UnresolvedCase if templates.size > 1

    template = templates.first
    old_template = template.dup
    template.gsub!(/<!--[\w\W]*?-->/,'')
    params = Helper.parse_template(template)

    raise UnresolvedCase unless params["district1"].empty?
    raise UnresolvedCase unless params["city1"].empty?
    raise UnresolvedCase unless params["region1"].empty?
    raise UnresolvedCase unless params["state1"].empty?

    # puts params["established_type"].inspect
    result = "{{Infobox military installation
| name            = #{params['name']}
| ensign          = 
| ensign_size     =
| native_name     = #{params['native_name']}
| type            = #{params['category']}
<!-- images -->
| image           = #{params['image']}
| caption         = #{params['image_caption']}
<!-- maps and coordinates -->
| image_map             = #{params['map'] if get_map(params).empty?}
| map_caption           = #{params['map_caption'] if get_map_caption(params).empty?}
| pushpin_map           = #{get_map(params)}
| pushpin_relief        = #{params["pushpin_map_relief"]}
| pushpin_map_caption   = #{get_map_caption(params)} 
| coordinates           = #{params['coordinates']}
| coordinates_footnotes = #{params['coordinates_note']}
<!-- location -->
| partof           = 
| location         = #{parse_location_no_country(params)}
| nearest_town     = 
| country          = #{params['country'].sub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')}
<!-- stats -->
| ownership        = #{params['owner']}
| operator         = #{parse_operator(params)}
| open_to_public   = #{params['public']}
| site_area        = 
| built            = #{params['established']}
| used             = 
| builder          = 
| materials        = #{parse_materials(params)}
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
}}"
    # | world_heritage_site =
    result.gsub!('<nowiki>', '')
    result.gsub!('</nowiki>', '')
    # result

    page.sub!(old_template, result)
    page
  end
# 
#   def parse_geobox_to_bridge(page)
#     page.force_encoding('UTF-8')
#     templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
#     raise NoTemplatesFound if templates.empty?
#     raise UnresolvedCase if templates.size > 1
# 
#     template = templates.first
#     old_template = template.dup
#     template.gsub!(/<!--[\w\W]*?-->/,'')
#     params = Helper.parse_template(template)
# 
#     result = "{{Infobox bridge
# | name                = #{params['name']}
# | native_name         = #{params['native_name']}
# | native_name_lang    = 
# | official_name       = #{params['official_name']}
# | other_name          = #{params['other_name']}
# | named_for           = #{params['etymology']}
# <!-- image --> 
# | image               = #{params['image']}
# | caption             = #{params['image_caption']}
# <!-- location -->
# | coordinates         = #{params['coordinates']}#{params['coordinates_note']} 
# | locale              = #{parse_location(params)}
# <!-- stats -->
# | carries             = #{params['road']}
# | crosses             = #{params['river']}
# | owner               = 
# | maint               = #{params['management']} 
# | id_type             = #{parse_bridge_id(params)[0]}
# | id                  = #{parse_bridge_id(params)[1]}
# | website             = #{params['website']} 
# | design              = #{params['category']}
# | length              = #{parse_length(params)}
# | width               = #{parse_width(params)}
# | height              = #{parse_height(params)}
# | depth               = 
# | number_spans        = 
# | piers_in_water      = 
# | load                = #{parse_load(params)}
# | clearance_above     = 
# | clearance_below     = 
# | lanes               = 
# | life                = 
# | num_track           = 
# | track_gauge         = 
# | structure_gauge     = 
# | electrification     = 
# | architect           = 
# | designer            = 
# | builder             = #{params['author']} 
# | fabricator          = 
# | begin               = 
# | built               = #{params['established']}
# | complete            = 
# | cost                = 
# | open                =
# | inaugurated         = 
# | rebuilt             = 
# | destroyed           = #{parse_destruction(params)}
# | collapsed           = 
# | closed              = 
# | replaces            = 
# | replaced_by         = 
# | traffic             = 
# | toll                =
# <!-- map -->
# | map_type            = #{get_map(params)}
# | map_relief          = #{params["pushpin_map_relief"]}
# | map_image           = #{params['map'] if get_map(params).empty?}
# | map_size            = 
# | map_caption         = #{params['map_caption'] if get_map_caption(params).empty?}#{get_map_caption(params)} 
# <!-- extra -->
# | extra               = #{params["footnotes"]}{{Infobox NRHP
#  | name                 = 
#  | embed                = yes
#  | nrhp_type            = 
#  | architect            = 
#  | architecture         = 
#  | added                = #{parse_nrhp_added(params)}
#  | designated_nrhp_type = 
#  | refnum               = #{parse_refnum(params)}
#  | website              = 
#  | mpsub                = #{parse_mps(params)}
# }}
# }}"
#     # | world_heritage_site =
#     result.gsub!('<nowiki>', '')
#     result.gsub!('</nowiki>', '')
#     result.gsub!('{{USA}}', '[[United States]]')
#     # result
# 
#     page.sub!(old_template, result)
#     page
#   end
# 
#   def parse_geobox_to_building(page)
#     page.force_encoding('UTF-8')
#     templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
#     raise NoTemplatesFound if templates.empty?
#     raise UnresolvedCase if templates.size > 1
# 
#     template = templates.first
#     old_template = template.dup
#     template.gsub!(/<!--[\w\W]*?-->/,'')
#     params = Helper.parse_template(template)
# 
#     result = "{{Infobox building
# | name                = #{params['name']}#{'{{subst:PAGENAME}}' if params['name'].empty? }
# | native_name         = #{params['native_name']}
# | native_name_lang    = 
# <!-- images -->
# | logo                = #{params['flag']}#{params['symbol']}
# | logo_size           = #{'100px' unless (params['flag'].empty? && params['symbol'].empty?)}
# | logo_caption        = 
# | image               = #{params['image']} 
# | image_size          = 
# | image_caption       = #{params['image_caption']} 
# <!-- map -->
# | map_type            = #{get_map(params)}
# | pushpin_relief      = #{params["pushpin_map_relief"]}
# | image_map           = #{params['map'] if get_map(params).empty?}
# | map_caption         = #{params['map_caption'] if get_map_caption(params).empty?}#{get_map_caption(params)} 
# <!-- location -->
# | location            = #{params['location']}#{parse_location_no_country(params) if params['location'].empty?}
# | address             = 
# | location_city       = #{params['municipality']}
# | location_country    = #{params['country']}
# | coordinates         = #{params['coordinates']}#{params['coordinates_note']}
# <!-- stats -->
# | former_names        = 
# | alternate_names     = 
# | etymology           = 
# | status              = 
# | cancelled           = 
# | topped_out          = 
# | building_type       = #{params['category']}
# | architectural_style = #{params['style']}
# | material            = #{params['material']}
# | classification      = 
# | altitude            = 
# | namesake            = 
# | groundbreaking_date = 
# | start_date          = 
# | stop_date           = 
# | est_completion      = 
# | completion_date     = 
# | opened_date         = #{params['established']}
# | inauguration_date   = 
# | closing_date        = 
# | demolition_date     = 
# | destruction_date    = 
# | cost                = 
# | ren_cost            = 
# | client              = 
# | owner               = #{params['owner']}
# | affiliation         = 
# | height              = 
# | architectural       = 
# | structural_system   = 
# | size                = 
# | floor_count         = 
# | floor_area          = 
# | elevator_count      = 
# | grounds_area        = 
# | architect           = #{params['author']}
# | architecture_firm   = 
# | developer           = 
# | engineer            = 
# | known_for           = 
# | website             = #{params['website']}
# | embed               = 
# | embedded            = 
# | references          = 
# | footnotes           = 
# }}"
#     # | world_heritage_site =
#     result.gsub!('<nowiki>', '')
#     result.gsub!('</nowiki>', '')
#     result.gsub!('{{USA}}', '[[United States]]')
#     result.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
#     # result
# 
#     page.sub!(old_template, result)
#     page
#   end
# 
#   def parse_geobox_to_landform(page)
#     page.force_encoding('UTF-8')
#     templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
#     raise NoTemplatesFound if templates.empty?
#     raise UnresolvedCase if templates.size > 1
# 
#     template = templates.first
#     old_template = template.dup
#     template.gsub!(/<!--[\w\W]*?-->/,'')
#     params = Helper.parse_template(template)
# 
#     result = "{{Infobox landform
# | water             = 
# | name              = #{params['name']}
# | other_name        = #{params['other_name']}
# | photo             = #{params['image']}
# | photo_width       = 
# | photo_alt         = 
# | photo_caption     = #{params['image_caption']}
# <!-- map -->
# | map               = #{get_map(params)}
# | relief            = #{params["pushpin_map_relief"]}
# | map_image         = #{params['map'] if get_map(params).empty?}
# | map_caption       = #{params['map_caption'] if get_map_caption(params).empty?}#{get_map_caption(params)} 
# <!-- location -->
# | location          = #{params['location']}#{parse_location(params) if params['location'].empty?}
# | coordinates       = #{params['coordinates']}
# | coordinates_ref   = #{params['coordinates_note']}
# | range             = 
# | part_of           = 
# | water_bodies      = 
# | elevation_ft      = <!-- or |elevation_m = -->
# | elevation_ref     = 
# | surface_elevation_ft = <!-- or |surface_elevation_m = -->
# | surface_elevation_ref =
# | highest_point     = 
# | highest_elevation = 
# | highest_coords    = 
# | length            = #{parse_length(params)}
# | width             = #{parse_width(params)}
# | area              = 
# | depth             = 
# | drop              = 
# | formed_by         = 
# | geology           = #{params['geology']}
# | age               = 
# | orogeny           = 
# | volcanic_arc/belt = 
# | volcanic_arc      = 
# | volcanic_belt     = 
# | volcanic_field    = 
# | eruption          = 
# | last_eruption     = 
# | topo              = 
# | operator          = 
# | designation       = 
# | free_label_1      = 
# | free_data_1       = 
# | free_label_2      = 
# | free_data_2       = 
# | website           = #{params['website']}
# | embed             = 
# }}"
#     # | world_heritage_site =
#     result.gsub!('<nowiki>', '')
#     result.gsub!('</nowiki>', '')
#     result.gsub!('{{USA}}', '[[United States]]')
#     # result
# 
#     page.sub!(old_template, result)
#     page
#   end
# 
#   def parse_geobox_to_mountain(page)
#     page.force_encoding('UTF-8')
#     templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
#     raise NoTemplatesFound if templates.empty?
#     raise UnresolvedCase if templates.size > 1
# 
#     template = templates.first
#     old_template = template.dup
#     template.gsub!(/<!--[\w\W]*?-->/,'')
#     params = Helper.parse_template(template)
# 
#     result = "{{Infobox mountain
# | name              = #{params['name']}
# | other_name        = 
# | etymology         = 
# | native_name       = 
# | native_name_lang  = 
# | photo             = #{params['image']}
# | photo_caption     = #{params['image_caption']}
# <!-- map -->
# | map               = #{get_map(params)}
# | map_image         = #{params['map'] if get_map(params).empty?}
# | map_size          = #{params['map_size']}#{params['pushpin_map_size'] if params['map_size'].empty?}
# | map_caption       = #{params['pushpin_map_caption']}#{params['map_caption']}
# | location          = #{parse_location(params)}
# | label             = 
# | label_position    = 
# | elevation         = 
# | elevation_m       = #{params['elevation']}
# | elevation_ft      = #{params['elevation_imperial']}
# | elevation_ref     = #{params['elevation_note']}
# | prominence        = 
# | prominence_m      = #{params['prominence']}
# | prominence_ft     = #{params['prominence_imperial']}
# | prominence_ref    = #{params['prominence_note']}
# | isolation         = 
# | isolation_km      = 
# | isolation_mi      = 
# | isolation_ref     = 
# | parent_peak       = 
# | listing           = 
# | translation       = 
# | language          = 
# | pronunciation     = 
# | range             = #{params['parent']}
# | coordinates       = #{params['coordinates']}
# | coordinates_ref   = 
# | topo              = 
# | type              = #{params['category ']}
# | age               = 
# | geology           = #{params['geology']}
# | easiest_route     = 
# | normal_route      = 
# | access            = #{params['access']}
# | child             = 
# | embedded          = 
# }}"
#     # | world_heritage_site =
#     result.gsub!('<nowiki>', '')
#     result.gsub!('</nowiki>', '')
#     result.gsub!('{{USA}}', '[[United States]]')
#     # result
# 
#     page.sub!(old_template, result)
#     page
#   end
#   
#   def parse_geobox_to_ancient_site(page)
#     page.force_encoding('UTF-8')
#     templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
#     raise NoTemplatesFound if templates.empty?
#     raise UnresolvedCase if templates.size > 1
# 
#     template = templates.first
#     old_template = template.dup
#     template.gsub!(/<!--[\w\W]*?-->/,'')
#     params = Helper.parse_template(template)
# 
#     result = "{{Infobox ancient site
# | name           = #{params['name']}#{'{{subst:PAGENAME}}' if params['name'].empty? }
# | native_name    = #{params['native']}
# | alternate_name = #{params['other_name']}
# <!-- image & map -->
# | image          = #{params['image']}
# | image_size     = 
# | alt            = 
# | caption        = #{params['image_caption']}
# | map            = #{params['map'] if get_map(params).empty?}
# | map_type       = #{get_map(params)}
# | map_caption    = #{params['pushpin_map_caption']}#{params['map_caption']}
# | map_size       = #{params['map_size']}#{params['pushpin_map_size'] if params['map_size'].empty?}
# | coordinates    = #{params['coordinates']}#{params['coordinates_note']}
# | location       = #{parse_location(params)}
# | type           = #{params['category']}
# | part_of        = 
# <!-- stats -->
# | altitude_m     = #{params['elevation']}
# | length         = #{parse_length(params)}
# | width          = #{parse_width(params)}
# | area           = #{parse_area(params)}
# | volume         = 
# | diameter       = 
# | circumference  = 
# | height         = 
# | builder        = 
# | material       = 
# | built          = 
# | abandoned      = 
# | epochs         = <!-- actually displays as 'Periods' -->
# | cultures       = 
# | dependency_of  = 
# | occupants      = 
# | event          = 
# | discovered     = 
# | excavations    = 
# | archaeologists = #{params['author']}
# | condition      = 
# | ownership      = #{params['owner']}
# | management     = 
# | public_access  = #{params['public']} #{params['access']}
# | website        = #{params['website']}
# | notes          = 
# <!-- Other -->
# | other_designation =
# }}"
#     # | world_heritage_site =
#     result.gsub!('<nowiki>', '')
#     result.gsub!('</nowiki>', '')
#     result.gsub!('{{USA}}', '[[United States]]')
#     result.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
#     # result
# 
#     page.sub!(old_template, result)
#     page
#   end
#   
#   def parse_geobox_to_church(page)
#     page.force_encoding('UTF-8')
#     templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
#     raise NoTemplatesFound if templates.empty?
#     raise UnresolvedCase if templates.size > 1
# 
#     template = templates.first
#     old_template = template.dup
#     template.gsub!(/<!--[\w\W]*?-->/,'')
#     template.gsub!('{{flag|Azores|name=Azores}}', '[[Azores]]')
#     template.gsub!('{{flagu|Azores|name=Azores}}', '[[Azores]]')
#     params = Helper.parse_template(template)
# 
#     result = "{{Infobox church
# | name               = #{params['name']}#{'{{subst:PAGENAME}}' if params['name'].empty? }
# | fullname           = 
# | other name         = #{params['other_name']}
# | native_name        = #{params['native_name']}
# | image              = #{params['image']}
# | image_size         = #{params['image_size']}
# | caption            = #{params['image_caption']}
# <!-- Map & Location -->
# | pushpin map        = #{get_map(params)}
# | pushpin mapsize    = #{params['map_size']}#{params['pushpin_map_size'] if params['map_size'].empty?}
# | relief             = 
# | map caption        = #{params['pushpin_map_caption']}#{params['map_caption']}
# | coordinates        = #{params['coordinates']}
# | location           = #{parse_location_no_country(params)}
# | country            = #{params['country']}
# <!-- Stats -->
# | architect          = #{params['author']}
# | length             = #{"{{convert|#{params['length']}|m|abbr=on}}" unless params['length'].empty?}
# | width              = #{"{{convert|#{params['width']}|m|abbr=on}}" unless params['width'].empty?}
# | dedication         = #{params['etymology']} 
# | diocese            = #{params['free1']} 
# | denomination       = 
# | years built        = 
# | style              = #{parse_style(params)}
# | website            = #{params['website']}
# }}"
#     # | world_heritage_site =
#     result.gsub!('<nowiki>', '')
#     result.gsub!('</nowiki>', '')
#     result.gsub!('{{USA}}', '[[United States]]')
#     result.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
#     # result
# 
#     page.sub!(old_template, result)
#     page
#   end
end