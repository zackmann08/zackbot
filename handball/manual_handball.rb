require '../helper'
require '../handball/handball'
include Handball

text = <<~TEXT
|years = 2001–2003<br>2003–2004<br>2004–2007<br>2007–2009<br>2009–2011<br>2011–2018<br>2018–
|clubs = [[RK Tutunski Kombinat]]<br>[[RK Vardar Skopje|RK Vardar Vatrosalna]]<br>[[RK Metalurg Skopje]]<br>[[Madeira Andebol SAD|Madeira Andebol]]<br>[[RK Tineks Prolet|Tinex Prolet Skopje]]<br>[[HC Odorheiu Secuiesc]]<br>[[RK Eurofarm Rabotnik]]
|youthyears = 1994–2001
|youthclubs = RK Tutunski Kombinat
TEXT
#<br>
PARAMS = %w[title titleyears titleplace manageryears managerclubs youthclubs youthyears nationalyears nationalteam nationalcaps\(goals\) years clubs caps\(goals\)]
PARAMS.each do |param|
  text.gsub!(/\|\s*#{param}\s*\=\s*(\||\}\}|\n)/, '\1')
end

CAPS_GOALS_REGEX = /(\d+).*\((\d*)\)/
YOUTH     = /\|\s*youthyears\s*\=.*\n\|\s*youthclubs\s*\=.*\n/
TITLE     = /\|\s*title\s*\=.*\n\|\s*titleyears\s*\=.*\n\|\s*titleplace\s*\=.*\n/
CLUB      = /\|\s*years\s*\=.*\n\|\s*clubs\s*\=.*\n/
MANAGER   = /\|\s*manageryears\s*\=.*\n\|\s*managerclubs\s*\=.*\n/
NATIONAL  = /(?:\|\s*nationalyears\s*\=.*\n)?\|\s*nationalteam\s*\=.*\n(?:\|\s*nationalcaps\(goals\)\s*\=.*\n)?/

if text.match?(YOUTH)
  text.gsub!(YOUTH, parse_youth_years(text))
end
if text.match?(CLUB)
  puts "C"
  text.gsub!(CLUB, parse_clubs_years(text))
end
if text.match?(NATIONAL)
  puts "N"
  text.gsub!(NATIONAL, parse_national(text))
end
if text.match?(MANAGER)
  puts "M"
  text.gsub!(MANAGER, parse_manager_years(text))
end
if text.match?(TITLE)
  # puts "C"
  text.gsub!(TITLE, parse_title(text))
end
text.strip!
Clipboard.copy(text.encode('utf-8'))
puts text.encode('utf-8')
