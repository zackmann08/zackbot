require 'Clipboard'
require './helper'

string = <<~TEXT
| {{RankedMedalTable|class=wikitable sortable|team=CGA}}
|-bgcolor=ccccff
| 1
!scope="row" align="left" style="background:#ccccff"| {{flagicon|IND}} [[India at the 2008 Commonwealth Youth Games|India]]{{dagger}}
|| 33
|| 26
|| 17
|| 76
|-
| 2
!scope="row" align="left"| {{flagicon|AUS}} [[Australia at the 2008 Commonwealth Youth Games|Australia]]
|| 24
|| 18
|| 23
|| 65
|-
| 3
!scope="row" align="left"| {{flagicon|ENG}} [[England at the 2008 Commonwealth Youth Games|England]]
|| 18
|| 9
|| 14
|| 41
|-
| 4
!scope="row" align="left"| {{flagicon|RSA}} [[South Africa at the 2008 Commonwealth Youth Games|South Africa]]
|| 7
|| 14
|| 9
|| 26
|-
| 5
!scope="row" align="left"| {{flagicon|CAN}} [[Canada at the 2008 Commonwealth Youth Games|Canada]]
|| 6
|| 11
|| 9
|| 26
|-
| 6
!scope="row" align="left"| {{flagicon|WAL}} [[Wales at the 2008 Commonwealth Youth Games|Wales]]
|| 5
|| 5
|| 6
|| 16
|-
| 7
!scope="row" align="left"| {{flagicon|MAS}} [[Malaysia at the 2008 Commonwealth Youth Games|Malaysia]]
|| 3
|| 4
|| 6
|| 13
|-
| 8
!scope="row" align="left"| {{flagicon|SCO}} [[Scotland at the 2008 Commonwealth Youth Games|Scotland]]
|| 3
|| 3
|| 12
|| 18
|-
| 9
!scope="row" align="left"| {{flagicon|NZL}} [[New Zealand at the 2008 Commonwealth Youth Games|New Zealand]]
|| 3
|| 1
|| 3
|| 7
|-
| 10
!scope="row" align="left"| {{flagicon|KEN}} [[Kenya at the 2008 Commonwealth Youth Games|Kenya]]
|| 3
|| 0
|| 3
|| 6
|-
| 11
!scope="row" align="left"| {{flagicon|SRI}} [[Sri Lanka at the 2008 Commonwealth Youth Games|Sri Lanka]]
|| 3
|| 0
|| 0
|| 3
|-
| 12
!scope="row" align="left"| {{flagicon|SIN}} [[Singapore at the 2008 Commonwealth Youth Games|Singapore]]
|| 2
|| 5
|| 4
|| 11
|-
| 13
!scope="row" align="left"| {{flagicon|UGA}} [[Uganda at the 2008 Commonwealth Youth Games|Uganda]]
|| 1
|| 3
|| 1
|| 5
|-
| 14
!scope="row" align="left"| {{flagicon|SAM}} [[Samoa at the 2008 Commonwealth Youth Games|Samoa]]
|| 1
|| 1
|| 2
|| 4
|-
| 15
!scope="row" align="left"| {{flagicon|ZAM}} [[Zambia at the 2008 Commonwealth Youth Games|Zambia]]
|| 1
|| 1
|| 1
|| 3
|-
| 16
!scope="row" align="left"| {{flagicon|FIJ}} [[Fiji at the 2008 Commonwealth Youth Games|Fiji]]
|| 1
|| 1
|| 0
|| 2
|-
| 17
!scope="row" align="left"| {{flagicon|BAR}} [[Barbados at the 2008 Commonwealth Youth Games|Barbados]]
|| 1
|| 0
|| 0
|| 1
|-
| 17
!scope="row" align="left"| {{flagicon|GRN}} [[Grenada at the 2008 Commonwealth Youth Games|Grenada]]
|| 1
|| 0
|| 0
|| 1
|-
| 17
!scope="row" align="left"| {{flagicon|Guernsey}} [[Guernsey at the 2008 Commonwealth Youth Games|Guernsey]]
|| 1
|| 0
|| 0
|| 1
|-
| 18
!scope="row" align="left"| {{flagicon|NIR}} [[Northern Ireland at the 2008 Commonwealth Youth Games|Northern Ireland]]
|| 1
|| 4
|| 5
|| 9
|-
| 19
!scope="row" align="left"| {{flagicon|PAK}} [[Pakistan at the 2008 Commonwealth Youth Games|Pakistan]]
|| 0
|| 2
|| 1
|| 3
|-
| 20
!scope="row" align="left"| {{flagicon|NGR}} [[Nigeria at the 2008 Commonwealth Youth Games|Nigeria]]
|| 0
|| 1
|| 2
|| 3
|-
| 21
!scope="row" align="left"| {{flagicon|BOT}} [[Botswana at the 2008 Commonwealth Youth Games|Botswana]]
|| 0
|| 1
|| 1
|| 2
|-
| 21
!scope="row" align="left"| {{flagicon|CMR}} [[Cameroon at the 2008 Commonwealth Youth Games|Cameroon]]
|| 0
|| 1
|| 1
|| 2
|-
| 22
!scope="row" align="left"| {{flagicon|CYP}} [[Cyprus at the 2008 Commonwealth Youth Games|Cyprus]]
|| 0
|| 1
|| 0
|| 1
|-
| 22
!scope="row" align="left"| {{flagicon|GUY}} [[Guyana at the 2008 Commonwealth Youth Games|Guyana]]
|| 0
|| 1
|| 0
|| 1
|-
| 22
!scope="row" align="left"| {{flagicon|MLT}} [[Malta at the 2008 Commonwealth Youth Games|Malta]]
|| 0
|| 1
|| 0
|| 1
|-
| 22
!scope="row" align="left"| {{flagicon|NAM}} [[Namibia at the 2008 Commonwealth Youth Games|Namibia]]
|| 0
|| 1
|| 0
|| 1
|-
| 22
!scope="row" align="left"| {{flagicon|GAM}} [[The Gambia at the 2008 Commonwealth Youth Games|The Gambia]]
|| 0
|| 1
|| 0
|| 1
|-
| 23
!scope="row" align="left"| {{flagicon|BAN}} [[Bangladesh at the 2008 Commonwealth Youth Games|Bangladesh]]
|| 0
|| 0
|| 1
|| 1
|-
| 23
!scope="row" align="left"| {{flagicon|NRU}} [[Nauru at the 2008 Commonwealth Youth Games|Nauru]]
|| 0
|| 0
|| 1
|| 1
|-
| 23
!scope="row" align="left"| {{flagicon|SKN}} [[St Kitts & Nevis at the 2008 Commonwealth Youth Games|St Kitts & Nevis]]
|| 0
|| 0
|| 1
|| 1
|-
| 23
!scope="row" align="left"| {{flagicon|TAN}} [[Tanzania at the 2008 Commonwealth Youth Games|Tanzania]]
|| 0
|| 0
|| 1
|| 1
|-class="sortbottom"
|  ||align=lef
TEXT

