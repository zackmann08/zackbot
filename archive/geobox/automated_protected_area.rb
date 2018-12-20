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

]


Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=6409909&format=json'

titles = Helper.get_wmf_pages(url)

titles.each do |title|
  next if SKIPS.include?(title)
  puts title.colorize(:blue)
  text = client.get_wikitext(title).body
  text.force_encoding('UTF-8')
  begin
    text = parse_geobox_to_protected_area(text)
  rescue Geobox::UnresolvedCase => e
    Helper.print_link(title)
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

  client.edit(title: title, text: text, summary: 'Converting to use [[Template:Infobox protected area]]')

  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 5 + rand(5)
end
puts 'DONE!'