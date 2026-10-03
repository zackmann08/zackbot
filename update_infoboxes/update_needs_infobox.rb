require 'mediawiki_api'
require 'httparty'
require 'timeout'
require './helper.rb'
require 'uri'
require 'colorize'
require_relative './custom_page'
require_relative './category'
require 'json'
require 'set'

def fetch_category_pages(client, category_title, current_level: 1, max_depth: 3, visited: Set.new)
  formatted_title = category_title.start_with?('Category:') ? category_title : "Category:#{category_title}"

  return [] if current_level > max_depth || visited.include?(formatted_title)

  visited.add(formatted_title)
  all_pages = []

  response = client.query(
    list: 'categorymembers',
    cmtitle: formatted_title,
    cmnamespace: '1|14',
    cmlimit: 'max'
  )

  # Access data directly using bracket syntax on the response
  data = response.data
  members = (data.is_a?(Hash) ? data['categorymembers'] : nil) || response['categorymembers'] || []

  members.each do |member|
    # Convert keys to strings/symbols safely in case member is a Hash with symbol or string keys
    ns = member['ns'] || member[:ns]
    title = member['title'] || member[:title]

    if ns == 14
      subpages = fetch_category_pages(
        client,
        title,
        current_level: current_level + 1,
        max_depth: max_depth,
        visited: visited
      )
      all_pages.concat(subpages)
    else
      all_pages << member
    end
  end

  all_pages
end

# EXAMPLE: pages = fetch_category_pages(client, CATEGORY, max_depth: 3)


Helper.read_env_vars(file = './vars.csv')
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

CATEGORY = 'Category:Wikipedia articles with an infobox request'
# CATEGORY = 'Category:Highways articles needing infoboxes'

# response = client.query(
#   list: 'categorymembers',
#   cmtitle: CATEGORY,
#   cmnamespace: '1',
#   cmlimit: 10000
# )

# if response.data && response.data['categorymembers']
#   members = response.data['categorymembers']
#   members.each do |member|
#     titles << member['title']
#   end
# else
#   puts "No category members found or error in request."
# end

titles = fetch_category_pages(client, CATEGORY, max_depth: 4)

INFOBOX = /\{\{[\s\w\n]*infobox/i

error_pages = []
pages_edited = 0
start = 0
# count = 0
puts titles.size
titles.drop(start).each_with_index do |page, index|
  raw_title = page['title']
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
      pages_edited += 1
      puts "- success - #{title}".colorize(:green)
    rescue CustomPage::NeedsInfoboxNotFound => e
      error_pages << talk_title
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


report = "{{User:ZackBot/Header}}\n"
report += ";Report on latest job run.\n"
report += ":'''Job ran at #{Time.now.utc.to_s} and edited a total of #{pages_edited} pages'''\n"
report += ":The parent category was set as {{cl|#{CATEGORY}}}"
report += "\n\n=== Errors ===\n"
if error_pages.empty?
  report += ":''None''\n" 
else
  error_pages.each do |page|
    report += "* [[#{page}]]\n"
  end
end

client.edit(minor: true, title: 'User:ZackBot/Report', text: report, summary: "Updating report after run ([[Wikipedia:Bots/Requests_for_approval/ZackBot_10|ZackBot 10]])")

# TODO: Do something with the error pages...
# TODO: Push the results to the reports page. 
puts "Finished and edited a total of #{pages_edited}".colorize(:red)
