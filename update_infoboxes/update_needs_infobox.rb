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

START_TIME = Time.now

Helper.read_env_vars(file = './vars.csv')
SKIPS = [ ]
client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

titles = []

CATEGORY = 'Category:Wikipedia articles with an infobox request'

pages = fetch_category_pages(client, CATEGORY, max_depth: 4)

sorted_titles = pages.map { |page| page['title'] }.sort!

report_start = "{{User:ZackBot/Header}}\n"
report_start += ";Report on latest job start.\n"
report_start += ":'''Job started at #{START_TIME.strftime("%D %H:%M")} and is looking at a total of #{pages.size} pages.'''\n"
report_start += ":The parent category is set as {{cl|#{CATEGORY}}}"

client.edit(title: 'User:ZackBot/Report', text: report_start, summary: "Updating report for start of run ([[Wikipedia:Bots/Requests_for_approval/ZackBot_10|ZackBot 10]])")

INFOBOX = /\{\{[\s\w\n]*infobox/i

error_pages = []
pages_edited = 0
start = 0
# count = 0
puts sorted_titles.size
sorted_titles.drop(start).each_with_index do |raw_title, index|

  if raw_title.start_with?('Talk:')
    title = raw_title.sub(/^Talk:/, '')
    talk_title = raw_title
  else
    title = raw_title
    talk_title = "Talk:#{title}"
  end

  next if SKIPS.include?(title)
  puts "#{start +index} - #{title}".colorize(:magenta) if index%100 == 0

  full_text = client.get_wikitext(title).body
  if CustomPage.parse_page(full_text, title, INFOBOX)
    talk_title = "Talk:#{title}"
    begin
      talk_page_text = client.get_wikitext(talk_title).body
      new_text = CustomPage.parse_talk_page(talk_page_text)
      client.edit(minor: true, title: talk_title, text: new_text, summary: "page has an infobox ([[Wikipedia:Bots/Requests_for_approval/ZackBot_10|ZackBot 10]] - [[User talk:ZackBot|report false positive]])")
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

END_TIME = Time.now

elapsed_seconds = END_TIME - START_TIME

minutes, seconds = elapsed_seconds.to_i.divmod(60)
hours, minutes = minutes.divmod(60)
days, hours = hours.divmod(24)

report = "{{User:ZackBot/Header}}\n"
report += ";Report on latest job run.\n"
report += ":'''Job finished at #{END_TIME.strftime("%D %H:%M")}, took #{days}d #{hours}h #{minutes}m #{seconds}s and edited a total of #{pages_edited} pages'''\n"
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
