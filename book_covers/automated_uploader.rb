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
SKIPS = [
    'Sexual Preference (book)',
    'A Latin Dictionary'
]
START = 3400

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

ISBN_REGEX = /\|\s*isbn\s*\=\s*([0-9\-]+)/i
OCLC_REGEX = /\|\s*oclc\s*\=\s*([a-z0-9\-]+)/i
IMAGE_REGEX = /(\s*\|\s*image\s*=)\s*/
Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

# 
URL = "https://petscan.wmflabs.org/?psid=6028563&format=json"

Helper.read_env_vars(file = '../vars.csv')
FileUtils.rm_rf('temp_book_covers')
Dir.mkdir('temp_book_covers') unless Dir.exist?('temp_book_covers')

titles = Helper.get_wmf_pages(URL)
puts titles.size
# titles = ['Just Like That (novel)']

# isbn_count = 0
# 4095 without ISBN!
titles.drop(START).each_with_index do |title, index|
  next if SKIPS.include?(title)
  puts "#{START + index} - #{title}".colorize(:blue)
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
    Helper.print_message('could not find infobox')
    next
  end

  unless infobox_templates.first.match?(ISBN_REGEX)
    Helper.print_message('could not find isbn')
    next
  else
    @isbn = infobox_templates.first.match(ISBN_REGEX)[1]
  end

  # # OPEN LIBRARY
  # response = HTTParty.get("https://openlibrary.org/api/books?bibkeys=ISBN:#{@isbn}")
  # result = response.body.delete('var _OLBookInfo = ').chomp(';')
  # begin 
  #   parsed_result = JSON.parse(result)
  # rescue JSON::ParserError
  #   Helper.print_message("JSON parse caused an error")
  #   next
  # end
  # if parsed_result.empty?
  #   Helper.print_message('No results from open library')
  #   next
  # end
  # begin
  #   image_id = parsed_result["SN:#{@isbn}"]["thumbilul"].match(/\d+/)
  # rescue NoMethodError
  #   Helper.print_message("OpenLibrary returned an invalid response: #{parsed_result}")
  #   next
  # end
  # image_url = "https://covers.openlibrary.org/b/id/#{image_id}-L.jpg"
  
  # # GOOGLE BOOKS
  # google_response = GoogleBooks.search("isbn:#{@isbn.gsub('-','')}")
  # # puts google_response.inspect
  # if google_response.total_items==0
  #   # puts google_response.inspect
  #   Helper.print_message("Google Books returned no results")
  #   next
  # end
  # image_url = google_response.first.image_link(zoom: 1)
  # if image_url.nil?
  #   Helper.print_message("Google Books has no image")
  #   next
  # end
  
  # Archive.org 
  response = HTTParty.get("https://archive.org/services/book/v1/do_we_have_it/?isbn=#{@isbn}")
  results = response.parsed_response['ia_identifiers']
  if results.empty?
    Helper.print_message('No results from archive.org')
    next    
  end
  id = results.first['ia_identifier']
  image_url = "https://archive.org/services/img/#{id}"
  
  filename = "#{title.gsub(/[:\"\?\\\/]/, '')}.jpg"
  open("temp_book_covers/#{filename}", 'wb') do |file|
    file << open(image_url.strip).read
  end

  begin
    @response = client.upload_image(filename, "temp_book_covers/#{filename}", 'Adding image', false, comment(title, author.strip, image_url))
  rescue Exception => e
    puts image_url
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
# puts "#{isbn_count} pages without ISBN numbers".colorize(:red)
puts 'DONE'.colorize(:green)