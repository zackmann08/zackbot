require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require './geobox'
# encoding: utf-8
include Geobox

def count_river(page)
  page.force_encoding('UTF-8')
  templates = page.scan(/(?=\{\{(?:geobox|geo box}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
  raise NoTemplatesFound if templates.empty?
  raise UnresolvedCase if templates.size > 1

  template = templates.first
  
  # raise UnresolvedCase.new('Contains invalid ref') if template.match?(/<ref\s*name=".*\|.*\"/i)

  Helper.parse_template(template)
end



SKIPS = [

]

Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=6503971&format=json'

titles = Helper.get_wmf_pages(url)
puts titles.size
depth_pages = []
count = 0
titles.each_with_index do |title, index|
  puts "#{index} - #{title}".colorize(:magenta) if index%100 == 0
  # next if SKIPS.include?(title)
  # puts title.colorize(:blue)
  text = client.get_wikitext(title).body
  text.force_encoding('UTF-8')
  begin
    params = count_river(text)
    if (!params['depth'].empty?) || (!params['depth_imperial'].empty?)
      depth_pages << title
      count += 1
      puts title
      Helper.print_link(title)
    end
  rescue Geobox::UnresolvedCase => e
    Helper.print_link(title)
    Helper.print_message(e)
    Helper.print_message('Hit an unresolved case')
    next
  rescue Geobox::NoTemplatesFound => e
    Helper.print_link(title)
    Helper.print_message('No templates found')
    next
  rescue Encoding::CompatibilityError => e
    Helper.print_message('Compatibility Error')
    next
  end

  # puts text.colorize(:red)

  # Helper.page_history(title)
  # puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  # sleep 10 + rand(5)
end
puts depth_pages.map{|p| "[[#{p}]]"}.join(', ')
puts "=========="
puts depth_pages
puts count
puts 'DONE!'