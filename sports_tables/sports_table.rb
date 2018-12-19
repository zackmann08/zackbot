# encoding: utf-8
require '../sports_tables/team'
require '../helper'

module SportsTable
  ASCII_OFFSET = 65
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end
  
  def parse_status(text) 
    raise Helper::UnresolvedCase.new('Status not dealt with') if text == 'allsvenskanchampion'
    raise Helper::UnresolvedCase.new('Status not dealt with') if text == 'swedishchampion'
    return 'O' if text == 'playoffwinner'
    return 'RQ' if text == 'relegationqualified'
    return text[0].upcase
  end
  
  TEMPLATE_REGEX = 'fb cl2 team 2pts|fb cl2 team'
  ROW_REGEX = /(?=\{\{\s*(?:#{TEMPLATE_REGEX.to_s}))(\{\{(?>[^{}]++|\g<1>)*}})/i
  
  HEADER_REGEX = /(?=\{\{\s*(?:Fb[\s\_]cl[\s\_]header))(\{\{(?>[^{}]++|\g<1>)*}})/i
  FOOTER_REGEX = /(?=\{\{\s*(?:Fb[\s\_]cl[\s\_]footer))(\{\{(?>[^{}]++|\g<1>)*}})/i
  def parse_sports_table(text)
    raise Helper::UnresolvedCase.new('Rowspan') if text.match?(/rowspan/i)
    raise Helper::UnresolvedCase.new('Has extra column') if text.match?(/\|\|/)
    raise Helper::UnresolvedCase.new('Pipe at end of row') if text.match?(/\{\{fb.*\|\}/i)
    
    teams = text.scan(ROW_REGEX).map {|l| Team.new(l.first)}
    
    parsed_header = Helper.parse_template(text.match(HEADER_REGEX)[1])
    
    # These indicate there is an extra column at the end
    raise Helper::UnresolvedCase.new('promoted=y') unless parsed_header['promoted'].empty?
    raise Helper::UnresolvedCase.new('qualification=y') unless parsed_header['qualification'].empty?
    parsed_footer = {}
    if text.match?(FOOTER_REGEX)
      parsed_footer = Helper.parse_template(text.match(FOOTER_REGEX)[1]) 
    end

    unless teams.map{|t| t.name}.uniq.length == teams.length
      # raise Helper::UnresolvedCase.new("Duplicate names: #{teams.map{|t| t.name}.inspect}")  
      # raise Helper::UnresolvedCase.new("Duplicate names: #{teams.map{|t| t.name}.sort.inspect}")
      
      # Comment out the except above in order to manually update the names as you go.
      used_names = []
      teams.each do |team|
        name = team.name
        if used_names.include?(name)
          new_name = Helper.get_custom_value("Name: '#{name}' already taken, enter new name for '#{team.raw_name}:'")
          team.name = new_name
          used_names << new_name
        else
          used_names << name
        end
      end
      unless teams.map{|t| t.name}.uniq.length == teams.length
        raise Helper::UnresolvedCase.new("STILL has duplicate names after manual update: #{teams.map{|t| t.name}.sort.inspect}")
      end
    end
    unless teams.map{|t| t.wpts}.uniq.length == 1
      raise Helper::UnresolvedCase.new("Different win points on different rows")
    end
     
     
    # Add the result header
    result = "{{#invoke:sports table|main|style=WDL
|res_col_header=QR"
    result += "\n|winpoints=2" if text.match?(/fb cl2 team 2pts/i)
    result += "\n|winpoints=#{teams.first.wpts}" unless teams.first.wpts.empty?
    result += "\n|use_goal_ratio=#{parsed_header['gavg']}" unless parsed_header['gavg'].empty?
    result += "\n|sortable_table=y" unless parsed_header['sort'].empty?
    result += "\n"
    
    # Add the team/name section
    teams.each.with_index(1) do |team, index|
      name = team.name.ljust(3)
      result += "\n|team#{index} = #{name}"
      result += " | pos_#{name} = #{team.pos.ljust(2)}" unless team.pos.to_i == index
      result += " | name_#{name} = #{team.raw_name}"
    end
    
    status_skips = ['PP', 'RR']
    # Add the stats section
    result += "\n"
    teams.each do |team|
      name = team.name.ljust(3)
      result += "\n|win_#{name} = #{team.win.ljust(2)}|draw_#{name} = #{team.draw.ljust(2)}|loss_#{name} = #{team.loss.ljust(2)}"
      result += "|gf_#{name} = #{team.gf.ljust(2)}|ga_#{name} = #{team.ga.ljust(2)}"
      result += "|adjust_points_#{name} = #{team.adjust}" unless team.adjust.zero?
      result += "|hth_#{name} = #{team.hth}" unless team.hth.empty?
      result += "|status_#{name} = #{team.status}" if (team.status && !status_skips.include?(team.status))
    end

    used_status = []
    teams.each.with_index(1) do |team, index|
      # puts team.color
      # puts team.raw_row
      next unless team.status || team.color
      if team.status
        unless used_status.include?(team.status)
          result+= "\n|col_#{team.status}=#{team.color}|text_#{team.status}=" unless team.color.nil?
          used_status << team.status
        end
        result+= "\n|result#{index}=#{team.status}"
      elsif team.color
        status = (index-1+ASCII_OFFSET).chr*2
        unless used_status.include?(status)
          result+= "\n|col_#{status}=#{team.color}|text_#{status}=" unless team.color.nil?
          used_status << status
        end
        result+= "\n|result#{index}=#{status}"
      else
        raise Helper::UnresolvedCase('Should not be possible')
      end     
    end

    # Add the footer
    class_rules = '1) points; 2) goal difference; 3) number of goals scored.'
        
    unless parsed_footer.empty?
      parsed_footer.default = nil
      result += "\n|update=#{parsed_footer['u'] || 'complete'}"
      result += "\n|class_rules=#{parsed_footer['orfc'] || class_rules}"
      result += "\n|nt=#{parsed_footer['nt']}" if parsed_footer['nt']
      result += "\n|source=#{parsed_footer['s']}\n}}"
      result.strip
    else
      result += "\n|update=complete|source=\n}}"
      result.strip
    end
  end
  TABLE_REGEX = /(\{\{\s*(?:Fb[\s\_]cl[\s\_]header)[\w\W]*?(?:\|\}|\{\{\s*end\s*\}\}|#{FOOTER_REGEX.to_s}))/i
  
  def parse_sports_table_page(text)
    text.gsub!(/\{\{he icon\}\}/, '@@@HE@@@')
    text.gsub!(/\{\{uk icon\}\}/, '@@@UK@@@')
    tables = []
    
    Timeout.timeout(5) do
      tables = text.scan(TABLE_REGEX)
    end
  
    # Likely cause here is that the footer contains "{{_____}}"
    raise Helper::NoTemplatesFound if tables.size==0
    
    tables.each do |table|
      table = table.first
      result = parse_sports_table(table)
      text.sub!(table, result)
    end
    text.gsub!('@@@HE@@@', '{{he icon}}')
    text.gsub!('@@@UK@@@', '{{uk icon}}')
    if text.match?(/\|hth_/)
      ans = Helper.get_custom_value("Has footnotes will you resolve manually?")
      raise Helper::UnresolvedCase.new('Has footnotes')  unless ans == 'Y'
    end
    text
  end
end
