module Handball
  BREAK = /<\s*[\/]*br\s*[\/]*>/
  YEARS = /\([\d\-\w]*\)\s*$/i
  # CAPS_GOALS_REGEX = /(\d+).*\((\d*)\)/
  # CAPS_GOALS_REGEX = /(\d+).*(?:\((\d+)\))?/
  # CAPS_GOALS_REGEX = /(\d+).*(?:\((\d+)\))|(\d+)/
  CAPS_GOALS_REGEX = /(?:(\d+).*(?:\((\d+)\))|(\d+))[\'\s]*(<ref>.*<\/ref>)?/
  # REF_REGEX = /<ref>.*<\/ref>/i
  class LengthsMismatch < StandardError; end
  
  def parse_youth_years(text)
    years_matches = text.match(/\|\s*youthyears(\s*)=\s*(.*)/)
    clubs_matches = text.match(/\|\s*youthclubs(\s*)=\s*(.*)/)

    years = years_matches[2].split(BREAK)
    clubs = clubs_matches[2].split(BREAK)

    if years.length != clubs.length
      raise LengthsMismatch
    end
    
    justify = years_matches[1].length
    justify -= 1 unless justify == 1
    years.each.with_index(1).map do |year, index|
      "| youthyears#{index.to_s.ljust(justify)} = #{year}\n| youthclubs#{index.to_s.ljust(justify)} = #{clubs[index-1]}\n"
    end.join
  end
  
  def parse_title(text)
    title_matches = text.match(/\|\s*title(\s*)=\s*(.*)/)
    years_matches = text.match(/\|\s*titleyears(\s*)=\s*(.*)/)
    place_matches = text.match(/\|\s*titleplace(\s*)=\s*(.*)/)

    years  = years_matches[2].split(BREAK)
    titles = title_matches[2].split(BREAK)
    places = place_matches[2].split(BREAK)
    
    justify = years_matches[1].length
    justify -= 1 unless justify == 1
    years.each.with_index(1).map do |year, index|
      "| titleyears#{index.to_s.ljust(justify)} = #{year}\n| title#{index.to_s.ljust(justify+5)} = #{titles[index-1]}\n| titleplace#{index.to_s.ljust(justify)} = #{places[index-1]}\n"
    end.join
  end
  
  def parse_manager_years(text)
    years_matches = text.match(/\|\s*manageryears(\s*)=\s*(.*)/)
    clubs_matches = text.match(/\|\s*managerclubs(\s*)=\s*(.*)/)

    years = years_matches[2].split(BREAK)
    clubs = clubs_matches[2].split(BREAK)

    if years.length != clubs.length
      raise LengthsMismatch
    end
    
    justify = years_matches[1].length
    justify -= 1 unless justify == 1
    years.each.with_index(1).map do |year, index|
      "| manageryears#{index.to_s.ljust(justify)} = #{year}\n| managerclubs#{index.to_s.ljust(justify)} = #{clubs[index-1]}\n"
    end.join
  end
  
    
  def parse_clubs_years(text)
    years_matches = text.match(/\|\s*years(\s*)=\s*(.*)/)
    clubs_matches = text.match(/\|\s*clubs(\s*)=\s*(.*)/)

    years = []
    years = years_matches[2].split(BREAK) if years_matches
    clubs = clubs_matches[2].split(BREAK)

    unless years.length == clubs.length || years.empty?
      puts "years: #{years.length}"
      puts "clubs: #{clubs.length}"
      raise LengthsMismatch
    end
    
    justify = clubs_matches[1].length
    justify -= 1 unless justify == 1
    result = ''
    clubs.each.with_index(1) do |club, index|
      if club.match?(YEARS)
        result += "| years#{index.to_s.ljust(justify)} = #{club.match(YEARS)[0].gsub(/[)(]/, '')}\n"
        result += "| clubs#{index.to_s.ljust(justify)} = #{club.gsub(YEARS, '')}\n"
      else 
        result += "| years#{index.to_s.ljust(justify)} = #{years[index-1]}\n" unless years.empty?
        result += "| clubs#{index.to_s.ljust(justify)} = #{club}\n"
      end
    end
    result
  end
  
  def parse_national(text)
    national_year_matches = text.match(/\|\s*nationalyears(\s*)=\s*(.*)\n/)
    national_team_matches = text.match(/\|\s*nationalteam(\s*)=\s*(.*)\n/)
    national_caps_matches = text.match(/\|\s*nationalcaps\(goals\)(\s*)=\s*(.*)\n/)

    # puts ref_matches.inspect
    # puts national_year_matches.inspect
    # puts national_team_matches.inspect
    # puts national_caps_matches.inspect
    
    caps = []
    years = []
    years = national_year_matches[2].split(BREAK) if national_year_matches
    teams = national_team_matches[2].split(BREAK)
    caps  = national_caps_matches[2].split(BREAK) if national_caps_matches
    
    # puts years.inspect
    # puts teams.inspect
    # puts caps.inspect
    # ref = ''
    # ref = ref_matches.first unless ref_matches.empty?
    unless (years.length == teams.length && teams.length == caps.length) or caps.length == 0 or years.length == 0 
      raise LengthsMismatch
    end
    justify = national_team_matches[1].length 
    justify -= 1 unless justify == 1
    result = ''
    teams.each.with_index(1) do |team, index|
      cap = goal = ref = ''
      unless caps.empty? || caps[index-1].empty? || !caps[index-1].match?(/\d/)
        match_data = caps[index-1].match(CAPS_GOALS_REGEX)
        cap = match_data[1] || match_data[3]
        goal = match_data[2]
        ref = match_data[4]
      end
      result += "| nationalyears#{index.to_s.ljust(justify-1)} = #{years[index-1]}\n"
      result += "| nationalteam#{index.to_s.ljust(justify)} = #{team}\n"
      result += "| nationalcaps#{index.to_s.ljust(justify)} = #{cap}#{ref}\n"
      result += "| nationalgoals#{index.to_s.ljust(justify-1)} = #{goal}\n"
    end
    result
  end
end