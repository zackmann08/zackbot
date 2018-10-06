#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'csv'
require 'open-uri'
require './helper'
require 'fileutils'

LOCATOR_MAP_REGEX = /\|\s*locator\smap\s*=\s*\{\{[\w\d\s\n\|\-=.,:]*\}\}/
IMAGE_REGEX = /\|\s*locator\smap\s*=\s*([A-Za-z0-9,\s\-]*(?:.PNG|.png|.JPG|.jpg|.SVG|.svg)).*/

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

pages = File.open('maps.txt').read

pages.each_line do |title|
  title.strip!
  puts title
  text = client.get_wikitext(title).body
  @map = ""
  @caption = ""
  @image = nil

  text.gsub!(/\|\s*map\s*=\s*\n/, '')
  text.gsub!(/\|\s*map_caption\s*=\s*\n/, '')
  text.gsub!(/\|\s*map_custom\s*=\s*.*\n/, '')
  text.gsub!(/\|\s*map_alt\s*=\s*\n/, '')
  text.gsub!(/\|\s*map_width\s*=\s*\n/, '')
  text.gsub!(/\|\s*locator\smap\ssize\s*=\s*\n/, '')
  text.gsub!(/\|\s*locator\smap\ssize\s*=\s*.*\n/, '')

  caption_match = text.match(/\|\s*map\scaption\s*=\s*(.*)\n/)
  @caption = caption_match[1] unless caption_match.nil?

  text.gsub!(/\|\s*map\scaption\s*=\s*\n/, '')
  text.gsub!(/\|\s*map\scaption\s*=\s*.*\n/, '')

  image_match = text.match(IMAGE_REGEX)
  @image = image_match[1] unless image_match.nil?

  unless @image.nil?
    text.gsub!(IMAGE_REGEX, "| map = \\1\n| map_caption = #{@caption}")
    client.edit(title: title, text: text, summary: 'Fixing infobox not to use [[:Category:Pages using deprecated map format|deprecated format]]')
    puts "-SUCCESS - Image"
    # sleep 1
    next
  end

  @match = text.match(/\|\s*locator\smap\s*=\s*\{\{[Ll]ocation map\s*\|(?<map>[A-Za-z0-9\s]*).*caption\s*=\s*(?<caption>[^\|]*).*\}\}/)

  if @match.nil?
    @match = text.match(/\|\s*locator\smap\s*=\s*\{\{[Ll]ocation map\s*\|(?<map>[A-Za-z0-9\s]*).*\}\}/)
    @match = text.match(/\|\s*locator\smap\s*=\s*\{\{[Ll]ocation map\s*\|(?<map>[A-Za-z0-9\s]*).*\n*\s*\}\}/) if @match.nil?
    @match = text.match(/\|\s*locator\smap\s*=\s*\{\{[Ll]ocation map\s*\|(?<map>[A-Za-z0-9\s]*).*\n*.*\n*\s*\}\}/) if @match.nil?
    @match = text.match(/\|\s*locator\smap\s*=\s*\{\{[Ll]ocation map\s*\|(?<map>[A-Za-z0-9\s]*).*\n*.*\n*.*\n*\s*\}\}/) if @match.nil?
    @match = text.match(/\|\s*locator\smap\s*=\s*\{\{[Ll]ocation map\s*\|(?<map>[A-Za-z0-9\s]*).*\n*.*\n*.*\n*.*\n*\s*\}\}/) if @match.nil?
  else
    @caption = @match[:caption]
  end

  if @match.nil?
    puts " - ERROR: #{title} couldn't be processed. 'locator map' not present in the code"
    next
  end

  if text.scan(LOCATOR_MAP_REGEX).size == 0
    puts " - ERROR: #{title} couldn't be processed. 'locator map' contains invalid characters"
    next
  end


  @map = @match[:map].strip

  text.gsub!(LOCATOR_MAP_REGEX, "| map = #{@map}\n| map_caption = #{@caption}")

  client.edit(title: title, text: text, summary: 'Fixing infobox not to use [[:Category:Pages using deprecated map format|deprecated format]]')
  puts "- SUCCESS - Map"
  # sleep 1
end

puts "DONE"