# style="background:#[A-Z0-9]{6};"
# if string.match?(/ANA/)
#   puts "- SKIPPING - has ANA"
#   return
# end

GET_TABLE_REGEX = /\{\|\s*\{\{RankedMedalTable[\S\s]*?\|\}/
string.gsub!(/\s*style="background[\-color]*\s*:\s*#[D-F][A-Z0-9]{5}[;"]*\s*\|*/i, '')
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
    /(?:[\{\|]([A-Z]{3}).*\}\}|\|([\w\s\.\-]*)\}\})[\s\n]*[\|]+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/
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
 | show_limit     = 
 | remaining_link = 
 | flag_template  = #{template}
 | event          = #{event}
 | team           = 
"
matches.each do |m|
  unless m[0].match?(/[A-Z]{3}/)
    ioc = Helper.to_ioc(m[0])
    if ioc.nil?
      puts " FAILED - IOC code '#{m[0]}' didn't convert"
      raise (m[0])
    else
      m[0] = ioc
    end
  end
  result += " | gold_#{m[0]} = #{m[1]} | silver_#{m[0]} = #{m[2]} | bronze_#{m[0]} = #{m[3]}#{" | host_#{m[0]} = yes " if m[0] == host}"
  result += ' | skip_ANA = yes | note_ANA = {{ref|a|[1]}}' if m[0] == 'ANA'
  result += "\n"
end
result += "}}"

puts result
Clipboard.copy(result)