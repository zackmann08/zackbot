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
==Group stage==
The teams were divided into ten groups of four teams each.

===Group 1===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=SUI |t='''[[FC Zürich|Zürich]]''' |w=5 |d=1 |l=0 |gf=14 |ga=5 |wpts=2}}
{{fb cl2 team |p=2 |nat=FRG |t=[[Hertha BSC Berlin|Hertha Berlin]] |w=3 |d=1 |l=2 |gf=10 |ga=7 |wpts=2}}
{{fb cl2 team |p=3 |nat=SWE |t=[[Östers IF|Öster]] |w=2 |d=0 |l=4 |gf=7 |ga=8 |wpts=2}}
{{fb cl2 team |p=4 |nat=AUT |t=[[FC Red Bull Salzburg|Austria Salzburg]] |w=1 |d=0 |l=5 |gf=3 |ga=14 |wpts=2}}
|}

===Group 2===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=FRG |t='''[[Hamburger SV|Hamburg]]''' |w=5 |d=0 |l=1 |gf=14 |ga=6 |wpts=2}}
{{fb cl2 team |p=2 |nat=POR |t=[[Vitória S.C.|Vitória Guimarães]] |w=4 |d=0 |l=2 |gf=15 |ga=8 |wpts=2}}
{{fb cl2 team |p=3 |nat=SWE |t=[[Djurgårdens IF Fotboll|Djurgården]] |w=2 |d=1 |l=3 |gf=9 |ga=14 |wpts=2}}
{{fb cl2 team |p=4 |nat=SUI |t=[[Neuchâtel Xamax]] |w=0 |d=1 |l=5 |gf=7 |ga=17 |wpts=2}}
|}

===Group 3===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=SWE |t='''[[Malmö FF]]''' |w=4 |d=1 |l=1 |gf=12 |ga=7 |wpts=2}}
{{fb cl2 team |p=2 |nat=CSK |t=[[Slavia Prague]] |w=3 |d=0 |l=3 |gf=12 |ga=8 |wpts=2}}
{{fb cl2 team |p=3 |nat=AUT |t=[[FK Austria Wien|Austria Vienna]] |w=2 |d=1 |l=3 |gf=6 |ga=12 |wpts=2}}
{{fb cl2 team |p=4 |nat=FRA |t=[[AS Saint-Étienne|Saint-Étienne]] |w=2 |d=0 |l=4 |gf=6 |ga=9 |wpts=2}}
|}

===Group 4===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=BEL |t='''[[Standard Liège]]''' |w=4 |d=0 |l=2 |gf=13 |ga=7 |wpts=2}}
{{fb cl2 team |p=2 |nat=CSK |t=[[Bohemians 1905|Bohemians Prague]] |w=2 |d=3 |l=1 |gf=10 |ga=8 |wpts=2}}
{{fb cl2 team |p=3 |nat=FRG |t=[[Fortuna Düsseldorf]] |w=2 |d=1 |l=3 |gf=10 |ga=14 |wpts=2}}
{{fb cl2 team |p=4 |nat=DEN |t=[[Kjøbenhavns Boldklub|KB]] |w=1 |d=2 |l=3 |gf=9 |ga=13 |wpts=2}}
|}

===Group 5===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=CSK |t='''[[ŠK Slovan Bratislava|Slovan Bratislava]]''' |w=5 |d=0 |l=1 |gf=9 |ga=1 |wpts=2}}
{{fb cl2 team |p=2 |nat=FRG |t=[[1. FC Kaiserslautern|Kaiserslautern]] |w=2 |d=2 |l=2 |gf=8 |ga=9 |wpts=2}}
{{fb cl2 team |p=3 |nat=SUI |t=[[Grasshopper Club Zürich|Grasshopper]] |w=2 |d=1 |l=3 |gf=9 |ga=12 |wpts=2}}
{{fb cl2 team |p=4 |nat=SWE |t=[[Åtvidabergs FF|Åtvidaberg]] |w=1 |d=1 |l=4 |gf=5 |ga=9 |wpts=2}}
|}

