require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require 'uri'
require 'colorize'
require 'json'

require_relative '../helper'

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=7913763&format=json'

TFD_LINK = "Wikipedia:Templates_for_discussion/Log/2019_March_9#Template:PeriodicTable-ImageMap"
TFD_TEXT = "{{Template for discussion/dated|action=|page=|link=#{TFD_LINK}|help=off|bigbox={{#invoke:Noinclude|noinclude|text=yes}}}}"

# TFD_TEXT = "{{mfd|Unused userbox template|help=off}}\n"
# TFD_TEXT = "<noinclude>{{db-xfd|fullvotepage=Wikipedia:Templates_for_discussion/Log/2019_February_27#All_templates_in_Category:Unnecessary_taxonomy_templates}}</noinclude>\n"

# titles = Helper.get_wmf_pages(url)
titles = ["Periodic table (actinides in the periodic table)", "Periodic table (d-block)", "Periodic table (eka-superactinides location)", "Periodic table (electron configuration lanthanides)", "Periodic table (f-block)", "Periodic table (metalloid)/Periodic table", "Periodic table (metals and nonmetals)/into image", "Periodic table (navbox isotopes)", "Periodic table (p-block)", "Periodic table (p-block trend)", "Periodic table (period 5)", "Periodic table (period 6)", "Periodic table (period 7)", "Periodic table (post-transition metals)", "Periodic table (s-block)", "Periodic table (standard atomic weight)", "Periodic table (superactinides)", "Periodic table (superactinides location)", ]
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

  client.edit(title: title, text: page, summary: 'bulk TFD')
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  sleep 2 + rand(5)
end
puts 'DONE!'