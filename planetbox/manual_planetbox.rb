require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'planetbox'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{{Planetbox begin 
| name = 79 Ceti b
}} 
{{Planetbox star
| star = [[79 Ceti]]
| constell = [[Cetus]]
| ra = {{RA|02|35|19.9293}}<ref name="Gaia DR2"/>
| dec = {{DEC|−03|33|38.1707}}<ref name="Gaia DR2"/>
| app_magv = 6.78
| dist_ly = {{val|123.4|0.3}}<ref name="Gaia DR2"/>
| dist_pc = {{val|37.83|0.08}}<ref name="Gaia DR2"/>
| class = G5IV
}}
{{Planetbox orbit 
| semimajor = 0.363±0.021
| eccentricity = 0.252±0.052
| period = 75.523±0.055
| arg_peri = 42±14
| t_peri = 2,450,338.0±3.0
| semi-amp = 11.99±0.87
}} 
{{Planetbox character 
| mass = &gt;0.260±0.028
}} 
{{Planetbox discovery 
| discovery_date = March 29, 2000
| discoverers = [[Geoffrey Marcy|Marcy]] et al.
| discovery_site = Calif., USA
| discovery_method = Doppler Spectroscopy
| discovery_status = Published
}} 
{{Planetbox end}} 

'''79 Ceti b''' (also known as '''''HD 16141 b''''') is an [[extrasolar planet]] orbiting its [[79 Ceti|star]] every 75 [[day]]s.  With [[HD 46375 b]] on March 29, 2000, it was the joint first known extrasolar planet to have [[minimum mass]] less than the mass of [[Saturn]].<ref name="Marcy2000"/>

==See also==
*[[79 Ceti]]
*[[94 Ceti b]]
*[[HD 46375 b]]

==References==
{{Reflist|refs=

<ref name="Gaia DR2">{{Cite Gaia DR2|2495335115182966016}}</ref>

<ref name="Marcy2000">{{cite journal | title=Sub-Saturn Planetary Candidates of HD 16141 and HD 46375 | url=http://iopscience.iop.org/article/10.1086/312723/fulltext/ | last1=Marcy | first1=Geoffrey W. | last2=Butler | first2=R. Paul | last3=Vogt | first3=Steven S. | display-authors=1 | journal=The Astrophysical Journal Letters | volume=536 | issue=1 | pages=L43–L46 | year=2000 | arxiv=astro-ph/0004326 | bibcode=2000ApJ...536L..43M | doi=10.1086/312723 }}</ref>

}}

*{{cite journal | title=Catalog of Nearby Exoplanets | url=http://iopscience.iop.org/article/10.1086/504701/fulltext/ | last1=Butler | first1=J. T. | last2=Wright | first2=R. P. | last3=Marcy | first3=G. W. | last4=Fischer | first4=D. A. | last5=Vogt | first5=S. S. | last6=Tinney | first6=C. G. | last7=Jones | first7=H. R. A. | last8=Carter | first8=B. D. | last9=Johnson | first9=J. A. | display-authors=1 | journal=The Astrophysical Journal | volume=646 | issue=1 | pages=505–522 | year=2006 | arxiv=astro-ph/0607493 | bibcode=2006ApJ...646..505B | doi=10.1086/504701 }}

==External links==
* [http://www.solstation.com/stars2/79ceti.htm '''SolStation''': 79 Ceti]
* [http://exoplanet.eu/star.php?st=HD+16141 '''Extrasolar Planets Encyclopaedia''': HD 16141]

{{Sky|02|35|19.9283|-|03|33|38.167|117.1}}

{{DEFAULTSORT:79 Ceti B}}
[[Category:Exoplanets]]
[[Category:Cetus (constellation)]]
[[Category:Exoplanets discovered in 2000]]
[[Category:Giant planets]]
[[Category:Exoplanets detected by radial velocity]]


{{extrasolar-planet-stub}}

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
# puts "FOO"

puts text
Clipboard.copy(text)