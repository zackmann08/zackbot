require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in 'ZackBot', ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=6018617&format=json'

titles = Helper.get_wmf_pages(url)

titles.each do |title|
  title = "Talk:#{title}"
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body
  
  page.gsub!(/\|(\s*)image(\s*)\=/,  '|\1needs-image\2=')
  page.gsub!(/\|(\s*)photo(\s*)\=/,  '|\1needs-image\2=')
  page.gsub!(/\|(\s*)infobox(\s*)\=/,'|\1needs-infobox\2=')
  
  client.edit(title: title, text: page, summary: 'fixing deprecated params')
  # sleep 3 + rand(2)
end