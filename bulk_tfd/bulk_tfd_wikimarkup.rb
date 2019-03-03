# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'

# \|\s*([\w-]*)(\s*)=
# | $1$2= #{params['$1']}


text = <<~TEXT
British Columbia provincial election, 2013/Burnaby-Edmonds	2017-05-16	transclusions
British Columbia provincial election, 2013/Delta South	2017-05-16	transclusions
British Columbia provincial election, 2013/Fort Langley-Aldergrove	2017-05-16	transclusions
British Columbia provincial election, 2013/Fraser-Nicola	2017-05-16	transclusions
British Columbia provincial election, 2013/Juan de Fuca	2017-05-16	transclusions
British Columbia provincial election, 2013/Kamloops-North Thompson	2017-05-16	transclusions
British Columbia provincial election, 2013/Kamloops-South Thompson	2017-05-16	transclusions
British Columbia provincial election, 2013/Kootenay East	2017-05-16	transclusions
British Columbia provincial election, 2013/Kootenay West	2017-05-16	transclusions
British Columbia provincial election, 2013/Langley	2017-05-16	transclusions
British Columbia provincial election, 2013/Maple Ridge-Mission	2017-05-16	transclusions
British Columbia provincial election, 2013/Nelson-Creston	2017-05-16	transclusions
British Columbia provincial election, 2013/New Westminster	2017-05-16	transclusions
British Columbia provincial election, 2013/North Coast	2017-05-16	transclusions
British Columbia provincial election, 2013/North Island	2017-05-16	transclusions
British Columbia provincial election, 2013/North Vancouver-Lonsdale	2017-05-16	transclusions
British Columbia provincial election, 2013/North Vancouver-Seymour	2017-05-16	transclusions
British Columbia provincial election, 2013/Peace River North	2017-05-16	transclusions
British Columbia provincial election, 2013/Peace River South	2017-05-16	transclusions
British Columbia provincial election, 2013/Penticton	2017-05-16	transclusions
British Columbia provincial election, 2013/Port Coquitlam	2017-05-16	transclusions
British Columbia provincial election, 2013/Port Moody-Coquitlam	2017-05-16	transclusions
British Columbia provincial election, 2013/Powell River-Sunshine Coast	2017-05-16	transclusions
British Columbia provincial election, 2013/Prince George-Mackenzie	2017-05-16	transclusions
British Columbia provincial election, 2013/Prince George-Valemount	2017-05-16	transclusions
British Columbia provincial election, 2013/Richmond Centre	2017-05-16	transclusions
British Columbia provincial election, 2013/Richmond East	2017-05-16	transclusions
British Columbia provincial election, 2013/Saanich North and the Islands	2017-05-16	transclusions
British Columbia provincial election, 2013/Saanich South	2017-05-16	transclusions
British Columbia provincial election, 2013/Shuswap	2017-05-16	transclusions
British Columbia provincial election, 2013/Skeena	2017-05-16	transclusions
British Columbia provincial election, 2013/Surrey-Cloverdale	2017-05-16	transclusions
British Columbia provincial election, 2013/Surrey-Fleetwood	2017-05-16	transclusions
British Columbia provincial election, 2013/Surrey-Newton	2017-05-16	transclusions
British Columbia provincial election, 2013/Surrey-Panorama	2017-05-16	transclusions
British Columbia provincial election, 2013/Surrey-Tynehead	2017-05-16	transclusions
British Columbia provincial election, 2013/Surrey-Whalley	2017-05-16	transclusions
British Columbia provincial election, 2013/Vancouver-Fairview	2017-05-16	transclusions
British Columbia provincial election, 2013/Vancouver-Hastings	2017-05-16	transclusions
British Columbia provincial election, 2013/Vancouver-Kensington	2017-05-16	transclusions
British Columbia provincial election, 2013/Vancouver-Kingsway	2017-05-16	transclusions
British Columbia provincial election, 2013/Vancouver-Mount Pleasant	2017-05-16	transclusions
British Columbia provincial election, 2013/Vancouver-Quilchena	2017-05-16	transclusions
British Columbia provincial election, 2013/Vernon-Monashee	2017-05-16	transclusions
British Columbia provincial election, 2013/West Vancouver-Capilano	2017-05-16	transclusions
British Columbia provincial election, 2013/West Vancouver-Sea to Sky	2017-05-16	transclusions
British Columbia provincial election, 2013/Westside-Kelowna
TEXT
text += "\n"
result = ''
text.each_line do |line|
  next if line.strip.empty?
  line.gsub!(/\t.*/,'')
  # line.gsub!(/(.*)\n/,"* {{Tfd links|\\1}}\n")
  line.gsub!(/(.*)\n/, "\"\\1\", ")
  result += line
end

puts result
Clipboard.copy(result)
