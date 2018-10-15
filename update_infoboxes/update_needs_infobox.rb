require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require_relative './custom_page'
require_relative './category'
require 'json'

Helper.read_env_vars(file = '../vars.csv')
SKIPS = [
    'Tangle Lakes'
]
client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=5972779&format=json'

titles = Helper.get_wmf_pages(url)
# # 
# # File.open("contents.txt", "w+") do |f|
# #   f.puts(titles)
# # end
# 
# # text=File.open('contents.txt').read
# # titles = text.split("\\n")
# # puts titles.first
# # puts text.inspect
# 
# titles = File.open('contents.txt').map{|line| line}

TALK_PAGE = /\|\s*(?:needs-infobox|infoboxneeded|infobox|needs-cultivar-infobox|no-infobox|ibox)\s*=\s*[^\}\|]*/
INFOBOX = /\{\{[\s\w\n]*infobox/i
#75090 
start = 0
titles.drop(start).each_with_index do |title, index|
  next if SKIPS.include?(title)
  puts "#{start +index} - #{title}".colorize(:magenta) if index%100 == 0
  
  full_text = client.get_wikitext(title).body
  if CustomPage.parse_page(full_text, title, INFOBOX)
    talk_title = "Talk:#{title}"
    begin
      talk_page_text = client.get_wikitext(talk_title).body
      new_text = CustomPage.parse_talk_page(talk_page_text,TALK_PAGE)
      client.edit(title: talk_title, text: new_text, summary: "page has an infobox")
      puts "- success".colorize(:green)
      # sleep 5 + rand(5)
    rescue CustomPage::NeedsInfoboxNotFound => e
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
