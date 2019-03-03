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
{{Infobox Finnish municipality
|name                   = Helsinki
|official_name          = {{lang|fi|Helsingin kaupunki}}<br/>{{lang|sv|Helsingfors stad}}<br/>City of Helsinki
|native_name            = Helsingfors
|nickname               = Stadi, Hesa<ref name="nickname">{{cite web|url=http://yorkspace.library.yorku.ca/xmlui/handle/10315/2924|title=Place Names in the Construction of Social Identities: The Uses of Names of Helsinki|last=Ainiala|first=Terhi|year=2009|publisher=Research Institute for the Languages of Finland|accessdate=22 September 2011}}</ref>
|settlement_type        = [[Capital city]]
|motto                  =
|image_skyline          = Helsinki montage 2015.jpg
|imagesize              = 300px
|image_caption          = Clockwise from top: [[Helsinki Cathedral]], view of central Helsinki, [[Sanoma]] building and [[Kiasma]], Helsinki city centre at night, beaches at [[Aurinkolahti]], [[Parliament House, Helsinki|Parliament House]] and [[Suomenlinna]].
|image_flag                = <!-- While Helsinki has an official ceremonial flag, it's very rarely used (see e.g. http://www.hel.fi/www/Helsinki/fi/kaupunki-ja-hallinto/tietoa-helsingista/yleistietoa-helsingista/helsingin-tunnukset/ ) -->
|image_shield           = Helsinki.vaakuna.svg
|dot_x                  =
|dot_y                  =
|dot_map_caption        =
|dot_mapsize            =
|image_map = Helsinki uusimaa.png
|map_caption = Location within the [[Uusimaa]] [[Regions of Finland|region]] and the Greater Helsinki [[Sub-regions of Finland|sub-region]]
|mapsize                 = 270px
|pushpin_map = Finland#Europe
|pushpin_map_caption = Location within Finland##Location within Europe
|pushpin_relief         = 1
|region                 = [[File:Uusimaa.vaakuna.svg|15px|link=Uusimaa]] [[Uusimaa]]
|subregion              = [[Greater Helsinki]]
|leader_title           = [[Mayor]]
|leader_name            = [[Jan Vapaavuori]]
|leader_title1          =
|leader_name1           =
|leader_title2          =
|leader_name2           =
|leader_title3          =
|leader_name3           =
|established_title      = [[Charter]]
|established_date       = 1550
|established_title2     = [[Capital city]]
|established_date2      = 1812
|established_title3     =
|established_date3      =

|population_urban = 1231595

|area_urban_km2         = 672.08

|population_density_urban_km2 = auto

|population_metro       = {{#expr: {{Infobox Finnish municipality/population count|Helsinki}} + {{Infobox Finnish municipality/population count|Espoo}} + {{Infobox Finnish municipality/population count|Vantaa}} + {{Infobox Finnish municipality/population count|Kauniainen}} + {{Infobox Finnish municipality/population count|Kirkkonummi}} + {{Infobox Finnish municipality/population count|Vihti}} + {{Infobox Finnish municipality/population count|Nurmijärvi}} + {{Infobox Finnish municipality/population count|Hyvinkää}} + {{Infobox Finnish municipality/population count|Tuusula}} + {{Infobox Finnish municipality/population count|Kerava}} + {{Infobox Finnish municipality/population count|Järvenpää}} + {{Infobox Finnish municipality/population count|Mäntsälä}} + {{Infobox Finnish municipality/population count|Sipoo}} + {{Infobox Finnish municipality/population count|Pornainen}} }}

|area_metro_km2         = {{#expr: {{Infobox Finnish municipality/land area|Helsinki}} + {{Infobox Finnish municipality/land area|Espoo}} + {{Infobox Finnish municipality/land area|Vantaa}} + {{Infobox Finnish municipality/land area|Kauniainen}} + {{Infobox Finnish municipality/land area|Kirkkonummi}} + {{Infobox Finnish municipality/land area|Vihti}} + {{Infobox Finnish municipality/land area|Nurmijärvi}} + {{Infobox Finnish municipality/land area|Hyvinkää}} + {{Infobox Finnish municipality/land area|Tuusula}} + {{Infobox Finnish municipality/land area|Kerava}} + {{Infobox Finnish municipality/land area|Järvenpää}} + {{Infobox Finnish municipality/land area|Mäntsälä}} + {{Infobox Finnish municipality/land area|Sipoo}}  + {{Infobox Finnish municipality/land area|Pornainen}} }}

|population_density_metro_km2 = {{#expr: ({{Infobox Finnish municipality/population count|Helsinki}} + {{Infobox Finnish municipality/population count|Espoo}} + {{Infobox Finnish municipality/population count|Vantaa}} + {{Infobox Finnish municipality/population count|Kauniainen}} + {{Infobox Finnish municipality/population count|Kirkkonummi}} + {{Infobox Finnish municipality/population count|Vihti}} + {{Infobox Finnish municipality/population count|Nurmijärvi}} + {{Infobox Finnish municipality/population count|Hyvinkää}} + {{Infobox Finnish municipality/population count|Tuusula}} + {{Infobox Finnish municipality/population count|Kerava}} + {{Infobox Finnish municipality/population count|Järvenpää}} + {{Infobox Finnish municipality/population count|Mäntsälä}} + {{Infobox Finnish municipality/population count|Sipoo}} + {{Infobox Finnish municipality/population count|Pornainen}}) / ({{Infobox Finnish municipality/land area|Helsinki}} + {{Infobox Finnish municipality/land area|Espoo}} + {{Infobox Finnish municipality/land area|Vantaa}} + {{Infobox Finnish municipality/land area|Kauniainen}} + {{Infobox Finnish municipality/land area|Kirkkonummi}} + {{Infobox Finnish municipality/land area|Vihti}} + {{Infobox Finnish municipality/land area|Nurmijärvi}} + {{Infobox Finnish municipality/land area|Hyvinkää}} + {{Infobox Finnish municipality/land area|Tuusula}} + {{Infobox Finnish municipality/land area|Kerava}} + {{Infobox Finnish municipality/land area|Järvenpää}} + {{Infobox Finnish municipality/land area|Mäntsälä}} + {{Infobox Finnish municipality/land area|Sipoo}}  + {{Infobox Finnish municipality/land area|Pornainen}}) round 1 }}

|population_demonyms    = {{lang|fi|helsinkiläinen}} (Finnish)<br/>{{lang|sv|helsingforsare}} (Swedish)<br>{{lang|en|Helsinkian}} (English)
|finnish_official       = 1
|swedish_official       = 1
|sami_official          =
|coordinates            = {{coord|60|10|15|N|24|56|15|E|display=inline,title}}
|latNS=N
|longEW=E
|elevation_m            =
|postal_code            =
|area_code             = +358-9
|blank1_name             = [[Köppen climate classification|Climate]]
|blank1_info             = [[Humid continental climate#Mild/cool summer subtype|Dfb]]
|website                = [https://www.hel.fi/helsinki/fi www.hel.fi]
|footnotes              =
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