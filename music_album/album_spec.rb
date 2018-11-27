require '../music_album/album'

include Album

describe 'fix_pipes' do
  it "works for base case" do
    text = <<~TEXT
{{Infobox Album |
  Name        = Furu Purachina|
  Type        = Album |
  Released    = May 24, 2000 |
  Recorded    =  |
  Genre       =[[J-pop]] |
This album  = ''Furu Purachina''<br />(2000) |
Next album  = ''[[Kouseki Radio]]''<br />(2001) |}}
    TEXT
    result = <<~TEXT
{{Infobox Album 
|Name        = Furu Purachina
|Type        = Album 
|Released    = May 24, 2000 
|Recorded    =  
|Genre       =[[J-pop]] 
|This album  = ''Furu Purachina''<br />(2000) 
|Next album  = ''[[Kouseki Radio]]''<br />(2001) 
}}
TEXT
    expect(fix_pipes(text)).to eq(result.strip)
  end  
  it "works for base second case" do
    text = <<~TEXT
{{Infobox album |
  Name        = Furu Purachina|
  Type        = Album |
  Released    = May 24, 2000 |
  Recorded    =  |
  Genre       =[[J-pop]] |
This album  = ''Furu Purachina''<br />(2000) |
Next album  = ''[[Kouseki Radio]]''<br />(2001)
}}
TEXT
    result = <<~TEXT
{{Infobox album 
|Name        = Furu Purachina
|Type        = Album 
|Released    = May 24, 2000 
|Recorded    =  
|Genre       =[[J-pop]] 
|This album  = ''Furu Purachina''<br />(2000) 
|Next album  = ''[[Kouseki Radio]]''<br />(2001)
}}
TEXT
    expect(fix_pipes(text)).to eq(result.strip)
  end
  
end

describe 'parse_extra_chrono' do
  it "works for base case" do
    text = <<~TEXT
{{Extra chronology
| Artist      = [[The Stranglers]]
| Type        = single
| Last single = "[[Always the Sun]] (Sunny Side Up Mix)"<br/>(1991)
| This single = "'''Golden Brown'''"<br/>(1991)
| Next single = "Heaven or Hell"<br/>(1992)
}}
TEXT
    result = <<~TEXT
{{subst:Extra chronology
| Artist      = [[The Stranglers]]
| Type        = single
| prev_title="[[Always the Sun]] (Sunny Side Up Mix)"
| prev_year=1991
| title="Golden Brown"
| year=1991
| next_title="Heaven or Hell"
| next_year=1992
}}
TEXT
    expect(parse_extra_chrono(text)).to eq(result.strip)
  end
  
  
