require '../helper'
require '../netball/netball'
include Netball
# encoding: utf-8

# PARAMS = %w[domesticyears domesticteams domesticcaps nationalyears nationalteams nationalcaps coachyears coachteams]
# 
# DOMESTIC  = /(?:\|\s*domesticyears\s*\=.*\n)?\|\s*domesticteams\s*\=.*\n(?:\|\s*domesticcaps\s*\=.*\n)?/
# NATIONAL  = /(?:\|\s*nationalyears\s*\=.*\n)?\|\s*nationalteam\s*\=.*\n(?:\|\s*nationalcaps\s*\=.*\n)?/
# COACH     = /\|\s*coachyears\s*\=.*\n\|\s*coachteams\s*\=.*\n/
# 

text = <<~TEXT
 |clubteam3  = [[Canterbury Flames]]
 |clubapps3  =
 |nationalyears1 = 2001–04
 |nationalteam1  = [[New Zealand national netball team|New Zealand]]
 |nationalcaps1  = 5
 
<!-- Medal record -->
 |medaltemplates =
}}
TEXT
#<br>

# begin
  text = parse_page(text)
# rescue NoMethodError
#   Helper.print_message('NoMethodError')
#   Helper.print_link(title)
#   next
# rescue Netball::LengthsMismatch
#   Helper.print_message('Lengths do not match')
#   Helper.print_link(title)
#   next
# end
text.strip!

text.strip!
Clipboard.copy(text.encode('utf-8'))
puts text.encode('utf-8')
