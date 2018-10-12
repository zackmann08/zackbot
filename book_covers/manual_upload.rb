# encoding: utf-8
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require 'uri'
require 'colorize'
require 'json'
require 'fileutils'
require 'open-uri'
require 'googlebooks'
require '../helper'
require './book'

include Book

images = <<-TEXT
Hannibal (Leckie novel)@!@http://books.google.com/books/content?id=GyhXAAAAYAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api
TEXT

def comment(title, author, url)
  author += ']]' if author[0,2] == '[[' && author.chars.last(2).join != ']]'
  "==Summary==
{{Non-free use rationale book cover
| Article = #{title.strip}
| Title   = [[#{title.strip}]]
| Author  = #{author}
| Source  = #{url}
| Use     = Infobox
}}

==Licensing==
{{Non-free book cover|image has rationale=yes}}"
end
BOOK_PROJECT = "{{WikiProject Books|class=File}}"

IMAGE_REGEX = /(\s*\|\s*image\s*=)\s*/
Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

Helper.read_env_vars(file = '../vars.csv')
FileUtils.rm_rf('temp_book_covers')
Dir.mkdir('temp_book_covers') unless Dir.exist?('temp_book_covers')

images.each_line do |image|
  title, url = image.split('@!@')
  puts "#{title}".colorize(:blue)
  page = Page.new(client.get_wikitext(title).body)
  infobox_templates = page.get_templates(/infobox/i)

  image_count = page.raw_text.scan(IMAGE_REGEX).size
  if image_count > 1
    Helper.print_message("'| image =' appears more than once.")
    next
  end

  author = ''
  if page.raw_text.scan(/author[s]*\s*=\s*/).any?
    author = page.raw_text.match(/author[s]*\s*=\s*(?<author>[^\|\n]*)/)[:author]
  end

  if infobox_templates.empty?
    # Helper.print_message('could not find infobox')
    next
  end

  filename = title + '(novel)'+ '.jpg'
  # filename = title + '.png'
  open("temp_book_covers/#{filename}", 'wb') do |file|
    file << open(url.strip).read
  end
  begin
    @response = client.upload_image(filename, "temp_book_covers/#{filename}", 'Adding image', false, comment(title, author.strip, url))
  rescue Exception => e
    puts "YES" if e.message.include?('png')
    puts url
    puts Helper.print_message("- ERROR: #{e}")
    next
  end

  unless @response.data["result"] == "Success"
    puts Helper.print_message("- There are warnings: #{@response.data["warnings"]}")
    next
  end
  client.edit(title: "File talk:#{filename}", text: BOOK_PROJECT, summary: 'adding project')
  puts '- image uploaded'.colorize(:green)

  if image_count == 0
    begin
      page.raw_text.gsub!(/(\{\{Infobox book)(\n\|\s*name\s*=.*)?/i, "\\1\\2\n| image = #{filename}")
    rescue Encoding::CompatibilityError
      Helper.print_link(title)
      Helper.print_message("##!! Incompatible character error")
      next
    end
    puts '- image = did not appear in original text, now inserted'.colorize(:green)
  else
    begin
      page.raw_text.gsub!(IMAGE_REGEX, "\\1 #{filename}\n")
    rescue Encoding::CompatibilityError
      Helper.print_link(title)
      Helper.print_message("##!! Incompatible character error")
      next
    end
    puts '- Image inserted as normal'.colorize(:green)
  end

  client.edit(title: title, text: page.raw_text, summary: 'Adding image')
  sleep 5
end
puts 'DONE'.colorize(:green)