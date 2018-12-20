require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require '../sports_tables/sports_table'
# encoding: utf-8
include SportsTable

# https://en.wikipedia.org/wiki/1906%E2%80%9307_Scottish_Division_Two
# adjust_points_COW
# hth_COW

# https://petscan.wmflabs.org/?psid=6716390
text = <<~TEXT
{{infobox football tournament season
| title = [[Toto Cup|Toto Cup Leumit]]
| year  = 2016–17
| other_title =
| image =
| imagesize =
| caption =
| country = {{ISR}}
| num_teams = 16
| champions = [[Maccabi Sha'arayim F.C.|Maccabi Sha'arayim]]
| runner-up = [[Hapoel Ramat Gan F.C.|Hapoel Ramat Gan]]
| matches = 22
| goals = 55
| top goal scorer = [[Ali El-Khatib]] (4)
| player =
| prevseason  = [[2015–16 Toto Cup Leumit|2015–16]]
| nextseason  = [[2017–18 Toto Cup Leumit|2017–18]]
}}
The '''2016–17 [[Toto Cup]] Leumit''' was the 27th season of the [[Liga Leumit|second tier]] [[League Cup]] (as a separate competition) since its introduction. It was held in two stages. First, sixteen [[2016–17 Liga Leumit|Liga Leumit]] teams were divided into four regionalized groups, with the winners and runners-up advanced to the quarter-finals. Quarter-finals, semi-finals and the final were held as one-legged matches.

The defending cup holders were [[Hapoel Ashkelon F.C.|Hapoel Ashkelon]], having won the cup on its [[2015–16 Toto Cup Leumit|previous edition]].

