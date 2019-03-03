require 'rspec'
require_relative '../country'
require_relative '../table'

describe 'test cases' do
  it 'works for summer 1972' do
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
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = flagIOCteam
 | event          = 1972 Summer
 | team           = 
 | gold_CAN = 0 | silver_CAN = 2 | bronze_CAN = 3
 | gold_IRI = 0 | silver_IRI = 2 | bronze_IRI = 1
 | gold_BEL = 0 | silver_BEL = 2 | bronze_BEL = 0
 | gold_GRE = 0 | silver_GRE = 2 | bronze_GRE = 0
 | gold_AUT = 0 | silver_AUT = 1 | bronze_AUT = 2
 | gold_COL = 0 | silver_COL = 1 | bronze_COL = 2
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
  
  it 'works for mismatched templates' do
    string = <<~TEXT
|-
| rowspan=2| 8 ||align=left| {{flag|France}} || 10 || 8 || 11 || 29
|-
| 38 || align=left | {{flag|Georgia|1990}} ||0||1||0||1
|-
| 45 || align=left | {{flag|Spain}} ||0||0||1||1
TEXT
    result = <<~TEXT 
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_FRA = 10 | silver_FRA = 8 | bronze_FRA = 11
 | gold_GEO = 0 | silver_GEO = 1 | bronze_GEO = 0 | name_GEO = {{flagteam|GEO|1990}}
 | gold_ESP = 0 | silver_ESP = 0 | bronze_ESP = 1
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
  
  it 'works with a host' do
      string = <<~TEXT
|- bgcolor=#ccccff
| rowspan=2| 8 ||align=left| {{flag|France}} || 10 || 8 || 11 || 29
|-
| 45 || align=left | {{flag|Spain}} ||0||0||1||1
  TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = FRA
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_FRA = 10 | silver_FRA = 8 | bronze_FRA = 11 | host_FRA = yes 
 | gold_ESP = 0 | silver_ESP = 0 | bronze_ESP = 1
}}
    TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
  
  it 'works with a unique template and event' do
    string = <<~TEXT
