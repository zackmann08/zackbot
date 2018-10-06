#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'open-uri'
require './helper'
require 'fileutils'

CHANNEL_REGEX = /\|(\s*)channel\s*=\s*(.*)\n/
HOST_REGEX    = /\|(\s*)host\s*=\s*(.*)\n/
NAME_REGEX    = /\|(\s*)name\s*=\s*(.*)\n/
STUDIO_REGEX  = /\|(\s*)studio\s*=\s*(.*)\n/


# Check to see if any of the REGEXs appear on the page more than one time
# if so, abort. Can't do multiple replacements.
def more_than_once?(text, param, regex)
  count = text.scan(regex).size
  puts "#{param}: #{count} time"
  if count > 1
    puts "- ERROR: '#{param}' appears more than one time on the page."
    return true
  end
  false
end

QUERY_URL = "https://petscan.wmflabs.org/?psid=596033&format=json"

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

json = JSON.load(open(QUERY_URL))
titles = json["*"].first["a"]["*"].map{ | page| page["title"].gsub("_"," ")}
puts titles.size

# For testing
# pages = File.open('tv.txt').read
# pages.each_line do |title|
titles.each do |title|
  title.strip!
  puts title
  text = client.get_wikitext(title).body

  next if (more_than_once?(text, "channel", CHANNEL_REGEX))
  next if (more_than_once?(text, "host",    HOST_REGEX))
  next if (more_than_once?(text, "name",    NAME_REGEX))
  next if (more_than_once?(text, "studio",  STUDIO_REGEX))


  # GSUB each of them.

  text.gsub!(CHANNEL_REGEX, "|\\1network = \\2\n")
  text.gsub!(HOST_REGEX,    "|\\1presenter = \\2\n")
  text.gsub!(NAME_REGEX,    "|\\1show_name = \\2\n")
  text.gsub!(STUDIO_REGEX,  "|\\1company = \\2\n")

  client.edit(title: title, text: text, summary: 'Fixing infobox not to use [[:Category:Pages using infobox television with alias parameters|deprecated parameters]]')
  puts "- SUCCESS"
end

puts "DONE"
