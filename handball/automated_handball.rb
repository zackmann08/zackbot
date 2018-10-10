require '../helper'
require '../handball/handball'
include Handball
# encoding: utf-8

PARAMS = %w[title titleyears titleplace manageryears managerclubs youthclubs youthyears nationalyears nationalteam nationalcaps\(goals\) years clubs caps\(goals\)]


CAPS_GOALS_REGEX = /(\d+).*\((\d*)\)/
YOUTH     = /\|\s*youthyears\s*\=.*\n\|\s*youthclubs\s*\=.*\n/
TITLE     = /\|\s*title\s*\=.*\n\|\s*titleyears\s*\=.*\n\|\s*titleplace\s*\=.*\n/
CLUB      = /(?:\|\s*years\s*\=.*\n)?\|\s*clubs\s*\=.*\n/
MANAGER   = /\|\s*manageryears\s*\=.*\n\|\s*managerclubs\s*\=.*\n/
NATIONAL  = /(?:\|\s*nationalyears\s*\=.*\n)?\|\s*nationalteam\s*\=.*\n(?:\|\s*nationalcaps\(goals\)\s*\=.*\n)?/

SKIPS = [
]

URL = 'https://petscan.wmflabs.org/?psid=6036836&format=json'
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

  PARAMS.each do |param|
    text.gsub!(/\|\s*#{param}\s*\=\s*(\||\}\}|\n)/, '\1')
  end
  
  begin
    if text.match?(YOUTH)
      # puts "Y"
      text.gsub!(YOUTH, parse_youth_years(text))
    end
    if text.match?(CLUB)
      # puts "C"
      text.gsub!(CLUB, parse_clubs_years(text))
    end
    if text.match?(TITLE)
      # puts "C"
      text.gsub!(TITLE, parse_title(text))
    end
    if text.match?(NATIONAL)
      # puts "N"
      # puts "############"
      # r = parse_national(text)
      # puts "############"
      text.gsub!(NATIONAL, parse_national(text))
    end
    if text.match?(MANAGER)
      # puts "M"
      text.gsub!(MANAGER, parse_manager_years(text))
    end
  rescue NoMethodError
    Helper.print_message('NoMethodError')
    Helper.print_link(title)
    next
  rescue Handball::LengthsMismatch
    Helper.print_message('Lengths do not match')
    Helper.print_link(title)
    next
  end
  text.strip!

  PARAMS.each do |param|
    text.gsub!(/\|\s*#{param}\s*\=\s*(\||\}\}|\n)/, '\1')
  end  
  if original_text == text
    Helper.print_message('No changes made')
    next
  end
  client.edit(title: title, text: text, summary: "fixing deprecated params")
  puts "  - success".colorize(:green)

  sleep 5 + rand(5)
end
