# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'

# \|\s*([\w-]*)(\s*)=
# | $1$2= #{params['$1']}


text = <<~TEXT
  name | logo | image size | image_size | imagesize | alt | logo_caption | image | caption | slogan | resort | location | location2 | location3 | coordinates | theme | owner | operator | general_manager | status | opening_date | closing_date | previous_names | season | visitors | area | area_ha | area_acre | rides | coasters | water_rides | homepage | footnotes   
TEXT

text.strip!
text+='|' unless text.end_with?('|')
text.gsub!(/\s*([\s\w\-\/]*)\|/, "| \\1 = \\1\n")
puts text
Clipboard.copy(text)
