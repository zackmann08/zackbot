require '../sports_tables/sports_table'
require '../sports_tables/team'
require '../helper'

include SportsTable


describe 'Team' do
  describe 'initialize' do
    it 'works for base case' do
      text = '{{Fb cl2 team 2pts |p=1 |t=[[CA River Plate|River Plate]]|w=1 |d=2 |l=3 |gf=4 |ga=5}}'
      
      expect(Team.new(text)).to have_attributes(
          raw_name: '[[CA River Plate|River Plate]]', name: 'RP',
          win: '1', draw: '2', loss: '3',
          gf: '4', ga: '5'
      )
    end

    it 'properly formats the color' do
      text = '{{fb cl2 team |p=2 |nat=SWE |bc=AAEEFF|t=[[Malmö FF]] |w=2 |d=2 |l=2 |gf=7 |ga=7}}'

      expect(Team.new(text)).to have_attributes(
          color: '#AAEEFF'
      )
     
      text = '{{fb cl2 team |p=2 |nat=SWE |bc=#AAEEFF|t=ABC}}'
      expect(Team.new(text)).to have_attributes(
          color: '#AAEEFF'
      )
     
      text = '{{fb cl2 team |p=2 |nat=SWE |bc=AEF|t=ABC}}'
      expect(Team.new(text)).to have_attributes(
          color: '#AEF'
      )
     
      text = '{{fb cl2 team |p=2 |nat=SWE |bc=blue|t=ABC}}'
      expect(Team.new(text)).to have_attributes(
          color: 'blue'
      )
     
      text = '{{fb cl2 team |p=2 |nat=SWE |bc=|t=ABC}}'
      expect(Team.new(text)).to have_attributes(
          color: nil
      )
    end
  end
  
  describe 'parse_status' do
    it 'works for base case' do
      text = '{{Fb cl2 team 2pts |p=1|t = USA| champion=yes}}'
      expect(Team.new(text)).to have_attributes(status: 'C')
    end
    
    it 'works for special case' do
      text = '{{Fb cl2 team 2pts |p=1|t = USA| relegationqualified=DUH}}'
      expect(Team.new(text)).to have_attributes(status: 'RQ')
    end
    
    it 'works for multiple statuses' do
      text = '{{Fb cl2 team 2pts |p=1  |t=[[St Johnstone F.C.|St Johnstone]]|w=25 |d=5  |l=6  |gf=83  |ga=37  |gavg=2.24 |bc=#D0F0C0 |champion=y |promoted=y |relegated=y}}'
      expect(Team.new(text)).to have_attributes(status: 'CPR')
    end
    
    it 'raises error for unresolved case' do
      text = '{{Fb cl2 team 2pts |p=1|t = USA| allsvenskanchampion=DUH}}'
      expect{Team.new(text)}.to raise_error(Helper::UnresolvedCase)
    end    
  end
  
  describe 'parse_name' do
    # it 'raises an error if the length is less than 3' do
    #   expect{Team.parse_name('AA')}.to raise_error(Helper::UnresolvedCase)
    # end
    # 
    # it 'raises an error if the name contains numbers' do
    #   expect{Team.parse_name('Fredrick John Smith the 3rd')}.to raise_error(Helper::UnresolvedCase)
    # end
    
    it 'works for a single word' do
      expect(Team.parse_name('Germany')).to eq('GER')
    end
    
    it 'works for dual word' do
      expect(Team.parse_name('Foo Bar')).to eq('FB')
      expect(Team.parse_name('Júpiter Leonés')).to eq('JL')
    end
    
    it 'works for tri word' do
      expect(Team.parse_name('Foo Bar Smith')).to eq('FBS')
      expect(Team.parse_name('Foo Bar Smith bob and jones')).to eq('FBS')
    end    
    
    it 'works for parentheses' do
      expect(Team.parse_name('Partizani (ASW)')).to eq('PAR')
    end        
    
    it 'works for flag templates' do
      expect(Team.parse_name('{{fb|ARG}}')).to eq('ARG')
    end    
  end
 
  describe 'parse_raw_name' do
    it 'works for plaintext' do
      expect(Team.parse_raw_name('Germany')).to eq('GER')
    end
    
    it 'works for a link' do
      expect(Team.parse_raw_name('[[Testing|Germany]]')).to eq('GER')
      expect(Team.parse_raw_name('[[Testing|Foo Bar Smith]]')).to eq('FBS')
    end
    
    it 'works for parentheses' do
      expect(Team.parse_raw_name('Partizani (aaQ)')).to eq('PAR')
      expect(Team.parse_raw_name('[[Estudiantes|Estudiantes (LP)]]')).to eq('EST')
    end
  end
  
end


