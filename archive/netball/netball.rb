module Netball
  BREAK = /<\s*[\/]*br\s*[\/]*>/
  YEARS = /\([\d\-\w]*\)\s*$/i

  PARAMS = %w[domesticyears domesticteams domesticcaps nationalyears nationalteams nationalcaps coachyears coachteams]

  DOMESTIC  = /(?:\s*\|\s*domesticyears\s*\=.*\n)?\s*\|\s*domesticteams\s*\=.*\n(?:\s*\|\s*domesticcaps\s*\=.*)?/
  NATIONAL  = /(?:\s*\|\s*nationalyears\s*\=.*\n)?\s*\|\s*nationalteams\s*\=.*\n(?:\s*\|\s*nationalcaps\s*\=.*)?/
  COACH     = /\s*\|\s*coachyears\s*\=.*\n\s*\|\s*coachteams\s*\=.*/
  
  class LengthsMismatch < StandardError; end
  
  def parse_page(text)
    PARAMS.each do |param|
      text.gsub!(/\|\s*#{param}\s*\=\s*(\||\}\}|\n)/, '\1')
    end
    if text.match?(DOMESTIC)
      text.gsub!(DOMESTIC, parse_domestic(text))
    end
    if text.match?(NATIONAL)
      text.gsub!(NATIONAL, parse_national(text))
    end
    if text.match?(COACH)
      text.gsub!(COACH, parse_coach(text))
    end
    PARAMS.each do |param|
      text.gsub!(/\|\s*#{param}\s*\=\s*(\||\}\}|\n)/, '\1')
    end
    new_params = %w[clubyears clubteams clubapps nationalyears nationalteams nationalcaps coachyears coachteams]
    new_params.each do |param|
      text.gsub!(/(#{param}\d*\s*=\s*\d*\n)\s*\n/,'\1')  
    end
    
    text
  end
  
  def parse_domestic(text)
    years_matches = text.match(/\|(\s*)domesticyears(\s*)=\s*(.*)/)
    teams_matches = text.match(/\|(\s*)domesticteams(\s*)=\s*(.*)/)
    caps_matches = text.match(/\|(\s*)domesticcaps(\s*)=\s*(.*)/)
    
    years = teams = caps = Array.new(20, '')
    years = years_matches[3].split(BREAK) if years_matches
    teams = teams_matches[3].split(BREAK) if teams_matches
    caps = caps_matches[3].split(BREAK) unless caps_matches.nil?
    
    padding =  teams_matches[1]
    justify = teams_matches[2].length
    justify -= 1 unless justify == 1
    teams.each.with_index(1).map do |team, index|
      "\n |#{padding}clubyears#{index.to_s.ljust(justify)} = #{years[index-1]}\n |#{padding}clubteam#{index.to_s.ljust(justify+1)} = #{team}\n |#{padding}clubapps#{index.to_s.ljust(justify+1)} = #{caps[index-1]}"
    end.join
  end
  def parse_national(text)
    years_matches = text.match(/\|(\s*)nationalyears(\s*)=\s*(.*)/)
    teams_matches = text.match(/\|(\s*)nationalteams(\s*)=\s*(.*)/)
    caps_matches = text.match(/\|(\s*)nationalcaps(\s*)=\s*(.*)/)

    years = teams = caps = Array.new(20, '')
    years = years_matches[3].split(BREAK) if years_matches
    teams = teams_matches[3].split(BREAK) if teams_matches
    caps = caps_matches[3].split(BREAK) if caps_matches

    padding =  teams_matches[1]
    justify = teams_matches[2].length
    justify -= 1 unless justify == 1
    teams.each.with_index(1).map do |team, index|
      "\n |#{padding}nationalyears#{index.to_s.ljust(justify)} = #{years[index-1]}\n |#{padding}nationalteam#{index.to_s.ljust(justify+1)} = #{team}\n |#{padding}nationalcaps#{index.to_s.ljust(justify+1)} = #{caps[index-1]}"
    end.join
  end
  
  def parse_coach(text)
    years_matches = text.match(/\|(\s*)coachyears(\s*)=\s*(.*)/)
    teams_matches = text.match(/\|(\s*)coachteams(\s*)=\s*(.*)/)

    years = teams = Array.new(20, '')
    years = years_matches[3].split(BREAK) if years_matches
    teams = teams_matches[3].split(BREAK) if teams_matches
    
    
    justify = teams_matches[2].length
    justify -= 1 unless justify == 1
    teams.each.with_index(1).map do |team, index|
      " |#{years_matches[1]}coachyears#{index.to_s.ljust(justify)} = #{years[index-1]}\n |#{teams_matches[1]}coachteam#{index.to_s.ljust(justify+1)} = #{team}"
    end.join
  end
end