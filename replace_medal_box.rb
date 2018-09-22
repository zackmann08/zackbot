require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'

def print_link(title)
  puts "\t#{URI::encode("https://en.wikipedia.org/wiki/#{title}")}"
end

def print_message(message)
  puts "\t#{message}"
end

TABLE_REGEX = /\{\|\s*\{\{RankedMedalTable[\S\s]*?\|\}/

SKIP = [
    '2018 Sukma Games',
    'IAAF World Championships in Athletics',
    '1906 Intercalated Games',
    '2003 World Championships in Athletics',
    "UCI Road World Championships – Men's road race",
    'World Indoor Lacrosse Championship',
    'Tennis at the 1900 Summer Olympics',
    '2010 Commonwealth Games',
    'ISSF 25 meter rapid fire pistol',
    "List of women's World Curling champions",
    'Junior World Rally Championship',
    'Cycling at the 2000 Summer Olympics',
    '1900 Summer Olympics medal table',
    '1907 UCI Track Cycling World Championships',
    '1906 World Weightlifting Championships',
    '1905 World Weightlifting Championships',
    '1999–2000 FIS Ski Jumping World Cup',
    '2000 Asian Wrestling Championships',
    '2000 Asian Weightlifting Championships',
    '2000 UCI Track Cycling World Championships',
    '2000 Summer Paralympics medal table',
    '2001 Asian Wrestling Championships',
    '2001 Asian Fencing Championships',
    '2001 Asian Cycling Championships',
    '2018 European Championships',
    '2018 European Shotgun Championships',
    '2018 Oceania Table Tennis Championships',
    'Golden Grand Prix Ivan Yarygin 2018',
    'Shooting at the 2018 Central American and Caribbean Games',
    '2012 Summer Olympics medal table',
    'World Allround Speed Skating Championships'
]

# URL = "https://petscan.wmflabs.org/?psid=5880073&format=json"
URL = "https://petscan.wmflabs.org/?psid=5890114&format=json"

Helper.read_env_vars

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

results = @content["*"].first['a']['*'].map do |i|
  i["title"]
end
puts "Total to do: #{results.size}"

@content["*"].first['a']['*'].each do |title|
  title = title['title'].gsub("_"," ")
  puts title
  if SKIP.include?(title)
    print_message('Skipping - in SKIP list')
    next
  end
  failed = false
  regexes = [
      /\|([A-Z]{3}).*\}\}\**\s*<.*>[\s\n]*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
      /[NOC=]*([A-Z]{3})\|[gold=]*(\d+)\|[silver=]*(\d+)\|[bronze=]*(\d+)/,
      /\|([A-Z]{3})\|(\d+)\|(\d+)\|(\d+)/,
      /\{flagIOCteam\|([A-Z]{3})\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+) /,
      /([A-Z]{3})\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
      /\|([A-Z]{3}).*\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
      /[\{\|]([A-Z]{3}).*\}\}[\s\n]*[\|]+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
      /(?:[\{\|]([A-Z]{3}).*\}\}|\|([\w\s\.\-]*)\}\})[\s\n]*[\|]+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/
  ]

  full_text = client.get_wikitext(title).body

  table_text = full_text.match(TABLE_REGEX)
  if (table_text.nil? || !table_text[0])
    print_link(title)
    print_message("FAILED - couldn't find the table")
    next
  end
  table_text = table_text[0]

  if table_text.match?(/ANA/)
    print_link(title)
    print_message('SKIPPING - has ANA')
    next
  end
  
  country_names = table_text.scan(/\{\{flag\|([\w\s]*)\}/).flatten
  country_names.each do |country|
    ioc = Helper.to_ioc(country)
    if ioc.nil?
      print_message("IOC code '#{country}' didn't convert")
      failed = true
      break
    else
      table_text.gsub!(country, ioc)
    end
  end 
  next if failed
  
  if table_text.match?(/\{\{[Ii]flm\|/)
    print_link(title)
    print_message('FAILED - uses {{iflm}}')
    next
  end
    
  table_text.gsub!(/\s*style="background[\-color]*\s*:\s*#[D-F][A-Z0-9]{5}[;"]*\s*/i, '')
  table_text.gsub!(/<small>.*<\/small>/, '')
  table_text.gsub!(/<!--.*-->/, '')
  table_text.gsub!(/\|\|\|/, '||')
  table_text.gsub!(/\|\s*\-/, '|0')
  table_text.gsub!("GBR2", "GBR")
  table_text.gsub!(/'''/, '')
  table_text.gsub!(/''/, '')
  table_text.gsub!(/<small>\(host nation\)<\/small>/i, '')
  table_text.gsub!(/\}\}\s*\**/, '}}')

  if table_text.match(/[\[\<]+/)
    print_link(title)
    print_message('FAILED - has a link or HTML tag')
    next
  end

  matches = []
  while matches.empty?
    matches = table_text.scan(regexes.pop())
    if regexes.empty?
      print_link(title)
      print_message("FAILED - REGEX didn't find the things")
      failed = true
      break
    end
  end
  next if failed

  if matches.first.size > 4
    matches.map!{|m| [(m[0]||m[1]), m[2], m[3], m[4]]}
  end

  template = ''
  event = ''

  template_matches = table_text.match(/\{\{([Ff]lag[A-Za-z0-9]*)\|/)
  template = template_matches[1] if template_matches
  unless template.empty?
    event_match = table_text.match(/\{\{[Ff]lag[A-Za-z0-9]*\s*\|\s*[A-Z]{3}\s*\|\s*([A-Za-z0-9\-#\s]*)\}\}/)
    event = event_match[1] if event_match
  end

  host = ''
  if table_text.match?(/(:?ccccff|ccf)/i)
    host_matches = table_text.match(/(:?ccccff|ccf|CCF|CCCCFF).*\n*.*(?:([A-Z]{3})|\|([A-Za-z\s\.\-]*)\}\})/)
    if host_matches && host_matches[3]
      ioc = Helper.to_ioc(host_matches[3])
      if ioc.nil?
        print_message("FAILED - IOC code '#{host_matches[3]}' didn't convert")
        failed = true
      else
        host = ioc
      end
    elsif host_matches
      host = host_matches[2]
    end
  end

  next if failed

  template = '' if (template.match?(/flagicon/i) || template.strip == 'flag')

  result = "{{Medals table
 | caption        = 
 | host           = #{host}
 | flag_template  = #{template}
 | event          = #{event}
 | team           = 
"
  matches.each do |m|
    unless m[0].match?(/[A-Z]{3}/)
      ioc = Helper.to_ioc(m[0])
      if ioc.nil?
        print_message(" FAILED - IOC code '#{m[0]}' didn't convert")
        failed = true
        break
      else
        m[0] = ioc
      end
    end
    m[0] = 'JPN' if m[0] == 'JAP'
    result += " | gold_#{m[0]} = #{m[1]} | silver_#{m[0]} = #{m[2]} | bronze_#{m[0]} = #{m[3]}#{" | host_#{m[0]} = yes " if m[0] == host}"
    result += "\n"
  end
  result += "}}"

  next if failed
  
  full_text.sub!(/(\;key\s*\:\s*\n)*\{\{legend.*(host).*(a){3,6}\s*\}\}\n/i, '')
  full_text.sub!(TABLE_REGEX, result)

  client.edit(title: title, text: full_text, summary: "Converting to use [[Template:Medals table]]", tags: 'AWB')
  puts "- success"
  sleep 1 + rand(5)
end

puts "DONE"
