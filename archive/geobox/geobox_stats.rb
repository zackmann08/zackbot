#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'

INFOBOX_REGEX = / /


URL = "https://petscan.wmflabs.org/?psid=6208217&format=json"

Helper.read_env_vars(file = '../vars.csv')

begin
  Timeout.timeout(40) do
    @content = HTTParty.get(URL)
  end
rescue Timeout::Error
  puts 'ERROR: Took longer than 10 seconds to get patch Script aborting.'
  exit(0)
end

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

results = @content["*"].first['a']['*'].map do |i|
  i["title"]
end

GEOBOX = /\{\{geobox\|([\w\s]*)\n/i
types = Hash.new(0)

@content["*"].first['a']['*'].each do |title|
  title = title['title'].gsub("_"," ")
  puts title

  full_text = client.get_wikitext(title).body
  
  if full_text.match?(GEOBOX)
    type = full_text.match(GEOBOX)[1]
    type.downcase!
    types[type]+=1
  end
  
end

puts types.inspect
puts types.sort_by {|_key, value| value}.to_h.inspect
puts types.sort_by {|key, _value| key}.to_h.inspect

puts "DONE"
