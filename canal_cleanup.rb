require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require './helper'
require 'uri'
require 'colorize'
require 'json'

Helper.read_env_vars(file = 'vars.csv')

client = MediawikiApi::Client.new 'https://en.wikipedia.org/w/api.php'
client.log_in 'Zackmann08', ENV['PASSWORD']
url = 'https://petscan.wmflabs.org/?psid=6604404&format=json'

titles = Helper.get_wmf_pages(url)

puts titles.count

titles.each do |title|
  puts title.colorize(:blue)
  page = client.get_wikitext(title).body

  templates = page.scan(/(?=\{\{(?:Infobox Canal))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten

  next unless templates.size == 1
  template = templates.first
  old_text = template.dup
  
  
  
  # Round 2
  # 

  template.gsub!(/\|(\s*)a_engineer(\s*)\=/, "|\\1other_engineer\\2=")
  template.gsub!(/\|(\s*)canal_name(\s*)\=/, "|\\1name\\2=")
  template.gsub!(/\|(\s*)caption(\s*)\=/, "|\\1image_caption\\2=")
  template.gsub!(/\|(\s*)company(\s*)\=/, "|\\1original_owner\\2=")
  template.gsub!(/\|(\s*)date_app(\s*)\=/, "|\\1date_approved\\2=")
  template.gsub!(/\|(\s*)date_comp(\s*)\=/, "|\\1date_completed\\2=")
  template.gsub!(/\|(\s*)date_cons(\s*)\=/, "|\\1date_began\\2=")
  template.gsub!(/\|(\s*)date_const(\s*)\=/, "|\\1date_began\\2=")
  template.gsub!(/\|(\s*)date_ext(\s*)\=/, "|\\1date_extended\\2=")
  template.gsub!(/\|(\s*)date_rest(\s*)\=/, "|\\1date_restored\\2=")
  template.gsub!(/\|(\s*)end(\s*)\=/, "|\\1end_point\\2=")
  template.gsub!(/\|(\s*)join(\s*)\=/, "|\\1connects_to\\2=")
  template.gsub!(/\|(\s*)m_name(\s*)\=/, "|\\1modern_name\\2=")
  template.gsub!(/\|(\s*)nav(\s*)\=/, "|\\1navigation_authority\\2=")
  template.gsub!(/\|(\s*)o_beam(\s*)\=/, "|\\1original_beam\\2=")
  template.gsub!(/\|(\s*)o_beam_ft(\s*)\=/, "|\\1original_beam_ft\\2=")
  template.gsub!(/\|(\s*)o_beam_in(\s*)\=/, "|\\1original_beam_in\\2=")
  template.gsub!(/\|(\s*)o_beam_m(\s*)\=/, "|\\1original_beam_m\\2=")
  template.gsub!(/\|(\s*)o_end(\s*)\=/, "|\\1original_end\\2=")
  template.gsub!(/\|(\s*)o_len(\s*)=/, "|\\1original_boat_length\\2=")
  template.gsub!(/\|(\s*)o_len_ft(\s*)=/, "|\\1original_boat_length_ft\\2=")
  template.gsub!(/\|(\s*)o_len_in(\s*)=/, "|\\1original_boat_length_in\\2=")
  template.gsub!(/\|(\s*)o_len_m(\s*)=/, "|\\1original_boat_length_m\\2=")
  template.gsub!(/\|(\s*)o_length(\s*)=/, "|\\1original_length\\2=")
  template.gsub!(/\|(\s*)o_length_km(\s*)=/, "|\\1original_length_km\\2=")
  template.gsub!(/\|(\s*)o_length_mi(\s*)=/, "|\\1original_length_mi\\2=")
  template.gsub!(/\|(\s*)o_lock_length_km(\s*)=/, "|\\1original_lock_length_km\\2=")
  template.gsub!(/\|(\s*)o_lock_length_mi(\s*)=/, "|\\1original_lock_length_mi\\2=")
  template.gsub!(/\|(\s*)o_lock_width_ft(\s*)=/, "|\\1original_lock_width_ft\\2=")
  template.gsub!(/\|(\s*)o_lock_width_m(\s*)=/, "|\\1original_lock_width_m\\2=")
  template.gsub!(/\|(\s*)o_locks(\s*)=/, "|\\1original_num_locks\\2=")
  template.gsub!(/\|(\s*)o_name(\s*)=/, "|\\1former_names\\2=")
  template.gsub!(/\|(\s*)o_start(\s*)=/, "|\\1original_start\\2=")
  template.gsub!(/\|(\s*)orig_num_locks(\s*)=/, "|\\1original_num_locks\\2=")
  template.gsub!(/\|(\s*)start(\s*)=/, "|\\1start_point\\2=")
  
  
  
  template.gsub!(/\|(\s*)length(\s*)=/, "|\\1length_mi\\2=")
  template.gsub!(/\|(\s*)original_length(\s*)=/, "|\\1original_length_mi\\2=")
  template.gsub!(/\|(\s*)len(\s*)=/, "|\\1len_ft\\2=")
  template.gsub!(/\|(\s*)original_boat_length(\s*)=/, "|\\1original_boat_length_ft\\2=")
  template.gsub!(/\|(\s*)beam(\s*)=/, "|\\1beam_ft\\2=")
  template.gsub!(/\|(\s*)original_beam(\s*)=/, "|\\1original_beam_ft\\2=")
  template.gsub!(/\|(\s*)elev(\s*)=/, "|\\1elev_ft\\2=")
  template.gsub!(/\|(\s*)o_end(\s*)=/, "|\\1original_end\\2=")
  
  page.gsub!(old_text, template)

  client.edit(title: title, text: page, summary: 'fixing even more deprecated params from [[Template:Infobox canal]]', tags: 'AWB')
  Helper.page_history(title)
  puts ' - success'.colorize(:green)
  sleep 5 + rand(3)
end
puts 'DONE!'