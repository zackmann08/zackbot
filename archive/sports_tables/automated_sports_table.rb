require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require '../sports_tables/sports_table'
# encoding: utf-8
include SportsTable


Helper.read_env_vars(file = '../vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=7144400&format=json'

titles = Helper.get_wmf_pages(url)
# titles.reverse!

$allow_extra_columns = true
$allow_manual_checks = false
puts titles.size
titles.each do |title|

  puts title.colorize(:blue)
  text = client.get_wikitext(title).body
  text.force_encoding('UTF-8')
  old = text.dup
  begin
    text.gsub!(/(\{\{fb.*)\|\}\}/i, "\\1}}")
    text = parse_sports_table_page(text).strip
  rescue Helper::NoTemplatesFound
    Helper.print_message('Template not found on page')
    next
  rescue Helper::UnresolvedCase => e
    Helper.print_link(title)
    Helper.print_message("Hit an unresolved case: #{e}")
    next
  rescue Timeout::Error => e
    Helper.print_link(title)
    Helper.print_message("Timeout error: #{e}")
    next
  rescue Encoding::CompatibilityError => e
    Helper.print_message('Compatibility Error')
    next
  end

  # puts text.colorize(:red)
  if text == old
    Helper.print_link(title)
    Helper.print_message('NO CHANGE')
    next
  end

  client.edit(title: title, text: text, summary: 'converting to use [[Module:Sports table]]')
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 10 + rand(5)
end
puts 'DONE!'