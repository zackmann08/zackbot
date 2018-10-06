require 'Clipboard'
require '../helper'
require_relative './country'
require_relative './table'

def print_message(message)
  puts "\t#{message}"
end

string = <<~TEXT
{{legend|#E9D66B|'''Leading in that sport'''}}
{| {{MedalTable|type=Sport}}
|-
|align=left| {{GamesSport|Modern pentathlon|Format=d}} || 1 || 0 || 0 || 1
|-
|--style="background:#E9D66B"
|align=left| {{GamesSport|Rugby sevens|Format=d}} || 1 || 0 || 0 || 1
|-
|align=left| {{GamesSport|Baseball|Format=d}} || 0 || 1 || 0 || 1
|-
|align=left| {{GamesSport|Judo|Format=d}} || 0 || 0 || 2 || 2
|-
! Total !! 2!! 1!! 2!! 5
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



