#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'

INFOBOX_REGEX = /(?=\{\{(?:[Ii]nfobox))(\{\{(?>[^{}]++|\g<1>)*}})/


URL = "https://petscan.wmflabs.org/?psid=5803291&format=json"

Helper.read_env_vars

begin
  Timeout.timeout(40) do
    @content = HTTParty.get(URL)
  end
rescue Timeout::Error
  puts 'ERROR: Took longer than 20 seconds to get edit count. Script aborting.'
  exit(0)
end

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

results = @content["*"].first['a']['*'].map do |i|
  i["title"]
end

@content["*"].first['a']['*'].each do |title|
  title = title['title'].gsub("_"," ")
  puts title

  full_text = client.get_wikitext(title).body

  next unless full_text.match?(INFOBOX_REGEX)
  infobox_text = full_text.match(INFOBOX_REGEX)[0]

  # puts title if /(\|\s*)lake(\s*=)/.match?(infobox_text)
  # 
  infobox_text.gsub!(/\|\s*draftnumber\s*=\s*[\d]*\n*/, '')
  # # infobox_text.gsub!(/(\|\s*)alt_lake(\s*=)/, "\\1alt\\2")
  # # infobox_text.gsub!(/(\|\s*)image_lake(\s*=)/, "\\1lake\\2")
  # # infobox_text.gsub!(/(\|\s*)caption_lake(\s*=)/, "\\1caption\\2")
  # # infobox_text.gsub!(/(\|\s*)lake_name(\s*=)/, "\\1name\\2")
  # # 
  # # 
  full_text.gsub!(INFOBOX_REGEX, infobox_text)

  client.edit(title: title, text: full_text, summary: "Removing deprecated parma")
  puts "- success"
  # sleep 20
end

puts "DONE"