describe 'parse_sports_table' do
#   it 'raises an error for duplicate name values' do
#     text = <<~TEXT
# {{fb cl header |noqr=y}}
# {{Fb cl2 team 2pts |p=1 |t=[[Foo Bar]]|w=22 |d=6 |l=6 |gf=81 |ga=43 }}
# {{Fb cl2 team 2pts |p=2 |t=[[Independiente]]|w=22 |d=6 |l=6 |gf=70 |ga=40 }}
# {{Fb cl2 team 2pts |p=3 |t=[[Foo Bar]] |w=20 |d=9 |l=5 |gf=59 |ga=26 }}
# |}
# TEXT
#     
#     expect{parse_sports_table(text)}.to raise_error(Helper::UnresolvedCase)
#   end
  it 'accounts for custom positions' do
    text = <<~TEXT
{{Fb cl header}}
{{Fb cl2 team |p=9  |t=[[Botafogo de Futebol e Regatas|Botafogo]]     |w=17 |d=8  |l=17 |gf=57 |ga=56 }}
{{Fb cl2 team |p=10 |t=[[Santos FC|Santos]]                           |w=16 |d=11 |l=15 |gf=68 |ga=71 }}
{{Fb cl2 team |p=11 |t=[[São Paulo FC|São Paulo]]                     |w=16 |d=10 |l=16 |gf=77 |ga=67 }}
{{Fb cl footer |orfc=1st points; 2nd head-to-head points; 3rd head-to-head goal difference; 4th head-to-head goals scored; 5th goal difference; 6th number of goals scored; |s=[http://esporte.uol.com.br/futebol/campeonatos/brasileiro/2005/classificacao.jhtm UOL Esportes] |date=July 2012}}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR

|team1 = BOT | pos_BOT = 9  | name_BOT = [[Botafogo de Futebol e Regatas|Botafogo]]
|team2 = SAN | pos_SAN = 10 | name_SAN = [[Santos FC|Santos]]
|team3 = SP  | pos_SP  = 11 | name_SP  = [[São Paulo FC|São Paulo]]

|win_BOT = 17|draw_BOT = 8 |loss_BOT = 17|gf_BOT = 57|ga_BOT = 56
|win_SAN = 16|draw_SAN = 11|loss_SAN = 15|gf_SAN = 68|ga_SAN = 71
|win_SP  = 16|draw_SP  = 10|loss_SP  = 16|gf_SP  = 77|ga_SP  = 67
|update=complete
|class_rules=1st points; 2nd head-to-head points; 3rd head-to-head goal difference; 4th head-to-head goals scored; 5th goal difference; 6th number of goals scored;
|source=[http://esporte.uol.com.br/futebol/campeonatos/brasileiro/2005/classificacao.jhtm UOL Esportes]
}}    
TEXT
    
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'accounts for last update date' do
    text = <<~TEXT
{{Fb cl header}}
{{Fb cl2 team |p=1  |t=[[Botafogo de Futebol e Regatas|Botafogo]]     |w=17 |d=8  |l=17 |gf=57 |ga=56 }}
{{Fb cl footer |u=4 December 2005
|orfc=1st points; 2nd head-to-head points; 3rd head-to-head goal difference; 4th head-to-head goals scored; 5th goal difference; 6th number of goals scored; |s=[http://esporte.uol.com.br/futebol/campeonatos/brasileiro/2005/classificacao.jhtm UOL Esportes] |date=July 2012}}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR

|team1 = BOT | name_BOT = [[Botafogo de Futebol e Regatas|Botafogo]]

|win_BOT = 17|draw_BOT = 8 |loss_BOT = 17|gf_BOT = 57|ga_BOT = 56
|update=4 December 2005
|class_rules=1st points; 2nd head-to-head points; 3rd head-to-head goal difference; 4th head-to-head goals scored; 5th goal difference; 6th number of goals scored;
|source=[http://esporte.uol.com.br/futebol/campeonatos/brasileiro/2005/classificacao.jhtm UOL Esportes]
}}    
TEXT
    
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'accounts for wpts on rows' do
    text = <<~TEXT
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=CSK |t='''[[Bohemians 1905|Bohemians Prague]]''' |w=5 |d=0 |l=1 |gf=20 |ga=7 |wpts=2}}
{{fb cl2 team |p=2 |nat=SUI |t=[[FC St. Gallen|St. Gallen]] |w=2 |d=2 |l=2 |gf=8 |ga=13 |wpts=2}}
{{fb cl2 team |p=3 |nat=FRG |t=[[Borussia Mönchengladbach]] |w=2 |d=1 |l=3 |gf=11 |ga=12 |wpts=2}}
{{fb cl2 team |p=4 |nat=DEN |t=[[Lyngby Boldklub|Lyngby]] |w=1 |d=1 |l=4 |gf=8 |ga=15 |wpts=2}}
|}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR
|winpoints=2

|team1 = CSK | name_CSK = '''[[Bohemians 1905|Bohemians Prague]]'''
|team2 = SUI | name_SUI = [[FC St. Gallen|St. Gallen]]
|team3 = FRG | name_FRG = [[Borussia Mönchengladbach]]
|team4 = DEN | name_DEN = [[Lyngby Boldklub|Lyngby]]

|win_CSK = 5 |draw_CSK = 0 |loss_CSK = 1 |gf_CSK = 20|ga_CSK = 7 
|win_SUI = 2 |draw_SUI = 2 |loss_SUI = 2 |gf_SUI = 8 |ga_SUI = 13
|win_FRG = 2 |draw_FRG = 1 |loss_FRG = 3 |gf_FRG = 11|ga_FRG = 12
|win_DEN = 1 |draw_DEN = 1 |loss_DEN = 4 |gf_DEN = 8 |ga_DEN = 15
|update=complete|source=
}}  
TEXT
    
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'accounts for custom colors on rows' do
    text = <<~TEXT
{{Fb cl header |noqr=y}}
{{Fb cl2 team 2pts |p=1 |t=[[Boca Juniors]] |w=27 |d=4 |l=3 |gf=98 |ga=31 |bc=lightgreen }}
{{Fb cl2 team 2pts |p=2 |t=[[CA Independiente|Independiente]] |w=24 |d=7 |l=3 |gf=101 |ga=38 }}
|}
TEXT
    result = <<~TEXT 
{{#invoke:sports table|main|style=WDL
|res_col_header=QR
|winpoints=2

|team1 = BJ  | name_BJ  = [[Boca Juniors]]
|team2 = IND | name_IND = [[CA Independiente|Independiente]]

|win_BJ  = 27|draw_BJ  = 4 |loss_BJ  = 3 |gf_BJ  = 98|ga_BJ  = 31
|win_IND = 24|draw_IND = 7 |loss_IND = 3 |gf_IND = 101|ga_IND = 38
|col_AA=lightgreen|text_AA=
|result1=AA
|update=complete|source=
}}
TEXT
    
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'works for super simple case' do
    text = <<~TEXT
{{fb cl header |noqr=y}}
{{Fb cl2 team 2pts |p=1 |t=[[CA River Plate|River Plate]]|w=22 |d=6 |l=6 |gf=81 |ga=43 }}
{{Fb cl2 team 2pts |p=2 |t=[[CA Independiente|Independiente]]|w=22 |d=6 |l=6 |gf=70 |ga=40 }}
{{Fb cl2 team 2pts |p=3 |t=[[Racing Club de Avellaneda|Racing]] |w=20 |d=9 |l=5 |gf=59 |ga=26 }}
|}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR
|winpoints=2

