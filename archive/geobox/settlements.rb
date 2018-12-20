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
   '1837 Great Plains smallpox epidemic', 'Tech Valley', 'Texas Hill Country', 'Texas Panhandle',
    'Couva–Tabaquite–Talparo', 'The Thumb', 'Trans-Pecos', 'Tri-Cities (Michigan)',
    'Mount Ogden Via Ferrata', 'Tug Hill', 'U.S. Interior Highlands', 'Upper Peninsula of Michigan',
    'Nama Karoo', 'Venezuelan Andes', 'Venezuelan Coastal Range', 'White Mountains (Arizona)', 'Yorkshire Wolds',
    'Nellis Air Force Base Complex', 'Venezuelan Llanos', 'Western Washington',
    'High Plains (United States)', 'West Michigan', 'Western New York', 
    'Oleshky Sands','Orinoco Delta', 'Papuan Peninsula', 'Reese Technology Center', 'Rías Baixas',
    'Sandhills (Nebraska)', 'Semigallia', 'Shivwits Plateau', 'Siberia', 'Sichuan Basin',
    'Sloboda Ukraine', 'South Coast Plain', 'Southeast Michigan', 'Southern Michigan', 'Southern Tier', 
    'Southwest Washington', 'Yunnan–Guizhou Plateau', 'Zaporizhia (region)'
]


Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=6342209&format=json'

titles = Helper.get_wmf_pages(url)

titles.each do |title|
  next if SKIPS.include?(title)
  puts title.colorize(:blue)
  text = client.get_wikitext(title).body
  text.force_encoding('UTF-8')
  begin
    text = parse_geobox_to_building(text)
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

  client.edit(title: title, text: text, summary: 'Converting to use [[Template:Infobox building]]')

  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 8 + rand(5)
end
puts 'DONE!'