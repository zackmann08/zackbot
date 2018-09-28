require 'Clipboard'
require '../helper'
require_relative './country'
require_relative './table'

def print_message(message)
  puts "\t#{message}"
end

string = <<~TEXT
|-bgcolor=ccccff<!--The host nation-->
||1||align=left|{{flag|South Africa}}
||71||64||49||184
|-
||2||align=left|{{flag|Nigeria}}
||64||28||37||129
|-
||3||align=left|{{flag|Egypt}}
||53||60||45||158
|-
||4||align=left|{{flag|Tunisia}}
||20||20||23||63
|-
||5||align=left|{{flag|Algeria}}
||14||24||32||70
|-
||6||align=left|{{flag|Kenya}}
||10||10||20||40
|-
||7||align=left|{{flag|Cameroon}}
||6||13||22||41
|-
||8||align=left|{{flag|Senegal}}
||6||10||9||25
|-
||9||align=left|{{flag|Ethiopia|1996}}
||6||4||4||14
|-
||10||align=left|{{flag|Lesotho|1987}}
||6||1||3||10
|-
||11||align=left|{{flag|Angola}}
||4||1||1||6
|-
||12||align=left|{{flag|Madagascar}}
||4||3||7||14
|-
||13||align=left|{{flag|Ghana}}
||2||2||11||15
|-
||14||align=left|{{flag|Côte d'Ivoire}}
||2||1||5||8
|-
||15||align=left|{{flag|Uganda}}
||2||1||3||6
|-
||16||align=left|{{flag|Zimbabwe}}
||1||10||13||24
|-
||17||align=left|{{flag|Mauritius}}
||1||7||9||17
|-
||18||align=left|{{flag|Gabon}}
||1||3||6||0
|-
||19||align=left|{{flag|DR Congo|1997}}
||1||1||2||4
|-
||20||align=left|{{flag|Mozambique}}
||1||0||0||0
|-
||21||align=left|{{flag|Botswana}}
||0||3||2||5
|-
||22||align=left|{{flag|Seychelles}}
||0||1||6||7
|-
| rowspan=2 |23||align=left|{{flag|Niger}}
||0||1||2||3
|-
|align=left|{{flag|Congo}}
||0||1||2||3
|-
| rowspan=4 |25||align=left|{{flag|Tanzania}}
||0||1||0||1
|-
|align=left|{{flag|Zambia}}
||0||1||0||1
|-
|align=left|{{flag|Togo}}
||0||1||0||1
|-
|align=left|{{flag|Benin}}
||0||1||0||1
|-
||29||align=left|{{flag|Swaziland}}
||0||0||4||4
|-
| rowspan=4 |30||align=left|{{flag|Central African Republic}}
||0||0||2||2
|-
|align=left|{{flag|Mali}}
||0||0||2||2
|-
|align=left|{{flag|Namibia}}
||0||0||2||2
|-
|align=left|{{flag|Cape Verde}}
||0||0||2||2
|-
| rowspan=3 |34||align=left|{{flag|Guinea-Bissau}}  
||0||0||1||1
|-   
|align=left|{{flag|Libya|1977}} 
||0||0||1||1
|-
|align=left|{{flag|Malawi|1964}}
||0||0||1||1
|-
!||Total ||224||223||280||727
|}

TEXT
#{flagcountry|Kingdom of Yugoslavia}} 
# string.gsub!(/\–/, '-')
# string.gsub!(/\{\{hs\|[a-z]{1,2}\}\}/i, '')
# string.gsub!(/align=center\|/, '')
# string.gsub!(/\{\{nts\|\s*(\d+)\s*\}\}/, '\1')

result = ''

begin
  result = Table.parse_table(string)
  puts result
  Clipboard.copy(result)
rescue Country::InvalidIoc, Country::UnableToParse => e
  print_message("Raised: #{e.message}")
rescue Table::NoCountries => e
  print_message("Raised: No countries were found by the table processor.")
rescue Table::UnresolvedCase => e
  print_message("Raised: #{e.message}")
end



