require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=7913763&format=json'

titles = Helper.get_wmf_pages(url)
# titles = ['Hello, My Twenties!']
puts titles.size
titles.each do |title|
  # title = "Talk:#{title}"
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body
  old = page.dup
  
  page.gsub!(/\{\{volleyballbox2/i, '{{volleyballbox')

  # templates = page.scan(/(?=\{\{\s*(?:TV series order|TV program order))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
  # templates.each do |temp|
  #   page.gsub!(temp, '')
  # end


  if page == old
    Helper.print_link(title)
    Helper.print_message('NO CHANGE')
    next
  end
  
  client.edit(title: title, text: page, summary: 'converting to use [[Template:Volleyballbox]] per [[Wikipedia:Templates_for_discussion/Log/2019_February_5#Template:Volleyballbox]] (step 2 of 2)')
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  sleep 8 + rand(5)
end
puts 'DONE!'