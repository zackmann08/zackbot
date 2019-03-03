# encoding: utf-8


module Generic
  class NoTemplatesFound < StandardError; end

  BREAK = /<\s*[\/]*br\s*[\/]*>/
  TOTAL = /tota?l?s?\.?/i
  DASH = /-|–/
  def parse_set(params)
    return unless (params['set1']&&params['set2']&&params['set'])
    
    team1 = params['set1'].gsub("'",'').split(BREAK).reject{|i| i.strip.match?(DASH)}
    team2 = params['set2'].gsub("'",'').split(BREAK).reject{|i| i.strip.match?(DASH)}
    sets = params['set'].gsub("'",'').split(BREAK)
    team1.pop if sets.last.match?(TOTAL)
    team2.pop if sets.last.match?(TOTAL)

    if team1.size != team2.size
      puts team1.inspect
      puts team2.inspect
      raise Helper::UnresolvedCase.new('Arrays do not match')
    end
    
    result = ''
    team1.zip(team2).each do |scores|
      result += "#{scores[0].strip}–#{scores[1].strip}, "
    end
    return "(#{result.chomp(', ')})"
    # Check for '-'
    # Check for 'total'
    # check for arrays not matching
  end
   
  
  def parse_text(text)
    text.force_encoding('UTF-8')
    text.gsub!('{{{bgc}}}','@@ZW@@')
    text.gsub!('{{{df|mdy}}}','@@ZW2@@')
    templates = text.scan(/(?=\{\{\s*(?:volleyballbox))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise Helper::NoTemplatesFound if templates.empty?
    # raise Helper::UnresolvedCase.new('More than 1 template') if templates.size > 1
    
    templates.each do |template|
      # template = templates.first
      old_template = template.dup
  
      template.gsub!(/<!--[\w\W]*?-->/,'')
      # template.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
      params = Helper.parse_template(template)
      params.default = nil
      # Delete blank values
      params.reject!{|_k,v| v.empty?}
      
      # \{\{\{([a-z\_]*)\|?\}\}\}
      # #{params['$1']}
      
      
      result = "{{volleyballbox2
| bg         = #{params['bg']}
| size       = #{params['size']}
| date       = #{params['date']}
| time       = #{params['time']}
| team1      = #{params['team1'].gsub("'''", '') if params['team1']}
| score      = #{params['score'].gsub(" ","") if params['score']}
| team2      = #{params['team2'].gsub("'''", '') if params['team2']}
| set        = #{parse_set(params)}
| stadium    = #{params['stadium']}
| attendance = #{params['attendance']}
| referee    = #{params['referee']}
| report     = #{params['report']}
}}"

      result.gsub!("'''", '')
      result.gsub!('<nowiki>', '')
      result.gsub!('</nowiki>', '')
      
      # This will strip un-used parmeters
      result.gsub!(/\|.*\=\s*\n/, '')
  
      text.sub!(old_template, result)
    end
    text.gsub!('@@ZW@@','{{{bgc}}}')
    text.gsub!('@@ZW2@@','{{{df|mdy}}}')
    text
  end
end
