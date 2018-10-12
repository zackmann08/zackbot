require '../helper'
require '../netball/netball'
include Netball
# encoding: utf-8


SKIPS = [
]

URL = 'https://petscan.wmflabs.org/?psid=6054003&format=json'
titles = Helper.get_wmf_pages(URL)

client = Helper.get_client

titles.each do |title|
  puts title.colorize(:blue)
  if SKIPS.include?(title)
    Helper.print_message('Skipping due to SKIPS')
    next
  end
  text = client.get_wikitext(title).body
  original_text = text.dup
  
  begin
    text = parse_page(text)
  rescue NoMethodError
    Helper.print_message('NoMethodError')
    Helper.print_link(title)
    next
  rescue Netball::LengthsMismatch
    Helper.print_message('Lengths do not match')
    Helper.print_link(title)
    next
  end
  text.strip!

  if original_text == text
    Helper.print_message('No changes made')
    next
  end
  
  client.edit(title: title, text: text, summary: "fixing deprecated params")
  puts "  - success".colorize(:green)
  
  # exit(1)
  sleep 5 + rand(5)
end
