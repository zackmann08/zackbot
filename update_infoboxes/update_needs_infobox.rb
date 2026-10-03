require 'mediawiki_api'
require 'httparty'
require 'timeout'
require '../helper.rb'
require 'uri'
require 'colorize'
require_relative './custom_page'
require_relative './category'
require 'json'

Helper.read_env_vars(file = '../vars.csv')
SKIPS = [
    'Anthony Wagner',
    'Tangle Lakes',
    'Bernd Jakubowski',
    'Karl-Heinz Marotzke',
    'Spalding v Gamage',
    'St. Johns Light',
    'Going Back to My Roots',
    'Pao v. Kleiner Perkins'
]
client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
# url = 'https://petscan.wmflabs.org/?psid=55556997&format=json'

titles = []

# CATEGORY = 'Category:Wikipedia articles with an infobox request'
CATEGORY = 'Category:Architecture articles needing infoboxes'

response = client.query(
  list: 'categorymembers',
  cmtitle: CATEGORY,
  cmnamespace: '1',
  cmlimit: 10000
)

if response.data && response.data['categorymembers']
  members = response.data['categorymembers']
  members.each do |member|
    titles << member['title']
  end
else
  puts "No category members found or error in request."
end

INFOBOX = /\{\{[\s\w\n]*infobox/i

start = 150
# count = 0
puts titles.size
titles.drop(start).each_with_index do |raw_title, index|
  sleep 0.5
  # title = title.gsub(/[A-Z]*:(.*)/i, '\1')
  if raw_title.start_with?('Talk:')
    title = raw_title.sub(/^Talk:/, '')
    talk_title = raw_title
  else
    title = raw_title
    talk_title = "Talk:#{title}"
  end

  next if SKIPS.include?(title)
  puts "#{start +index} - #{title}".colorize(:magenta) if index%100 == 0
  
  # TODO: Check for client.get_wikitext(title).status == 429 showing a rate limit error
  #       check for a possible 'retry-after' time?


  full_text = client.get_wikitext(title).body
  if CustomPage.parse_page(full_text, title, INFOBOX)
    talk_title = "Talk:#{title}"
    begin
      talk_page_text = client.get_wikitext(talk_title).body
      new_text = CustomPage.parse_talk_page(talk_page_text)
      client.edit(minor: true, title: talk_title, text: new_text, summary: "page has an infobox ([[Wikipedia:Bots/Requests_for_approval/ZackBot_10|ZackBot 10]])")
      puts "- success - #{title}".colorize(:green)
    rescue CustomPage::NeedsInfoboxNotFound => e
      puts e.message
      puts e.backtrace
      puts '#####'
      puts talk_page_text
      puts '#####'
      Helper.print_message('Raised: "NeedsInfoboxNotFound"')
      Helper.print_link(title)
      Helper.print_link(talk_title)
      next
    end
  end
end

# puts titles[0]
# #TODO: now that I'm doing the entire thing, get the JSON from WMF and store it locally
# # That way I can resume where I left off. 
# # made it to 9300 - Bla Bla
# # https://en.wikipedia.org/wiki/Bla%20Bla
# categories = CSV.foreach('data.csv', {headers: true}).map do |row|
#   Category.new(row)
# end
# # tempHash = {
# #     "key_a" => "val_a",
# #     "key_b" => "val_b"
# # }
# # File.open("public/temp.json","w") do |f|
# #   f.write(tempHash.to_json)
# # end
# 
# categories.each do |category|
#   puts "Category: #{category.name}".colorize(:blue)
# 
#   Category.parse_category(category, client)
# end
# 
puts 'DONE!'
