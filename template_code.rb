
# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'
text = <<~TEXT
wide | name | title | image | logo | image_size | image_upright | alt | caption | team1logo | team2logo | team3logo | team4logo | team1 | team2 | team3 | team4 | native name | native_name | other names | sport | type | city or region | teams involved | teams | first contested | firstmeeting | mostrecent | nextmeeting | broadcasters | stadiums | trophy | total | most wins | most player appearances | top scorer | alltimerecord | series | regularseason | postseason | largestvictory | largestscoring | longeststreak | longestunbeatenstreak | currentstreak | currentunbeatenstreak | league | trophy series | smallestvictory | section_info | section_header | map_location | map_width | map_caption | map_alt | map_relief | map_label1 | map_label1_position | map_mark1 | coordinates1 | coordinates | map_label2 | map_label2_position | map_mark2 | coordinates2 | map_label3 | map_label3_position | map_mark3 | coordinates3 | map_label4 | map_label4_position | map_mark4 | coordinates4
TEXT

text.strip!
params = text.split('|')
params.map!(&:strip)
pad = params.max_by(&:length).length

result = params.map{|p| "| #{p.ljust(pad, ' ')} = \n"}
puts result
Clipboard.copy(result.join.strip)
