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
{{Geobox|mountains
| name = Venezuelan Andes
| other_name = Andes Venezolanos
| category = Geographic/Natural Region
| image = Sierra_Nevada_Pico_Bolivar.jpg
| image_caption =  A view of Venezuelan Andes from Tabay
| image_size =250
| country = [[Venezuela]]
| state = [[Táchira]]
| state1 = [[Mérida (state)|Mérida]]
| state2 = [[Trujillo (state)|Trujillo]]
| state3 = [[Lara (state)|Lara]]
| state4 = [[Barinas (state)|Barinas]]
| state5 = [[Apure]]
| state6 = [[Portuguesa (state)|Portuguesa]]
| state7 = [[Zulia]]
| state8 = 
| state9 = 
| state10 = 
| state11 = 
| state12 = 
| region = [[Andes]]
| coordinates = {{coord|8|45|N|70|55|W|display=inline,title}}
| capital_coordinates = 
| mouth_coordinates = 
| highest = Pico Bolívar
| highest_elevation = 4,978 
| lowest = Andean piedmont
| lowest_elevation = 200
| length = 
| width =  
| area = 47,323
| population = 
| population_density = 
| map = RegionNatural Andes.png
| map_caption = Geographic map of the Andean Venezuelan natural region.
| website =
}}

The '''Venezuelan Andes''' ([[Spanish language|Spanish]]: ''Andes Venezolanos'') also simply known as '''the Andes''' ([[Spanish language|Spanish]]: ''Los Andes'') in Venezuela, are a [[mountain system]] that form the northernmost extension of the [[Andes]]. They are fully identified, both by their geological origin as by the components of the relief, the constituent rocks and the geological structure.

