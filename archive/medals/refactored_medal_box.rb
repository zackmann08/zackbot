require 'Clipboard'
require '../helper'
require_relative './untry'
require_relative './table'

string = <<~TEXT
|-
| 27 ||align=left| {{flagIOCteam|CAN|1972 Summer}} || 0 || 2 || 3 || 5
|-
| 28 ||align=left| {{flagIOCteam|IRI|1972 Summer}} || 0 || 2 || 1 || 3
|-
|rowspan=2| 29 ||align=left| {{flagIOCteam|BEL|1972 Summer}} || 0 || 2 || 0 || 2
|-
|align=left| {{flagIOCteam|GRE|1972 Summer}} || 0 || 2 || 0 || 2
|-
|rowspan=2| 31 ||align=left| {{flagIOCteam|AUT|1972 Summer}} || 0 || 1 || 2 || 3
|-
|align=left| {{flagIOCteam|COL|1972 Summer}} || 0 || 1 || 2 || 3
TEXT

result = Table.parse_table(string)

puts result

# GET_TABLE_REGEX = /\{\|\s*\{\{RankedMedalTable[\S\s]*?\|\}/
# string.gsub!(/\s*style="background[\-color]*\s*:\s*#[D-F][A-Z0-9]{5}[;"]*\s*\|*/i, '')
# string.gsub!(/(?<=\|\|)[\–\-\s]*(?=\|\|)/, '0')
# string.gsub!(/\[\[.*\]\]/, '')
# string.gsub!(/<sup>.*<\/sup>/, '')
# string.gsub!(/<small>.*<\/small>/, '')
# string.gsub!("GBR2", "GBR")
# string.gsub!(/\}\}[\s\w]*\|/, '}} |')
# string.gsub!(/'''/, '')
# string.gsub!(/''/, '')
# string.gsub!(/<small>\(host nation\)<\/small>/i, '')
# string.gsub!(/\}\}\s*\**/, '}}')
# 
# country_names = string.scan(/\{\{flag\|([\w\s]*)\}/).flatten
# country_names.each do |country|
#   ioc = Helper.to_ioc(country)
#   if ioc.nil?
#     puts " FAILED - IOC code '#{country} didn't convert"
#     raise (country)
#   else
#     string.gsub!(country, ioc)
#   end
# end
# 
# template = ''
# event = ''
# 
# template_matches = string.match(/\{\{([Ff]lag[A-Za-z0-9]*)\|/)
# template = template_matches[1] if template_matches
# unless template.empty?
#   event_match = string.match(/\{\{[Ff]lag[A-Za-z0-9]*\s*\|\s*[A-Z]{3}\s*\|\s*([A-Za-z0-9#\-\s]*)\}\}/)
#   event = event_match[1] if event_match
# end
# 
# host = ''
# if string.match?(/(:?ccccff|ccf)/i)
#   host_matches = string.match(/(:?ccccff|ccf|CCF|CCCCFF).*\n*.*(?:([A-Z]{3})|\|([A-Za-z\s\.\-]*)\}\})/)
#   puts host_matches.inspect
#   if host_matches && host_matches[3] 
#     ioc = Helper.to_ioc(host_matches[3])
#     if ioc.nil?
#       puts " FAILED - IOC code '#{host_matches[3]}' didn't convert"
#       raise (host_matches[3])
#     else
#       host = ioc
#     end
#   elsif host_matches 
#     host = host_matches[2]
#   end
# end
# 
# regexes = [
#     /\|([A-Z]{3}).*\}\}\**\s*<.*>[\s\n]*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
#     /[NOC=]*([A-Z]{3})\|[gold=]*(\d+)\|[silver=]*(\d+)\|[bronze=]*(\d+)/,
#     /\|([A-Z]{3})\|(\d+)\|(\d+)\|(\d+)/,
#     /\{flagIOCteam\|([A-Z]{3})\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+) /,
#     /([A-Z]{3})\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
#     /\|([A-Z]{3}).*\}\}\s*\|+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
#     /[\{\|]([A-Z]{3}).*\}\}[\s\n]*[\|]+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/,
#     /(?:[\{\|]([A-Z]{2,3}).*\}\}|\|([\w\s\.\-]*)\}\})[\s\n]*[\|]+\s*(\d+)\s*\|+\s*(\d+)\s*\|+\s*(\d+)/
# ]
# matches = []
# while matches.empty?
#   matches = string.scan(regexes.pop())
#   if regexes.empty?
#     puts "FAILED"
#     exit(1)
#   end
# end
# 
# template = '' if (template.match?(/flagicon/i) || template.strip == 'flag')
# 
# if matches.first.size > 4
#   matches.map!{|m| [(m[0]||m[1]), m[2], m[3], m[4]]}
# end
# result = "
# {{Medals table
#  | caption        = 
#  | host           = #{host}
#  | show_limit     = 
#  | remaining_link = 
#  | flag_template  = #{template}
#  | event          = #{event}
#  | team           = 
# "
# 
# matches.each do |m|
#   unless m[0].match?(/[A-Z]{2,3}/)
#     ioc = Helper.to_ioc(m[0])
#     if ioc.nil?
#       puts " FAILED - IOC code '#{m[0]}' didn't convert"
#       raise (m[0])
#     else
#       m[0] = ioc
#     end
#   end
#   # canada = m[0]
#   # m[0] = m[0]+'A'
#   result += " | gold_#{m[0]} = #{m[1]} | silver_#{m[0]} = #{m[2]} | bronze_#{m[0]} = #{m[3]}#{" | host_#{m[0]} = yes " if m[0] == host}"
#   result += ' | skip_ANA = yes | note_ANA = {{ref|a|[1]}}' if m[0] == 'ANA'
#   # result += " | name_#{m[0]} = {{#{canada}}}"
#   result += "\n"
# end
# result += "}}"
# 
# puts result
# Clipboard.copy(result)