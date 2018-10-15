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
SKIPS = [
    'Orin Starn',
    'Alpha (anthology series)',
    'Amir-Abbas Fakhravar',
    'A Rought Passage',
    'A Sport from Hollowlog Flat',
    'The Mirror of Simple Souls',
    'Sexual Preference (book)',
    'A Latin Dictionary',
    'The Recruit (novel)'
]
START = 0
URL = "https://petscan.wmflabs.org/?psid=6028563&format=json"
include Book

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']


Helper.read_env_vars(file = '../vars.csv')
FileUtils.rm_rf('temp_book_covers')
Dir.mkdir('temp_book_covers') unless Dir.exist?('temp_book_covers')

titles = Helper.get_wmf_pages(URL)
puts titles.size
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
    # Helper.print_message('could not find infobox')
    next
  end

  @oclc = @isbn = ''
  if infobox_templates.first.match?(ISBN_REGEX)
    @isbn = infobox_templates.first.match(ISBN_REGEX)[1]
  elsif infobox_templates.first.match?(OCLC_REGEX)
    @oclc = infobox_templates.first.match(OCLC_REGEX)[1]
  else
    # Helper.print_message('could not find isbn or oclc')
    next
  end
  # unless infobox_templates.first.match?(ISBN_REGEX)
  #   # Helper.print_message('could not find isbn')
  #   unless infobox_templates.first.match?(OCLC_REGEX)
  #   # Helper.print_message('could not find oclc')
  #     next
  #   else
  #     @oclc = infobox_templates.first.match(OCLC_REGEX)[1]
  #   end
  # else
  #   @isbn = infobox_templates.first.match(ISBN_REGEX)[1]
  # end
  image_url = nil
  # if author
  #   image_url = get_google_book_at(author, title)
  #   next if image_url.nil?
  # else
  #   next
  # end
  
  
  if @isbn
    image_url = get_google_books(@isbn)
    image_url = get_open_library(@isbn) if image_url.nil?
    image_url = get_archive_org(@isbn) if image_url.nil?
    next if image_url.nil?
  # elsif @oclc
  #   puts " - testing OCLC".colorize(:red)
  #   image_url = get_open_library(@isbn)
  #   next if image_url.nil?
  else
    next    
  end
  
  
  # # GOOGLE BOOKS 2
  # 
  # Must first sanatize the author to just be the name
  # GoogleBooks.search('intitle:"#{title}"+inauthor:"#{author}"')
  
  
  filename = "#{title.gsub(/[:\"\?\\\/\*]/, '')}.jpg"
  open("temp_book_covers/#{filename}", 'wb') do |file|
    file << open(image_url.strip).read
  end

  begin
    @response = client.upload_image(filename, "temp_book_covers/#{filename}", 'Adding image', false, comment(title, author.strip, image_url))
  rescue Exception => e
    if e.message.match?(/A file with this name exists already in the shared file repository/)
      begin
        Helper.print_message('- WARNING: file already existed. Check this one...')
        new_filename = filename.gsub('.jpg', ' Book Cover.jpg')
        @response = client.upload_image(new_filename, "temp_book_covers/#{filename}", 'Adding image', false, comment(title, author.strip, image_url))
        filename = new_filename
      rescue Exception => e
        puts image_url
        puts Helper.print_message("- ERROR: #{e}")
        next
      end
    else
      puts image_url
      puts Helper.print_message("- ERROR: #{e}")
      next
    end
  end
  
  
  
  if @response.data["warnings"] && @response.data["warnings"]["was-deleted"]
    begin
      @response = client.upload_image(filename, "temp_book_covers/#{filename}", 'Adding image', true, comment(title, author.strip, image_url))
    rescue Exception => e
      puts image_url
      puts Helper.print_message("- ERROR: #{e}")
      next
    end
  end

  unless @response.data["result"] == "Success"
    Helper.print_message("- There are warnings: #{@response.data["warnings"]}")
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
end
puts 'DONE'.colorize(:green)