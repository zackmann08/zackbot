
# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'
text = <<~TEXT
name | logo | logo_size | alt | logo_caption | image | image_size | caption | slogan | resort | location | location2 | location3 | coordinates | theme | owner | operator | general_manager | status | opening_date | closing_date | previous_names | season | visitors | area | area_ha | area_acre | rides | coasters | water_rides | other_rides | shows | homepage | park1 | coordinates1 | status1 | opened1 | closed1 | replaced1 | replacement1 | park2 | coordinates2 | status2 | opened2 | closed2 | replaced2 | replacement2 | park3 | coordinates3 | status3 | opened3 | closed3 | replaced3 | replacement3 | park4 | coordinates4 | status4 | opened4 | closed4 | replaced4 | replacement4 | park5 | coordinates5 | status5 | opened5 | closed5 | replaced5 | replacement5 | park6 | coordinates6 | status6 | opened6 | closed6 | replaced6 | replacement6 | footnotes   
TEXT

text.strip!
params = text.split('|')
params.map!(&:strip)
pad = params.max_by(&:length).length

result = params.map{|p| "| #{p.ljust(pad, ' ')} = \n"}
puts result
Clipboard.copy(result.join.strip)
