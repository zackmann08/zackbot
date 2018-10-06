#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'csv'
require 'open-uri'
require './helper'
require 'fileutils'

# COORDS_REGEX = /\|\s*lat_d\s*=\s*(?<lat>[\d.-]*)\n\|\s*long_d\s*=\s*(?<long>[\d.-]*)\n/

COORDS_REGEX = /
  \|\s*lat_d\s*=\s*(?<lat_d>[0-9\-.]*)(?:\n*\s*\|\s*lat_m\s*=\s*(?<lat_m>[0-9\-.]*))?(?:\n*\s*\|\s*lat_s\s*=\s*(?<lat_s>[0-9\-.]*))?(?:\n*\s*\|\s*lat_NS\s*=\s*(?<lat_NS>[NSns]*))?\n*
  \|\s*long_d\s*=\s*(?<long_d>[0-9\-.]*)(?:\n*\s*\|\s*long_m\s*=\s*(?<long_m>[0-9\-.]*))?(?:\n*\s*\|\s*long_s\s*=\s*(?<long_s>[0-9\-.]*))?(?:\n*\s*\|\s*long_EW\s*=\s*(?<long_EW>[EWew]*))?\s*\n
/xm


# https://petscan.wmflabs.org/?psid=594650
# just Infobox protected area
QUERY_URL = "https://petscan.wmflabs.org/?language=en&project=wikipedia&depth=0&categories=Pages%20using%20deprecated%20coordinates%20format&combination=subset&negcats=&ns%5B0%5D=1&show_redirects=both&edits%5Bbots%5D=both&edits%5Banons%5D=both&edits%5Bflagged%5D=both&templates_yes=Infobox%20protected%20area&subpage_filter=either&common_wiki=auto&source_combination=&wikidata_item=no&wikidata_label_language=&wikidata_prop_item_use=&wpiu=any&sitelinks_yes=&sitelinks_any=&sitelinks_no=&min_sitelink_count=&max_sitelink_count=&format=json&output_compatability=catscan&sortby=title&sortorder=ascending&regexp_filter=&min_redlink_count=1&doit=Do%20it%21&interface_language=en&active_tab=tab_output"

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

json = JSON.load(open(QUERY_URL))
titles = json["*"].first["a"]["*"].map{ | page| page["title"].gsub("_"," ")}
puts titles.size

# For testing
# pages = File.open('coords.txt').read
# pages.each_line do |title|
titles.each do |title|
  title.strip!
  puts title
  text = client.get_wikitext(title).body
  region = nil
  ref = nil

  coord_text = ""

  if text.match(/\{\{[Cc]oords/)
    puts "- ERROR: Coords template already present on page"
    next
  end

  text.gsub!(/\|\s*coordinates\s*=\s*\n/, '')
  text.gsub!(/\|\s*coords_ref\s*=\s*\n/, '')
  text.gsub!(/\|\s*coords\s*=\s*\n/, '')
  text.gsub!(/\|\s*(?:iso_)?region\s*=\s*\n/, '')
  text.gsub!(/\|\s*scale\s*=\s*.*\n/, '')

  coords_match = text.match(COORDS_REGEX)

  if coords_match.nil?
    next
  end

  region_match = text.match(/\|\s*(?:iso_)?region\s*=\s*(?<region>[A-Za-z0-9\-:]*)\s*/)
  region = region_match[:region] unless region_match.nil?

  ref_match = text.match(/\|\s*coords_ref\s*=\s*(?<ref>.*)\n/)
  unless ref_match.nil?
    ref = ref_match[:ref]
    unless ref.include?("</ref>")
      puts "- ERROR: Reference is spread across multiple lines, </ref> was not captured"
      next
    end
  end

  text.gsub!(/\|\s*(?:iso_)?region\s*=\s*.*\n/, '')
  text.gsub!(/\|\s*coords_ref\s*=\s*.*\n/, '')

  coord_text += "|#{coords_match[:lat_d]}"  unless coords_match[:lat_d].nil?  || coords_match[:lat_d].empty?
  coord_text += "|#{coords_match[:lat_m]}"  unless coords_match[:lat_m].nil?  || coords_match[:lat_m].empty?
  coord_text += "|#{coords_match[:lat_s]}"  unless coords_match[:lat_s].nil?  || coords_match[:lat_s].empty?
  coord_text += "|#{coords_match[:lat_NS]}" unless coords_match[:lat_NS].nil? || coords_match[:lat_NS].empty?
  coord_text += "|#{coords_match[:long_d]}"  unless coords_match[:long_d].nil?  || coords_match[:long_d].empty?
  coord_text += "|#{coords_match[:long_m]}"  unless coords_match[:long_m].nil?  || coords_match[:long_m].empty?
  coord_text += "|#{coords_match[:long_s]}"  unless coords_match[:long_s].nil?  || coords_match[:long_s].empty?
  coord_text += "|#{coords_match[:long_EW]}" unless coords_match[:long_EW].nil? || coords_match[:long_EW].empty?

  region ? (region_text = "|region:#{region}") : (region_text = '')
  ref ? (notes = "|notes=#{ref}") : (notes = '')

  text.gsub!(COORDS_REGEX, "| coordinates = {{coords#{coord_text}#{region_text}#{notes}|display=inline, title}}\n")

  client.edit(title: title, text: text, summary: 'Fixing infobox not to use [[:Category:Pages using deprecated coordinates format|deprecated coordinates format]]')
  puts "- SUCCESS"
  # sleep 1
end

puts "DONE"
