require 'Clipboard'
require '../helper'
require_relative './country'
require_relative './table'

def print_message(message)
  puts "\t#{message}"
end

string = <<~TEXT
{| {{MedalTable|type=Games}}
!style="width:4.5em; font-weight:bold;"|Rank
|- 
|align=left| [[1930 British Empire Games|1930 Hamilton]] || 0 || 2 || 1 || 3 || 7
|-
|align=left| [[1934 British Empire Games|1934 London]] || 0 || 3 || 3 || 6 || 8
|-
|align=left| [[1938 British Empire Games|1938 Sydney]] || 2 || 1 || 0 || 3 || 6
|-
|align=left| [[1950 British Empire Games|1950 Auckland]] || 0 || 1 || 0 || 1 || 10
|- 
|align=left| [[1954 British Empire and Commonwealth Games|1954 Vancouver]]|| 1 || 1 || 5 || 7 || 13
|- style="background:#ccf;"
|align=left| [[1958 British Empire and Commonwealth Games|1958 Cardiff]]  || 1 || 3 || 7 || 11 || 11
|-
|align=left| [[1962 British Empire and Commonwealth Games|1962 Perth]]  || 0 || 2 || 4 || 6 || 13
|-
|align=left| [[1966 Commonwealth Games|1966 Kingston]] || 3 || 2 || 2 || 7 || 11
|-
|align=left| [[1970 Commonwealth Games|1970 Edinburgh]] || 2 || 6 || 4 || 12 || 12
|-
|align=left| [[1974 Commonwealth Games|1974 Christchurch]] || 1 || 5 || 4 || 10 || 12
|-
|align=left| [[1978 Commonwealth Games|1978 Edmonton]] || 2 || 1 || 5 || 8 || 9
|-
|align=left| [[1982 Commonwealth Games|1982 Brisbane]] || 4 || 4 || 1 || 9 || 8
|-
|align=left| [[1986 Commonwealth Games|1986 Edinburgh]] || 6 || 5 || 12 || 23 || 5
|-
|align=left| [[1990 Commonwealth Games|1990 Auckland]] || 10 || 3 || 12 || 25 || 6
|-
|align=left| [[1994 Commonwealth Games|1994 Victoria]] || 5 || 8 || 6 || 19 || 9
|-
|align=left| [[1998 Commonwealth Games|1998 Kuala Lumpur]] || 3 || 4 || 8 || 15 || 10
|-
|align=left| [[2002 Commonwealth Games|2002 Manchester]] || 6 || 13 || 12 || 31 || 9
|-
|align=left| [[2006 Commonwealth Games|2006 Melbourne]] || 3 || 5 || 11 || 19 || 13
|- 
|align=left| [[2010 Commonwealth Games|2010 Delhi]] || 3 || 6 || 10 || 19 || 15
|-
|align=left| [[2014 Commonwealth Games|2014 Glasgow]] || 5 || 11 || 20 || 36 || 13
|-
|align=left| [[2018 Commonwealth Games|2018 Gold Coast]] || 10 || 12 || 14 || 36 || 7
|-
|- class="sortbottom" style="text-align:center;"
! Total || 67 || 98 || 141 || 306 || 10
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



