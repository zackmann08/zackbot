#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'csv'
require 'open-uri'
require '../helper'
require 'fileutils'
require 'colorize'

# File format: <page_name>@!@<url_for_image>
VIDEO_GAME_PROJECT = "{{WikiProject Video games|class=file}}"

IMAGE_REGEX = /(\s*\|\s*image\s*=)\s*/

def comment(title, url)
  "{{Non-free use rationale video game cover
| Article = #{title}
| Use     = Infobox
| Name    = [[#{title}]]
| Source  = #{url}
}}

==Licensing==
{{Non-free video game cover|image has rationale=yes}}
"
end

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

Dir.mkdir('video_games') unless Dir.exist?('video_games')

games = File.open('video_games.csv.txt').read

games.each_line do |game|
  title, url = game.split('@!@')
  puts title.to_s.colorize(:blue)
  text = client.get_wikitext(title).body
  extension = File.extname(url).strip

  # Make sure "| image = " only appears once
  image_count = text.scan(IMAGE_REGEX).size

  if image_count > 1
    Helper.print_message("- ERROR: #{title} couldn't be processed. '| image =' appears more than once.")
    next
  end
  
  filename = "#{title}#{extension}".gsub(':', '')

  open("video_games/#{filename}", 'wb') do |file|
    file << open(url.strip).read
  end

  begin
    @response = client.upload_image(filename, "video_games/#{filename}", 'Adding image', false, comment(title, url))
  rescue Exception => e
    Helper.print_message("- ERROR: #{e}")
    next
  end

  unless @response.data["result"] == "Success"
    Helper.print_message("- ERROR: There are warnings: #{@response.data["warnings"]}")
    next
  end
  client.edit(title: "File talk:#{filename}", text: VIDEO_GAME_PROJECT, summary: 'adding project')

  if image_count == 0
    puts '- NOTE: image = did not appear in original text'.colorize(:green)
    text.gsub!(/(\{\{Infobox video game)(\n\|\s*name\s*=.*)?/i, "\\1\\2\n| image = #{filename}\n")
  else
    puts '- NOTE: Image inserted as normal'.colorize(:green)
    text.gsub!(IMAGE_REGEX, "\\1 #{filename}\n")
  end

  client.edit(title: title, text: text, summary: 'Adding image')

  talk_page = client.get_wikitext("Talk:#{title}").body

  talk_page.gsub!(/\|\s*cover\s*=\s*[^\}\|]*/, '')

  client.edit(title: "Talk:#{title}", text: talk_page, summary: 'has cover art')
end

puts "Cleaning up and deleting all downloaded covers".colorize(:green)
FileUtils.rm_rf('video_games')
