require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require_relative './untry'
require_relative './table'
require 'uri'
require 'colorize'
# encoding: utf-8

# DEBUG = true
DEBUG = false

SKIPS = [
    'ICF World Junior and U23 Canoe Slalom Championships',
    '1900 Summer Olympics medal table',
    'All-time World Games medal table',
    'List of World Aquatics Championships medalists in open water swimming',
    '2014 Palarong Pambansa',
    "List of Olympic medalists in swimming (men)",
    "List of women's World Curling champions",
    "Men's Junior European Volleyball Championship",
    'List of indoor volleyball world medalists',
    'Marathons at the Paralympics',
    'Southeast Asian Games',
    '2010 Central American and Caribbean Junior Championships',
    '2010 CARIFTA Games',
    '2009 CARIFTA Games',
    'World Fencing Championships',
    'Asian Junior Squash Individual Championships',
    'Asia Masters Athletics Championships',
    'World Allround Speed Skating Championships for Men',
    'UCI Indoor Cycling World Championships'
]

def print_link(title)
  puts "\t#{URI::encode("https://en.wikipedia.org/wiki/#{title}")}"
end

def print_message(message)
  puts "\t#{message}".colorize(:red)
end

TABLE_REGEX = /\{\|\s*\{\{RankedMedalTable[\S\s]*?\|\}/

# 2000 - present
# URL = "https://petscan.wmflabs.org/?psid=5899945&format=json"
# # 1970-1999
# URL = "https://petscan.wmflabs.org/?psid=5892830&format=json"
# 1950-1969
# URL = "https://petscan.wmflabs.org/?psid=5912685&format=json"
# 1900-1949
# URL = "https://petscan.wmflabs.org/?psid=5915410&format=json"
# ALL articles
# URL = "https://petscan.wmflabs.org/?psid=5859536&format=json"
# ALL opposite order
# URL = "https://petscan.wmflabs.org/?psid=5932065&format=json"
# ALL random
# URL = "https://petscan.wmflabs.org/?psid=5941492&format=json"


# CUSTOM
URL = "https://petscan.wmflabs.org/?psid=5975260&format=json"

Helper.read_env_vars(file = '../vars.csv')

begin
  Timeout.timeout(40) do
    @content = HTTParty.get(URL)
  end
rescue Timeout::Error
  puts 'ERROR: Took longer than 10 seconds to get patch Script aborting.'
  exit(0)
end

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

pages = @content["*"].first['a']['*'].map do |i|
  i["title"].gsub('_', ' ')
end
puts "Total to do: #{pages.size}"

@errors = Hash.new(0)

pages.each do |title|
  puts title
  if SKIPS.include?(title)
    print_link(title)
    print_message('SKIPPING, in skip list')
    next
  end
  
  full_text = client.get_wikitext(title).body
  table_text = full_text.match(TABLE_REGEX)
  if (table_text.nil? || !table_text[0])
    print_link(title)
    print_message("FAILED - couldn't find the table")
    next
  end
  table_text = table_text[0]
  
  if table_text.match(/<includeonly>|<onlyinclude>/)
    print_link(title)
    print_message('Failed - contains includeonly/onlyinclude tags')
    next
  end
 
  
  begin
    result = Table.parse_table(table_text)
  rescue Country::InvalidIoc, Country::UnableToParse => e
    # @errors["Raised: #{e.message}"] += 1
    print_message("Raised: #{e.message}")
    print_link(title)
    next
  rescue Table::NoCountries => e
    # @errors["Raised: No countries were found by the table processor."] += 1
    print_message("Raised: No countries were found by the table processor.")
    print_link(title)
    next
  rescue Table::UnresolvedCase => e
  #   @errors["Raised: This example hit one of my unresolved cases"] += 1
    print_message("Raised: #{e.message}")
    print_link(title)
    next
  rescue Encoding::CompatibilityError => e
    # @errors["Raised: CompatibilityError - #{e.message}"] += 1
    print_message("Raised: CompatibilityError - #{e.message}")
    print_link(title)
    next
  rescue Table::DuplicateIocs => e
    # @errors["Raised: Duplicate IOCS - #{e.message}"] += 1
    print_message("Raised: Duplicate IOCS - #{e.message}")
    print_link(title)
    next
  end
  
  if DEBUG
    print_link(title)
    puts result.colorize(:green)
  else
    full_text.sub!(/(\;key\s*\:\s*\n)*\{\{legend.*(host).*(a){3,6}\s*\}\}\n/i, '')
    full_text.sub!(TABLE_REGEX, result)
    client.edit(title: title, text: full_text, summary: "Converting to use [[Template:Medals table]]")

    puts "- success".colorize(:green)
    sleep 15 + rand(5)
  end 
end

puts "DONE!"