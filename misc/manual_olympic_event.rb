require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require '../geobox/geobox'
# encoding: utf-8
include Geobox
# \n\| city\d*\s*=\s
# \n\| p\d*\s*=\s
# 
text = <<~TEXT
{{Infobox Olympic Cycling
|year= 2008
|image = [[File:2008 Laoshan Velodrome.JPG|300px]]
|caption = The Laoshan Velodrome
|BMXvenue = [[Laoshan BMX Field]]
|mountainbikevenue = [[Laoshan Mountain Bike Course]]
|roadvenue = [[Urban Road Cycling Course]]
|trackvenue = [[Laoshan Velodrome]]
|dates = 9 August&nbsp;– 23 August
|cyclists= 508
|nations = 66
|NOC1        = GBR
  |gold1       =   8
  |silver1     =   4
  |bronze1     =   2
  |NOC2        = FRA
  |gold2       =   2
  |silver2     =   3
  |bronze2     =   1
  |NOC3        = ESP
  |gold3       =   2
  |silver3     =   1
  |bronze3     =   1
|prev = [[cycling at the 2004 Summer Olympics|2004]]
|next = [[cycling at the 2012 Summer Olympics|2012]]
}}
'''[[Cycling]]''' competitions '''at the [[Beijing]] [[2008 Summer Olympics]]''' were held from August 9 to August 23 at the [[Laoshan Velodrome]] (track events), [[Laoshan Mountain Bike Course]], [[Laoshan BMX Field]] and the [[Beijing Cycling Road Course]]. The event was  dominated by the [[Great Britain at the 2008 Summer Olympics|British team]], who claimed 14 medals in total, including eight golds.<ref name="BBC Cycling">{{cite web
|url=http://news.bbc.co.uk/sport2/hi/olympics/cycling/7534073.stm |title=How GB cycling went from tragic to magic
|date=2008-08-14
|publisher=[[BBC]]
|accessdate=2009-05-07
}}</ref><ref name="Metro Cycling">{{cite web
|url=http://www.metro.co.uk/sport/olympics/article.html?in_article_id=268147&in_page_id=310
|title=How Team GB's weekend of glory happened
|date=2009-08-17
|publisher=[[Metro (Associated Metro Limited)|Metro]]
|accessdate=2009-05-07
}}</ref>

==Events==
Eighteen sets of medals were awarded in four disciplines: [[track cycling]], [[Road bicycle racing|road cycling]], [[Mountain bike racing|mountain bike]], and, new for 2008, [[BMX]].  The following events were contested:

===Track cycling===
{{CyclingAt2008SummerOlympics}}
*[[Team sprint]] men
*[[Sprint (cycling)|Sprint]] men
*[[Keirin]] men
*4000 m [[Team pursuit]] men
*4000 m [[Individual pursuit]] men
*[[Madison (cycling)|Madison]] 50&nbsp;km men
*[[Points race]] 40&nbsp;km men
*Sprint women
*3000 m Individual pursuit women
*Points race 25&nbsp;km women

===Road cycling===
*[[Road bicycle racing|Road bicycle race]] men—239&nbsp;km
*[[Time trial|Road time trial]] men—46.8&nbsp;km
*[[Road bicycle racing|Road bicycle race]] women—120&nbsp;km
*[[Time trial|Road time trial]] women—31.2&nbsp;km

===Mountain bike===
*Mountain bike men
*Mountain bike women

===BMX===
*BMX race men
*BMX race women