===Group 6===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=CSK |t='''[[FC Spartak Trnava|Spartak Trnava]]''' |w=3 |d=2 |l=1 |gf=7 |ga=5 |wpts=2}}
{{fb cl2 team |p=2 |nat=AUT |t=[[FC Linz|VÖEST Linz]] |w=3 |d=1 |l=2 |gf=13 |ga=7 |wpts=2}}
{{fb cl2 team |p=3 |nat=POL |t=[[Wisła Kraków]] |w=2 |d=3 |l=1 |gf=7 |ga=5 |wpts=2}}
{{fb cl2 team |p=4 |nat=SWE |t=[[AIK Fotboll|AIK]] |w=1 |d=0 |l=5 |gf=5 |ga=15}}
|}

===Group 7===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=FRG |t='''[[MSV Duisburg|Duisburg]]''' |w=4 |d=1 |l=1 |gf=24 |ga=10 |wpts=2}}
{{fb cl2 team |p=2 |nat=POL |t=[[Górnik Zabrze]] |w=2 |d=2 |l=2 |gf=14 |ga=17 |wpts=2}}
{{fb cl2 team |p=3 |nat=SUI |t=[[FC Winterthur|Winterthur]] |w=2 |d=1 |l=3 |gf=11 |ga=15 |wpts=2}}
{{fb cl2 team |p=4 |nat=DEN |t=[[Hvidovre IF|Hvidovre]] |w=1 |d=2 |l=3 |gf=8 |ga=15 |wpts=2}}
|}

===Group 8===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=CSK |t='''[[FC Baník Ostrava|Baník Ostrava]]''' |w=3 |d=3 |l=0 |gf=8 |ga=3 |wpts=2}}
{{fb cl2 team |p=2 |nat=POL |t=[[Legia Warsaw]] |w=3 |d=2 |l=1 |gf=11 |ga=4 |wpts=2}}
{{fb cl2 team |p=3 |nat=DEN |t=[[Vejle Boldklub|Vejle]] |w=1 |d=2 |l=3 |gf=4 |ga=9 |wpts=2}}
{{fb cl2 team |p=4 |nat=SWE |t=[[IFK Norrköping|Norrköping]] |w=1 |d=1 |l=4 |gf=4 |ga=11}}
|}

===Group 9===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=CSK |t='''[[MFK Košice|Košice]]''' |w=4 |d=2 |l=0 |gf=21 |ga=6 |wpts=2}}
{{fb cl2 team |p=2 |nat=POL |t=[[ŁKS Łódź]] |w=2 |d=2 |l=2 |gf=8 |ga=13 |wpts=2}}
{{fb cl2 team |p=3 |nat=DEN |t=[[Randers Sportsklub Freja|Randers Freja]] |w=2 |d=1 |l=3 |gf=12 |ga=11}}
{{fb cl2 team |p=4 |nat=AUT |t=[[SK Sturm Graz|Sturm Graz]] |w=1 |d=1 |l=4 |gf=6 |ga=17 |wpts=2}}
|}

===Group 10===
{{Fb cl header |noqr=y}}
{{fb cl2 team |p=1 |nat=POR |t='''[[G.D. Fabril|CUF]]''' |w=3 |d=2 |l=1 |gf=8 |ga=5 |wpts=2}}
{{fb cl2 team |p=2 |nat=SWE |t=[[Landskrona BoIS|Landskrona]] |w=2 |d=3 |l=1 |gf=9 |ga=5 |wpts=2}}
{{fb cl2 team |p=3 |nat=TUR |t=[[Altay S.K.|Altay]] |w=1 |d=3 |l=2 |gf=6 |ga=9 |wpts=2}}
{{fb cl2 team |p=4 |nat=SWE |t=[[Hammarby IF|Hammarby]] |w=1 |d=2 |l=3 |gf=7 |ga=11 |wpts=2}}
|}

TEXT

# parse_sports_table_page(text)
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