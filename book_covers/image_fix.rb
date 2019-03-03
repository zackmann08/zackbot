#!/usr/bin/env ruby
# encoding: utf-8

require '../helper'

# File format: <page_name>@!@<url_for_image>
images = <<-TEXT 
aaaa@!@bbbb
TEXT

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

Dir.mkdir('fix_book_covers') unless Dir.exist?('fix_book_covers')

# images = File.open('fix_books.csv.txt').read

images.each_line do |image|
  image, url = image.split('@!@')
  image += '.jpg' unless image.end_with?('.jpg')
  puts image.colorize(:blue)
  open("fix_book_covers/#{image}", 'wb') do |file|
    file << open(url.strip).read
  end

  begin
    @response = client.upload_image(image, "fix_book_covers/#{image}", 'Fixing image', true)
  rescue Exception => e
    Helper.print_message("- ERROR: #{e}")
    next
  end
  puts "- success".colorize(:green)
  sleep 2
end

puts "Cleaning up and deleting all downloaded covers"
FileUtils.rm_rf('fix_book_covers')