==Medal table==
{{Medals table
 | caption        = 
 | host           = 
 | flag_template  = flagIOCteam
 | event          = 2008 Summer
 | team           = 
 | gold_GBR = 8 | silver_GBR = 4 | bronze_GBR = 2
 | gold_FRA = 2 | silver_FRA = 3 | bronze_FRA = 1
 | gold_ESP = 2 | silver_ESP = 1 | bronze_ESP = 1
 | gold_USA = 1 | silver_USA = 1 | bronze_USA = 3
 | gold_SUI = 1 | silver_SUI = 1 | bronze_SUI = 2
 | gold_GER = 1 | silver_GER = 1 | bronze_GER = 1
 | gold_ARG = 1 | silver_ARG = 0 | bronze_ARG = 0
 | gold_LAT = 1 | silver_LAT = 0 | bronze_LAT = 0
 | gold_NED = 1 | silver_NED = 0 | bronze_NED = 0
 | gold_SWE = 0 | silver_SWE = 2 | bronze_SWE = 0
 | gold_NZL = 0 | silver_NZL = 1 | bronze_NZL = 1
 | gold_AUS = 0 | silver_AUS = 1 | bronze_AUS = 0
 | gold_CUB = 0 | silver_CUB = 1 | bronze_CUB = 0
 | gold_DEN = 0 | silver_DEN = 1 | bronze_DEN = 0
 | gold_POL = 0 | silver_POL = 1 | bronze_POL = 0
 | gold_RUS = 0 | silver_RUS = 0 | bronze_RUS = 3
 | gold_CHN = 0 | silver_CHN = 0 | bronze_CHN = 1
 | gold_ITA = 0 | silver_ITA = 0 | bronze_ITA = 1
 | gold_JPN = 0 | silver_JPN = 0 | bronze_JPN = 1
 | gold_UKR = 0 | silver_UKR = 0 | bronze_UKR = 1
}}

==Road cycling==
{| {{MedalistTable|type=Event}}
|-
|Men's road race<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's individual road race}}
|{{flagIOCmedalist|[[Samuel Sánchez]]|ESP|2008 Summer}}
|{{flagIOCmedalist|[[Fabian Cancellara]]|SUI|2008 Summer}}
|{{flagIOCmedalist|[[Alexandr Kolobnev]]|RUS|2008 Summer}}
|-
|Women's road race<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Women's individual road race}}
|{{flagIOCmedalist|[[Nicole Cooke]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Emma Johansson]]|SWE|2008 Summer}}
|{{flagIOCmedalist|[[Tatiana Guderzo]]|ITA|2008 Summer}}
|-
|Men's time trial<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's road time trial}}
|{{flagIOCmedalist|[[Fabian Cancellara]]|SUI|2008 Summer}}
|{{flagIOCmedalist|[[Gustav Larsson]]|SWE|2008 Summer}}
|{{flagIOCmedalist|[[Levi Leipheimer]]|USA|2008 Summer}}
|-
| Women's time trial<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Women's road time trial}}
|{{flagIOCmedalist|[[Kristin Armstrong]]|USA|2008 Summer}}
|{{flagIOCmedalist|[[Emma Pooley]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Karin Thürig]]|SUI|2008 Summer}}
|}

==Track cycling==
===Men===
{| {{MedalistTable|type=Event}}
|-
| Keirin<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's Keirin}}
|{{flagIOCmedalist|[[Chris Hoy]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Ross Edgar]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Kiyofumi Nagai]]|JPN|2008 Summer}}
|-valign="top"
| Madison<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's Madison}}
|{{flagIOCteam|ARG|2008 Summer}}<br/>[[Juan Esteban Curuchet]]<br/>[[Walter Fernando Perez]]
|{{flagIOCteam|ESP|2008 Summer}}<br/>[[Joan Llaneras]]<br/>[[Antonio Tauler]]
|{{flagIOCteam|RUS|2008 Summer}}<br/>[[Mikhail Ignatiev (cyclist)|Mikhail Ignatiev]]<br/>[[Alexei Markov]]
|-
| points race<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's points race}}
|{{flagIOCmedalist|[[Joan Llaneras]]|ESP|2008 Summer}}
|{{flagIOCmedalist|[[Roger Kluge]]|GER|2008 Summer}}
|{{flagIOCmedalist|[[Chris Newton]]|GBR|2008 Summer}}
|-
| individual pursuit<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's individual pursuit}}
|{{flagIOCmedalist|[[Bradley Wiggins]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Hayden Roulston]]|NZL|2008 Summer}}
|{{flagIOCmedalist|[[Steven Burke]]|GBR|2008 Summer}}
|-valign="top"
| team pursuit<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's team pursuit}}
|valign=top|{{flagIOCteam|GBR|2008 Summer}}<br/>[[Ed Clancy]]<br/>[[Paul Manning (cyclist)|Paul Manning]]<br/>[[Geraint Thomas]]<br/>[[Bradley Wiggins]]
|valign=top|{{flagIOCteam|DEN|2008 Summer}}<br/>[[Alex Nicki Rasmussen]]<br/>[[Michael Moerkoev]]<br/>[[Casper Jørgensen]]<br/>[[Jens-Erik Madsen]]<br/>''[[Michael Færk Christensen]]*''
|valign=top|{{flagIOCteam|NZL|2008 Summer}}<br/>[[Sam Bewley]]<br/>[[Jesse Sergent]]<br/>[[Hayden Roulston]]<br/>[[Marc Ryan]]<br/>''[[Westley Gough]]*''
|-
| individual sprint<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's sprint}}
|{{flagIOCmedalist|[[Chris Hoy]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Jason Kenny]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Mickaël Bourgain]]|FRA|2008 Summer}}
|-valign="top"
| team sprint<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's team sprint}}
|{{flagIOCteam|GBR|2008 Summer}}<br/>[[Jamie Staff]]<br/>[[Jason Kenny]]<br/>[[Chris Hoy]]
|{{flagIOCteam|FRA|2008 Summer}}<br/>[[Grégory Baugé]]<br/>[[Kévin Sireau]]<br/>[[Arnaud Tournant]]
|{{flagIOCteam|GER|2008 Summer}}<br/>[[René Enders]]<br/>[[Maximillian Levy]]<br/>[[Stefan Nimke]]
|}

