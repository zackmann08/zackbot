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
{{Geobox|Building
<!-- *** Heading *** -->
| name = Kyiv Pechersk Lavra
| native_name = Києво-Печерська лавра
| category = National Historic-Cultural Sanctuary / Monastery
<!-- *** Image *** -->
| image = Лавра.jpg
| image_caption =View of the Kiev Pechersk Lavra
| image_size =300px
<!-- *** Names **** --> 
| official_name = 
| etymology = Monastery of the caves
| nickname =
<!-- *** Symbols *** -->
| flag = 
| symbol = 
<!-- *** Country *** -->
| country = Ukraine
| state = 
| region_type = Capital city
| region = Kiev
| district = Pechersk Raion
| municipality = [[Legal status and local government of Kiev|Kiev City]]
<!-- *** Family *** -->
| landmark = Great Lavra Belltower
| landmark1 = Gate Church of the Trinity (Pechersk Lavra)
| landmark5 = The All Saints Church
| landmark2 = Church of the Saviour at Berestove
| landmark3 =  Near Caves
| river =Dnieper
| lake =
| mountain =
<!-- *** Locations *** -->
| location = 
| elevation =
| prominence =
| coordinates = {{coord|50|26|3|N|30|33|33|E|display=inline,title}}
| capital_coordinates = 
| mouth_coordinates = 
| length = | length_orientation = 
| width = | width_orientation = 
| height =
| depth = 
| volume =
| area = 235400
<!-- *** Features *** -->
| author =Theodosius of Kiev
| author1 =Anthony of Kiev
| style = Ukrainian Baroque
| material =
<!-- *** History & management *** -->
| established =[[Cave monastery]]
| date =1051
| established1 =State Sanctuary
| date1 ={{Start date|df=yes|1926|9|29}}<ref name="website">{{cite web|url=http://www.kplavra.kiev.ua/cgi-bin/view.cgi?part=info&lg=ua|title=Official website|publisher=|accessdate=23 June 2017|deadurl=yes|archiveurl=https://web.archive.org/web/20110307044308/http://www.kplavra.kiev.ua/cgi-bin/view.cgi?part=info&lg=ua|archivedate=7 March 2011|df=dmy-all}}</ref>
| established2 =Reinstatement of Monastery
| date2 =1988
| government = [[List of historic reserves in Ukraine|Ministry of Culture of Ukraine]]
| management = Ukrainian Orthodox Church (Moscow Patriarchy)
| leader =[[Onufriy (Berezovsky)|Metropolitan Onufriy]] <small>(Monastery)</small>
| leader1 =Marina Hromova <small>(Sanctuary)</small>
<!-- *** Access *** -->
| public =
| visitation = | visitation_date =
| access =
<!-- *** UNESCO etc. *** -->
| whs_name =Kiev: [[Saint Sophia Cathedral in Kiev|Saint Sophia Cathedral]] and Related Monastic Buildings, Kiev Pechersk Lavra
| whs_year =1990
| whs_number =527
| whs_region =4
| whs_criteria =i, ii, iii, iv
| iucn_category =
<!-- *** Free fields *** -->
| free =[[Seven Wonders of Ukraine]]<ref>{{cite web|url=http://7chudes.in.ua/info/177.htm|title=Seven Wonders of Ukraine|publisher=|accessdate=23 June 2017|deadurl=yes|archiveurl=https://web.archive.org/web/20071111150520/http://7chudes.in.ua/info/177.htm|archivedate=11 November 2007|df=dmy-all}}</ref> | free_type = Recognition
<!-- *** Maps *** -->
| map =
| map_caption = 
| map_background = 
| map_locator =
| map_locator_x =
| map_locator_y = 
<!-- *** Website *** --> 
| website =[http://lavra.ua lavra.ua]
<!-- *** Footnotes *** -->
| footnotes =
}}
TEXT

begin
  text = parse_geobox_to_church(text).strip
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