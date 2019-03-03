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
===League table===
{{Fb_cl_header}}
{{Fb cl2 team 2pts |p=1 |t=[[Bootle F.C.|Bootle]]|w=19|d=9 |l=6 |gf=61|ga=35|champion=y|bc=#ACE1AF|promoted=y}}
{{Fb cl3 qr |rows=2|promotion=y|competition=[[1979–80 Cheshire County Football League#Division One|Division One]]}}
{{Fb cl2 team 2pts |p=2 |t=[[Curzon Ashton F.C.|Curzon Ashton]]|w=18|d=9|l=7 |gf=57|ga=32|bc=#ACE1AF|promoted=y}}
{{Fb cl2 team 2pts |p=3 |t=[[Prescot Town F.C.|Prescot Town]]|w=20|d=5|l=9 |gf=68|ga=37|dp=2|pn=1}}
{{Fb cl2 team 2pts |p=4 |t=[[Kirkby Town F.C.|Kirkby Town]]|w=18|d=6|l=10 |gf=66|ga=42}}
{{Fb cl2 team 2pts |p=5 |t=[[Accrington Stanley F.C.|Accrington Stanley]]|w=18|d=6|l=10 |gf=65|ga=43}}
{{Fb cl2 team 2pts |p=6 |t=[[Irlam Town F.C.|Irlam Town]]|w=16|d=10|l=8 |gf=47|ga=33}}
{{Fb cl2 team 2pts |p=7 |t=[[Congleton Town F.C.|Congleton Town]]|w=14|d=13|l=7 |gf=52|ga=31}}
{{Fb cl2 team 2pts |p=8 |t=[[Prescot BI F.C.|Prescot BI]]|w=15|d=11|l=8 |gf=55|ga=42}}
{{Fb cl2 team 2pts |p=9 |t=[[Eastwood Hanley F.C.|Eastwood Hanley]]|w=15|d=9|l=10 |gf=60|ga=47}}
{{Fb cl2 team 2pts |p=10 |t=[[Prestwich Heys F.C.|Prestwich Heys]]|w=17|d=5|l=12 |gf=53|ga=41|dp=2|pn=1}}
{{Fb cl2 team 2pts |p=11 |t=[[Maghull F.C.|Maghull]]|w=11|d=7|l=16 |gf=41|ga=50}}
{{Fb cl2 team 2pts |p=12 |t=[[Ford Motors F.C.|Ford Motors]]|w=9|d=10|l=15 |gf=38|ga=52}}
{{Fb cl2 team 2pts |p=13 |t=[[Anson Villa F.C.|Anson Villa]]|w=10|d=7|l=17 |gf=39|ga=60}}
{{Fb cl2 team 2pts |p=14 |t=[[Warrington Town F.C.|Warrington Town]]|w=11|d=5|l=18 |gf=45|ga=69}}
{{Fb cl2 team 2pts |p=15 |t=[[Atherton Collieries F.C.|Atherton Collieries]]|w=8|d=9|l=17 |gf=43|ga=56}}
{{Fb cl2 team 2pts |p=16 |t=[[Skelmersdale United F.C.|Skelmersdale United]]|w=9|d=6|l=19 |gf=36|ga=53}}
{{Fb cl2 team 2pts |p=17 |t=[[Glossop F.C.|Glossop]]|w=6|d=6|l=22 |gf=42|ga=83}}
{{Fb cl2 team 2pts |p=18 |t=[[Ashton Town F.C.|Ashton Town]]|w=3|d=5|l=26 |gf=22|ga=84}}
{{Fb cl footer|u=|s=[http://www.rsssf.com/tablese/engcheshirehist.html]|date=July 2018
|nt=<sup>1</sup>Prescot Town, Prestwich Heys deducted 2 points - Bootle deducted 4 points
}}
<sup>The points system until the 1990–91 season: 2 points for a win, 1 point for a draw and 0 points for losing.</sup>

TEXT

$allow_extra_columns = true
$allow_manual_checks = true
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