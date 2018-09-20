#!/usr/bin/env ruby
# encoding: utf-8

require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'

# STRIP_START_REGEX = /[\d]{4}[-\d\d]*\s*/
STRIP_START_REGEX = /\*\s*\[\[[\d]{4}[*–\d\d]*\s*/


# URL = "https://petscan.wmflabs.org/?language=en&project=wikipedia&depth=4&categories=Sports%20navigational%20boxes%20by%20sport&combination=subset&negcats=Australian%20cricket%20colour%20templates%0D%0ACricket%20navigational%20boxes%0D%0AShooting%20world%20record%20navigational%20boxes%0D%0AWestern%20Hockey%20League%20navigational%20boxes%0D%0ABaseball%20standings%20templates&ns%5B10%5D=1&larger=&smaller=&minlinks=&maxlinks=&before=&after=&max_age=&show_redirects=both&edits%5Bbots%5D=both&edits%5Banons%5D=both&edits%5Bflagged%5D=both&page_image=any&ores_type=any&ores_prob_from=&ores_prob_to=&ores_prediction=any&templates_yes=&templates_any=&templates_no=Sidebar%20games%20events%0D%0Acladogram%0D%0Ainfobox%0D%0Asidebar%20with%20collapsible%20lists%0D%0Anavbox%20basketball%20club%0D%0ASimple%20Horizontal%20timeline%0D%0Anavbox%20basketball%20club%0D%0AMPBL%20roster%20header%0D%0APBA%20roster%20header%0D%0ANavbox%0D%0AWNBA%20roster%20header%20current%0D%0ANavbox%20with%20collapsible%20groups%0D%0ASidebar%0D%0AMedalistTable%0D%0AFootball%20manager%20history%0D%0ATeam%20roster%20navbox%0D%0ANBA%20roster%20header&outlinks_yes=&outlinks_any=&outlinks_no=&links_to_all=&links_to_any=&links_to_no=&sparql=&manual_list=&manual_list_wiki=&pagepile=&search_query=&search_wiki=&search_max_results=500&wikidata_source_sites=&subpage_filter=either&common_wiki=auto&source_combination=&wikidata_item=no&wikidata_label_language=&wikidata_prop_item_use=&wpiu=any&sitelinks_yes=&sitelinks_any=&sitelinks_no=&min_sitelink_count=&max_sitelink_count=&labels_yes=&cb_labels_yes_l=1&langs_labels_yes=&labels_any=&cb_labels_any_l=1&langs_labels_any=&labels_no=&cb_labels_no_l=1&langs_labels_no=&format=json&output_compatability=catscan&sortby=ns_title&sortorder=ascending&regexp_filter=&min_redlink_count=1&doit=Do%20it%21&interface_language=en&active_tab=tab_output"
URL = "https://petscan.wmflabs.org/?psid=5859536&format=json"

Helper.read_env_vars

begin
  Timeout.timeout(40) do
    @content = HTTParty.get(URL)
  end
rescue Timeout::Error
  puts 'ERROR: Took longer than 20 seconds to get edit count. Script aborting.'
  exit(0)
end
# 
results = @content["*"].first['a']['*'].map do |i|
  # "#{i["title"].gsub('_',' ')}"
  "* [[#{i["title"].gsub('_',' ')}]]"
end

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in ENV['USERNAME'], ENV['PASSWORD']

results.select!{|str| str.include?('2018')}

results.sort_by!{|str| [str.gsub(STRIP_START_REGEX, ''), str]}
size = results.size
results = results.join("\n")

client.edit(title: 'User:Zackmann08/medals-todo', text: ("TO GO: #{size}\n" + results), summary: "Updating pages todo")
puts 'DONE'
# puts results.size