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
| name                 = Roman city of Conímbriga
| native_name          = Cidade Romana de Conímbriga
| other_name           = Ruins of Conímbriga
| other_name1          = 
| category             = [[Ruins]]
| native_category      = Ruinas
<!-- *** Image *** -->
| image                = Conimbriga (13249222603).jpg
| image_caption        = A view of the ruins of the Roman settlement of Conímbriga
| image_size           = 235
<!-- *** Names **** -->
| official_name        = Cidade romana de Conímbriga/Ruínas de Conímbriga
| etymology            = pre-Indo-European meaning ''rocky height or outcrop'' and the [[Celtic languages|Celtic]] ''briga'', signifying a defended place
| etymology_type       = Named for
| nickname             = Conímbriga
<!-- *** Symbols *** -->
| flag                 =
| symbol               =
<!-- *** Country *** -->
| country              = {{flag|Portugal}}
| state_type           = Region
| state                = [[Centro Region, Portugal|Centro]]
| region_type          = Subregion
| region               = [[Baixo Mondego]]
| district             = [[Coimbra (district)|Coimbra]]
| municipality         = [[Condeixa-a-Nova]]
<!-- *** Locations *** -->
| location             = [[Condeixa-a-Velha e Condeixa-a-Nova]]
| elevation            = 
| prominence           =
| coordinates          = {{coord|40|5|58|N|8|29|26|W|display=inline,title}}
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
| author               = <nowiki>unknown</nowiki>
| style                = [[Roman architecture|Roman]]
| material             = Granite
<!-- *** History & management *** -->
| established          = 1st century
| established_type     = Origin
| established1         = 
| established1_type    = Initiated
| established2         = 
| established2_type    = Completion
| owner                = Portuguese Republic
<!-- *** Access *** -->
| public               = Public
| visitation           = 
| visitation_date      = 
| access               = Ramal da EN342, near the village of Condeixa-a-Velha
<!-- *** UNESCO etc. *** -->
| whs_name             = 
| whs_year             = 
| whs_number           = 
| whs_region           = 
| whs_criteria         = 
| iucn_category        = 
<!-- *** Free fields *** -->
| free                 = [[IGESPAR|Instituto de Gestão do Património Arquitectónico e Arqueológico]]
| free_type            = Management
| free1                = 
| free1_type           = Operator
| free2                = 
| free2_type           = 
| free3                = 
| free3_type           = 
| free4                = '''[[National Monuments of Portugal|National Monument]]'''
| free4_type           = Status
| free5                = Decree 16 June 1910; DG136, 23 June 1910; ZEP Dispatch, DG, Série II, 277 (25 November 1971)
Grau
| free5_type           = Listing
<!-- *** Maps *** -->
| map                  = 
| map_caption          = Location of the archaeological site in the municipality of [[Condeixa-a-Nova]]
| map_size             = 235
| map_background       =
| map_locator          =
| map_locator_x        = 
| map_locator_y        = 
<!-- *** Website *** -->
| commons              = Museu Monográfico de Conímbriga
| website              = 
<!-- *** Footnotes *** -->
| footnotes            =
}}
'''Conímbriga''' is one of the largest [[Roman Empire|Roman]] settlements excavated in [[Portugal]], and was classified as a [[Monuments of Portugal|National Monument]] in 1910. Located in the [[Freguesia (Portugal)|civil parish]] of Condeixa-a-Velha e Condeixa-a-Nova, in the [[Concelho|municipality]] of [[Condeixa-a-Nova]], it is situated {{convert|2|km|mi}} from the municipal seat and {{convert|16|km|mi}} from [[Coimbra]] (the Roman town of ''[[Aeminium]]'').

Conímbriga is a walled urban settlement, encircled by a curtain of stone structures approximately {{convert|1500|m|ft}} long. Entrance to the settlement is made from vaulted structures consisting of two doors (one on hinges), and at one time was defended by two towers. The walls are paralleled by two passages, channelled to excavations, in order to remove water infiltration from the walls. The urban settlement consists of various structures such as a forum, basilica and commercial shops, thermal spas, aqueducts, insulae, homes of various heights (including interior patios) and [[domus]] (such as the ''Casa dos Repuxos'' and ''Casa de Cantaber''), in addition to paleo-Christian basilica.

