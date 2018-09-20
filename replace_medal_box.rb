require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'

TABLE_REGEX = /\{\|\s*\{\{RankedMedalTable[\S\s]*?\|\}/

SKIP = [
    '1906 Intercalated Games',
    '2003 World Championships in Athletics',
    "UCI Road World Championships – Men's road race",
    'World Indoor Lacrosse Championship',
    'Tennis at the 1900 Summer Olympics'
]

URL = "https://petscan.wmflabs.org/?psid=5860498&format=json"

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
    puts "- Skipping"
    next
  end
  failed = false
  regexes = [
      /\|([A-Z]{3}).*\}\}\**\s*<.*>[\s\n]*\|+\s*(\d+)\s*\|\|\s*(\d+)\s*\|\|\s*(\d+)/,
      /[NOC=]*([A-Z]{3})\|[gold=]*(\d+)\|[silver=]*(\d+)\|[bronze=]*(\d+)/,
      /\|([A-Z]{3})\|(\d+)\|(\d+)\|(\d+)/,
      /\{flagIOCteam\|([A-Z]{3})\}\}\s*\|\|\s*(\d+)\s*\|\|\s*(\d+)\s*\|\|\s*(\d+) /,
      /([A-Z]{3})\}\}\s*\|\|\s*(\d+)\s*\|\|\s*(\d+)\s*\|\|\s*(\d+)/,
      /\|([A-Z]{3}).*\}\}\s*\|\|\s*(\d+)\s*\|\|\s*(\d+)\s*\|\|\s*(\d+)/,
      /\|([A-Z]{3}).*\}\}[\s\n]*[\|]+\s*(\d+)\s*\|\|\s*(\d+)\s*\|\|\s*(\d+)/
  ]

  full_text = client.get_wikitext(title).body

  table_text = full_text.match(TABLE_REGEX)
  next unless table_text[0]
  table_text = table_text[0]
  
  table_text.gsub!(/<small>.*<\/small>/, '')
  table_text.gsub!(/<small>\(host nation\)<\/small>/i, '')
  table_text.gsub!(/\}\}\s*\**/, '}}')

  matches = []
  while matches.empty?
    matches = table_text.scan(regexes.pop())
    if regexes.empty?
      puts "- FAILED"
      failed = true
      break
    end
  end
  next if failed

  template = ''
  event = ''

  template_matches = table_text.match(/\{\{([Ff]lag[A-Za-z0-9]*)\|/)
  template = template_matches[1] if template_matches
  unless template.empty?
    event_match = table_text.match(/\{\{[Ff]lag[A-Za-z0-9]*\s*\|\s*[A-Z]{3}\s*\|\s*([A-Za-z0-9\s]*)\}\}/)
    event = event_match[1] if event_match
  end

  host = ''
  if table_text.match?(/(:?ccccff|ccf)/i)
    host_matches = table_text.match(/(:?ccccff|ccf|CCF|CCCCFF).*\n*.*([A-Z]{3})/)
    host = host_matches[2] if host_matches
  end

  result = "{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = #{template}
 | event          = #{event}
 | team           = 
"
  matches.each do |m|
    result += " | gold_#{m[0]} = #{m[1]} | silver_#{m[0]} = #{m[2]} | bronze_#{m[0]} = #{m[3]}#{" | host_#{m[0]} = yes " if m[0] == host}\n"
  end
  result += "}}"

  full_text.gsub!(TABLE_REGEX, result)

  client.edit(title: title, text: full_text, summary: "Converting to use [[Template:Medals table]]")
  puts "- success"
  sleep 8
end

puts "DONE"
