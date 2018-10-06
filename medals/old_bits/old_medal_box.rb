require 'Clipboard'
require './helper'

string = <<~TEXT
{| {{RankedMedalTable}}
|- style="background:#ccf;"
|| 1 || style="text-align:left" | {{flaglink|Australia|at the 2006 Commonwealth Games}}
|| 84 || 69 || 69 || 222
|-
|| 2 || style="text-align:left" | {{flaglink|England|at the 2006 Commonwealth Games}}
|| 36 || 40 || 34 || 110
|-
|| 3 || style="text-align:left" |  {{flaglink|Canada|at the 2006 Commonwealth Games}}
|| 26 || 29 || 31 || 86
|-
|| 4 || style="text-align:left"  | {{flaglink|India|at the 2006 Commonwealth Games}}
|| 22 || 17 || 11 || 50
|-
|| 5 ||style="text-align:left" | {{flaglink|South Africa|at the 2006 Commonwealth Games}}
|| 12 || 13 || 13 || 38
|-
|| 6 || style="text-align:left" |  {{flaglink|Scotland|at the 2006 Commonwealth Games}}
|| 11 || 7 || 11 || 29
|-
|| 7 || style="text-align:left" | {{flaglink|Jamaica|at the 2006 Commonwealth Games}}
|| 10 || 4 || 8 || 22
|-
|| 8 || style="text-align:left" |  {{flaglink|Malaysia|at the 2006 Commonwealth Games}}
|| 7 || 12 || 10 || 29
|-
|| 9 ||style="text-align:left" | {{flaglink|New Zealand|at the 2006 Commonwealth Games}}
|| 6 || 12 || 14 || 32
|-
|| 10 || style="text-align:left" |  {{flaglink|Kenya|at the 2006 Commonwealth Games}}
|| 6 || 5 || 7 || 18
|}
TEXT

# style="background:#[A-Z0-9]{6};"
# if string.match?(/ANA/)
#   puts "- SKIPPING - has ANA"
#   return
# end

GET_TABLE_REGEX = /\{\|\s*\{\{RankedMedalTable[\S\s]*?\|\}/
string.gsub!(/(background.*\|\s*)(?=\n)/, '\1 0')
string.gsub!(/\s*style="background[\-color]*\s*:\s*#[D-F][A-Z0-9]{5}[;"]*\s*\|*/i, '')
string.gsub!(/(?<=\|\|)[\–\-\s]*(?=\|\|)/, '0')
string.gsub!(/\[\[.*\]\]/, '')
string.gsub!(/<sup>.*<\/sup>/, '')
string.gsub!(/<small>.*<\/small>/, '')
string.gsub!("GBR2", "GBR")
string.gsub!(/\}\}[\s\w]*\|/, '}} |')
string.gsub!(/'''/, '')
string.gsub!(/''/, '')
string.gsub!(/<small>\(host nation\)<\/small>/i, '')
string.gsub!(/\}\}\s*\**/, '}}')

country_names = string.scan(/\{\{flag\|([\w\s]*)\}/).flatten
country_names.each do |country|
  ioc = Helper.to_ioc(country)
  if ioc.nil?
    puts " FAILED - IOC code '#{country} didn't convert"
    raise (country)
  else
    string.gsub!(country, ioc)
  end
end

template = ''
event = ''

template_matches = string.match(/\{\{([Ff]lag[A-Za-z0-9]*)\|/)
template = template_matches[1] if template_matches
unless template.empty?
  event_match = string.match(/\{\{[Ff]lag[A-Za-z0-9]*\s*\|\s*[A-Z]{3}\s*\|\s*([A-Za-z0-9#\-\s]*)\}\}/)
  event = event_match[1] if event_match
end

host = ''
if string.match?(/(:?ccccff|ccf)/i)
  host_matches = string.match(/(:?ccccff|ccf|CCF|CCCCFF).*\n*.*(?:([A-Z]{3})|\|([A-Za-z\s\.\-]*)\}\})/)
  puts host_matches.inspect
  if host_matches && host_matches[3] 
    ioc = Helper.to_ioc(host_matches[3])
    if ioc.nil?
      puts " FAILED - IOC code '#{host_matches[3]}' didn't convert"
      raise (host_matches[3])
    else
      host = ioc
    end
  elsif host_matches 
    host = host_matches[2]
  end
end

regexes = [
    /\|([A-Z]{3}).*\}\}\**\s*<.*>[\s\n]*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
    /[NOC=]*([A-Z]{3})\|[gold=]*(\d+)\|[silver=]*(\d+)\|[bronze=]*(\d+)/,
    /\|([A-Z]{3})\|(\d+)\|(\d+)\|(\d+)/,
    /\{flagIOCteam\|([A-Z]{3})\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+) /,
    /([A-Z]{3})\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
    /\|([A-Z]{3}).*\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
    /[\{\|]([A-Z]{3}).*\}\}[\s\n]*[\|]+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
    /(?:[\{\|]\s*([A-Z]{2,3}).*\}\}|\|([\w\s\.\-]*)\}\})[\s\n]*[\|]+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/
]
matches = []
while matches.empty?
  matches = string.scan(regexes.pop())
  if regexes.empty?
    puts "FAILED"
    exit(1)
  end
end

template = '' if (template.match?(/flagicon/i) || template.strip == 'flag')

if matches.first.size > 4
  matches.map!{|m| [(m[0]||m[1]), m[2], m[3], m[4]]}
end
result = "
{{Medals table
 | caption        = 
 | host           = #{host}
 | flag_template  = #{template}
 | event          = #{event}
 | team           = 
"

matches.each do |m|
  unless m[0].match?(/[A-Z]{2,3}/)
    ioc = Helper.to_ioc(m[0])
    if ioc.nil?
      puts " FAILED - IOC code '#{m[0]}' didn't convert"
      raise (m[0])
    else
      m[0] = ioc
    end
  end
  # canada = m[0]
  # m[0] = m[0]+'A'
  result += " | gold_#{m[0]} = #{m[1]} | silver_#{m[0]} = #{m[2]} | bronze_#{m[0]} = #{m[3]}#{" | host_#{m[0]} = yes " if m[0] == host}"
  result += ' | skip_ANA = yes | note_ANA = {{ref|a|[1]}}' if m[0] == 'ANA'
  # result += " | name_#{m[0]} = {{#{canada}}}"
  result += "\n"
end
result += "}}"

puts result
Clipboard.copy(result)