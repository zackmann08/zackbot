require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../helper'
require 'uri'
require 'colorize'
require 'json'

# templates = JSON.parse(File.read('FOOOO.json'))
templates = JSON.parse(File.read(Dir.glob("*.json").max_by {|f| File.mtime(f)}))
puts templates['rows'].count

result = "{{User:Zackmann08/unused templates/notes}}
==Results (updated at #{Time.now.strftime("%Y-%m-%d %H:%M:%S PST")})==
{{User:Zackmann08/unused navbox}}
Current count: #{templates['rows'].count}\n"
result += '{| class="wikitable plainlinks sortable"'
result += "\n|-\n! Template\n! Created on\n! Transclusions link\n"
templates['rows'].each do |template|
  name = template[0].gsub('_', ' ')
  link = "<span class=\"plainlinks\"> [//en.wikipedia.org/w/index.php?title=Special:WhatLinksHere/Template:#{template[0]}&limit=999&hidelinks=1 transclusions]</span>"
  result += "|-
|[[Template:#{name}|#{name}]]||#{Date::strptime(template[1], "%Y%m%d%H%M%S")}||#{link}\n"

end
result += '|}'

Helper.read_env_vars(file = '../vars.csv')
client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

USERNAME = 'Zackmann08'
client.edit(title: "User:Zackmann08/unused templates", text: result, summary: 'Updating with new report data')

puts 'done'
