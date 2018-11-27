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
| name= John Brown Bell
| other_name = "The second-most important bell in American history"
| image = John Brown Bell.jpg
| image_caption = The bell on display in Marlborough, Massachusetts
<!-- *** Names **** -->
| etymology =
<!-- *** Country *** -->
| country = United States
| state = Massachusetts
| region =
| district =
| municipality =
<!-- *** Family *** -->
| city = [[Marlborough, Massachusetts|Marlborough]]
}}
The '''John Brown Bell''', in [[Marlborough, Massachusetts]], is a distinguished [[American Civil War]]-era bell that is often known as the "second-most important bell in American history", after the [[Liberty Bell]].<ref name="wickedlocal.com">[http://www.wickedlocal.com/marlborough/homepage/x1625323222/For-whom-should-John-Browns-bell-toll For whom should John Brown's bell toll]</ref>

==History==
At one time the bell was kept in [[Harpers Ferry]], [[West Virginia]], but since 1892 the John Brown Bell has been in Marlborough, Massachusetts, and is currently located in a special tower built for the bell on Union Common in downtown Marlborough.<ref>[http://www.historicmarlborough.org/John_Brown_Bell.html John Brown Bell]</ref>

In 1859, abolitionist [[John Brown (abolitionist)|John Brown]] led a raid on the Harpers Ferry armory, the second armory built in the U.S. Brown had intended to use the bell to alert slaves in the surrounding countryside that the revolt had begun. The raid ended when Marines under the command of Lt. Col. [[Robert E. Lee]] stormed the building. Brown and 10 of his men were later hanged for murder and treason.

Two years later, with the Civil War beginning, a Marlborough unit in the Union Army took the bell from the Harpers Ferry Armory after being ordered to seize anything of value to the U.S. government to prevent it from falling into the hands of Lee's Confederate army.

Knowing their hook and ladder company in Marlborough needed a bell, the soldiers removed the 700 to 800-pound device and got permission from the War Department to keep it.<ref name="wickedlocal.com"/><!-- Deleted image removed: [[Image:JohnBrownBellTower.jpg|right|thumb|250px|The John Brown Bell in its current location in [[Marlborough]], [[Massachusetts]].|{{deletable image-caption|1=Tuesday, 25 August 2009}}]] -->

==Controversy over ownership==
Over the years, citizens of Harpers Ferry have tried in vain to have the bell returned to be exhibited in the John Brown Wax Museum or the reconstructed firehouse where John Brown was captured by Col. Robert E. Lee. "In the past, several mayors have tried to have it returned, but basically it's difficult to do. I suppose it requires a lot of energy that, frankly, no one has," James A. Addy, mayor of the [[Appalachian Mountains|Appalachian]] town of 310 that is about 60 miles from [[Washington, D.C.]], said. "I believe the bell is wired with an alarm, so it can't be surreptitiously taken, like at night."<ref name="thefreelibrary.com">[http://www.thefreelibrary.com/Controversy+clangs+again;+West+Virginia+`a-bell-itionists'+want+John...-a0191821768 Controversy clangs again]</ref> "Oh, they've wanted it back," said Joan Abshire, a member of the Marlborough Historical Society who recently finished a comprehensive study of the bell. "When I went down there (for research), they always said, 'Well, where's the bell?"  The men from Marlborough saved it from obliteration, claimed Gary Brown, chairman of the city's Historical Commission, "Had they not taken the bell, it wouldn't exist. Virtually every bell in the South was melted down for munitions."<ref name="wickedlocal.com"/>

==References==
{{reflist|2}}
{{refbegin}}

==Further reading==
* [http://historicmarlborough.org/John_Brown_Bell.html ''The John Brown Bell: The journey of the second-most important bell in American history, from Harpers Ferry, West Virginia, to Marlborough, Massachusetts''] by Joan Abshire and available through the Marlborough Historical Society.  Published 2008.
* [http://13thmass.org/1861/harpersferry.html 13th Rifle Regiment, Massachusetts Volunteers] 1910 by Lysander Parker, Post 43, [[Grand Army of the Republic|G.A.R.]] Rawlins Building Association, Marlborough, Mass.

[[Category:Individual bells in the United States]]
[[Category:Buildings and structures in Marlborough, Massachusetts]]
[[Category:Harpers Ferry, West Virginia]]

TEXT

begin
  text = parse_geobox_to_building(text).strip
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