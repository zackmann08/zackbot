require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require 'uri'
require 'colorize'
require 'json'
require_relative 'generic'
require_relative '../helper'
# encoding: utf-8
include Generic

SKIPS = [
    
]

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=7234654&format=json'

titles = Helper.get_wmf_pages(url)

puts titles.size
titles.each do |title|
  next if SKIPS.include?(title)
  puts title.colorize(:blue)
  text = client.get_wikitext(title).body
  text.force_encoding('UTF-8')
  old = text.dup
  begin
    text = parse_text(text)
  rescue Helper::NoTemplatesFound
    Helper.print_message('Template not found on page')
    next
  rescue Helper::UnresolvedCase => e
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
  
  summary = 'converting to use [[Template:Infobox amusement park]]'
  # summary = 'cleaning up and replacing deprecated parameters'

  client.edit(title: title, text: text, summary: summary)
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 10 + rand(8)
end
puts 'DONE!'