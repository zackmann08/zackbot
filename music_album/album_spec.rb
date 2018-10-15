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
{{Infobox album | <!-- See Wikipedia:WikiProject_Albums -->
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
  it "raises error for flatlist ending pipes" do
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

    TEXT
    result = <<~TEXT

    TEXT
    expect(parse_album(text)).to eq(result)
  # end
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


