# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require 'csv'

# \|\s*([\w-]*)(\s*)=
# | $1$2= #{params['$1']}


text = <<~TEXT
alternative_map | bus | caption | cause | coordinates | country | crew | damage | date | deaths | footnotes | image | image_alt | image_map | image_map_alt | image_map_caption | image_size | injuries | line | location | location_city | location_dir | location_dist_km | location_dist_mi | map_type | mapframe | mapframe_height | mapframe_marker | mapframe_marker_color | mapframe_marker_colour | mapframe_width | mapframe_zoom | name | operator | owner | passengers | pedestrians | property | pushpin_map | pushpin_map_alt | pushpin_map_caption | qid | route_map | route_map_name | route_map_state | service | time | trains | type | vehicles    
TEXT

text.strip!
text = text.split('|')
params = text.map{|param| param.strip!}

file_name = 'template_data.csv'
raise('file exists') if File.file?(file_name)
header = ['name', 'label', 'description', 'example', 'type', 'default', 'required']
CSV.open(file_name, 'w') do |csv|
  csv << header
  params.each do |param|
    csv << [param, param.split('_').map(&:capitalize).join(' '), '', '', '', '', '']
  end
end