# for properly indenting data for a testcase table
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require 'json'
require 'csv'
require './param'

file_name = 'template_data.csv'
params = []
CSV.foreach(file_name, headers: true) do |row|
  params << Param.new(row.to_hash)
   # puts row.to_hash.inspect
end

result = "{
\t\"params\": {"
params.each do |param|
  result +="
\t\t\"#{param.name}\": {
\t\t\t\"label\": \"#{param.label}\",
\t\t\t\"description\": \"#{param.description}\",
\t\t\t\"type\": \"#{param.type}\",
\t\t\t\"example\": \"#{param.example}\",
\t\t\t\"default\": \"#{param.default}\",
\t\t\t\"required\": #{param.required},
\t\t},"
end
result += "	
\t}
}"

result.gsub!(/\t*"\w*\":\s"",\s*\n/, '')
result.gsub!(/\t*"required\":\s,\s*\n/, '')
result.gsub!(/,(\n\s*\})/, '\1')

puts result
# 
# text.strip!
# params = text.split('|')
# params.map!(&:strip)
# pad = params.max_by(&:length).length
# 
# result = params.map{|p| "| #{p.ljust(pad, ' ')} = \n"}
# puts result
# Clipboard.copy(result.join.strip)
