# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'

# \|\s*([\w-]*)(\s*)=
# | $1$2= #{params['$1']}


text = <<~TEXT
Periodic table (actinides in the periodic table)	2012-08-31	transclusions
Periodic table (d-block)	2012-05-27	transclusions
Periodic table (eka-superactinides location)	2012-10-23	transclusions
Periodic table (electron configuration lanthanides)	2014-02-20	transclusions
Periodic table (f-block)	2012-05-27	transclusions
Periodic table (metalloid)/Periodic table	2014-03-08	transclusions
Periodic table (metals and nonmetals)/into image	2014-09-18	transclusions
Periodic table (navbox isotopes)	2005-06-13	transclusions
Periodic table (p-block)	2012-05-27	transclusions
Periodic table (p-block trend)	2012-07-01	transclusions
Periodic table (period 5)	2012-08-29	transclusions
Periodic table (period 6)	2012-05-29	transclusions
Periodic table (period 7)	2012-05-29	transclusions
Periodic table (post-transition metals)	2012-06-01	transclusions
Periodic table (s-block)	2012-05-27	transclusions
Periodic table (standard atomic weight)	2012-05-04	transclusions
Periodic table (superactinides)	2012-06-05	transclusions
Periodic table (superactinides location)
TEXT
text += "\n"
result = ''
text.each_line do |line|
  next if line.strip.empty?
  line.gsub!(/\t.*/,'')
  # line.gsub!(/(.*)\n/,"* {{Tfd links|\\1}}\n")
  line.gsub!(/(.*)\n/, "\"\\1\", ")
  result += line
end

puts result
Clipboard.copy(result)