|team1 = RP  | name_RP  = [[CA River Plate|River Plate]]
|team2 = IND | name_IND = [[CA Independiente|Independiente]]
|team3 = RAC | name_RAC = [[Racing Club de Avellaneda|Racing]]

|win_RP  = 22|draw_RP  = 6 |loss_RP  = 6 |gf_RP  = 81|ga_RP  = 43
|win_IND = 22|draw_IND = 6 |loss_IND = 6 |gf_IND = 70|ga_IND = 40
|win_RAC = 20|draw_RAC = 9 |loss_RAC = 5 |gf_RAC = 59|ga_RAC = 26
|update=complete|source=
}}
TEXT
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'works for case #2' do
    text = <<~TEXT
{{Fb_cl_header |sort=y }}
{{Fb cl2 team 2pts |p=1 |t=[[Bangor City F.C.|Bangor]]|w=7 |d=2 |l=1 |gf=26|ga=11|bc=#ACE1AF|champion=y}}
{{Fb cl2 team 2pts |p=2 |t=[[Flint Town United F.C.|Flint]]|w=6 |d=2 |l=2 |gf=29|ga=20}}
{{Fb cl2 team 2pts |p=3 |t=[[Carnarvon Ironopolis]]  |w=4 |d=2 |l=4 |gf=20|ga=16}}
{{Fb cl2 team 2pts |p=4 |t=[[Llandudno Swifts]]      |w=3 |d=1 |l=6 |gf=14|ga=18}}
{{Fb cl2 team 2pts |p=5 |t=[[Holywell Town F.C.|Holywell]]|w=3 |d=1 |l=6 |gf=15|ga=31}}
{{Fb cl2 team 2pts |p=6 |t=[[Rhyl F.C.|Rhyl]]|w=3 |d=0 |l=7 |gf=13|ga=31}}
{{Fb_cl_footer |s=[http://www.wfda.co.uk/leagues_nwcoast.php?season_id=3 Welsh Football Data Archive]
|date=April 2011}}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR
|winpoints=2
|sortable_table=y

|team1 = BAN | name_BAN = [[Bangor City F.C.|Bangor]]
|team2 = FLI | name_FLI = [[Flint Town United F.C.|Flint]]
|team3 = CI  | name_CI  = [[Carnarvon Ironopolis]]
|team4 = LS  | name_LS  = [[Llandudno Swifts]]
|team5 = HOL | name_HOL = [[Holywell Town F.C.|Holywell]]
|team6 = RHY | name_RHY = [[Rhyl F.C.|Rhyl]]

|win_BAN = 7 |draw_BAN = 2 |loss_BAN = 1 |gf_BAN = 26|ga_BAN = 11|status_BAN = C
|win_FLI = 6 |draw_FLI = 2 |loss_FLI = 2 |gf_FLI = 29|ga_FLI = 20
|win_CI  = 4 |draw_CI  = 2 |loss_CI  = 4 |gf_CI  = 20|ga_CI  = 16
|win_LS  = 3 |draw_LS  = 1 |loss_LS  = 6 |gf_LS  = 14|ga_LS  = 18
|win_HOL = 3 |draw_HOL = 1 |loss_HOL = 6 |gf_HOL = 15|ga_HOL = 31
|win_RHY = 3 |draw_RHY = 0 |loss_RHY = 7 |gf_RHY = 13|ga_RHY = 31
|col_C=#ACE1AF|text_C=
|result1=C
|update=complete
|class_rules=1) points; 2) goal difference; 3) number of goals scored.
|source=[http://www.wfda.co.uk/leagues_nwcoast.php?season_id=3 Welsh Football Data Archive]
}}
TEXT
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'works for case #3' do
    text = <<~TEXT
{{Fb_cl header|gavg=yes|noqr=no}}
{{Fb cl2 team 2pts|p=1 |t=[[North Shore United]]|w=14 |d=3 |l=5 |gf=37 |ga=25 |bc=#ACE1AF|champion=y}}
{{Fb cl2 team 2pts|p=2 |t=[[Stop Out]]|w=11 |d=8 |l=3 |gf=40 |ga=28 }}
{{Fb cl2 team 2pts|p=3 |t=[[Christchurch United]]|w=9 |d=9 |l=4 |gf=32 |ga=17}}
{{Fb cl2 team 2pts|p=4 |t=[[Melville United]]|w=9 |d=9|l=4 |gf=41 |ga=22  }}
{{Fb cl2 team 2pts|p=5 |t=[[Wellington United]]|w=8 |d=7 |l=7 |gf=41 |ga=31 }}
{{Fb cl2 team 2pts|p=6 |t=[[University-Mount Wellington|Mount Wellington]]|w=8|d=7 |l=7 |gf=27 |ga=21  }}
{{Fb cl2 team 2pts|p=7 |t=[[Nelson United]]|w=6 |d=9|l=7 |gf=22 |ga=29 }}
{{Fb cl2 team 2pts|p=8 |t=[[Bay Olympic]]|w=7 |d=7 |l=8 |gf=23 |ga=33 }}
{{Fb cl2 team 2pts|p=9 |t=[[Hakoah Sydney City East FC|Eastern Suburbs]]|w=6 |d=5|l=11 |gf=31 |ga=36 }}
{{Fb cl2 team 2pts|p=10 |t=[[New Brighton A.F.C., New Zealand|New Brighton]]|w=5 |d=7 |l=10 |gf=24 |ga=36 |bc=#FFCCCC|relegated=y}}
{{Fb cl2 team 2pts|p=11 |t=[[Dunedin City]]|w=5 |d=7|l=10 |gf=19 |ga=30  |bc=#FFCCCC|relegated=y}}
{{Fb cl2 team 2pts|p=12 |t=[[Caversham AFC|Caversham]]|w=3|d=4|l=15|gf=14 |ga=43 |bc=#FFCCCC|relegated=y}}
{{Fb cl footer |gavg=yes|s=<ref name="rsssf77"/> |date=May 2012}}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR
|winpoints=2
|use_goal_ratio=yes

|team1 = NSU | name_NSU = [[North Shore United]]
|team2 = SO  | name_SO  = [[Stop Out]]
|team3 = CU  | name_CU  = [[Christchurch United]]
|team4 = MU  | name_MU  = [[Melville United]]
|team5 = WU  | name_WU  = [[Wellington United]]
|team6 = MW  | name_MW  = [[University-Mount Wellington|Mount Wellington]]
|team7 = NU  | name_NU  = [[Nelson United]]
|team8 = BO  | name_BO  = [[Bay Olympic]]
|team9 = ES  | name_ES  = [[Hakoah Sydney City East FC|Eastern Suburbs]]
|team10 = NB  | name_NB  = [[New Brighton A.F.C., New Zealand|New Brighton]]
|team11 = DC  | name_DC  = [[Dunedin City]]
|team12 = CAV | name_CAV = [[Caversham AFC|Caversham]]

|win_NSU = 14|draw_NSU = 3 |loss_NSU = 5 |gf_NSU = 37|ga_NSU = 25|status_NSU = C
|win_SO  = 11|draw_SO  = 8 |loss_SO  = 3 |gf_SO  = 40|ga_SO  = 28
|win_CU  = 9 |draw_CU  = 9 |loss_CU  = 4 |gf_CU  = 32|ga_CU  = 17
|win_MU  = 9 |draw_MU  = 9 |loss_MU  = 4 |gf_MU  = 41|ga_MU  = 22
|win_WU  = 8 |draw_WU  = 7 |loss_WU  = 7 |gf_WU  = 41|ga_WU  = 31
|win_MW  = 8 |draw_MW  = 7 |loss_MW  = 7 |gf_MW  = 27|ga_MW  = 21
|win_NU  = 6 |draw_NU  = 9 |loss_NU  = 7 |gf_NU  = 22|ga_NU  = 29
|win_BO  = 7 |draw_BO  = 7 |loss_BO  = 8 |gf_BO  = 23|ga_BO  = 33
|win_ES  = 6 |draw_ES  = 5 |loss_ES  = 11|gf_ES  = 31|ga_ES  = 36
|win_NB  = 5 |draw_NB  = 7 |loss_NB  = 10|gf_NB  = 24|ga_NB  = 36|status_NB  = R
|win_DC  = 5 |draw_DC  = 7 |loss_DC  = 10|gf_DC  = 19|ga_DC  = 30|status_DC  = R
|win_CAV = 3 |draw_CAV = 4 |loss_CAV = 15|gf_CAV = 14|ga_CAV = 43|status_CAV = R
|col_C=#ACE1AF|text_C=
|result1=C
|col_R=#FFCCCC|text_R=
|result10=R
|result11=R
|result12=R
|update=complete
|class_rules=1) points; 2) goal difference; 3) number of goals scored.
|source=<ref name="rsssf77"/>
}}    
TEXT
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'works for case #4' do
    text = <<~TEXT
{{fb cl header |noqr=y}}
{{Fb cl2 team 2pts |p=1 |t=[[Alfonso Ugarte de Chiclín|Alfonso Ugarte Ed]] |w=4 |d=0 |l=1 |gf=10 |ga=5 |bc=#D0F0C0 }}
{{Fb cl2 team 2pts |p=2 |t=[[Club Octavio Espinoza|Octavio Espinoza]] |w=3 |d=1 |l=1 |gf=10 |ga=6 |bc=#D0F0C0}}
{{Fb cl2 team 2pts |p=3 |t=[[Juan Aurich (1922–1992)|Juan Aurich]] |w=3 |d=1 |l=1 |gf=8 |ga=6 |bc=#D0F0C0 }}
{{Fb cl2 team 2pts |p=4 |t=[[FBC Melgar|Melgar]] |w=2 |d=1 |l=2 |gf=10 |ga=3 }}
{{Fb cl2 team 2pts |p=5 |t=[[Colegio Nacional Iquitos|CNI]] |w=0 |d=2 |l=3 |gf=6 |ga=17 }}
{{Fb cl2 team 2pts |p=6 |t=[[Cienciano]] |w=0 |d=1 |l=4 |gf=4 |ga=11 }}
|}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR
|winpoints=2

|team1 = AUE | name_AUE = [[Alfonso Ugarte de Chiclín|Alfonso Ugarte Ed]]
|team2 = OE  | name_OE  = [[Club Octavio Espinoza|Octavio Espinoza]]
|team3 = JA  | name_JA  = [[Juan Aurich (1922–1992)|Juan Aurich]]
|team4 = MEL | name_MEL = [[FBC Melgar|Melgar]]
|team5 = CNI | name_CNI = [[Colegio Nacional Iquitos|CNI]]
|team6 = CIE | name_CIE = [[Cienciano]]

|win_AUE = 4 |draw_AUE = 0 |loss_AUE = 1 |gf_AUE = 10|ga_AUE = 5 
|win_OE  = 3 |draw_OE  = 1 |loss_OE  = 1 |gf_OE  = 10|ga_OE  = 6 
|win_JA  = 3 |draw_JA  = 1 |loss_JA  = 1 |gf_JA  = 8 |ga_JA  = 6 
|win_MEL = 2 |draw_MEL = 1 |loss_MEL = 2 |gf_MEL = 10|ga_MEL = 3 
|win_CNI = 0 |draw_CNI = 2 |loss_CNI = 3 |gf_CNI = 6 |ga_CNI = 17
|win_CIE = 0 |draw_CIE = 1 |loss_CIE = 4 |gf_CIE = 4 |ga_CIE = 11
|col_PP=#D0F0C0|text_PP=
|result1=PP
|result2=PP
|result3=PP
|update=complete|source=
}}

TEXT
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'works for case #5' do
    text = <<~TEXT
{{Fb cl header |sort=y |noqr=y}}
{{Fb cl2 team 2pts |p=1 |t=[[St Bernard's F.C.|St Bernard's]]|w=11 |d=4  |l=3 |dp = 2 |gf=42 |ga=26 |champion=y }}
{{Fb cl2 team 2pts |p=2 |t=[[Airdrieonians F.C. (1878)|Airdrieonians]]|w=11 |d=1 |bp = 5 |l=6  |gf=43 |ga=32 }}
{{Fb cl2 team 2pts |p=3 |t=[[Abercorn F.C.|Abercorn]]|w=9  |d=3  |l=6  |gf=37 |ga=33 |dp = -7 | bp = 9}}
{{Fb cl2 team 2pts |p=4 |t=[[Clyde F.C.|Clyde]]|w=9  |d=2  |l=7  |gf=43 |ga=35 }}
{{Fb cl2 team 2pts |p=4 |t=[[Port Glasgow Athletic F.C.|Port Glasgow Athletic]]|w=10 |d=0  |l=8  |gf=45 |ga=43 }}
{{Fb cl2 team 2pts |p=6 |t=[[Ayr F.C.|Ayr]]|w=9  |d=0  |l=9  |gf=32 |ga=34 }}
{{Fb cl2 team 2pts |p=7 |t=[[East Stirlingshire F.C.|East Stirlingshire]]|w=7  |d=3  |l=8  |gf=34 |ga=39 }}
{{Fb cl2 team 2pts |p=8 |t=[[Hamilton Academical F.C.|Hamilton Academical]]|w=4  |d=4  |l=10 |gf=41 |ga=49 }}
{{Fb cl2 team 2pts |p=8 |t=[[Leith Athletic F.C.|Leith Athletic]]|w=5  |d=2  |l=11 |gf=22 |ga=32 }}
{{Fb cl2 team 2pts |p=10|t=[[Motherwell F.C.|Motherwell]]|w=4  |d=3  |l=11 |gf=26 |ga=42 }}
{{Fb cl footer|s=[http://www.statto.com/football/teams/east-stirlingshire/1900-1901 statto.com] |date=January 2013 |orfc=Teams finish equal if level on points. Points system: 2 points for a win, 1 point for a draw, 0 points for a loss}}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR
|winpoints=2
|sortable_table=y

|team1 = SB  | name_SB  = [[St Bernard's F.C.|St Bernard's]]
|team2 = AIR | name_AIR = [[Airdrieonians F.C. (1878)|Airdrieonians]]
|team3 = ABE | name_ABE = [[Abercorn F.C.|Abercorn]]
|team4 = CLY | name_CLY = [[Clyde F.C.|Clyde]]
|team5 = PGA | pos_PGA = 4  | name_PGA = [[Port Glasgow Athletic F.C.|Port Glasgow Athletic]]
|team6 = AYR | name_AYR = [[Ayr F.C.|Ayr]]
|team7 = ES  | name_ES  = [[East Stirlingshire F.C.|East Stirlingshire]]
|team8 = HA  | name_HA  = [[Hamilton Academical F.C.|Hamilton Academical]]
|team9 = LA  | pos_LA  = 8  | name_LA  = [[Leith Athletic F.C.|Leith Athletic]]
|team10 = MOT | name_MOT = [[Motherwell F.C.|Motherwell]]

|win_SB  = 11|draw_SB  = 4 |loss_SB  = 3 |gf_SB  = 42|ga_SB  = 26|adjust_points_SB  = 2|status_SB  = C
|win_AIR = 11|draw_AIR = 1 |loss_AIR = 6 |gf_AIR = 43|ga_AIR = 32|adjust_points_AIR = 5
|win_ABE = 9 |draw_ABE = 3 |loss_ABE = 6 |gf_ABE = 37|ga_ABE = 33|adjust_points_ABE = 2
|win_CLY = 9 |draw_CLY = 2 |loss_CLY = 7 |gf_CLY = 43|ga_CLY = 35
|win_PGA = 10|draw_PGA = 0 |loss_PGA = 8 |gf_PGA = 45|ga_PGA = 43
|win_AYR = 9 |draw_AYR = 0 |loss_AYR = 9 |gf_AYR = 32|ga_AYR = 34
|win_ES  = 7 |draw_ES  = 3 |loss_ES  = 8 |gf_ES  = 34|ga_ES  = 39
|win_HA  = 4 |draw_HA  = 4 |loss_HA  = 10|gf_HA  = 41|ga_HA  = 49
|win_LA  = 5 |draw_LA  = 2 |loss_LA  = 11|gf_LA  = 22|ga_LA  = 32
|win_MOT = 4 |draw_MOT = 3 |loss_MOT = 11|gf_MOT = 26|ga_MOT = 42
|result1=C
|update=complete
|class_rules=Teams finish equal if level on points. Points system: 2 points for a win, 1 point for a draw, 0 points for a loss
|source=[http://www.statto.com/football/teams/east-stirlingshire/1900-1901 statto.com]
}}    
TEXT
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'works for case #6 (extra columns)' do
    $allow_extra_columns = true
    text = <<~TEXT
{{Fb cl header}}
{{Fb cl2 team|p=1|t=[[Matavera FC|Matavera]]|w=5|d=1|l=0|gf=11|ga=3|bc=#D0F0C0|qualified=y}}
|rowspan=4|<small>Qualified for [[1984 Cook Islands Round Cup#Knockout stage|Knockout stage]]</small>
{{Fb cl2 team|p=2|t=[[Titikaveka FC|Titikaveka]]|w=4|d=2|l=0|gf=20|ga=5|bc=#D0F0C0|qualified=y}}
{{Fb cl2 team|p=3|t=[[Avatiu FC|Avatiu]] |w=3|d=0|l=3|gf=9|ga=8|bc=#D0F0C0|qualified=y}}
{{Fb cl2 team|p=4|t=[[Arorangi FC|Arorangi]]|w=2|d=2|l=2|gf=6|ga=9|bc=#D0F0C0|qualified=y}}
{{Fb cl2 team|p=5|t=[[Nikao Sokattack FC|Nikao]]|w=2|d=1|l=3|gf=12|ga=11}}
{{Fb cl2 team|p=6|t=[[Tupapa Maraerenga FC|Tupapa]]|w=0|d=2|l=4|gf=6|ga=15}}
{{Fb cl2 team|p=7|t=[[Takuvaine FC|Takuvaine]]|w=1|d=0|l=5|gf=3|ga=16}}
{{Fb cl footer|u=|s=<ref name="RSSSF2">[http://www.rsssf.com/tablesc/cook84.html Cook Islands 1984] at RSSSF.com</ref>|nt=|date=July 2013}}

TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR

|team1 = MAT | name_MAT = [[Matavera FC|Matavera]]
|team2 = TIT | name_TIT = [[Titikaveka FC|Titikaveka]]
|team3 = AVA | name_AVA = [[Avatiu FC|Avatiu]]
|team4 = ARO | name_ARO = [[Arorangi FC|Arorangi]]
|team5 = NIK | name_NIK = [[Nikao Sokattack FC|Nikao]]
|team6 = TUP | name_TUP = [[Tupapa Maraerenga FC|Tupapa]]
|team7 = TAK | name_TAK = [[Takuvaine FC|Takuvaine]]

|win_MAT = 5 |draw_MAT = 1 |loss_MAT = 0 |gf_MAT = 11|ga_MAT = 3 |status_MAT = Q
|win_TIT = 4 |draw_TIT = 2 |loss_TIT = 0 |gf_TIT = 20|ga_TIT = 5 |status_TIT = Q
|win_AVA = 3 |draw_AVA = 0 |loss_AVA = 3 |gf_AVA = 9 |ga_AVA = 8 |status_AVA = Q
|win_ARO = 2 |draw_ARO = 2 |loss_ARO = 2 |gf_ARO = 6 |ga_ARO = 9 |status_ARO = Q
|win_NIK = 2 |draw_NIK = 1 |loss_NIK = 3 |gf_NIK = 12|ga_NIK = 11
|win_TUP = 0 |draw_TUP = 2 |loss_TUP = 4 |gf_TUP = 6 |ga_TUP = 15
|win_TAK = 1 |draw_TAK = 0 |loss_TAK = 5 |gf_TAK = 3 |ga_TAK = 16
|col_Q=#D0F0C0|text_Q=<small>Qualified for [[1984 Cook Islands Round Cup#Knockout stage|Knockout stage]]</small>
|result1=Q
|result2=Q
|result3=Q
|result4=Q
|update=
|class_rules=1) points; 2) goal difference; 3) number of goals scored.
|nt=
|source=<ref name="RSSSF2">[http://www.rsssf.com/tablesc/cook84.html Cook Islands 1984] at RSSSF.com</ref>
}}
TEXT
    expect(parse_sports_table(text)).to eq(result.strip)
  end
  it 'works for case #7 (extra columns)' do
    $allow_extra_columns = true
    text = <<~TEXT 
{{Fb cl header}}
{{Fb cl2 team |p=1 |t=[[Lincoln Red Imps F.C.|Lincoln Red Imps Women]] |w=4 |d=0 |l=0 |gf=15|ga= 1|bc=#D0F0C0|champion=}}||Possible [[2018–19 UEFA Women's Champions League]]
{{Fb cl2 team |p=2 |t=[[Lions Gibraltar F.C.|Lions Gibraltar Women]]   |w=3 |d=0 |l=2 |gf=17|ga= 7|bc=#123456|champion=}}||TESTING
{{Fb cl2 team |p=3 |t=[[Europa F.C.|Europa Women]]                     |w=0 |d=0 |l=5 |gf= 0|ga=24}}
|}
TEXT
    result = <<~TEXT 
{{#invoke:sports table|main|style=WDL
|res_col_header=QR

|team1 = LRI | name_LRI = [[Lincoln Red Imps F.C.|Lincoln Red Imps Women]]
|team2 = LGW | name_LGW = [[Lions Gibraltar F.C.|Lions Gibraltar Women]]
|team3 = EW  | name_EW  = [[Europa F.C.|Europa Women]]

|win_LRI = 4 |draw_LRI = 0 |loss_LRI = 0 |gf_LRI = 15|ga_LRI = 1 
|win_LGW = 3 |draw_LGW = 0 |loss_LGW = 2 |gf_LGW = 17|ga_LGW = 7 
|win_EW  = 0 |draw_EW  = 0 |loss_EW  = 5 |gf_EW  = 0 |ga_EW  = 24
|col_PP=#D0F0C0|text_PP=Possible [[2018–19 UEFA Women's Champions League]]
|result1=PP
|col_BB=#123456|text_BB=TESTING
|result2=BB
|update=complete|source=
}}
TEXT
    expect(parse_sports_table(text)).to eq(result.strip)
  end
#   it 'works for case #' do
#     text = <<~TEXT
# 
# TEXT
#     result = <<~TEXT
# TEXT
#     expect(parse_sports_table(text)).to eq(result.strip)
#   end
#   it 'works for case #' do
#     text = <<~TEXT
# 
# TEXT
#     result = <<~TEXT
# TEXT
#     expect(parse_sports_table(text)).to eq(result.strip)
#   end
  it 'works for parentheses' do
    text = <<~TEXT
{{fb cl header |noqr=y}}
{{fb cl2 team|p=1 |t='''Partizani (Q)''' |w=2 |d=4 |l=0 |gf=8 |ga=4 |bc=#D0F0C0}}
{{fb cl2 team|p=2 |t='''Teuta (Q)'''          |w=2 |d=3 |l=1 |gf=8 |ga=6 |bc=#D0F0C0}}
{{fb cl2 team|p=3 |t=Laci        |w=2 |d=1 |l=3 |gf=5 |ga=7 }}
{{fb cl2 team|p=4 |t=Beselidhja     |w=1 |d=2 |l=3 |gf=5 |ga=9 }}
{{Fb cl footer|u=January 1994 |s= |date=December 2011}}
TEXT
    result = <<~TEXT
{{#invoke:sports table|main|style=WDL
|res_col_header=QR

|team1 = PAR | name_PAR = Partizani (Q)
|team2 = TEU | name_TEU = Teuta (Q)
|team3 = LAC | name_LAC = Laci
|team4 = BES | name_BES = Beselidhja

|win_PAR = 2 |draw_PAR = 4 |loss_PAR = 0 |gf_PAR = 8 |ga_PAR = 4 
|win_TEU = 2 |draw_TEU = 3 |loss_TEU = 1 |gf_TEU = 8 |ga_TEU = 6 
|win_LAC = 2 |draw_LAC = 1 |loss_LAC = 3 |gf_LAC = 5 |ga_LAC = 7 
|win_BES = 1 |draw_BES = 2 |loss_BES = 3 |gf_BES = 5 |ga_BES = 9 
|col_PP=#D0F0C0|text_PP=
|result1=PP
|result2=PP
|update=January 1994
|class_rules=1) points; 2) goal difference; 3) number of goals scored.
|source=
}}
TEXT
    expect(parse_sports_table(text)).to eq(result.strip)
  end
end