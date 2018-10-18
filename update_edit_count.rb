#!/usr/bin/env ruby
# encoding: utf-8

# https://www.mediawiki.org/wiki/Manual:Namespace
# https://xtools.readthedocs.io/en/stable/api/user.html#simple-edit-count
# Get all the templates that I have created and then filter out the ones that are sandbox, etc. 

require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require 'json'
require './helper'

REGEX = /Total edits.*\n.*<strong>(?<number>[0-9,]*)/

def get_content(url)
  begin
    Timeout.timeout(40) do
      @content = HTTParty.get(url)
    end
  rescue Timeout::Error
    puts 'ERROR: Took longer than 40 seconds to get edit count. Script aborting.'
    exit(0)
  end
end

EDIT_COUNT_URL  = 'https://en.wikipedia.org/w/api.php?action=query&list=users&usprop=editcount&ususers=Zackmann08&format=json'
TEMPLATES_URL   = 'https://xtools.wmflabs.org/api/user/pages/en.wikipedia/Zackmann08/10'
MODULES_URL     = 'https://xtools.wmflabs.org/api/user/pages/en.wikipedia/Zackmann08/828'
CATEGORIES_URL  = 'https://xtools.wmflabs.org/api/user/pages_count/en.wikipedia/Zackmann08/14'
FILES_URL       = 'https://xtools.wmflabs.org/api/user/pages_count/en.wikipedia/Zackmann08/6'
# URL = "https://tools.wmflabs.org/supercount/index.php?user=#{ENV['USERNAME']}&project=en.wikipedia"
Helper.read_env_vars
client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

puts "Getting count for #{ENV['USERNAME']}"


@content = get_content(EDIT_COUNT_URL)
result = @content["query"]["users"][0]["editcount"]

puts "Updating count to #{result}"
client.edit(title: "User:#{ENV['USERNAME']}/edit count", text: result)

templates = get_content(TEMPLATES_URL)
count = templates["pages"].reject!{ |page| 
  (page['page_title'].include?('/doc')||
      page['page_title'].include?('sandbox') ||
      page['page_title'].include?('/testcase') 
  )}.size
puts "Updating template count to #{count}"
client.edit(title: "User:#{ENV['USERNAME']}/template count", text: count)

categories = get_content(CATEGORIES_URL)
count = categories["counts"]["count"]
puts "Updating category count to #{count}"
client.edit(title: "User:#{ENV['USERNAME']}/category count", text: count)

files = get_content(FILES_URL)
count = files["counts"]["count"]
puts "Updating file count to #{count}"
client.edit(title: "User:#{ENV['USERNAME']}/file count", text: count)

modules = get_content(MODULES_URL)
count = modules["pages"].reject!{ |page|
  (page['page_title'].include?('/doc')||
      page['page_title'].include?('sandbox') ||
      page['page_title'].include?('/testcase')
  )}.size
puts "Updating modules count to #{count}"
client.edit(title: "User:#{ENV['USERNAME']}/module count", text: count)


text = client.get_wikitext('Wikipedia:List of Wikipedians by number of edits/1–1000').body
rank = text.scan(/(\d*)\s*\n*\|\s*\[\[User:Zackmann08\|Zackmann08\]\]/).flatten.first
puts "Updating rank to #{rank}"
client.edit(title: "User:#{ENV['USERNAME']}/rank", text: rank)




