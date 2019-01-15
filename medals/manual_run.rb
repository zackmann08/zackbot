require 'Clipboard'
require '../helper'
require_relative './country'
require_relative './table'

def print_message(message)
  puts "\t#{message}"
end

string = <<~TEXT
{| {{MedalTable|type=Sport}}
|-
|align=left| {{GamesSport|Sailing|Format=d}} || 2 || 0 || 0 || 2
|-
|align=left| {{GamesSport|Tennis|Format=d}} || 1 || 3 || 3 || 7
|-
|align=left| {{GamesSport|Polo|Format=d}} || 1 || 1 || 1 || 3
|-
|align=left| {{GamesSport|Athletics|Format=d}} || 1 || 1 || 0 || 2
|-
|align=left| {{GamesSport|Rowing|Format=d}} || 1 || 0 || 0 || 1
|-
|align=left| {{GamesSport|Tug of war|Format=d}} || 1 || 0 || 0 || 1
|-
|align=left| {{GamesSport|Fencing|Format=d}} || 1 || 0 || 0 || 1
|-
! Total !! 8 !! 5 !! 4 !! 17
|}

TEXT
#{flagIOCteam|Kingdom of Yugoslavia}} 
# string.gsub!(/\–/, '-')
# string.gsub!(/\{\{hs\|[a-z]{1,2}\}\}/i, '')
# string.gsub!(/align=center\|/, '')
# string.gsub!(/\{\{nts\|\s*(\d+)\s*\}\}/, '\1')
string.gsub!(/<span[^>]*>([A-Z\(\)]*)<\/span>/, '\1')

result = ''

begin
  result = Table.parse_table(string, false)
  result.gsub!('flagteam','flagcountry')
  result.gsub!('| flag_template  = \s*\n+','| flag_template  = flagcountry\n')
  puts result
  Clipboard.copy(result)
# rescue Country::InvalidIoc, Country::UnableToParse => e
#   print_message("Raised: #{e.message}")
# rescue Table::NoCountries => e
#   print_message("Raised: No countries were found by the table processor.")
# rescue Table::UnresolvedCase => e
#   print_message("Raised: #{e.message}")
end



