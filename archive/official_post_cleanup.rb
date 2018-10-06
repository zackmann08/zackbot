#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'csv'
require 'open-uri'
require './helper'
require 'fileutils'

CATEGORY = "[[:Category:Pages using infobox official post with deprecated parameters|deprecated parameters]]"

OLD_PARAM = "nativename"
NEW_PARAM = "native_name"

OLD_REGEX = /\|(\s*)nativename\s*=\s*/
NEW_REGEX = /\|\s*native_name\s*=\s*/

QUERY_URL = "https://petscan.wmflabs.org/?psid=597034&format=json"

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

json = JSON.load(open(QUERY_URL))
titles = json["*"].first["a"]["*"].map{ | page| page["title"].gsub("_"," ")}
puts titles.size
puts "Substituting '#{OLD_PARAM}' with '#{NEW_PARAM}'"

# For testing
# pages = File.open('tv.txt').read
# pages.each_line do |title|
titles.each do |title|
  title.strip!
  puts title
  text = client.get_wikitext(title).body

  count = text.scan(OLD_REGEX).size

  if count > 1
    puts "- ERROR: '#{OLD_PARAM}' param appears more than one time on the page."
    next
  end

  if count < 1
    puts "- ERROR: '#{OLD_PARAM}' param not found."
    next
  end

  new_count = text.scan(NEW_REGEX).size
  if new_count > 0
    puts "- ERROR: '#{NEW_PARAM}' param already on page."
    next
  end


  text.gsub!(OLD_REGEX, "|\\1#{NEW_PARAM} = ")

  client.edit(title: title, text: text, summary: "Fixing infobox not to use #{CATEGORY}")
  puts "- SUCCESS"
end

puts "DONE"
