# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'
text = <<~TEXT
 IP | status | requestor | date | Investigator | Contactor | comment 
TEXT

text.strip!
text+='|' unless text.end_with?('|')
text.gsub!(/\s*([\s\w\-]*)\|/, "| \\1 = \\1\n")
puts text
Clipboard.copy(text)
