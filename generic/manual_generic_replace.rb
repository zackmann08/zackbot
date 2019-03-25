require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'generic'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{{Infobox South African town 2011
|name = Cape Town
|native_name = {{lang|af|Kaapstad}} {{af icon}}<br /> {{lang|xh|iKapa}} {{xh icon}}
|nicknames = Mother City, Tavern of the Seas, West side
|motto = ''Spes Bona'' ([[Latin]] for "Good Hope")
|image_skyline = Cape Town Montage 2015.png
|imagesize = 295px 
|image_caption = Clockwise from top: Cape Town CBD, [[Strand, Western Cape|Strand]], [[Clifton, Cape Town|Clifton beach]], [[Table Mountain]], [[Port of Cape Town]], [[Cape Town City Hall]]
|image_flag = City of Cape Town CoA.png
|image_shield = Cape_Town_Coat_of_Arms.png
|coordinates   = {{coord|33|55|31|S|18|25|26|E|region:ZA-WC_type:city(4000000)|display=inline,title}}
|coor_pinpoint = [[Cape Town City Hall|City Hall]]
|province  = Western Cape
|district  =
|municipality = City of Cape Town
|established_title = Founded
|established_date = 1652
|established_title1 = Municipal government
|established_date1 = 1839
|government_footnotes = <ref name="news24.com">{{cite news |date=26 April 2018 |title=
City of Cape Town announces new city manager |url=https://www.news24.com/SouthAfrica/News/city-of-cape-town-announces-new-city-manager-20180426 |publisher=News24 |accessdate=5 February 2019}}</ref>
|government_type = [[Metropolitan municipality (South Africa)|Metropolitan municipality]]
|leader_party1 = [[Democratic Alliance (South Africa)|DA]]
|leader_title1 = [[Mayor of Cape Town|Mayor]]
|leader_name1 = [[Dan Plato]] ([[Democratic Alliance (South Africa)|DA]])
|leader_party2 = [[Democratic Alliance (South Africa)|DA]]
|leader_title2 = [[Deputy Mayor of Cape Town|Deputy Mayor]]
|leader_name2 = [[Ian Neilson]] ([[Democratic Alliance (South Africa)|DA]])
|leader_title3= [[Council]]
|leader_name3 = [[Cape Town City Council]]
|leader_title4 = [[City manager]]
|leader_name4 =[[City of Cape Town|Lungelo Mbandazayo]]
|area_footnotes = <!-- ignored by the template when censuscode is provided -->
|area_metro_km2 = 2461
|elevation_max_m = 1590.4
|elevation_min_m = 0
|elevation_m  =
|population_as_of = 
|population_footnotes = 
|population_metro_footnotes = <ref name="metro">{{cite web|title=City of Cape Town Metropolitan Municipality|url=http://www.statssa.gov.za/?page_id=6283|accessdate=22 December 2018}}</ref>
|population_density_total_km2 = 1083
|population_metro = 4005015
|population_density_metro_km2 = 1637
|population_demonym = Capetonian
<!-- demographics (section 1) -->
|demographics1_footnotes = <ref>{{cite web|title=City of Cape Town|url=https://wazimap.co.za/profiles/municipality-CPT-city-of-cape-town/#citations|accessdate=22 December 2018}}</ref><ref>{{cite web|title=2016 Community Survey|url=https://www.capetown.gov.za/en/stats/Pages/Census2011.aspx|accessdate=19 February 2016|deadurl=yes|archiveurl=https://web.archive.org/web/20130720225750/http://www.capetown.gov.za/en/stats/Pages/Census2011.aspx|archivedate=20 July 2013|df=dmy-all}}</ref>

<!-- demographics (section 2) NB these demographics values are ignored: Template:Infobox South African town 2011 shows stuff direct from the census (of Cape Town main place, not he municipality). -->
|demographics2_footnotes = <ref>{{cite web|title=City of Cape Town|url=http://www.statssa.gov.za/?page_id=1021&id=city-of-cape-town-municipality|accessdate=19 February 2016}}</ref>
|demographics2_title1 = [[Afrikaans]]
|demographics2_info1 = 60.81% type anything here, it's overridden by the template!
|demographics2_title2 = 3 [[Xhosa language|Xhosa]]
|demographics2_info2 = 29.2%
|demographics2_title3 = [[South African English|English]]
|demographics2_info3 = 27.8%
|demographics2_title4 = Other
|demographics2_info4 = 8.1%
|postal_code = 7400 to 8099
|area_code = +27 (0)21
|censuscode = 199041<!--
|blank_name_sec1 = [[Human Development Index|HDI]]
|blank_info_sec1 = {{increase}} 0.764 <span style="color:#1fca23">'''High'''</span> <small>(2017)</small>-->
|blank_name_sec2 = GDP
|blank_info_sec2 = [[American dollar|US$]]78.7&nbsp;billion<ref name="brookingsgdp">{{cite web|url=http://www.brookings.edu/research/interactives/global-metro-monitor-3 |title=Global city GDP 2011 |publisher=Brookings Institution |accessdate=18 November 2014 |deadurl=yes |archiveurl=https://www.webcitation.org/6H7Jql2A9?url=http://www.brookings.edu/research/interactives/global-metro-monitor-3 |archivedate=4 June 2013 |df=dmy }}</ref>
|blank1_name_sec2 = GDP per capita
|blank1_info_sec2 = US$19,656<ref name="brookingsgdp"/>
|website = {{URL|www.capetown.gov.za}}
|footnotes =
}}
TEXT

begin
  text = parse_text(text).strip
rescue Page::NoTemplatesFound => e
  puts text
  Helper.print_message('Template not found on page')
  exit(1)
# rescue Page::UnresolvedCase => e
#   Helper.print_message(e)
#   Helper.print_message('Hit an unresolved case')
#   exit(1)
end

puts text
Clipboard.copy(text)