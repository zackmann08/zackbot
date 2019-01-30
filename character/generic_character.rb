# encoding: utf-8


module Generic
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end
  
  def parse_color(params)
    params = params.reject{|_k,v| v.empty?}
    result = ""
    result += "\n| color              = #{params['color']||params['bgcolor']}" if (params['color'] || params['bgcolor'])
    result += "\n| colour             = #{params['colour']||params['bgcolour']}" if (params['colour'] || params['bgcolour'])
    result
  end
  def parse_labels(params)
    params = params.reject{|_k,v| v.empty?}
    result = ""
    (1..5).each do |i|
      result += "\n| lbl#{i}               = #{params["lbl#{i}"]}" if params["lbl#{i}"]
      result += "\n| data#{i}              = #{params["data#{i}"]}" if params["data#{i}"]
    end
    result
  end
  def parse_labels2(params)
    params = params.reject{|_k,v| v.empty?}
    result = ""
    (21..25).each do |i|
      result += "\n| lbl#{i}               = #{params["lbl#{i}"]}" if params["lbl#{i}"]
      result += "\n| data#{i}              = #{params["data#{i}"]}" if params["data#{i}"]
    end
    result += "\n| extra-hdr          = #{params['extra-hdr']}" if params['extra-hdr']
    (31..35).each do |i|
      result += "\n| lbl#{i}               = #{params["lbl#{i}"]}" if params["lbl#{i}"]
      result += "\n| data#{i}              = #{params["data#{i}"]}" if params["data#{i}"]
    end
    result
  end
  
  def parse_names(params)
    params = params.reject{|_k,v| v.empty?}
    result = ""
    result += "\n| nickname           = #{params['nickname']}" if params['nickname']
    result += "\n| nickname           = #{params['Nickname']}" if params['Nickname']
    result += "\n| nicknames          = #{params['nicknames']}" if params['nicknames']
    result += "\n| alias              = #{params['alias']}" if params['alias']
    result += "\n| aliases            = #{params['aliases']}" if params['aliases']
    result += "\n| aliases            = #{params['other_names']}" if params['other_names']
    result += "\n| race               = #{params['race']}" if params['race']
    result += "\n| species            = #{params['species']}" if params['species']
    result += "\n| species            = #{params['kind of species']}" if params['kind of species']
    result += "\n| position           = #{params['position']}" if params['position']
    result += "\n| occupation         = #{params['occupation']}" if params['occupation']
    result += "\n| spouse             = #{params['spouse']}" if params['spouse']
    result += "\n| spouses            = #{params['spouses']}" if params['spouses']
    result += "\n| significant_other  = #{params['significant_other']}" if params['significant_other']
    result += "\n| significant_other  = #{params['significant other']}" if params['significant other']
    result += "\n| significant_others = #{params['significant_others']}" if params['significant_others']
    result += "\n| home               = #{params['home']}" if params['home']
    result += "\n| home               = #{params['hometown']}" if params['hometown']
    result += "\n| origin             = #{params['origin']}" if params['origin']
    result += "\n| origin             = #{params['homeworld']}" if params['homeworld']
    
    result
  end
  
  def parse_text(text)
    text.force_encoding('UTF-8')
    templates = text.scan(/(?=\{\{\s*(?:Infobox character|CharacterInfoBox|Infobox Buffyverse character|Dune character box|Firefly Character|General CVG character|General VG character|Infobox Avatar: The Last Airbender character|Infobox biblical character|Infobox cartoon character|Infobox Character|Infobox character|Infobox Dune character|Infobox epic character|Infobox fictional character|Infobox James Bond character|Infobox mythical character|Infobox mythological character|Infobox player|Infobox religious character|Infobox Sea Patrol character|Infobox Street Fighter character|Infobox television character|Infobox VG Character|Infobox VG character|Infobox video game character|James Bond Character|Killer Instinct Character|Namco characters|Infobox G.I. Joe character))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
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
      params.select!{|k,_v| k.start_with?('lbl')}
      
      
      return params.values
      
      known_params = ["adapted_by", "affiliation", "alias", "aliases", "alt", "caption", "children", "color", 
          "colour", "creator", "data1", "data2", "data21", "data22", "data23", "data24", "data25", "data3", "data31", 
          "data32", "data33", "data34", "data35", "data4", "data5", "designer", "extra-hdr", "family", "fighting_style", 
          "first", "first_date", "first_issue", "first_major", "first_minor", "firstgame", "franchise", "full_name", 
          "fullname", "gender", "home", "image", "image_size", "image_upright", "info-hdr", "last", "last_date", "last_issue", 
          "last_major", "last_minor", "lbl1", "lbl2", "lbl21", "lbl22", "lbl23", "lbl24", "lbl25", "lbl3", 
          "lbl31", "lbl32", "lbl33", "lbl34", "lbl35", "lbl4", "lbl5", "motion_actor", "multiple", "name", 
          "nationality", "nickname", "nicknames", "noinfo", "occupation", "origin", "portrayer", "position", "race", 
          "relatives", "religion", "series", "significant_other", "significantother", "significant_others", "species", 
          "spouse", "spouses", "title", "voice", "weapon"]
      
      rejected_params = ['colour text', 'cause']
      
      # params.keys.each do |k|
      #   # puts k
      #   # raise Helper::UnresolvedCase.new("#{k} is not resolved") unless (known_params.include?(k) || rejected_params.include?(k))
      #   raise Helper::UnresolvedCase.new(k) unless (known_params.include?(k) || rejected_params.include?(k))
      # end
      
      # ['KanjiTitle', 'RomajiTitle'].each do |param|
      #   raise Helper::UnresolvedCase.new(param) if (params[param] && !params[param].empty?)
      # end
      #
      # puts params['hm1-stat'].inspect
      # raise Helper::UnresolvedCase.new('Winner is not actually winner') if (!params['hm1-stat'].nil? && !params['hm1-stat'].empty? && params['hm1-stat'].downcase != 'winner')
      # raise Helper::UnresolvedCase.new('Runner up is not actually runner-up') if (params['hm2-stat'].nil? || (params['hm2-stat'].downcase != 'runner' && params['hm2-stat'].downcase != 'runnerup'))
      # raise Helper::UnresolvedCase.new('Day not formatted properly') if (params['hm1-exit'].nil? || params['hm1-exit'].empty? || !params['hm1-exit'].match?(/day \d+/i))
      
      result = "{{Infobox character#{parse_color(params)}
| name               = #{params['name']}
| series             = #{params['series']}
| franchise          = #{params['franchise']}
| image              = #{params['image']}
| image_size         = #{params['image_size']}
| alt                = #{params['alt']}
| caption            = #{params['caption']}
| episode            = #{params['episode']}
| first              = #{params['first']||params['first appearance']}
| first_major        = #{params['first_major']}
| first_minor        = #{params['first_minor']}
| first_issue        = #{params['first_issue']}
| first_date         = #{params['first_date']}
| firstgame          = #{params['firstgame']}
| last               = #{params['last']||params['Last Appearance']}
| last_major         = #{params['last_major']}
| last_minor         = #{params['last_minor']}
| last_issue         = #{params['last_issue']}
| last_date          = #{params['last_date']}
| creator            = #{params['creator']||params['creators']}
| adapted_by         = #{params['adapted_by']}
| designer           = #{params['designer']}
| portrayer          = #{params['portrayer']||params['portrayed']||params['liveactor']||params['played by']||params['portrayed by']}
| voice              = #{params['voice']||params['voiceactor']}
| motion_actor       = #{params['motion_actor']}#{parse_labels(params)}
| full_name          = #{params['full_name']||params['fullname']||params['Full Name']}#{parse_names(params)}
| gender             = #{params['gender']}
| title              = #{params['title']}
| affiliation        = #{params['affiliation']||params['Team affiliation']}
| fighting_style     = #{params['fighting_style']}
| weapon             = #{params['weapon']||params['weapons']}
| family             = #{params['family']}
| children           = #{params['children']}
| relatives          = #{params['relatives']||params['known relatives']}
| religion           = #{params['religion']}
| nationality        = #{params['nationality']||params['nationaliy']}#{parse_labels2(params)}
}}"

      result.gsub!('<nowiki>', '')
      result.gsub!('</nowiki>', '')
      
      # This will strip un-used parmeters
      result.gsub!(/\|.*\=\s*\n/, '')
  
      text.sub!(old_template, result)
    end
    text
  end
end