end
describe 'parse_album_year' do
  it 'returns a valid result' do
    text = "''Time Stands Still''<br/>(2015)"
    
    expect(parse_album_year(text)).to eq(['Time Stands Still', '2015'])
  end
  it 'returns a valid result row date range' do
    text = "''[[The Great Blue Star Sessions 1952-1953]]''<br>(1952-53)"
    
    expect(parse_album_year(text)).to eq(['[[The Great Blue Star Sessions 1952-1953]]', '1952-53'])
  end
  
  it 'returns string if there is no date at all' do
    text = "''This Is A Test''"
    expect(parse_album_year(text)).to eq(['This Is A Test',''])
  end
    
  it 'returns string if there is just a link' do
    text = "[[Tour]]"
    expect(parse_album_year(text)).to eq(['[[Tour]]',''])
  end
  
  it 'works with appostrophes' do
    text = " ''[[I Remember (Meli'sa Morgan album)|I Remember]]''<br />(2005)"
    expect(parse_album_year(text)).to eq(["[[I Remember (Meli'sa Morgan album)|I Remember]]",'2005'])
  end
  
  it 'works with no break, standard case' do
    text = " ''[[Taking Heaven By Storm]]'' (1993) "
    expect(parse_album_year(text)).to eq(["[[Taking Heaven By Storm]]",'1993'])
  end
  
  it 'removes trailing pipes' do
    text = "''[[FOO]]''<br />(2007)|  "
    expect(parse_album_year(text)).to eq(["[[FOO]]",'2007'])
  end
  
  it 'works for slashed years' do
    text = " ''[[BAR]]'' <br>(1989/91)"
    expect(parse_album_year(text)).to eq(["[[BAR]]",'1989/91'])
  end
  
  it 'works with en dash' do
    text = "''[[Tenorlee]]''<br>(1977–78)"
    expect(parse_album_year(text)).to eq(["[[Tenorlee]]",'1977–78'])
  end
  
  it 'works with en weird break' do
    text = " ''[[The State of Things (EP)|The State of Things]]'' EP<br/ >(2000)"
    expect(parse_album_year(text)).to eq(["[[The State of Things (EP)|The State of Things]] EP",'2000'])
  end
  
  it 'works with year in music' do
    text = "''[[Yummy, Yummy, Yummy (Julie London album)|Yummy, Yummy, Yummy]]''<br>([[1969 in music|1969]])"
    expect(parse_album_year(text)).to eq(["[[Yummy, Yummy, Yummy (Julie London album)|Yummy, Yummy, Yummy]]", "[[1969 in music|1969]]"])
  end
  
  it 'removes extra breaks' do 
    text = '1st<br />''[[When in Rome, Kill Me]]''<br />(1989)'
    expect(parse_album_year(text)).to eq(["1st<br />[[When in Rome, Kill Me]]", "1989"])
  end
    
  it 'works with small tags' do 
    text = '[[Radio Pirata]] <br> <small> (2004)</small>'
    expect(parse_album_year(text)).to eq(["[[Radio Pirata]]", "2004"])
  end
  
  it 'works for special case #1' do 
    text = "''[[Beautiful Lies You Could Live In]]''<br />(as Pearls Before Swine, 1971)"
    expect(parse_album_year(text)).to eq(["[[Beautiful Lies You Could Live In]]", "1971"])
  end
  
  it 'works for references' do 
    text = <<~TEXT
"[[Animal Arithmetic]]"<ref>{{cite web
 |url         = foo
 |title = bar
}}</ref><br/>(2010)
TEXT
    album = <<~TEXT
"[[Animal Arithmetic]]"<ref>{{cite web
 |url         = foo
 |title = bar
}}</ref>
TEXT
    expect(parse_album_year(text)).to eq([album.strip, "2010"])
  end
  
  # it 'aaaaa' do 
  #   text = 'aaa'
  #   expect(parse_album_year(text)).to eq(["", ""])
  # end
end