!2
| align="left"|{{RUS}} ||7 ||5 ||6 ||18
|-
!rowspan=2|3
| align="left"|{{flag|Ethiopia|1996}} ||2 ||0 ||0 ||2
|-
| align="left"|{{UKR}} ||2 ||0 ||0 ||2
TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_RUS = 7 | silver_RUS = 5 | bronze_RUS = 6
 | gold_ETH = 2 | silver_ETH = 0 | bronze_ETH = 0 | name_ETH = {{flagteam|ETH|1996}}
 | gold_UKR = 2 | silver_UKR = 0 | bronze_UKR = 0
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
  
  it 'raises an error when the country cannot be parsed' do
    string = <<~TEXT
{| {{RankedMedalTable}}
|-
| KJH'AS || 36 || 39 || 27 || 102|} 
TEXT
    expect{Table.parse_table(string)}.to raise_error(Country::UnableToParse)
  end
  
  
  it 'works when there are multiple of the same template' do
    string = <<~TEXT
{| {{RankedMedalTable|class=wikitable sortable}}
|-
| 1 || align=left| {{flag|United States}} || 11 || 11 || 9 || 31
|-
| 2 || align=left| {{flag|East Germany}} || 11 || 7 || 5 || 23
|-
| 3 || align=left| {{flag|Hungary}} || 3 || 0 || 0 || 3
|-
| 4 || align=left| {{flag|Great Britain}} || 2 || 1 || 5 || 8
|- class="sortbottom"
!colspan=2| Total || 29 || 29 || 29 || 87
|}
TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_USA = 11 | silver_USA = 11 | bronze_USA = 9
 | gold_GDR = 11 | silver_GDR = 7 | bronze_GDR = 5
 | gold_HUN = 3 | silver_HUN = 0 | bronze_HUN = 0
 | gold_GBR = 2 | silver_GBR = 1 | bronze_GBR = 5
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
  
  it 'replaces prevents name being set if they all match' do 
    string = <<~TEXT
{{legend|#ccccff|The host country is highlighted in lavender blue|border=solid 1px #AAAAAA}}
{| {{RankedMedalTable|class=wikitable sortable}}
|-
|bgcolor = DDEEFF| 1  ||align=left| {{flagcountry|Brazil}} ||  9  || 11  ||  7 || 27 
|-
|bgcolor = DDEEFF| 2  ||align=left| {{flagcountry|Argentina}} ||  9  ||  9  ||  7 || 25 
|-
|bgcolor = DDEEFF| 3  ||align=left| {{flagcountry|Colombia}} ||  5  ||  4  ||  4 || 13 
|-
|bgcolor = DDEEFF| 4  ||align=left| {{flagcountry|Chile}} ||  4  ||  2  || 10 || 16 
|-
|bgcolor = DDEEFF| 5  ||align=left| {{flagicon|Peru}} [[Peru|Perú]] ||  3  ||  5  ||  1 ||  9 
|-style="background-color:#ccccff"
|bgcolor = DDEEFF| 6  ||align=left| {{flagcountry|Ecuador}} ||  1  ||  0  ||  2 ||  3 
|}
TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = ECU
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_BRA = 9 | silver_BRA = 11 | bronze_BRA = 7
 | gold_ARG = 9 | silver_ARG = 9 | bronze_ARG = 7
 | gold_COL = 5 | silver_COL = 4 | bronze_COL = 4
 | gold_CHI = 4 | silver_CHI = 2 | bronze_CHI = 10
 | gold_PER = 3 | silver_PER = 5 | bronze_PER = 1
 | gold_ECU = 1 | silver_ECU = 0 | bronze_ECU = 2 | host_ECU = yes 
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
  
  it 'removes flagicon template' do
    string = <<~TEXT
{| {{RankedMedalTable|class=wikitable sortable}}
|-style="background-color:#ccccff"
|bgcolor = DDEEFF| 1  ||align=left| {{flagicon|Panama}} [[Panama|Panamá]] ||  12  ||  13  ||  9 || 34 
|-
|bgcolor = DDEEFF| 2  ||align=left| {{flagcountry|Costa Rica}} ||  3  ||  2  ||  4 ||  9 
|-
|bgcolor = DDEEFF| 3  ||align=left| {{flagcountry|El Salvador}} ||  3  ||  1  ||  5 ||  9 
|-
|bgcolor = DDEEFF| 4  ||align=left| {{flagcountry|Guatemala}} ||  1  ||  2  ||  2 ||  5 
|-
|bgcolor = DDEEFF| 5  ||align=left| {{flagcountry|Honduras}} ||  1  ||  2  ||  0 ||  3 
|}
TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = PAN
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_PAN = 12 | silver_PAN = 13 | bronze_PAN = 9 | host_PAN = yes 
 | gold_CRC = 3 | silver_CRC = 2 | bronze_CRC = 4
 | gold_ESA = 3 | silver_ESA = 1 | bronze_ESA = 5
 | gold_GUA = 1 | silver_GUA = 2 | bronze_GUA = 2
 | gold_HON = 1 | silver_HON = 2 | bronze_HON = 0
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
  
  it 'works when the nations are just plain text' do
    string = <<~TEXT
{| {{RankedMedalTable}}
|-
| 1 ||align=left| USA || 36 || 39 || 27 || 102
|-
| 2 ||align=left| China || 32 || 17 || 14 || 63
|-
| 3 ||align=left| Russia || 27 || 27 || 38 || 92
|} 
TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_USA = 36 | silver_USA = 39 | bronze_USA = 27
 | gold_CHN = 32 | silver_CHN = 17 | bronze_CHN = 14
 | gold_RUS = 27 | silver_RUS = 27 | bronze_RUS = 38
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end

  it 'works for a 3 param template' do 
    string = <<~TEXT
|-
||5||align=left|{{flaglink|TUR|at the 1955 Mediterranean Games}}
||8||3||3||14
|-
||6||align=left|{{flaglink|GRE|at the 1955 Mediterranean Games|old}}
||1||7||8||16
|-
||7||align=left|{{flaglink|LIB|at the 1955 Mediterranean Games}}
||1||1||4||6
|-
||8||align=left|{{flaglink|SYR|at the 1955 Mediterranean Games|1932}}
||1||1||4||6
TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = flaglink
 | event          = at the 1955 Mediterranean Games
 | team           = 
 | gold_TUR = 8 | silver_TUR = 3 | bronze_TUR = 3
 | gold_GRE = 1 | silver_GRE = 7 | bronze_GRE = 8 | name_GRE = {{flaglink|GRE|at the 1955 Mediterranean Games|old}}
 | gold_LIB = 1 | silver_LIB = 1 | bronze_LIB = 4
 | gold_SYR = 1 | silver_SYR = 1 | bronze_SYR = 4 | name_SYR = {{flaglink|SYR|at the 1955 Mediterranean Games|1932}}
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip) 
  end
  
  it 'raises an error for nts templates' do 
    string = <<~TEXT
|-
| 3 ||align=left| {{flagPASOteam|CAN|1963}}|| {{nts|11}} || {{nts|27}} || {{nts|26}} || {{nts|64}}
|-
| 4 ||align=left| {{flagPASOteam|ARG|1963}}|| {{nts|8}} || {{nts|15}} || {{nts|16}} || {{nts|39}}
TEXT
   
    expect{Table.parse_table(string)}.to raise_error(Table::UnresolvedCase) 
  end
  
  it 'raises an error for ref templates' do 
    string = <<~TEXT
|-
| 3 ||align=left| {{flagPASOteam|CAN|1963}} {{ref|1|a}}|| 11 || 2 || 3 || 4
|-
| 4 ||align=left| {{flagPASOteam|ARG|1963}}|| 1 || 2 || 3 || 4
TEXT
    expect{Table.parse_table(string)}.to raise_error(Table::UnresolvedCase) 
  end

  it 'parses the caption and team' do
    string = <<~TEXT
{| {{RankedMedalTable|class=wikitable sortable plainrowheaders|caption=2004 ASEAN University Games medal table|team=NOC}}
|-
|1||align=left|{{flagteam|THA}} || 52 || 46 || 26 || 124
|-style="background:#ccccff"
|2||align=left|{{flagteam|INA}} || 30 || 33 || 48 || 111
    TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 2004 ASEAN University Games medal table
 | host           = INA
 | flag_template  = flagteam
 | event          = 
 | team           = NOC
 | gold_THA = 52 | silver_THA = 46 | bronze_THA = 26
 | gold_INA = 30 | silver_INA = 33 | bronze_INA = 48 | host_INA = yes 
}}
TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end

  it 'works with SFR Yugoslavia' do
    string = <<~TEXT 
|-
| 5 ||align=left| {{flag|SFR Yugoslavia}} || 1 || 1 || 0 || 2
|-bgcolor=cccc
| 9 ||align=left| {{flag|Ireland}} || 0 || 0 || 3 || 3
|-
| =10 ||align=left| {{flag|Denmark}} || 0 || 0 || 2 || 2 
    TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_SFR = 1 | silver_SFR = 1 | bronze_SFR = 0 | name_SFR = {{flagteam|SFR Yugoslavia}}
 | gold_IRL = 0 | silver_IRL = 0 | bronze_IRL = 3
 | gold_DEN = 0 | silver_DEN = 0 | bronze_DEN = 2
}}
    TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
  
  it 'works with FR Yugoslavia' do
    string = <<~TEXT 
