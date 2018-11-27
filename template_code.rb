
# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'
text = <<~TEXT
embed | name | native_name | native_name_lang | other_name | image | image_size | alt | caption | image_map | image_map_alt | image_map_caption | pushpin_map | pushpin_map_alt | coordinates | pushpin_map_caption | etymology | name_etymology | tower | building | location | caster | commissioner | cast_date | installed_date | event1_date | event2_date | event3_date | event4_date | event5_date | event1 | event2 | event3 | event4 | event5 | volume | weight | width | height | material1 | material2 | material3 | material4 | material1_part | material2_part | material3_part | material4_part | hung | striking | operation | musical_note | earshot | website | footnotes   
TEXT

text.strip!
params = text.split('|')
params.map!(&:strip)
pad = params.max_by(&:length).length

result = params.map{|p| "| #{p.ljust(pad, ' ')} = \n"}
puts result
Clipboard.copy(result.join.strip)
