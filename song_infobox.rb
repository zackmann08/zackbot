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
url = 'https://petscan.wmflabs.org/?psid=6101520&format=json'

titles = Helper.get_wmf_pages(url)

titles.each do |title|
  # title = "Talk:#{title}"
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body

  page.gsub!(/\{\{MusicBrainz.*\|\s*id=/i, '{{MusicBrainz release|mbid=')

  client.edit(title: title, text: page, summary: 'fixing deprecated params')
  sleep 8 + rand(5)
  puts ' - success'.colorize(:green)
end
puts 'DONE!'