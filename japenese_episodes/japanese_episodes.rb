# encoding: utf-8


module Generic
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end
  
  def param_present(param)
    return !param.nil? 
  end
  
  def parse_text(text)
    text.force_encoding('UTF-8')
    templates = text.scan(/(?=\{\{\s*(?:Japanese episode list))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
    raise Helper::NoTemplatesFound if templates.empty?
    # raise Helper::UnresolvedCase.new('More than 1 template') if templates.size > 1

    templates.each do |template|
      # template = templates.first
      old_template = template.dup
  
      template.gsub!(/<!--[\w\W]*?-->/,'')
      # template.gsub!(/\{\{flag\|(.*)\}\}/,'[[\1]]')
      params = Helper.parse_template(template)
      params.default = nil

      # puts params.inspect
      # puts params.inspect
      # puts params['EpisodeNumber2'].nil?
      
      # ['KanjiTitle', 'RomajiTitle'].each do |param|
      #   raise Helper::UnresolvedCase.new(param) if (params[param] && !params[param].empty?)
      # end
      result = "{{Episode list"
      
      result += "\n| EpisodeNumber   = #{params['EpisodeNumber']}" unless (params['EpisodeNumber'].nil?||params['EpisodeNumber'].empty?)
      result += "\n| EpisodeNumber2  = #{params['EpisodeNumber2']}" unless params['EpisodeNumber2'].nil?
      result += "\n| Title           = #{params['EnglishTitle']}" unless params['EnglishTitle'].nil?
      result += "\n| AltTitle        = #{params['RomajiTitle']}" unless (params['RomajiTitle'].nil? || params['RomajiTitle'].empty?)
      result += "\n| RAltTitle       = #{"&nbsp;({{Nihongo2|#{params['KanjiTitle']}}})"}" unless (params['KanjiTitle'].nil? || params['KanjiTitle'].empty?)
      result += "\n| RTitle          = #{params['RTitle']}" unless params['RTitle'].nil?
      result += "\n| Aux1            = #{params['Aux1']}" unless params['Aux1'].nil?
      result += "\n| DirectedBy      = #{params['DirectedBy']}" unless params['DirectedBy'].nil?
      result += "\n| WrittenBy       = #{params['WrittenBy']}" unless params['WrittenBy'].nil?
      result += "\n| Aux2            = #{params['Aux2']}" unless params['Aux2'].nil?
      result += "\n| Aux3            = #{params['Aux3']}" unless params['Aux3'].nil?
      result += "\n| OriginalAirDate = #{params['OriginalAirDate']}" unless params['OriginalAirDate'].nil?
      result += "\n| AltDate         = #{params['FirstEngAirDate']}" unless params['FirstEngAirDate'].nil?
      result += "\n| ProdCode        = #{params['ProdCode']}" unless params['ProdCode'].nil?
      result += "\n| Aux4            = #{params['Aux4']}" unless params['Aux4'].nil?
      result += "\n| ShortSummary    = #{params['ShortSummary']}" unless params['ShortSummary'].nil?
      result += "\n| LineColor       = #{params['LineColor']}" unless params['LineColor'].nil?
      result += "\n| TopColor        = #{params['TopColor']}" unless params['TopColor'].nil?
      
      result += "\n}}"
      
      result.gsub!('<nowiki>', '')
      result.gsub!('</nowiki>', '')
  
      text.sub!(old_template, result)
    end
    text
  end
end
