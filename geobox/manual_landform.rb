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
| name                 = Tidal Pools de Leça da Palmeira
| native_name          = Piscinas de Marés de Leça da Palmeira
| other_name           = 
| category             = Tidal swimming pools
| native_category      = Poços de Maré
<!-- *** Image *** -->
| image                = Swimmingpool on the Beach at Leça da Palmeira by Christian Gänshirt.JPG
| image_caption        = Street level, changing facilities, and beach area of the swimming pool
| image_size           = 235
<!-- *** Names **** --> 
| official_name        = Piscinas de Marés de Leça da Palmeira
| etymology            = Leça da Palmeira
| etymology_type       = Named for
| nickname             = 
<!-- *** Symbols *** -->
| flag                 = 
| symbol               = 
<!-- *** Country *** -->
| country              = {{flag|Portugal}}
| state_type           = Region
| state                = [[Norte, Portugal|Norte]]
| region_type          = Subregion
| region               = [[Grande Porto|Greater Porto]]
| district             = [[Porto (district)|Porto]]
| municipality         = [[Matosinhos]]
<!-- *** Locations *** -->
| location             = [[Matosinhos e Leça da Palmeira]]
| elevation            = 
| prominence           = 
| coordinates          = {{coord|41|11|34|N|8|42|28|W|display=inline,title}}
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
| author_type          = Architect
| author               = Álvaro Siza
| author1              = 
| style                = 
| material             = Jordian marble
| material1            = Reinforced concrete
| material2            = Aluminum
| material3            = Azulejo
| material4            = Wood
| material5            = Polystyrene
| material6            = Ceramics
<!-- *** History & management *** -->
| established          = 
| established_type     = Origin
| established1         = 15 April 2005
| established1_type    = Initiated
| established2         = 
| established2_type    = Completion
| date                 = 
| date_type            = 
| owner                = [[Porto|Câmara Municipal do Porto]]
<!-- *** Access *** -->
| public               = Public
| visitation           = 
| visitation_date      = 
| access               = ''Avenida da Boavista''
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
| free1                = Fundação Casa da Música (Decree 18/2006, 26 January)
| free1_type           = Operator
| free2                = '''National Monument'''<br>''Monumento Nacional''
| free2_type           = Status
| free3                = Decree 16/2011, Diário da República, Série 1, 101 (25 May 2011); Special Protection Zone (ZEP), Dispatch 608/2012, Diário da República, Série, 206 (24 October 2012)<ref>The special protection zone includes, not only the swimming areas, but also the ''Casa de Chá da Boa Nova'' (''Boa Nova Teahouse'')</ref>
| free3_type           = Listing
<!-- *** Maps *** -->
| map                  = 
| map_caption          = Location of the swimming area within the municipality of [[Matosinhos]]
| map_background       = 
| map_locator          = 
| map_locator_x        = 34
| map_locator_y        = 85
<!-- *** Website *** --> 
| commons              = Piscinas de Marés
| website              = 
<!-- *** Footnotes *** -->
| footnotes            =
}}
The '''Tidal pools of Leça da Palmeira''' ({{lang-pt|Poços de Maré de Leça da Palmeira}}) is swimming area on the beach of [[Leça da Palmeira]], along the coast of the [[Freguesia (Portugal)|civil parish]] of [[Matosinhos e Leça da Palmeira]], [[Concelho|municipality]] of [[Matosinhos]], in the [[Portugal|Portuguese]] [[Norte Region, Portugal|northern]] district of [[Porto]]. The structures consist of two [[natural pool]]s filled with fresh sea water, designed and built between 1959 and 1973 by [[Portugal|Portuguese]] architect [[Álvaro Siza Vieira]].<ref>{{citation |first=Kenneth |last=Frampton |title=Álvaro Siza: Complete Works |publisher=Phaidon |year=2000 |isbn=978-0714840048}}</ref> Situated {{convert|1|km|mi}} from the Boa Nova tearoom and restaurant, it is considered one of Siza Vieira early projects.

==History==
[[File:Swimming Pool Piscinas de Marés Leça da Palmeira by Álvaro Siza foto Christian Gänshirt.jpg|thumb|left|235px|Natural pools filled with fresh sea water on the rocky beach]]
[[File:Piscinas Leça da Palmeira Portugal.JPG|thumb|235px|left|View of the changing rooms]]
In 1961, the initial project, which foresaw the construction of a bar along the southern edge of the pool, was never realized.<ref name="SIPA">{{citation|url=http://www.monumentos.pt/Site/APP_PagesUser/SIPA.aspx?id=20880 |title=Piscinas de Marés de Leça da Palmeira (IPA.00020880/PT011308050053) |publisher=SIPA – Sistema de Informação para o Património Arquitectónico |editor=SIPA |location=Lisbon, Portugal |language=Portuguese |first=Patrícia |last=Costa |first2=Ana |last2=Filipe |year=2011 |accessdate=14 April 2017}}</ref> 

The current facility was completed in 1966. To architect Alves Costa, the structure was an attempt at integration at the site, that created an artificial world within the natural landscape, as if the artificial was normal to nature.<ref name=SIPA/>

But, by 2004, the facilities were in a complete state of ruin and abandoned by the local public.<ref name=SIPA/> It was in early 2004 (5 February) that a dispatch was issued to open the process to classify the site.<ref name=SIPA/>

==Architecture==
The facility is situated on the rocky outcrops in a linear form, paralleling the ''Avenida da Liberdade'' and ocean, framed by the landscape.<ref name=SIPA/>

The saltwater pool, has an irregular, rectangular plan, constructed over the outcrops and structured along the linear wall that delimits the beach.<ref name=SIPA/> Access to the structure is conditioned by a route framed by raw cement, along which there are orthogonal and linear views that induce the view to look at focal points of the landscape.<ref name=SIPA/> Below the walls are various support structures.<ref name=SIPA/> 

==References==
===Notes===
{{Reflist|30em}}
===References===
* {{citation |title=Porto 1901-2001: Guia de Arquitectura Moderna |location=Porto, Portugal |year=2001 |language=Portuguese}}
* {{citation |last=Alves |first=Virgínia |contribution=IPPAR rende-se ás obras de Siza |title=Jornal de Noticias |location=Porto, Portugal |year=9 February 2004 |pages=23 |language=Portuguese}}



[[Category:Swimming venues in Portugal]]
[[Category:Matosinhos|Tidal pools Leca Palmeira]]
[[Category:National monuments in Portugal|Tidal pool Leca Palmeira]]
[[Category:Álvaro Siza Vieira buildings]]
[[Category:Modernist architecture in Portugal]]

TEXT

begin
  text = parse_geobox_to_landform(text).strip
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