|-
| 5 ||align=left| {{flag|FR Yugoslavia}} || 1 || 1 || 0 || 2
|-bgcolor=cccc
| 9 ||align=left| {{flag|Ireland}} || 0 || 0 || 3 || 3
|-
| =10 ||align=left| {{flag|Denmark}} || 0 || 0 || 2 || 2 
    TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_FRY = 1 | silver_FRY = 1 | bronze_FRY = 0 | name_FRY = {{flagteam|FR Yugoslavia}}
 | gold_IRL = 0 | silver_IRL = 0 | bronze_IRL = 3
 | gold_DEN = 0 | silver_DEN = 0 | bronze_DEN = 2
}}
    TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
 
  it 'sets remaining link' do
    string = <<~TEXT
|-
|9||align=left|{{FlagIOC2team|MAS|1994 Asian Games}}||4||2||13||19
|-
|10||align=left|{{FlagIOC2team|QAT|1994 Asian Games}}||4||1||5||10
</onlyinclude><!--DO NOT REMOVE! Leave this after the 10th place at ALL TIMES-->
|-
    TEXT
    result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = FlagIOC2team
 | event          = 1994 Asian Games
 | team           = 
 | remaining_link = [[|Remaining]]
 | show_limit     = <includeonly>10</includeonly>

 | gold_MAS = 4 | silver_MAS = 2 | bronze_MAS = 13
 | gold_QAT = 4 | silver_QAT = 1 | bronze_QAT = 5
}}
    TEXT
    expect(Table.parse_table(string)).to eq(result.strip)
  end
 
  describe 'multi-line tables' do
    it 'works for a multi-line table' do
      # MEDALS_REGEX = /(?:\|+\s*|[\|\s]*)([\.\d]+)\s*\|+\s*([\.\d]+)\s*\|+\s*([\.\d]+)/
      # ISOLATE_COUNTRY = /\|[^\n\{\[]*(.*?)(?=(?:\|\||\n))/
      string = <<~TEXT
