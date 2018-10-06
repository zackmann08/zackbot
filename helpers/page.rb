class Page
  attr_accessor :raw_text
  
  def initialize(text)
    @raw_text = text
  end
  
  def get_templates(template)
    @raw_text.scan(/(?=\{\{(?:#{template.to_s}))(\{\{(?>[^{}]++|\g<1>)*}})/).flatten
  end
  
end