describe 'parse_album' do
  it 'returns a valid result' do
    text = <<~TEXT
{{Infobox album <!-- See Wikipedia:WikiProject_Albums -->
| Name = Apex
| Type = studio
| Artist = [[Unleash the Archers]]
| Cover = Apex_album_cover.jpg
| Alt = 
| Released = {{Start date|2017|6|2|mf=y}}<ref>{{Cite web|url=http://www.knac.com/article.asp?ArticleID=23769|title=KNAC.COM - News - UNLEASH THE ARCHERS Premiere 'The Matriarch' Video|website=www.knac.com|access-date=2017-12-29}}</ref>
| Genre = [[Melodic death metal]], [[power metal]]
| Length = {{Duration|m=60|s=37}}
| language = 
| Label = [[Napalm Records]]
| producer = 
| prev_title = 
| prev_year = 
| next_title = 
| next_year = 
| Last album = ''Time Stands Still''<br/>(2015)
| This album = '''''Apex'''''<br/>(2017)
| Next album  = ''[[Burning Horizon at the End of Dawn]]''
}}
TEXT
    result = <<~TEXT
{{subst:Infobox Album 
| name = Apex
| type = studio
| artist = [[Unleash the Archers]]
| cover = Apex_album_cover.jpg
| alt = 
| released = {{Start date|2017|6|2|mf=y}}<ref>{{Cite web|url=http://www.knac.com/article.asp?ArticleID=23769|title=KNAC.COM - News - UNLEASH THE ARCHERS Premiere 'The Matriarch' Video|website=www.knac.com|access-date=2017-12-29}}</ref>
| genre = [[Melodic death metal]], [[power metal]]
| length = {{Duration|m=60|s=37}}
| language = 
| label = [[Napalm Records]]
| producer = 
| prev_title = 
| prev_year = 
| next_title = 
| next_year =
| This album = '''''Apex'''''<br/>(2017)
| prev_title=Time Stands Still
| prev_year=2015
| next_title=[[Burning Horizon at the End of Dawn]]
| next_year=
}}
TEXT
    expect(parse_album(text)).to eq(result)
  end 
  it 'returns a valid result without see text' do
    text = <<~TEXT
{{Infobox album 
| Name = Apex
| Type = studio
| Artist = [[Unleash the Archers]]
| Cover = Apex_album_cover.jpg
| Alt = 
| Released = {{Start date|2017|6|2|mf=y}}<ref>{{Cite web|url=http://www.knac.com/article.asp?ArticleID=23769|title=KNAC.COM - News - UNLEASH THE ARCHERS Premiere 'The Matriarch' Video|website=www.knac.com|access-date=2017-12-29}}</ref>
| Genre = [[Melodic death metal]], [[power metal]]
| Length = {{Duration|m=60|s=37}}
| language = 
| Label = [[Napalm Records]]
| producer = 
| prev_title = 
| prev_year = 
| next_title = 
| next_year = 
| Last album = ''Time Stands Still''<br/>(2015)
| This album = '''''Apex'''''<br/>(2017)
| Next album  = ''[[Burning Horizon at the End of Dawn]]''
}}
TEXT
    result = <<~TEXT
{{subst:Infobox Album 
| name = Apex
| type = studio
| artist = [[Unleash the Archers]]
| cover = Apex_album_cover.jpg
| alt = 
| released = {{Start date|2017|6|2|mf=y}}<ref>{{Cite web|url=http://www.knac.com/article.asp?ArticleID=23769|title=KNAC.COM - News - UNLEASH THE ARCHERS Premiere 'The Matriarch' Video|website=www.knac.com|access-date=2017-12-29}}</ref>
| genre = [[Melodic death metal]], [[power metal]]
| length = {{Duration|m=60|s=37}}
| language = 
| label = [[Napalm Records]]
| producer = 
| prev_title = 
| prev_year = 
| next_title = 
| next_year =
| This album = '''''Apex'''''<br/>(2017)
| prev_title=Time Stands Still
| prev_year=2015
| next_title=[[Burning Horizon at the End of Dawn]]
| next_year=
}}
TEXT
    expect(parse_album(text)).to eq(result)
  end 
  it 'works with trailing pipes' do
    text = <<~TEXT
{{infobox album | <!-- See Wikipedia:WikiProject_Albums -->
 Released    = November 16, 2009 |
  Recorded    =  |
  Genre       = [[Hip hop music|Hip hop]]<br>[[Trip hop]]<br>[[Ethiopian music]]<br>[[Instrumental hip hop]] |
  Length      =  |
  Label       = [[Disruption Productions]] |
  Producer    = [[Oh No (rapper)|Oh No]] |
  Last album  = ''[[Dr. No's Oxperiment]]''<br />(2007)|
  This album  = '''''Dr. No's Ethiopium'''''<br />(2009)|
  Next album  =  ''[[Sawblade EP]] <br /> (2010)
}}
TEXT
    result = <<~TEXT
{{subst:Infobox Album 
|released    = November 16, 2009 
|recorded    =  
|genre       = [[Hip hop music|Hip hop]]<br>[[Trip hop]]<br>[[Ethiopian music]]<br>[[Instrumental hip hop]] 
|length      =  
|label       = [[Disruption Productions]] 
|producer    = [[Oh No (rapper)|Oh No]]
|This album  = '''''Dr. No's Ethiopium'''''<br />(2009)
| prev_title=[[Dr. No's Oxperiment]]
| prev_year=2007
| next_title=[[Sawblade EP]]
| next_year=2010
}}
TEXT
    expect(parse_album(text)).to eq(result)
  end
  it 'works with trailing pipes and spaces' do
    text = <<~TEXT
{{Infobox album| <!-- See Wikipedia:WikiProject_Albums -->
  Name        = Eyes of Innocence |
  Type        = Album |
  Artist      = [[Brídín Brennan]] |
  Cover       = Bridinalbum.jpg|
  Released    = October 19, 2005 |
  Recorded    =  |
  Genre       = [[Pop music]] |
  Length      =  |
  Label       =  MDM Records|
  Producer    = |
  Reviews     = |
  Last album  =  |
  This album  =  '''''Eyes of Innocence'''''|
  Next album  = ''Incumbent''|}}
TEXT
    result = <<~TEXT
{{subst:Infobox Album
|name        = Eyes of Innocence 
|type        = Album 
|artist      = [[Brídín Brennan]] 
|cover       = Bridinalbum.jpg
|released    = October 19, 2005 
|recorded    =  
|genre       = [[Pop music]] 
|length      =  
|label       =  MDM Records
|producer    = 
|Reviews     =
|This album  =  '''''Eyes of Innocence'''''
| prev_title=
| prev_year=
| next_title=Incumbent
| next_year=
}}
TEXT
    expect(parse_album(text)).to eq(result)
  end
  it 'works with trailing pipes 2' do
    text = <<~TEXT
{{Infobox album|
 Released    = November 16, 2009 |
  Recorded    =  |
  Genre       = [[Hip hop music|Hip hop]]<br>[[Trip hop]]<br>[[Ethiopian music]]<br>[[Instrumental hip hop]] |
  Length      =  |
  Label       = [[Disruption Productions]] |
  Producer    = [[Oh No (rapper)|Oh No]] |
  Last album  = ''[[Dr. No's Oxperiment]]''<br />(2007)|
  This album  = '''''Dr. No's Ethiopium'''''<br />(2009)|
  Next album  =  ''[[Sawblade EP]] <br /> (2010)
}}
TEXT
    result = <<~TEXT
{{subst:Infobox Album
|released    = November 16, 2009 
|recorded    =  
|genre       = [[Hip hop music|Hip hop]]<br>[[Trip hop]]<br>[[Ethiopian music]]<br>[[Instrumental hip hop]] 
|length      =  
|label       = [[Disruption Productions]] 
|producer    = [[Oh No (rapper)|Oh No]]
|This album  = '''''Dr. No's Ethiopium'''''<br />(2009)
| prev_title=[[Dr. No's Oxperiment]]
| prev_year=2007
| next_title=[[Sawblade EP]]
| next_year=2010
}}
TEXT
    expect(parse_album(text)).to eq(result)
  end
  it "works for extra pipe at start and wikiproject" do
    text = <<~TEXT
{{Infobox album | <!-- See Wikipedia:WikiProject_Albums -->  
| Name        = Ethiopian Knights
| Last album  = ''[[Kofi (album)|Kofi]]''<br>(1969-70)
| Next album  = ''[[Black Byrd]]''<br>(1972)
}}
    TEXT
    result = <<~TEXT
{{subst:Infobox Album 
| name        = Ethiopian Knights
| prev_title=[[Kofi (album)|Kofi]]
| prev_year=1969-70
| next_title=[[Black Byrd]]
| next_year=1972
}}
    TEXT
    expect(parse_album(text)).to eq(result)
  end  
  it "works for extra pipe at start" do
    text = <<~TEXT
{{Infobox album |
| Name        = Drive
| Type        = studio
| Last album  = From the Redwoods to the Rockies<br />(1998)
| This album  = Drive<br />(2002)
| Next album  = The Benoit/Freeman Project 2<br />(2004)}}
    TEXT
    result = <<~TEXT
{{subst:Infobox Album 
| name        = Drive
| type        = studio
| This album  = Drive<br />(2002)
| prev_title=From the Redwoods to the Rockies
| prev_year=1998
| next_title=The Benoit/Freeman Project 2
| next_year=2004
}}
    TEXT
    expect(parse_album(text)).to eq(result)
  end
  it "works for flatlist ending pipes" do
    text = <<~TEXT
{{Infobox album <!-- See Wikipedia:WikiProject_Albums -->
| Name        = Endless Sleep Chapter 46
| Type        = studio
| Genre       = {{flatlist|
* [[Blues rock]]
* [[Soul music|soul]]
}} 
| Length      = 
}}
    TEXT
    result = <<~TEXT
{{subst:Infobox Album 
| name        = Endless Sleep Chapter 46
| type        = studio
| genre       = {{flatlist|
* [[Blues rock]]
* [[Soul music|soul]]
}} 
| length      = 
}}
    TEXT
    expect(parse_album(text)).to eq(result)
  end

  it "works for special case #1" do
    text = <<~TEXT
{{Infobox album
| Name        = Go Do
| Type        = ep
| Artist      = [[Jón Þór Birgisson|Jónsi]]
| Cover       = Go Do cover.jpg
| Released    = 22 March 2010
| Last album  = [[LAST]]<ref>{{cite web
 |url         = testing again
 |title = another title
}}</ref><br/>(2005)
| This album  = '''Go Do'''
| Next album  = "[[Animal Arithmetic]]"<ref>{{cite web
 |url         = foo
 |title = bar
}}</ref><br/>(2010)
|misc={{External music video|{{YouTube|T6HjT4SQKJI|"Go Do"}} }}
}}
    TEXT
    result = <<~TEXT
{{subst:Infobox Album
| name        = Go Do
| type        = ep
| artist      = [[Jón Þór Birgisson|Jónsi]]
| cover       = Go Do cover.jpg
| released    = 22 March 2010
| This album  = '''Go Do'''
|misc={{External music video|{{YouTube|T6HjT4SQKJI|"Go Do"}} }}
| prev_title=[[LAST]]<ref>{{cite web
 |url         = testing again
 |title = another title
}}</ref>
| prev_year=2005
| next_title="[[Animal Arithmetic]]"<ref>{{cite web
 |url         = foo
 |title = bar
}}</ref>
| next_year=2010
}}
TEXT
    expect(parse_album(text)).to eq(result)
  end

  it "works for special case #2" do
    text = <<~TEXT
{{Infobox Album | <!-- See Wikipedia:WikiProject_Albums -->
|  Name        = Greetings From Tennessee | 
  Cover       = Greetings_from_Tennessee_by_Superdrag_Cover.jpg |
  Type        = [[Album]] |
  Artist      = [[Superdrag]]  |
  Released    = June 27, 2001|
  Genre       = [[Rock and roll|Rock]]/[[Punk rock|Punk]]|
  Length      = 35:25  |
  Label       = [[Two Children Records]] and [[Arena Rock Recording Co.]] |
Last album  = ''[[The Rock Soldier CD]]'' <br /> (2000) |
This album  = '''''Greetings From Tennessee'''''<br /> (2001) |
Next album  = ''[[Last Call For Vitriol]]''<br /> (2002) |}} 
TEXT
    result = <<~TEXT
{{subst:Infobox Album 
|  name        = Greetings From Tennessee
|  cover       = Greetings_from_Tennessee_by_Superdrag_Cover.jpg
|  type        = [[Album]]
|  artist      = [[Superdrag]]
|  released    = June 27, 2001
|  genre       = [[Rock and roll|Rock]]/[[Punk rock|Punk]]
|  length      = 35:25
|  label       = [[Two Children Records]] and [[Arena Rock Recording Co.]]
|This album  = '''''Greetings From Tennessee'''''<br /> (2001)
| prev_title=[[The Rock Soldier CD]]
| prev_year=2000
| next_title=[[Last Call For Vitriol]]
| next_year=2002
}} 
TEXT
    expect(parse_album(text)).to eq(result)
  end

  it "works with extra chrolonogy" do
    text = <<~TEXT
{{Infobox album <!-- See Wikipedia:WikiProject_Albums -->
| Name        = Gamma 1
| Last album  = ''[[LAST]]''<br />(1995)
| This album  = '''''Gamma 1'''''<br />(1996)
| Next album  = ''[[Gamma 2]]''<br />(1997)
| Misc        =
{{Extra chronology
   | Artist      = [[Ronnie Montrose]]
   | Type        = studio
   | Last album  = ''[[Open Fire (album)|Open Fire]]''<br />(1978)
   | This album  = '''''Gamma 1'''''<br />(1979)
   | Next album  = ''[[Gamma 2]]''<br />(1980)}}
}} 
TEXT
    result = <<~TEXT
{{subst:Infobox Album 
| name        = Gamma 1
| This album  = '''''Gamma 1'''''<br />(1996)
| misc        =
{{subst:Extra chronology
   | Artist      = [[Ronnie Montrose]]
   | Type        = studio
| prev_title=[[Open Fire (album)|Open Fire]]
| prev_year=1978
| title=Gamma 1
| year=1979
| next_title=[[Gamma 2]]
| next_year=1980
}}
| prev_title=[[LAST]]
| prev_year=1995
| next_title=[[Gamma 2]]
| next_year=1997
}} 
TEXT
    expect(parse_album(text)).to eq(result)
  end

  it "works with multiple extra chrolonogy" do
    text = <<~TEXT
{{Infobox album <!-- See Wikipedia:WikiProject_Albums -->
| Name = G3: Live in Tokyo
| Cover = G3tok.jpg
| Type = live
| Artist = [[Joe Satriani]], [[Steve Vai]] and [[John Petrucci]]
| Released = October 25, 2005
| Recorded = May 8, 2005
| Genre = [[Instrumental rock]]
| Length = 101:04
| Label = [[Epic Records|Epic]]
| Producer = [[Joe Satriani]]<br />[[Steve Vai]]<br />[[John Petrucci]]
| Misc = {{Extra chronology
| Artist = [[Joe Satriani]]
| Type = live
| Last album = ''[[Is There Love in Space?]]''<br />(2004)
| This album = '''''G3: Live in Tokyo'''''<br />(2005)
| Next album = ''[[One Big Rush: The Genius of Joe Satriani]]'' <br>(2005)
}}
{{Extra chronology
| Artist = [[Steve Vai]]
| Type = live
| Last album = ''[[Live_at_the_Astoria,_London#CD|Live in London]]''<br />(2004)
| This album = '''''G3: Live in Tokyo'''''<br />(2005)
| Next album = ''[[Sound Theories Vol. I & II]]''<br />(2007)
}}
{{Extra chronology
| Artist = [[John Petrucci]]
| Type = live
| Last album = ''[[Suspended Animation (John Petrucci album)|Suspended Animation]]''<br />(2005)
| This album = '''''G3: Live in Tokyo'''''<br />(2005)
| Next album =
}}
{{Extra chronology
| Artist = [[G3 (tour)|G3]]
| Type = live
| Last album = ''[[G3: Rockin' in the Free World]]''<br />(2003)
| This album = '''''G3: Live in Tokyo'''''<br />(2005)
| Next album =
}}
}}
TEXT
    result = <<~TEXT
{{subst:Infobox Album 
| name = G3: Live in Tokyo
| cover = G3tok.jpg
| type = live
| artist = [[Joe Satriani]], [[Steve Vai]] and [[John Petrucci]]
| released = October 25, 2005
| recorded = May 8, 2005
| genre = [[Instrumental rock]]
| length = 101:04
| label = [[Epic Records|Epic]]
| producer = [[Joe Satriani]]<br />[[Steve Vai]]<br />[[John Petrucci]]
| misc = {{subst:Extra chronology
| Artist = [[Joe Satriani]]
| Type = live
| prev_title=[[Is There Love in Space?]]
| prev_year=2004
| title=G3: Live in Tokyo
| year=2005
| next_title=[[One Big Rush: The Genius of Joe Satriani]]
| next_year=2005
}}
{{subst:Extra chronology
| Artist = [[Steve Vai]]
| Type = live
| prev_title=[[Live_at_the_Astoria,_London#CD|Live in London]]
| prev_year=2004
| title=G3: Live in Tokyo
| year=2005
| next_title=[[Sound Theories Vol. I & II]]
| next_year=2007
}}
{{subst:Extra chronology
| Artist = [[John Petrucci]]
| Type = live
| prev_title=[[Suspended Animation (John Petrucci album)|Suspended Animation]]
| prev_year=2005
| title=G3: Live in Tokyo
| year=2005
| next_title=
| next_year=
}}
{{subst:Extra chronology
| Artist = [[G3 (tour)|G3]]
| Type = live
| prev_title=[[G3: Rockin' in the Free World]]
| prev_year=2003
| title=G3: Live in Tokyo
| year=2005
| next_title=
| next_year=
}}
}}
TEXT
    expect(parse_album(text)).to eq(result)
  end

  it "works for special case with new lines" do
    text = <<~TEXT
{{Infobox album| <!-- See Wikipedia:WikiProject_Albums -->
| Name        = Time Flies...but Aeroplanes Crash
| Type        = ep
| Artist      = [[Subhumans (UK band)|Subhumans]]
| Cover       = Time FliesBut Aeroplanes Crash.jpg
| Released    = October 1983
| Recorded    = 5/10 August 1983 (tracks 1-3, 5 and 8),
29 July 1983 (tracks 4, 6 and 7)
| Genre       = [[Punk rock|Punk]]
| Length      =
| Label       = [[Bluurg Records]]
| Producer    = Subhumans
| Reviews     =
| Last album  = ''[[Evolution (Subhumans album)|Evolution]]''<br/> (1983)
| This album  = '''''Time Flies...but Aeroplanes Crash'''''<br/> (1983)
| Next album  = ''[[From the Cradle to the Grave (album)|From the Cradle to the Grave]]''<br/> (1984)
}}
    TEXT
    result = <<~TEXT
{{subst:Infobox Album
| name        = Time Flies...but Aeroplanes Crash
| type        = ep
| artist      = [[Subhumans (UK band)|Subhumans]]
| cover       = Time FliesBut Aeroplanes Crash.jpg
| released    = October 1983
| recorded    = 5/10 August 1983 (tracks 1-3, 5 and 8),
29 July 1983 (tracks 4, 6 and 7)
| genre       = [[Punk rock|Punk]]
| length      =
| label       = [[Bluurg Records]]
| producer    = Subhumans
| Reviews     =
| This album  = '''''Time Flies...but Aeroplanes Crash'''''<br/> (1983)
| prev_title=[[Evolution (Subhumans album)|Evolution]]
| prev_year=1983
| next_title=[[From the Cradle to the Grave (album)|From the Cradle to the Grave]]
| next_year=1984
}}
TEXT
    expect(parse_album(text)).to eq(result)
  end
  # 
  # it "works for special case #1" do
  #   text = <<~TEXT
  # 
  #   TEXT
  #   result = <<~TEXT
  # 
  #   TEXT
  #   expect(parse_album(text)).to eq(result)
  # end
end

