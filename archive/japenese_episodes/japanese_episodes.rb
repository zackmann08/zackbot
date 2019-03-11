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
    templates = text.scan(/(?=\{\{\s*(?:Japanese episode list multi-part))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
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
      
      # space = (params['KanjiTitle'].nil? || params['KanjiTitle'].empty?) ? '' : '    '
      # result = "{{Episode list"
      # 
      # result += "\n| EpisodeNumber   #{space}= #{params['EpisodeNumber']}" unless params['EpisodeNumber'].nil?
      # result += "\n| EpisodeNumber2  #{space}= #{params['EpisodeNumber2']}" unless params['EpisodeNumber2'].nil?
      # result += "\n| Title           #{space}= #{params['EnglishTitle']}" unless params['EnglishTitle'].nil?
      # result += "\n| TranslitTitle   #{space}= #{params['RomajiTitle']}" unless (params['RomajiTitle'].nil? || params['RomajiTitle'].empty?)
      # result += "\n| NativeTitle     #{space}= #{params['KanjiTitle']}" unless (params['KanjiTitle'].nil? || params['KanjiTitle'].empty?)
      # result += "\n| NativeTitleLangCode = ja " unless (params['KanjiTitle'].nil? || params['KanjiTitle'].empty?)
      # result += "\n| RTitle          #{space}= #{params['RTitle']}" unless params['RTitle'].nil?
      # result += "\n| Aux1            #{space}= #{params['Aux1']}" unless params['Aux1'].nil?
      # result += "\n| DirectedBy      #{space}= #{params['DirectedBy']}" unless params['DirectedBy'].nil?
      # result += "\n| WrittenBy       #{space}= #{params['WrittenBy']}" unless params['WrittenBy'].nil?
      # result += "\n| Aux2            #{space}= #{params['Aux2']}" unless params['Aux2'].nil?
      # result += "\n| Aux3            #{space}= #{params['Aux3']}" unless params['Aux3'].nil?
      # result += "\n| OriginalAirDate #{space}= #{params['OriginalAirDate']}" unless params['OriginalAirDate'].nil?
      # result += "\n| AltDate         #{space}= #{params['FirstEngAirDate']}" unless params['FirstEngAirDate'].nil?
      # result += "\n| ProdCode        #{space}= #{params['ProdCode']}" unless params['ProdCode'].nil?
      # result += "\n| Aux4            #{space}= #{params['Aux4']}" unless params['Aux4'].nil?
      # result += "\n| ShortSummary    #{space}= #{params['ShortSummary']}" unless params['ShortSummary'].nil?
      # result += "\n| LineColor       #{space}= #{params['LineColor']}" unless params['LineColor'].nil?
      # result += "\n| TopColor        #{space}= #{params['TopColor']}" unless params['TopColor'].nil?
      # 
      # result += "\n}}"

      raise Helper::UnresolvedCase.new('More than 5 parts') if params['NumParts'].to_i > 6
      
      space = (params['KanjiTitle'].nil? || params['KanjiTitle'].empty?) ? '' : '    '
      result = "{{Episode list"
      result += "\n| EpisodeNumber       = #{params['EpisodeNumber']}" unless params['EpisodeNumber'].nil?
      result += "\n| EpisodeNumber2      = #{params['EpisodeNumber2']}" unless params['EpisodeNumber2'].nil?
      result += "\n| NumParts            = #{params['NumParts'] || '1'}"
      result += "\n| Title_1             = #{params['EnglishTitle']}" unless params['EnglishTitle'].nil?
      result += "\n| TranslitTitle_1     = #{params['RomajiTitle']}" unless (params['RomajiTitle'].nil? || params['RomajiTitle'].empty?)
      result += "\n| NativeTitle_1       = #{params['KanjiTitle']}" unless (params['KanjiTitle'].nil? || params['KanjiTitle'].empty?)
      result += "\n| Title_1             = #{params['EnglishTitleA']}" unless params['EnglishTitleA'].nil?
      result += "\n| TranslitTitle_1     = #{params['RomajiTitleA']}" unless (params['RomajiTitleA'].nil? || params['RomajiTitleA'].empty?)
      result += "\n| NativeTitle_1       = #{params['KanjiTitleA']}" unless (params['KanjiTitleA'].nil? || params['KanjiTitleA'].empty?)
      result += "\n| Title_2             = #{params['EnglishTitleB']}" unless params['EnglishTitleB'].nil?
      result += "\n| TranslitTitle_2     = #{params['RomajiTitleB']}" unless (params['RomajiTitleB'].nil? || params['RomajiTitleB'].empty?)
      result += "\n| NativeTitle_2       = #{params['KanjiTitleB']}" unless (params['KanjiTitleB'].nil? || params['KanjiTitleB'].empty?)
      result += "\n| Title_3             = #{params['EnglishTitleC']}" unless params['EnglishTitleC'].nil?
      result += "\n| TranslitTitle_3     = #{params['RomajiTitleC']}" unless (params['RomajiTitleC'].nil? || params['RomajiTitleC'].empty?)
      result += "\n| NativeTitle_3       = #{params['KanjiTitleC']}" unless (params['KanjiTitleC'].nil? || params['KanjiTitleC'].empty?)
      result += "\n| Title_4             = #{params['EnglishTitleD']}" unless params['EnglishTitleD'].nil?
      result += "\n| TranslitTitle_4     = #{params['RomajiTitleD']}" unless (params['RomajiTitleD'].nil? || params['RomajiTitleD'].empty?)
      result += "\n| NativeTitle_4       = #{params['KanjiTitleD']}" unless (params['KanjiTitleD'].nil? || params['KanjiTitleD'].empty?)
      result += "\n| Title_5             = #{params['EnglishTitleE']}" unless params['EnglishTitleE'].nil?
      result += "\n| TranslitTitle_5     = #{params['RomajiTitleE']}" unless (params['RomajiTitleE'].nil? || params['RomajiTitleE'].empty?)
      result += "\n| NativeTitle_5       = #{params['KanjiTitleE']}" unless (params['KanjiTitleE'].nil? || params['KanjiTitleE'].empty?)
      result += "\n| Title_6             = #{params['EnglishTitleF']}" unless params['EnglishTitleF'].nil?
      result += "\n| TranslitTitle_6     = #{params['RomajiTitleF']}" unless (params['RomajiTitleF'].nil? || params['RomajiTitleF'].empty?)
      result += "\n| NativeTitle_6       = #{params['KanjiTitleF']}" unless (params['KanjiTitleF'].nil? || params['KanjiTitleF'].empty?)
      result += "\n| NativeTitleLangCode = ja " unless (params['KanjiTitle'].nil? || params['KanjiTitle'].empty?)
      result += "\n| NativeTitleLangCode = ja " unless (params['KanjiTitleA'].nil? || params['KanjiTitleA'].empty?)
      result += "\n| RTitle              = #{params['RTitle']}" unless params['RTitle'].nil?
      result += "\n| Aux1                = #{params['Aux1']}" unless params['Aux1'].nil?
      result += "\n| DirectedBy          = #{params['DirectedBy']}" unless params['DirectedBy'].nil?
      result += "\n| WrittenBy           = #{params['WrittenBy']}" unless params['WrittenBy'].nil?
      result += "\n| Aux2                = #{params['Aux2']}" unless params['Aux2'].nil?
      result += "\n| Aux3                = #{params['Aux3']}" unless params['Aux3'].nil?
      result += "\n| OriginalAirDate     = #{params['OriginalAirDate']}" unless params['OriginalAirDate'].nil?
      result += "\n| AltDate             = #{params['FirstEngAirDate']}" unless params['FirstEngAirDate'].nil?
      result += "\n| ProdCode            = #{params['ProdCode']}" unless params['ProdCode'].nil?
      result += "\n| Aux4                = #{params['Aux4']}" unless params['Aux4'].nil?
      result += "\n| ShortSummary        = #{params['ShortSummary']}" unless params['ShortSummary'].nil?
      result += "\n| LineColor           = #{params['LineColor']}" unless params['LineColor'].nil?
      result += "\n| TopColor            = #{params['TopColor']}" unless params['TopColor'].nil?
      
      result += "\n}}"
      
      result.gsub!('<nowiki>', '')
      result.gsub!('</nowiki>', '')
  
      text.sub!(old_template, result)
    end
    text.gsub!(/\s*table-layout\s*:\s*fixed\s*;/i, '')
    text
  end
end
