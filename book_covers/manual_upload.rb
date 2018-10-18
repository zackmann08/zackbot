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

# JUST_UPLOAD = true
JUST_UPLOAD = false

images = <<-TEXT
The Dark Wind@!@http://ehillerman.unm.edu/sites/default/files/files/pictures/A14425%20874744_0.jpg
TEXT

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

FileUtils.rm_rf('temp_book_covers')
Dir.mkdir('temp_book_covers') unless Dir.exist?('temp_book_covers')

images.each_line do |image|
  title, url = image.split('@!@')
  puts "#{title}".colorize(:blue)
  author = ''
  
  unless JUST_UPLOAD
    page = Page.new(client.get_wikitext(title).body)
    infobox_templates = page.get_templates(/infobox/i)

    image_count = page.raw_text.scan(IMAGE_REGEX).size
    if image_count > 1
      Helper.print_message("'| image =' appears more than once.")
    end

    
    if page.raw_text.scan(/author[s]*\s*=\s*/).any?
      author = page.raw_text.match(/author[s]*\s*=\s*(?<author>[^\|\n]*)/)[:author]
    end

    if infobox_templates.empty?
      # Helper.print_message('could not find infobox')
      next
    end
  end
  
  filename = "#{title.gsub(/[:\"\?\\\/\*]/, '')}.jpg"
  # filename = title + '.png'
  open("temp_book_covers/#{filename}", 'wb') do |file|
    file << open(url.strip).read
  end
  begin
    @response = client.upload_image(filename, "temp_book_covers/#{filename}", 'Adding image', false, comment(title, author.strip, url))
  rescue Exception => e
    puts Helper.print_message("- ERROR: #{e}")
    next
  end

  unless @response.data["result"] == "Success"
    puts Helper.print_message("- There are warnings: #{@response.data["warnings"]}")
    next
  end
  client.edit(title: "File talk:#{filename}", text: BOOK_PROJECT, summary: 'adding project')
  puts '- image uploaded'.colorize(:green)

  unless JUST_UPLOAD
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
  end  
  
  sleep 5
end
puts 'DONE'.colorize(:green)