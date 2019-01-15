# encoding: utf-8


module Generic
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end
  
  def parse_extra_areas(params)
    result = ''
    if params['park'] || params['coordinates'] || params['status'] || params['opened'] || params['closed'] || params['previousattraction'] || params['replaced'] || params['replacement']
      result += "\n<!--   Park 1   -->
| park1           = #{params['park']}
| coordinates1    = #{params['coordinates']}
| status1         = #{params['status']}
| opened1         = #{params['opened']}
| closed1         = #{params['closed']}
| replaced1       = #{params['previousattraction'] || params['replaced']}
| replacement1    = #{params['replacement']}"
    end
    if params['park2'] || params['coordinates2'] || params['status2'] || params['opened2'] || params['closed2'] || params['previousattraction2'] || params['replaced2'] || params['replacement2']
      result += "\n<!--   Park 2   -->
| park2           = #{params['park2']}
| coordinates2    = #{params['coordinates2']}
| status2         = #{params['status2'] || params['Status2']}
| opened2         = #{params['opened2']}
| closed2         = #{params['closed2']}
| replaced2       = #{params['previousattraction2'] || params['replaced2']}
| replacement2    = #{params['replacement2']}"
    end
    if params['park3'] || params['coordinates3'] || params['status3'] || params['opened3'] || params['closed3'] || params['previousattraction3'] || params['replaced3'] || params['replacement3']
      result += "\n<!--   Park 3   -->
| park3           = #{params['park3']}
| coordinates3    = #{params['coordinates3']}
| status3         = #{params['status3'] || params['Status3']}
| opened3         = #{params['opened3']}
| closed3         = #{params['closed3']}
| replaced3       = #{params['previousattraction3'] || params['replaced3']}
| replacement3    = #{params['replacement3']}"
    end

    if params['park4'] || params['coordinates4'] || params['status4'] || params['opened4'] || params['closed4'] || params['previousattraction4'] || params['replaced4'] || params['replacement4']
      result += "\n<!--   Park 4   -->
| park4           = #{params['park4']}
| coordinates4    = #{params['coordinates4']}
| status4         = #{params['status4'] || params['Status4']}
| opened4         = #{params['opened4']}
| closed4         = #{params['closed4']}
| replaced4       = #{params['previousattraction4'] || params['replaced4']}
| replacement4    = #{params['replacement4']}"
    end

    if params['park5'] || params['coordinates5'] || params['status5'] || params['opened5'] || params['closed5'] || params['previousattraction5'] || params['replaced5'] || params['replacement5']
      result += "\n<!--   Park 5   -->
| park5           = #{params['park5']}
| coordinates5    = #{params['coordinates5']}
| status5         = #{params['status5'] || params['Status5']}
| opened5         = #{params['opened5']}
| closed5         = #{params['closed5']}
| replaced5       = #{params['previousattraction5'] || params['replaced5']}
| replacement5    = #{params['replacement5']}"
    end

    if params['park6'] || params['coordinates6'] || params['status6'] || params['opened6'] || params['closed6'] || params['previousattraction6'] || params['replaced6'] || params['replacement6']
      result += "\n<!--   Park 6   -->
| park6           = #{params['park6']}
| coordinates6    = #{params['coordinates6']}
| status6         = #{params['status6'] || params['Status6']}
| opened6         = #{params['opened6']}
| closed6         = #{params['closed6']}
| replaced6       = #{params['previousattraction6'] || params['replaced6']}
| replacement6    = #{params['replacement6']}"
    end
    result
  end
  
  def parse_text(text)
    text.force_encoding('UTF-8')
    templates = text.scan(/(?=\{\{\s*(?:Infobox themed area))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
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
      
      # ['KanjiTitle', 'RomajiTitle'].each do |param|
      #   raise Helper::UnresolvedCase.new(param) if (params[param] && !params[param].empty?)
      # end
      
      
      result = "{{Infobox amusement park
| name            = #{params['name']}
| logo            = #{params['logo']}
| logo_size       = #{params['logo_width']}
| image           = #{params['image']}
| image_size      = #{params['image_width']}
| caption         = #{params['caption']}
<!-- General Information -->
| theme           = #{params['theme']}
| area            = #{params['area']}
| area_ha         = #{params['area_ha']}
| area_acre       = #{params['area_acre']}
| rides           = #{params['attractions']}
| coasters        = #{params['coasters']}
| water_rides     = #{params['water_rides']}
| other_rides     = #{params['rides']}
| shows           = #{params['shows']}#{parse_extra_areas(params)}
}}"
      
      result.gsub!('<nowiki>', '')
      result.gsub!('</nowiki>', '')
      
      # This will strip un-used parmeters
      # result.gsub!(/\|.*\=\s*\n/, '')
  
      text.sub!(old_template, result)
    end
    text
  end
end
