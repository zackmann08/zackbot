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
C.D. Primeiro de Agosto (basketball) 2001-2002	2013-05-29	transclusions
C.D. Primeiro de Agosto (basketball) 2012-2013	2013-04-27	transclusions
C.D. Primeiro de Agosto (basketball) 2013-2014	2013-11-17	transclusions
C.D. Primeiro de Agosto (basketball) Women's 2012-2013	2013-06-10	transclusions
C.D. Primeiro de Agosto (basketball) Women's 2013-2014	2013-11-17	transclusions
C.D. Primeiro de Agosto (basketball) Women's 2014-2015	2014-09-10	transclusions
C.D. Primeiro de Agosto (football) 1977	2014-11-24	transclusions
C.D. Primeiro de Agosto (football) 2015	2015-07-12	transclusions
C.D. Primeiro de Agosto (handball) Women's 2011-2012	2013-06-20	transclusions
C.D. Primeiro de Agosto (handball) Women's 2012-2013	2013-06-10	transclusions
C.D. Primeiro de Agosto (handball) Women's 2013-2014	2014-02-27	transclusions
C.D. Primeiro de Agosto (volleyball) 2011-2012	2014-03-16	transclusions
C.D. Primeiro de Agosto (volleyball) Women's 2011-2012	2014-03-16	transclusions
C.D. Primeiro de Agosto 2002 Africa Clubs Champions Cup 1st Place	2013-05-18	transclusions
C.D. Primeiro de Agosto 2012-13
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
