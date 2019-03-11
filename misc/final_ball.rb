require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=8161954&format=json'

TEMPLATE_REGEX = 'OGol|Ogol|TheFinalBall player|Zerozero|Zerozero profile|TheFinalBall'
titles = Helper.get_wmf_pages(url)
# titles = ['User:Zackmann08/sandbox']
puts titles.size
titles.each do |title|
  # title = "Talk:#{title}"
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body
  old = page.dup
  
  if page.match?(/<ref.*?>\{\{(?:#{TEMPLATE_REGEX})/i)
    Helper.print_link(title)
    Helper.print_message('Has reference')
    next
  end

  templates = page.scan(/(?=\{\{(?:#{TEMPLATE_REGEX}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
  templates.each do |template|
    page.gsub!(/\*\s*#{Regexp.escape(template)}\n?/, '')
  end

  if page == old
    Helper.print_link(title)
    Helper.print_message('NO CHANGE')
    next
  end

  client.edit(title: title, text: page, summary: 'removing template per [[Wikipedia:Templates_for_discussion/Log/2019_February_13#Template:TheFinalBall]]')
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  sleep 6 + rand(5)
end
puts 'DONE!'