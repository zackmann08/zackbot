require '../handball/handball'

include Handball
describe 'parse_clubs_years' do
  it 'returns a valid result' do
    text = <<~TEXT
| years               = 2009-2011<br>2011-2012<br>2012-2013
| clubs               = [[Aalborg DH]]<br>[[Viborg HK]]<br>[[SK Aarhus]]
TEXT
    result = <<~TEXT
| years1              = 2009-2011
| clubs1              = [[Aalborg DH]]
| years2              = 2011-2012
| clubs2              = [[Viborg HK]]
| years3              = 2012-2013
| clubs3              = [[SK Aarhus]]
TEXT
    expect(parse_clubs_years(text)).to eq(result)
  end
  
  it 'works for just club, no years' do
    text = <<~TEXT
| currentclub         = [[RK Gorenje Velenje]]
| clubnumber          = 19
| clubs               = [[RK Priboj (foo)]]<br>[[RK Partizan]]<br>[[RK Zagreb]]
| nationalyears1      = 
TEXT
    result = <<~TEXT
| clubs1              = [[RK Priboj (foo)]]
| clubs2              = [[RK Partizan]]
| clubs3              = [[RK Zagreb]]
TEXT
    expect(parse_clubs_years(text)).to eq(result)
  end
  
  it 'works when years are provided in parentheses' do
    text = <<~TEXT
| clubs               = {{flagicon|Russia}} [[SKIF Krasnodar]] (1996-1998)<br>{{flagicon|Slovakia}} [[HT Tatran Prešov]] (2007-2016)<br>{{flagicon|Czech Republic}} [[HC Banik Karviná]] (2016-present)
TEXT
    result = <<~TEXT
| years1              = 1996-1998
| clubs1              = {{flagicon|Russia}} [[SKIF Krasnodar]] 
| years2              = 2007-2016
| clubs2              = {{flagicon|Slovakia}} [[HT Tatran Prešov]] 
| years3              = 2016-present
| clubs3              = {{flagicon|Czech Republic}} [[HC Banik Karviná]] 
TEXT
    expect(parse_clubs_years(text)).to eq(result)
  end
end
describe 'parse_national' do
  it 'returns a valid result' do
    text = <<~TEXT
| nationalyears       = 1959–1964<br>1965-1978
| nationalteam        = [[Norway national handball team|Norway]]<br>[[Testing123]]
| nationalcaps(goals) = '''7'''<br>'''8''' (92)
TEXT
    result = <<~TEXT
| nationalyears1      = 1959–1964
| nationalteam1       = [[Norway national handball team|Norway]]
| nationalcaps1       = 7
| nationalgoals1      = 
| nationalyears2      = 1965-1978
| nationalteam2       = [[Testing123]]
| nationalcaps2       = 8
| nationalgoals2      = 92
TEXT
    expect(parse_national(text)).to eq(result)
  end
  it 'works when year is missing' do
    text = <<~TEXT 
| nationalteam        = [[Romania women's national handball team|Romania]]
| nationalcaps(goals) = '''130''' (318)
TEXT
    result = <<~TEXT
| nationalyears1      = 
| nationalteam1       = [[Romania women's national handball team|Romania]]
| nationalcaps1       = 130
| nationalgoals1      = 318
TEXT
    expect(parse_national(text)).to eq(result)
  end 
  it 'handles references' do
    text = <<~TEXT 
| nationalteam        = [[Algeria national handball team|Algeria]]
| nationalcaps(goals) = '''70''' (0)<ref>{{cite web|url=http://ihf.info/files/CompetitionData/153/pdf/ALG.pdf |title=2015 World Championship Roster |publisher=[[International Handball Federation|IHF]] |accessdate=15 January 2015 |deadurl=yes |archiveurl=https://web.archive.org/web/20141218194641/http://www.ihf.info/files/CompetitionData/153/pdf/ALG.pdf |archivedate=18 December 2014 }}</ref> 
TEXT
    result = <<~TEXT
| nationalyears1      = 
| nationalteam1       = [[Algeria national handball team|Algeria]]
| nationalcaps1       = 70<ref>{{cite web|url=http://ihf.info/files/CompetitionData/153/pdf/ALG.pdf |title=2015 World Championship Roster |publisher=[[International Handball Federation|IHF]] |accessdate=15 January 2015 |deadurl=yes |archiveurl=https://web.archive.org/web/20141218194641/http://www.ihf.info/files/CompetitionData/153/pdf/ALG.pdf |archivedate=18 December 2014 }}</ref>
| nationalgoals1      = 0
TEXT
    expect(parse_national(text)).to eq(result)
  end
end

describe 'parse_title' do
  it 'works for title' do
    text = <<~TEXT
| title               = Sports director<br>Vice-president
| titleyears          = 1993–1995<br>1997–1999
| titleplace          = [[RK Zamet]]<br>[[ŽRK Zamet]]
TEXT
    result = <<~TEXT
| titleyears1         = 1993–1995
| title1              = Sports director
| titleplace1         = [[RK Zamet]]
| titleyears2         = 1997–1999
| title2              = Vice-president
| titleplace2         = [[ŽRK Zamet]]
TEXT
    expect(parse_title(text)).to eq(result)
  end
end