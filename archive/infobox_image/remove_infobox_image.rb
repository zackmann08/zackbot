require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require './image'

include Image

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

# 
URL = "https://petscan.wmflabs.org/?psid=6000673&format=json"

Helper.read_env_vars(file = '../vars.csv')

titles = Helper.get_wmf_pages(URL)

puts "Total to do: #{titles.size}"

IMAGE_PARAM = /\|(\s*)(image|image_skyline)(\s*)\=(\s*)\[\[(.*?)\]\]/
# titles = ['User:Zackmann08/sandbox-thumb']
titles.each do |title|
  has_caption = false
  puts title.colorize(:blue)
  
  page = Page.new(client.get_wikitext(title).body)
  infobox_templates = page.get_templates(/infobox/i)
  
  infobox_templates.each do |box|
    puts "########################"
    if box.match?(IMAGE_PARAM)
      image_param = box.match(IMAGE_PARAM)[2]
      #TODO match the image param with the associate caption param
      # image -> caption, logo -> logo_caption etc.
      file_text = box.match(IMAGE_PARAM)[5]
      image, caption = parse_image(file_text)
      unless caption.nil?
        Helper.print_message('Has caption')
        has_caption = true
        next
      end
      new_box = box.sub(IMAGE_PARAM, "\|\\1\\2\\3=\\4#{image}")
      page.raw_text.sub!(box, new_box)
    else
      Helper.print_message('Did not match IMAGE_PARAM regex')
    end
  end
  
  next if has_caption
  
  client.edit(title: title, text: page.raw_text, summary: "removing thumb from infobox per [[WP:INFOBOXIMAGE]]")
  puts " - success".colorize(:green)
end

puts 'DONE!'