|align=left| {{Flag|France}}
| 2
| 1
| 2
| 5
|-
| 2
|align=left| {{Flag|Soviet Union}}
| 1
| 2
| 1
| 4
|-
      TEXT
      result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_FRA = 2 | silver_FRA = 1 | bronze_FRA = 2
 | gold_URS = 1 | silver_URS = 2 | bronze_URS = 1
}}
      TEXT
      expect(Table.parse_table(string)).to eq(result.strip)
    end
    it 'works for a table with blanks' do
      string = <<~TEXT
|-
| 1
| style="text-align:left;" | {{GDR}}
| 0
| 3
| 8
| 11
|-
| 2
| style="text-align:left;" | {{URS}}
| 2
| 
| 1
| 5
|-
| 3
| style="text-align:left;" | {{BUL}}
| 2
| 1
| 
| 1
|-
| 4
| style="text-align:left;" | {{FRG}}
| 1
| 3
| 1
| 5
|-
      TEXT
      result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_GDR = 0 | silver_GDR = 3 | bronze_GDR = 8
 | gold_URS = 2 | silver_URS = 0 | bronze_URS = 1
 | gold_BUL = 2 | silver_BUL = 1 | bronze_BUL = 0
 | gold_FRG = 1 | silver_FRG = 3 | bronze_FRG = 1
}}
      TEXT
      expect(Table.parse_table(string)).to eq(result.strip)
    end
    it 'works for a table with dashes' do
      string = <<~TEXT
|-
| 1
| style="text-align:left;" | {{GDR}}
| -
| 3
| 8
| 11
|-
| 2
| style="text-align:left;" | {{URS}}
| 2
| -
| 1
| 5
|-
| 3
| style="text-align:left;" | {{BUL}}
| 2
| 1
|  -
| 1
|-
| 4
| style="text-align:left;" | {{FRG}}
| 1
| 3
| 1
| 5
|-
      TEXT
      result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_GDR = 0 | silver_GDR = 3 | bronze_GDR = 8
 | gold_URS = 2 | silver_URS = 0 | bronze_URS = 1
 | gold_BUL = 2 | silver_BUL = 1 | bronze_BUL = 0
 | gold_FRG = 1 | silver_FRG = 3 | bronze_FRG = 1
}}
      TEXT
      expect(Table.parse_table(string)).to eq(result.strip)
    end
  end  
  it 'raises an error for duplicate IOCs' do
    string = <<~TEXT
