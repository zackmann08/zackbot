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

TFD_LINK = "Wikipedia:Templates_for_discussion/Log/2019_March_16#Unused_C.D._Primeiro_de_Agosto_templates"
TFD_TEXT = "{{Template for discussion/dated|action=|page=|link=#{TFD_LINK}|help=off|bigbox={{#invoke:Noinclude|noinclude|text=yes}}}}"

# TFD_TEXT = "{{mfd|Unused userbox template|help=off}}\n"
# TFD_TEXT = "<noinclude>{{db-xfd|fullvotepage=Wikipedia:Templates_for_discussion/Log/2019_February_27#All_templates_in_Category:Unnecessary_taxonomy_templates}}</noinclude>\n"

titles = ["C.D. Primeiro de Agosto (basketball) 2012-2013", "C.D. Primeiro de Agosto (basketball) 2013-2014", "C.D. Primeiro de Agosto (basketball) Women's 2012-2013", "C.D. Primeiro de Agosto (basketball) Women's 2013-2014", "C.D. Primeiro de Agosto (basketball) Women's 2014-2015", "C.D. Primeiro de Agosto (football) 1977", "C.D. Primeiro de Agosto (football) 2015", "C.D. Primeiro de Agosto (handball) Women's 2011-2012", "C.D. Primeiro de Agosto (handball) Women's 2012-2013", "C.D. Primeiro de Agosto (handball) Women's 2013-2014", "C.D. Primeiro de Agosto (volleyball) 2011-2012", "C.D. Primeiro de Agosto (volleyball) Women's 2011-2012", "C.D. Primeiro de Agosto 2002 Africa Clubs Champions Cup 1st Place", "C.D. Primeiro de Agosto 2012-13"]
puts titles.size
titles.each do |title|
  title.force_encoding('UTF-8')
  title = "Template:#{title}"
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body
  page.force_encoding('UTF-8')
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