
# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
text = <<~TEXT
name | symbol | image | image_size | image_alt | caption | background | bgcolour | label_width | discoverer | discovery_site | discovered | discovery_method | discovery_ref | mpc_name | mp_name | named_after | alt_names | mp_category | pronounce | pronounced | adjective | adjectives | extrasolarplanet | exosolar planets | minorplanet | orbit_diagram | epoch | uncertainty | observation_arc | earliest_precovery_date | aphelion | perihelion | periapsis | apoapsis | semimajor | mean_orbit_radius | eccentricity | period | synodic_period | avg_speed | mean_anomaly | inclination | angular_dist | asc_node | long_periastron | time_periastron | arg_peri | semi-amplitude | satellite_of | satellites | moid | mercury_moid | venus_moid | mars_moid | jupiter_moid | saturn_moid | uranus_moid | neptune_moid | orbit_ref | apsis | mean_motion | allsatellites | tisserand | p_semimajor | p_eccentricity | p_mean_motion | p_inclination | node_rate | perihelion_rate | p_orbit_ref | dimensions | mean_diameter | mean_radius | equatorial_radius | polar_radius | flattening | circumference | surface_area | volume | mass | density | surface_grav | moment_of_inertia_factor | escape_velocity | rotation | sidereal_day | rot_velocity | axial_tilt | right_asc_north_pole | declination | pole_ecliptic_lat | pole_ecliptic_lon | albedo | single_temperature | temp_name1 | temp_name2 | temp_name3 | temp_name4 | spectral_type | magnitude | abs_magnitude | angular_size | physical_ref | min_temp_1 | mean_temp_1 | max_temp_1 | min_temp_2 | mean_temp_2 | max_temp_2 | min_temp_3 | mean_temp_3 | max_temp_3 | min_temp_4 | mean_temp_4 | max_temp_4 | family | atmosphere | scale_height | atmosphere_composition | atmosphere_ref | surface_pressure | note      
TEXT

text.strip!
params = text.split('|')
params.map!(&:strip)
pad = params.max_by(&:length).length

result = params.map{|p| "| #{p.ljust(pad, ' ')} = \n"}
puts result
Clipboard.copy(result.join.strip)