===Women===
{| {{MedalistTable|type=Event}}
|-
| points race<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Women's points race}}
|{{flagIOCmedalist|[[Marianne Vos]]|NED|2008 Summer}}
|{{flagIOCmedalist|[[Yoanka González]]|CUB|2008 Summer}}
|{{flagIOCmedalist|[[Leire Olaberría]]|ESP|2008 Summer}}
|-
| pursuit<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Women's individual pursuit}}
|{{flagIOCmedalist|[[Rebecca Romero]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Wendy Houvenaghel]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Lesya Kalytovska]]|UKR|2008 Summer}}
|-
| sprint<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Women's sprint}}
|{{flagIOCmedalist|[[Victoria Pendleton]]|GBR|2008 Summer}}
|{{flagIOCmedalist|[[Anna Meares]]|AUS|2008 Summer}}
|{{flagIOCmedalist|[[Guo Shuang]]|CHN|2008 Summer}}
|}
<nowiki>*</nowiki> Participate in the preliminary round only.

==Mountain biking==
{| {{MedalistTable|type=Event}}
|-
|Men's <br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's cross-country}}
|{{flagIOCmedalist|[[Julien Absalon]]|FRA|2008 Summer}}
|{{flagIOCmedalist|[[Jean-Christophe Péraud]]|FRA|2008 Summer}}
|{{flagIOCmedalist|[[Nino Schurter]]|SUI|2008 Summer}}
|-
|Women's <br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Women's cross-country}}
|{{flagIOCmedalist|[[Sabine Spitz]]|GER|2008 Summer}}
|{{flagIOCmedalist|[[Maja Włoszczowska]]|POL|2008 Summer}}
|{{flagIOCmedalist|[[Irina Kalentieva]]|RUS|2008 Summer}}
|}

==BMX==
{| {{MedalistTable|type=Event}}
|-
|Men's<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Men's BMX}}
|{{flagIOCmedalist|[[Māris Štrombergs]]|LAT|2008 Summer}}
|{{flagIOCmedalist|[[Mike Day (cyclist)|Mike Day]]|USA|2008 Summer}}
|{{flagIOCmedalist|[[Donny Robinson]]|USA|2008 Summer}}
|-
|Women's<br/>{{DetailsLink|Cycling at the 2008 Summer Olympics – Women's BMX}}
|{{flagIOCmedalist|[[Anne-Caroline Chausson]]|FRA|2008 Summer}}
|{{flagIOCmedalist|[[Laëtitia Le Corguillé]]|FRA|2008 Summer}}
|{{flagIOCmedalist|[[Jill Kintner]]|USA|2008 Summer}}
|}

