
# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
text = <<~TEXT
Name | Image | Image_size | alt | Nickname | Coach | Association | Colors | First year | Titles | Runners-up | Best | Entries | European Titles | European Runners-up | European Best | Asian Titles | Asian Runners-up | Asian Best      
TEXT

text.strip!
params = text.split('|')
params.map!(&:strip)
pad = params.max_by(&:length).length

result = params.map{|p| "| #{p.ljust(pad, ' ')} = \n"}
puts result
Clipboard.copy(result.join.strip)
