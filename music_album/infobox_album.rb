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

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
# ALL pages in category
# url = 'https://petscan.wmflabs.org/?psid=6112363&format=json'

# Only Infobox Album
url = 'https://petscan.wmflabs.org/?psid=6112476&format=json'

titles = Helper.get_wmf_pages(url)

titles.each do |title|
  puts title.colorize(:blue)
  text = client.get_wikitext(title).body
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

  client.edit(title: title, text: text, summary: 'fixing deprecated params')

  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 12 + rand(5)
end
puts 'DONE!'