The Venezuelan Andean system represents the terminal bifurcation of the [[Cordillera Oriental (Colombia)|Cordillera Oriental de Colombia]], which in Venezuelan territory consists of two mountainous branches: the [[Sierra de Perija]], smaller, slightly displaced from southwest to northeast with 7,500&nbsp;km<sup>2</sup> in Venezuela; and a larger, frankly oriented Southwest to northeast with about 40,000&nbsp;km<sup>2</sup>, the [[Cordillera de Mérida]], commonly known as the proper Venezuelan Andes.<ref name="Geotemas">{{cite book|last1=Vivas|first1=Leonel|title=Geotemas|date=2012|publisher=Fondo Editorial "Simón Rodriguez"|location=San Cristobal, Venezuela|isbn=978-980-6838-57-4|language=Spanish}}</ref> The highest point in [[Venezuela]] is located in this natural region.<ref name=perez>Pérez et al (Sep. 2005): [http://www.scielo.org.ve/scielo.php?script=sci_arttext&pid=S0378-18442005000400005&lng=es&nrm=iso "Alturas del Pico Bolívar y otras cimas andinas venezolanas a partir de observaciones Gps."] INCI v.30, n.4, Caracas sep. 2005. Retrieved 2012-09-27. {{es}}</ref> It covers around 5.2% of the national territory, being the 4th largest natural region in Venezuela.

==Geography==

Venezuelan Andes can be divided in two sections:
*  [[Cordillera de Mérida]]: covering almost all the territory of [[Táchira]], [[Mérida (state)|Mérida]] and [[Trujillo (state)|Trujillo]] states, the southern area of [[Lara (state)|Lara]], and portions of higher areas on the western side of [[Barinas (state)|Barinas]], [[Apure]] and [[Portuguesa (Venezuela)|Portuguesa]] states. It can be divided in three subregions:
# Western Venezuelan Andes ([[Macizo del Tama]], [[Páramos Batallón y La Negra]]).
# Central Venezuelan Andes (Macizo del Sur, [[Sierra Nevada de Mérida]], [[Sierra de La Culata]], [[Sierra de Santo Domingo]]).
# North-Eastern Venezuelan Andes ([[Sierra de Trujillo]], [[Sierra de Portuguesa]], Lara Andes)
*  [[Sierra de Perija]]: located at the western extreme of Venezuela in [[Zulia]] state, bordering [[Colombia]].

==Geology==

They have a common geological origin, which dates back to the [[Eocene]] period of the early [[Tertiary era]], about 40-50 million years ago, coincides with the beginning of the contact of the three [[tectonic plates]] ([[Nazca plate|Nazca]], [[Caribbean plate|Caribbean]] and [[South American plate|South American]]) that began their orographic rise.

Before the rise of the current Venezuelan Andes, between the [[Cambrian]] and [[Silurian]] periods, the so-called ''primitive Andes'' emerged, which already for the [[Triassic period]] ([[Mesozoic Era]]) had been almost completely flattened because of the intense erosive process to which were subjected.<ref name="Vargas-Garcia">{{cite book|last1=Vargas Ponce|first1=José|last2=García|first2=Pablo Emilio|title=Geografía: 9º Educación Básica|publisher=Ed. Romor|isbn=980-6010-67-1|language=Spanish}}</ref>

===Quaternary tectonics===

It's characterized by the interaction of the three most important lithosperic plates in the region: [[Nazca plate|Nazca]], [[Caribbean plate|Caribbean]] and [[South American plate|South American]]. A northwest-southwest oriented direction of compression produces vertical and horizontal deformation components, with the formation of thrusts align the Andean borders, and [[strike-slip faults]]. The split of Venezuelan Andes apparently began in the Late Eocene, an its present height was probably attained before the Quaternary.

During the [[Quaternary]]. the main active structures are the strike-slip faults. the principal one being the [[Boconó Fault]] Zone, with a measured dextral displacement of several millimeters per year. In the field this displacement is shown by the existence of [[fault trenches]], [[fault depressions]], [[sag ponds]], [[offset ridges]] and [[lateral moraines]].<ref name="Schubert-Vivas">{{cite book|last1=Schubert|first1=Carlos|last2=Vivas|first2=Leonel|title=El Cuaternario de la Cordillera de Mérida|date=1993|publisher=Universidad de Los Andes / Fundación Polar|location=Mérida, Venezuela|isbn=980-221-707-7|language=Spanish}}</ref>

===Glacial geology===

Like all tropical mountain ranges with altitudes above 3,000m. The Venezuelan Andes were affected by [[Quaternary glaciation|Pleistocene glaciations]].

====Late Pleistocene Glaciation====

Two morainic complexes have been recognized in the [[Cordillera de Mérida]]: one between 2,600 and 2,800 m altitude, and another one between 2,900 and 3,500 m. These two levels have been considered as Early and Late Stades, respectively, of the [[Mérida Glaciation]]. The moraines of the Late Stade are topographically well represented, and several superposed moraines, or morainic complexes, are found. The glaciated area in Cordillera de Mérida during the [[Last Glacial Maximum]] was approximately 600&nbsp;km<sup>2</sup><ref>{{cite web |author=Schubert, Carlos |title=Glaciers of Venezuela |year=1998 |work=US Geological Survey (USGS P 1386-I) |url=http://pubs.usgs.gov/pp/p1386i/venezuela/text.html}}</ref><ref>{{cite journal |author1=Schubert, C. |author2=Valastro, S. |title=Late Pleistocene glaciation of Páramo de La Culata, north-central Venezuelan Andes |journal=Geologische Rundschau |volume=63 |issue=2 |pages=516–538 |doi=10.1007/BF01820827 |url=http://www.springerlink.com/content/wgu0186p83150562/fulltext.pdf |format=PDF |year=1974}}</ref><ref>{{cite journal |author1=Mahaney, William C. |author2=Milner, M.W., [[Volli Kalm|Kalm, Volli]] |author3=Dirsowzky, Randy W. |author4=Hancock, R.G.V. |author5=Beukens, Roelf P. |title=Evidence for a Younger Dryas glacial advance in the Andes of northwestern Venezuela |journal=Geomorphology |volume=96 |issue=1–2 |pages=199–211 |date=1 April 2008 |doi=10.1016/j.geomorph.2007.08.002 |url=http://www.sciencedirect.com/science/article/pii/S0169555X07003935}}</ref><ref>{{cite web |author1=Maximiliano, B. |author2=Orlando, G. |author3=Juan, C. |author4=Ciro, S. |title=Glacial Quaternary geology of las Gonzales basin, páramo los conejos, Venezuelan andes |url=http://www.cprm.gov.br/33IGC/1349672.html}}</ref>

In the [[Sierra de Perija]], the existence of moraines has been mentioned at altitudes between 2,700 and 3,100 m. In the absecence of more detailed data, these have been tentatively assigned to the Late Stade of the [[Mérida Glaciation]].<ref name="Schubert 1976">{{cite journal|last1=Schubert|first1=Carlos|title=Evidence of former glaciation in the Sierra de Perijá, western Venezuela|date=1976|pages=222–224|jstor=25641752|publisher=Erdkuner}}</ref>

====Late Holocene Glaciation====

Evidence of Late Holocene morainic sedimentation are based on palynological and radiocarbon analyses, which established a cold phase between the 15th and middle-19th centuries, which can be correlate with the [[Little Ice Age]]. The moraines associated with this phase are most probably those located at an altitude of approximately 4,700 m between 100 and 200 below the terminal zone of present-day glaciers.<ref>{{cite journal|last1=Rull|first1=Valentí|last2=Salgado-Labouriau|first2=M.L.|last3=Schubert|first3=Carlos|last4=Valastro|first4=S.|title=Late Holocene temperature depression in the Venezuelan Andes: palynological evidence|journal= 	Palaeogeography, Palaeoclimatology, Palaeoecology|date=1987|volume=60|pages=109–21|doi=10.1016/0031-0182(87)90027-7|url=https://www.researchgate.net/publication/223515775_Late_Holocene_temperature_depression_in_the_Venezuelan_Andes_palynological_evidence|accessdate=14 February 2017}}</ref>

==See also==

{{Empty section|date=September 2017}}

==References==

<references />

{{Natural Regions of Venezuela}}

{{-}}

[[Category:Mountain ranges of the Andes]]
[[Category:Mountain ranges of Venezuela|Andes]]
[[Category:Geographical regions of Venezuela|Andes]]
[[Category:Natural regions of Venezuela|Andes]]
[[Category:Geography of Apure|Andes]]
[[Category:Geography of Táchira|Andes]]
[[Category:Geography of Mérida (state)|Andes]]
[[Category:Geography of Barinas (state)|Andes]]
[[Category:Geography of Trujillo (state)|Andes]]
[[Category:Geography of Portuguesa (state)|Andes]]
[[Category:Geography of Lara (state)|Andes]]
[[Category:Páramos|Andes]]

TEXT

begin
  text = parse_geobox_to_mountain(text).strip
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