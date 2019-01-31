# encoding: utf-8


module Generic
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end
  
  def parse_prev_next(text)
    "[[#{text}|#{text.match(/\((.*)\)/)[1]}]]"
  end
  def parse_housemates(params)
    (1..48).reverse_each do |i|
      return i if params["hm#{i}"]
    end
  end
  
  def parse_text(text)
    text.force_encoding('UTF-8')
    templates = text.scan(/(?=\{\{\s*(?:Infobox CFL Draft))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
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
      
      year = params['year'].to_i
      
      
      result = "{{Infobox sports draft
| name          = {{subst:PAGENAME}}
| logo          = #{params['image']} 
| logosize      = #{params['imagesize']||params['image_size']}
| logoalt       = #{params['year']} CFL draft logo 
| caption       = #{params['caption']}
| sport         = Football
| date          = #{params['date']}
| time          = #{params['time']}
| location      = #{params['location']}
| network       = #{params['network']}
| overall       = #{params['overall']}
| rounds        = 
| league        = 
| first         = #{params['first']}
| teams         = 
| team          = 
| territorial   = 
| mr_irrelevant = 
| fewnum        = 
| fewest        = #{params['fewest']}
| mostnum       = 
| most          = #{params['most']}
| prev          = {{subst:#ifexist:#{year-1} CFL Draft|[[#{year-1} CFL Draft|#{year-1}]]}}
| next          = {{subst:#ifexist:#{year+1} CFL Draft|[[#{year-1} CFL Draft|#{year+1}]]}}
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
