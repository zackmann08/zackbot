require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require './geobox'
# encoding: utf-8
include Geobox

SKIPS = [
    'Hudson River',
    'Baixa da Ponta dos Rosais'
]


Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=6503971&format=json'

titles = Helper.get_wmf_pages(url)
puts titles.size
titles.reverse!
# count = 1
titles.each do |title|
  next if SKIPS.include?(title)
  puts title.colorize(:blue)
  text = client.get_wikitext(title).body
  text.force_encoding('UTF-8')
  begin
    text = parse_geobox_to_river(text)
  rescue Geobox::UnresolvedCase => e
    Helper.print_link(title)
    Helper.print_message(e)
    Helper.print_message('Hit an unresolved case')
    next
  rescue Geobox::NoTemplatesFound => e
    Helper.print_link(title)
    Helper.print_message('No templates found')
    next
  rescue Encoding::CompatibilityError => e
    Helper.print_message('Compatibility Error')
    next
  end

  # puts text.colorize(:red)

  client.edit(title: title, text: text, summary: 'Converting to use [[Template:Infobox river]]')

  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 10 + rand(5)
end
puts 'DONE!'