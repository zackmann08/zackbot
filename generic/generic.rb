# encoding: utf-8


module Generic
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end

  def parse_text(text)
    text.force_encoding('UTF-8')
    templates = text.scan(/(?=\{\{\s*(?:Infobox college sports rivalry|Infobox college rivalry))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise Helper::NoTemplatesFound if templates.empty?
    # raise Helper::UnresolvedCase.new('More than 1 template') if templates.size > 1

    templates.each do |template|
      # template = templates.first
      old_template = template.dup
  
      template.gsub!(/<!--[\w\W]*?-->/,'')
      # template.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
      params = Helper.parse_template(template)
      params.default = nil

      result = "{{Infobox sports rivalry
| wide                  = yes
| name                  = 
| image                 = #{params['rivalry_image']||params['two_team_image']}
| image_size            = #{params['rivalry_image_size']||params['two_team_image_size']}
| caption               = 
{{Infobox basketball tournament season
| title                      = WNBA Playoffs
| year                       = #{params['year']}
| other_titles               = 
| image                      = #{params['image']}
| imagesize                  = 
| caption                    = #{params['caption']}
| country                    = 
| dates                      = 
| num_teams                  = 
| defending champions        = 
| champions                  = 
| runner-up                  = 
| third                      = 
| fourth                     = 
| continentalcup1            = 
| continentalcup1 qualifiers = 
| matches                    = 
| attendance                 = 
| top scorer                 = 
| player                     = 
| prevseason                 = 
| nextseason                 = 
| extra information          = 
| updated                    = 
}}"
      
      result.gsub!('<nowiki>', '')
      result.gsub!('</nowiki>', '')
  
      text.sub!(old_template, result)
    end
    text
  end
end
