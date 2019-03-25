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
url = 'https://petscan.wmflabs.org/?psid=8368847&format=json'

titles = Helper.get_wmf_pages(url)
# titles = ['Hello, My Twenties!']
puts titles.size
titles.each do |title|
  # title = "Talk:#{title}"
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body
  old = page.dup
  
  # page.gsub!(/\{\{volleyballbox2/i, '{{volleyballbox')
  page.gsub!(/<!--\s*The PBB_Summary template is automatically maintained by Protein Box Bot.\s*See Template:PBB_Controls to Stop updates. -->\n/i, '')
  page.gsub!(/PBB[\_\s]Summary/i, 'subst:PBB Summary')

  # templates = page.scan(/(?=\{\{\s*(?:TV series order|TV program order))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
  # templates.each do |temp|
  #   page.gsub!(temp, '')
  # end


  if page == old
    Helper.print_link(title)
    Helper.print_message('NO CHANGE')
    next
  end
  
  client.edit(title: title, text: page, summary: 'removing template per [[Wikipedia:Templates_for_discussion/Log/2019_March_9#Template:PBB_Controls]]', tags: 'AWB')
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 4 + rand(5)
end
puts 'DONE!'