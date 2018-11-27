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
url = 'https://petscan.wmflabs.org/?psid=6552793&format=json'

titles = Helper.get_wmf_pages(url)

titles.each do |title|
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body
  
  page.gsub!(/\{\{\s*Chembox Identifiers/i, "{{Infobox chemical/identifiers")
  page.gsub!(/\{\{\s*Chembox Properties/i, "{{Infobox chemical/properties")
  page.gsub!(/\{\{\s*Chembox Structure/i, "{{Infobox chemical/structure")
  page.gsub!(/\{\{\s*Chembox Thermochemistry/i, "{{Infobox chemical/thermochemistry")
  page.gsub!(/\{\{\s*Chembox Explosive/i, "{{Infobox chemical/explosive")
  page.gsub!(/\{\{\s*Chembox Pharmacology/i, "{{Infobox chemical/pharmacology")
  page.gsub!(/\{\{\s*Chembox Hazards/i, "{{Infobox chemical/hazards")
  page.gsub!(/\{\{\s*Chembox Related/i, "{{Infobox chemical/related")
  page.gsub!(/\{\{\s*Chembox/i, "{{Infobox chemical")

  client.edit(title: title, text: page, summary: 'replacing deprecated [[Template:Chembox]] with updated [[Template:Infobox chemical]]')
  puts ' - success'.colorize(:green)
  sleep 8 + rand(5)
end
puts 'DONE!'