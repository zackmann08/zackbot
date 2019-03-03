
# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
text = <<~TEXT
 name | other_names | image | sampleimage | image_size | image_alt | caption | series | founded | founder | leader | capital | homeworld | base_of_operations | kind | official_language | language | currency | flagship | anthem | religion | firstapp | creator | distinctions | races | actor | footnotes       
TEXT

text.strip!
params = text.split('|')
params.map!(&:strip)
pad = params.max_by(&:length).length

result = params.map{|p| "| #{p.ljust(pad, ' ')} = \n"}
puts result
Clipboard.copy(result.join.strip)