== Broken records ==
{{see also|World and Olympic records set at the 2008 Summer Olympics}}
{| class="wikitable"
!Event
!Time
!Name
!Nation
!Date
!Record
|-
|Men's [[Sprint (cycling)|Sprint]]
|align=right|9.815&nbsp;
|[[Chris Hoy]]
|{{flagIOCteam|GBR|2008 Summer}}
|2008-08-17 || [[Olympic record progression track cycling – Men's flying 200 m time trial|OR]]
|-
|Men's [[Individual pursuit]]
|align=right|&nbsp;4:15.031&nbsp;
|[[Bradley Wiggins]]
|{{flagIOCteam|GBR|2008 Summer}}
|2008-08-15 || [[Olympic record progression track cycling – Men's individual pursuit|OR]]
|-
|Men's [[Team pursuit]]
|align=right|3:53.312&nbsp;
|[[Bradley Wiggins]]<br/>[[Paul Manning (cyclist)|Paul Manning]]<br/>[[Geraint Thomas]]<br/>[[Ed Clancy]]
|{{flagIOCteam|GBR|2008 Summer}}
|2008-08-18 || [[Olympic record progression track cycling – Men's team pursuit|OR]]
|-
|Women's [[Sprint (cycling)|Sprint]]
|align=right|10.963&nbsp;
|[[Victoria Pendleton]]
|{{flagIOCteam|GBR|2008 Summer}}
|2008-08-17|| [[Olympic record progression track cycling – Women's flying 200 m time trial|OR]]
|}


== Qualification==
{{main|Cycling at the 2008 Summer Olympics - Qualification}}

== See also ==
*[[Cycling at the 2008 Summer Paralympics]]

== References ==
{{Reflist}}

== External links ==
{{Commons category|Cycling at the 2008 Summer Olympics}}
*[https://web.archive.org/web/20060331010211/http://www.beijing2008.com/ Beijing 2008]
*[https://web.archive.org/web/20081112165745/http://www.uci.ch/templates/UCI/UCI5/layout.asp?MenuId=MjI1MA Union Cycliste Internationale]

{{EventsAt2008SummerOlympics}}
{{Cycling at the Summer Olympics}}
{{2008 in road cycling}}

{{DEFAULTSORT:Cycling At The 2008 Summer Olympics}}
[[Category:2008 Summer Olympics events]]
[[Category:Cycling at the Summer Olympics|2008]]
[[Category:2008 in cycle racing|Olympics]]
[[Category:Cycling at the 2008 Summer Olympics| ]]
[[Category:2008 in track cycling]]
[[Category:2008 in road cycling]]
[[Category:2008 in BMX]]
[[Category:2008 in mountain biking]]
[[Category:International cycle races hosted by China]]

TEXT

def parse_venues(params)
  results = [params['BMXvenue'], params['mountainbikevenue'], params['roadvenue'], params['trackvenue']].reject{|val| val.empty?}
  results.join('<br>')
end

def change_template(page)
  page.force_encoding('UTF-8')
  templates = page.scan(/(?=\{\{(?:infobox))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
  raise NoTemplatesFound if templates.empty?
  raise UnresolvedCase if templates.size > 1

  template = templates.first
  old_template = template.dup
  params = Helper.parse_template(template)
  result = "{{Infobox Olympic event
| event       = Cycling
| games       = #{params['year']} Summer
| image       = #{params['image']}
| caption     = #{params['caption']}
| venues      = #{parse_venues(params)}
| date        = #{params['dates']}
| competitors = #{params['cyclists']}
| nations     = #{params['nations']}
| prev        = #{params['prev']}
| next        = #{params['next']}
}}"
  
  result.gsub!('<nowiki>', '')
  result.gsub!('</nowiki>', '')
  # result

  page.sub!(old_template, result)
  page
  
end



begin
  text = change_template(text).strip
rescue Page::NoTemplatesFound => e
  puts text
  Helper.print_message('Template not found on page')
  exit(1)
# rescue Page::UnresolvedCase => e
#   Helper.print_message('Hit an unresolved case')
#   exit(1)
end

puts text
Clipboard.copy(text)