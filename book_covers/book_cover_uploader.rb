#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'csv'
require 'open-uri'
require './helper'
require 'fileutils'

# File format: <page_name>@!@<url_for_image>

IMAGE_REGEX = /(\s*\|\s*image\s*=)\s/

def comment(title, author, url)
  "==Summary==
{{Non-free use rationale 2
|Description = The cover of [[#{title.strip}]] by #{author}.
|Source = #{url.strip}
|Author = #{author}
|Article = #{title.strip}
|Purpose = To serve as the primary means of visual identification at the top of the article dedicated to the work in question.
|Replaceability = n.a.
|Minimality = Will only be used on the article itself.
|Commercial = n.a.
}}

==Licensing==
{{Non-free book cover|image has rationale=yes}}"
end

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

Dir.mkdir('book_covers') unless Dir.exist?('book_covers')

books = File.open('books.csv.txt').read


books.each_line do |book|
  title, url = book.split('@!@')
  puts title.to_s

  text = client.get_wikitext(title).body
  extension = File.extname(url).strip

  # Make sure "| image = " only appears once
  image_count = text.scan(IMAGE_REGEX).size

  if image_count > 1
    puts "- ERROR: #{title} couldn't be processed. '| image =' appears more than once."
    next
  end

  if text.scan(/author[s]*\s*=\s*/).empty?
    puts "- ERROR: #{title} couldn't be processed. No author is present on the page!"
    next
  end

  author = text.match(/author[s]*\s*=\s*(?<author>.*)/)[:author]

  open("book_covers/#{title}#{extension}", 'wb') do |file|
    file << open(url.strip).read
  end

  begin
    @response = client.upload_image("#{title.gsub(':', ' -')}#{extension}", "book_covers/#{title}#{extension}", 'Adding image', false, comment(title, author, url))
  rescue Exception => e
    puts "- ERROR: #{e}"
    next
  end

  unless @response.data["result"] == "Success"
    puts "- ERROR: There are warnings: #{@response.data["warnings"]}"
    next
  end

  if image_count == 0
    puts '- NOTE: image = did not appear in original text'
    text.gsub!(/(\{\{Infobox book)(\n\|\s*name\s*=.*)?/, "\\1\\2\n| image = #{title.gsub(':', ' -')}#{extension}")
  else
    puts '- NOTE: Image inserted as normal'
    text.gsub!(IMAGE_REGEX, "\\1 #{title.gsub(':', ' -')}#{extension}")
  end

  client.edit(title: title, text: text, summary: 'Adding image')
end

puts "Cleaning up and deleting all downloaded covers"
FileUtils.rm_rf('book_covers')
