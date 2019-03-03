# encoding: utf-8
require_relative '../../helper'

module Generic
  
  REF_REGEX = /<ref>*[\w\W]*?(?:\/>|<\/ref>)/i

  def check_for_not_a_number(param)
    ref = ''
    val = (param && param.include?('±')) ? param.gsub(/\s*±\s*/, '|±|') : param
    if val && val.match?(REF_REGEX)
      ref = val.match(REF_REGEX)[0]
      val = val.gsub!(REF_REGEX, '')
    end
    return param if (val && val.match?(/[^0-9\.\,±\|]/))
    nil
  end
  def check_for_plus_minus(param)
    ref = ''
    val = (param && param.include?('±')) ? param.gsub(/\s*±\s*/, '|±|') : param
    if val && val.match?(REF_REGEX)
      ref = val.match(REF_REGEX)[0]
      val = val.gsub!(REF_REGEX, '')
    end
    raise Helper::UnresolvedCase.new(param) if (val && val.match?(/[^0-9\.\,±\|]/))
    [val, ref]
  end
  # def check_for_plus_minus(param)
  #   raise Helper::UnresolvedCase.new("not a number") if (param && param.match?(/[^0-9\.\,]/))
  #   return param.gsub!(/\s*±\s*/, '|±|') if (param && param.include?('±'))
  #   raise Helper::UnresolvedCase.new("±") if (param && param.include?('±'))
  #   
  #   param
  # end
  
  def parse_apastron(params)
    return "#{check_for_not_a_number(params['apastron'])} [[astronomical unit|AU]]" if check_for_not_a_number(params['apastron'])
    return "#{check_for_not_a_number(params['apastron_gm'])} [[gigameter|Gm]]" if check_for_not_a_number(params['apastron_gm'])
    apastron = check_for_plus_minus(params['apastron'])
    apastron_gm = check_for_plus_minus(params['apastron_gm'])
    return "{{convert|#{apastron[0]}|AU|km|abbr=on}}#{apastron[1]}" if params['apastron']
    return "{{convert|#{apastron_gm[0]}|Gm|abbr=on}}#{apastron_gm[1]}" if params['apastron_gm']
    return ''
  end
  def parse_periastron(params)
    return "#{check_for_not_a_number(params['periastron'])} [[astronomical unit|AU]]" if check_for_not_a_number(params['periastron'])
    return "#{check_for_not_a_number(params['periastron_gm'])} [[gigameter|Gm]]" if check_for_not_a_number(params['periastron_gm'])
    periastron = check_for_plus_minus(params['periastron'])
    periastron_gm =check_for_plus_minus(params['periastron_gm'])
    return "{{convert|#{periastron[0]}|AU|km|abbr=on}}#{periastron[1]}" if params['periastron']
    return "{{convert|#{periastron_gm[0]}|Gm|abbr=on}}#{periastron_gm[1]}" if params['periastron_gm']
    return ''
  end

  def parse_radius(params)
    return "#{check_for_not_a_number(params['radius_megameter'])} [[Megametre|Mm]]" if check_for_not_a_number(params['radius_megameter'])
    radius_megameter = check_for_plus_minus(params['radius_megameter'])
    values = []
    values << "#{params['planet_radius']} {{Jupiter radius|link=y}}" if params['planet_radius']
    values << "#{params['radius_earth']} {{Earth radius|link=y}}" if params['radius_earth']
    values << "{{convert|#{radius_megameter[0]}|Mm|lk=on|abbr=on}}#{radius_megameter[1]}" if params['radius_megameter']
    return values.join('<br>')
  end
  
  def parse_semimajor(params)
    return "#{check_for_not_a_number(params['semimajor'])} [[astronomical unit|AU]]" if check_for_not_a_number(params['semimajor'])
    return "#{check_for_not_a_number(params['semimajor_gm'])} [[gigameter|Gm]]" if check_for_not_a_number(params['semimajor_gm'])
    semimajor = check_for_plus_minus(params['semimajor'])
    semimajor_gm = check_for_plus_minus(params['semimajor_gm'])
    return "{{convert|#{semimajor[0]}|AU|km|abbr=on}}#{semimajor[1]}" if params['semimajor']
    return "{{convert|#{semimajor_gm[0]}|Gm|abbr=on}}#{semimajor_gm[1]}" if params['semimajor_gm']
    return "#{params['semimajor_mas']} [[Minute and second of arc|mas]]" if params['semimajor_mas']
    return ''
  end
  
  def parse_period(params)
    values = []
    values << "#{params['period']} [[day|d]]" if params['period']
    values << "#{params['period_year']} [[year|y]]" if params['period_year']
    values << "#{params['period_hour']} [[hour|h]]" if params['period_hour']
    return values.join('<br>')
  end
  
  def parse_density(params)
    return "#{check_for_not_a_number(params['density'])} [[kilogram|kg]] [[cubic metre|m<sup>−3</sup>]]" if check_for_not_a_number(params['density'])
    return "#{check_for_not_a_number(params['density_cgs'])} [[gram|g]] [[cubic centimetre|cm<sup>−3</sup>]]" if check_for_not_a_number(params['density_cgs'])
    density= check_for_plus_minus(params['density'])
    density_cgs = check_for_plus_minus(params['density_cgs'])

    return "{{convert|#{density[0]}|kg/m3|lk=on|abbr=on}}#{density[1]}" if params['density']
    return "{{convert|#{density_cgs[0]}|g/cm3|lk=on|abbr=on}}#{density_cgs[1]}" if params['density_cgs']
    return ''
  end
  def parse_mass(params)
    mass_jupiter = params['planet_mass']
    mass_earth   = params['mass_earth']
    
    if mass_jupiter
      return "#{mass_jupiter} {{Jupiter mass|link=y}}<br>(#{mass_earth} {{Earth mass|link=y}})" if mass_earth
      return "#{mass_jupiter} {{Jupiter mass|link=y}}"
    elsif mass_earth
      return "#{mass_earth} {{Earth mass|link=y}}" 
    end
    ''
  end
  def parse_gravity(params)
    return "#{check_for_not_a_number(params['gravity'])} [[Metre per second squared|m/s²]] " if check_for_not_a_number(params['gravity'])
    gravity = check_for_plus_minus(params['gravity'])
    earth_g = params['gravity_earth']
    
    if gravity[0] && !gravity[0].empty?
      return "{{convert|#{gravity[0]}|m/s2|lk=on|abbr=on}}#{gravity[1]}<br>#{earth_g} [[g-force|g]]" if earth_g
      return "{{convert|#{gravity[0]}|m/s2|lk=on|abbr=on}}#{gravity[1]}"
    elsif earth_g
      return "#{earth_g} [[g-force|g]]"
    end
    ''
  end
  
  TEMPLATES = ["Planetbox begin", "Planetbox image", "Planetbox star", "Planetbox star detail|Planetbox star detail", "Planetbox separation", "Planetbox orbit", "Planetbox character", "Planetbox discovery", "Planetbox catalog", "Planetbox reference", "Planetbox end"]
  def parse_text(text)
    text.force_encoding('UTF-8')
    # planetary_radius = text.scan(/(?=\{\{\s*(?:Planetary radius))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    # raise Helper::UnresolvedCase.new("Contains Planetary radius template") if planetary_radius.size > 1
    # 
    # text.gsub!(planetary_radius.first,'') unless planetary_radius.nil? || planetary_radius.empty?
    #  
    params = {}
    params.default = nil
    TEMPLATES.each do |temp|
      templates = text.scan(/(?=\{\{\s*(?:#{temp}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
      raise Helper::UnresolvedCase.new("More than 1 template (#{temp})") if templates.size > 1
      next if templates.size == 0
      template = templates.first
      new_params = Helper.parse_template(template, true)

      # puts "###########"
      # puts template
      # puts "###########"
      text.gsub!(template, 'ZWTEMP@@@@@')
      # puts "$$$$$"
      # puts text
      # puts "$$$$$"
      
      # puts new_params.inspect
      if temp == 'Planetbox character'
        new_params['planet_radius'] = new_params.delete('radius')
        new_params['planet_mass'] = new_params.delete('mass')
        new_params['planet_temperature'] = new_params.delete('temperature')
      elsif temp == 'Planetbox star'
        new_params['star_radius'] = new_params.delete('radius')
        new_params['star_mass'] = new_params.delete('mass')
        new_params['star_temperature'] = new_params.delete('temperature')
        new_params['star_name'] = new_params.delete('star')
      elsif temp == 'Planetbox orbit'
        new_params['orbit_epoch'] = new_params.delete('epoch')
      elsif temp == 'Planetbox separation'
        new_params['separation_epoch'] = new_params.delete('epoch')
      elsif temp == 'Planetbox reference'
        new_params['reference_star_name'] = new_params.delete('star')
      end
      
      # puts "!!!#{temp}"
      # puts new_params.keys & params.keys
      raise Helper::UnresolvedCase.new("Duplicate params: #{new_params.keys & params.keys}") unless (new_params.keys & params.keys).empty?
     
      params.merge!(new_params)
    end
    
    # puts params.inspect
    # return 'a'
    
    #DO NOT COMMENT THIS OUT! Will break custom parsing (mass, gravity, etc. )
    params.reject!{|_k,v| v.nil? || v.empty?}
      
    result = "{{Infobox planet
| name                     = #{params['name']}
| image                    = #{params['image']}
| caption                  = #{params['caption']}
<!-- DISCOVERY           -->
| discoverer               = #{params['discoverers']}
| discovery_site           = #{params['discovery_site']}
| discovered               = #{params['discovery_date']}
| discovery_method         = #{params['discovery_method']}
| discovery_ref            =
<!-- DESIGNATIONS        -->
| exosolar planets         = 
| minorplanet              = 
| extrasolarplanet         =  
| mpc_name                 =
| pronounced               =  
| named_after              = 
| alt_names                = 
| mp_category              = 
| adjectives               = 
<!-- ORBITAL             --> 
| orbit_ref                = 
| orbit_diagram            = 
| epoch                    = #{params['orbit_epoch']}
| uncertainty              = 
| observation_arc          = 
| earliest_precovery_date  = 
| apsis                    = astron
| aphelion                 = #{parse_apastron(params)}
| perihelion               = #{parse_periastron(params)}
| semimajor                = #{parse_semimajor(params)}
| mean_orbit_radius        = 
| eccentricity             = #{params['eccentricity']}
| period                   = #{parse_period(params)}
| synodic_period           = 
| avg_speed                = #{params['speed']}
| mean_anomaly             = #{params['mean_anomaly']}
| mean_motion              = 
| inclination              = #{params['inclination']}
| angular_dist             = 
| asc_node                 = #{params['node']}
| long_periastron          = #{params['mean_longitude']}
| time_periastron          = #{params['t_peri']||params['t_peri_no_jd']}
| arg_peri                 = #{params['arg_peri']}
| semi-amplitude           = #{params['semi-amp']}
| satellite_of             = 
| satellites               = 
| star                     = #{params['star_name']}
| allsatellites            = 
| tisserand                = 
<!-- PHYS CHARS          --> 
| physical_ref             =
| dimensions               = 
| mean_diameter            = 
| mean_radius              = #{parse_radius(params)}
| equatorial_radius        = 
| polar_radius             = 
| flattening               = 
| circumference            = 
| surface_area             = 
| volume                   = 
| mass                     = #{parse_mass(params)}
| density                  = #{parse_density(params)}
| surface_grav             = #{parse_gravity(params)}
| moment_of_inertia_factor = 
| escape_velocity          = 
| rotation                 = #{params['rotation_period']}
| sidereal_day             = 
| rot_velocity             = 
| axial_tilt               = 
| right_asc_north_pole     = 
| declination              = 
| pole_ecliptic_lat        = 
| pole_ecliptic_lon        = 
| albedo                   = #{params['geometric_albedo']}
| single_temperature       = #{params['planet_temperature']}
| spectral_type            = 
| magnitude                = 
| abs_magnitude            = 
| angular_size             = 
| family                   =
<!-- ATMOSPHERE          --> 
| atmosphere_ref           =  
| atmosphere               = 
| scale_height             = 
| surface_pressure         = 
| atmosphere_composition   = 
<!-- NOTES               --> 
| note                     =
}}\n"
    
    result.gsub!('<nowiki>', '')
    result.gsub!('</nowiki>', '')
    
    
    # # This will strip un-used parmeters
    result.gsub!(/\|.*\=\s*\n/, '')
       
    text = text.sub(/(?:ZWTEMP@@@@@\s*\n)+/i, result)
    text.gsub!(/<ref name="Gaia DR2".*\n*/, '')
    text.gsub!(/<ref name="van Leeuwen2007".*\n*/, '')
    # puts text
    
    raise Helper::UnresolvedCase.new("ZWTEMP present")  if text.include?('ZWTEMP@@@@@')
    text
  end
end
