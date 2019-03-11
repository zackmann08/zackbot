# encoding: utf-8


module Generic
  class UnresolvedCase < StandardError
    def initialize(message = '??')
      super("Unresolved case: '#{message}'")
    end
  end
  class NoTemplatesFound < StandardError; end

  def autolink(value)
    return '' if value.nil? || value.empty?
    return value if (value.include?('[[') || value.include?('{{'))
    "{{subst:#ifexist:#{value}|[[#{value}]]|#{value}}}"
  end
  
  def parse_text(text)
    text.force_encoding('UTF-8')
    templates = text.scan(/(?=\{\{\s*(?:Infobox playwright))(\{\{(?>[^{}]++|\g<1>)*}})/i).flatten
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
      
      raise ('Need to add additional params')
      
      result = "{{Infobox online service
|name                 = 
|title                = #{params['name']||params['service_name']}
|logo                 = #{params['logo']||params['service_logo']}
|logo_size            = #{params['logo size']||params['logo_size']}
|logo_alt             = #{params['logo alt']||params['logo_alt']}
|logo caption         = #{params['logo caption']}
|image                = #{params['screenshot']||params['service_screenshot']}
|image_size           = #{params['screenshot size']||params['screenshot_size']}
|image_alt            = #{params['screenshot alt']||params['screenshot_alt']}
|caption              = #{params['alt']}
|developer            = #{params['owner']||params['owners']||params['autor']||params['creator']||params['authors']||params['creators']}
|type                 = Music
|launched             = #{params['opened']}
|discontinued         = #{params['discontinued']}
|version              =
|version release date =
|preview version      = #{params['preview']}
|updated              =
|operating system     = #{params['platforms']}
|status               =
|members              =
|website              = #{params['website']}
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
