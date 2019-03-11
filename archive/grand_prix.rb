require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'

def parse_text(text)
  text.force_encoding('UTF-8')
  templates = text.scan(/(?=\{\{(?:Infobox speedway grand prix event|SGP Event infobox))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
  raise Helper::NoTemplatesFound if templates.empty?
  raise Helper::UnresolvedCase.new('More than 1 template') if templates.size > 1

  template = templates.first
  old_template = template.dup

  template.gsub!(/<!--[\w\W]*?-->/,'')
  params = Helper.parse_template(template)

  raise Helper::UnresolvedCase if params['CITY'].empty?
  
  result = "{{Infobox speedway grand prix event
| flag       = #{params['FLAG']}
| name       = #{params['NAME']}
| date       = {{subst:date|#{params['DATE D']}-#{params['DATE M']}-#{params['DATE Y']}}}
| city       = #{params['CITY']}
| event      = #{params['EVENT']}
| referee    = #{params['REFEREE']}
| flag_ref   = #{params['REF-FLAG']}
| jury       = #{params['JURY']}
| flag_jury  = #{params['JURY-FLAG']}
| stadium    = #{params['STADIUM']}
| capacity   = #{params['CAPACITY']}
| length     = #{params['LENGTH']}
| track      = #{params['TRACK']}
| attendance = #{params['ATTENDANCE']}
| flag_time  = #{params['TIME-FLAG']}
| time_best  = #{params['TIME-BEST']}
| time_name  = #{params['TIME-NAME']}
| time_heat  = #{params['TIME-HEAT']}
| name1      = #{params['NAME-1']}
| flag1      = #{params['FLAG-1']}
| name2      = #{params['NAME-2']}
| flag2      = #{params['FLAG-2']}
| name3      = #{params['NAME-2']}
| flag3      = #{params['FLAG-3']}
}}"
  result.gsub!('<nowiki>', '')
  result.gsub!('</nowiki>', '')

  text.sub!(old_template, result)
  text
end

SKIPS = [
    '1995 Speedway Grand Prix of Austria',
    '1995 Speedway Grand Prix of Denmark',
    '1995 Speedway Grand Prix of Germany',
    '1995 Speedway Grand Prix of Great Britain',
    '1995 Speedway Grand Prix of Poland',
    '1995 Speedway Grand Prix of Sweden',
    '1995 Speedway Grand Prix of Denmark',
]
Helper.read_env_vars(file = './vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=6640288&format=json'

titles = Helper.get_wmf_pages(url)
puts titles.size
titles.each do |title|
  next if SKIPS.include?(title)
  puts title.colorize(:blue)
  text = client.get_wikitext(title).body
  text.force_encoding('UTF-8')
  begin
    text = parse_text(text)
  rescue Helper::UnresolvedCase => e
    Helper.print_link(title)
    Helper.print_message(e)
    Helper.print_message('Hit an unresolved case')
    next
  rescue Helper::NoTemplatesFound => e
    Helper.print_link(title)
    Helper.print_message('No templates found')
    next
  rescue Encoding::CompatibilityError => e
    Helper.print_message('Compatibility Error')
    next
  end

  # puts text.colorize(:red)

  client.edit(title: title, text: text, summary: 'fixing deprecated params', tags: 'AWB')

  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  # puts "waiting: "
  # continue = gets
  # puts continue
  sleep 5 + rand(3)
end
puts 'DONE!'