In the final, played on 30 November 2016, [[Maccabi Sha'arayim F.C.|Maccabi Sha'arayim]] defeated [[Hapoel Ramat Gan F.C.|Hapoel Ramat Gan]] 2–1.<ref>[https://sports.walla.co.il/item/3018276 Due to a Penalty Kick Stop at the 120th Minute: Maccabi Sha'arayim Won the Toto Cup Leumit] 30 November 2016, Walla! {{he icon}}</ref>

==Group stage==
Groups were allocated according to geographic distribution of the clubs. The groups were announced by the IFA on took place on 18 July 2016.<ref>[http://www.one.co.il/Article/16-17/1,2,6,0/274504.html Leumit: Hapoel P.T. vs. Netanya in the Opening Round] 18 July 2016, One {{he icon}}</ref>

The matches are due to be played from 1 August.

===Tiebreakers===
If two or more teams are equal on points on completion of the group matches, the following criteria are applied to determine the rankings.<ref name="regulations1">[http://football.org.il/Game%20Rules/%D7%AA%D7%A7%D7%A0%D7%95%D7%9F%20%D7%92%D7%91%D7%99%D7%A2%20%D7%9E%D7%93%D7%99%D7%A0%D7%94.pdf State Cup Regulations (page 22)] football.org.il {{he icon}}</ref><ref name="regulations2">[http://football.org.il/Game%20Rules/%D7%AA%D7%A7%D7%A0%D7%95%D7%9F%20%D7%90%D7%9C%D7%99%D7%A4%D7%95%D7%AA.pdf Championship Regulations (pages 41-47)] football.org.il {{he icon}}</ref>
# Superior [[goal difference]]
# Higher number of victories achieved
# Higher number of goals scored
# Higher number of points obtained in the group matches played among the teams in question
# Superior goal difference from the group matches played among the teams in question
# Higher number of victories achieved in the group matches played among the teams in question
# Higher number of goals scored in the group matches played among the teams in question
# A deciding match, if needed to set which team qualifies to the quarter-finals.

{| class="wikitable"
|-
!Key to colours in group tables
|- bgcolor=#ACE1AF
|Group winners and runners-up advanced to the Quarterfinals
|}

===Group A===
{{col-begin}}
{{col-2}}
{{Fb cl header |noqr=y}}
{{fb cl2 team|p=1 |t=Maccabi Ahi Nazareth |w=2 |d=1 |l=0 |gf=5 |ga=3 |bc=#ACE1AF }}
{{fb cl2 team|p=2 |t=Hapoel Afula|w=1 |d=1 |l=1 |gf=5 |ga=4 |bc=#ACE1AF }}
{{fb cl2 team|p=3 |t=Hapoel Acre|w=1 |d=1 |l=1 |gf=3 |ga=3 }}
{{fb cl2 team|p=4 |t=Hapoel Nazareth Illit |w=0 |d=1 |l=2 |gf=4 |ga=7 }}
{{Fb cl footer |s=[http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?GroupId=1&SEASON_ID=18&LEAGUE_ID=630 football.org.il] {{he icon}} |orfc=1st points; 2nd goal difference; 3rd matches won; 4th goals scored; 5th head-to-head; 6th decision match|u=27 September 2016 |season_over=y |date=September 2016}}
{{col-2}}
{{Fb r2 header |nt=4 |[[Hapoel Acre F.C.|HAC]]|[[Hapoel Afula F.C.|HAF]]|[[Hapoel Nazareth Illit F.C.|HNI]]|[[Maccabi Ahi Nazareth F.C.|MAN]]}}

{{Fb r2 team |t= [[Hapoel Acre F.C.|Hapoel Acre]]}}
<!-- Hapoel Acre --> {{fb r |r=null }}
<!-- Hapoel Afula --> {{fb r | r=null }}
<!-- Hapoel Nazareth Illit --> {{fb r |r=null }}
<!-- Maccabi Ahi Nazareth --> {{fb r |gf=1 |ga=2 }}

{{Fb r2 team |t=[[Hapoel Afula F.C.|Hapoel Afula]]}}
<!-- Hapoel Acre --> {{fb r |gf=1 |ga=2 }}
<!-- Hapoel Afula --> {{fb r |r=null }}
<!-- Hapoel Nazareth Illit --> {{fb r |r=null }}
<!-- Maccabi Ahi Nazareth --> {{fb r |r=null }}

{{Fb r2 team |t= [[Hapoel Nazareth Illit F.C.|Hapoel Nazareth Illit]]}}
<!-- Hapoel Afula --> {{fb r |gf=2 |ga=4 }}
<!-- Hapoel Nazareth Illit --> {{fb r |r=null }}
<!-- Maccabi Ahi Nazareth --> {{fb r |r=null }}
<!-- Hapoel Acre --> {{fb r |gf=0 |ga=0 }}

{{Fb r2 team |t= [[Maccabi Ahi Nazareth F.C.|Maccabi Ahi Nazareth]]}}
<!-- Hapoel Afula --> {{fb r |gf=0| ga=0 }}
<!-- Hapoel Nazareth Illit --> {{fb r |gf=3 |ga=2 }}
<!-- Maccabi Ahi Nazareth --> {{fb r |r=null }}
<!-- Hapoel Acre --> {{fb r |r=null }}

{{Fb r footer |s=[http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?GroupId=1&SEASON_ID=18&LEAGUE_ID=630 football.org.il] {{he icon}}|u=27 September 2016|date=September 2016}}
{{col end}}

===Group B===
{{col-begin}}
{{col-2}}
{{Fb cl header |noqr=y}}
{{fb cl2 team|p=1 | t=Maccabi Netanya |w=1 |d=2 |l=0 |gf=4 |ga=3 |bc=#ACE1AF }}
{{fb cl2 team|p=2 | t=Hapoel Ramat HaSharon|w=1 |d=1 |l=1 |gf=6 |ga=5 |bc=#ACE1AF }}
{{fb cl2 team|p=3 |t=Ironi Nesher |w=1 |d=1 |l=1 |gf=3 |ga=3  }}
{{fb cl2 team|p=4 |t=Maccabi Herzliya |w=0 |d=2 |l=1 |gf=7 |ga=9 }}
{{Fb cl footer |s=[http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?GroupId=2&SEASON_ID=18&LEAGUE_ID=630 football.org.il] {{he icon}} |orfc=1st points; 2nd goal difference; 3rd matches won; 4th goals scored; 5th head-to-head; 6th decision match|u=20 September 2016 |season_over=y |date=September 2016}}

{{col-2}}
{{Fb r2 header |nt=4 |[[Hapoel Nir Ramat HaSharon F.C.|HRH]]|[[Ironi Nesher F.C.|INE]]|[[Maccabi Herzliya F.C.|MHE]]|[[Maccabi Netanya F.C.|MNE]]}}
{{Fb r2 team |t=[[Hapoel Nir Ramat HaSharon F.C.|Hapoel Ramat HaSharon]]}}
<!-- Hapoel Ramat HaSharon  --> {{fb r |r=null }}
<!-- Ironi Nesher --> {{fb r |gf=0 | ga=1 }}
<!-- Maccabi Herzliya --> {{fb r |r=null }}
<!-- Maccabi Netanya --> {{fb r |gf=1 |ga=1 }}

{{Fb r2 team |t=[[Ironi Nesher F.C.|Ironi Nesher]]}}
<!-- Hapoel Ramat HaSharon  --> {{fb r |r=null }}
<!-- Ironi Nesher --> {{fb r |r=null }}
<!-- Maccabi Herzliya --> {{fb r |gf=2 |ga=2 }}
<!-- Maccabi Netanya --> {{fb r |gf=0 |ga=1 }}

{{Fb r2 team |t=[[Maccabi Herzliya F.C.|Maccabi Herzliya]]}}
<!-- Hapoel Ramat HaSharon  --> {{fb r |gf=3 |ga=5 }}
<!-- Ironi Nesher --> {{fb r |r=null }}
<!-- Maccabi Herzliya --> {{fb r |r=null }}
<!-- Maccabi Netanya --> {{fb r |r=null }}

{{Fb r2 team |t=[[Maccabi Netanya F.C.|Maccabi Netanya]]}}
<!-- Hapoel Ramat HaSharon  --> {{fb r |r=null }}
<!-- Ironi Nesher --> {{fb r |r=null }}
<!-- Maccabi Herzliya --> {{fb r |gf=2 |ga=2 }}
<!-- Maccabi Netanya --> {{fb r |r=null }}

{{Fb r footer |s=[http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?GroupId=2&SEASON_ID=18&LEAGUE_ID=630 football.org.il] {{he icon}}|u=20 September 2016 |date=September 2016}}
{{col end}}

===Group C===
{{col-begin}}
{{col-2}}
{{Fb cl header |noqr=y}}
{{fb cl2 team|p=1 |t=Hapoel Bnei Lod|w=3 |d=0 |l=0 |gf=6 |ga=1|bc=#ACE1AF  }}
{{fb cl2 team|p=2 |t=Hapoel Ramat Gan|w=2 |d=0 |l=1 |gf=6 |ga=6 |bc=#ACE1AF |}}
{{fb cl2 team|p=3 |t=Beitar Tel Aviv Ramla |w=1 |d=0 |l=2 |gf=7 |ga=7 }}
{{fb cl2 team|p=4 |t=Hapoel Petah Tikva|w=0 |d=0 |l=3 |gf=6 |ga=11 }}
{{Fb cl footer |s=[http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?GroupId=3&SEASON_ID=18&LEAGUE_ID=630 football.org.il] {{he icon}} |orfc=1st points; 2nd goal difference; 3rd matches won; 4th goals scored; 5th head-to-head; 6th decision match|u=5 October 2016|season_over=y|date=October 2016}}
{{col-2}}
{{Fb r2 header |nt=4 |[[Beitar Tel Aviv Ramla F.C.|BTR]]|[[Hapoel Bnei Lod F.C.|HBL]]|[[Hapoel Petah Tikva F.C.|HPT]]|[[Hapoel Ramat Gan Givatayim F.C.|HRG]]}}
{{Fb r2 team |t=[[Beitar Tel Aviv Ramla F.C.|Beitar Tel Aviv Ramla]]}}
<!-- Beitar Tel Aviv Ramla --> {{fb r | r=null }}
<!-- Hapoel Bnei Lod --> {{fb r |r=null }}
<!-- Hapoel Petah Tikva  --> {{fb r | gf=5 |ga=3 }}
<!-- Hapoel Ramat Gan --> {{fb r | gf=2 |ga=3 }}

{{Fb r2 team |t=[[Hapoel Bnei Lod F.C.|Hapoel Bnei Lod]]}}
<!-- Beitar Tel Aviv Ramla --> {{fb r |gf=1 |ga=0 }}
<!-- Hapoel Bnei Lod --> {{fb r |r=null }}
<!-- Hapoel Petah Tikva  --> {{fb r |gf=3 |ga=1 }}
<!-- Hapoel Ramat Gan --> {{fb r |r=null }}

{{Fb r2 team |t=[[Hapoel Petah Tikva F.C.|Hapoel Petah Tikva]]}}
<!-- Beitar Tel Aviv Ramla --> {{fb r |r=null }}
<!-- Hapoel Bnei Lod --> {{fb r | r=null }}
<!-- Hapoel Petah Tikva  --> {{fb r |r=null }}
<!-- Hapoel Ramat Gan --> {{fb r | gf= |ga= }}

{{Fb r2 team |t=[[Hapoel Ramat Gan Givatayim F.C.|Hapoel Ramat Gan]]}}
<!-- Beitar Tel Aviv Ramla --> {{fb r |r=null }}
<!-- Hapoel Bnei Lod --> {{fb r | gf=0 |ga=2 }}
<!-- Hapoel Petah Tikva  --> {{fb r |r=null }}
<!-- Hapoel Ramat Gan --> {{fb r |r=null }}
{{Fb r footer |s=[http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?GroupId=3&SEASON_ID=18&LEAGUE_ID=630 football.org.il] {{he icon}}|u=5 October 2016|date=October 2016}}
{{col end}}

===Group D===
{{col-begin}}
{{col-2}}
{{Fb cl header |noqr=y}}
{{fb cl2 team|p=1 |t= Maccabi Sha'arayim|w=2 |d=1 |l=0 |gf=5 |ga=2 |bc=#ACE1AF }}
{{fb cl2 team|p=2 |t= Hapoel Jerusalem |w=1 |d=1 |l=1 |gf=3 |ga=3 |bc=#ACE1AF |}}
{{fb cl2 team|p=3 |t= Hapoel Rishon LeZion|w=0 |d=2 |l=1 |gf=2 |ga=3 }}
{{fb cl2 team|p=4 |t= Hapoel Katamon|w=0 |d=2 |l=1 |gf=4 |ga=6 }}
{{Fb cl footer |s=[http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?GroupId=4&SEASON_ID=18&LEAGUE_ID=630 football.org.il] {{he icon}} |orfc=1st points; 2nd goal difference; 3rd matches won; 4th goals scored; 5th head-to-head; 6th decision match |u=28 August 2016|season_over=n|date=August 2016}}
{{col-2}}
{{Fb r2 header |nt=4 |[[Hapoel Jerusalem F.C.|HJE]]|[[Hapoel Katamon Jerusalem F.C.|HKN]]|[[Hapoel Rishon LeZion F.C.|HRL]]|[[Maccabi Sha'arayim F.C.|MSH]]}}
{{Fb r2 team |t=[[Hapoel Jerusalem F.C.|Hapoel Jerusalem]]}}
<!-- Hapoel Jerusalem --> {{fb r |r=null }}
<!-- Hapoel Katamon --> {{fb r |r=null }}
<!-- Hapoel Rishon LeZion --> {{fb r | gf=1 |ga=0 }}
<!-- Maccabi Sha'arayim --> {{fb r | r=null }}

{{Fb r2 team |t=[[Hapoel Katamon Jerusalem F.C.|Hapoel Katamon Jerusalem]]}}
<!-- Hapoel Jerusalem --> {{fb r | gf=2 |ga=2 }}
<!-- Hapoel Katamon --> {{fb r | r=null }}
<!-- Hapoel Rishon LeZion --> {{fb r | gf=1 |ga=1 }}
<!-- Maccabi Sha'arayim --> {{fb r | r=null }}

{{Fb r2 team |t=[[Hapoel Rishon LeZion F.C.|Hapoel Rishon LeZion]]}}
<!-- Hapoel Jerusalem --> {{fb r |r=null }}
<!-- Hapoel Katamon --> {{fb r | r=null }}
<!-- Hapoel Rishon LeZion --> {{fb r |r=null }}
<!-- Maccabi Sha'arayim --> {{fb r | gf=1 |ga=1 }}

{{Fb r2 team |t=[[Maccabi Sha'arayim F.C.|Maccabi Sha'arayim]]}}
<!-- Hapoel Jerusalem --> {{fb r | gf=1 |ga=0 }}
<!-- Hapoel Katamon --> {{fb r | gf=3 |ga=1 }}
<!-- Hapoel Rishon LeZion --> {{fb r |r=null }}
<!-- Maccabi Sha'arayim --> {{fb r |r=null }}
{{Fb r footer |s=[http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?GroupId=4&SEASON_ID=18&LEAGUE_ID=630 football.org.il] {{he icon}}|u=28 August 2016|date=August 2016}}
{{col end}}

==Knockout Rounds==
===Quarter Finals===
{{football box collapsible
| date = 25 October 2016
| time = 19:00
| team1 = [[Maccabi Ahi Nazareth F.C.|Maccabi Ahi Nazareth]]
| report = [http://eng.football.org.il/TotoCup/Pages/TotoCupGameDetails.aspx?TOTO_CUP_GAME_ID=484213 Report]
| score = 3–1
| team2 = '''[[Hapoel Bnei Lod F.C.|Hapoel Bnei Lod]]'''
| goals1 = [[Ali El-Khatib|A. Khatib]] {{goal|12||90|pen.}} <br> [[Mohammed Khatib|M. Khativ]] {{goal|83}}
| goals2 = {{goal|29}} [[Mustafa Sheikh Yusef|Sheikh Yusef]]
| stadium = [[Ilut Stadium]]
| location = [[Nazareth]]
| attendance = 
| referee = Shilo'ach Aviad Yahav-Hai
| stack = yes
}}
{{football box collapsible
| date = 25 October 2016
| time = 19:00
| team1 = [[Maccabi Sha'arayim F.C.|Maccabi Sha'arayim]]
| report = [http://eng.football.org.il/TotoCup/Pages/TotoCupGameDetails.aspx?TOTO_CUP_GAME_ID=484214 Report]
| score = 2–2
| aet = yes
| team2 = '''[[Hapoel Afula F.C.|Hapoel Afula]]'''
| goals1 = [[Gil Itzhak|Itzhak]] {{goal|62}} <br> [[Eyal Danin|Danin]] {{goal|65}}
| goals2 = {{goal|89}} [[Yuval Shawat|Shawat]] <br> {{goal|90+5}} [[Mohammed Handy|Handy]]
| stadium = [[Ness Ziona Stadium]]
| location = [[Ness Ziona]]
|penaltyscore = 8–7
|penalties1 = 
|penalties2 = 
| attendance = 
| referee = Shalev Sasson
| stack = yes
}}
{{football box collapsible
| date = 26 October 2016
| time = 20:00
| team1 = [[Maccabi Netanya F.C.|Maccabi Netanya]]
| report = [http://eng.football.org.il/TotoCup/Pages/TotoCupGameDetails.aspx?TOTO_CUP_GAME_ID=484212 Report]
| score = 0–1
| team2 = [[Hapoel Ramat HaSharon F.C.|Hapoel Ramat HaSharon]]
| goals1 = 
| goals2 = {{goal|90+4}} [[Or Ostvind|Ostvind]]
| stadium = [[Netanya Stadium]]
| location = [[Netanya]]
| attendance = 
| referee = Na'il Uda
| stack = yes
}}
{{football box collapsible
| date = 25 October 2016
| time = 19:00
| team1 = '''[[Hapoel Jerusalem F.C.|Hapoel Jerusalem]]'''
| report = [http://eng.football.org.il/TotoCup/Pages/TotoCupGameDetails.aspx?TOTO_CUP_GAME_ID=484215 Report]
| score = 1–2
| team2 = [[Hapoel Ramat Gan F.C.|Hapoel Ramat Gan]]
| goals1 = [[Assaf Levy (footballer, born 1991)|A. Levy]] {{goal|18|pen.}} 
| goals2 = {{goal|53|o.g.}} [[Or Lagrisi|Lagrisi]] <br> {{goal|90+1}} [[Or Hasidim|Hasidim]]
| stadium = [[Lod Municipal Stadium|Municipal Stadium]]
| location = [[Lod]]
| attendance = 
| referee = Rifaat al-Hamula
| stack = yes
}}

===Semi Finals===
{{football box collapsible
| date = 8 November 2016
| time = 19:00
| team1 = '''[[Hapoel Ramat HaSharon F.C.|Hapoel Ramat HaSharon]]'''
| report = [http://eng.football.org.il/TotoCup/Pages/TotoCupGameDetails.aspx?TOTO_CUP_GAME_ID=484218 Report]
| score = 1 - 2
| team2 = [[Maccabi Sha'arayim F.C.|Maccabi Sha'arayim]]
| goals1 = [[Or Ostvind|Ostvind]] {{goal|16}}
| goals2 = {{goal|10}} [[Bar Shalom|Shalom]] <br>{{goal|90+4}} [[Gil Itzhak|Itzhak]]
| stadium = [[Lod Municipal Stadium|Municipal Stadium]]
| location = [[Lod]]
| attendance = 
| referee = As'ad Jabarin
| stack = yes
}}
{{football box collapsible
| date = 8 November 2016
| time = 19:00
| team1 = [[Hapoel Ramat Gan F.C.|Hapoel Ramat Gan]]
| report = [http://eng.football.org.il/TotoCup/Pages/TotoCupGameDetails.aspx?TOTO_CUP_GAME_ID=484218 Report]
| score = 0–0
| aet = yes
| team2 = '''[[Maccabi Ahi Nazareth F.C.|Maccabi Ahi Nazareth]]'''
| goals1 = 
| goals2 = 
| stadium = [[Grundman Stadium]]
| location = [[Ramat HaSharon]]
| attendance = 
| referee = David Fuchsmann
| penaltyscore = 7–6
| penalties1 =  [[Liad Berkovic|Berkovic]] {{pengoal}}<br>[[Liran Cohen|Cohen]] {{penmiss}}<br>[[Israel Rosh|Rosh]] {{pengoal}}<br>[[Nir Sharon|Sharon]] {{pengoal}}<br>[[Moti Barshazki|Barshazki]] {{pengoal}}<br>[[David Tiram|Tiram]] {{pengoal}}<br>[[Eldar Pshehazkey|Pshehazkey]] {{pengoal}}<br>[[Or Hasidim|Hasidim]] {{pengoal}}
| penalties2 = {{pengoal}} [[Eyad Hutba|Hutba]]<br>{{penmiss}} [[Anas Dabour|Dabour]]<br>{{pengoal}} [[Ali El-Khatib|A. Khatib]]<br>{{pengoal}} [[Gal Sapir|Sapir]]<br>{{pengoal}} [[Amjad Sliman|Sliman]]<br>{{pengoal}} [[Paty Yeye Lenkebe|Paty]]<br>{{pengoal}}  [[Habeb Jaber|Jaber]]<br>{{penmiss}}  [[Matias Martin|Martin]] 
| stack = yes
}}

==Final==
{{football box collapsible
| date = 30 November 2016
| time = 19:00
| team1 = [[Maccabi Sha'arayim F.C.|Maccabi Sha'arayim]]
| report = [http://eng.football.org.il/TotoCup/Pages/TotoCupGameDetails.aspx?TOTO_CUP_GAME_ID=484219 Report]
| score = 2–1
| aet = yes
| team2 = '''[[Hapoel Ramat Gan F.C.|Hapoel Ramat Gan]]'''
| goals1 = [[Oded Gavish]] {{goal|101}}<br> [[Gil Itzhak]] {{goal|110}}
| goals2 = {{goal|105}} [[David Tiram]]
| stadium = [[Lod Municipal Stadium]]
| location = [[Lod]]
| attendance = 
| referee = Shilo'ach Aviad Yahav-Hai
| stack = yes
}}

==See also==
* [[2016–17 Toto Cup Al]]
* [[2016–17 Liga Leumit]]
* [[2016–17 Israel State Cup]]

==References==
{{Reflist}}

==External links==
* [http://www.football.org.il/TotoCup/Pages/PriemerLeague.aspx?&SEASON_ID=18&LEAGUE_ID=630 Official website] {{he icon}}

{{2016–17 in Israeli football}}
{{Toto Cup}}
{{Football in Israel}}

{{DEFAULTSORT:2016-17 Toto Cup Leumit}}
[[Category:Toto Cup seasons|Leumit]]
[[Category:2016–17 in Israeli football|Toto Cup Leumit]]
[[Category:2016–17 domestic association football cups|Toto Cup Leumit]]

TEXT

$allow_extra_columns = true
begin
  text.gsub!(/(\{\{fb.*)\|\}\}/i, "\\1}}")
  text = parse_sports_table_page(text).strip
rescue Page::NoTemplatesFound => e
  # puts text
  Helper.print_message('Template not found on page')
  exit(1)
# rescue Helper::UnresolvedCase => e
#   Helper.print_message(e)
#   Helper.print_message('Hit an unresolved case')
#   exit(1)
end

puts text
Clipboard.copy(text)