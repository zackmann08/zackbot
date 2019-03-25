require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'

Helper.read_env_vars

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=7866572&format=json'


text = <<~TEXT
*{{tfdl|ICC_Team_of_the_Year|2019 March 14|section=Template:ICC Team of the Year}}
TEXT


Template = Struct.new(:name, :regex, :tfd)
templates = []

PARTS_REGEX=/\*\s*\{\{tfdl\|([\w\s_'\-\–\/]*)\|([\w\s]*)\|section=([\w\s':]*)\}\}/i
text.each_line do |line|
  matches = line.match(PARTS_REGEX)
  templates << Template.new("Template:#{matches[1].gsub('_', ' ')}", matches[1].gsub('_', ' '), "Wikipedia:Templates for discussion/Log/#{matches[2]}##{matches[3]}")
end
# templates.each do |t|
#   puts "######"
#   puts t.name
#   puts t.regex
#   puts t.tfd
# end
# 
# raise 'hell'



# templates << Template.new('Template:', '', '' )
# templates << Template.new('Template:The Television Drama Academy Award Best Actor Award', 'The Television Drama Academy Award Best Actor Award', 'Wikipedia:Templates for discussion/Log/2019 February 17#Template:The Television Drama Academy Award Best Actor Award' )
# templates << Template.new('Template:The Television Drama Academy Award Best Actress Award', 'The Television Drama Academy Award Best Actress Award', 'Wikipedia:Templates for discussion/Log/2019 February 17#Template:The Television Drama Academy Award Best Actress Award' )
# templates << Template.new('Template:The Television Drama Academy Award Best Supporting Actor Award', 'The Television Drama Academy Award Best Supporting Actor Award', 'Wikipedia:Templates for discussion/Log/2019 February 17#Template:The Television Drama Academy Award Best Supporting Actor Award' )


SKIPS = [
    'User:Pppery/noinclude list'
]
templates.each do |template|
  puts '#################'
  puts template[:name].colorize(:blue) 
  puts Helper.print_link(template[:name])
  titles = Helper.get_transclusions(template[:name])
  
  puts 'No transclusions'.colorize(:red) if titles.empty?
  
  puts titles.size.to_s.colorize(:blue)
  
  titles.each do |title|
    puts "- #{title}".colorize(:magenta)
    next if SKIPS.include?(title)
    page = client.get_wikitext(title).body
    page.force_encoding('UTF-8')
    old = page.dup
        
    page.scan(/(?=\{\{\s*(?:#{Regexp.escape(template[:regex])}))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten.each do |temp|
      page.gsub!(/#{Regexp.escape(temp)}\n*/, '')
    end

    if page == old
      Helper.print_link(title)
      Helper.print_message('NO CHANGE')
      next
    end
    
    client.edit(title: title, text: page, summary: "removing template per [[#{template[:tfd]}]]")
    Helper.page_history(title)
    puts ' - success'.colorize(:green)
    sleep 8 + rand(5)
  end
end

puts 'DONE!'