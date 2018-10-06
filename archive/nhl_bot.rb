
require 'mediawiki_api'
require 'HTTParty'
require 'csv'
require 'open-uri'
require './helper'
require 'fileutils'

def at_least_once(text, param, regex)
  count = text.scan(regex).size
  if count == 0
    puts "- ERROR: '#{param}' does not appear on the page"
    return false
  end
  true
end

INFOBOX_REGEX = /(?=\{\{(?:NHLTeamSeason|NHL team season|Infobox NHL team season))(\{\{(?>[^{}]++|\g<1>)*}})/

QUERY_URL = "https://petscan.wmflabs.org/?psid=5775127&format=json"

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

json = JSON.load(open(QUERY_URL))
titles = json["*"].first["a"]["*"].map{ | page| "#{page["nstext"]}#{':' unless page["nstext"].empty?}#{page["title"].gsub("_"," ")}"}
puts titles.size

title = titles.first

titles.each do |title|
  title.strip!
  puts title

  full_text = client.get_wikitext(title).body

  next unless (at_least_once(full_text, "Hockey box", INFOBOX_REGEX))

  # next if Helper.no_bots?(full_text)

  infobox_text = full_text.match(INFOBOX_REGEX)[0]

  # if (Helper.ever?(infobox_text, /\|\s*League\s*=\s*/ ))
  #   puts "ALREADY DONE"
  #   # next
  # end

  infobox_text.gsub!(/^(\s*)\|(\s*)Season(\s*)=(\s*)/, "\\1|\\2League\\3=\\4NHL\n\\1|\\2Season\\3=")

  full_text.gsub!(INFOBOX_REGEX, infobox_text)

  client.edit(title: title, text: full_text, summary: "Adding param to allow upmerging of infobox.")
  puts "- success"
end

puts "DONE"