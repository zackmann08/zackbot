require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require 'uri'
require 'colorize'
require 'json'

require_relative '../helper'

Helper.read_env_vars(file = './vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=7913763&format=json'

TFD_TEXT = "{{Template for discussion/dated|action=|page=|link=Wikipedia:Templates_for_discussion/Log/2019_February_28#Unused_British_Columbia_provincial_election_2013_templates|help=off|bigbox={{#invoke:Noinclude|noinclude|text=yes}}}}"

# titles = Helper.get_wmf_pages(url)
titles = ["British Columbia provincial election, 2013/Burnaby-Edmonds", "British Columbia provincial election, 2013/Delta South", "British Columbia provincial election, 2013/Fort Langley-Aldergrove", "British Columbia provincial election, 2013/Fraser-Nicola", "British Columbia provincial election, 2013/Juan de Fuca", "British Columbia provincial election, 2013/Kamloops-North Thompson", "British Columbia provincial election, 2013/Kamloops-South Thompson", "British Columbia provincial election, 2013/Kootenay East", "British Columbia provincial election, 2013/Kootenay West", "British Columbia provincial election, 2013/Langley", "British Columbia provincial election, 2013/Maple Ridge-Mission", "British Columbia provincial election, 2013/Nelson-Creston", "British Columbia provincial election, 2013/New Westminster", "British Columbia provincial election, 2013/North Coast", "British Columbia provincial election, 2013/North Island", "British Columbia provincial election, 2013/North Vancouver-Lonsdale", "British Columbia provincial election, 2013/North Vancouver-Seymour", "British Columbia provincial election, 2013/Peace River North", "British Columbia provincial election, 2013/Peace River South", "British Columbia provincial election, 2013/Penticton", "British Columbia provincial election, 2013/Port Coquitlam", "British Columbia provincial election, 2013/Port Moody-Coquitlam", "British Columbia provincial election, 2013/Powell River-Sunshine Coast", "British Columbia provincial election, 2013/Prince George-Mackenzie", "British Columbia provincial election, 2013/Prince George-Valemount", "British Columbia provincial election, 2013/Richmond Centre", "British Columbia provincial election, 2013/Richmond East", "British Columbia provincial election, 2013/Saanich North and the Islands", "British Columbia provincial election, 2013/Saanich South", "British Columbia provincial election, 2013/Shuswap", "British Columbia provincial election, 2013/Skeena", "British Columbia provincial election, 2013/Surrey-Cloverdale", "British Columbia provincial election, 2013/Surrey-Fleetwood", "British Columbia provincial election, 2013/Surrey-Newton", "British Columbia provincial election, 2013/Surrey-Panorama", "British Columbia provincial election, 2013/Surrey-Tynehead", "British Columbia provincial election, 2013/Surrey-Whalley", "British Columbia provincial election, 2013/Vancouver-Fairview", "British Columbia provincial election, 2013/Vancouver-Hastings", "British Columbia provincial election, 2013/Vancouver-Kensington", "British Columbia provincial election, 2013/Vancouver-Kingsway", "British Columbia provincial election, 2013/Vancouver-Mount Pleasant", "British Columbia provincial election, 2013/Vancouver-Quilchena", "British Columbia provincial election, 2013/Vernon-Monashee", "British Columbia provincial election, 2013/West Vancouver-Capilano", "British Columbia provincial election, 2013/West Vancouver-Sea to Sky", "British Columbia provincial election, 2013/Westside-Kelowna"]
puts titles.size
titles.each do |title|
  title = "Template:#{title}"
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body
  old = page.dup

  page = TFD_TEXT + page

  if page == old
    Helper.print_link(title)
    Helper.print_message('NO CHANGE')
    next
  end

  client.edit(title: title, text: page, summary: 'bulk-tfd')
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  sleep 2 + rand(5)
end
puts 'DONE!'