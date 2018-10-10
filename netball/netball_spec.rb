require '../netball/netball'

include Netball
describe 'parse_page' do
  it 'returns a valid result' do
    text = <<~TEXT
{{Infobox netball biography
 |name    = Kathleen Knott
<!-- Personal information -->
 |fullname     =
<!-- Netball career -->
 |positions     = GS
 |domesticyears = 2009-present <br>2007
 |domesticteams = [[Melbourne Vixens]] <br>[[Melbourne Kestrels]] City West Falcons
 |domesticcaps  = 2<br>0
 |nationalyears =
 |nationalteams =
 |nationalcaps  =
 |coachyears    =
 |coachteams    =
<!-- Medal record -->
 |medaltemplates =
}}
TEXT
    result = <<~TEXT
{{Infobox netball biography
 |name    = Kathleen Knott
<!-- Personal information -->
 |fullname     =
<!-- Netball career -->
 |positions     = GS
 |domesticyears1 = 2009-present 
 |domesticteams1 = [[Melbourne Vixens]] 
 |domesticcaps1  = 2
 |domesticyears2 = 2007
 |domesticteams2 = [[Melbourne Kestrels]] City West Falcons
 |domesticcaps2  = 0 
<!-- Medal record -->
 |medaltemplates =
}}
TEXT
    expect(parse_page(text)).to eq(result)
  end
  it 'returns another valid result' do
    text = <<~TEXT
{{Infobox netball biography
 |positions     = GD, GK, WD
 |domesticyears = 2010 <br> 2009 <br> 2005–07
 |domesticteams = [[Queensland Firebirds]] <br> [[Melbourne Vixens]] <br> [[Melbourne Kestrels]] <br> [[Adelaide Thunderbirds]]
 |domesticcaps  = 10 <br> 1 <br> 5
 |nationalyears = 2008–present
 |nationalteams = Australia U21 <br> [[Australian Netball Team]]
 |nationalcaps  = <br>2
 |coachyears    =
 |coachteams    =
}}
TEXT
    result = <<~TEXT
{{Infobox netball biography
 |positions     = GD, GK, WD
 |clubyears1 = 2010 
 |clubteam1  = [[Queensland Firebirds]] 
 |clubapps1  = 10 
 |clubyears2 =  2009 
 |clubteam2  =  [[Melbourne Vixens]] 
 |clubapps2  =  1 
 |clubyears3 =  2005–07
 |clubteam3  =  [[Melbourne Kestrels]] 
 |clubapps3  =  5
 |clubyears4 = 
 |clubteam4  =  [[Adelaide Thunderbirds]]
 |clubapps4  =
 |nationalyears1 = 2008–present
 |nationalteam1  = Australia U21 
 |nationalcaps1  = 
 |nationalyears2 = 
 |nationalteam2  =  [[Australian Netball Team]]
 |nationalcaps2  = 2
 }}
TEXT
    expect(parse_page(text)).to eq(result)
  end
end
describe 'parse_domestic' do
  it 'returns a valid result' do
    text = <<-TEXT
 |domesticyears = 2003 <br>2004–present
 |domesticteams = [[AIS Canberra Darters]] <br>[[Queensland Firebirds]]
 |domesticcaps  = 2<br>4
TEXT
        result = <<-TEXT

 |clubyears1 = 2003 
 |clubteam1  = [[AIS Canberra Darters]] 
 |clubapps1  = 2
 |clubyears2 = 2004–present
 |clubteam2  = [[Queensland Firebirds]]
 |clubapps2  = 4
TEXT
    expect(parse_domestic(text)).to eq(result)
  end
end
describe 'parse_national' do
  it 'returns a valid result' do
    text = <<~TEXT
 |nationalyears = 2003 <br>2004–present
 |nationalteams = [[AIS Canberra Darters]] <br>[[Queensland Firebirds]]
 |nationalcaps  = 2<br>4
TEXT
    result = <<~TEXT
 |nationalyears1 = 2003 
 |nationalteams1 = [[AIS Canberra Darters]] 
 |nationalcaps1  = 2
 |nationalyears2 = 2004–present
 |nationalteams2 = [[Queensland Firebirds]]
 |nationalcaps2  = 4
TEXT
    expect(parse_national(text)).to eq(result)
  end
end
describe 'parse_coach' do
  it 'returns a valid result' do
    text = <<~TEXT
|coachyears = 2003 <br>2004–present
|coachteams = [[AIS Canberra Darters]] <br>[[Queensland Firebirds]]
TEXT
    result = <<~TEXT
|coachyears1 = 2003 
|coachteams1 = [[AIS Canberra Darters]] 
|coachyears2 = 2004–present
|coachteams2 = [[Queensland Firebirds]]
TEXT
    expect(parse_coach(text)).to eq(result)
  end
end
