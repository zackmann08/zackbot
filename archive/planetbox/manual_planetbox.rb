require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'planetbox'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{{Planetbox begin
| name=MOA-2007-BLG-197Lb
}}
{{Planetbox star
| star = MOA-2007-BLG-197Lb
| RA = {{RA|18|07|04.729}}
| DEC = {{DEC|–31|56|46.77}}
}}
{{Planetbox character
| mass=41{{±|2|2}} 
}}
{{Planetbox discovery
| discoverers=Ranc ''et al.''
| discovery_date=17 August 2015
| discovery_method=[[Gravitational microlensing]]
| discovery_status=Published
}}
{{Planetbox end}}

TEXT
# <math>\scriptstyle \mathrm{distance\ in\ parsecs}=\frac{1000}{\mathrm{parallax\ in\ milliarcseconds}}</math>
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