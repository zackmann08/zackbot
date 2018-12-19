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
| name                 = Castle of Alcanede
| native_name          = Castelo de Alcanede
| other_name           = 
| category             = [[Castle]]
| native_category      = Castelo
<!-- *** Image *** -->
| image                = Castelo de Alcanede 7519.jpg
| image_caption        = A view of the Castle of Alcanede from below
| image_size           = 235
<!-- *** Names **** --> 
| official_name        = Castelo de Alcanede
| etymology            = Alcanede
| etymology_type       = Named for
| nickname             = 
<!-- *** Symbols *** -->
| flag                 = 
| symbol               = 
<!-- *** Country *** -->
| country              = {{flag|Portugal}}
| state_type           = Region
| state                = [[Centro Region, Portugal|Centro]]
| region_type          = Subregion
| region               = [[Lezíria do Tejo]]
| district             = [[Santarém (district)|Santarem]]
| municipality         = [[Santarém, Portugal|Santarém]]
<!-- *** Locations *** -->
| location             = [[Alcanede]]
| elevation            = 
| prominence           = 
| coordinates          = {{coord|39|25|2|N|8|49|17|W|display=inline,title}}
| capital_coordinates  = 
| mouth_coordinates    = 
| length               = 
| length_orientation   = Southwest-Northeast
| width                = 
| width_orientation    = Northwest-Southeast
| height               = 
| depth                = 
| volume               = 
| area                 = 
<!-- *** Features *** -->
| author_type          = Architects
| author               = 
| style                = [[Medieval architecture|Medieval]]
| material             = Masonry
| material1            = Brick
<!-- *** History & management *** -->
| established          = 49 B.C.
| established_type     = Origin
| established1         = 1091
| established1_type    = Initiated
| established2         = 
| established2_type    = Completion
| date                 = 
| date_type            = 
| owner                = [[Portugal|Portuguese Republic]]
<!-- *** Access *** -->
| public               = Public
| visitation           = 
| visitation_date      = 
| access               = ''Estrada Nacional E.N.362'' and ''Estrada Nacional E.N.361'', ''Rua da Encosta do Castelo'', ''Rua da Igreja''
<!-- *** UNESCO etc. *** -->
| whs_name             = 
| whs_year             = 
| whs_number           = 
| whs_region           = 
| whs_criteria         = 
| iucn_category        = 
<!-- *** Free fields *** -->
| free                 = [[IGESPAR|Instituto Gestão do Patrimonio Arquitectónico e Arqueológico]]
| free_type            = Management
| free1                = DGPC (Decreee 115/2012; Diário da República, Série 1, 102, 25 May 2012)
| free1_type           = Operator
| free2                = '''Property of Public Interest'''<br>''Imóvel de Interesse Público''
| free2_type           = Status
| free3                = Decree 32/973; DG, Série 1, 175 (18 August 1943); Special Protection Zone, Dispatch, DG, Série 2, 237 (12 October 1949)
| free3_type           = Listing
<!-- *** Maps *** -->
| map                  = 
| map_caption          = Location of the castle within the municipality of [[Santarém, Portugal|Santarém]]
| map_background       = 
| map_locator          = 
| map_locator_x        = 
| map_locator_y        = 
<!-- *** Website *** --> 
| commons              = Castelo de Alcanede
| website              = 
<!-- *** Footnotes *** -->
| footnotes            =
}}
TEXT

begin
  text = parse_geobox_to_castle(text).strip
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