require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require './album'
# encoding: utf-8
include Album

SKIPS = [
    'Hakkin no Yoake',
    "Sucker M.C.'s"
]

# TODO check for proper use of the template AFTER converting. 
# https://en.wikipedia.org/w/api.php?action=query&format=json&prop=templates&titles=#{title}&tllimit=500
# Use the above endpoint to get a list of all the templates. 
# Ensure that Template:Infobox album is in the list.

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
# client.log_in 'ZackBot', ENV['PASSWORD']
# ALL pages in category
# url = 'https://petscan.wmflabs.org/?psid=6465241&format=json'
url = 'https://petscan.wmflabs.org/?psid=6488551&format=json'

# Only Infobox Album
# url = 'https://petscan.wmflabs.org/?psid=6112476&format=json'

# Infobox album AND singles
# url = 'https://petscan.wmflabs.org/?psid=6150855&format=json'
# Infobox album and OPTIONAL singles (can be there, not required)
# url = 'https://petscan.wmflabs.org/?psid=6185992&format=json'
# Infobox album and one of the other templates
# url = 'https://petscan.wmflabs.org/?psid=6150870&format=json'

# Infobox single
# url = 'https://petscan.wmflabs.org/?psid=6352308&format=json'

titles = Helper.get_wmf_pages(url)
# titles.reverse!

count = 0 
puts titles.size
titles.each do |title|
  # break if count>50
  next if SKIPS.include?(title)
  puts title.colorize(:blue)
  text = client.get_wikitext(title).body
  text.force_encoding('UTF-8')
  old = text.dup
  begin
    text = parse_album(text)
  rescue Page::NoTemplatesFound, Album::NoTemplatesFound
    Helper.print_message('Template not found on page')
    next
  rescue Page::UnresolvedCase => e
    Helper.print_link(title)
    Helper.print_message('Hit an unresolved case')
    next
  rescue Encoding::CompatibilityError => e
    Helper.print_message('Compatibility Error')
    next
  end
  
  # puts text.colorize(:red)
  if text == old
    Helper.print_link(title)
    Helper.print_message('NO CHANGE')
    next
  end

  # client.edit(title: title, text: text, summary: 'fixing deprecated params, [[Wikipedia:Bots/Requests_for_approval/ZackBot_11|ZackBot 11 Trial]]')
  client.edit(title: title, text: text, summary: 'fixing deprecated params')
  count += 1
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 10 + rand(5)
end
puts 'DONE!'