# encoding: utf-8
require_relative '../helper'

module Generic
  
  def check_for_plus_minus(param)
    raise Helper::UnresolvedCase.new("±") if (param && param.include?('±'))
    raise Helper::UnresolvedCase.new("not a number") if (param && param.match?(/[^0-9\.\,]/))
    
  end
  
  def parse_apastron(params)
    check_for_plus_minus(params['apastron'])
    check_for_plus_minus(params['apastron_gm'])
    return "{{convert|#{params['apastron']}|AU|km|abbr=on}}" if params['apastron']
    return "{{convert|#{params['apastron_gm']}|Gm|abbr=on}}" if params['apastron_gm']
    return ''
  end
  def parse_periastron(params)
    check_for_plus_minus(params['periastron'])
    check_for_plus_minus(params['periastron_gm'])
    return "{{convert|#{params['periastron']}|AU|km|abbr=on}}" if params['periastron']
    return "{{convert|#{params['periastron_gm']}|Gm|abbr=on}}" if params['periastron_gm']
    return ''
  end

  def parse_radius(params)
    check_for_plus_minus(params['radius_megameter'])
    values = []
    values << "#{params['planet_radius']} {{Jupiter radius|link=y}}" if params['planet_radius']
    values << "#{params['radius_earth']} {{Earth radius|link=y}}" if params['radius_earth']
    values << "{{convert|#{params['radius_megameter']}|Mm|lk=on|abbr=on}}" if params['radius_megameter']
    return values.join('<br>')
  end
  
  def parse_semimajor(params)
    check_for_plus_minus(params['semimajor'])
    check_for_plus_minus(params['semimajor_gm'])
    return "{{convert|#{params['semimajor']}|AU|km|abbr=on}}" if params['semimajor']
    return "{{convert|#{params['semimajor_gm']}|Gm|abbr=on}}" if params['semimajor_gm']
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
    check_for_plus_minus(params['density'])
    check_for_plus_minus(params['density_cgs'])
    density = params['density']
    density_cgs = params['density_cgs']

    return "{{convert|#{density}|kg/m3|lk=on|abbr=on}}" if density
    return "{{convert|#{density_cgs}|g/cm3|lk=on|abbr=on}}" if density_cgs
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
    check_for_plus_minus(params['gravity'])
    check_for_plus_minus(params['gravity_earth'])
    gravity = params['gravity']
    earth_g = params['gravity_earth']
    
    if gravity
      return "{{convert|#{gravity}|m/s2|lk=on|abbr=on}}<br>#{earth_g} [[g-force|g]]" if earth_g
      return "{{convert|#{gravity}|m/s2|lk=on|abbr=on}}"
    elsif earth_g
      return "#{earth_g} [[g-force|g]]" 
    end
    ''
  end
  
  TEMPLATES = ["Planetbox begin", "Planetbox image", "Planetbox star", "Planetbox star detail|Planetbox star detail", "Planetbox separation", "Planetbox orbit", "Planetbox character", "Planetbox discovery", "Planetbox catalog", "Planetbox reference", "Planetbox end"]
  def parse_text(text)
    text.force_encoding('UTF-8')
    params = {}
    params.default = nil
    TEMPLATES.each do |temp|
      templates = text.scan(/(?=\{\{\s*(?:#{temp}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
      raise Helper::UnresolvedCase.new("More than 1 template (#{temp})") if templates.size > 1
      next if templates.size == 0
      template = templates.first
      
      new_params = Helper.parse_template(template)
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
      puts new_params.keys & params.keys
      raise Helper::UnresolvedCase.new("Duplicate params") unless (new_params.keys & params.keys).empty?
      
      # template.gsub!(/<!--[\w\W]*?-->/,'')
      text.sub!(template, 'ZWTEMP@@@@@')
      params.merge!(new_params)
    end
    
    # puts params.inspect
    # return 'a'
    
    #DO NOT COMMENT THIS OUT! Will break custom parsing (mass, gravity, etc. )
    params.reject!{|_k,v| v.nil? || v.empty?}
      
    result = "{{Infobox planet
| name                     = #{params['name']}
| symbol                   = 
| image                    = #{params['image']}
| image_size               = 
| image_alt                = 
| caption                  = #{params['caption']}
| background               = 
| bgcolour                 = 
| label_width              = 
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
| star                     = #{params['star']}
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
    # # result.gsub!(/\|.*\=\s*\n/, '')
       
    text = text.sub(/(?:ZWTEMP@@@@@\s*\n)+/i, result)
    text.gsub!(/<ref name="Gaia DR2".*\n*/, '')
    text.gsub!(/<ref name="van Leeuwen2007".*\n*/, '')
    # puts text
    
    raise Helper::UnresolvedCase.new("ZWTEMP present")  if text.include?('ZWTEMP@@@@@')
    text
  end
end
