
require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require '../helper'
require 'uri'
require 'colorize'
require_relative './page'


def print_link(title)
  puts "\t#{URI::encode("https://en.wikipedia.org/wiki/#{title}")}"
end

def print_message(message)
  puts "\t#{message}".colorize(:red)
end

URL = "https://petscan.wmflabs.org/?psid=5950450&format=json"

Helper.read_env_vars(file = '../vars.csv')

@content = HTTParty.get(URL)

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

pages = @content["*"].first['a']['*'].map do |i|
  i["title"].gsub('_', ' ')
end
puts "Total to do: #{pages.size}"

pages.each do |title|
  puts title

  full_text = client.get_wikitext(title).body
  if Page.parse_page(full_text,title)
    talk_title = "Talk:#{title}"
    begin
      talk_page_text = client.get_wikitext(talk_title).body
      new_text = Page.parse_talk_page(talk_page_text)
      client.edit(title: talk_title, text: new_text, summary: "removing 'needs-infobox' as the page has an infobox")
      puts "- success".colorize(:green)
      sleep 5
    rescue Page::NeedsInfoboxNotFound => e
      Helper.print_message('Raised: "NeedsInfoboxNotFound"')
      Helper.print_link(talk_title)
      next
    end
  end
end

puts "DONE!"