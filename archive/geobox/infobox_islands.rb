require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in 'ZackBot', ENV['PASSWORD']
# client.log_in 'Zackmann08', ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=6300261&format=json'

titles = Helper.get_wmf_pages(url)

puts titles.count
# count = 1
titles.each do |title|
  # break if count > 2
  puts title.colorize(:blue)
  # puts count
  page = client.get_wikitext(title).body
  
  templates = page.scan(/(?=\{\{(?:Infobox islands))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
  
  next unless templates.size == 1
  # templates.each do |template|
    template = templates.first
    old_text = template.dup

    params = Helper.parse_template(template)

    params.keys.each do |key|
      new_key = key.gsub(/\s/, '_')
      new_key = 'grid_reference' if key == 'GridReference'
      template.gsub!(/\|(\s*)#{key}(\s*)\=/, "|\\1#{new_key}\\2=")
    end

    page.gsub!(old_text, template)
  # end  
  
  
  client.edit(title: title, text: page, summary: 'fixing deprecated params from [[Template:Infobox islands]] - [[Wikipedia:Bots/Requests_for_approval/ZackBot_12|ZackBot 12 - Approved]]')
  # puts ' - success'.colorize(:green)
  # count += 1
end
puts 'DONE!'