A visitors' centre (which includes restaurant/café and gift-shop) was constructed to display objects found by archaeologists during their excavations, including coins, surgical tools, utensils and ceramics.

==History==
[[File:20110908 P1080780 Museo Conimbriga.jpg|235px|left|thumb|Votive and ceremonial structures]] 
[[File:Conimbriga (13248873023).jpg|235px|left|thumb|A maquette of the conceived layout of the forum at Conímbriga]]
[[File:Conimbriga casa dos repuxos (3).JPG|thumb|left|235px|The interior of the ''Casa dos Repuxos.'']]
[[File:Conimbriga (13248745525).jpg|thumb|left|235px|A view of the Monographic Museum at Conímbriga.]]

Like many archaeological sites, Conímbriga was evolved sequentially and built up by successive layers, with the primary period of occupation beginning in the 9th century; during this period the area was occupied by a [[Castro culture]].<ref name="SIPA">{{citation|url=http://www.monumentos.pt/Site/APP_PagesUser/SIPA.aspx?id=2710 |title=Cidade romana de Conímbriga/Ruínas de Conímbriga  (IPA.00002710/PT020604050001) |publisher=SIPA – Sistema de Informação para o Património Arquitectónico |location=Lisbon, Portugal |language=Portuguese |first=João |last=Cravo |first2=Horácio |last2=Bonifácio |first3=Carlos |last3=Amaral |year=2005 |accessdate=19 April 2015}}</ref><ref>{{cite web|url=http://www.conimbriga.pt/portugues/ruinas.html |title=Conimbriga - Ruínas, Museu monográfico |year=2000 |accessdate=2011-10-28 |publisher=Museu Monográfico de Conimbriga/IPM |language=Portuguese |location=Coimbra, Portugal}}</ref> Before the Roman occupation, the [[Conii]] peoples (who would later settle in southern Portugal) occupied the settlement.<ref name=SIPA/> The Conímbriga designation came from ''conim'', used by pre-European indigenous to designate ''the place of rocky eminence'', and ''briga'', the Celtic suffix meaning "citadel".<ref name=SIPA/> This site had become a junction between the road that linked [[Olisipo]] to [[Bracara Augusta]], by way of [[Aeminium]] (Coimbra).<ref name=SIPA/>

Around 139 BC, Romans began arriving in the area, as a consequence of the expeditionary campaigns of Decimus Junius Brutus.<ref name=SIPA/><ref name="IGESPAR">{{citation |url=http://www.patrimoniocultural.pt/pt/patrimonio/patrimonio-imovel/pesquisa-do-patrimonio/classificado-ou-em-vias-de-classificacao/geral/view/70107/ |title=Ruínas de Conímbriga |publisher=Direção-Geral de Património Cultural |editor=GIF/IPPAR |location=Lisbon, Portugal |language=Portuguese |first=A. |last=Martins |accessdate=19 April 2015 |date=28 February 2005}}</ref> At the time, Conímbriga was already a built-up settlement. The Romans introduced the formal organization of space to the settlement. Owing to the peaceful nature of rural Lusitania, [[Romanization (cultural)|Romanisation]] of the indigenous population was quick and Conímbriga, inevitably, became a prosperous town.<ref name=SIPA/><ref name=IGESPAR/>

Between 69 and 79 AD, during the reign of Vespasian, Conímbriga was elevated to the status of ''[[municipium]]''.<ref name=SIPA/><ref name=IGESPAR/> At that time, new urban programs were initiated. Judging by the capacity of the amphitheatre, by this time, the city had an estimated population of approximately 10600.<ref name=SIPA/><ref>Jorge Alarcão (1999), p.95</ref> Many of the new colonists came from the Italian peninsula (like the [[Lucanus (disambiguation)|Lucanus]], [[Murrius]], [[Vitellius]] and [[Aponia]] families) and intermarried with local inhabitants (such as the [[Turrania]], [[Valeria (disambiguation)|Valeria]], [[Alios]] and [[Maelo]] families).

Construction of the ''Casa dos Repuxos'' began in the 2nd century, likely over a pre-existing structure.<ref name=SIPA/> At the end of the 3rd century, the Augustian walls were replaced by the existing structures.<ref name=SIPA/><ref name=IGESPAR/> In addition there was a remodelling of the baths and construction of a majority of the larger homes of the town, leading to the construction of the paleo-Christian basilica in the 4th century.<ref name=SIPA/>

Between 465 and 468, invasions by [[Sueves]] caused the destruction of the city, and its inhabitants dispersed, some into slavery.<ref name=SIPA/>

The bishopric of Conímbriga was established between 561 and 572, under the direction of Lucêncio, its first bishop. By 589, Conímbriga ceased to be the episcopal seat, and was transferred to [[Aeminium]], which later became Coimbra.<ref name=SIPA/>

===Kingdom===
During the reign of King [[Manuel I of Portugal|Manuel]] (1519), the king ordered the inscriptions on the facade of the Church of Condeixa-a-Nova.<ref name=SIPA/>

In the 18th century, Conímbriga was first referred to in parochial documents, resulting in the 1869 visit by Hubner to the site. In 1873, the ''Instituto de Coimbra'' (''Coimbra Institute'') was created, in addition to the formation of a museum dedicated to archaeology, instigating the first formal excavations at Conímbriga in 1873.<ref name=SIPA/> Mosaics were removed from the uncovered homes and the first excavations were made in 1899, resulting in the plan for the oppidum.<ref name=SIPA/>

===Republic===
In 1911, the Coimbra Institute ceded its collection to the Museum Machado de Castro, resulting in the beginnings of the studies by Augusto Filipe Simões and António Augusto Gonçalves.<ref name=SIPA/>

On the occasion of the 11th International Congress on Archaeology and Pre-History (1930) in Portugal, the state acquired the first lands and official excavations on the site.<ref name=SIPA/> At the time of this congress the eastern gates to the city were unobstructed. The following year the DGEMN started the work of reconstructing and consolidating the ruins, which were continued in 1955.<ref name=SIPA/>

In 1956, there were archaeological studies of ''Oppidum Romano'', by the ''Serviços dos Monumentos Nacionais'' (''National Monument Service''). New excavations occurred in 1964.<ref name=SIPA/>

In 1962, the ''Museu Monográfico de Conímbriga'' (''Conímbriga Monographic Museum'') was inaugurated. It was followed in 1964 by the collaboration between this museum and the archaeological mission from the [[University of Bordeaux]]: under the direction of J. Bairrão Oleiro, Robert Étienne and Jorge de Alarcão, the centre of the Roman city was unearthed.<ref name=SIPA/>

In 1970, the work with the mosaics was consolidated, at a time when the monograph museum was expanded (with a basement, installations for a guard and interior shelter).<ref name=SIPA/> But, throughout the transition to Portuguese democracy and beyond, the team at Conímbriga attempted to consolidate and maintain the site.<ref name=SIPA/> The early work continued into 1974, with the consolidation, restoration and expansion of the museum and 1975, with the prospecting into other zones, the paving of walkways, landscaping and solutions to drainage issues. In 1976, the gazebo and interior of the older Monographic Museum was repaired.<ref name=SIPA/> These repairs continued into 1977, with expansion of the museum, restoration of the facades, the old portico and the colonnade was transformed into an internal gallery, the arrangement of the principal atrium and creating a gutters to alleviate pedestrian walkways.<ref name=SIPA/> The following year began the construction of a ticket booth in cement and glass, while in 1979 an electrical transformer and litter incineration unit was installed. The installation of electrical devices, illumination and climate control units in the museum only occurred between 1981 and 1982.<ref name=SIPA/> In 1986 a new awning was installed to cover the ''Casa dos Repuxos''.<ref name=SIPA/>

The first permanent public exposition was opened in April 1985.<ref name=SIPA/>

During the 1990s, there were projects to remodel the museum and upgrade the displays and various installations to support visitors, under the direction of Cruz Alarcão, Arquitectos Lda.<ref name=SIPA/> They were re-contracted between 2004-2005 to improve the site, including the reconstruction of the Augustian forum and southern thermal spas, construction of a small structure for spectacles (consisting of a roadway, stage and bunks molded to the terrain), alongside the aqueduct.<ref name=SIPA/>

On 9 August 1991, the museum became part of the ''Instituto Português de Museus'' (''Portuguese Institute for Museums''), leading to the 1 June 1992 transfer to the ''Instituto Português do Património Arquitetónico'' (IPPAR), and then on 29 March 2007, the ''Instituto dos Museus e Conservação'' (''Institute for Museums and Conservation'').<ref name=SIPA/>

==Architecture==
[[File:Conimbriga (13248964953).jpg|thumb|235px|Sections of a residential domus with water gardens.]]
[[File:Conimbriga (13249007765).jpg|thumb|235px|An arched section of the aqueduct in one of the alleyways.]]
[[File:Conimbriga (13249190094).jpg|thumb|235px|The "skeleton" of the thermal baths.]]
[[File:Conimbriga (13248781615).jpg|thumb|235px|The exposed ruins and the gazebo protecting the ''Casa dos Repuxos.'']]

The excavation site and visitors' centre is located on the outskirts of the rural community of [[Condeixa-a-Nova]], based on a plateau-shaped triangular spur over two deep depressions (one occupied by the Ribeira dos Mouros).<ref name=SIPA/><ref name=IGESPAR/>

Although Conimbriga was not the largest [[Roman cities in Portugal|Roman city in Portugal]], it is the best preserved, with archaeologists estimating that only 10 percent of the city has been excavated.<ref name=SIPA/>

The urbanized civitas includes integrated structures starting from the Iron Age and extending to the 5th century. There were specifically three phases of spatial organization: in the 1st century BC, under the reign of Augustus, a late republican forum (that included crypto-portico, basilica, curia and commercial shops), thermal baths, an aqueduct and the first residential pre-Roman architectural structures;  a 1st-century AD group, established under Flavius, that included a reconstructed imperial forum, Vitruvian baths and revised urban plan; and a 3rd-century settlement that fell within revised walls.<ref name=SIPA/><ref name=IGESPAR/>

The civil/residential buildings included numerous examples of remodeled and reused structures dating from the first century BC. Most of these homes were insulae (houses with more than one floor), with open patio/courtyards and domus with peristyle (such as the ''Casa dos Repuxos'' and ''Casa de Cantaber'').<ref name=SIPA/> Most of the private/civil architecture and public buildings included abundant decorative materials, including mosaics, sculptures and painted murals.<ref name=SIPA/>

Of the Suebic occupation, there is a paleo-Christian basilica (5th-6th century), which was a reused and transformed domus.<ref name=SIPA/> The robust, rustic {{convert|1500|m|ft}} walls imply an urgency in its construction.<ref name=IGESPAR/> It was built using large, carved, irregular blocks, with most coming from other constructions. The height of the walls vary from {{convert|5|m|ft}} to {{convert|6.5|m|ft}}, suggesting the significance of its military feasibility.<ref name=SIPA/>

There are three distinct baths within the walls: the Great Southern Baths, the Baths of the Wall, and the Baths of the Aqueduct.<ref name=SIPA/> The network of stone heating ducts under the (now-missing) floors are the most distinct structures in the Roman baths.<ref name=SIPA/>

The amphitheatre, dating from the end of the [[Julio-Claudian dynasty]], takes advantage of a natural depression that surrounded the city to the north.<ref name=SIPA/> The first was identified in 1993 by Virgílio H. Correia, and excavations began in 2012-2013. Part of the amphitheatre was located below local homes in Condeixa-a-Nova, consisting of three entranceways to the Roman structure.<ref>{{cite web |url=https://sicnoticias.sapo.pt/vida/2011/11/06/escavacoes-em-conimbriga-vao-por-a-descoberto-anfiteatro-romano-unico-no-pais |title=Escavações em Conimbriga vão pôr a descoberto anfiteatro romano único no país |publisher=SIC Noticias |location=Lisbon, Portugal |language=Portuguese |deadurl=yes |archiveurl=https://web.archive.org/web/20111109105807/http://sicnoticias.sapo.pt/vida/2011/11/06/escavacoes-em-conimbriga-vao-por-a-descoberto-anfiteatro-romano-unico-no-pais |archivedate=2011-11-09 |df= }}</ref> The 5000-capacity monument was {{convert|90|x|60|x|20|m|ft}}, and {{convert|4|m|ft}} underground, with some rural homes built using part of the structure.

The Luso-French mission (1965-1968) unearthed public structures of great dimensions, whose architecture was reconstructed. This included two phases, where the first structures can not be reconstructed with certainty.<ref name=SIPA/> These [[Flavian dynasty|Flavian]] monuments coincide with the location of some important elements, such as the central square.

==See also==
* [[Aeminium]]
* [[Lusitania]]

==References==
===Notes===
{{Reflist|30em}}

===Sources===
* {{citation |first=Jorge |last=Alarcão |year=1999 |title=Conímbriga - O Chão Escutado |location=Mem Martins, Portugal |publisher=Edicarte, Edições e Comércio de Arte, Lda. |pages=95 |language=Portuguese}}
* {{citation |title=Instituto Português dos Museus, Roteiros da Arqueologia Portuguesa, Ruínas de Conimbriga |location=Condeixa-a-Nova, Portugal |year=1995 |language=Portuguese}}
* {{citation |publisher=Ministério das Obras Públicas |title=Relatório da Actividade do Ministério no Triénio de 1947 a 1949 |location=Lisbon, Portugal |year=1950 |language=Portuguese}}
* {{citation |publisher=Ministério das Obras Públicas |title=Relatório da Actividade do Ministério no Triénio de 1955 |location=Lisbon, Portugal |year=1956 |language=Portuguese}}
* {{citation |publisher=Ministério das Obras Públicas |title=Relatório da Actividade do Ministério no Triénio de 1956 |location=Lisbon, Portugal |year=1957 |language=Portuguese}}
* {{citation |contribution=Oppidum romano de Conimbriga |title=Boletim da Direcção-Geral dos Edifícios e Monumentos Nacionais |issue=52-53 |location=Lisbon, Portugal |year=1948 |language=Portuguese}}
* {{citation |contribution=Ruínas de Conimbriga: consolidação de mosaicos |title=Boletim da Direcção-Geral dos Edifícios e Monumentos Nacionais |issue=116 |location=Lisbon, Portugal |year=1964}}

== External links ==
* [http://www.conimbriga.pt/index_en.html Conímbriga]
* [http://www.ez-team.com/turismo/conimbriga/ Multimedia gallery of Conímbriga Museum]
* [https://web.archive.org/web/20070925123122/http://lsm.dei.uc.pt/forum/ Flavian Forum of Conímbriga]
* [http://italicaromana.blogspot.com/ Italica Romana - Reconstructions of Conímbriga]
* [https://conimbriga.academia.edu/VirgilioHipolitoCorreia/Papers/450385/O_forum_de_Conimbriga_e_a_evolucao_do_centro_urbano O forum de Conimbriga e a evolução do centro urbano]
* [http://ww2.estg.ipleiria.pt/~alex/forum/ The Flavian Forum of Conimbriga in VRML]

{{DEFAULTSORT:Conimbriga}}
[[Category:History of Coimbra]]
[[Category:Destroyed cities]]
[[Category:Former populated places in Portugal]]
[[Category:Roman sites in Portugal]]
[[Category:Roman towns and cities in Portugal]]
[[Category:Ruins in Portugal]]
[[Category:Museums in Coimbra District]]
[[Category:Archaeological museums in Portugal]]
[[Category:Museums of ancient Rome]]

TEXT

begin
  text = parse_geobox_to_ancient_site(text).strip
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