|-
| 23 ||align=left| {{flag|FR Yugoslavia}} || 1 || 3 || 2 || 6
|-
| 23 ||align=left| {{flag|Slovakia}} || 1 || 3 || 2 || 6
|-
| 23 ||align=left| {{flag|FR Yugoslavia}} || 1 || 3 || 2 || 6
|-
| 24 ||align=left| {{flag|Turkey}} || 1 || 2 || 4 || 7
|-
| 33= ||align=left| {{flag|Belgium}} || 0 || 0 || 1 || 1 
TEXT
    expect{Table.parse_table(string)}.to raise_error(Table::DuplicateIocs)
  end
  
  describe 'italics' do
    it 'works with bold numbers' do
      string = <<~TEXT
{| {{RankedMedalTable|class=wikitable sortable}}
|-
| 1 ||align=left| {{flag|URS}} || ''62'' || '''31''' || 23 || 116
|-
| 2 ||align=left| {{flag|USA}} || 54 || 43 || 35 || 132
|-
| 3 ||align=left| {{flag|JPN}} || 32 || 20 || 17 || 69
|-
TEXT
      result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_URS = 62 | silver_URS = 31 | bronze_URS = 23
 | gold_USA = 54 | silver_USA = 43 | bronze_USA = 35
 | gold_JPN = 32 | silver_JPN = 20 | bronze_JPN = 17
}}
TEXT
      expect(Table.parse_table(string)).to eq(result.strip)
    end
    it 'works for basic italics' do
      string = <<~TEXT
{| {{RankedMedalTable|class=wikitable sortable}}
|-
| 1 ||align=left| {{flag|URS}} || 62 || 31 || 23 || 116
|-
| 2 ||align=left| ''{{flag|USA}}'' || 54 || 43 || 35 || 132
|-
| 3 ||align=left| {{flag|JPN}} || 32 || 20 || 17 || 69
|-
TEXT
      result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_URS = 62 | silver_URS = 31 | bronze_URS = 23
 | gold_USA = 54 | silver_USA = 43 | bronze_USA = 35 | name_USA = ''{{flagteam|USA}}''
 | gold_JPN = 32 | silver_JPN = 20 | bronze_JPN = 17
}}
TEXT
      expect(Table.parse_table(string)).to eq(result.strip)
    end
    it 'works for USSR italics' do
      string = <<~TEXT
{| {{RankedMedalTable|class=wikitable sortable}}
|-
| 1 ||align=left| {{flag|SPN}} || 62 || 31 || 23 || 116
|-
| 2 ||align=left| ''{{USSR}}'' || 54 || 43 || 35 || 132
|-
| 3 ||align=left| {{flag|JPN}} || 32 || 20 || 17 || 69
|-
TEXT
      result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_SPN = 62 | silver_SPN = 31 | bronze_SPN = 23
 | gold_URS = 54 | silver_URS = 43 | bronze_URS = 35 | name_URS = ''{{flagteam|Soviet Union}}''
 | gold_JPN = 32 | silver_JPN = 20 | bronze_JPN = 17
}}
TEXT
      expect(Table.parse_table(string)).to eq(result.strip)
    end
    it 'works for custom template italics' do
      string = <<~TEXT
{| {{RankedMedalTable|class=wikitable sortable}}
|-
| 1 ||align=left| {{FlagIOC2team|URS}} || 62 || 31 || 23 || 116
|-
| 2 ||align=left| ''{{FlagIOC2team|USA}}'' || 54 || 43 || 35 || 132
|-
| 3 ||align=left| {{FlagIOC2team|JPN}} || 32 || 20 || 17 || 69
|-
TEXT
      result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = FlagIOC2team
 | event          = 
 | team           = 
 | gold_URS = 62 | silver_URS = 31 | bronze_URS = 23
 | gold_USA = 54 | silver_USA = 43 | bronze_USA = 35 | name_USA = ''{{FlagIOC2team|USA}}''
 | gold_JPN = 32 | silver_JPN = 20 | bronze_JPN = 17
}}
TEXT
      expect(Table.parse_table(string)).to eq(result.strip)
    end
  end
  
  describe 'special cases' do
    it 'works for entries with no IOC code possible' do
      string = <<~TEXT
|-
|1 ||[[Jiangsu]] || 4 || 0 || 0 || 4
|-
|2 ||[[Liaoning]] || 3 || 2 || 1 || 6
|-
|3 ||[[Hunan]] || 2 || 2 || 2 || 6
TEXT
      result = <<~TEXT
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = 
 | event          = 
 | team           = 
 | gold_AAA = 4 | silver_AAA = 0 | bronze_AAA = 0 | name_AAA = [[Jiangsu]]
 | gold_BBB = 3 | silver_BBB = 2 | bronze_BBB = 1 | name_BBB = [[Liaoning]]
 | gold_CCC = 2 | silver_CCC = 2 | bronze_CCC = 2 | name_CCC = [[Hunan]]
}} 
TEXT
      expect(Table.parse_table(string)).to eq(result.strip)
    end
  end
end